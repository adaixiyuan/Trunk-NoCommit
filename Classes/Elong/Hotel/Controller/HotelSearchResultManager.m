//
//  SearchHotelResultManager.m
//  ElongClient
//
//  Created by bin xing on 11-2-7.
//  Copyright 2011 DP. All rights reserved.
//

#import "HotelSearchResultManager.h"
#import "HotelConditionRequest.h"
#import "AreaInfo.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "ElongClientAppDelegate.h"
#import "HotelKeywordViewController.h"
#import "HotelSearchFilterController.h"
#import "HotelFavorite.h"
#import "CacheManage.h"
#import "MyElongCenter.h"
#import "FilterViewController.h"
#import "FilterSidebarItem.h"
#import "CountlyEventHotelListPageFilter.h"
#import "CountlyEventClick.h"

#define kCityName		[[HotelPostManager hotelsearcher] getObject:ReqHS_CityName_S]		// 获取当前城市名

@interface  HotelSearchResultManager ()

@property (nonatomic, retain) UIBarButtonItem *originItem;			// 刚进页面时的barbutton
@property (nonatomic, retain) UIBarButtonItem *moreItem;            // 地图模式更多按钮
@property (nonatomic, assign) BOOL distanceSort;

@property (nonatomic, retain) HotelSearchFilterController *filter;

@end

@implementation HotelSearchResultManager

@synthesize originItem;
@synthesize moreItem;
@synthesize moreBtn;
@synthesize isMaximum;
@synthesize orderView;
@synthesize keyword;
@synthesize selRow;


#pragma mark -
#pragma mark Dealloc

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    if (IOSVersion_6 && [self.view window] == nil) {
        self.view = nil;
        listModelItem = nil;
        mapModelItem = nil;
        SFRelease(mapmode);
        SFRelease(listmode);
    }
}

- (void)viewDidUnload{
    [super viewDidUnload];
	
	SFRelease(mapmode);
	SFRelease(listmode);
}

- (void)dealloc{
	[[FastPositioning shared] stopPosition];
	
	self.originItem = nil;
	self.moreItem = nil;
	self.moreBtn = nil;
    self.favBtn = nil;
    self.keyword = nil;
    
    if (hotelAreaUtil) {
        [hotelAreaUtil cancel];
        SFRelease(hotelAreaUtil);
    }
    
    if (hotelThemeUtil) {
        [hotelThemeUtil cancel];
        SFRelease(hotelThemeUtil);
    }
	
	[listmode release];
    
    if (orderView) {
        [orderView release];
    }
    
	[mapmode release];
    [[HotelSearch hotels] removeAllObjects];    // 清空静态数据
    
    [keywordVC release];
    
    [_filter release];
    [priceView release];
    
    
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [hotelsearcher clearBuildData];
    
    
	
    [super dealloc];
}

- (void)back{
    
    if (listmode.view.superview == nil) {
        // mapview
        // 后退点击事件 countly
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACK;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }else{
        // listview
        // 后退点击事件 countly
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELLISTPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACK;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }
    
	[mapmode stopAllMapReq];
	
	[super back];
}


#pragma mark -
#pragma mark Alloc
- (id)initWithTitle:(NSString *)titleStr{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    if ([HotelSearch isPositioning] && [hotelsearcher getIsPos]) {
        titleStr = [NSString stringWithFormat:@"       周边(%d家)       ", [HotelSearch hotelCount]];
    }else{
        titleStr = [NSString stringWithFormat:@"    %@(%d家)    ", kCityName, [HotelSearch hotelCount]];
    }
    
    if ([titleStr isEqualToString:kCityName]) {
        titleStr = [NSString stringWithFormat:@"%@               ", kCityName];
    }
    //hotel_ico.png
	if (self = [super initWithTopImagePath:@"" andTitle:titleStr style:_NavNoTelStyle_]) {
		refreshSearchTag = NO;
	}
    
	return self;
}


- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (listmode.selectIndexPath) {
        [listmode.listTableView deselectRowAtIndexPath:listmode.selectIndexPath animated:YES];
    }
}

- (void)viewDidLoad{
	[super viewDidLoad];
    
    isMaximum = NO;
    
    // 收藏
    self.favBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
    self.favBtn.exclusiveTouch = YES;
    self.favBtn.adjustsImageWhenDisabled = NO;
    self.favBtn.titleLabel.font = FONT_B15;
	[self.favBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
    [self.favBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [self.favBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
	[self.favBtn addTarget:self action:@selector(getFavList) forControlEvents:UIControlEventTouchUpInside];
    
	self.originItem = [[[UIBarButtonItem alloc] initWithCustomView:self.favBtn] autorelease];
    
    self.navigationItem.rightBarButtonItem =  self.originItem;
	
    // 现实更多
	self.moreBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
    self.moreBtn.exclusiveTouch = YES;
	moreBtn.adjustsImageWhenDisabled = NO;
    moreBtn.titleLabel.font = FONT_B15;
	[moreBtn setTitle:@"显示更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
	[moreBtn addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	self.moreItem = [[[UIBarButtonItem alloc] initWithCustomView:moreBtn] autorelease];

    // 地图和列表底部工具栏
	[self addListFooterView];
	[self addMapFooterView];
	
	if ([[SettingManager instanse] getMapPriority]) {
		// 如果是周边查询且选择优先显示地图时，初始显示地图
		mapmode = [[HotelMapMode alloc] init];
		mapmode.rootController = self;
		[self.view insertSubview:mapmode.view atIndex:0];
		listFooterView.hidden	= YES;
		mapFooterView.hidden	= NO;
        
		self.navigationItem.rightBarButtonItem = moreItem;
		[self goCenter];
	}
	else {
		listmode = [[HotelListMode alloc] init];
		listmode.rootController = self;
		[self.view insertSubview:listmode.view atIndex:0];
		listFooterView.hidden	= NO;
		mapFooterView.hidden	= YES;
        
        // 周边酒店清除searchbar.text by dawn
        if ([HotelSearch isPositioning]) {
            listmode.keywordVC.searchBar.text = @"";
        }
	}
    
    [self performSelector:@selector(preLoadSearchCondition) withObject:nil afterDelay:0.1];
    
    if ([HotelSearch isPositioning]){
        [self addAddressTips];
    }
    
    
    // 刷新筛选状态
    [self updateFilterIcon];
    
    // 刷新价格状态
    [self updatePriceIcon];
}

#pragma mark -
#pragma mark Private Mehtods

// 周边搜索位置提示
- (void) addAddressTips{
    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20 - 44 - 65, SCREEN_WIDTH, 20)];
    addressLbl.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    addressLbl.textColor = [UIColor whiteColor];
    
    addressLbl.font = [UIFont boldSystemFontOfSize:13.0f];
    NSString *addressName = [[PositioningManager shared] getAddressName];
    if(addressName){
        addressLbl.hidden = NO;
        addressLbl.text = [NSString stringWithFormat:@"  当前位置：%@  ", addressName];
    }else{
        addressLbl.hidden = YES;
    }
    [self.view addSubview:addressLbl];
    [addressLbl release];
}

// 列表底部工具栏
-(void)addListFooterView{
	listFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20 - 44 - 45, 320, 45)];
    listFooterView.delegate = self;
    
    // 地图
    mapModelItem = [[BaseBottomBarItem alloc] initWithTitle:@"地图"
                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                                                      image:@"basebar_map.png"
                                            highligtedImage:@"basebar_map_h.png"];
    // 筛选
    listFilterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                                                    titleFont:[UIFont systemFontOfSize:12.0f]
                                                        image:@"basebar_filter.png" highligtedImage:@"basebar_filter_h.png"];
    
    // 排序
    if ([HotelSearch isPositioning]==YES){
        sortItem = [[BaseBottomBarItem alloc] initWithTitle:@"由近及远"
                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                                                      image:@"basebar_sort.png" highligtedImage:@"basebar_sort_h.png"];
    }
    else{
        sortItem = [[BaseBottomBarItem alloc] initWithTitle:@"排序"
                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                                                      image:@"basebar_sort.png" highligtedImage:@"basebar_sort_h.png"];
    }
    
    // 价格
    listPriceItem = [[BaseBottomBarItem alloc] initWithTitle:@"价格范围"
                                                   titleFont:[UIFont systemFontOfSize:12.0f]
                                                       image:@"basebar_starprice.png" highligtedImage:@"basebar_starprice_h.png"];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    
    [itemArray addObject:listFilterItem];
    listFilterItem.allowRepeat = YES;
    listFilterItem.autoReverse = YES;
    [listFilterItem release];
    
    [itemArray addObject:listPriceItem];
    listPriceItem.allowRepeat = YES;
    listPriceItem.autoReverse = YES;
    [listPriceItem release];
    
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

// 地图底部工具栏
-(void)addMapFooterView{
	mapFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20 - 44 - 45, 320, 45)];
    mapFooterView.delegate = self;
    BaseBottomBarItem *locationItem = [[BaseBottomBarItem alloc] initWithTitle:@"当前位置"
                                                                     titleFont:[UIFont systemFontOfSize:12.0f]
                                                                         image:@"basebar_location.png"
                                                               highligtedImage:@"basebar_location_h.png"];
    
    //goCenter
    BaseBottomBarItem *destinationItem = [[BaseBottomBarItem alloc] initWithTitle:@"目的地"
                                                                        titleFont:[UIFont systemFontOfSize:12.0f]
                                                                            image:@"basebar_map.png"
                                                                  highligtedImage:@"basebar_map_h.png"];
    
    
    
    //selectPin
    mapFilterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                                                   titleFont:[UIFont systemFontOfSize:12.0f]
                                                       image:@"basebar_filter.png" highligtedImage:@"basebar_filter_h.png"];
    
    listModelItem = [[BaseBottomBarItem alloc] initWithTitle:@"列表"
                                                   titleFont:[UIFont systemFontOfSize:12.0f]
                                                       image:@"basebar_list.png"
                                             highligtedImage:@"basebar_list_h.png"];
    
    // 价格
    mapPriceItem = [[BaseBottomBarItem alloc] initWithTitle:@"价格星级"
                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                                                      image:@"basebar_starprice.png" highligtedImage:@"basebar_starprice_h.png"];
    
	//switchViews
    NSMutableArray *itemArray = [NSMutableArray array];
    [itemArray addObject:locationItem];
    locationItem.allowRepeat = YES;
    locationItem.autoReverse = YES;
    [locationItem release];
    
    [itemArray addObject:destinationItem];
    destinationItem.allowRepeat = YES;
    destinationItem.autoReverse = YES;
    [destinationItem release];
    
    [itemArray addObject:mapPriceItem];
    mapPriceItem.allowRepeat = YES;
    mapPriceItem.autoReverse = YES;
    [mapPriceItem release];
    
    [itemArray addObject:mapFilterItem];
    mapFilterItem.allowRepeat = YES;
    mapFilterItem.autoReverse = YES;
    [mapFilterItem release];
    
    [itemArray addObject:listModelItem];
    listModelItem.allowRepeat = YES;
    listModelItem.autoReverse = YES;
    [listModelItem release];
    
    mapFooterView.baseBottomBarItems = itemArray;
    
	[self.view addSubview:mapFooterView];
	[mapFooterView release];
}

// 预加载商圈、行政区、品牌和主题
- (void)preLoadSearchCondition{
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [searchReq setSearchCity:[hotelsearcher cityName]];
    if (![searchReq isAllDataLoaded]) {
        [searchReq clearDataOnly];
        hotelsearcher.isChain = NO;
        if (hotelAreaUtil) {
            [hotelAreaUtil cancel];
            SFRelease(hotelAreaUtil);
        }
        hotelAreaUtil = [[HttpUtil alloc] init];
        [hotelAreaUtil sendAsynchronousRequest:OTHER_SEARCH PostContent:[searchReq requestForAllCondition] CachePolicy:CachePolicyHotelArea Delegate:self];
    }
    if (![searchReq isThemeDataLoaded]) {
        if (hotelThemeUtil) {
            [hotelThemeUtil cancel];
            SFRelease(hotelThemeUtil);
        }
        hotelThemeUtil = [[HttpUtil alloc] init];
        [hotelThemeUtil sendAsynchronousRequest:HOTELSEARCH PostContent:[searchReq requestForThemes] CachePolicy:CachePolicyNone Delegate:self];
    }
}

// 更新右上角按钮
- (void)upDateNavBar{
	
	if (listmode.view.superview) {
		// 列表模式
		self.navigationItem.rightBarButtonItem = self.originItem;
	}
	else {
		// 地图模式
		self.navigationItem.rightBarButtonItem = self.moreItem;
	}
}

// 重置关键词
- (void) resetKeywordFromMap{
    self.keyword = nil;
    listmode.keywordVC.searchBar.text = nil;
    // 清空记录
    [listmode.keywordVC cancelSearchCondition];
    [self searchHotelWithKeyword:nil];
}

// 关键词搜索
- (void)searchHotelWithKeyword:(NSString *)keyword_{
    if(UMENG){
        if(keyword_){
            //酒店关键词搜索
            [MobClick event:Event_HotelKeyword];
            
            
        }
    }
    
    UMENG_EVENT(UEvent_Hotel_List_Keyword)
    
    // countly 搜索框点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELLISTPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_SEARCHBAR;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    
    // 重置筛选条件
    if ([HotelSearch hotelSearch]) {
        [[HotelSearch hotelSearch] resetSearchCondition];
    }
   
    
    if (!keyword_) {
        // 设置搜索条件
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                            object:self
                                                          userInfo:[NSDictionary dictionaryWithObject:@"" forKey:HOTEL_SEARCH_KEYWORD]];
        
        
        HotelConditionRequest *request = [HotelConditionRequest shared];
        [request clearKeywordFilter];
        
        [self researchHotel];
        [self updateFilterIcon];
    }else{
        NSString *cityName = [NSString stringWithFormat:@"%@",kCityName];
        self.keyword = [NSString stringWithFormat:@"%@",keyword_];
        
        //把搜索城市存入本地
        [[ElongUserDefaults sharedInstance] setObject:cityName forKey:USERDEFAULT_HOTEL_SEARCHCITYNAME];
        
        // 记录历史关键词
        if (STRINGHASVALUE(self.keyword)) {
            HotelConditionRequest *request = [HotelConditionRequest shared];
            NSString *city = [NSString stringWithFormat:@"%@",cityName];
            NSString *key = [NSString stringWithFormat:@"%@",self.keyword];
            NSNumber *type = nil;
            NSNumber *pid = nil;
            NSNumber *lat = nil;
            NSNumber *lng = nil;
            
            type = NUMBER(request.keywordFilter.keywordType);
            if (request.keywordFilter.keywordType == HotelKeywordTypeBrand) {
                pid = [NSNumber numberWithInt:request.keywordFilter.pid];
            }else if (request.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation
                      || request.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
                      || request.keywordFilter.keywordType == HotelKeywordTypePOI) {
                lat = [NSNumber numberWithFloat:request.keywordFilter.lat];
                lng = [NSNumber numberWithFloat:request.keywordFilter.lng];
            }
            
            [PublicMethods saveSearchKey:key type:type propertiesId:pid lat:lat lng:lng forCity:city];
        }
        
        // 清空搜索条件
        [hotelsearcher resetPosition];
        [HotelSearch setPositioning:NO];
        
        HotelConditionRequest *request = [HotelConditionRequest shared];
//        if (keyword_ != nil && keyword_.length > 0)
        if (keyword_ != nil)
        {
            // 有搜索条件时
            if (request.keywordFilter.keywordType == HotelKeywordTypeBrand) {
                // 品牌记录
                [hotelsearcher setBrandIDs:[NSString stringWithFormat:@"%d",request.keywordFilter.pid]];
            }else if(request.keywordFilter.keywordType == HotelKeywordTypeBusiness
                     || request.keywordFilter.keywordType == HotelKeywordTypeDistrict){
                // 商圈或行政区
                [hotelsearcher setAreaName:request.keywordFilter.keyword];
            }else if (request.keywordFilter.keywordType == HotelKeywordTypeNormal){
                // 酒店名
                [hotelsearcher setHotelName:request.keywordFilter.keyword];
            }else if (request.keywordFilter.keywordType == HotelKeywordTypePOI
                      || request.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
                      || request.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation){
                // 经纬度搜索
                [hotelsearcher setCurrentPos:HOTEL_NEARBY_RADIUS Longitude:request.keywordFilter.lng Latitude:request.keywordFilter.lat];
            }
            
            [self researchHotel];
        }
        
        [self updateFilterIcon];
    }
    
}

// 更新筛选按钮的指示灯
- (void)updateFilterIcon{
    
    
    if ([HotelSearchFilterController filterLightWithLM:NO]) {
        listFilterItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_filter_mark.png"];
        mapFilterItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_filter_mark.png"];
        listFilterItem.customerTitleColor = nil;
        mapFilterItem.customerTitleColor = nil;
        
        UMENG_EVENT(UEvent_Hotel_List_FilterAction)
    }
    else {
        listFilterItem.customerIcon = nil;
        listFilterItem.customerTitleColor = nil;
        mapFilterItem.customerTitleColor = nil;
        mapFilterItem.customerIcon = nil;
        
        UMENG_EVENT(UEvent_Hotel_List_FilterReset)
    }
    
    
}

// 更新价格按钮的指示灯
- (void) updatePriceIcon{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    NSInteger minPrice = [[hotelsearcher getMinPrice] intValue];
    NSInteger maxPrice = [[hotelsearcher getMaxPrice] intValue];
    if (minPrice < 0) {
        minPrice = 0;
    }
    if (maxPrice < 0) {
        maxPrice = GrouponMaxMaxPrice;
    }
    
    // 星级
    BOOL haveStar = NO;
    NSArray *starIndexs = [hotelsearcher getStarCodeIndexs];
    if (starIndexs && starIndexs.count) {
        if ([[starIndexs objectAtIndex:0] intValue] != -1 && [[starIndexs objectAtIndex:0] intValue] != 0) {
            haveStar = YES;
        }
    }else{
        haveStar = YES;
    }

    
    [self resetHotelMinPrice:minPrice maxPrice:maxPrice star:haveStar];
}


// 更新排序按钮指示灯
- (void) updateSortIcon{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    NSInteger orderby = [hotelsearcher getOrderBy];
    if (orderby == 0) {
        [self changetBarItemStyle:0];
        [orderView selectRow:0];
    }
}

// 刷新列表
- (void)refreshListByDictionary:(NSDictionary *)sourceDic{
    [self refreshTitle];
    
    // 刷新列表数据
    NSMutableArray *hotelArray = [NSMutableArray arrayWithArray:[sourceDic safeObjectForKey:RespHL_HotelList_A]];
    
    [[HotelSearch hotels] removeAllObjects];
    [[HotelSearch hotels] addObjectsFromArray:hotelArray];
    [HotelSearch setHotelCount:[[sourceDic safeObjectForKey:RespHL_HotelCount_I] intValue]];
    
    // 设置今日特价信息
    if ([sourceDic safeObjectForKey:@"HotelLmCnt"] != [NSNull null] && [sourceDic safeObjectForKey:@"HotelLmCnt"]) {
        [HotelSearch setTonightHotelCount:[[sourceDic safeObjectForKey:@"HotelLmCnt"] intValue]];
    }else{
        [HotelSearch setTonightHotelCount:0];
    }
    if ([sourceDic safeObjectForKey:@"MinPrice"] != [NSNull null] && [sourceDic safeObjectForKey:@"MinPrice"]) {
        [HotelSearch setTonightMinPrice:[[sourceDic safeObjectForKey:@"MinPrice"] floatValue]];
    }else{
        [HotelSearch setTonightMinPrice:0.0f];
    }
    
    listmode.hotelCount = [[HotelSearch hotels] count];
    mapmode.hotelCount = [[HotelSearch hotels] count];
    [listmode refreshData];
    [mapmode moveCurrentPin];
    [self refreshMapData];
}

// 刷新Title
- (void)refreshTitle{
    NSString *titleStr = nil;
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    if ([HotelSearch isPositioning] && [hotelsearcher getIsPos]) {
        titleStr = [NSString stringWithFormat:@"    周边(%d家)    ",[HotelSearch hotelCount]];
    }else{
        titleStr = [NSString stringWithFormat:@"    %@(%d家)    ",kCityName,[HotelSearch hotelCount]];
    }
    
    
    [self setNavTitle:titleStr];
}

//根据选中改变下边bar的icon
-(void) changetBarItemStyle:(NSInteger) index{
    if (index == 0){
        sortItem.customerIcon = nil;
        sortItem.customerTitleColor = nil;
        if ([HotelSearch isPositioning]==YES){
            sortItem.titleLabel.text=@"由近及远";
        }
        else{
            sortItem.titleLabel.text=@"排序";
        }
    }
    else if (index==1){
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
        sortItem.titleLabel.text=@"由近及远";
    }
    else if (index==2){
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
        sortItem.titleLabel.text=@"价格升序";
    }
    else if (index==3){
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
        sortItem.titleLabel.text=@"价格降序";
    }
    else if (index==4){
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
        sortItem.titleLabel.text=@"星级升序";
    }
    else if (index==5){
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
        sortItem.titleLabel.text=@"星级降序";
    }
    else if (index==6){
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
        sortItem.titleLabel.text=@"好评降序";
    }
    else{
        sortItem.customerIcon = nil;
        sortItem.customerTitleColor = nil;
        sortItem.titleLabel.text=@"排序";
    }
}


//重新筛选
- (void)researchHotel{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    requestType = 0;
    
    [listmode.moreHotelReq cancel];
    listmode.moreHotelReq = nil;
    listmode.listTableView.tableFooterView = nil;
    
    [Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] policy:CachePolicyHotelList delegate:self];
    
    [self updateFilterIcon];
    
    [self updatePriceIcon];
    
    [self updateSortIcon];
}

#pragma mark -
#pragma mark Actions
// 加载收藏列表
- (void)getFavList{
    if (UMENG) {
        //酒店列表进收藏酒店列表页面
        [MobClick event:Event_FavHotelList_List];
    }
    
    // countly mycollection
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELLISTPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_MYCOLLECTION;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    UMENG_EVENT(UEvent_Hotel_List_FavList)
    
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    HotelFavoriteRequest *jghf=[HotelPostManager favorite];
    
    NSString *cityId = [PublicMethods getCityIDWithCity:[hotelsearcher cityName]];
    if (cityId && ![cityId isEqualToString:@""]) {
        jghf.cityId = cityId;
    }else{
        jghf.cityId = nil;
    }
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (islogin) {
        requestType = -1;
        
        [Utils request:HOTELSEARCH req:[jghf request] delegate:self];
    }else {
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_HotelGetFavorite];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
    }
}

// 点击更多按钮
- (void)moreButtonPressed{
	[mapmode searchMoreHotel];
}

// 目的地
- (void)selectPin{
    if(listmode.hotelCount == 0){
        [PublicMethods showAlertTitle:nil Message:@"未找到酒店位置信息"];
        return;
    }
    [mapmode.searchDC setActive:NO animated:YES];
	[mapmode selectPin];
}

// 当前位置
- (void)goCenter{
    if(listmode.hotelCount == 0){
        [PublicMethods showAlertTitle:nil Message:@"未找到酒店位置信息"];
        return;
    }
	float zoomLevel = 0.05;
	MKCoordinateRegion currentRegion = mapmode.mapView.region;
    CLLocationCoordinate2D userloacation = mapmode.mapView.userLocation.location.coordinate;
    if (userloacation.longitude == 0 && userloacation.latitude == 0) {
        userloacation = [[PositioningManager shared] myCoordinate];
    }
	if (currentRegion.span.latitudeDelta > zoomLevel) {
		currentRegion = MKCoordinateRegionMake(userloacation, MKCoordinateSpanMake(zoomLevel,zoomLevel));
	}
    
	else {
		currentRegion = MKCoordinateRegionMake(userloacation, currentRegion.span);
	}
	[mapmode.searchDC setActive:NO animated:YES];
	[mapmode.mapView setRegion:currentRegion animated:YES];
}

// 列表地图切换
- (void)switchViews:(id)sender{
	self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, SCREEN_HEIGHT - 44 - 20);
	[PublicMethods showAvailableMemory];
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(upDateNavBar)];
    
    if (listmode.view.superview == nil){
        if (listmode == nil){
			listmode = [[HotelListMode alloc] init];
			listmode.rootController = self;
        }
		else {
			if (mapmode.isResearch) {
				[listmode refreshData];
				mapmode.isResearch = NO;
			}
			else {
				[listmode.listTableView reloadData];
			}
		}
		[self.view insertSubview:listmode.view atIndex:0];
        [mapmode.view removeFromSuperview];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:self.view cache:YES];
		listFooterView.hidden=NO;
		mapFooterView.hidden=YES;
    }
    else{
        if (mapmode == nil){
            mapmode = [[HotelMapMode alloc] init];
			mapmode.rootController = self;
        }else{
            [mapmode setKeyword];
        }
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        
        [listmode.view removeFromSuperview];
        [self.view insertSubview:mapmode.view atIndex:0];
		
		listFooterView.hidden=YES;
		mapFooterView.hidden=NO;
    }
    
    [UIView commitAnimations];
}


- (void)listSortedByArray:(NSArray *)array{
	[[HotelSearch hotels] removeAllObjects];
	[[HotelSearch hotels] addObjectsFromArray:array];
	
	[listmode.listTableView reloadData];
	[listmode.listTableView setContentOffset:CGPointMake(0, 0)];
	
	[mapmode reloadMap];
}

// 价格排序
- (void)priceSortByAscend:(BOOL)animated{
	NSSortDescriptor *sortDes = [[[NSSortDescriptor alloc] initWithKey:RespHL__LowestPrice_D ascending:animated] autorelease];
	NSArray *descriptors = [NSArray arrayWithObject:sortDes];
	NSArray *sorted = [[HotelSearch hotels] sortedArrayUsingDescriptors:descriptors];
	
	[self listSortedByArray:sorted];
}

// 星级排序
- (void)starLevelSortByAscend:(BOOL)animated{
	static NSString *starKey = @"starKey";
	for (NSMutableDictionary *dic in [HotelSearch hotels]) {
		NSInteger sortIndex = [[dic safeObjectForKey:NEWSTAR_CODE] intValue];
		if (sortIndex > 10) {
			sortIndex = round(sortIndex / 10.0f);
		}
		[dic safeSetObject:[NSNumber numberWithInt:sortIndex] forKey:starKey];
	}
	NSSortDescriptor *sortDes = [[[NSSortDescriptor alloc] initWithKey:starKey ascending:animated] autorelease];
	NSArray *descriptors = [NSArray arrayWithObject:sortDes];
	NSArray *sorted = [[HotelSearch hotels] sortedArrayUsingDescriptors:descriptors];
	[self listSortedByArray:sorted];
}

// 筛选
- (void)presentAreaChooseView{
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    [searchReq setIsFromLastMinute:NO];
    
    self.filter = nil;
    
    HotelSearchFilterController *filter = [[HotelSearchFilterController alloc] initWithTitle:@"筛选" style:NavBarBtnStyleOnlyBackBtn isLM:NO];
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    filter.cityName = hotelsearcher.cityName;
    filter.isLM = NO;
    filter.delegate = self;
    self.filter = filter;
    [filter release];
    
    NSMutableArray *sidebarArray = [NSMutableArray array];
    FilterSidebarItem *item = [[FilterSidebarItem alloc] init];
    item.title = @"区域位置";
    item.image = [UIImage noCacheImageNamed:@"filterPoi.png"];
    item.color = RGBACOLOR(220, 220, 220, 1);
    item.highlightColor = RGBACOLOR(210, 70, 36, 1);
    item.itemType = FilterSidebarItemRegion;
    [sidebarArray addObject:item];
    [item release];
    
    item = [[FilterSidebarItem alloc] init];
    item.title = @"酒店品牌";
    item.image = [UIImage noCacheImageNamed:@"filterBrand.png"];
    item.color = RGBACOLOR(220, 220, 220, 1);
    item.highlightColor = RGBACOLOR(210, 70, 36, 1);
    item.itemType = FilterSidebarItemBrand;
    [sidebarArray addObject:item];
    [item release];
    
    item = [[FilterSidebarItem alloc] init];
    item.title = @"支付方式";
    item.image = [UIImage noCacheImageNamed:@"filterPayType.png"];
    item.color = RGBACOLOR(220, 220, 220, 1);
    item.highlightColor = RGBACOLOR(210, 70, 36, 1);
    item.itemType = FilterSidebarItemPayType;
    [sidebarArray addObject:item];
    [item release];
    
    item = [[FilterSidebarItem alloc] init];
    item.title = @"促销方式";
    item.image = [UIImage noCacheImageNamed:@"filterPromotionType.png"];
    item.color = RGBACOLOR(220, 220, 220, 1);
    item.highlightColor = RGBACOLOR(210, 70, 36, 1);
    item.itemType = FilterSidebarItemPromotionType;
    [sidebarArray addObject:item];
    [item release];
    
    item = [[FilterSidebarItem alloc] init];
    item.title = @"设施服务";
    item.image = [UIImage noCacheImageNamed:@"filterFacility.png"];
    item.color = RGBACOLOR(220, 220, 220, 1);
    item.highlightColor = RGBACOLOR(210, 70, 36, 1);
    item.itemType = FilterSidebarItemFacility;
    [sidebarArray addObject:item];
    [item release];

    item = [[FilterSidebarItem alloc] init];
    item.title = @"住宿类型";
    item.image = [UIImage noCacheImageNamed:@"filterTheme.png"];
    item.color = RGBACOLOR(220, 220, 220, 1);
    item.highlightColor = RGBACOLOR(210, 70, 36, 1);
    item.itemType = FilterSidebarItemTheme;
    [sidebarArray addObject:item];
    [item release];
    
    filter.sidebarItems = sidebarArray;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filter];
    
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
    
    //[filter performSelector:@selector(presentAparmentNoteView) withObject:nil afterDelay:0.3];      //展示引导图
}

// 排序
- (void)orderBtnPressed:(id)sender{
	if (!orderView) {
        if ([HotelSearch isPositioning]) {
            orderView = [[HotelFilterView alloc] initWithShowDistanceSort:NO fromTonightHotelList:NO];
        }
        else {
            orderView = [[HotelFilterView alloc] initWithShowDistanceSort:YES fromTonightHotelList:NO];
        }

		[self.view addSubview:orderView.view];
	}else{
        if (orderView.view.superview != self.view) {
            [orderView.view removeFromSuperview];
        }
        [self.view addSubview:orderView.view];
        
    }
    orderView.delegate = self;
    if ([HotelSearch isPositioning]) {
        orderView.showDistanceFilter = NO;
    }
    else {
        HotelConditionRequest *searchReq = [HotelConditionRequest shared];
        if (searchReq.keywordFilter == nil) {
            orderView.showDistanceFilter = YES;
        }
        else {
            orderView.showDistanceFilter = NO;
        }
    }
	[orderView showInView];
}

// 价格
- (void) priceBtnPress
{

    if (!priceView)
    {
		priceView = [[StarAndPricePopViewController alloc] initWithTitle:@"价格星级" Datas:nil];
		priceView.starAndPricedelegate = self;
		[self.view addSubview:priceView.view];
    }
    
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [priceView setMinPrice:[[hotelsearcher getMinPrice] intValue] maxPrice:[[hotelsearcher getMaxPrice] intValue] starCodes:[[hotelsearcher getStarCodes] componentsJoinedByString:@","]];
    
    [priceView showInView];
}


#pragma mark -
#pragma mark PublicMethods

- (void)checkHotelFull{
	if ([[HotelSearch hotels] count] >= MAX_HOTEL_COUNT) {
		[listmode keepHotelNumber];
		[mapmode removeMapAnnotationsInRange:NSMakeRange(0, HOTEL_PAGESIZE)];
	}
}

- (void)refreshMapData{
    [self refreshTitle];
	[mapmode reloadMap];
}

- (void)forbidSearchMoreHotel{
	moreBtn.enabled = NO;
	[moreBtn setTitleColor:COLOR_NAV_BIN_TITLE_DISABLE forState:UIControlStateNormal];
	listmode.listTableView.tableFooterView = nil;
    [self refreshTitle];
}

- (void)restoreSearchMoreHotel{
	moreBtn.enabled = YES;
	[moreBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [self refreshTitle];
}

- (void)cancelOrderView{
	if (orderView.isShowing) {
		[orderView dismissInView];
	}
}


- (void)goHotelDetail{
    if ([[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelName_S] != [NSNull null]){
        HotelDetailController *hoteldetail = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
        if (self.selRow == -1) {
            hoteldetail.listImageUrl = nil;
        }else{
            hoteldetail.listImageUrl = [[[HotelSearch hotels] safeObjectAtIndex:self.selRow] safeObjectForKey:RespHL__PicUrl_S];
        }
        [self.navigationController pushViewController:hoteldetail animated:YES];
        [hoteldetail release];
        [hoteldetail setPsgRecommend:[[HotelSearch hotels] safeObjectAtIndex:self.selRow]];
    }
    else {
        if (listmode.selectIndexPath) {
            [listmode.listTableView deselectRowAtIndexPath:listmode.selectIndexPath animated:YES];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"酒店信息错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)setKeywordFromMap:(NSString *)kw{
    
    // countly 地图-搜索框点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_SEARCHBAR;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    UMENG_EVENT(UEvent_Hotel_ListMap_Keyword)
    self.keyword = kw;
    listmode.keywordVC.searchBar.text = kw;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE object:self userInfo:[NSDictionary dictionaryWithObject:kw forKey:HOTEL_SEARCH_KEYWORD]];
    
    [self updateFilterIcon];
}


#pragma mark -
#pragma mark HotelKeywordViewControllerDelegate

- (void)hotelKeywordVCDidBeginEdit:(HotelKeywordViewController *)hotelKeywordVC{
    [listmode.listTableView setContentOffset:CGPointMake(0, 0)];
    listmode.listTableView.scrollEnabled = NO;
}

- (void)hotelKeywordVC:(HotelKeywordViewController *)hotelKeywordVC didGetKeyword:(NSString *)keyword_{
    listmode.keywordVC.searchBar.text = keyword_;
    listmode.listTableView.scrollEnabled = YES;
    [self searchHotelWithKeyword:keyword_];
}

- (void)hotelKeywordVC:(HotelKeywordViewController *)hotelKeywordVC cancelWithContent:(NSString *)content{
    listmode.listTableView.scrollEnabled = YES;
    if (STRINGHASVALUE(content)){
        self.keyword = content;
    }
    else{
        if (![self.keyword isEqualToString:@""] && self.keyword!=nil) {
            self.keyword = nil;
            
            // 清空记录
            [hotelKeywordVC cancelSearchCondition];
            [self searchHotelWithKeyword:nil];
        }
    }
}

- (void) hotelKeywordVCDidBeginListen:(HotelKeywordViewController *)hotelKeywordVC{
    IFlyMSCViewController *iflyMSCVC = [[IFlyMSCViewController alloc] initWithTitle:@"语音搜索" style:NavBarBtnStyleOnlyBackBtn];
    iflyMSCVC.delegate = self;
    iflyMSCVC.iflyMSCType = IFlyMSCTypeHotelSemantics;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:iflyMSCVC];
    [iflyMSCVC release];
    
    [self presentModalViewController:nav animated:YES];
    [nav release];
}

- (void) hotelKeywordVCSearchNearby:(HotelKeywordViewController *)hotelKeywordVC{
    listmode.listTableView.scrollEnabled = YES;
    [self searchNearby];
}

#pragma mark -
#pragma mark IFlyMSCViewControllerDelegate
- (void) iflyMSCVCSearch:(IFlyMSCViewController *)iflyMSCVC{
    [[HotelSearch hotelSearch] iflyMSCVCSearch:iflyMSCVC];
    HotelConditionRequest *request = [HotelConditionRequest shared];
    if (request.keywordFilter.keywordType == HotelKeywordTypeBusiness
        ||request.keywordFilter.keywordType == HotelKeywordTypeDistrict
        ||request.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation
        ||request.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
        ||request.keywordFilter.keywordType == HotelKeywordTypePOI
        ||request.keywordFilter.keywordType == HotelKeywordTypeNormal) {
        listmode.keywordVC.searchBar.text = request.keywordFilter.keyword;
        self.keyword = request.keywordFilter.keyword;
    }else{
        listmode.keywordVC.searchBar.text = nil;
        self.keyword = nil;
    }
    [self researchHotel];
    
    // 刷新价格状态
    [self updatePriceIcon];
}

#pragma mark -
#pragma mark StarAndPricePopViewControllerDelegate

- (void) starAndPricePopViewController:(StarAndPricePopViewController *)starAndPriceVC didSelectMinPrice:(NSInteger)minPrice MaxPrice:(NSInteger)maxPrice starCodes:(NSString *)starCodes{
    requestType = 0;
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
	[hotelsearcher resetPage];
    [hotelsearcher setStarCodes:starCodes];
    [hotelsearcher setMinPrice:[NSString stringWithFormat:@"%d",minPrice] MaxPrice:[NSString stringWithFormat:@"%d",maxPrice]];
    [Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] policy:CachePolicyHotelList delegate:self];
    
    // 星级
    BOOL haveStar = NO;
    NSArray *starIndexs = [hotelsearcher getStarCodeIndexs];
    if (starIndexs && starIndexs.count) {
        if ([[starIndexs objectAtIndex:0] intValue] != -1 && [[starIndexs objectAtIndex:0] intValue] != 0) {
            haveStar = YES;
        }
    }else{
        haveStar = YES;
    }

    
    [self resetHotelMinPrice:minPrice maxPrice:maxPrice star:haveStar];
    
    if (UMENG) {
        // 选择价格筛选
        [MobClick event:Event_Filter_Price];
    }
}

- (void) resetHotelMinPrice:(int)minPrice maxPrice:(int)maxPrice star:(BOOL)brand{
    if (maxPrice >= GrouponMaxMaxPrice && minPrice >0) {
        listPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-不限",minPrice];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-不限",minPrice];
        listPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
        mapPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
    }else if(minPrice <= 0 && maxPrice >= GrouponMaxMaxPrice){
        listPriceItem.titleLabel.text = [NSString stringWithFormat:@"价格星级"];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"价格星级"];
        listPriceItem.customerIcon = nil;
        mapPriceItem.customerIcon = nil;
        listPriceItem.customerTitleColor = nil;
        mapPriceItem.customerTitleColor = nil;
    }else{
        listPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-%d",minPrice,maxPrice];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-%d",minPrice,maxPrice];
        listPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
        mapPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
    }
    
    if (brand) {
        listPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
        mapPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
    }
}


#pragma mark HotelSearchFilterDelegate

// 退出
- (void)filterViewControllerDidCancel:(HotelSearchFilterController *)filter{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

// 确定
- (void) filterViewControllerDidAction:(HotelSearchFilterController *)filter withInfo:(NSDictionary *)info{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    if (listmode.view.superview ) {
        
    }
    requestType = 0;
	
	JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
	[hotelsearcher resetPage];
	
	HotelConditionRequest *request = [HotelConditionRequest shared];
	if (![HotelSearch isPositioning]) {
		// 非周边搜索时设置搜索区域
        
        if (request.keywordFilter.keyword == nil) {
            [hotelsearcher resetPosition];
            [hotelsearcher setHotelName:@""];
            [hotelsearcher setAreaName:@""];
        }else if(request.keywordFilter.keywordType == HotelKeywordTypePOI
                 || request.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
                 || request.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation){
            // 周边
            [hotelsearcher setAreaName:@""];
            [hotelsearcher setCurrentPos:HOTEL_NEARBY_RADIUS Longitude:request.keywordFilter.lng Latitude:request.keywordFilter.lat];
        }else if(request.keywordFilter.keywordType == HotelKeywordTypeNormal){
            // 酒店名
            [hotelsearcher resetPosition];
            [hotelsearcher setHotelName:request.keywordFilter.keyword];
        }else if(request.keywordFilter.keywordType == HotelKeywordTypeBusiness
                 || request.keywordFilter.keywordType == HotelKeywordTypeDistrict){
            // 商圈和行政区
            [hotelsearcher resetPosition];		// 取消位置
			[hotelsearcher setAreaName:request.keywordFilter.keyword];
        }else if(request.keywordFilter.keywordType == HotelKeywordTypeBrand){
            // 品牌
            [hotelsearcher resetPosition];
            [hotelsearcher setBrandIDs:[NSString stringWithFormat:@"%d",request.keywordFilter.pid]];
        }
        
        if (!request.isFromLastMinute && refreshSearchTag) {
			// 非今日特价时，联动首页的搜索关键字
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",request.keywordFilter.keyword] forKey:HOTEL_SEARCH_KEYWORD]];
		}
		
        if(listFooterView.hidden == NO){
            // 清空地图
            [mapmode.view removeFromSuperview];
            [mapmode release];
            mapmode = nil;
        }
	}
    else {
        if (request.keywordFilter.keyword == nil) {
            [hotelsearcher setHotelName:@""];
            [hotelsearcher setAreaName:@""];
        }else if(request.keywordFilter.keywordType == HotelKeywordTypePOI
                 || request.keywordFilter.keywordType == HotelKeywordTypeSubwayStation
                 || request.keywordFilter.keywordType == HotelKeywordTypeAirportAndRailwayStation){
            // 周边
            [hotelsearcher setAreaName:@""];
            [hotelsearcher setCurrentPos:HOTEL_NEARBY_RADIUS Longitude:request.keywordFilter.lng Latitude:request.keywordFilter.lat];
        }else if(request.keywordFilter.keywordType == HotelKeywordTypeNormal){
            // 酒店名
            [hotelsearcher setHotelName:request.keywordFilter.keyword];
        }else if(request.keywordFilter.keywordType == HotelKeywordTypeBusiness
                 || request.keywordFilter.keywordType == HotelKeywordTypeDistrict){
            // 商圈和行政区
			[hotelsearcher setAreaName:request.keywordFilter.keyword];
        }else if(request.keywordFilter.keywordType == HotelKeywordTypeBrand){
            // 品牌
            [hotelsearcher setBrandIDs:[NSString stringWithFormat:@"%d",request.keywordFilter.pid]];
        }
        
        if (!request.isFromLastMinute && refreshSearchTag) {
            // 非今日特价时，联动首页的搜索关键字
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",request.keywordFilter.keyword] forKey:HOTEL_SEARCH_KEYWORD]];
        }
        
        if(listFooterView.hidden==NO){
            // 清空地图
            [mapmode.view removeFromSuperview];
            [mapmode release];
            mapmode = nil;
        }
        
    }
	
	// 设置搜索品牌
	[hotelsearcher setBrandIDs:[info safeObjectForKey:HOTELFILTER_BRANDS]];
	
	// 设置消费券、担保筛选条件
	[hotelsearcher setMutipleFilter:[info safeObjectForKey:HOTELFILTER_MUTIPLECONDITION]];
    
    // 设置设施
    [hotelsearcher setFacilitiesFilter:[info safeObjectForKey:HOTELFILTER_FACILITIES]];
    
    // 公寓
    [hotelsearcher setIsApartment:[[info safeObjectForKey:HOTELFILTER_APARTMENT] boolValue]];
    
    // 主题
    [hotelsearcher setThemesFilter:[info safeObjectForKey:HOTELFILTER_THEMES]];
    
    // 可入住人
    [hotelsearcher setNumbersOfRoom:[[info safeObjectForKey:HOTELFILTER_NUMBER] intValue]];
    
    // 计算选中了多少个筛选条件
    
    [self updateFilterIcon];
    
    if (filter.locationInfo.keyword) {
        [hotelsearcher setHotelName:@""];
        self.searchDisplayController.searchBar.text = filter.locationInfo.keyword;
        self.keyword = filter.locationInfo.keyword;
        
        // 设置搜索条件
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                            object:self
                                                          userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@",filter.locationInfo.keyword] forKey:HOTEL_SEARCH_KEYWORD]];
        
        listmode.keywordVC.searchBar.text = filter.locationInfo.keyword;
        
        listmode.listTableView.scrollEnabled = YES;
    }
    else if (filter.locationInfo == nil && self.keyword != nil && self.keyword.length > 0) {
        [hotelsearcher setHotelName:@""];
        self.searchDisplayController.searchBar.text = @"";
        self.keyword = @"";
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                            object:self
                                                          userInfo:[NSDictionary dictionaryWithObject:@"" forKey:HOTEL_SEARCH_KEYWORD]];
        
        listmode.keywordVC.searchBar.text = @"";
        
        listmode.listTableView.scrollEnabled = YES;
        
        [request clearKeywordFilter];
    }
    
    // 重置地图中的keyword
    if (listFooterView.hidden) {
        [mapmode setKeyword];
    }
    
	[Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] policy:CachePolicyHotelList delegate:self];
}

- (void) filterCountly{
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    
    CountlyEventHotelListPageFilter *countlySearch = [[CountlyEventHotelListPageFilter alloc] init];
    countlySearch.keyword = [hotelsearcher getHotelName];
    countlySearch.checkInDate = [hotelsearcher getCheckinDate];
    countlySearch.checkOutDate = [hotelsearcher getCheckoutDate];
    countlySearch.city = [hotelsearcher cityName];
    countlySearch.highestPrice = NUMBER([[hotelsearcher getMaxPrice] intValue]);
    countlySearch.lowestPrice = NUMBER([[hotelsearcher getMinPrice] intValue]);
    countlySearch.hotelBrandid = [[hotelsearcher getBrandIDs] componentsJoinedByString:@","];
    countlySearch.isApartment = [NSNumber numberWithBool:[hotelsearcher getIsApartment]];
    countlySearch.isPositioning = [NSNumber numberWithBool:[hotelsearcher getIsPos]];
    countlySearch.latitude = [NSNumber numberWithFloat:[hotelsearcher getLatitude]];
    countlySearch.longitude = [NSNumber numberWithFloat:[hotelsearcher getLongitude]];
    countlySearch.memberLevel = [NSNumber numberWithInt:[hotelsearcher getMemberLevel]];
    countlySearch.mutilpleFilter = [NSNumber numberWithInt:[[hotelsearcher getMutipleFilter] intValue]];
    countlySearch.orderBy =  [NSNumber numberWithInt:[hotelsearcher getOrderBy]];
    countlySearch.pageIndex = [NSNumber numberWithInt:[hotelsearcher getPageIndex]];
    countlySearch.pageSize = [NSNumber numberWithInt:[hotelsearcher getPageSize]];
    countlySearch.radius = [NSNumber numberWithInt:[hotelsearcher getRadius]];
    countlySearch.searchType = [NSNumber numberWithInt:[hotelsearcher getSearchType]];
    countlySearch.starCode = [hotelsearcher getStarCodesStr];
    countlySearch.facilitiesFilter = [[hotelsearcher getFacilitiesFilter] componentsJoinedByString:@","];
    countlySearch.themesFilter = [[hotelsearcher getThemesFilter] componentsJoinedByString:@","];
    countlySearch.filter = [NSNumber numberWithInt:[[hotelsearcher getFilter] intValue]];
    countlySearch.areaName = [hotelsearcher getAreaName];
    [countlySearch sendEventCount:1];
    [countlySearch release];
}

#pragma mark -
#pragma mark HttpDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
	NSDictionary *root = [PublicMethods unCompressData:responseData];

    if (util == hotelAreaUtil) {
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return;
        }
        
		HotelConditionRequest *searchReq = [HotelConditionRequest shared];
		[searchReq setAllCondition:root];
    }else if(util == hotelThemeUtil){
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return;
        }
        HotelConditionRequest *searchReq = [HotelConditionRequest shared];
		[searchReq setThemes:root];
    }else{
        if (0 == requestType) {
            if (!DICTIONARYHASVALUE(root)) {
                // 针对all in one search的处理
                [PublicMethods showAlertTitle:@"未找到搜索酒店" Message:nil];
                [self refreshListByDictionary:root];
                return;
            }
            
            if ([Utils checkJsonIsError:root]) {
                return;
            }
            
            // 周边搜索情况，传入品牌和星级信息
            JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
            [hotelsearcher setBrandAndStar:root];
            
            [self refreshListByDictionary:root];
            
            // countly filter
            // countly search
            [self filterCountly];
            
        }else if(-1 == requestType){
            [[MyElongCenter allHotelFInfo] removeAllObjects];
            NSArray *favorArray = [root safeObjectForKey:@"HotelFavorites"];
            if ([favorArray isEqual:[NSNull null]]) {
                favorArray = [NSArray array];
            }
            [[MyElongCenter allHotelFInfo] addObjectsFromArray:favorArray];
            
            HotelFavoriteRequest *jghf=[HotelPostManager favorite];
            HotelFavorite *mFavorite = [[HotelFavorite alloc] initWithEditStyle:YES category:jghf.category];
            mFavorite.totalCount = [[root objectForKey:@"TotalCount"] intValue];
            [self.navigationController pushViewController:mFavorite animated:YES];
            [mFavorite release];
        }
    }
	
}


#pragma mark -
#pragma mark BaseBottomBarDelegate
- (void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if (bar == listFooterView) {
        switch (index) {
            case 0:{
                // 筛选
                [self presentAreaChooseView];
                UMENG_EVENT(UEvent_Hotel_List_FilterEnter)
                
                // countly 筛选按钮点击事件
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELLISTPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_FILTER;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            case 1:{
                //价格
                [self priceBtnPress];
                
                // countly 价格星级击事件
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELLISTPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_PRICEANDSTAR;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            case 2:{
                // 排序
                [self orderBtnPressed:nil];
                UMENG_EVENT(UEvent_Hotel_List_SortEnter)
                
                // countly 排序点击事件
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELLISTPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_SORT;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            case 3:{
                // 地图
                [self switchViews:nil];
                UMENG_EVENT(UEvent_Hotel_List_MapEnter)
                
                // countly 地图点击事件
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELLISTPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_MAP;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            default:
                break;
        }
    }else if(bar == mapFooterView){
        switch (index) {
            case 0:{
                // 当前位置
                [self goCenter];
                UMENG_EVENT(UEvent_Hotel_ListMap_Position)
                
                // countly currentlocation
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_CURRENTLOCATION;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            case 1:{
                // 目的地
                [self selectPin];
                UMENG_EVENT(UEvent_Hotel_ListMap_Destination)
                
                // countly destination
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_DESTINATION;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            case 2:{
                // 价格
                [self priceBtnPress];
                
                // countly 地图-星级价格点击事件
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_PRICEANDSTAR;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            case 3:{
                // 筛选
                [self presentAreaChooseView];
                UMENG_EVENT(UEvent_Hotel_List_FilterEnter)
                
                // countly 地图-筛选点击事件
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_FILTER;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            case 4:{
                // 列表
                [self switchViews:nil];
                
                // countly 地图-列表点击事件
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELMAPPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_LIST;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
                break;
            default:
                break;
        }
    }
    
}


#pragma mark -
#pragma mark FilterDelegate

- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView{
	JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];	
	
	if (0 == index) {
        if (_distanceSort) {
            _distanceSort = NO;
            [hotelsearcher resetPosition];
        }
		[hotelsearcher setOrderBy:0];
        
	}
	else if (2 == index) {
		if ([[HotelSearch hotels] count] >= [HotelSearch hotelCount]) {
            // 数据少时，本地排序
			[self priceSortByAscend:YES];
		}
        
        if (_distanceSort) {
            _distanceSort = NO;
            [hotelsearcher resetPosition];
        }
        [hotelsearcher setOrderBy:1];
        UMENG_EVENT(UEvent_Hotel_List_SortPriceLow2High)
	}
	else if (3 == index) {
		if ([[HotelSearch hotels] count] >= [HotelSearch hotelCount]) {
            // 数据少时，本地排序
			[self priceSortByAscend:NO];
		}
        
        if (_distanceSort) {
            _distanceSort = NO;
            [hotelsearcher resetPosition];
        }
        [hotelsearcher setOrderBy:101];
        UMENG_EVENT(UEvent_Hotel_List_SortPriceHigh2Low)
	}
	else if (4 == index) {
		if ([[HotelSearch hotels] count] >= [HotelSearch hotelCount]) {
            // 数据少时，本地排序
			[self starLevelSortByAscend:YES];
		}
        
        if (_distanceSort) {
            _distanceSort = NO;
            [hotelsearcher resetPosition];
        }
        [hotelsearcher setOrderBy:3];
        UMENG_EVENT(UEvent_Hotel_List_SortStarLow2High)
	}
	else if (5 == index) {
		if ([[HotelSearch hotels] count] >= [HotelSearch hotelCount]) {
            // 数据少时，本地排序
			[self starLevelSortByAscend:NO];
			
		}
        
        if (_distanceSort) {
            _distanceSort = NO;
            [hotelsearcher resetPosition];
        }
        [hotelsearcher setOrderBy:103];
        UMENG_EVENT(UEvent_Hotel_List_SortStarHigh2Low)
	}
    //好评排序
    else if (6 == index)
    {
        if (_distanceSort) {
            _distanceSort = NO;
            [hotelsearcher resetPosition];
        }
        [hotelsearcher setOrderBy:105];
	}
    else if(1 == index){
        [self searchNearby];
    }
	
	if ([[HotelSearch hotels] count] < [HotelSearch hotelCount] || 0 == index|| 6 == index) {
		requestType = 0;
        
		[Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] policy:CachePolicyHotelList delegate:self];
	}
    
    if (UMENG) {
        // 排序页点击确定
        [MobClick event:Event_Sort_Confirm label:[NSString stringWithFormat:@"%d",index]];
    }
    
    [self changetBarItemStyle:index];
}

// 周边搜索
- (void) searchNearby{
    [HotelSearch setPositioning:YES];
    if ([[PositioningManager shared] myCoordinate].latitude == 0 && [[PositioningManager shared] myCoordinate].longitude == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败，请确认已打开手机定位功能" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return;
    }
    
    if ([[PositioningManager shared] isGpsing]) {
        [Utils alert:@"正在校准定位，请稍后尝试"];
        
        // 重新定位
        FastPositioning *position = [FastPositioning shared];
        position.autoCancel = YES;
        [position fastPositioning];
        
        return ;
    }
    
    UMENG_EVENT(UEvent_Hotel_List_SortNearby)
    
    [[HotelConditionRequest shared] setIsFromLastMinute:NO];
    
    FastPositioning *position = [FastPositioning shared];
    position.autoCancel = YES;
    [position fastPositioning];
    
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [hotelsearcher setOrderBy:0];
    NSString *currentRadius=[NSString stringWithFormat:@"%.f",5000.0f];
    [hotelsearcher setCurrentPos:[currentRadius intValue] Longitude:[[PositioningManager shared] myCoordinate].longitude Latitude:[[PositioningManager shared] myCoordinate].latitude];
    requestType = 0;
    _distanceSort = YES;
    [Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] policy:CachePolicyHotelList delegate:self];
}
@end
