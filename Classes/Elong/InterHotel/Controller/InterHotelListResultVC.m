//
//  InterHotelListViewController.m
//  ElongClient
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelListResultVC.h"
#import "InterHotelListView.h"
#import "Utils.h"
#import "InterHotelSearcher.h"
#import "InterHotelDefine.h"
#import "ElongURL.h"

#define NET_TYPE_REFRESHDATA      1

@interface InterHotelListResultVC ()

@property (nonatomic, retain) UIBarButtonItem *originItem;			// 刚进页面时的barbutton
@property (nonatomic, retain) UIBarButtonItem *moreItem;            // 地图模式更多按钮

@end


@implementation InterHotelListResultVC

@synthesize originItem;
@synthesize moreItem;
@synthesize moreBtn;
@synthesize isMaximum;
@synthesize listView;

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (listView.selectIndexPath) {
        [listView.listTableView deselectRowAtIndexPath:listView.selectIndexPath animated:YES];
    }
}

- (void)dealloc {
    [listView release];
    
    self.originItem = nil;
	self.moreItem = nil;
    self.moreBtn = nil;
    
    [super dealloc];
}

- (id)initWithTitle:(NSString *)titleStr {
	if (self = [super initWithTopImagePath:@"" andTitle:titleStr style:_NavNoTelStyle_]) {
        self.cityName = titleStr;
        
        [self makeUI];
	}
    
	return self;
}

#pragma mark -
#pragma mark 界面初始化

- (void)makeUI {
	self.originItem = self.navigationItem.rightBarButtonItem;
	
    self.moreBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
    self.moreBtn.exclusiveTouch = YES;
	moreBtn.adjustsImageWhenDisabled = NO;
    moreBtn.titleLabel.font = FONT_B15;
	[moreBtn setTitle:@"显示更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
	[moreBtn addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
	self.moreItem = [[[UIBarButtonItem alloc] initWithCustomView:moreBtn] autorelease];
	// ==============================================================================
	
	isMaximum = NO;
	
	[self addListFooterView];
    [self addMapFooterView];
	
    listView = [[InterHotelListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44 - 45) rootController:self];
    [self.view insertSubview:listView atIndex:0];
    
    listFooterView.hidden	= NO;
    mapFooterView.hidden = YES;
    
    // 刷新筛选标记
    [self updateFilterIcon];
}

// 列表工具栏
-(void)addListFooterView{
    
    listFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 20 - 44 - 45, SCREEN_WIDTH, 45)];
    listFooterView.delegate = self;
    
//    priceItem = [[BaseBottomBarItem alloc] initWithTitle:@"价格"
//                                               titleFont:[UIFont systemFontOfSize:12.0f]
//                                                   originImage:@"basebar_price.png"];
    
    sortItem = [[BaseBottomBarItem alloc] initWithTitle:@"排序"
                                              titleFont:[UIFont systemFontOfSize:12.0f]
                                                  image:@"basebar_sort.png"
                                        highligtedImage:@"basebar_sort_h.png"];
    
    filterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                   titleFont:[UIFont systemFontOfSize:12.0f]
                  image:@"basebar_filter.png" highligtedImage:@"basebar_filter_h.png"];
    
    
    mapModelItem = [[BaseBottomBarItem alloc] initWithTitle:@"地图"
                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                                                      image:@"basebar_map.png"
                                            highligtedImage:@"basebar_map_h.png"];
    
    NSMutableArray *itemArray = [NSMutableArray array];
    
    
    
    [itemArray addObject:filterItem];
    filterItem.allowRepeat = YES;
    filterItem.autoReverse = YES;
    [filterItem release];
    
    [itemArray addObject:sortItem];
    sortItem.allowRepeat = YES;
    sortItem.autoReverse = YES;
    [sortItem release];
    
    //    [itemArray addObject:priceItem];
    //    priceItem.allowRepeat = YES;
    //    priceItem.autoReverse = YES;
    //    [priceItem release];
    
    [itemArray addObject:mapModelItem];
    mapModelItem.allowRepeat = YES;
    mapModelItem.autoReverse = YES;
    [mapModelItem release];
    
    listFooterView.baseBottomBarItems = itemArray;
    
    [self.view addSubview:listFooterView];
    [listFooterView release];
}

// 地图工具栏
-(void)addMapFooterView{
    mapFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45-20-44, 320, 45)];
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
    
//    mapPriceItem = [[BaseBottomBarItem alloc] initWithTitle:@"价格"
//                     titleFont:[UIFont systemFontOfSize:12.0f]
//                    image:@"basebar_price.png" highligtedImage:@"basebar_price_h.png"];
    
    //selectPin
    
    mapFilterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                                                                      titleFont:[UIFont systemFontOfSize:12.0f]
                     image:@"basebar_filter.png" highligtedImage:@"basebar_filter_h.png"];
    
    listModelItem = [[BaseBottomBarItem alloc] initWithTitle:@"列表"
                                                   titleFont:[UIFont systemFontOfSize:12.0f]
                                                       image:@"basebar_list.png"
                                             highligtedImage:@"basebar_list_h.png"];

    
    
    NSMutableArray *itemArray = [NSMutableArray array];
    [itemArray addObject:locationItem];
    locationItem.allowRepeat = YES;
    locationItem.autoReverse = YES;
    [locationItem release];
    
    [itemArray addObject:destinationItem];
    destinationItem.allowRepeat = YES;
    destinationItem.autoReverse = YES;
    [destinationItem release];
    
//    [itemArray addObject:mapPriceItem];
//    mapPriceItem.allowRepeat = YES;
//    mapPriceItem.autoReverse = YES;
//    [mapPriceItem release];
    
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


#pragma mark -
#pragma mark BaseBottomBarDelegate
- (void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if (bar == listFooterView) {
        switch (index) {
            case 0:{
                // 筛选
                [self clickFilterButton];
            }
                break;
            case 1:{
                // 排序
                [self orderBtnPressed:nil];
            }
                break;
            case 2:{
                // 地图
                [self switchViews:nil];
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
            }
                break;
            case 1:{
                // 目的地
                [self selectPin];
            }
                break;
            case 2:{
                // 筛选
                [self clickFilterButton];
            }
                break;
            case 3:{
                // 列表
                [self switchViews:nil];
            }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark -
#pragma mark Actions

// 价格滑块触发
- (void) priceSelectPressed
{
    return;
    
    if (!priceView) {
		priceView = [[PricePopViewController alloc] initWithTitle:@"价格" Datas:nil];
		priceView.priceChangeDelegate = self;
		[self.view addSubview:priceView.view];
	}
    
    [priceView reset];
    
    [priceView showInView];
}

// 点击更多按钮触发
- (void)moreButtonPressed {
    self.moreBtn.enabled = NO;
	[mapView searchMoreHotel];
}

// 筛选按钮触发
- (void)clickFilterButton {
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    NSUInteger minPrice = [searcher minPrice];
    NSUInteger maxPrice = [searcher maxPrice];
    NSUInteger minStarLevel = [searcher minStarLevel];
    NSUInteger maxStarLevel = [searcher maxStarLevel];
    NSUInteger star = 0;
    if (minStarLevel == 1 && maxStarLevel == 5) {
        star = 0;
    }
    else if (minStarLevel == 1 && maxStarLevel == 2) {
        star = 1;
    }
    else if (minStarLevel == 3 && maxStarLevel == 3) {
        star = 2;
    }
    else if (minStarLevel == 4 && maxStarLevel == 4) {
        star = 3;
    }
    else if (minStarLevel == 5 && maxStarLevel == 5) {
        star = 4;
    }
    InterHotelSearchFilterController *filter = [[InterHotelSearchFilterController alloc] initWithNibName:@"FilterController" bundle:nil minPrice:minPrice maxPrice:maxPrice starLevel:star locationInfo:searcher.location keyword:searcher.keywords];
//    filter.minPrice = minPrice;
//    filter.maxPrice = maxPrice;
//    filter.starLevel = star;
//    filter.locationInfo = searcher.location;
//    filter.keyword = searcher.keywords;
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
- (void)orderBtnPressed:(id)sender {
	if (!orderView) {
		orderView = [[InterHotelOrderView alloc] init];
		[self.view addSubview:orderView.view];
	}
    else{
        if (orderView.view.superview != self.view) {
            [orderView.view removeFromSuperview];
        }
        [self.view addSubview:orderView.view];
    }
    orderView.delegate = self;
    
	[orderView showInView];
}

// 计算是否应该显示筛选条件图标
- (void)updateFilterIcon
{
    int count = 0;
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    NSUInteger minPrice = [searcher minPrice];
    NSUInteger maxPrice = [searcher maxPrice];
    
    if (minPrice>0||(maxPrice>0&&maxPrice<NSUIntegerMax)) {
        count++;
    }
    
    NSUInteger minStarLevel = [searcher minStarLevel];
    NSUInteger maxStarLevel = [searcher maxStarLevel];
    NSUInteger star = 0;
    if (minStarLevel == 1 && maxStarLevel == 5) {
        star = 0;
    }
    else if (minStarLevel == 1 && maxStarLevel == 2) {
        star = 1;
    }
    else if (minStarLevel == 3 && maxStarLevel == 3) {
        star = 2;
    }
    else if (minStarLevel == 4 && maxStarLevel == 4) {
        star = 3;
    }
    else if (minStarLevel == 5 && maxStarLevel == 5) {
        star = 4;
    }
    
    if (star>0) {
        count++;
    }
    
    if (searcher.location) {
        count++;
    }
    
    if (STRINGHASVALUE(searcher.keywords)) {
        count++;
    }
    
    if (count > 0) {
        filterItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_filter_mark.png"];
        mapFilterItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_filter_mark.png"];
    }
    else {
        filterItem.customerIcon = nil;
        mapFilterItem.customerIcon = nil;
    }
}

#pragma mark -
#pragma mark PriceChangeDelegate Delegate
- (void) changePrice:(int) minPrice maxPrice:(int) maxPrice
{
    return;
    if (maxPrice >= GrouponMaxMaxPrice && minPrice >0) {
        priceItem.titleLabel.text = [NSString stringWithFormat:@"%d-不限",minPrice];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-不限",minPrice];
        priceItem.iconImageView.image = [UIImage noCacheImageNamed:@"basebar_price_h.png"];
        mapPriceItem.iconImageView.image = [UIImage noCacheImageNamed:@"basebar_price_h.png"];
        priceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        mapPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
    }else if(minPrice <= 0 && maxPrice >= GrouponMaxMaxPrice){
        priceItem.titleLabel.text = [NSString stringWithFormat:@"价格"];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"价格"];
        priceItem.iconImageView.image = [UIImage noCacheImageNamed:@"basebar_price.png"];
        mapPriceItem.iconImageView.image = [UIImage noCacheImageNamed:@"basebar_price.png"];
        priceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
        mapPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    }else{
        priceItem.titleLabel.text = [NSString stringWithFormat:@"%d-%d",minPrice,maxPrice];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-%d",minPrice,maxPrice];
        priceItem.iconImageView.image = [UIImage noCacheImageNamed:@"basebar_price_h.png"];
        mapPriceItem.iconImageView.image = [UIImage noCacheImageNamed:@"basebar_price_h.png"];
        priceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        mapPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
    }

    if (UMENG) {
        // 国际酒店选择价格筛选
        [MobClick event:Event_InterHotelFilter_Price];
    }
    
    NSLog(@"%d-%d",minPrice,maxPrice);
    
//    GListRequest *cityListReq = [GListRequest shared];
//    
//    if (maxPrice==GrouponMaxMaxPrice) {
//        maxPrice=-1;
//    }
//	
//	[cityListReq setMinPrice:minPrice];
//	[cityListReq setMaxPrice:maxPrice];
//    
//    //    [self updateFilterIcon];
//    linkType = kReloadListType;
//    
//	[Utils request:GROUPON_SEARCH req:[cityListReq grouponListCompress:YES] policy:CachePolicyGrouponList delegate:self];
}

#pragma mark -
#pragma mark PrivateMethods
// 关键词搜索酒店
- (void)searchHotelWithKeyword:(NSString *)keyword_{
    if(UMENG){
        if (keyword_) {
            //国际酒店关键词搜索
            [MobClick event:Event_InterHotelKeyword];
        }
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HotelSearch class]]) {
            HotelSearch *searchCtr = (HotelSearch *)controller;
            searchCtr.interHotelKeywordTextField.text = keyword_;
            break;
        }
    }
    
    //把搜索城市和对应条件存入本地
    [PublicMethods saveSearchKey:keyword_ forCity:_cityName];
    
    requestType = NET_TYPE_REFRESHDATA;
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    searcher.keywords = keyword_;
    [Utils request:INTER_SEARCH req:[searcher request] policy:CachePolicyHotelList delegate:self];
    
    [self updateFilterIcon];
}

// 定位到地图自己所在位置
- (void)goCenter {
	[mapView goUserLocation];
}

// 定位到地图选中位置
- (void)selectPin{
	[mapView selectPin];
}

// 列表地图翻转动画
- (void)switchViews:(id)sender{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(upDateNavBar)];
    
    if (listView.superview == nil){
        
        if (listView == nil){
			listView = [[InterHotelListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44 - 40)];
            listView.rootController = self;
        }
		
        [self.view insertSubview:listView atIndex:0];
        listFooterView.hidden	= NO;
        
        [mapView removeFromSuperview];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:self.view cache:YES];
        
		listFooterView.hidden=NO;
		mapFooterView.hidden=YES;
    }
    else
    {
        if (mapView == nil){
            mapView = [[InterHotelMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44 - 45)];
			mapView.rootController = self;
        }
		
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromRight
                               forView:self.view cache:YES];
        
        [listView removeFromSuperview];
        [self.view insertSubview:mapView atIndex:0];
		
		listFooterView.hidden=YES;
		mapFooterView.hidden=NO;
    }
    
    [UIView commitAnimations];
}

// 更新导航栏右上角按钮
- (void)upDateNavBar {
	// 更新右上角按钮
	if (listView.superview) {
		// 列表模式
		self.navigationItem.rightBarButtonItem = originItem;
	}
	else {
		// 地图模式
		self.navigationItem.rightBarButtonItem = moreItem;
	}
}

//
#pragma mark -
#pragma mark PublicMethods

// 检测酒店列表数目是否达到上限
- (void)checkHotelFull {
    //	if ([[HotelSearch hotels] count] >= MAX_HOTEL_COUNT) {
    //		[listmode keepHotelNumber];
    //		[mapmode removeMapAnnotationsInRange:NSMakeRange(0, HOTEL_PAGESIZE)];
    //	}
}


// 刷新地图数据
- (void)refreshMapData {
    if (mapView) {
        [mapView addMoreData];
    }
}

// 刷新列表数据
- (void) refreshListData{
    if(listView){
        [listView addMoreData];
    }
}

// 重置列表数据
- (void) resetListData{
    if (listView) {
        [listView refreshData];
    }
}

// 重置地图数据
- (void) resetMapData{
    if (mapView) {
        [mapView refreshMap];
    }
}

// 禁止点击更多按钮
- (void)forbidSearchMoreHotel {
	moreBtn.enabled = NO;
	[moreBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateNormal];
}

// 恢复点击更多按钮
- (void)restoreSearchMoreHotel {
	moreBtn.enabled = YES;
	[moreBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    
    // [self refreshTitle];
}

- (void)cancelOrderView {
	if (orderView.isShowing) {
		[orderView dismissInView];
	}
}


- (void)setSwitchButtonActive:(BOOL)animated {
    /* to do
    if (animated) {
        listModelBtn.userInteractionEnabled = YES;
        mapModelBtn.userInteractionEnabled = YES;
    }
    else {
        listModelBtn.userInteractionEnabled = NO;
        mapModelBtn.userInteractionEnabled = NO;
    }
     */
}

#pragma mark -
#pragma mark HotelKeywordViewControllerDelegate

- (void)hotelKeywordVCDidBeginEdit:(HotelKeywordViewController *)hotelKeywordVC{
    [listView.listTableView setContentOffset:CGPointMake(0, 0)];
    listView.listTableView.scrollEnabled = NO;
}

- (void)hotelKeywordVC:(HotelKeywordViewController *)hotelKeywordVC didGetKeyword:(NSString *)keyword_{
    listView.keywordVC.searchBar.text = keyword_;
    listView.listTableView.scrollEnabled = YES;

    [self searchHotelWithKeyword:keyword_];
}

- (void)hotelKeywordVC:(HotelKeywordViewController *)hotelKeywordVC cancelWithContent:(NSString *)content{
    listView.listTableView.scrollEnabled = YES;

    if (STRINGHASVALUE(content)) {
        // 点击取消时搜索框有值
    }else{
        // 无值时重新搜索
        [self searchHotelWithKeyword:@""];
    }
}

#pragma mark -
#pragma mark FilterDelegate

- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView {
	InterHotelSearcher *hotelsearcher = [InterHotelSearcher shared];
    hotelsearcher.currentPage = 1;

	if (0 == index) {
        // 默认最受欢迎
		hotelsearcher.sortType = SortTypeOfInterHotelPopular;
	}
	else if (1 == index) {
        hotelsearcher.sortType = SortTypeOfInterHotelPriceLowToHigh;
	}
	else if (2 == index) {
        hotelsearcher.sortType = SortTypeOfInterHotelStarHighToLow;
	}
	else if (3 == index) {
        // 特惠
		hotelsearcher.sortType = SortTypeOfInterHotelDiscount;
	}

    requestType = NET_TYPE_REFRESHDATA;
    [Utils request:INTER_SEARCH req:[hotelsearcher request] policy:CachePolicyHotelList delegate:self];
    
    if (UMENG) {
        //国际酒店排序页点击确定
        [MobClick event:Event_InterHotelSort_Confirm label:[NSString stringWithFormat:@"%d",hotelsearcher.sortType]];
    }
    
    [self changetBarItemStyle:index];
}

//根据选中改变下边bar的icon
-(void) changetBarItemStyle:(NSInteger) index
{
    if (index == 0)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
        sortItem.titleLabel.text=@"最受欢迎";
    }
    else if (index==1)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        sortItem.titleLabel.text=@"价格升序";
    }
    else if (index==2)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        sortItem.titleLabel.text=@"星级降序";
    }
    else if (index==3)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        sortItem.titleLabel.text=@"优惠降序";
    }
    else
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
        sortItem.titleLabel.text=@"最受欢迎";
    }
}


#pragma mark -
#pragma mark SearchFilterDelegate

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
    NSUInteger minPrice = [[info safeObjectForKey:@"MinPrice"] integerValue];
    NSUInteger maxPrice = [[info safeObjectForKey:@"MaxPrice"] integerValue];
    NSUInteger starLevel = [[info safeObjectForKey:@"StarLevel"] integerValue];
    NSDictionary *location = [info safeObjectForKey:@"Location"];
    NSString *keyword = [info safeObjectForKey:@"Keyword"];
    
    InterHotelSearcher *searcher = [InterHotelSearcher shared];
    searcher.minPrice = minPrice;
    searcher.maxPrice = maxPrice;

    searcher.minStarLevel = starLevel;
    searcher.maxStarLevel = starLevel;
    searcher.currentPage = 1;
    
    switch (starLevel) {
        case 0:
            searcher.minStarLevel = 1;
            searcher.maxStarLevel = 5;
            break;
        case 1:
            searcher.minStarLevel = 1;
            searcher.maxStarLevel = 2;
            break;
        case 2:
            searcher.minStarLevel = 3;
            searcher.maxStarLevel = 3.5;
            break;
        case 3:
            searcher.minStarLevel = 4;
            searcher.maxStarLevel = 4.5;
            break;
        case 4:
            searcher.minStarLevel = 5;
            searcher.maxStarLevel = 5;
            break;
        default:
            break;
    }

    if (location != nil) {
        float lat = 0.0f;
        float lng = 0.0f;
        if (![[location safeObjectForKey:@"Lat"] isEqual:[NSNull null]]) {
            lat = [[location safeObjectForKey:@"Lat"] floatValue];
        }
        if (![[location safeObjectForKey:@"Lng"] isEqual:[NSNull null]]) {
             lng = [[location safeObjectForKey:@"Lng"] floatValue];
        }
        [searcher setLocation:location];
        [searcher setCoordinateWithLatitude:lat withLongitude:lng withRadius:5.0 withName:[location safeObjectForKey:@"LandMarkNameEn"]];
    }
    else {
        [searcher removeCoordinate];
        [searcher setLocation:nil];
    }
    
    searcher.keywords = keyword;
    self.listView.keywordVC.searchBar.text = searcher.keywords;
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HotelSearch class]]) {
            HotelSearch *searchCtr = (HotelSearch *)controller;
            searchCtr.interHotelKeywordTextField.text = keyword;
            break;
        }
    }
    
    requestType = NET_TYPE_REFRESHDATA;
    [Utils request:INTER_SEARCH req:[searcher request] policy:CachePolicyHotelList delegate:self];
    
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    [self updateFilterIcon];
}

#pragma mark - HttpRequestDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *dic = [PublicMethods unCompressData:responseData];
	
	if ([Utils checkJsonIsError:dic]) {
		return;
	}
    
    if (requestType == NET_TYPE_REFRESHDATA) {
        // 处理筛选和排序后的数据
        InterHotelSearcher *searcher = [InterHotelSearcher shared];
        
        [searcher setHotelCount:[[dic safeObjectForKey:@"HotelCount"] integerValue]];
        [searcher setHotelList:[dic safeObjectForKey:HOTEL_LIST]];
        
        if (searcher.hotelList.count > 0) {
            searcher.countryId = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CountryCode"];
            searcher.cityNameEn = [[searcher.hotelList safeObjectAtIndex:0] safeObjectForKey:@"CityEnName"];
        }
        
        if(listView){
            [listView refreshData];
        }
        if (mapView) {
            [mapView refreshMap];
        }
    }
}

@end
