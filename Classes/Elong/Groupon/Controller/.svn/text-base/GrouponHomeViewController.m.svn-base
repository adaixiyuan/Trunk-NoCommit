//
//  GrouponHomeViewController.m
//  ElongClient
//  团购首页
//
//  Created by haibo on 11-10-20.
//  Copyright 2011 elong. All rights reserved.
// 

#import "GrouponHomeViewController.h"
#import "GrouponCityChooseViewController.h"
#import "GListRequest.h"
#import "GDetailRequest.h"
#import "GrouponDetailViewController.h"
#import "CustomSegmented.h"
#import "FXLabel.h"
#import "ResizeLabel.h"
#import "StarsView.h"
#import "WaitingView.h"
#import "GrouponItemCell.h"
#import "InterRoomerSelectorViewController.h"
#import "SearchFilterController.h"
#import "GrouponSearchFilterController.h"
#import "GrouponFavorite.h"
#import "GrouponProductIdStack.h"

#define kButtonImageTag		1510
#define kScrollViewTag		1511
#define kLoadingTag			1513
#define kCityListType		1113
#define kReloadListType     1114
#define kGrouponTag			10000

#define CHANGECITY			10
#define GODETAIL			12
#define ORDER				13

#define SCROLL_HEIGHT       (SCREEN_4_INCH ? 423 : 378)

@interface GrouponHomeViewController ()

@property (nonatomic, retain) UIBarButtonItem		*originItem;	// 有电话、有home键的barbutton
@property (nonatomic, retain) UIBarButtonItem		*moreItem;		// 地图模式更多按钮

@end

@implementation GrouponHomeViewController

@synthesize allGroupons;
@synthesize originItem;
@synthesize moreItem;
@synthesize linkType;
@synthesize grouponCount;
@synthesize currentOrder;
@synthesize moreBtn;
@synthesize wxGrouponId;
@synthesize isFromWX;
@synthesize mapIsDisplay;
@synthesize currentGrouponCity;
@synthesize grouponDic;
@synthesize keyword;
@synthesize displayName;
@synthesize moreRequest;

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
//    HttpUtil *httpUtil = [HttpUtil shared];
//    if (httpUtil.delegate==self) {
//        httpUtil.delegate=nil;
//    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
	// clear request
	GListRequest *req = [GListRequest shared];
	[req clearData];
	
	self.allGroupons	= nil;
	self.originItem		= nil;
	self.moreItem		= nil;
	self.moreBtn		= nil;
	self.currentOrder	= nil;
    self.currentGrouponCity = nil;
    self.grouponDic     = nil;
    self.keyword        = nil;
    self.displayName    = nil;
    self.favBtn         = nil;
    
	[originArray	 release];
	[moreButtonView release];
    
    orderView.delegate=nil;
	[orderView release];
    
    priceView.priceChangeDelegate=nil;
    [priceView release];
    
	[segButton release];
    
    listViewController.homeVC=nil;
    [listViewController release];
    
    listMapViewController.hoomVC=nil;
    [listMapViewController release];
    
    cityChooseVC.root=nil;
    [cityChooseVC release];
    
    listFooterView.delegate=nil;
    mapFooterView.delegate=nil;
    
    if (moreRequest) {
        [moreRequest cancel];
        [moreRequest release],moreRequest = nil;
    }
    if (favRequest) {
        [favRequest cancel];
        [favRequest release],favRequest = nil;
    }
    
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release],detailRequest = nil;
    }
    
    
    [_listFilterIcon release];
    [_mapFilterIcon release];
    
    [GrouponProductIdStack clearProdIdArr];
	
    [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (id)init
{
	grouponCount = 0;
	firstLoading = YES;
	self.isFromWX = NO;
    
	if (self = [super init:@"" style:_NavNoTelStyle_]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCacheFileDateNoti:) name:NOTI_CACHEFILE_MODITIME object:nil];
        
		// 请求初始数据
        self.mapIsDisplay = NO;
        [self addTopBar];
        
//		[self researchGrouponListByCity:[[PositioningManager shared] currentCity] isFirstRequst:NO];
        [self researchGrouponListByCity:nil isFirstRequst:YES];
	}
	
	return self;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate cityName:(NSString *) cityName_
{
    grouponCount = 0;
	firstLoading = YES;
	self.isFromWX = NO;
    
	if (self = [super init:@"" style:_NavNoTelStyle_])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveCacheFileDateNoti:) name:NOTI_CACHEFILE_MODITIME object:nil];
        
		// 请求初始数据
        self.mapIsDisplay = NO;
        [self addTopBar];
        
        
        GListRequest *cityListReq	= [GListRequest shared];
        
        // 清空搜索条件
        self.currentOrder = @"";
        [cityListReq clearData];
        [self setBarItemDefaultStyle];
        
        [cityListReq setLongitude:coordinate.longitude];
        [cityListReq setLatitude:coordinate.latitude];
        linkType					= CHANGECITY;
        cityListReq.cityName		= cityName_;
        cityListReq.ImageSizeType   = 1;
        [cityListReq restoreGrouponListReqest];
        
        self.currentGrouponCity = [[PositioningManager shared] currentCity];
        self.displayName = @"所选位置";
        
        [[Profile shared] start:@"团购搜索"];
        [Utils request:GROUPON_SEARCH req:[cityListReq grouponListCompress:YES] policy:CachePolicyGrouponList delegate:self];
	}
	
	return self;
}

//- (void)back
//{
//	[PublicMethods closeSesameInView:self.navigationController.view];
//}

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentGrouponCity = [[PositioningManager shared] currentCity];
	
    // 存放团购数据
	NSMutableArray *mArray	= [[NSMutableArray alloc] initWithCapacity:2];
	self.allGroupons		= mArray;
	[mArray release];
	
	self.view.clipsToBounds = YES;
    [self changeMode];
	
    // 添加底栏
    [self addListFooterView];
	
	// 添加地图模式的底栏 
	[self performSelector:@selector(addMapFooterView)];
    
    // 收藏列表
    [self makeupFavBtn];
}

//取消选中
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (listViewController.selIndex>=0&&listViewController.selIndex<self.allGroupons.count)
    {
        NSIndexPath *selectRow = [NSIndexPath indexPathForRow:listViewController.selIndex inSection:0];
        [listViewController.listView deselectRowAtIndexPath:selectRow animated:YES];
    }
}

- (void)receiveCacheFileDateNoti:(NSNotification *)noti
{
    NSDate *cacheDate = (NSDate *)[noti object];
    cacheFileCreateTime = [[NSDate date] timeIntervalSinceDate:cacheDate];
}

#pragma mark -
#pragma mark Private Methods
#pragma mark ============================= UI =============================
// 收藏列表
- (void) makeupFavBtn{
    self.favBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
    self.favBtn.exclusiveTouch = YES;
    self.favBtn.adjustsImageWhenDisabled = NO;
    self.favBtn.titleLabel.font = FONT_B15;
	[self.favBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    [self.favBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [self.favBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
	[self.favBtn addTarget:self action:@selector(clickFavBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.favBtn] autorelease];
}

// 列表工具栏
-(void)addListFooterView{
    
    listFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20 - 44 - 45, SCREEN_WIDTH, 45)];
    listFooterView.delegate = self;
    
    filterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                                                titleFont:[UIFont systemFontOfSize:12.0f]
                                                    image:@"basebar_filter.png"
                                          highligtedImage:@"basebar_filter_h.png"];

    
    priceItem = [[BaseBottomBarItem alloc] initWithTitle:@"价格范围"
                                               titleFont:[UIFont systemFontOfSize:12.0f]
                                                   image:@"basebar_price.png"
                                         highligtedImage:@"basebar_price_h.png"];
    
    
    sortItem = [[BaseBottomBarItem alloc] initWithTitle:@"排序"
                                              titleFont:[UIFont systemFontOfSize:12.0f]
                                                  image:@"basebar_sort.png"
                                        highligtedImage:@"basebar_sort_h.png"];
//    sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
    
    mapModelItem = [[BaseBottomBarItem alloc] initWithTitle:@"地图"
                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                                                      image:@"basebar_map.png"
                                            highligtedImage:@"basebar_map_h.png"];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    
    [itemArray addObject:filterItem];
    filterItem.allowRepeat = YES;
    filterItem.autoReverse = YES;
    [filterItem release];
    
    [itemArray addObject:priceItem];
    priceItem.allowRepeat = YES;
    priceItem.autoReverse = YES;
    [priceItem release];
    
    [itemArray addObject:sortItem];
    sortItem.allowRepeat = YES;
    sortItem.autoReverse = YES;
    [sortItem release];
    
    [itemArray addObject:mapModelItem];
    mapModelItem.allowRepeat = YES;
    mapModelItem.autoReverse = YES;
    [mapModelItem release];
    
    listFooterView.baseBottomBarItems = itemArray;
    
    [self.view addSubview:listFooterView];
    [listFooterView release];
}


// 地图模式下的底部功能按钮
- (void)addMapFooterView
{
    mapFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45-20-44, 320, 45)];
    mapFooterView.delegate = self;
    
    mapFilterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛 选"
                                                   titleFont:[UIFont systemFontOfSize:12.0f]
                                                       image:@"basebar_filter.png"
                                             highligtedImage:@"basebar_filter_h.png"];
    
    mapPriceItem = [[BaseBottomBarItem alloc] initWithTitle:@"价格范围"
                                               titleFont:[UIFont systemFontOfSize:12.0f]
                                               image:@"basebar_price.png"
                                               highligtedImage:@"basebar_price_h.png"];

    
    listModelItem = [[BaseBottomBarItem alloc] initWithTitle:@"列 表"
                                                   titleFont:[UIFont systemFontOfSize:12.0f]
                                                       image:@"basebar_list.png"
                                             highligtedImage:@"basebar_list_h.png"];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    
    [itemArray addObject:mapFilterItem];
    mapFilterItem.allowRepeat = YES;
    mapFilterItem.autoReverse = YES;
    [mapFilterItem release];
    
    [itemArray addObject:mapPriceItem];
    mapPriceItem.allowRepeat = YES;
    mapPriceItem.autoReverse = YES;
    [mapPriceItem release];
    
    [itemArray addObject:listModelItem];
    listModelItem.allowRepeat = YES;
    listModelItem.autoReverse = YES;
    [listModelItem release];
    
    mapFooterView.baseBottomBarItems = itemArray;
    [self.view addSubview:mapFooterView];
    mapFooterView.hidden = YES;
    [mapFooterView release];
}

#pragma mark -
#pragma mark BaseBottomBarDelegate
- (void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if (bar == listFooterView) {
        switch (index) {
            case 0:{
                // 筛选
                [self filterBtnPressed];
            }
                break;
            case 1:{
                // 价格
                [self priceSelectPressed];
            }
                break;
            case 2:{
                //  排序
                [self orderBtnPressed];
                break;
            }
            case 3:{
                // 地图
                [self switchViews];
                UMENG_EVENT(UEvent_Groupon_List_Map)
            }
                break;
            default:
                break;
        }
    }else if(bar == mapFooterView){
        switch (index) {
                
            case 0:{
                // 筛选
                [self filterBtnPressed];
            }
                break;
            case 1:{
                // 价格
                [self priceSelectPressed];
            }
                break;
            case 2:{
                // 列表
                [self switchViews];
            }
                break;
            default:
                break;
        }
    }
    
}

// 导航栏中添加城市选择按钮和更多按钮
- (void)addTopBar
{
	// add city choose button
	UIButton *chooseCitysBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[chooseCitysBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateNormal];
	[chooseCitysBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"groupon_city_choose_btn.png"] forState:UIControlStateHighlighted];
	[chooseCitysBtn addTarget:self action:@selector(pushCityList) forControlEvents:UIControlEventTouchUpInside];
	chooseCitysBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
	chooseCitysBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
	chooseCitysBtn.frame           = CGRectMake(0, 0, 150, 32);
	
	UIImageView *btnImg = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"ico_downarrow.png"]];
	btnImg.tag			= kButtonImageTag;
	btnImg.hidden		= YES;
	[chooseCitysBtn addSubview:btnImg];
	[btnImg release];
	self.navigationItem.titleView = chooseCitysBtn;
	
	// add More Button
	self.moreBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
	moreBtn.adjustsImageWhenDisabled = NO;
    [moreBtn setExclusiveTouch:YES];
	moreBtn.titleLabel.font = FONT_B15;
	[moreBtn setTitle:@"显示更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
	[moreBtn addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	
	self.moreItem = [[[UIBarButtonItem alloc] initWithCustomView:moreBtn] autorelease];
}

// 计算是否应该显示筛选条件图标
- (void) updateFilterIcon
{
    GListRequest *cityListReq = [GListRequest shared];
    int count = 0;
    if ([cityListReq getStarLevel] != 0) {
        count++;
    }
    if (cityListReq.location != nil) {
        count++;
    }
    
    if (count > 0) {
        [self.listFilterIcon setHidden:NO];
        [self.mapFilterIcon  setHidden:NO];
    }
    else {
        [self.listFilterIcon setHidden:YES];
        [self.mapFilterIcon  setHidden:YES];
    }
    
    if (cityListReq.brand!=nil)
    {
        if ([[cityListReq.brand safeObjectForKey:@"BrandId"] intValue]>0) {
            count++;
        }
    }
    
    if (cityListReq.typpee!=nil)
    {
        if ([[cityListReq.typpee safeObjectForKey:@"CategoryId"] intValue]>0) {
            count++;
        }
    }
    
    if (count > 0) {
        filterItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_filter_mark.png"];
        mapFilterItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_filter_mark.png"];
        UMENG_EVENT(UEvent_Groupon_List_FilterAction)
    }
    else {
        filterItem.customerIcon = nil;
        mapFilterItem.customerIcon = nil;
        UMENG_EVENT(UEvent_Groupon_List_FilterReset)
    }
}

#pragma mark ============================= Filter =============================

// 判断是否包含所有数据
- (BOOL)isAllData
{
    if ([self.grouponDic safeObjectForKey:@"AllGrouponCnt"]) {
        return [[grouponDic safeObjectForKey:ALLGROUPONCNT_GROUPON] intValue] == [allGroupons count];
    }else{
        return YES;
    }
}

// 刷新数据
- (void)grouponListOrderByArray:(NSArray *)array
{
	[allGroupons removeAllObjects];
    
    if (ARRAYHASVALUE(array))
    {
        [allGroupons addObjectsFromArray:array];
    }
	
    [listViewController.listView reloadData];
    [listViewController.listView setContentOffset:CGPointMake(0, 0)];
	
	[listMapViewController resetAnnotations];
}

// 价格升序
- (void)priceSortByAscend:(BOOL)animated
{
	NSSortDescriptor *sortDes	= [[[NSSortDescriptor alloc] initWithKey:SALEPRICE_GROUPON ascending:animated] autorelease];
	NSArray *descriptors		= [NSArray arrayWithObject:sortDes];
	NSArray *sorted				= [allGroupons sortedArrayUsingDescriptors:descriptors];
	
	[self grouponListOrderByArray:sorted];
}

// 销量升序
- (void)salNumSortByAscend:(BOOL)animated
{
	NSSortDescriptor *sortDes	= [[[NSSortDescriptor alloc] initWithKey:SALENUMS_GROUPON ascending:animated] autorelease];
	NSArray *descriptors		= [NSArray arrayWithObject:sortDes];
	NSArray *sorted				= [allGroupons sortedArrayUsingDescriptors:descriptors];
	
	[self grouponListOrderByArray:sorted];
}

// 更新右上角按钮
- (void)upDateRightBarButton
{
	
	if (!listMapViewController.view.superview) {
		// 地图模式
        [self setshowNormaltpyewithouthtel];
        [self makeupFavBtn];
	}
	else {
		// 列表模式
		self.navigationItem.rightBarButtonItem = moreItem;
	}
}

#pragma mark ============================= Loding Animation =================================

- (void)startLoadingData
{
	// 在开始进入团购时展示
	WaitingView *waitView = [[WaitingView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 63) / 2, 160, 63, 51)];
	[waitView startLoading];
	waitView.tag = kLoadingTag;
	[self.view addSubview:waitView];
	[waitView release];
}

- (void)finishLoadingData
{
	// 获取团购数据后执行
	WaitingView *waitView = (WaitingView *)[self.view viewWithTag:kLoadingTag];
	[waitView stopLoading];
	[waitView removeFromSuperview];
	waitView = nil;
}

#pragma mark ============================= GrouponItem =============================
// 翻转到地图
- (void)changeToDisMap
{
	
	if (!listMapViewController) {
		listMapViewController = [[GrouponListMapViewController alloc] init];
        listMapViewController.hoomVC = self;
        listMapViewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44);
	}
	
    mapIsDisplay = YES;
    [listViewController.view removeFromSuperview];
    
	listFooterView.hidden	= YES;
	galleryFilterBtn.hidden = YES;
	mapFooterView.hidden	= NO;
	
	[self performSelector:@selector(upDateRightBarButton) withObject:nil afterDelay:0.8];
	[self.view insertSubview:listMapViewController.view atIndex:0];
}

// 弹出城市选择列表
- (void)pushCityList
{
	GListRequest *cityListReq = [GListRequest shared];
	if ([cityListReq isNeedRequestForCityList]) {
		// 请求城市列表
		linkType = kCityListType;
		[Utils request:GROUPON_SEARCH req:[cityListReq grouponCityRequestCompress:YES] delegate:self];
	}
	else {
        if (cityChooseVC==nil) {
            cityChooseVC		= [[GrouponCityChooseViewController alloc] init];
            cityChooseVC.root	= self;
        }
		
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityChooseVC];
        
        if (IOSVersion_7) {
            nav.transitioningDelegate = [ModalAnimationContainer shared];
            nav.modalPresentationStyle = UIModalPresentationCustom;
        }
        if(IOSVersion_7){
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self presentModalViewController:nav animated:YES];
        }
        [nav release];
	}
    
}

// 刷新列表页数据
- (void)reloadList
{
	[listViewController reloadList];
}

// 请求下页数据
- (void)requestForNextPage
{
	linkType = kRequest_More;
	GListRequest *cityListReq	= [GListRequest shared];
	[cityListReq nextPage];
    
    if (moreRequest) {
        [moreRequest cancel];
        [moreRequest release],moreRequest = nil;
    }
    moreRequest = [[HttpUtil alloc] init];
    [moreRequest connectWithURLString:GROUPON_SEARCH Content:[cityListReq grouponListCompress:YES]  StartLoading:NO EndLoading:NO Delegate:self];
    
    if (UMENG) {
        //团购酒店列表加载更多
        [MobClick event:Event_GrouponHotelList_More];
    }
    // 关闭收藏功能
    self.navigationItem.rightBarButtonItem.enabled = NO;

}

// 判断是否是最后一页
- (BOOL)isLastPage
{
    if (self.grouponDic == nil) {
        return YES;
    }
	if ([[self.grouponDic safeObjectForKey:ALLPAGECOUNT] intValue] == 0) {
		return YES;
	}
	
	return [[self.grouponDic safeObjectForKey:ALLPAGECOUNT] isEqual:[self.grouponDic safeObjectForKey:CURPAGEINDEX]];
}

// 数目过多时，删减项目
- (void)keepGrouponNumber
{
	if ([self.allGroupons count] > MAX_GROUPON_COUNT) {
		
		for (NSInteger i = 0; i < MAX_PAGESIZE_GROUPON; i ++) {
			NSDictionary *groupon = [self.allGroupons safeObjectAtIndex:i];
			if ([listViewController.imageDic count] > 0) {
				[listViewController.imageDic removeObjectForKey:[groupon safeObjectForKey:PRODID_GROUPON]];
				[listViewController.progressDic removeObjectForKey:[groupon safeObjectForKey:PRODID_GROUPON]];
			}
		}
		
        // 移除地图中的项目
		[listMapViewController removeMapAnnotationsInRange:NSMakeRange(0, MAX_PAGESIZE_GROUPON)];
        
        // 移除数据源中的项目
		[self.allGroupons removeObjectsInRange:NSMakeRange(0, MAX_PAGESIZE_GROUPON)];
        
        if ([self.allGroupons count] > MAX_GROUPON_COUNT - MAX_PAGESIZE_GROUPON)
        {
            [listViewController.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:MAX_GROUPON_COUNT - MAX_PAGESIZE_GROUPON - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            listViewController.listView.contentOffset=CGPointMake(listViewController.listView.contentOffset.x, listViewController.listView.contentOffset.y+listViewController.listView.tableFooterView.frame.size.height);
        }
	}
}


#pragma mark -
#pragma mark Actions

- (void) clickFavBtn:(id)sender
{
    UMENG_EVENT(UEvent_Groupon_List_FavList)
    
    if (UMENG) {
        //团购列表进入团购收藏列表
        [MobClick event:Event_GrouponFavList_List];
    }
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (islogin) {
        // 点击收藏团购
        GrouponFavoriteRequest *grouponFavReq = [HotelPostManager grouponFav];
        [grouponFavReq reset];
        
        if (favRequest) {
            [favRequest cancel];
            [favRequest release],favRequest = nil;
        }
        favRequest = [[HttpUtil alloc] init];
        [favRequest connectWithURLString:GROUPON_SEARCH
                                 Content:[grouponFavReq request]
                            StartLoading:YES
                              EndLoading:YES
                                Delegate:self];
    }else {
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_GrouponGetFavorite];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
    }
    
}

// 价格滑块触发
- (void) priceSelectPressed
{
    if (!priceView) {
		priceView = [[PricePopViewController alloc] initWithTitle:@"价格" Datas:nil];
		priceView.priceChangeDelegate = self;
		[self.view addSubview:priceView.view];
	}
    
    [priceView reset];
    
    [priceView showInView];
}

// 筛选按钮触发
- (void)filterBtnPressed
{
    
    GrouponSearchFilterController *filter = [[GrouponSearchFilterController alloc] initWithNibName:@"FilterController" bundle:nil isShowLocation:![self.displayName isEqualToString:@"当前位置"]];
    filter.filterDelegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filter];
    [filter release];
    
    if (IOSVersion_7) {
        nav.transitioningDelegate = [ModalAnimationContainer shared];
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentModalViewController:nav animated:YES];
    }
    [nav release];
}

// 排序按钮触发
- (void)orderBtnPressed
{
	NSArray *datas = nil;//
    
    GListRequest *request = [GListRequest shared];
    PositioningManager *positionManager = [PositioningManager shared];
    if ([self.displayName isEqualToString:@"当前位置"])
    {
        datas =  [NSArray arrayWithObjects:
                  orderStrings[0],
                  orderStrings[2],
                  orderStrings[3],
                  orderStrings[4],
                  orderStrings[5],
                  nil];
    }
    else if (positionManager.myCoordinate.latitude != 0 && [positionManager getPostingBool] && [positionManager.currentCity isEqualToString:request.cityName])
    {
        datas =  [NSArray arrayWithObjects:
                  orderStrings[0],
                  orderStrings[1],
                  orderStrings[2],
                  orderStrings[3],
                  orderStrings[4],
                  orderStrings[5],
                  nil];
    }
    else
    {
        datas =  [NSArray arrayWithObjects:
                  orderStrings[0],
                  orderStrings[2],
                  orderStrings[3],
                  orderStrings[4],
                  orderStrings[5],
                  nil];
    }
	
	if (!orderView) {
		orderView = [[GrouponFilterView alloc] initWithTitle:@"排序" Datas:datas];
		orderView.delegate = self;
		[self.view addSubview:orderView.view];
	}
    orderView.listDatas = datas;
	
	[orderView showInView];
	if (STRINGHASVALUE(currentOrder)) {
		[orderView selectRow:[datas indexOfObject:currentOrder]];
	}
	else {
		[orderView selectRow:0];
	}
}

// 更多按钮触发
- (void)moreButtonPressed
{
	[listMapViewController searchMoreHotel];
}

#pragma mark -
#pragma mark Public Methods

- (BOOL)checkDataNull
{
	// 检测是否有团购酒店
	if ([allGroupons count] == 0) {
		[listViewController.view removeTipMessage];
		[listViewController.view showTipMessage:@"未找到团购信息"];
        listViewController.listView.tableFooterView = nil;
        [listViewController.listView reloadData];
		return YES;
	}
	else {
		[listViewController.view removeTipMessage];
		return NO;
	}
}

- (NSMutableArray *)getAllGrouponList
{
	return allGroupons;
}

// 切换城市，重新搜索
- (void)researchGrouponListByCity:(NSString *)cityName isFirstRequst:(BOOL) isFirstRequst
{
    if (cityName) {
        self.currentGrouponCity = cityName;
        if (STRINGHASVALUE(cityName)) {
            GListRequest *cityListReq	= [GListRequest shared];
            
            if (![cityName isEqualToString:self.displayName]) {
                // 如切换城市则清空搜索条件
                self.currentOrder = @"";
                self.keyword = nil;
                if (!IOSVersion_5) {
                    [listViewController viewWillAppear:YES];
                }
                [cityListReq clearData];
                [self setBarItemDefaultStyle];
            }
            
            // 即时不换城市也进行搜索，时刻不同酒店不同
            linkType					= CHANGECITY;
            cityListReq.cityName		= cityName;
            cityListReq.ImageSizeType   = 1;
            [cityListReq setLongitude:0];
            [cityListReq setLatitude:0];
            [cityListReq restoreGrouponListReqest];
            
            self.currentGrouponCity = cityName;
            self.displayName = cityName;
            
            [[Profile shared] start:@"团购搜索"];
            [Utils request:GROUPON_SEARCH req:[cityListReq grouponListCompress:YES] policy:CachePolicyGrouponList delegate:self];
        }
        UMENG_EVENT(UEvent_Groupon_List_CityChoice)
    }else{
        UMENG_EVENT(UEvent_Groupon_List_Position)
        // 当前位置，按坐标进行搜索
        // to do by dawn
        
        //先定位下
        FastPositioning *position = [FastPositioning shared];
        position.autoCancel = YES;
        [position fastPositioning];
        
        //首次进入，校对定位
        if (isFirstRequst)
        {
            if (![self checkPoi])
            {
                return;
            }
        }
        
        GListRequest *cityListReq	= [GListRequest shared];
        
        // 清空搜索条件
        self.currentOrder = @"";
        [cityListReq clearData];
        [self setBarItemDefaultStyle];
        
        // 即时不换城市也进行搜索，时刻不同酒店不同
        PositioningManager *posiManager = [PositioningManager shared];
        [cityListReq setLongitude:posiManager.myCoordinate.longitude];
        [cityListReq setLatitude:posiManager.myCoordinate.latitude];
        linkType					= CHANGECITY;
        cityListReq.cityName		= [[PositioningManager shared] currentCity];
        cityListReq.ImageSizeType   = 1;
        [cityListReq restoreGrouponListReqest];
        
        self.currentGrouponCity = [[PositioningManager shared] currentCity];
        self.displayName = @"当前位置";
        
        [[Profile shared] start:@"团购搜索"];
        [Utils request:GROUPON_SEARCH req:[cityListReq grouponListCompress:YES] policy:CachePolicyGrouponList delegate:self];
        
        // 团购周边搜索
        if(UMENG){
            [MobClick event:Event_GrouponHotelAround];
        }
    }
}

//校验定位
-(BOOL) checkPoi
{
    PositioningManager *posiManager = [PositioningManager shared];
    if (posiManager.myCoordinate.longitude ==0 && posiManager.myCoordinate.latitude == 0)
    {
        //定位失败，按城市搜索
        if (STRINGHASVALUE(posiManager.currentCity)) {
            [self researchGrouponListByCity:posiManager.currentCity isFirstRequst:NO];
            return NO;
        }
    }
    
    if ([[PositioningManager shared] isGpsing])
    {
        //定位失败，按城市搜索
        if (STRINGHASVALUE(posiManager.currentCity)) {
            [self researchGrouponListByCity:posiManager.currentCity isFirstRequst:NO];
            return NO;
        }
    }
    
    //不在热门城市里或者定位城市失败（搜索北京），搜索定位城市
    if (![self isInHotCities:posiManager.currentCity]||posiManager.isNotFindCityName) {
        [self researchGrouponListByCity:posiManager.currentCity isFirstRequst:NO];
        return NO;
    }
    
    return YES;
}

//是否在热门城市里
-(BOOL) isInHotCities:(NSString *) tagertCity
{
    if (!STRINGHASVALUE(tagertCity)) {
        return NO;
    }
    
    NSArray *hotKeys = [GrouponCityChooseViewController getHotArrays];
    for (NSString *c in hotKeys) {
        if (STRINGHASVALUE(c)) {
            if ([c isEqualToString:tagertCity]) {
                return YES;
            }
        }
    }
    
    return NO;
}

// 禁用更多按钮
- (void)forbidSearchMoreHotel
{
	if (moreBtn.enabled) {
		moreBtn.enabled = NO;
		[moreBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateNormal];
	}
}

// 恢复更多按钮
- (void)restoreSearchMoreHotel
{
	if (!moreBtn.enabled) {
		moreBtn.enabled = YES;
		[moreBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
	}
}

// 设置导航栏城市按钮文字
- (void)setGrouponCity:(NSString *)cityName
{
	// 设置顶部的城市button
    UIButton *chooseCitysBtn = (UIButton *)self.navigationItem.titleView;
    UIImageView *btnImg = (UIImageView *)[chooseCitysBtn viewWithTag:kButtonImageTag];
    if (btnImg.hidden) {
        // 如果是第一次请求，自己设置标题
        btnImg.hidden = NO;
        galleryFilterBtn.hidden = NO;
    }
    
	[chooseCitysBtn setTitle:cityName forState:UIControlStateNormal];
	
	CGSize size	= [cityName sizeWithFont:chooseCitysBtn.titleLabel.font];
	int maxWidth = chooseCitysBtn.frame.size.width - 30;
	if (size.width >= maxWidth) {
		size.width = maxWidth;
	}
	
	btnImg.frame		= CGRectMake(size.width / 2 + chooseCitysBtn.frame.size.width / 2 + 1, 
									 14,
									 9,
									 5);
}

// 获取筛选条件，重新筛选
- (void)researchGrouponListByFilter:(NSDictionary *)filterDic
{
	linkType = CHANGECITY;
	
	[self setListGrouponInfo:filterDic];
}

- (void)resetListData:(NSDictionary *)dic
{
    self.grouponDic  = dic;
    NSArray *array = [dic safeObjectForKey:GROUPONLIST_GROUPON];
    // 重设源数据
    grouponCount = 0;
    [allGroupons removeAllObjects];
    [listViewController.imageDic removeAllObjects];
    [listViewController.progressDic removeAllObjects];
    
    if (ARRAYHASVALUE(array))
    {
        [allGroupons addObjectsFromArray:array];
    }
    
    
    currentPageIndex = 0;
    grouponCount += [array count];
    
    if ([self checkDataNull]) {
        // 更新更多按钮状态
        if ([[dic safeObjectForKey:ALLGROUPONCNT_GROUPON] intValue] <= 10) {
            // 不满一页时，不再进行更多查询
            [self forbidSearchMoreHotel];
        }
        else {
            [self restoreSearchMoreHotel];
        }
        
        // 界面恢复
        [self reloadList];
        return;
    }
    
    // 更新更多按钮状态
    if ([[dic safeObjectForKey:ALLGROUPONCNT_GROUPON] intValue] <= 10) {
        // 不满一页时，不再进行更多查询
        [self forbidSearchMoreHotel];
    }
    else {
        [self restoreSearchMoreHotel];
    }
    
    // 界面恢复
    [self reloadList];
    [listViewController.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentPageIndex inSection:0]
                                       atScrollPosition:UITableViewScrollPositionBottom
                                               animated:NO];
}

- (void)setListGrouponInfo:(NSDictionary *)dic
{
	self.grouponDic  = dic;
    NSArray *array = nil;
	if ([dic safeObjectForKey:@"ProductList"]!=[NSNull null] && [dic safeObjectForKey:@"ProductList"]) {
        array = [dic safeObjectForKey:@"ProductList"];
    }else if([dic safeObjectForKey:GROUPONLIST_GROUPON]!=[NSNull null] && [dic safeObjectForKey:GROUPONLIST_GROUPON]){
        array = [dic safeObjectForKey:GROUPONLIST_GROUPON];
    }else{
        array = [NSArray array];
    }
	 
	if ([array count] > 0) {
		if (kRequest_More == linkType) {
			grouponCount += [array count];
            
            if (ARRAYHASVALUE(array))
            {
                [allGroupons addObjectsFromArray:array];
            }
            
			[self keepGrouponNumber];
			
			// 显示更多团购
            [self reloadList];			
			if ([self isLastPage]) {
				[self forbidSearchMoreHotel];
			}
			
			// 更新地图模式状态
			[listMapViewController addMapAnnotations:array];
		}
		else {
			// 重设源数据
            grouponCount = 0;
            [allGroupons removeAllObjects];
            [listViewController.imageDic removeAllObjects];
            [listViewController.progressDic removeAllObjects];
            
            if (ARRAYHASVALUE(array))
            {
                [allGroupons addObjectsFromArray:array];
            }
            
            currentPageIndex = 0;
            grouponCount += [array count];
            
            if ([self checkDataNull]) {
                return;
            }
            
            // 更新更多按钮状态
            if ([[dic safeObjectForKey:ALLGROUPONCNT_GROUPON] intValue] <= 10) {
                // 不满一页时，不再进行更多查询
                [self forbidSearchMoreHotel];
            }
            else {
                [self restoreSearchMoreHotel];
            }
            
            // 界面恢复
            [listViewController resetKeywordBar];
            [self reloadList];
			[listMapViewController resetAnnotations];
            [listViewController.listView setContentOffset:CGPointMake(0, 0)];
            
            [self updateFilterIcon];
		}
	}
	else {
		if (CHANGECITY == linkType) {
			// 切换条件时，筛选没有酒店的情况
			grouponCount = 0;
			[allGroupons removeAllObjects];
			[listViewController.imageDic removeAllObjects];
			[listViewController.progressDic removeAllObjects];
			currentPageIndex = 0;
			
			[self forbidSearchMoreHotel];
			[listMapViewController resetAnnotations];
			[self checkDataNull];
            [self reloadList];
		}
		else if (kRequest_More == linkType) {
			// 更多时，服务器传值错误
			[self forbidSearchMoreHotel];
			[self reloadList];
		}
        else {
            grouponCount = 0;
			[allGroupons removeAllObjects];
			[listViewController.imageDic removeAllObjects];
			[listViewController.progressDic removeAllObjects];
			currentPageIndex = 0;
            
            [self forbidSearchMoreHotel];
			[listMapViewController resetAnnotations];
			[self checkDataNull];
            
            [self reloadList];
        }
	}
}

- (void)searchDetailInfoByHotelID:(NSString *)prodId
{
    currentPageIndex = listViewController.selIndex;
    
	if (orderView.isShowing) {
		[orderView dismissInView];
	}
    
    if (priceView.isShowing) {
		[priceView dismissInView];
	}
    
    if (![prodId isEqual:[NSNull null]] && [prodId intValue] != 0) {
        GDetailRequest *gDReq = [GDetailRequest shared];
        [gDReq setProdId:prodId];
        linkType = GODETAIL;
        
        if (detailRequest) {
            [detailRequest cancel];
            [detailRequest release],detailRequest = nil;
        }
        
        detailRequest = [[HttpUtil alloc] init];
        [detailRequest sendSynchronousRequest:GROUPON_SEARCH PostContent:[gDReq grouponDetailCompress:YES] CachePolicy:CachePolicyGrouponDetail Delegate:self];
    }
	else {
        [PublicMethods showAlertTitle:@"该团购已失效" Message:@"请选择其它酒店"];
    }
}

- (void)switchViews
{
    if (!IOSVersion_7)
    {
        // 防止IOS7做完动画以后出现页面出现问题
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT);
    }

	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:0.8];
    moreBtn.enabled = NO;
    [self performSelector:@selector(cancelunuseraction) withObject:nil afterDelay:1.8];

	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	
	if (!listMapViewController.view.superview) {
		// 翻转到地图
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
							   forView:self.view cache:YES];
		
		[self changeToDisMap];
        if (!IOSVersion_5) {
            [listMapViewController viewWillAppear:YES];
        }
	}
	else {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
							   forView:self.view cache:YES];
		[listMapViewController.view removeFromSuperview];
        mapIsDisplay = NO;
		[self performSelector:@selector(upDateRightBarButton) withObject:nil afterDelay:0.8];
		
		// 翻转到列表
        [self.view insertSubview:listViewController.view atIndex:0];
        
        listFooterView.hidden	= NO;
        galleryFilterBtn.hidden = YES;
        mapFooterView.hidden	= YES;
        
        if (!IOSVersion_5) {
            [listViewController viewWillAppear:YES];
        }
	}
	
	[UIView commitAnimations];
}

- (void)cancelunuseraction
{
    moreBtn.enabled = YES;
}

// 关键词搜索
- (void) searchGrouponWithKeyword:(NSString *)keyword_ hitType:(NSInteger) hitType
{
    if (UMENG) {
        if (keyword_) {
            //团购关键词搜索
            [MobClick event:Event_GrouponHotelKeyword];
            
        }
    }
    
    // 重置
    GListRequest *request = [GListRequest shared];
    [request clearData];
    [self setBarItemDefaultStyle];
    [request setCityName:self.currentGrouponCity];
    self.currentOrder = @"";

    request.keyword = nil;
    request.hitType = [NSString stringWithFormat:@"%d", hitType];
    if (keyword_) {
        if ([request.aioCondition safeObjectForKey:@"BizSection"]) {
            [request setBizsectionID:[request.aioCondition safeObjectForKey:@"BizSection"]];
        }else if([request.aioCondition safeObjectForKey:@"District"]){
            [request setDistrictID:[request.aioCondition safeObjectForKey:@"District"]];
        }else{
            request.keyword = [request.aioCondition safeObjectForKey:@"Keyword"];
        }
    }
    
    
    linkType					= CHANGECITY;
    request.ImageSizeType   = 1;
    [request setLongitude:0];
    [request setLatitude:0];
    [request restoreGrouponListReqest];
    
    self.keyword = keyword_;
    
    self.displayName = self.currentGrouponCity;
    
    if (!request.keyword) {
        [Utils request:GROUPON_SEARCH req:[request grouponListCompress:YES] policy:CachePolicyGrouponList delegate:self];
    }else{
        [Utils request:GROUPON_SEARCH req:[request grouponKeywordSearchCompress:YES] policy:CachePolicyGrouponList delegate:self];
    }
}

#pragma mark -
#pragma mark PriceChangeDelegate Delegate
- (void) changePrice:(int) minPrice maxPrice:(int) maxPrice
{
    if (maxPrice >= GrouponMaxMaxPrice && minPrice >0) {
        priceItem.titleLabel.text = [NSString stringWithFormat:@"%d-不限",minPrice];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-不限",minPrice];
        priceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_price_h.png"];
        mapPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_price_h.png"];
//        priceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
//        mapPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
    }else if(minPrice <= 0 && maxPrice >= GrouponMaxMaxPrice){
        priceItem.titleLabel.text = [NSString stringWithFormat:@"价格范围"];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"价格范围"];
        priceItem.customerIcon = nil;
        mapPriceItem.customerIcon = nil;
        priceItem.customerTitleColor = nil;
        mapPriceItem.customerTitleColor = nil;
    }else{
        priceItem.titleLabel.text = [NSString stringWithFormat:@"%d-%d",minPrice,maxPrice];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-%d",minPrice,maxPrice];
        priceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_price_h.png"];
        mapPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_price_h.png"];
//        priceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
//        mapPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
    }
    
    // 团购价格筛选
    if(UMENG){
        [MobClick event:Event_GrouponHotelFilter_Price];
    }
    
    NSLog(@"%d-%d",minPrice,maxPrice);
    GListRequest *cityListReq = [GListRequest shared];
	[cityListReq restoreGrouponListReqest];
    
    if (maxPrice==GrouponMaxMaxPrice) {
        maxPrice=-1;
    }
	
	[cityListReq setMinPrice:minPrice];
	[cityListReq setMaxPrice:maxPrice];
    
//    [self updateFilterIcon];
    linkType = kReloadListType;
    
	[Utils request:GROUPON_SEARCH req:[cityListReq grouponListCompress:YES] policy:CachePolicyGrouponList delegate:self];
}

#pragma mark -
#pragma mark Net Delegate
- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (moreRequest == util) {
        [moreRequest release],moreRequest = nil;
        // 开放收藏功能
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        [listViewController resetListFooterView];
    }else if(favRequest == util){
        [favRequest release],favRequest = nil;
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@", root);
	
	if ([Utils checkJsonIsError:root]) {
        if (util == moreRequest) {
             [listViewController resetListFooterView];
        }
		return;
	}
	
    if (util == moreRequest) {
        if (moreRequest) {
            [moreRequest release],moreRequest = nil;
        }

        // 更新本页数据(排序，切换地区)
        linkType = kRequest_More;
        [self setListGrouponInfo:root];
        if ([root safeObjectForKey:@"CityName"]) {
            if (![[root safeObjectForKey:@"CityName"] isEqualToString:self.currentGrouponCity]) {
                self.currentGrouponCity = [root safeObjectForKey:@"CityName"];
                self.displayName = self.currentGrouponCity;
            }
        }
        
        
        [self setGrouponCity:self.displayName];
        
        [originArray release];
        originArray = nil;
        
        // 开放收藏功能
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else if(util == favRequest)
    {
        GrouponFavorite *favorite = [[GrouponFavorite alloc]initWithEditStyle:YES grouponDict:root];
        
        [self.navigationController pushViewController:favorite animated:YES];
        [favorite release];
    }
    else if(util == detailRequest){
        // 进入详情页面
        [PublicMethods showAvailableMemory];
        NSMutableDictionary *mRoot = [NSMutableDictionary dictionaryWithDictionary:root];
        if (cacheFileCreateTime) {
            // 如果有缓存，需要把剩余时间减掉缓存时间
            double newLeftTime = [[root safeObjectForKey:LEFTTIME_GROUPON] doubleValue] - cacheFileCreateTime * 1000;
            [mRoot safeSetObject:[NSNumber numberWithDouble:newLeftTime] forKey:LEFTTIME_GROUPON];
        }
        
        if ([mRoot objectForKey:@"ProductDetail"]==[NSNull null]) {
            [PublicMethods showAlertTitle:nil Message:@"该团购产品已过期"];
            return;
        }
        GrouponDetailViewController *controller = [[GrouponDetailViewController alloc] initWithDictionary:mRoot addtionalInfos:[[allGroupons safeObjectAtIndex:listViewController.selIndex] safeObjectForKey:@"HotelServices"]];
        controller.salesNum = [[[allGroupons safeObjectAtIndex:listViewController.selIndex] safeObjectForKey:@"SaleNums"] intValue];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    else
    {
        if (kCityListType == linkType) {
            // 获取团购城市列表
            if ([Utils checkJsonIsError:root]) {
                return;
            }
            
            GListRequest *listReq = [GListRequest shared];
            listReq.grouponCitys  = [root safeObjectForKey:CITYS_GROUPON];
            
            if ([listReq.grouponCitys count] > 0) {
                if (cityChooseVC==nil) {
                    cityChooseVC		= [[GrouponCityChooseViewController alloc] init];
                    cityChooseVC.root	= self;
                }
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityChooseVC];
                
                if (IOSVersion_7) {
                    nav.transitioningDelegate = [ModalAnimationContainer shared];
                    nav.modalPresentationStyle = UIModalPresentationCustom;
                }
                if (IOSVersion_7) {
                    [self presentViewController:nav animated:YES completion:nil];
                }else{
                    [self presentModalViewController:nav animated:YES];
                }
                [nav release];
            }
            else {
                [PublicMethods showAlertTitle:nil Message:@"未能获取城市列表"];
            }
            
            [self updateFilterIcon];
        }
        else {
            // 更新本页数据(排序，切换地区)
            [self setListGrouponInfo:root];
            if ([root safeObjectForKey:@"CityName"]) {
                if (![[root safeObjectForKey:@"CityName"] isEqualToString:self.currentGrouponCity]) {
                    self.currentGrouponCity = [root safeObjectForKey:@"CityName"];
                    self.displayName = self.currentGrouponCity;
                }
            }
            
            [self setGrouponCity:self.displayName];
            [[Profile shared] end:@"团购搜索"];
            
            [originArray release];
            originArray = nil;
        }
    }
}

#pragma mark -
#pragma mark CustomSegmented Delegate

- (void)changeMode
{
	if (!listViewController) {
        listViewController = [[GrouponListViewController alloc] init];
        listViewController.homeVC = self;
    }
    if (!listViewController.view.superview) {
        [segButton setBackgroundImage:[UIImage noCacheImageNamed:@"switch_right_groupon_n.png"] forState:UIControlStateNormal];
        [segButton setBackgroundImage:[UIImage noCacheImageNamed:@"switch_right_groupon_h.png"] forState:UIControlStateHighlighted];
        
        if (orderView.isShowing) {
            [orderView dismissInView];
        }
        
        if (priceView.isShowing) {
            [priceView dismissInView];
        }
        
        [self.view insertSubview:listViewController.view atIndex:0];
        
        [self reloadList];
        
        if ([allGroupons count] > 0) {
            [listViewController.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentPageIndex-1 inSection:0]
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:NO];
        }
        listFooterView.hidden	= NO;
        galleryFilterBtn.hidden = YES;
    }
}

#pragma mark -
#pragma mark GalleryFilterViewControllerDelegate

- (void)galleryFilterVCSlideBack
{
    if (listViewController && !IOSVersion_5) {
        [listViewController viewWillAppear:YES];
    }
    if (listMapViewController && !IOSVersion_5) {
        [listMapViewController viewWillAppear:YES];
    }
}

#pragma mark -
#pragma mark FilterDelegate

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView
{
	self.currentOrder = filterStr;
    if ([filterStr isEqualToString:orderStrings[1]]) {
        UMENG_EVENT(UEvent_Groupon_List_SortNearby)
    }else if([filterStr isEqualToString:orderStrings[2]]) {
        UMENG_EVENT(UEvent_Groupon_List_PriceLow2High)
    }else if([filterStr isEqualToString:orderStrings[3]]) {
        UMENG_EVENT(UEvent_Groupon_List_PriceHigh2Low)
    }else if([filterStr isEqualToString:orderStrings[4]]){
        UMENG_EVENT(UEvent_Groupon_List_SalesLow2High)
    }else if([filterStr isEqualToString:orderStrings[5]]){
        UMENG_EVENT(UEvent_Groupon_List_SalesHigh2Low)
    }
    
    
	// 对团购进行排序
	if (NO == [self isAllData]) {
		// 如果没有显示所有数据时，重新发起请求
		linkType = ORDER;
        GListRequest *glistReq = [GListRequest shared];
        [glistReq restoreGrouponListReqest];
        
        //距离最近，清空条件
        if ([filterStr isEqualToString:orderStrings[1]])
        {
            [glistReq clearData];
            [self setBarItemDefaultStyle];
            [glistReq setLatitude:[[PositioningManager shared] myCoordinate].latitude];
            [glistReq setLongitude:[[PositioningManager shared] myCoordinate].longitude];
            [glistReq orderByType:filterStr];
        }
        else if ([self.displayName isEqualToString:@"当前位置"])
        {
            //默认排序走距离最近
            if ([filterStr isEqualToString:orderStrings[0]])
            {
                [glistReq orderByType:orderStrings[1]];//按距离最近排序
            }
            else
            {
                [glistReq orderByType:filterStr];
            }
            
            [glistReq setLatitude:[[PositioningManager shared] myCoordinate].latitude];
            [glistReq setLongitude:[[PositioningManager shared] myCoordinate].longitude];
        }
        else {
            [glistReq setLatitude:0];
            [glistReq setLongitude:0];
            [glistReq orderByType:filterStr];
        }
        [Utils request:GROUPON_SEARCH req:[glistReq grouponListCompress:YES] policy:CachePolicyGrouponList delegate:self];
	}
	else {
		// 本地排序
		if (!originArray) {
			// 记录默认排序数组
			originArray = [[NSArray alloc] initWithArray:allGroupons copyItems:YES];
		}
		
		if ([filterStr isEqualToString:orderStrings[0]]) {
			// 默认排序
			[self grouponListOrderByArray:originArray];
		}
		else if ([filterStr isEqualToString:orderStrings[2]]) {
			// 价格从低到高
			[self priceSortByAscend:YES];
		}
		else if ([filterStr isEqualToString:orderStrings[3]]) {
			// 价格从高到低
			[self priceSortByAscend:NO];
		}
		else if ([filterStr isEqualToString:orderStrings[4]]) {
			// 销量从低到高
			[self salNumSortByAscend:YES];
		}
		else if ([filterStr isEqualToString:orderStrings[5]]) {
			// 销量从高到低
			[self salNumSortByAscend:NO];
		}
        else {
            // 距离从近到远
        }
	}
    
    [self changetBarItemStyle:filterStr];
    
    if(UMENG){
        //团购酒店排序页点击确定
        [MobClick event:Event_GrouponHotelSort_Confirm label:filterStr];
    }
}

//设置低栏的默认状态 重置搜索状态时调用
-(void) setBarItemDefaultStyle
{
    //排序
    sortItem.customerIcon = nil;
    sortItem.customerTitleColor = nil;
    sortItem.titleLabel.text = @"排序";
    
    //价格
    priceItem.titleLabel.text = [NSString stringWithFormat:@"价格范围"];
    mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"价格范围"];
    priceItem.customerIcon = nil;
    mapPriceItem.customerIcon = nil;
    priceItem.customerTitleColor = nil;
    mapPriceItem.customerTitleColor = nil;
    
    if (priceView) {
        [priceView resetToZero];
    }
}

//根据选中改变下边bar的icon
-(void) changetBarItemStyle:(NSString *)filterStr
{
    if (STRINGHASVALUE(filterStr))
    {
        if ([filterStr isEqualToString:@"默认排序"])
        {
            sortItem.customerIcon = nil;
            sortItem.customerTitleColor = nil;
            sortItem.titleLabel.text = @"排序";
        }
        else if ([filterStr isEqualToString:@"距离最近"])
        {
            sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
//            sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
            sortItem.titleLabel.text=@"由近及远";
        }
        else if ([filterStr isEqualToString:@"价格从低到高"])
        {
            sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
//            sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
            sortItem.titleLabel.text=@"价格升序";
        }
        else if ([filterStr isEqualToString:@"价格从高到低"])
        {
            sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
//            sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
            sortItem.titleLabel.text=@"价格降序";
        }
        else if ([filterStr isEqualToString:@"销量从低到高"])
        {
            sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
//            sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
            sortItem.titleLabel.text=@"销量升序";
        }
        else if ([filterStr isEqualToString:@"销量从高到低"])
        {
            sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
//            sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
            sortItem.titleLabel.text=@"销量降序";
        }
    }
    else
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort.png"];
        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
        sortItem.titleLabel.text=@"排序";
    }
}

#pragma mark - SearchFilterControllerDelegate

// 退出
- (void)searchFilterControllerDidCancel:(SearchFilterController *)filter
{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

// 确定
- (void)searchFilterController:(SearchFilterController *)filter didFinishedWithInfo:(NSDictionary *)info
{
    self.keyword = nil;
    
    GListRequest *cityListReq = [GListRequest shared];
    
	[cityListReq restoreGrouponListReqest];
	[cityListReq setStarLevel:[[info safeObjectForKey:@"StarLevel"] integerValue]];
//	[cityListReq setMinPrice:[[info safeObjectForKey:@"MinPrice"] integerValue]];
//	[cityListReq setMaxPrice:[[info safeObjectForKey:@"MaxPrice"] integerValue]];
    
    NSDictionary *location = [info safeObjectForKey:@"Location"];
    
    NSString *name = [location safeObjectForKey:@"Name"];
    NSString *districtId = [location safeObjectForKey:@"DistrictId"];
    NSString *businessAreaId = [location safeObjectForKey:@"BusinessAreaId"];
    double lat = [[location safeObjectForKey:@"Lat"] doubleValue];
    double lng = [[location safeObjectForKey:@"Lng"] doubleValue];
    
    [cityListReq setLocationName:name];
    
    if ([businessAreaId integerValue] != 0) {
        [cityListReq setLatitude:0];
        [cityListReq setLongitude:0];
        [cityListReq setBizsectionID:businessAreaId];
        [cityListReq setDistrictID:nil];
//        currentOrder = @"默认排序";
    }
    else if ([districtId integerValue] != 0) {
        [cityListReq setLatitude:0];
        [cityListReq setLongitude:0];
        [cityListReq setBizsectionID:nil];
        [cityListReq setDistrictID:districtId];
//        currentOrder = @"默认排序";
    }
    else {
        [cityListReq setBizsectionID:nil];
        [cityListReq setDistrictID:nil];
//        currentOrder = @"默认排序";
        
        if (self.displayName&&[self.displayName isEqualToString:@"当前位置"])
        {
            //当前位置不赋值经纬度
        }
        else
        {
            [cityListReq setLatitude:lat];
            [cityListReq setLongitude:lng];
        }
    }
    
    [cityListReq setBrandId];
    [cityListReq setTypeId];
    
    [self updateFilterIcon];
    linkType = kReloadListType;
    
	[Utils request:GROUPON_SEARCH req:[cityListReq grouponListCompress:YES] policy:CachePolicyGrouponList delegate:self];
    
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
