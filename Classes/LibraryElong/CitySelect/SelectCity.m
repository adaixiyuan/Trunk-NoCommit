//
//  SearchBarViewController.m
//  SearchBar
//
//  Created by bin xing on 11-1-11.
//  Copyright 2011 DP. All rights reserved.
//

#import "SelectCity.h"
#import "selectCityCell.h"
#import "HotelKeywordListRequest.h"
#import "HotelSearch.h"
#import "FlightSearch.h"
#import "InterHotelCityRequest.h"
#import "InterHotelSearcher.h"
#import "InterHotelDefine.h"
#import "SearchBarView.h"
#import "HotelCityUpdater.h"

#define INTER_HOTEL_PLACEHOLDER     @"请输入国际城市名(中/英文)，如:巴黎"
#define NATIVE_HOTEL_PLACEHOLDER    @"城市名"

@interface SelectCity ()

@property (nonatomic, assign) BOOL isSave;
@property (nonatomic, retain) UITableView *defaultTableView;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) NSArray *sectionTitleArray;		// 每个section的title
@property (nonatomic, copy) NSString *placeHolder;              // 搜索栏占位符

@end

@implementation SelectCity

@synthesize searchDisplayController = searchDisplayController;
@synthesize cityDelegate = _cityDelegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SFRelease(_cityDelegate);
    [loadingSuperView removeFromSuperview];
	[_sectionTitleArray release];
    [_placeHolder release];
    [topView release];
    [footView release];
	
	[sectionArray release];
	[filteredListContent release];
	[_defaultTableView release];
	[_selectedCity release];
	[searchDisplayController release];
	
	[super dealloc];
}

- (void)back
{
    if((_cityDelegate != nil) && ([_cityDelegate respondsToSelector:@selector(selectCityBack:)] == YES))
    {
        [_cityDelegate selectCityBack:nil];
    }
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)getCountTotal
{
	int j = 0;
	for (int i = 0; i < [sectionArray count] - 1; i++) {
		j += [[sectionArray safeObjectAtIndex:i] count];
	}
}

- (void)createSectionList:(NSString *)filename
{
    [sectionArray removeAllObjects];
    
	NSString *plistPath = nil;
    //国内酒店需要从cityUpdater中获取
    if (cityType==SelectCityTypeHotel&&isInterHotel==NO)
    {
        plistPath=[HotelCityUpdater getCityListPlistName:filename];
    }
    else
    {
        plistPath=[[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    }
    
    if (cityType == SelectCityTypeTrainDepart || cityType == SelectCityTypeTrainArrive)
    {
        // 获取document文件夹位置
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        // 文件路径名
        NSString *fileFullname = [NSString stringWithFormat:@"%@.plist",filename];
        plistPath = [path stringByAppendingPathComponent:fileFullname];   //获取路径
    }
    
	NSDictionary *dict = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
    if (!DICTIONARYHASVALUE(dict))
    {
        //酒店防止，有路径，找不到文件的问题出现（never go here）,再读取一遍，从最基础版本的城市列表
        if (cityType==SelectCityTypeHotel)
        {
            plistPath=[[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
            dict = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] autorelease];
            if (!DICTIONARYHASVALUE(dict))
            {
                return;
            }
        }
        else
        {
            return;
        }
    }
	
	NSArray *allkeys=[dict allKeys];
	int count = [allkeys count];
    
	for (int i = 0; i < count; i++)
	{
		NSMutableArray *ma=[[[NSMutableArray alloc] init] autorelease];
		[sectionArray addObject:ma];
	}
    
    NSInteger sectionIndex = 0;
    NSMutableArray *arraySectionTitleTmp = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[_sectionTitleArray count]; i++)
	{
        NSString *sectionKey = [_sectionTitleArray safeObjectAtIndex:i];
        
		NSArray *citys = [dict safeObjectForKey:sectionKey];
        
        if ([citys count] > 0)
        {
            for (NSArray *city in citys)
            {
                [[sectionArray safeObjectAtIndex:sectionIndex] addObject:city];
            }
            sectionIndex++;
            
            [arraySectionTitleTmp addObject:sectionKey];
        }
	}
    
    NSUserDefaults* historyDefaults = [NSUserDefaults standardUserDefaults];
    // 列车历史城市
    NSMutableArray *arrayHistoryCity = [[[NSMutableArray alloc] init] autorelease];
    if (cityType == SelectCityTypeTrainDepart)
    {
        arrayHistoryCity = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_TRAIN_DEPARTCITYNAME];
    }
    else if (cityType == SelectCityTypeTrainArrive)
    {
        arrayHistoryCity = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_TRAIN_ARRIVALCITYNAME];
    }
    // 酒店历史城市
    NSArray *historyCities = [historyDefaults objectForKey:History_Cities];
    if((m_searchCityName && !isInterHotel) ||           // 国内酒店判断是否有历史搜索
       (ARRAYHASVALUE(historyCities) && isInterHotel) ||    // 国际酒店判断
       (arrayHistoryCity != nil && [arrayHistoryCity count] > 0))   // 列车历史城市
    {
        NSMutableArray *ma=[[[NSMutableArray alloc] init] autorelease];
		[sectionArray insertObject:ma atIndex:0];
        //
        [arraySectionTitleTmp insertObject:[_sectionTitleArray objectAtIndex:0] atIndex:0];
    }
    
    // 保存sectionTitle
    [self setSectionTitleArray:arraySectionTitleTmp];
    [arraySectionTitleTmp release];
    
    
    if (isInterHotel) {
        // 取出国际酒店搜索纪录(多条)
        if (ARRAYHASVALUE(historyCities)) {
            for (NSDictionary *cityDic in historyCities) {
                if (DICTIONARYHASVALUE(cityDic)) {
                    NSString *cityDescription = [[cityDic safeObjectForKey:Description_CityList_InterHotel] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                    NSString *cityDestID = [cityDic safeObjectForKey:DESTINATION_CITYLIST_INTERHOTEL];
                    
                    // 当前位置
                    NSString *cityNameCN = [[cityDic safeObjectForKey:Cnname_CityList_InterHotel] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                    if (![cityNameCN isEqualToString:@"当前位置"])
                    {
                        NSArray *searchhistory = [NSArray arrayWithObjects:cityDescription,@"",cityDestID,nil];
                        [[sectionArray safeObjectAtIndex:0] addObject:searchhistory];
                    }
                }
            }
        }
    }
    else {
        // 取出国内酒店搜索纪录（单条）
        if(m_searchCityName)
        {
            //搜索历史的array
            NSArray *searchhistory = [NSArray arrayWithObjects:m_searchCityName,@"",@"",nil];
            [[sectionArray safeObjectAtIndex:0] addObject:searchhistory];
        }
        
    }
    
    if (cityType == SelectCityTypeHotel)
    {
        // 增加当前位置
        NSMutableArray *sectionTitleArrayTmp = [NSMutableArray arrayWithArray:self.sectionTitleArray];
        [sectionTitleArrayTmp insertObject:@"当前位置" atIndex:0];
        self.sectionTitleArray = [NSArray arrayWithArray:sectionTitleArrayTmp];
        
        NSMutableArray *arrayCurrLocation = [[NSMutableArray alloc] init];
        NSArray *currLocation = [NSArray arrayWithObjects:@"当前位置",@"",@"",nil];
        [arrayCurrLocation addObject:currLocation];
        [sectionArray insertObject:arrayCurrLocation atIndex:0];
        [arrayCurrLocation release];
    }
    
    // 取出列车历史城市
    if (arrayHistoryCity != nil && [arrayHistoryCity count] > 0)
    {
        [sectionArray replaceObjectAtIndex:0 withObject:arrayHistoryCity];
    }
	
	[self getCountTotal];	// 获取列表总数
}

-(id)init:(NSString *)name style:(NavBtnStyle)style citylable:(id)citylable cityType:(SelectCityType)type isSave:(BOOL)isSave
{
    cityType = type;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshByNoti:) name:NOTI_INTERCITY_SUGGEST object:nil];
    
    BOOL hasHistory = NO;
    
    
    if (SelectCityTypeHotel == type) {
        
        m_searchCityName = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_HOTEL_SEARCHCITYNAME];
    }
    else if (SelectCityTypeFlight == type) {
        if ([name isEqualToString:@"出发城市"]) {
            m_searchCityName = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_FLIGHT_DEPARTCITYNAME];
        }
        if ([name isEqualToString:@"到达城市"]) {
            m_searchCityName = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_FLIGHT_ARRIVALCITYNAME];
        }
    }
    else if (type == SelectCityTypeTrainDepart)
    {
        NSMutableArray *arrayHistoryCity = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_TRAIN_DEPARTCITYNAME];
        
        if (arrayHistoryCity != nil && [arrayHistoryCity count] > 0)
        {
            hasHistory = YES;
        }
    }
    else if (type == SelectCityTypeTrainArrive)
    {
        NSMutableArray *arrayHistoryCity = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_TRAIN_ARRIVALCITYNAME];
        
        if (arrayHistoryCity != nil && [arrayHistoryCity count] > 0)
        {
            hasHistory = YES;
        }
    }
    // 航班动态出发地
    else if (type == SelectCityTypeFStatusDepart)
    {
        m_searchCityName = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_FLIGHTSTATUS_DEPARTCITYNAME];
    }
    // 航班动态到达地
    else if (type == SelectCityTypeFStatusArrive)
    {
        m_searchCityName = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFUALT_FLIGHTSTATUS_ARRIVALCITYNAME];
    }
    
    //搜索历史
    if (m_searchCityName || hasHistory)
    {
        self.sectionTitleArray = [NSArray arrayWithObjects: @"历史",@"热门",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N",@"P", @"Q", @"R", @"S",@"T", @"W", @"X", @"Y", @"Z", nil];
    }
    else
    {
        self.sectionTitleArray = [NSArray arrayWithObjects: @"热门",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N",@"P", @"Q", @"R", @"S",@"T", @"W", @"X", @"Y", @"Z", nil];
        
    }
    
    
    NSString *filename = nil;
    switch (type) {
        case SelectCityTypeHotel:
            filename = @"hotelcity";
            break;
        case SelectCityTypeFlight:
            filename = @"flightcity";
            break;
        case SelectCityTypeTrainDepart:
            filename = @"railwaycity";
            break;
        case SelectCityTypeTrainArrive:
            filename = @"railwaycity";
            break;
        case SelectCityTypeFStatusDepart:
            filename = @"flightonline";
            break;
        case SelectCityTypeFStatusArrive:
            filename = @"flightonline";
            break;
        default:
            break;
    }
    filteredListContent = [[NSMutableArray alloc] init];
    sectionArray = [[NSMutableArray alloc] init];
    [self createSectionList:filename];

	if (self = [super initWithTopImagePath:nil andTitle:name style:style])
    {
		isSave = isSave;
		self.resultlabel = citylable;
        
		if([name isEqualToString:@"出发站"]||[name isEqualToString:@"到达站"]||[name isEqualToString:@"车站查询"])
        {
            self.placeHolder = @"请输入车站名";
		}
        else {
            self.placeHolder = NATIVE_HOTEL_PLACEHOLDER;
        }
        
        self.searchDisplayController.searchBar.placeholder = _placeHolder;
        
        if (type == SelectCityTypeHotel) {
            // 如果是酒店列表页，增加国际和国内酒店切换功能
            [self addSwitchItem];
            
        }
	}
    
	return self;
}

// 添加顶部的切换栏
- (void)addSwitchItem {
    //增加国内酒店以及国际酒店选项
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    topView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:topView];
    
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"国内(含港澳台)", @"国际", nil];
    _hotelSeg = [[CustomSegmented alloc] initSegmentedWithFrame:CGRectMake(10, 8, 300, 29) titles:titleArray normalIcons:nil highlightIcons:nil];
    
    _hotelSeg.delegate = self;
    _hotelSeg.selectedIndex = 0;
    [topView addSubview:_hotelSeg];
    [_hotelSeg release];
    
    // add newicon
    UIImageView *newNote = [[UIImageView alloc] initWithFrame:CGRectMake(278, 1, 37, 22)];
    newNote.image = [UIImage imageNamed:@"functionNew.png"];
    newNote.userInteractionEnabled = NO;
    [topView addSubview:newNote];
    [newNote release];
}


-(void)loadView
{
	[super loadView];
    
    
    NSInteger originY = 0;
    if (cityType == SelectCityTypeHotel)
    {
        originY = 44;
    }
    
    // to do
    
    UISearchBar *searchBar = [[SearchBarView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	searchBar.delegate = self;
	

    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                                                                  [UIColor blackColor],
//                                                                                                  UITextAttributeTextColor,
//                                                                                                  [UIColor whiteColor],
//                                                                                                  UITextAttributeTextShadowColor,
//                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
//                                                                                                  UITextAttributeTextShadowOffset,
//                                                                                                  nil]
//                                                                                        forState:UIControlStateNormal];
    
    
    // 创建列表
    CGFloat tableHeight = MAINCONTENTHEIGHT-44;
    if (cityType == SelectCityTypeHotel)
    {
        tableHeight -= 44;
    }
	self.defaultTableView = [[[UITableView alloc]
						initWithFrame:CGRectMake(0, originY + searchBar.frame.size.height, self.view.bounds.size.width, tableHeight)
						style:UITableViewStylePlain] autorelease];
	
	_defaultTableView.backgroundColor = [UIColor whiteColor];
	_defaultTableView.delegate=self;
	_defaultTableView.dataSource=self;
	_defaultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _defaultTableView.showsVerticalScrollIndicator = NO;
    if (IOSVersion_7) {
        _defaultTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        
     
    }
	
	
    self.searchDisplayController = [[[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self] autorelease];
    [searchDisplayController setDelegate:self];
    [searchDisplayController setSearchResultsDataSource:self];
    [searchDisplayController setSearchResultsDelegate:self];
	searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[searchBar release];
	
	[self.view addSubview:searchDisplayController.searchBar];
	[self.view addSubview:_defaultTableView];
    
    [self performSelector:@selector(layoutTableView) withObject:nil afterDelay:0.3];
   
}

- (void) layoutTableView{
    if (IOSVersion_7) {
        for (UIView *view in self.defaultTableView.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]) {
                if ([view respondsToSelector:@selector(setFont:)]) {
                    [view performSelector:@selector(setFont:) withObject:[UIFont boldSystemFontOfSize:11.0f]];
                    [self.defaultTableView reloadData];
                }
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isInterHotel = NO;
    
    FastPositioning *position = [FastPositioning shared];
    position.autoCancel = YES;
    [position fastPositioning];
}


// 跳转到上次选中的城市,有则跳转，没有就滚到顶部
- (void)scrollToLastCity {
    NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
    NSString *hotelLastSelectedCity = [dater objectForKey:kHotelLastSelectedCityKey];
    
    if (STRINGHASVALUE(hotelLastSelectedCity)) {
        if (isInterHotel) {
            for (NSArray *sections in sectionArray) {
                for (NSArray *city in sections) {
                    if ([[city lastObject] isEqual:hotelLastSelectedCity]) {
                        // 如果城市的id相同
                        int section = [sectionArray count] - 1;
                        int row = [[sectionArray lastObject] indexOfObject:city];
                        
                        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
                        [self.defaultTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                        return;
                    }
                }
            }
        }
        else {
            NSUInteger section = 0;
            if(m_searchCityName)
            {
                ++section;
            }
            
            for (; section < sectionArray.count; ++section)
            {
                NSArray *array = [sectionArray safeObjectAtIndex:section];
                NSUInteger row = 0;
                for (NSArray *city in array)
                {
                    NSString *cityId = [city lastObject];
                    
                    if ([hotelLastSelectedCity isEqualToString:cityId]) {
                        NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
                        [self.defaultTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                        return;
                    }
                    
                    ++row;
                }
            }
        }
    }
    
    [_defaultTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


// 选中国际酒店
- (void)selectInterHotel {
    isInterHotel = YES;
    
    // indexBar
    [_defaultTableView setViewWidth:self.view.frame.size.width];
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects: @"热门", nil];
    NSArray *historyCities = [[NSUserDefaults standardUserDefaults] objectForKey:History_Cities];
    if (ARRAYHASVALUE(historyCities)) {
        [titleArray insertObject:@"历史" atIndex:0];
    }
    self.sectionTitleArray = [NSArray arrayWithArray:titleArray];
    self.placeHolder = INTER_HOTEL_PLACEHOLDER;
    self.searchDisplayController.searchBar.placeholder = _placeHolder;

    [self createSectionList:@"InternalHotelCity"];
    [_defaultTableView reloadData];
    
    // 国际酒店加入下部提示栏
    if (!footView) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, SCREEN_WIDTH, 44)];
        
        UIButton *bgbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgbutton addTarget:searchDisplayController.searchBar action:@selector(becomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        [bgbutton setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
        bgbutton.frame = footView.bounds;
        [footView addSubview:bgbutton];
        
        UIImageView *penView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 13, 17, 17)];
        penView.image = [UIImage noCacheImageNamed:@"interCityPlus.png"];
        [footView addSubview:penView];
        [penView release];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, penView.frame.origin.y, 200, penView.frame.size.height)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"输入其它城市名称";
        titleLabel.textColor = COLOR_NAV_TITLE;
        [footView addSubview:titleLabel];
        [titleLabel release];
    }
    _defaultTableView.tableFooterView = footView;
    
    [self scrollToLastCity];
}


// 选中国内酒店
- (void)selectNativeHotel {
    isInterHotel = NO;
    
    NSMutableArray *titleArray = [NSMutableArray arrayWithObjects: @"热门",@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"J", @"K", @"L", @"M", @"N",@"P", @"Q", @"R", @"S",@"T", @"W", @"X", @"Y", @"Z", nil];
    
    if (m_searchCityName) {
        // 有搜索纪录,增加一项
        [titleArray insertObject:@"历史" atIndex:0];
    }
    self.sectionTitleArray = [NSArray arrayWithArray:titleArray];
    self.placeHolder = NATIVE_HOTEL_PLACEHOLDER;
    self.searchDisplayController.searchBar.placeholder = _placeHolder;
    
    [self createSectionList:@"hotelcity"];
    [_defaultTableView reloadData];
    
    // 隐藏下方文字框
//    _defaultTableView.frame = CGRectMake(0, 44, self.view.bounds.size.width, MAINCONTENTHEIGHT-44);
//    footView.hidden = YES;
    _defaultTableView.tableFooterView = nil;
    
    [self scrollToLastCity];
}

#pragma mark - customSegmented delegate

- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index{
    
    //切换，筛选数据清空
    [filteredListContent removeAllObjects];
    
    if (index == 0) {
        [self selectNativeHotel];
        [self layoutTableView];
    }
    else {
        [self selectInterHotel];
    }
}


#pragma mark -
#pragma mark UITableView
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (tableView == searchDisplayController.searchResultsTableView) {
		return nil;
	}
    
    NSString *title = [_sectionTitleArray safeObjectAtIndex:section];
    if ([title isEqualToString:@"历史"]) {
        return @"搜索历史";
    }else if([title isEqualToString:@"热门"]){
        return @"热门城市";
    }else{
        return title;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if (tableView == searchDisplayController.searchResultsTableView || isInterHotel) {
		return nil;
	}
    
    BOOL hasHistory = NO;
    // 列车历史城市
    NSMutableArray *arrayHistoryCity = [[[NSMutableArray alloc] init] autorelease];
    if (cityType == SelectCityTypeTrainDepart)
    {
        arrayHistoryCity = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_TRAIN_DEPARTCITYNAME];
    }
    else if (cityType == SelectCityTypeTrainArrive)
    {
        arrayHistoryCity = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_TRAIN_ARRIVALCITYNAME];
    }
    if (arrayHistoryCity != nil && [arrayHistoryCity count] > 0)
    {
        hasHistory = YES;
    }
    
    if (!m_searchCityName && !hasHistory) {
        return _sectionTitleArray;
    }
    else
    {
        NSMutableArray *temparray = [NSMutableArray arrayWithArray:_sectionTitleArray];
        [temparray replaceObjectAtIndex:0 withObject:@""];
        return temparray;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectCityCell";
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
    
	selectCityCell *cell = (selectCityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    
	if (tableView == searchDisplayController.searchResultsTableView) {
        if (cell == nil) {
            cell = [[[selectCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.isInterHotelType = isInterHotel;
        }
		NSString *city = nil;
        if (isInterHotel) {
            NSDictionary *interCity = [filteredListContent safeObjectAtIndex:row];
            if (DICTIONARYHASVALUE(interCity)) {
                NSString *sName = [interCity safeObjectForKey:Description_CityList_InterHotel];
                if (STRINGHASVALUE(sName)) {
                    city = [sName stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                }
            }
        }
        else {
            city = [[filteredListContent safeObjectAtIndex:row] safeObjectAtIndex:0];
        }
        
		cell.city_label.text= city;
	}
	else{
        if (cell == nil) {
            cell = [[[selectCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            
        }
        
        NSArray *citys = [[sectionArray safeObjectAtIndex:section] safeObjectAtIndex:row];
        NSString *city = nil;
        if (ARRAYHASVALUE(citys)) {
            city = [citys safeObjectAtIndex:0];
        }
        
        if ((cityType == SelectCityTypeHotel) && (section == 0) && (row == 0))
        {
            cell.gpsView.hidden = NO;
        }
        else
        {
            cell.gpsView.hidden = YES;
        }

        if ([city isEqualToString:@"当前位置"]) {
            PositioningManager *positionManager = [PositioningManager shared];
            city = [positionManager getAddressName];
            if (city == nil || [city isEqualToString:@""]) {
                city = @"尚未获取位置信息";
            }
        }
        cell.city_label.text = city;
        if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            cell.splitView.hidden = YES;
        }else{
            cell.splitView.hidden = NO;
        }
	}
	
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == searchDisplayController.searchResultsTableView) {
		return 0;
	}
    
    if ((cityType == SelectCityTypeHotel) && (section == 0))
    {
        // 当前位置
        return 24;
    }
    else
    {
        return 24;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (tableView == searchDisplayController.searchResultsTableView) {
		return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
	}
    
    UIView* mview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    mview.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    UILabel *headerview=[[UILabel alloc] initWithFrame:CGRectMake(17, 0, 220, 24)];
    headerview.backgroundColor=[UIColor clearColor];
    headerview.text= [self tableView:tableView titleForHeaderInSection:section];    //[NSString stringWithFormat:@"%@",[_sectionTitleArray safeObjectAtIndex:section]];
    headerview.font= FONT_B15;
    headerview.textColor =  RGBACOLOR(52, 52, 52, 1);
    headerview.textAlignment=UITextAlignmentLeft;
    [mview addSubview:headerview];
    [headerview release];
    
    return [mview autorelease];
    
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (tableView == searchDisplayController.searchResultsTableView) {
		return 1;
	}
	return [sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == searchDisplayController.searchResultsTableView) {
		return [filteredListContent count];
	}
	return [[sectionArray safeObjectAtIndex:section] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)([UIApplication sharedApplication]).delegate;
    appDelegate.window.backgroundColor = [UIColor blackColor];
    
	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	
    NSString *cityID = nil;     // 纪录国内/国际酒店的cityID
	HotelKeywordListRequest *req = [HotelKeywordListRequest shared];
	if (tableView == searchDisplayController.searchResultsTableView) {
        if (isInterHotel) {
            NSDictionary *interCity = [filteredListContent safeObjectAtIndex:row];
            if (DICTIONARYHASVALUE(interCity)) {
                NSString *sName = [interCity safeObjectForKey:Cnname_CityList_InterHotel];
                if (!STRINGHASVALUE(sName)) {
                    // 没有中文名就显示英文名
                    sName = [interCity safeObjectForKey:Ename_CityList_InterHotel];
                }
                self.selectedCity = [NSString stringWithFormat:@"%@", sName];
                
                InterHotelSearcher *searcher = [InterHotelSearcher shared];
                searcher.cityId = [NSString stringWithFormat:@"%@",[interCity safeObjectForKey:DESTINATION_CITYLIST_INTERHOTEL]];
                searcher.cityDescription = [NSString stringWithFormat:@"%@", [interCity safeObjectForKey:Description_CityList_InterHotel]];
                cityID = searcher.cityId;
                
                searcher.cityNameEn = [interCity safeObjectForKey:Ename_CityList_InterHotel];
            }
        }
        else {
            self.selectedCity = [[filteredListContent safeObjectAtIndex:row] safeObjectAtIndex:0];
            req.currentCityID = [[filteredListContent safeObjectAtIndex:row] lastObject];
            cityID = req.currentCityID;
        }
	}
    else {
        if (isInterHotel) {
            InterHotelSearcher *searcher = [InterHotelSearcher shared];
            selectCityCell *cell = (selectCityCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if ([sectionArray count] == 3 &&
                section == 1) {
                // 国际酒店点击历史搜索的情况,从历史里找出destinationID
                NSArray *historyCities = [[NSUserDefaults standardUserDefaults] objectForKey:History_Cities];
                searcher.cityId = [NSString stringWithFormat:@"%@",[[historyCities safeObjectAtIndex:row] safeObjectForKey:DESTINATION_CITYLIST_INTERHOTEL]];
                cityID = searcher.cityId;
                
                searcher.cityNameEn = [[historyCities safeObjectAtIndex:row] safeObjectForKey:Ename_CityList_InterHotel];
                searcher.cityDescription = cell.city_label.text;
                
                self.selectedCity = [[historyCities safeObjectAtIndex:row] safeObjectForKey:Cnname_CityList_InterHotel];
            }
            else if (section == 0)  // 当前位置
            {
                NSArray *cityArray = [[sectionArray safeObjectAtIndex:section] safeObjectAtIndex:row];
                self.selectedCity = [cityArray safeObjectAtIndex:0];
            }
            else
            {
                // 否则，从本地找destinationID
                NSArray *cityArray = [[sectionArray safeObjectAtIndex:section] safeObjectAtIndex:row];
                searcher.cityId = [cityArray lastObject];
                cityID = searcher.cityId;
                
                searcher.cityNameEn = [cityArray safeObjectAtIndex:4];
                searcher.cityDescription = cell.city_label.text;
                
                self.selectedCity = [cityArray safeObjectAtIndex:1];
            }
        }
        else {
            self.selectedCity = [[[sectionArray safeObjectAtIndex:section] safeObjectAtIndex:row] safeObjectAtIndex:0];
            req.currentCityID = [[[sectionArray safeObjectAtIndex:section] safeObjectAtIndex:row] lastObject];
            cityID = req.currentCityID;
        }
	}
	
	if ([_resultlabel isKindOfClass:[UITextField class]]) {
        ((UITextField *)_resultlabel).text = _selectedCity;
	}else {
		((UILabel *)_resultlabel).text = _selectedCity;
		if (_isSave) {
			[[SettingManager instanse] setDepartCity:_selectedCity];
		}
	}
    
    if (cityType == SelectCityTypeHotel) {
        NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
        [dater setValue:cityID forKey:kHotelLastSelectedCityKey];
    }
    
    // 代理回调
    if((_cityDelegate != nil) && ([_cityDelegate respondsToSelector:@selector(selectCityBack:)] == YES))
    {
        [_cityDelegate selectCityBack:_selectedCity];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELCITY_TYPE object:[NSNumber numberWithBool:isInterHotel]];      
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText
{
	[filteredListContent removeAllObjects];
	
	if (searchText==nil||[searchText isEqualToString:@""])
    {
		return;
	}
    
    int first = 0;
	for (NSArray *array in sectionArray)
    {
        if (first==0) {
			first ++ ;
			continue;
		}
        
		for (NSArray *city in array)
        {
			NSComparisonResult result = [[city safeObjectAtIndex:0] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			NSComparisonResult result1 = [[city safeObjectAtIndex:1] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			NSComparisonResult result2 = [[city safeObjectAtIndex:2] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            
			if (result == NSOrderedSame || result1 == NSOrderedSame || result2 == NSOrderedSame)
			{
				[filteredListContent addObject:city];
            }
			
			// 香港、澳门等特殊城市，需要多加英文名
			if ([city count] > 4 && (cityType != SelectCityTypeFStatusDepart && cityType != SelectCityTypeFStatusArrive))
            {
				NSComparisonResult result3 = [[city safeObjectAtIndex:3] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				NSComparisonResult result4 = [[city safeObjectAtIndex:4] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				if (result3 == NSOrderedSame || result4 == NSOrderedSame)
                {
					[filteredListContent addObject:city];
				}
			}
		}
	}
    
    // 去重复
    NSMutableArray *arrayFilteResult = [NSMutableArray array];
//    for (unsigned i = 0; i < [filteredListContent count]; i++){
//        if ([arrayFilteResult containsObject:[filteredListContent objectAtIndex:i]] == NO){
//            [arrayFilteResult addObject:[filteredListContent objectAtIndex:i]];
//        }
//    }
    
    for (int i=0; i<filteredListContent.count; i++)
    {
        NSString *cityName = [[filteredListContent safeObjectAtIndex:i] safeObjectAtIndex:0];
        BOOL isExsit = NO;
        for (int j=0; j<arrayFilteResult.count; j++)
        {
            NSString *temCityName = [[arrayFilteResult safeObjectAtIndex:j] safeObjectAtIndex:0];
            
            if ([cityName isEqualToString:temCityName])
            {
                isExsit = YES;
                break;
            }
        }
        
        if (!isExsit)
        {
            [arrayFilteResult addObject:[filteredListContent objectAtIndex:i]];
        }
    }
    
    // 保存
    [filteredListContent setArray:arrayFilteResult];
    
}

// 获取国际酒店城市返回通知，对比搜索关键字和当前关键字
- (void)refreshByNoti:(NSNotification *)noti {
	NSString *keyword = (NSString *)[noti object];
    NSString *searchWord = [self.searchDisplayController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
	if ([keyword isEqualToString:searchWord]) {
		// 如果是当前正在搜索的关键字，则对列表进行刷新
		[self refreshInterCityListByKeyword:keyword];
	}
}

- (void)refreshInterCityListByKeyword:(NSString *)key {
    if (self.searchDisplayController.searchBar.text.length == 0) {
        // 按searchbar的叉号把文字都清空的情况
        [loadingView stopLoading];
        loadingSuperView.hidden = YES;
        return;
    }
    
	// 更新地址列表
	if (key) {
        InterHotelCityRequest *request = [InterHotelCityRequest shared];
		
        NSArray *addressArray = [request getAddressListByKeyword:[key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
		if ([addressArray isKindOfClass:[NSArray class]]) {
			// 已请求过的情况
            
			[filteredListContent setArray:addressArray];
            [self.searchDisplayController.searchResultsTableView reloadData];
            self.searchDisplayController.searchResultsTableView.scrollEnabled = YES;
            
            [loadingView stopLoading];
            loadingSuperView.hidden = YES;
		}
		else {
			// 未请求时，重新请求
			NSString *newkey =  [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[request requestForKeyword:newkey];
            [filteredListContent setArray:nil];
            
            if (!loadingView) {
                ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
                loadingSuperView = [[UIView alloc] initWithFrame:CGRectMake(100, 130, 120, 100)];
                loadingSuperView.backgroundColor = [UIColor whiteColor];
                [appDelegate.window addSubview:loadingSuperView];
                [loadingSuperView release];
                
                loadingView = [[SmallLoadingView alloc] initWithFrame:CGRectMake(35, 25, 50, 50)];
                [loadingSuperView addSubview:loadingView];
                [loadingView release];
            }
            
            self.searchDisplayController.searchResultsTableView.scrollEnabled = NO;
            [loadingView startLoading];
            loadingSuperView.hidden = NO;
		}
	}
}

#pragma mark - indexBar Delegate
- (void)tableViewIndexBar:(AIMTableViewIndexBar *)indexBar didSelectSectionAtIndex:(NSInteger)index
{
    if ([self.defaultTableView numberOfSections] > index && index > -1){   // 校验
        [self.defaultTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
    }
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (isInterHotel) {
        // 国际酒店走api搜索
        [self refreshInterCityListByKeyword:searchString];
    }
    else {
        // 其它走本地搜索
        [self filterContentForSearchText:searchString];
    }
    
    return YES;
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)([UIApplication sharedApplication]).delegate;
    appDelegate.window.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    
    self.searchDisplayController.searchBar.placeholder = @"";
    [self.searchDisplayController.searchResultsTableView reloadData];
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    self.searchDisplayController.searchBar.placeholder = _placeHolder;
    if (!loadingSuperView.hidden) {
        [loadingView stopLoading];
        loadingSuperView.hidden = YES;
    }    
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)([UIApplication sharedApplication]).delegate;
    appDelegate.window.backgroundColor = [UIColor blackColor];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    //tableView.frame = CGRectMake(0, 44, 320, MAINCONTENTHEIGHT);
	searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    //tableView.frame = CGRectMake(0, 44, 320, MAINCONTENTHEIGHT);

}

#pragma mark UISearchBar delegate methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (isInterHotel) {
        // 正在搜索时，不执行任何操作
        if (loadingSuperView.hidden) {
            // 国际酒店，默认选中第一栏文字，如果没有，提示错误
            if (ARRAYHASVALUE(filteredListContent)) {
                NSDictionary *interCity = [filteredListContent safeObjectAtIndex:0];
                if (DICTIONARYHASVALUE(interCity)) {
                    NSString *cnName = [interCity safeObjectForKey:Cnname_CityList_InterHotel];   // 国际酒店中文名字段
                    if (!STRINGHASVALUE(cnName)) {
                        // 没有中文名就显示英文名
                        cnName = [interCity safeObjectForKey:Ename_CityList_InterHotel];
                    }
                    
                    self.selectedCity = [NSString stringWithFormat:@"%@", cnName];
                    InterHotelSearcher *searcher = [InterHotelSearcher shared];
                    searcher.cityId = [NSString stringWithFormat:@"%@",[interCity safeObjectForKey:DESTINATION_CITYLIST_INTERHOTEL]];
                    searcher.cityDescription = [NSString stringWithFormat:@"%@",[interCity safeObjectForKey:Description_CityList_InterHotel]];
                    searcher.cityNameEn = [interCity safeObjectForKey:Ename_CityList_InterHotel];                    
                }
            }
            else {
                [PublicMethods showAlertTitle:@"对不起，未找到对应城市" Message:nil];
                return;
            }
        }
        else {
            return;
        }
    }
    else {
        if (cityType == SelectCityTypeFlight &&
            [searchBar.text isEqualToString:@"襄阳"])
        {
            searchBar.text = @"襄樊(襄阳)";     // 如果用户输入襄阳，强制改为这个名字
        }
        
        self.selectedCity = searchBar.text;
    }
    
    // 去除空格
    NSString *selectCityText = [self.selectedCity stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (STRINGHASVALUE(selectCityText))
    {
        // 判断是否有特殊字符或者数字
        if ([selectCityText checkCityNameValid])
        {
            // 保存
            self.selectedCity = selectCityText;
            
            if ([_resultlabel isKindOfClass:[UITextField class]]) {
                ((UITextField *)_resultlabel).text = _selectedCity;
            }else {
                ((UILabel *)_resultlabel).text = _selectedCity;
                if (_isSave) {
                    [[SettingManager instanse] setDepartCity:_selectedCity];
                }
            }
            
            // 代理回调
            if((_cityDelegate != nil) && ([_cityDelegate respondsToSelector:@selector(selectCityBack:)] == YES))
            {
                [_cityDelegate selectCityBack:_selectedCity];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELCITY_TYPE object:[NSNumber numberWithBool:isInterHotel]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [PublicMethods showAlertTitle:@"输入包含数字或特殊字符，请重新输入" Message:nil];
            return;
        }
        
    }
    else
    {
        [PublicMethods showAlertTitle:@"输入为空" Message:nil];
        return;
    }
    
	
}


@end
