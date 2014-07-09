//
//  HotelListMode.m
//  ElongClient
//
//  Created by bin xing on 11-1-4.
//  Modify by Dawn  on 2014.2.26
//  Copyright 2011 DP. All rights reserved.
//

#define HOTELDETAIL 1
#define kCountLabelTag		4111

#import "HotelListMode.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "HotelMapMode.h"
#import "HotelConditionRequest.h"
#import "TonightHotelListModeTableCell.h"
#import "TonightHotelListMode.h"
#import "HotelListCell.h"
#import "UnsignedHotelListCell.h"
#import "HotelListCellDataSource.h"
#import "HotelListCellAction.h"
#import "CountlyEventShow.h"
#import "CountlyEventHotelListPageHotelItem.h"
#import "HotelPromotionInfoRequest.h"

@interface HotelListMode (){
@private
    HotelListCellDataSource *cellDataSource;
    HotelListCellAction *cellAction;
}

@property (nonatomic, retain) NSArray *filterArray;     // 从api得到的联想数据
@property (nonatomic, copy) NSString *m_key;            // 搜索关键词


@end

@implementation HotelListMode

@synthesize tableFootView;
@synthesize listTableView;
@synthesize areaName;
@synthesize hotelCount;
@synthesize moreHotelReq;
@synthesize rootController;
@synthesize searchcontent;
@synthesize filterArray;
@synthesize m_key;
@synthesize keywordVC;
@synthesize selectIndexPath;

- (void)dealloc {
    
    self.rootController = nil;
	self.areaName = nil;
	self.listTableView = nil;
    self.searchcontent = nil;
    self.filterArray = nil;
    self.m_key = nil;
    self.selectIndexPath = nil;
	[tableFootView release];
    [moreHotelButton release];
    [moreHotelReq cancel];
    self.moreHotelReq = nil;
    [keywordVC release];
    [filterAdjustArray release];
    [cellDataSource release],cellDataSource = nil;
    [cellAction release],cellAction = nil;
    
    HttpUtil *httpUtil = [HttpUtil shared];
    if (httpUtil.delegate == self) {
        httpUtil.delegate = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.listTableView = nil;
	SFRelease(tableFootView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)init {
	if (self = [super init]) {
        // cell 数据源
        cellDataSource = [[HotelListCellDataSource alloc] init];
        cellAction = [[HotelListCellAction alloc] init];
        
        //清空所有的今日特价
        [[HotelSearch tonightHotels] removeAllObjects];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadTable:) name:NOTI_LONGVIP object:nil];
        
        self.moreHotelReq = nil;
        
        filterAdjustArray = [[NSMutableArray alloc] init];
        
        [self refreshTonight];
	}
	
	return self;
}

- (void)viewDidLoad {
    
    if (UMENG) {
        //酒店列表页面
        [MobClick event:Event_HotelList];
    }
    
    // countly hotelListPage
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_HOTELLISTPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
    
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT -20-44-40)];
	contentView.backgroundColor=[UIColor clearColor];
	contentView.clipsToBounds=YES;
	self.view=contentView;
	[contentView release];
	
	nullTipLabel					= [[UILabel alloc] initWithFrame:CGRectMake(50, 50 * COEFFICIENT_Y, 180, 40)];
	nullTipLabel.backgroundColor	= [UIColor clearColor];
	nullTipLabel.text				= @"未找到符合条件的酒店";
	nullTipLabel.textAlignment		= UITextAlignmentCenter;
    nullTipLabel.textColor          = RGBACOLOR(93, 93, 93, 1);
	nullTipLabel.font				= [UIFont boldSystemFontOfSize:16];
	nullTipLabel.center				= self.view.center;
	[self.view addSubview:nullTipLabel];
	[nullTipLabel release];
    
    if (!listTableView.superview) {
        if (!listTableView) {
            self.listTableView =[[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - 20 - 44 - 45) style:UITableViewStylePlain] autorelease];
            listTableView.delegate=self;
            listTableView.dataSource=self;
            listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            listTableView.rowHeight = 95;
            [self addTableHeaderView];
        }
        
        [self.view addSubview:listTableView];
    }
    
    
    // 搜索栏
    [self addSearchBar];
    
	hotelCount = [[HotelSearch hotels] count];
	if (hotelCount < [HotelSearch hotelCount]) {
		[self makeMoreLoadingView];
	}
	
	[self performSelector:@selector(refreshData) withObject:nil afterDelay:0.1];		// 防止更多按钮提前出现
}

#pragma mark -
#pragma mark Private Methods

// 重新计算当前模式否是应该按今日特价显示
- (void) refreshTonight{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    NSString *checkInDate = [hotelsearcher getCheckinDate];
    NSString *checkOutDate = [hotelsearcher getCheckoutDate];
    
    NSString *today = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"yyyy-MM-dd"];
    NSString *tomorrow = [TimeUtils displayDateWithNSDate:[NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]] formatter:@"yyyy-MM-dd"];
    tonight = [checkInDate isEqualToString:today] && [checkOutDate isEqualToString:tomorrow] && ([HotelSearch tonightHotelCount] > 0);
}

- (void)reLoadTable:(NSNotification *)noti {
    [listTableView reloadData];
}


// 更新顶部提示信息
- (void)resetTipLabel {
	UILabel *countlabel = (UILabel *)[self.listTableView.tableHeaderView viewWithTag:kCountLabelTag];
	countlabel.text=[NSString stringWithFormat:_string(@"s_totalhotelcount"),[HotelSearch hotelCount]];
}

// 酒店搜索页面顶部提示
- (void)addTableHeaderView {
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    
    listTableView.tableHeaderView = headerView;
    
    // 刷新酒店数量
	[self resetTipLabel];
}

- (void) addSearchBar{
    // 搜索框
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    if (!keywordVC) {
        keywordVC = [[HotelKeywordViewController alloc] initWithSearchCity:[hotelsearcher cityName] contentsController:nil];
        keywordVC.delegate = rootController;
        keywordVC.viewController = rootController;
        keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        keywordVC.searchList.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44);
        keywordVC.withNavHidden = YES;
        JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
        PositioningManager *positionManager = [PositioningManager shared];
        if ([positionManager.currentCity isEqualToString:hotelsearcher.cityName] && ![hotelsearcher getIsPos]){
            keywordVC.nearbyIsShow = YES;
        }
        else{
            keywordVC.nearbyIsShow = NO;
        }
        keywordVC.searchBar.translucent = NO;
        keywordVC.searchBar.clipsToBounds = NO;
        if ([ProcessSwitcher shared].allowIFlyMSC && [PublicMethods isHotCity:[hotelsearcher cityName] ]) {
            keywordVC.iflyIsShow = YES;
        }
        
    }
    [self.view addSubview:keywordVC.searchBar];
}


- (void)makeMoreLoadingView {
	tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 47)];
	UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiView.center = tableFootView.center;
    [aiView startAnimating];
	[tableFootView addSubview:aiView];
    [aiView release];
    
    moreHotelButton = [[UIButton alloc] initWithFrame:tableFootView.frame];
    moreHotelButton.titleLabel.font = FONT_14;
    moreHotelButton.adjustsImageWhenHighlighted = NO;
    [moreHotelButton setTitle:@"点击加载更多酒店" forState:UIControlStateNormal];
    [moreHotelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [moreHotelButton addTarget:self action:@selector(clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickMoreButton {
    isRequstMore = NO;
    listTableView.tableFooterView = tableFootView;
    [self morehotel];
}

- (void)refreshData {
    [self addTableHeaderView];
    
    // 恢复searchbar
    searchBarHidden = NO;
    keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    listTableView.tableHeaderView.hidden = NO;
    isRequstMore = NO;
	
    // 重新计算今日特价
    [self refreshTonight];
    
	[listTableView reloadData];
	[self resetTipLabel];
	
	[listTableView setContentOffset:CGPointMake(0, 0)];
	listTableView.hidden = [HotelSearch hotelCount] == 0 ? YES : NO;
    
    // by dawn
    if ([self getSuggestionNum]>0) {
        listTableView.hidden = NO;
    }
	
	hotelCount = [[HotelSearch hotels] count];

	if (hotelCount >= [HotelSearch hotelCount]) {
		listTableView.tableFooterView = nil;
	}else {
		if (!tableFootView) {
			[self makeMoreLoadingView];
		}
		listTableView.tableFooterView = tableFootView;
	}

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    listTableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT -20-44-43);
    [UIView commitAnimations];
    
    [self.rootController refreshTitle];
}

- (void)doSearchTipAnimation {
    [listTableView scrollRectToVisible:CGRectMake(0, 44, listTableView.bounds.size.width, listTableView.bounds.size.height) animated:YES];
}

- (void)cancelSearchCondition {
	// 取消搜索结果
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:@"" forKey:HOTEL_SEARCH_KEYWORD]];
	
	HotelConditionRequest *hcReq = [HotelConditionRequest shared];
    [hcReq clearKeywordFilter];
}

// 重新调整搜索条件
- (void) readjustSearchCondition:(NSInteger)index{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    NSDictionary *dict = [filterAdjustArray safeObjectAtIndex:index];
    NSString *tag = [dict safeObjectForKey:@"Tag"];
    if ([tag isEqualToString:@"POI"]) {
        // 地标 暂设定为3KM
        [hotelsearcher resetPage];
        [hotelsearcher setHotelName:@""];
        [hotelsearcher setCurrentPos:3000
                           Longitude:[[dict safeObjectForKey:@"Longitude"] floatValue]
                            Latitude:[[dict safeObjectForKey:@"Latitude"] floatValue]];
        
        //[HotelSearch setPositioning:YES];
        
        HotelConditionRequest *hcReq = [HotelConditionRequest shared];
        hcReq.keywordFilter.keyword = nil;
        hcReq.keywordFilter.keywordType = HotelKeywordTypePOI;
        hcReq.keywordFilter.poi = [dict safeObjectForKey:@"HotelName"];
        
        
        // 清空keyword
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                            object:self
                                                          userInfo:[NSDictionary dictionaryWithObject:@"" forKey:HOTEL_SEARCH_KEYWORD]];
        self.rootController.keyword = nil;
        self.keywordVC.searchBar.text = nil;

    }else if ([tag isEqualToString:@"Price"]) {
        // 价格
        NSInteger minPrice = -1;
        NSInteger maxPrice = -1;
        
        [hotelsearcher resetPage];
        [hotelsearcher setMinPrice:[NSString stringWithFormat:@"%d",minPrice]
                          MaxPrice:[NSString stringWithFormat:@"%d",maxPrice]];
    }else if([tag isEqualToString:@"Star"]){
        // 星级
        [hotelsearcher resetPage];
        [hotelsearcher setStarCodes:@"星级不限"];
    }else if([tag isEqualToString:@"Brand"]){
        // 品牌
        [hotelsearcher resetPage];
        [hotelsearcher setBrandIDs:@"0"];
    }else if([tag isEqualToString:@"Theme"]){
        // 主题
        [hotelsearcher resetPage];
        [hotelsearcher setThemesFilter:nil];
    }else if ([tag isEqualToString:@"Facility"]){
        // 设施
        [hotelsearcher resetPage];
        [hotelsearcher setFacilitiesFilter:nil];
    }else if([tag isEqualToString:@"Area"]){
        // 区域
        [hotelsearcher resetPage];
        [hotelsearcher setAreaName:@""];
        
        
        // 坐标形式 地铁站、飞机场火车站
        HotelConditionRequest *hcReq = [HotelConditionRequest shared];
        if (hcReq.keywordFilter) {
            if (hcReq.keywordFilter.keywordType == HotelKeywordTypePOI
                || hcReq.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
                || hcReq.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation) {
                [hotelsearcher resetPosition];
                [hcReq clearKeywordFilter];
            }
        }
        
        // 清空keyword
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                            object:self
                                                          userInfo:[NSDictionary dictionaryWithObject:@"" forKey:HOTEL_SEARCH_KEYWORD]];
        self.rootController.keyword = nil;
        self.keywordVC.searchBar.text = nil;
    }
    [self.rootController researchHotel];
}

// 建议列表数量
- (NSInteger) getSuggestionNum{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    NSDictionary *content = [hotelsearcher getContent];
    [filterAdjustArray removeAllObjects];
    
    // 地标条件
    NSInteger hotelNum = 0;
    if ([[[hotelsearcher getContent] safeObjectForKey:ReqHS_IsPositioning_B] boolValue] || ![[content safeObjectForKey:@"IntelligentSearchText"] isEqualToString:@""]) {
        // 如果是周边搜索，显示每个酒店周边
        hotelNum = [[HotelSearch hotels] count];
        for (NSInteger i = 0; i < hotelNum; i++) {
            NSDictionary *hotel = [[HotelSearch hotels] safeObjectAtIndex:i];
            NSString *name = [NSString stringWithFormat:@"\"%@\"周边酒店    ",[hotel safeObjectForKey:@"HotelName"]];

            [filterAdjustArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[hotel safeObjectForKey:@"HotelName"],@"HotelName",name,@"Name",@"POI",@"Tag",[hotel safeObjectForKey:@"Longitude"],@"Longitude",[hotel safeObjectForKey:@"Latitude"],@"Latitude" , nil]];
        }
    }
    
    // 筛选条件
    NSInteger count = hotelNum;
        
    if ([[content safeObjectForKey:@"LowestPrice"] intValue] > 0 || ([[content safeObjectForKey:@"HighestPrice"] intValue] < 5000 && [[content safeObjectForKey:@"HighestPrice"] intValue] > 0)) {
        // 价格
        count++;
        

        NSInteger minPrice = [[content safeObjectForKey:@"LowestPrice"] intValue];
        NSInteger maxPrice = [[content safeObjectForKey:@"HighestPrice"] intValue];
        
    
        
        NSString *tips = @"所有价位的酒店";
        
        // 将价格提高一个档次，如果查出范围则设置为不限制
       
        [filterAdjustArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:tips,@"Name",@"Price",@"Tag",NUMBER(minPrice),@"LPrice",NUMBER(maxPrice),@"HPrice",NUMBER(0),@"PriceLevel",nil]];
    }
    if([[content safeObjectForKey:@"StarCode"] intValue] > 0){
        // 星级
        count++;
        [filterAdjustArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"所有星级的酒店"],@"Name",@"Star",@"Tag", nil]];
    }
    if([[content safeObjectForKey:@"HotelBrandID"] intValue] > 0){
        // 品牌
        count++;
        [filterAdjustArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"品牌不限的酒店"],@"Name",@"Brand",@"Tag", nil]];
    }
    
    if([content safeObjectForKey:@"AreaName"]!=[NSNull null]){
        // 区域
        if (![[content safeObjectForKey:@"AreaName"] isEqualToString:@""]) {
            count++;
            [filterAdjustArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"所有区域的酒店"],@"Name",@"Area",@"Tag", nil]];
        }
    }
    if ([[content safeObjectForKey:@"ThemesFilter"] intValue] > 0) {
        // 主题
        count++;
        [filterAdjustArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"主题不限的酒店"],@"Name",@"Theme",@"Tag", nil]];
    }
    if ([[content safeObjectForKey:@"FacilitiesFilter"] intValue] > 0) {
        // 设施
        count++;
        [filterAdjustArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"设施不限的酒店"],@"Name",@"Facility",@"Tag", nil]];
    }
    
    // 坐标形式 地铁站、飞机场火车站
    HotelConditionRequest *hcReq = [HotelConditionRequest shared];
    if (hcReq.keywordFilter) {
        if (hcReq.keywordFilter.keywordType == HotelKeywordTypePOI
            || hcReq.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
            || hcReq.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation) {
            count++;
            [filterAdjustArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"所有区域的酒店"],@"Name",@"Area",@"Tag", nil]];
        }
    }
    
    return count;
}

// 请求酒店详情
- (void)searchHotelAtRow:(NSInteger)row {
    selRow = row;
    // 查询x行的酒店详情
    NSDictionary *hotel = [[HotelSearch hotels] safeObjectAtIndex:row];
    NSString *hotelId = [hotel safeObjectForKey:RespHL__HotelId_S];
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    NSString *CheckonDate = [hotelsearcher getObject:ReqHS_CheckInDate_ED];
    NSString *CheckoutDate = [hotelsearcher getObject:ReqHS_CheckOutDate_ED];
    if ([hotel safeObjectForKey:@"HotelSpecialType"]) {
        isSevenDay = YES;
    }
    
    BOOL isUnsined= NO;
    if ([hotel safeObjectForKey:@"IsUnsigned"]&&[hotel safeObjectForKey:@"IsUnsigned"]!=[NSNull null])
    {
        isUnsined=[[hotel safeObjectForKey:@"IsUnsigned"] boolValue];
    }
    
    [self hoteldetail:hotelId CheckInDate:CheckonDate CheckOutDate:CheckoutDate isUnsigned:isUnsined];
    
    UMENG_EVENT(UEvent_Hotel_List_DetailEnter)
    
    // countly hotelitem
    CountlyEventHotelListPageHotelItem *countlyHotelItem = [[CountlyEventHotelListPageHotelItem alloc] init];
    countlyHotelItem.hotelId = hotelId;
    countlyHotelItem.line = NUMBER(row);
    if ([hotel objectForKey:@"NewStarCode"] != [NSNull null]) {
        countlyHotelItem.starcode = [NSNumber numberWithInt:[[hotel objectForKey:@"NewStarCode"] intValue]];
    }
    [countlyHotelItem sendEventCount:1];
    [countlyHotelItem release];
    
    //
    BOOL isPSG = NO;
    if ([hotel objectForKey:@"PSGRecommendReason"] != [NSNull null]) {
        if ([hotel objectForKey:@"PSGRecommendReason"]) {
            NSString *psg = [hotel objectForKey:@"PSGRecommendReason"];
            if (STRINGHASVALUE(psg)) {
                isPSG = YES;
            }
        }
    }
    
    HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
    promotionInfoRequest.orderEntrance = OrderEntranceList;
    if (isPSG) {
        promotionInfoRequest.orderEntrance = OrderEntrancePSG;
    }
    promotionInfoRequest.checkinDate = CheckonDate;
    promotionInfoRequest.checkoutDate = CheckoutDate;
    promotionInfoRequest.hotelId = hotelId;
    promotionInfoRequest.hotelName = [hotel safeObjectForKey:RespHL__HotelName_S];
    promotionInfoRequest.cityName = hotelsearcher.cityName;
    promotionInfoRequest.star = [hotel safeObjectForKey:RespHL__StarCode_I];
}

// 酒店详情网络请求
-(void)hoteldetail:(NSString *)hotelId CheckInDate:(NSString *)checkInDate CheckOutDate:(NSString *)checkOutDate isUnsigned:(BOOL) isUnsigned{
	linktype = HOTELDETAIL;
	
	JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:hotelId];
    [hoteldetail setIsUnsigned:isUnsigned];
    if (isSevenDay) {
        [hoteldetail setSevenDay:YES];
    }
	[hoteldetail setCheckDateByElongDate:checkInDate checkoutdate:checkOutDate];
    
	[Utils request:HOTELSEARCH req:[hoteldetail requesString:YES] policy:CachePolicyHotelDetail  delegate:self];
}


// 加载更多酒店
-(void)morehotel{
	JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
	[hotelsearcher nextPage];
    
    if (moreHotelReq) {
        [moreHotelReq cancel];
        self.moreHotelReq = nil;
    }
    
    self.moreHotelReq = [[[HttpUtil alloc] init] autorelease];
    
    [moreHotelReq connectWithURLString:HOTELSEARCH
                               Content:[hotelsearcher requesString:YES]
                          StartLoading:NO
                            EndLoading:NO
                            AutoReload:YES
                              Delegate:self];
    
    listTableView.tableFooterView = tableFootView;
    
    
    if (UMENG) {
        // 酒店列表加载更多
        [MobClick event:Event_HotelList_More];
    }
}

#pragma mark -
#pragma mark Public Methods

- (void)checkFoot {
	if (hotelCount >= [HotelSearch hotelCount]) {
		listTableView.tableFooterView = nil;
		rootController.isMaximum = YES;
		[rootController forbidSearchMoreHotel];
	}else {
		listTableView.tableFooterView = tableFootView;
		rootController.isMaximum = NO;
	}
}


// 当列表数量过多时删除多出的酒店
- (void)keepHotelNumber{
    if ([HotelSearch hotels]==nil||[HotelSearch hotels].count<=MAX_HOTEL_COUNT) {
        return;
    }
    
    int removeCnt=[HotelSearch hotels].count-MAX_HOTEL_COUNT;
	
	[[HotelSearch hotels] removeObjectsInRange:NSMakeRange(0, removeCnt)];
    
	[listTableView reloadData];
    
    beginDrag = NO;
    
    if (tonight)
    {
        [listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1+[HotelSearch hotels].count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    else
    {
        [listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[HotelSearch hotels].count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    listTableView.contentOffset=CGPointMake(listTableView.contentOffset.x, listTableView.contentOffset.y+listTableView.tableFooterView.frame.size.height);
}


#pragma mark - 
#pragma mark UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        // 推荐
        static NSString *cellIdentifier = @"SuggestCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
            cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
            
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.textColor = [UIColor colorWithRed:24.0/255.0f green:116.0/255.0f blue:203.0/255.0f alpha:1];
            cell.textLabel.highlightedTextColor = [UIColor colorWithRed:24.0/255.0f green:116.0/255.0f blue:203.0/255.0f alpha:1];
            
            // 分割线
            UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
            splitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [cell.contentView addSubview:splitView];
            [splitView release];
            
            // arrow
            UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(292, 0, 20, 50)];
            arrowView.contentMode = UIViewContentModeCenter;
            arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
            [cell.contentView addSubview:arrowView];
            [arrowView release];
            
            cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        }
        NSDictionary *dict = [filterAdjustArray safeObjectAtIndex:indexPath.row];
        cell.textLabel.text = [dict safeObjectForKey:@"Name"];
        //
        return cell;
    }
    
    // index
    NSUInteger row =[indexPath row];
    if (tonight && row == 0) {
        // 区分今日特价、龙萃和正常酒店
        static NSString *TonightHotelListModeCellIdentifier = @"TonightHotelListModeCellIdentifier";
        TonightHotelListModeTableCell *tcell = nil;
        
        // 今日特价
        tcell = (TonightHotelListModeTableCell *)[tableView dequeueReusableCellWithIdentifier:TonightHotelListModeCellIdentifier];
        if (tcell == nil) {
            tcell = [[[TonightHotelListModeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TonightHotelListModeCellIdentifier] autorelease];
        }
        tcell.tonightHotelCount = [HotelSearch tonightHotelCount];
        if (tcell.tonightHotelCount != 0) {
            [tcell stopLoading];
        }
        if (tcell.tonightHotelCount == 0) {
            tcell.hidden = YES;
        }else{
            tcell.hidden = NO;
        }
        tcell.clipsToBounds = YES;
        return tcell;
    }
    else{
        if (tonight) {
            row = row - 1;
        }
        
        NSDictionary *hotel = [[HotelSearch hotels] safeObjectAtIndex:row];
        
        // PSG推荐
        BOOL showImage = [[SettingManager instanse] defaultDisplayHotelPic];
        BOOL isPSG = NO;
        if ([hotel objectForKey:@"PSGRecommendReason"] != [NSNull null]) {
            if ([hotel objectForKey:@"PSGRecommendReason"]) {
                NSString *psg = [hotel objectForKey:@"PSGRecommendReason"];
                if (STRINGHASVALUE(psg)) {
                    isPSG = YES;
                }
            }
        }

        HotelListCell *cell = nil;
        if (isPSG) {
            static NSString* PSGHotelListModeCellIdentifier = @"PSGHotelListCellIdentifier";
            cell = (HotelListCell *)[tableView dequeueReusableCellWithIdentifier:PSGHotelListModeCellIdentifier];
            if (cell == nil) {
                cell = [[[HotelListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PSGHotelListModeCellIdentifier haveImage:showImage haveAction:YES recommend:YES] autorelease];
            }
        }else{
            static NSString* HotelListModeCellIdentifier = @"HotelListCellIdentifier";
            cell = (HotelListCell *)[tableView dequeueReusableCellWithIdentifier:HotelListModeCellIdentifier];
            if (cell == nil) {
                cell = [[[HotelListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HotelListModeCellIdentifier haveImage:showImage haveAction:YES] autorelease];
            }
        }
        cell.indexPath = indexPath;
        cell.dataIndex = row;
        cell.isLM = NO;
        
        // 设置cell数据源
        cellAction.parentNav = self.rootController.navigationController;
        cellDataSource.keyword  = self.keywordVC.searchBar.text;
        cell.actionDelegate = cellAction;
        cell.dataSource = cellDataSource;
        cell.delegate = self;
        
        // 刷新数据
        [cell reloadCell];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (tonight) {
        row = row - 1;
    }
    if (indexPath.section == 0) {
        NSDictionary *hotel = [[HotelSearch hotels] safeObjectAtIndex:row];
        float cellHeight = 95;
        
        // PSG推荐
        if ([hotel objectForKey:@"PSGRecommendReason"] != [NSNull null]) {
            if ([hotel objectForKey:@"PSGRecommendReason"]) {
                NSString *psg = [hotel objectForKey:@"PSGRecommendReason"];
                if (STRINGHASVALUE(psg)) {
                    cellHeight = 95 + 40;
                }
            }
        }
        if (tonight) {
            if (indexPath.row == 0) {
                // 如果今日特价和酒店列表酒店一致，返回0，隐藏之
                NSArray *hotels = [HotelSearch hotels];
                if (hotels.count == [HotelSearch tonightHotelCount]) {
                    return 0;
                }
                if (hotels.count == 0) {
                    return 0;
                }
                return 80;
            }
            else {
                return cellHeight;
            }
        }
        else {
            return cellHeight;
        }
    }else{
        return 50;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (tonight) {
            cellNum = [[HotelSearch hotels] count] + 1;
            
        }else{
            cellNum = [[HotelSearch hotels] count];
        }
        
        return cellNum;
    }else{
        
        return [self getSuggestionNum];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if ( [[HotelSearch hotels] count] <= 3) {
        if ([self getSuggestionNum] > 0) {
            return 2;
        }else{
            return 1;
        }
    }
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 28)];
    sectionView.backgroundColor = [UIColor colorWithRed:231.0/255.0f green:231.0/255.0f blue:231.0/255.0f alpha:1];
    
        
    UILabel *sectionLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 28)];
    sectionLbl.font = [UIFont systemFontOfSize:14.0f];
    sectionLbl.textColor = [UIColor colorWithWhite:101.0/255.0f alpha:1];
    sectionLbl.backgroundColor = [UIColor clearColor];
    sectionLbl.text = @"为您推荐以下酒店";
    [sectionView addSubview:sectionLbl];
    [sectionLbl release];
    
    if ([[HotelSearch hotels] count] == 0) {
        UIImageView *nohotelView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 16, 16)];
        nohotelView.image = [UIImage noCacheImageNamed:@"filter_nohotel.png"];
        [sectionView addSubview:nohotelView];
        [nohotelView release];
        
        sectionLbl.frame = CGRectMake(32, 0, SCREEN_WIDTH - 42, 28);
        sectionLbl.text = @"未找到符合条件的酒店";
    }

    return [sectionView autorelease];
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        if ([[HotelSearch hotels] count] == 0) {
            return 28;
        }
        return 0;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectIndexPath = indexPath;
    if (keywordVC.searchBarIsShow) {
        return;
    }
    
    if (indexPath.section == 0) {
        if (tonight) {
            if (indexPath.row == 0) {
                TonightHotelListMode *tonightHotelListMode = [[TonightHotelListMode alloc] initWithTopImagePath:nil andTitle:@"今日特价" style:_NavNoTelStyle_];
                tonightHotelListMode.rootController = self.rootController;
                ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate.navigationController pushViewController:tonightHotelListMode animated:YES];
                [tonightHotelListMode release];
                
                UMENG_EVENT(UEvent_Hotel_List_LastMinute)
                
                // countly lm
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELLISTPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_LM;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
            else {
                [rootController cancelOrderView];
                NSUInteger row = [indexPath row] - 1;
                [HotelSearch setCurrentIndex:row];
                
                [self searchHotelAtRow:row];
            }
        }
        else {
            [rootController cancelOrderView];
            NSUInteger row = [indexPath row];
            [HotelSearch setCurrentIndex:row];
            
            [self searchHotelAtRow:row];
        }
    }else{
        [self readjustSearchCondition:indexPath.row];
    }
}



#pragma mark -
#pragma mark HotelListCellDelegate
- (void) hotelListCellDidSelected:(HotelListCell *)cell{
    [listTableView selectRowAtIndexPath:cell.indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void) hotelListCellDidDeselected:(HotelListCell *)cell{
    [listTableView deselectRowAtIndexPath:cell.indexPath animated:NO];
}

- (void) hotelListCellDidAction:(HotelListCell *)cell{
    [self tableView:listTableView didSelectRowAtIndexPath:cell.indexPath];
}


#pragma mark -
#pragma mark UIScroll Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    for (HotelListCell *cell in [listTableView visibleCells]) {
//        if ([cell isKindOfClass:[HotelListCell class]]) {
//            [cell setAction:NO animated:NO];
//        }
//    }
//    if (!beginDrag) {
//        return;
//    }
	if (listTableView.tableFooterView && !isRequstMore) {
        // 当还有更多酒店时在滑到倒数第5行时发起请求
		NSArray *array = [listTableView visibleCells];
        NSIndexPath *cellIndex = [listTableView indexPathForCell:[array lastObject]];
        
        if (cellIndex.row >= [[HotelSearch hotels] count] - 5) {
            isRequstMore = YES;
            [self morehotel];
        }
	}

    NSInteger minCellNum = SCREEN_4_INCH ? 5 : 4;       // 少于这个数目的不做动画

    if (minCellNum < cellNum) {
        if (scrollView.contentOffset.y - moveY > 60) {
            if (!searchBarHidden) {
                searchBarHidden = YES;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                keywordVC.searchBar.frame = CGRectMake(0, -44, SCREEN_WIDTH, 44);
                [UIView commitAnimations];
                
                moveY = scrollView.contentOffset.y;
            }
            
        }else if(scrollView.contentOffset.y - moveY < -50){
            if(searchBarHidden){
                searchBarHidden = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
                [UIView commitAnimations];
                
                moveY = scrollView.contentOffset.y;
            }
        }
        if (scrollView.contentOffset.y <= 44) {
            if(searchBarHidden){
                searchBarHidden = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelay:0.3];
                keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
                [UIView commitAnimations];
                
                moveY = scrollView.contentOffset.y;
            }
        }
    }
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    beginDrag = NO;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    beginDrag = NO;
}

- (void) scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if(searchBarHidden){
        searchBarHidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            keywordVC.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        }];
        moveY = scrollView.contentOffset.y;
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    beginDrag = YES;
    moveY = scrollView.contentOffset.y;
}

#pragma mark -
#pragma mark HttpUtilDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@", root);
    
    if ([Utils checkJsonIsError:root]) {
        listTableView.tableFooterView = nil;
        isRequstMore = NO;
        return ;
    }
    
    if (util == moreHotelReq) {
        // 请求更多酒店
        [rootController checkHotelFull];
        
        NSArray *dataArray = [root safeObjectForKey:RespHL_HotelList_A];
        [[HotelSearch hotels] addObjectsFromArray:dataArray];
        hotelCount += [dataArray count];
        
        // 更新数据过后，刷新表格与地图得显示
        [listTableView reloadData];
        [rootController refreshMapData];
        [self checkFoot];
        
        isRequstMore = NO;
    }
    else{
        switch (linktype) {
            case HOTELDETAIL:
            {
                [[HotelDetailController hoteldetail] addEntriesFromDictionary:root];
                [[HotelDetailController hoteldetail] removeRepeatingImage];
                rootController.selRow = selRow;
                [rootController goHotelDetail];
            }
                break;
            default:
                break;
        }
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if (util == moreHotelReq) {
        isRequstMore = YES;
        listTableView.tableFooterView = moreHotelButton;
    }
    if (self.selectIndexPath) {
        [listTableView deselectRowAtIndexPath:self.selectIndexPath animated:YES];
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util {
    if (util == moreHotelReq) {
        isRequstMore = YES;
        listTableView.tableFooterView = moreHotelButton;
    }
    if (self.selectIndexPath) {
        [listTableView deselectRowAtIndexPath:self.selectIndexPath animated:YES];
    }
}

@end