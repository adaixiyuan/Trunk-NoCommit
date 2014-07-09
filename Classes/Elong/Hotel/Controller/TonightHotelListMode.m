//
//  TonightHotelListMode.m
//  ElongClient
//
//  Created by Wang Shuguang on 12-10-23.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "TonightHotelListMode.h"
#import "HotelPostManager.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "HotelConditionRequest.h"
#import "HotelFavorite.h"
#import "MyElongCenter.h"
#import "HotelListCellDataSource.h"
#import "HotelListCellAction.h"
#import "HotelPromotionInfoRequest.h"

#define MAP_ZOOM_LEVEL		0.05
#define kCountLabelTag		4111
#define lineLabelTag        4112
#define MOREHOTEL           0
#define HOTELDETAIL         1
#define HOTELFILTER         2
#define HOTELFAV            3
#define PRICELABELTAG       2222
#define STARLABELTAG        3333
#define TIPBARTAG           2223
#define LONGCUITAG          4444
#define LASTMINITETAG       5555
#define HOTELINDEXTAG       6666
#define MAPPRICEIMAGE       7777

#define kCityName		[[HotelPostManager hotelsearcher] getObject:ReqHS_CityName_S]		// 获取当前城市名

@interface TonightHotelListMode (){
    HotelListCellDataSource *cellDataSource;
    HotelListCellAction *cellAction;
}
- (void)resetTipLabel;
-(void)addTipLabel;
- (void)refreshData;
-(void)morehotel;
-(void)addListFooterView;

@property (nonatomic, retain) HotelSearchFilterController *filter;
@property (nonatomic, retain) NSIndexPath *selectIndexPath;

@end

@implementation TonightHotelListMode
@synthesize rootController = _rootController;
@synthesize orderView = _orderView;
@synthesize moreBtn;
@synthesize originItem;
@synthesize moreItem;
@synthesize moreHotelReq;

int const FootButtonWidth=100;            //底部按钮长度    

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    [searchReq setIsFromLastMinute:NO];
    
    // cancel Downloads
    self.rootController = nil;
    [tonightUtil cancel];
    SFRelease(tonightUtil);
    [moreHotelReq cancel];
    self.moreHotelReq= nil;
    
	[queue cancelAllOperations];
	[queue release];

    [moreHotelButton release];
	[progressManager release];
	[tableImgeDict release];
	[tableFootView release];
    [mapAnnotations release];
    [smallLoading release];
    
    self.orderView = nil;
    [[HotelSearch tonightHotels] removeAllObjects];
    
    self.moreItem = nil;
	self.originItem = nil;
	self.moreBtn = nil;
    self.selectIndexPath = nil;
  
    if (animateView) {
        [animateView release];
        animateView = nil;
    }
    
    [_filter release];
    [priceView release];
    
    [cellDataSource release],cellDataSource = nil;
    
    [cellAction release],cellAction = nil;
    
    [super dealloc];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithTopImagePath:(NSString *)imgPath andTitle:(NSString *)titleStr style:(NavBtnStyle)style{
    if (self = [super initWithTopImagePath:imgPath andTitle:titleStr style:style]) {
        tableImgeDict	= [[NSMutableDictionary alloc] initWithCapacity:2];
		progressManager	= [[NSMutableDictionary alloc] initWithCapacity:2];
		queue = [[NSOperationQueue alloc] init];
        refreshNeeded = NO;
        
        cellDataSource = [[HotelListCellDataSource alloc] init];
        cellAction = [[HotelListCellAction alloc] init];
        
        lastTonightCount = [HotelSearch tonightHotelCount];
        
        [[HotelSearch tonightHotels] removeAllObjects];
        [HotelSearch setTonightHotelCount:0];
        
        JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
        
        // 拷贝查询条件
        [hotelsearcher copyFromJHotelSearch:[HotelPostManager hotelsearcher]];
        [hotelsearcher setFilter:1];
        //[hotelsearcher setPriceLevel:0];
    }
    return  self;
}

- (void) getFavList{
    BOOL islogin = [[AccountManager instanse] isLogin];
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (islogin) {
        linktype = HOTELFAV;
        HotelFavoriteRequest *jghf=[HotelPostManager favorite];
        [Utils request:HOTELSEARCH req:[jghf request] delegate:self];
    }else {
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_HotelGetFavorite];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
    }
}


#pragma mark -
#pragma mark DPNav back
- (void)back {
    
    if (self.rootController) {
        [moreHotelReq cancel];
        [HotelSearch setTonightHotelCount:lastTonightCount];
        
        [super back];
    }else{
        [super back];
    }
    
}


- (void)backhome {
    [moreHotelReq cancel];
    [super backhome];
}


// 酒店搜索页面顶部提示
-(void)addTipLabel{
 
    
    UIImageView *tipView = [[UIImageView alloc] initWithImage:[UIImage stretchableImageWithPath:@"hotel_list_top_bar_bg.png"]];
	[tipView setFrame:CGRectMake(0, 1, 320, 24)];
	
    NSString *indate = [TimeUtils displayDateWithNSTimeInterval:[[NSDate date] timeIntervalSince1970] formatter:@"yyyy-MM-dd"];
    NSString *outdate = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+24*60*60) formatter:@"yyyy-MM-dd"];
	
	UIImageView *checkInImg = [[UIImageView alloc] initWithFrame:CGRectMake(13, 5, 15, 15)];
	checkInImg.image = [UIImage noCacheImageNamed:@"checkIn_ico.png"];
	[tipView addSubview:checkInImg];
	[checkInImg release];
	
	UILabel *checkInLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 2, 80, 20)];
	checkInLabel.backgroundColor  = [UIColor clearColor];
	checkInLabel.font				= FONT_14;
	checkInLabel.textColor			= [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
	checkInLabel.text				= indate;//[TimeUtils displayDateWithJsonDate:indate formatter:@"yyyy-MM-dd"];
	[tipView addSubview:checkInLabel];
	[checkInLabel release];
	
	UIImageView *checkOutImg = [[UIImageView alloc] initWithFrame:CGRectMake(123, 5, 15, 15)];
	checkOutImg.image = [UIImage noCacheImageNamed:@"checkOut_ico.png"];
	[tipView addSubview:checkOutImg];
	[checkOutImg release];
	
	UILabel *checkOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 2, 80, 20)];
	checkOutLabel.backgroundColor  = [UIColor clearColor];
	checkOutLabel.font				= FONT_14;
	checkOutLabel.textColor			= [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
	checkOutLabel.text				= outdate;//[TimeUtils displayDateWithJsonDate:outdate formatter:@"yyyy-MM-dd"];
	[tipView addSubview:checkOutLabel];
	[checkOutLabel release];
	
	// 后部分提示一共多少家酒店
    UILabel *countlabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 2, 85, 20)];
	[countlabel setFont:FONT_14];
	countlabel.textAlignment = UITextAlignmentRight;
	countlabel.textColor= [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
	countlabel.tag = kCountLabelTag;
	countlabel.backgroundColor=[UIColor clearColor];
	[tipView addSubview:countlabel];
	[countlabel release];
    
	[self.view addSubview:tipView];
	[self resetTipLabel];
	
	[tipView release];
}

//底部筛选
-(void)addListFooterView{
    listFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -45-20-44, 320, 45)];
    listFooterView.delegate = self;

    // 地图
    BaseBottomBarItem *mapModelItem = [[BaseBottomBarItem alloc] initWithTitle:@"地图"
                                                                     titleFont:[UIFont systemFontOfSize:12.0f]
                                                                         image:@"basebar_map.png"
                                                               highligtedImage:@"basebar_map_h.png"];
    
    // 筛选
    listFilterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                                                    titleFont:[UIFont systemFontOfSize:12.0f]
                                                        image:@"basebar_filter.png"
                                              highligtedImage:@"basebar_filter_h.png"];
    
    // 排序
    sortItem = [[BaseBottomBarItem alloc] initWithTitle:@"排序"
                                              titleFont:[UIFont systemFontOfSize:12.0f]
                image:@"basebar_sort.png" highligtedImage:@"basebar_sort_h.png"];
//    sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
    
    // 价格
    listPriceItem = [[BaseBottomBarItem alloc] initWithTitle:@"价格星级"
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
	[animationView addSubview:listFooterView];
	[listFooterView release];
}

- (void) addMapFooterView{
    
    mapFooterView = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -45-20-44, 320, 45)];
    mapFooterView.delegate = self;
    
    mapFilterItem = [[BaseBottomBarItem alloc] initWithTitle:@"筛选"
                                                   titleFont:[UIFont systemFontOfSize:12.0f]
                                                       image:@"basebar_filter.png"
                                             highligtedImage:@"basebar_filter_h.png"];
    
    BaseBottomBarItem *listModelItem = [[BaseBottomBarItem alloc] initWithTitle:@"列表"
                                                   titleFont:[UIFont systemFontOfSize:12.0f]
                                                       image:@"basebar_list.png"
                                             highligtedImage:@"basebar_list_h.png"];
    
    // 价格
    mapPriceItem = [[BaseBottomBarItem alloc] initWithTitle:@"价格星级"
                                                  titleFont:[UIFont systemFontOfSize:12.0f]
                    image:@"basebar_starprice.png" highligtedImage:@"basebar_starprice_h.png"];
    
    NSMutableArray *itemArray = [NSMutableArray array];
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
    [animationView addSubview:mapFooterView];
    [mapFooterView release];
}


//筛选
- (void)presentAreaChooseView {
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    [searchReq setIsFromLastMinute:YES];
    
    HotelSearchFilterController *filter = [[[HotelSearchFilterController alloc] initWithTitle:@"筛选" style:NavBarBtnStyleOnlyBackBtn isLM:YES] autorelease];
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
    
    JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
    filter.cityName = hotelsearcher.cityName;
    filter.isLM = YES;
    filter.delegate = self;
    self.filter = filter;
    
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
}

//排序
- (void)orderBtnPressed:(id)sender {
	if (!self.orderView) {
        HotelFilterView *orderVC = [[HotelFilterView alloc] initWithShowDistanceSort:NO fromTonightHotelList:YES];
		self.orderView = orderVC;
        // 如果正常列表选择周边搜索，此处现实默认排序
        if (_rootController.orderView.currentRow == 1) {
            orderVC.currentRow = 0;
        }else{
            orderVC.currentRow = _rootController.orderView.currentRow;
        }
        [orderVC release];
		[self.view addSubview:self.orderView.view];
	}else {
        if (self.orderView.view.superview != self.view) {
            [self.orderView.view removeFromSuperview];
        }
        [self.view addSubview:self.orderView.view];
    }
	self.orderView.delegate = self;
	[self.orderView showInView];
    
    refreshNeeded = YES;
}

// 价格
- (void) priceBtnPress{
    if (!priceView) {
		priceView = [[StarAndPricePopViewController alloc] initWithTitle:@"价格星级" Datas:nil];
		priceView.starAndPricedelegate = self;
		[self.view addSubview:priceView.view];
	}
    
    JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
    [priceView setMinPrice:[[hotelsearcher getMinPrice] intValue] maxPrice:[[hotelsearcher getMaxPrice] intValue] starCodes:[[hotelsearcher getStarCodes] componentsJoinedByString:@","]];
    
    [priceView showInView];
}

- (void)listSortedByArray:(NSArray *)array {
	[[HotelSearch tonightHotels] removeAllObjects];
	[[HotelSearch tonightHotels] addObjectsFromArray:array];
	
	[listTableView reloadData];
	[listTableView setContentOffset:CGPointMake(0, 0)];
}


- (void)priceSortByAscend:(BOOL)animated {
	NSSortDescriptor *sortDes = [[[NSSortDescriptor alloc] initWithKey:RespHL__LowestPrice_D ascending:animated] autorelease];
	NSArray *descriptors = [NSArray arrayWithObject:sortDes];
	NSArray *sorted = [[HotelSearch tonightHotels] sortedArrayUsingDescriptors:descriptors];
	
	[self listSortedByArray:sorted];
}

- (void)starLevelSortByAscend:(BOOL)animated {
	//NSMutableArray *sortArray = [NSMutableArray arrayWithCapacity:2];
	static NSString *starKey = @"starKey";
	
	for (NSMutableDictionary *dic in [HotelSearch tonightHotels]) {
		NSInteger sortIndex = [[dic safeObjectForKey:NEWSTAR_CODE] intValue];
		if (sortIndex > 10) {
			sortIndex = round(sortIndex / 10.0f);
		}
		[dic safeSetObject:[NSNumber numberWithInt:sortIndex] forKey:starKey];
	}
	
	
	NSSortDescriptor *sortDes = [[[NSSortDescriptor alloc] initWithKey:starKey ascending:animated] autorelease];
	NSArray *descriptors = [NSArray arrayWithObject:sortDes];
	NSArray *sorted = [[HotelSearch tonightHotels] sortedArrayUsingDescriptors:descriptors];
    
	[self listSortedByArray:sorted];
}

- (void) distanceSortByAscend{
    NSSortDescriptor *sortDes = [[[NSSortDescriptor alloc] initWithKey:RespHL__Distance_D ascending:YES] autorelease];
	NSArray *descriptors = [NSArray arrayWithObject:sortDes];
	NSArray *sorted = [[HotelSearch tonightHotels] sortedArrayUsingDescriptors:descriptors];
    [self listSortedByArray:sorted];
}

- (void)updateFilterIcon{
    if ([HotelSearchFilterController filterLightWithLM:YES] > 0) {
        listFilterItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_filter_mark.png"];
        listFilterItem.customerTitleColor = nil;
        mapFilterItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_filter_mark.png"];
        mapFilterItem.customerTitleColor = nil;
    }
    else {
        listFilterItem.customerIcon = nil;
        listFilterItem.customerTitleColor = nil;
        mapFilterItem.customerIcon = nil;
        mapFilterItem.customerTitleColor = nil;
    }
}

- (void) updateSortIcon{
    JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
    NSInteger sortOrder = [hotelsearcher getOrderBy];
    switch (sortOrder) {
        case 0:
            // 默认
            [self changetBarItemStyle:0];
            break;
        case 1:
            // 价格 低->高
            [self changetBarItemStyle:2];
            break;
        case 101:
            // 价格 高->低
            [self changetBarItemStyle:3];
            break;
        case 3:
            // 星级 低->高
            [self changetBarItemStyle:4];
            break;
        case 103:
            // 星级 高->低
            [self changetBarItemStyle:5];
            break;
        case 105:
            //好评排序 高->低
            [self changetBarItemStyle:6];
            break;
        default:
            break;
    }
}

// 更新价格按钮的指示灯
- (void) updatePriceIcon{
    JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
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

#pragma mark -
#pragma mark StarAndPricePopViewControllerDelegate

- (void) starAndPricePopViewController:(StarAndPricePopViewController *)starAndPriceVC didSelectMinPrice:(NSInteger)minPrice MaxPrice:(NSInteger)maxPrice starCodes:(NSString *)starCodes{
    linktype = HOTELFILTER;
    JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
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
}

- (void) resetHotelMinPrice:(int)minPrice maxPrice:(int)maxPrice star:(BOOL)brand{
    if (maxPrice >= GrouponMaxMaxPrice && minPrice >0) {
        listPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-不限",minPrice];
        mapPriceItem.titleLabel.text = [NSString stringWithFormat:@"%d-不限",minPrice];
        listPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
        mapPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
        //        listPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        //        mapPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
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
        //        listPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        //        mapPriceItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
    }
    
    if (brand) {
        listPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
        mapPriceItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_starprice_h.png"];
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
            }
                break;
            case 1:{
                [self priceBtnPress];
            }
                break;
            case 2:{
                // 排序
                [self orderBtnPressed:nil];
            }
                break;
            case 3:{
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
                [self priceBtnPress];
            }
                break;
            case 1:{
                // 筛选
                [self presentAreaChooseView];
            }
                break;
            case 2:{
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
#pragma mark FilterDelegate

- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView {
	JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
	
	if (0 == index) {
		[hotelsearcher setOrderBy:0];
	}
	else if (2 == index) {
		if ([[HotelSearch tonightHotels] count] < [HotelSearch tonightHotelCount]) {
			
		}else {
			// 数据少时，本地排序
			[self priceSortByAscend:YES];
		}
        
        [hotelsearcher setOrderBy:1];
	}
	else if (3 == index) {
		if ([[HotelSearch tonightHotels] count] < [HotelSearch tonightHotelCount]) {
			
		}else {
			// 数据少时，本地排序
			[self priceSortByAscend:NO];
		}
        [hotelsearcher setOrderBy:101];
	}
	else if (4 == index) {
		if ([[HotelSearch tonightHotels] count] < [HotelSearch tonightHotelCount]) {
			
		}else {
			// 数据少时，本地排序
			[self starLevelSortByAscend:YES];
		}
        [hotelsearcher setOrderBy:3];
	}
	else if (5 == index) {
		if ([[HotelSearch tonightHotels] count] < [HotelSearch tonightHotelCount]) {
			
		}else {
			// 数据少时，本地排序
			[self starLevelSortByAscend:NO];
		}
        [hotelsearcher setOrderBy:103];
	}
    //好评排序
    else if (6 == index)
    {
        [hotelsearcher setOrderBy:105];
	}
    
//    else if (6 == index){
//        if ([[HotelSearch tonightHotels] count] >= [HotelSearch tonightHotelCount]) {
//            // 数据少时，本地排序
//			[self distanceSortByAscend];
//		}
//        
//        [hotelsearcher setOrderBy:2];
//    }
	
	if ([[HotelSearch tonightHotels] count] < [HotelSearch tonightHotelCount] || 0 == index || 6 == index) {
		linktype = HOTELFILTER;
		[Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] delegate:self];
	}
    
    [self changetBarItemStyle:index];
}

//根据选中改变下边bar的icon
-(void) changetBarItemStyle:(NSInteger) index
{
    if (index == 0)
    {
        sortItem.customerIcon = nil;
        sortItem.customerTitleColor = nil;;
        sortItem.titleLabel.text=@"排序";
    }
    else if (index==2)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        sortItem.titleLabel.text=@"价格升序";
    }
    else if (index==3)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        sortItem.titleLabel.text=@"价格降序";
    }
    else if (index==4)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_right_h.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        sortItem.titleLabel.text=@"星级升序";
    }
    else if (index==5)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
//        sortItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_HIGHLIGHTED;
        sortItem.titleLabel.text=@"星级降序";
    }
    else if (index==6)
    {
        sortItem.customerIcon = [UIImage noCacheImageNamed:@"basebar_sort_left_h.png"];
        sortItem.titleLabel.text=@"好评降序";
    }
    else
    {
        sortItem.customerIcon = nil;
        sortItem.customerTitleColor = nil;
        sortItem.titleLabel.text=@"排序";
    }
}

#pragma mark -
#pragma mark MapView Delegate
- (void)addAnnotationFromDictionary:(NSDictionary *)dic {
	int index = [mapAnnotations count];
	double r = [[dic safeObjectForKey:RespHL__Latitude_D] doubleValue];
	double l = [[dic safeObjectForKey:RespHL__Longitude_D] doubleValue];
	
	NSString *titlestring = [NSString stringWithFormat:@"%@",[dic safeObjectForKey:RespHL__HotelName_S]];
	NSString *hoteladress = [NSString stringWithFormat:_string(@"s_map_address"),[dic safeObjectForKey:RespHL__Address_S]];
	
	PriceAnnotation *priceAnnotation	= [[PriceAnnotation alloc] init];
	priceAnnotation.title				= titlestring;
	priceAnnotation.subtitle			= hoteladress;
	//priceAnnotation.hotelSpecialType    = Default;
    
	// 酒店星级
	int starlevel=[[dic safeObjectForKey:RespHL__StarCode_I] intValue];
	if (starlevel < 3) {
		starlevel = 0;
	}else if (starlevel > 5) {
		starlevel = 5;
	}
	NSString *starStr;
	switch (starlevel) {
		case 0:
			starStr = @"";
			break;
		case 1:
			starStr = @"★";
			break;
		case 2:
			starStr = @"★★";
			break;
		case 3:
			starStr = @"★★★";
			break;
		case 4:
			starStr = @"★★★★";
			break;
		case 5:
			starStr = @"★★★★★";
			break;
		default:
			break;
	}
	
	priceAnnotation.priceStr	= [NSString stringWithFormat:@"¥%.f",[[dic safeObjectForKey:RespHL__LowestPrice_D] doubleValue]];
    priceAnnotation.truePrice=[[dic safeObjectForKey:RespHL__LowestPrice_D] doubleValue];
	priceAnnotation.starLevel	= starStr;
	priceAnnotation.index		= index + 1;
	priceAnnotation.hotelid		= [dic safeObjectForKey:RespHL__HotelId_S];
	[priceAnnotation setCoordinateStruct:r l:l];
	
    if([[dic safeObjectForKey:RespHL_HotelSpecialType] intValue]==2)
        priceAnnotation.hotelSpecialType=Longcui;
    
    if([dic safeObjectForKey:RespHL_LastMinutesDesp]!=[NSNull null]&&![[dic safeObjectForKey:RespHL_LastMinutesDesp] isEqualToString:@""]){
        if(priceAnnotation.hotelSpecialType==Longcui)
            priceAnnotation.hotelSpecialType=LongCuiAndLM;
        else
            priceAnnotation.hotelSpecialType=LastMinute;
    }
	[mapAnnotations addObject:priceAnnotation];
	[priceAnnotation release];
}


- (void)addMapAnnotations:(NSArray *)annotations {
	for (NSDictionary *hotel in annotations) {
		[self addAnnotationFromDictionary:hotel];
	}
	
    [mapView addAnnotations:mapAnnotations];
	
	if ([mapAnnotations count] <= 0) {
		nullTipLabel.hidden = NO;
	}
	else
    {
		nullTipLabel.hidden = YES;
	}
}


// 重设地图上的价格标签
- (void)resetAnnotations {
	[mapView removeAnnotations:mapAnnotations];
	[mapAnnotations removeAllObjects];
	
	[self addMapAnnotations:[HotelSearch tonightHotels]];
}

- (void)addMapLoadingView {
	if (!smallLoading) {
		smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, (self.view.frame.size.height-50) / 2, 50, 50)];
		[self.view addSubview:smallLoading];
	}
	
	[smallLoading startLoading];
}


- (void)removeMapLoadingView {
	[smallLoading stopLoading];
}

-(void) centerMap
{
    
    if(!mapAnnotations||mapAnnotations.count<1)
        return;
    
    
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
    int count = mapAnnotations.count;
	for(int idx = 0; idx < count; idx++)
	{
        PriceAnnotation * curAnonotation=((PriceAnnotation *)[mapAnnotations safeObjectAtIndex:idx]);
        
        if(curAnonotation.coordinate.latitude==0 && curAnonotation.coordinate.longitude==0)
            continue;
        
		if(curAnonotation.coordinate.latitude > maxLat)
			maxLat = curAnonotation.coordinate.latitude;
		if(curAnonotation.coordinate.latitude < minLat)
			minLat = curAnonotation.coordinate.latitude;
		if(curAnonotation.coordinate.longitude > maxLon)
			maxLon = curAnonotation.coordinate.longitude;
		if(curAnonotation.coordinate.longitude < minLon)
			minLon = curAnonotation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.008;
	region.span.longitudeDelta = maxLon - minLon + 0.008;
    
	[mapView setRegion:region animated:YES];
}



//增加地图坐标
- (void)addmark {
    if(!mapAnnotations)
		mapAnnotations = [[NSMutableArray alloc] init];
    
	[self resetAnnotations];
    [self centerMap];
}

//得到价签图片路径
-(NSString *) getPriceAnomationIcon:(double)price
{
    NSString *path=@"lowPrice.png";
    if(price<300)
        path=@"lowPrice.png";
    else if(price>=300&&price<600)
        path=@"middlePrice.png";
    else if(price>=600)
        path=@"highPrice.png";
    
    return path;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	// If it's the user location, just return nil.
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
	
    static NSString *priceIdentifier = @"priceIdentifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:priceIdentifier];
    
    if (!annotationView)
    {
        // 价格注解
        annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:priceIdentifier] autorelease];
        annotationView.canShowCallout	= YES;
        annotationView.opaque			= NO;
        annotationView.frame			= CGRectMake(0, 0, 49, 35);
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, annotationView.frame.size.width, annotationView.frame.size.height)];
        bgImageView.tag = MAPPRICEIMAGE;
        [annotationView addSubview:bgImageView];
        [bgImageView release];
        
        
        
        
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -4, annotationView.frame.size.width, 12)];
        priceLabel.font				= [UIFont systemFontOfSize:14];
        priceLabel.backgroundColor	= [UIColor clearColor];
        priceLabel.textColor		= [UIColor whiteColor];
        priceLabel.textAlignment	= UITextAlignmentCenter;
        priceLabel.tag				= PRICELABELTAG;
        priceLabel.adjustsFontSizeToFitWidth = YES;
        [annotationView addSubview:priceLabel];
        [priceLabel release];
        
        
        UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, annotationView.frame.size.width, 10)];
        starLabel.font				= [UIFont systemFontOfSize:9];
        starLabel.backgroundColor	= [UIColor clearColor];
        starLabel.textColor			= [UIColor whiteColor];
        starLabel.textAlignment		= UITextAlignmentCenter;
        starLabel.tag				= STARLABELTAG;
        [annotationView addSubview:starLabel];
        [starLabel release];
    }
    
    //get price
    UIImageView *bgImageView = (UIImageView *)[annotationView viewWithTag:MAPPRICEIMAGE];        
    bgImageView.image = [UIImage noCacheImageNamed:@"mapAnnotation_Icon.png"];// [UIImage noCacheImageNamed:mapPath];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    PriceAnnotation *ba = (PriceAnnotation *)annotation;
    [rightButton setTitle:ba.hotelid forState:UIControlStateNormal];
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    UILabel *priceLabel = (UILabel *)[annotationView viewWithTag:PRICELABELTAG];
    priceLabel.text = [NSString stringWithFormat:@"%@",((PriceAnnotation *)annotation).priceStr];
    
    UILabel *starLabel = (UILabel *)[annotationView viewWithTag:STARLABELTAG];
    starLabel.text = [NSString stringWithFormat:@"%@",((PriceAnnotation *)annotation).starLevel];
    
    if (![starLabel.text isEqualToString:@""]) {
        priceLabel.frame = CGRectMake(0, 3, annotationView.frame.size.width, 13);
    }
    else {
        priceLabel.frame = CGRectMake(0, 7, annotationView.frame.size.width, 13);
    }
     
    return annotationView;
}

#pragma mark -
#pragma mark AreaSelectDelegate

- (void)setAssociateTag:(BOOL)tag {
	refreshSearchTag = tag;
}

- (void)getFilterConditions:(NSDictionary *)conditions {
	linktype = HOTELFILTER;
	
	JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
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
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[HotelSearch class]]) {
                    HotelSearch *searchCtr = (HotelSearch *)controller;
                    searchCtr.m_keywordsTextField.text = request.keywordFilter.keyword;
                    
                    break;
                }
            }
        }
    }
	
    // 设置搜索品牌
	[hotelsearcher setBrandIDs:[conditions safeObjectForKey:HOTELFILTER_BRANDS]];
	
    [hotelsearcher setFilter:1];
	
	// 设置消费券、担保筛选条件
	[hotelsearcher setMutipleFilter:[conditions safeObjectForKey:HOTELFILTER_MUTIPLECONDITION]];
    
    // 设置设施
    [hotelsearcher setFacilitiesFilter:[conditions safeObjectForKey:HOTELFILTER_FACILITIES]];

    // 公寓
    [hotelsearcher setIsApartment:[[conditions safeObjectForKey:HOTELFILTER_APARTMENT] boolValue]];
    
    // 主题
    [hotelsearcher setThemesFilter:[conditions safeObjectForKey:HOTELFILTER_THEMES]];
    
    // 可入住人
    [hotelsearcher setNumbersOfRoom:[[conditions safeObjectForKey:HOTELFILTER_NUMBER] intValue]];
    
	[Utils request:HOTELSEARCH req:[hotelsearcher requesString:YES] delegate:self];
}



// 更新顶部提示信息
- (void)resetTipLabel {
	UILabel *countlabel = (UILabel *)[self.view viewWithTag:kCountLabelTag];
	countlabel.text=[NSString stringWithFormat:_string(@"s_totalhotelcount"),[HotelSearch tonightHotelCount]];
}

//创建更多按钮
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

- (void)clickMoreButton
{
    isRequstMore = NO;
    listTableView.tableFooterView = tableFootView;
    [self morehotel];
}

-(void)morehotel
{
	JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
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
    
    if(isMapShow)
    {
        [self addMapLoadingView];
    }
}

- (void)forbidSearchMoreHotel
{
	moreBtn.enabled = NO;
	[moreBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateNormal];
}

- (void)restoreSearchMoreHotel
{
	moreBtn.enabled = YES;
	[moreBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
}

- (void)addMoreHotels
{
    [self resetTipLabel];
    
    [listTableView reloadData];
    listTableView.hidden = [HotelSearch tonightHotelCount] == 0 ? YES : NO;
    
	tonightHotelCount = [[HotelSearch tonightHotels] count];
	
	if (tonightHotelCount >= [HotelSearch tonightHotelCount]) {
		listTableView.tableFooterView = nil;
        [self forbidSearchMoreHotel];
        
	}else {
		if (!tableFootView) {
			[self makeMoreLoadingView];
		}
		listTableView.tableFooterView = tableFootView;
        [self restoreSearchMoreHotel];
 	}
    
    if(tonightHotelCount>0)
    {
        nullTipLabel.hidden=true;
        listTableView.hidden=isMapShow;
        mapView.hidden=!isMapShow;
    }
    else
    {
        nullTipLabel.hidden=false;
        mapView.hidden=true;
        listTableView.hidden=true;
    }
    if (tonightHotelCount == 0) {
        hiddenlabel.hidden = YES;
        hiddenbutton.hidden = YES;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    listTableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT -20-44-45);
    [UIView commitAnimations];
    hiddencellcount = 0;
}

//刷新数据
- (void)refreshData {
	[tableImgeDict removeAllObjects];
	[progressManager removeAllObjects];
    isRequstMore = NO;
    
    [self addMoreHotels];
}

//判断是否需要显示更多按钮
- (void)checkFoot {
	if (tonightHotelCount >= [HotelSearch tonightHotelCount]) {
		listTableView.tableFooterView = nil;
	}else {
		listTableView.tableFooterView = tableFootView;
	}
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    [blackView release];
    
    //右上角"更多"按钮
	self.originItem = self.navigationItem.rightBarButtonItem;
	self.moreBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, NAVBAR_WORDBTN_WIDTH, NAVBAR_ITEM_HEIGHT)] autorelease];
    self.moreBtn.exclusiveTouch = YES;
	moreBtn.adjustsImageWhenDisabled = NO;
	moreBtn.titleLabel.font = FONT_B15;
	[moreBtn setTitle:@"显示更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [moreBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
	[moreBtn addTarget:self action:@selector(morehotel) forControlEvents:UIControlEventTouchUpInside];
	self.moreItem = [[[UIBarButtonItem alloc] initWithCustomView:moreBtn] autorelease];
    
    //默认列表模式
    isMapShow=false;
    //数据显示容器
    animationView=[[UIView alloc] initWithFrame:CGRectMake(0, 0 ,320, SCREEN_HEIGHT -20-44)];
    animationView.backgroundColor = [UIColor whiteColor];
    
    hiddencellcount = 0;
    hiddenlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    hiddenlabel.backgroundColor = [UIColor colorWithRed:36/255.0 green:114/255.0 blue:208/255.0 alpha:1.0];
    hiddenlabel.text = [NSString stringWithFormat:@"点击显示%d个隐藏酒店",hiddencellcount];
    hiddenlabel.textColor = [UIColor whiteColor];
    hiddenlabel.textAlignment = NSTextAlignmentCenter;
    hiddenlabel.font = FONT_14;
    [animationView addSubview:hiddenlabel];
    [hiddenlabel release];
    hiddenbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    hiddenbutton.frame = hiddenlabel.frame;
    [animationView addSubview:hiddenbutton];
    [hiddenbutton addTarget:self action:@selector(showhidden) forControlEvents:UIControlEventTouchUpInside];

    //列表
    listTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT -20-44-45) style:UITableViewStylePlain];
	listTableView.delegate=self;
    listTableView.backgroundColor = [UIColor whiteColor];
	listTableView.dataSource=self;
	listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.hidden=isMapShow;
	[animationView addSubview:listTableView];
    [listTableView release];
    //地图    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-20-44-45)];
    float zoomLevel = MAP_ZOOM_LEVEL;
    MKCoordinateRegion region = MKCoordinateRegionMake([[PositioningManager shared] myCoordinate],MKCoordinateSpanMake(zoomLevel,zoomLevel));
    [mapView setRegion:[mapView regionThatFits:region] animated:NO];
    mapView.delegate=self;
    mapView.showsUserLocation = YES;
    mapView.hidden=!isMapShow;
    [animationView addSubview:mapView];
    [mapView release];
    
    [self.view addSubview:animationView];
    [animationView release];

    //没有酒店提示
    nullTipLabel					= [[UILabel alloc] initWithFrame:CGRectMake(50, 0 , 180, 40)];
	nullTipLabel.backgroundColor	= [UIColor clearColor];
    nullTipLabel.textColor          = RGBACOLOR(93, 93, 93, 1);
	nullTipLabel.text				= @"未找到符合条件的酒店";
	nullTipLabel.textAlignment		= UITextAlignmentCenter;
	nullTipLabel.font				= [UIFont boldSystemFontOfSize:16];
	nullTipLabel.center				=  CGPointMake(self.view.center.x, self.view.center.y - 44);
	nullTipLabel.hidden=true;
    [animationView addSubview:nullTipLabel];
	[nullTipLabel release];
    
    //加载底部信息支持条
    [self addListFooterView];
    [self addMapFooterView];
    listFooterView.hidden = NO;
    mapFooterView.hidden = YES;
    
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    // 拷贝来自正常列表的关键词
    JHotelKeywordFilter *normalFilter = searchReq.keywordFilter;
    [searchReq setIsFromLastMinute:YES];
    JHotelKeywordFilter *lmFilter = searchReq.keywordFilter;
    [lmFilter copyDataFrom:normalFilter];

    [self performSelector:@selector(getTonightHotels) withObject:nil afterDelay:0.1];
    

    if (MONKEY_SWITCH){
        // 开启monkey时，地图屏蔽版权点击区域
        UIView *mapCover = [[UIView alloc] initWithFrame:CGRectMake(0, mapView.bounds.size.height - 30, 50, 30)];
        mapCover.backgroundColor = [UIColor clearColor];
        [mapView addSubview:mapCover];
        [mapCover release];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.selectIndexPath) {
        [listTableView deselectRowAtIndexPath:self.selectIndexPath animated:YES];
    }
}

- (void)showhidden
{
    [self performSelector:@selector(getTonightHotels) withObject:nil afterDelay:0.0];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}



- (void)getFavorSuccess:(NSNotification *)noti{
	if (animateView) {
        ElongClientAppDelegate *delegate =  (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        UIWindow *window = delegate.window;
        [window addSubview:animateView];
        [animateView release];
        
        // 动画
        [UIView animateWithDuration:.6 animations:^{
            animateView.frame = CGRectMake(SCREEN_WIDTH - 54, 26, 30, 30);
            animateView.alpha = 0;
        } completion:^(BOOL finished) {
            [animateView removeFromSuperview];
            animateView = nil;
        }];
        
        // 停止监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ADDFAVOR_SUCCESS object:nil];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        double latitude  = [[currentcelldict safeObjectForKey:@"Latitude"] doubleValue];
        double longitude  = [[currentcelldict safeObjectForKey:@"Longitude"] doubleValue];
        [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(latitude, longitude) title:[currentcelldict safeObjectForKey:@"HotelName"]];
    }
}

- (void)getTonightHotels{
    JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
    //[hotelsearcher setMutipleFilter:@"52"];
    [hotelsearcher resetPage];
    
    if (USENEWNET) {
        if (tonightUtil) {
            [tonightUtil cancel];
            SFRelease(tonightUtil);
        }
        
        tonightUtil = [[HttpUtil alloc] init];
        
        [tonightUtil sendSynchronousRequest:HOTELSEARCH PostContent:[hotelsearcher requesString:YES] CachePolicy:CachePolicyHotelList Delegate:self];
    }
    
    // 刷新筛选状态
    [self updateFilterIcon];
    
    
    // 刷新价格状态
    [self updatePriceIcon];
    
    // 刷新排序
    [self updateSortIcon];
}

- (void)switchViews:(id)sender
{
    //切换试图
    isMapShow=!isMapShow;
    if(tonightHotelCount>0)
    {
        listTableView.hidden=isMapShow;
        mapView.hidden=!isMapShow;
    }
    
    if (!isMapShow)
    {
        mapFooterView.hidden = YES;
        listFooterView.hidden = NO;
        self.navigationItem.rightBarButtonItem = originItem;
    }
    else
    {
        mapFooterView.hidden = NO;
        listFooterView.hidden = YES;
        self.navigationItem.rightBarButtonItem = moreItem;
    }
    
    
    //动画
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    if (!isMapShow)
    {
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromLeft
                               forView:animationView cache:YES];
        [animationView bringSubviewToFront:listFooterView];
    }
    else
    {
        [UIView setAnimationTransition:
         UIViewAnimationTransitionFlipFromRight
                               forView:animationView cache:YES];
        if(!mapAnnotations)
        {
            [self addmark];
        }
        [animationView bringSubviewToFront:mapFooterView];
    }
    
    [UIView commitAnimations];
}

- (NSString *) getAddressTipsFromHotel:(NSDictionary *)hotel{
    NSString *tips = @"";
    if ([hotel safeObjectForKey:RespHL__DistrictName]!=[NSNull null]) {
        if([hotel safeObjectForKey:RespHL__BusinessAreaName]!=[NSNull null] && [hotel safeObjectForKey:RespHL__BusinessAreaName]){
            if ([[hotel safeObjectForKey:RespHL__DistrictName] isEqualToString:[hotel safeObjectForKey:RespHL__BusinessAreaName]]) {
                tips = [NSString stringWithFormat:@"%@",[hotel safeObjectForKey:RespHL__DistrictName]];
            }else{
                tips = [NSString stringWithFormat:@"%@  %@",[hotel safeObjectForKey:RespHL__DistrictName],[hotel safeObjectForKey:RespHL__BusinessAreaName]];
            }
        }else{
            tips = [NSString stringWithFormat:@"%@",[hotel safeObjectForKey:RespHL__DistrictName]];
        }
        
    }
    return tips;
}

#pragma mark -
#pragma mark ImageDown Delegate

- (void)imageDidLoad:(NSDictionary *)imageInfo
{
	UIImage *image          = [imageInfo safeObjectForKey:keyForImage];
	NSIndexPath *indexPath	= [imageInfo safeObjectForKey:keyForPath];
	NSString *keyName		= [imageInfo safeObjectForKey:keyForName];
	
	if (image && indexPath && keyName) {
		NSDictionary *celldata = [NSDictionary dictionaryWithObjectsAndKeys:
								  indexPath, @"indexPath",
								  image, @"image",
								  keyName, @"name",
								  nil];
		
		[self performSelectorOnMainThread:@selector(setCellImageWithData:) withObject:celldata waitUntilDone:NO];
	}
}

#pragma mark -
#pragma mark TableView
#pragma mark thread

- (void)setCellImageWithData:(id)celldata
{
	NSString *name		= [celldata safeObjectForKey:@"name"];
	UIImage *img		= [celldata safeObjectForKey:@"image"];
	NSIndexPath *index	= [celldata safeObjectForKey:@"indexPath"];
	
	if (img && name && index) {
        
		[tableImgeDict safeSetObject:img forKey:name];
		HotelListCell *cell = (HotelListCell *)[listTableView cellForRowAtIndexPath:index];
		[cell.hotelImageView endLoading];
		cell.hotelImageView.image = img;
	}
}

- (void)requestImageWithURLPath:(NSString *)path AtIndexPath:(NSIndexPath *)indexPath
{
    
    // 从url请求图片
	NSDictionary *hotel = [[HotelSearch tonightHotels] safeObjectAtIndex:indexPath.row];
	
	NSString *hotelID	= [hotel safeObjectForKey:RespHL__HotelId_S];
	
	if(STRINGHASVALUE(hotelID)) {
		if (![progressManager safeObjectForKey:hotelID]) {
			// 过滤重复请求
			ImageDownLoader *downLoader = [[ImageDownLoader alloc] initWithURLPath:path keyString:hotelID indexPath:indexPath];
			[queue addOperation:downLoader];
			downLoader.delegate		= self;
			downLoader.noDataImage	= [UIImage imageNamed:@"bg_nohotelpic.png"];
			//[downLoader startDownloadWithURLPath:path keyString:hotelID indexPath:indexPath];
			[progressManager safeSetObject:downLoader forKey:hotelID];
			[downLoader release];
		}
	}
}

-(void)hoteldetail:(NSString *)hotelId CheckonDate:(NSString *)CheckonDate CheckoutDate:(NSString *)CheckoutDate
{
	linktype = HOTELDETAIL;
	
	JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:hotelId];
    if (isSevenDay) {
        [hoteldetail setSevenDay:YES];
    }
	[hoteldetail setCheckDateByElongDate:CheckonDate checkoutdate:CheckoutDate];
	[Utils request:HOTELSEARCH req:[hoteldetail requesString:YES] delegate:self];
}

-(void)showDetails:(id)sender
{
	UIButton *btn = (UIButton *)sender;
	NSString *hotelId = [btn currentTitle];
    selRow = -1;
	
	JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
	NSString *CheckonDate = [hotelsearcher getObject:ReqHS_CheckInDate_ED];
	NSString *CheckoutDate = [hotelsearcher getObject:ReqHS_CheckOutDate_ED];
	
	[self hoteldetail:hotelId CheckonDate:CheckonDate CheckoutDate:CheckoutDate];
}

- (double)azimuthFrom:(CLLocation *) location_a to:(CLLocation *)location_b
{
    double d = 0;
    double lat_a = location_a.coordinate.latitude * M_PI / 180;
    double lng_a = location_a.coordinate.longitude * M_PI / 180;
    double lat_b = location_b.coordinate.latitude * M_PI / 180;
    double lng_b = location_b.coordinate.longitude * M_PI / 180;
    
    d = sin(lat_a) * sin(lat_b) + cos(lat_a) * cos(lat_b) * cos(lng_b - lng_a);
    d = sqrt(1 - d * d);
    d = cos(lat_b) * sin(lng_b - lng_a) / d;
    d = asin(d) * 180 / M_PI;
    
    return d;
}

- (NSInteger)getDiscount:(NSDictionary *)hotel
{
    NSInteger formerPirce = 0;
    if ([hotel safeObjectForKey:@"LmOriPrice"]!=[NSNull null] && [hotel safeObjectForKey:@"LmOriPrice"])
    {
        formerPirce = [[hotel safeObjectForKey:@"LmOriPrice"] intValue];
    }
    
    NSInteger price = [[NSString stringWithFormat:@"%.f",[[hotel safeObjectForKey:RespHL__LowestPrice_D] floatValue]] intValue];
    
    if (formerPirce == 0)
    {
        return 0;
    }
    else if(formerPirce - price<=0)
    {
        return 0;
    }
    else
    {
        return (price + 0.0) * 10/formerPirce;
    }
}

#pragma mark - UITableViewDelegate、UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger row =[indexPath row];
    NSDictionary *hotel = [[HotelSearch tonightHotels] safeObjectAtIndex:row];
	
    // 存储数据源
    [[ElongDataCache sharedInstance] setObject:hotel forKey:HOTELLISTCELLDATASOURCE];
    
    HotelListCell *cell =  nil;
    BOOL showImage = [[SettingManager instanse] defaultDisplayHotelPic];


    NSString* HotelListModeCellIdentifier = @"HotelListCellIdentifier";
    cell = (HotelListCell *)[tableView dequeueReusableCellWithIdentifier:HotelListModeCellIdentifier];
    if (cell == nil) {
        cell = [[[HotelListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HotelListModeCellIdentifier haveImage:showImage haveAction:YES] autorelease];
    }
    
    cell.indexPath = indexPath;
    cell.dataIndex = row;
    cell.isLM = YES;
    
    // 设置cell数据源
    cellAction.parentNav = self.rootController.navigationController;
    cellDataSource.keyword  = nil;
    cell.actionDelegate = cellAction;
    cell.dataSource = cellDataSource;
    cell.delegate = self;
    
    // 刷新数据
    [cell reloadCell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[HotelSearch tonightHotels] count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndexPath = indexPath;
    
    [self.orderView dismissInView];
    
    NSUInteger row =[indexPath row];
    [HotelSearch setCurrentIndex:row];
     selRow = row;
    
    NSDictionary *hotel = [[HotelSearch tonightHotels] safeObjectAtIndex:row];
    NSString *hotelId = [hotel safeObjectForKey:RespHL__HotelId_S];

    // 今日特价日期处理
    NSString *checkindate = [TimeUtils displayDateWithNSTimeInterval:[[NSDate date] timeIntervalSince1970] formatter:@"yyyy-MM-dd"];
    NSString *checkoutdate = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+24*60*60) formatter:@"yyyy-MM-dd"];
    
	NSString *checkindatestring = [TimeUtils makeJsonDateWithDisplayNSStringFormatter:checkindate formatter:@"yyyy-MM-dd"];
	NSString *checkoutdatestring = [TimeUtils makeJsonDateWithDisplayNSStringFormatter:checkoutdate formatter:@"yyyy-MM-dd"];
 


    
    if ([hotel safeObjectForKey:@"HotelSpecialType"]) {
        isSevenDay = YES;
    }
    [self hoteldetail:hotelId CheckonDate:checkindatestring CheckoutDate:checkoutdatestring];
    
    
    JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
    HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
    promotionInfoRequest.orderEntrance = OrderEntranceLMList;
    promotionInfoRequest.checkinDate = checkindatestring;
    promotionInfoRequest.checkoutDate = checkoutdatestring;
    promotionInfoRequest.hotelId = hotelId;
    promotionInfoRequest.hotelName = [hotel safeObjectForKey:RespHL__HotelName_S];
    promotionInfoRequest.cityName = hotelsearcher.cityName;
    promotionInfoRequest.star = [hotel safeObjectForKey:RespHL__StarCode_I];
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
    if (listTableView.tableFooterView && !isRequstMore) {
        // 当还有更多酒店时在滑到倒数第5行时发起请求
		NSArray *array = [listTableView visibleCells];
        NSIndexPath *cellIndex = [listTableView indexPathForCell:[array lastObject]];
        
        if (cellIndex.row >= [[HotelSearch tonightHotels] count] - 5) {
            isRequstMore = YES;
            [self morehotel];
        }
	}
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {

    
    if (util == tonightUtil) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:root]) {
            listTableView.tableFooterView = nil;
            isRequstMore = NO;
            
            return ;
        }
        
        // 周边搜索情况，传入品牌和星级信息
        JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
        [hotelsearcher setBrandAndStar:root];
        
        
        if ([root safeObjectForKey:@"HotelCount"] != [NSNull null] && [root safeObjectForKey:@"HotelCount"]) {
            [HotelSearch setTonightHotelCount:[[root safeObjectForKey:@"HotelCount"] intValue]];
        }else{
            [HotelSearch setTonightHotelCount:0];
        }
        if ([root safeObjectForKey:@"MinPrice"] != [NSNull null] && [root safeObjectForKey:@"MinPrice"]) {
            [HotelSearch setTonightMinPrice:[[root safeObjectForKey:@"MinPrice"] floatValue]];
        }else{
            [HotelSearch setTonightMinPrice:0.0f];
        }
        
        NSArray *dataArray = [root safeObjectForKey:RespHL_HotelList_A];
        
        //先清空再添加
        [[HotelSearch tonightHotels] removeAllObjects];
        [[HotelSearch tonightHotels] addObjectsFromArray:dataArray];
        
        [self refreshData];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.3f];
        listTableView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT -20-44-43);
        [UIView commitAnimations];
        hiddencellcount = 0;
    }
    else if (util == moreHotelReq) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        
        NSArray *dataArray = [root safeObjectForKey:RespHL_HotelList_A];
        [[HotelSearch tonightHotels] addObjectsFromArray:dataArray];
        tonightHotelCount += [dataArray count];
        
        //更新数据过后，刷新表格与地图得显示
        [listTableView reloadData];
        
        [self addMoreHotels];
        [self addmark];
        [self checkFoot];
        if(isMapShow)
        {
            [self removeMapLoadingView];
        }
        
        isRequstMore = NO;
    }
    else{
        switch (linktype) {
            case HOTELDETAIL:
            {
                NSDictionary *root = [PublicMethods unCompressData:responseData];
                if ([Utils checkJsonIsError:root]) {
                    return ;
                }
                
                [[HotelDetailController hoteldetail] addEntriesFromDictionary:root];
                [[HotelDetailController hoteldetail] removeRepeatingImage];
                HotelDetailController *hoteldetail = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
                if (selRow == -1) {
                    hoteldetail.listImageUrl = nil;
                }else{
                    hoteldetail.listImageUrl = [[[HotelSearch tonightHotels] safeObjectAtIndex:selRow] safeObjectForKey:RespHL__PicUrl_S];
                }
                ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate.navigationController pushViewController:hoteldetail animated:YES];
                [hoteldetail release];
                
                JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
                NSString *CheckonDate = [hotelsearcher getObject:ReqHS_CheckInDate_ED];
                NSString *CheckoutDate = [hotelsearcher getObject:ReqHS_CheckOutDate_ED];
                HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
                promotionInfoRequest.orderEntrance = OrderEntranceLMMap;
                promotionInfoRequest.checkinDate = CheckonDate;
                promotionInfoRequest.checkoutDate = CheckoutDate;
                promotionInfoRequest.hotelId = [root safeObjectForKey:RespHL__HotelId_S];
                promotionInfoRequest.hotelName = [root safeObjectForKey:RespHL__HotelName_S];
                promotionInfoRequest.cityName = hotelsearcher.cityName;
                promotionInfoRequest.star = [root safeObjectForKey:@"NewStarCode"];
            }
                break;
            case HOTELFILTER:{
                NSDictionary *root = [PublicMethods unCompressData:responseData];
                if ([Utils checkJsonIsError:root]) {
                    return ;
                }
                
                // 周边搜索情况，传入品牌和星级信息
                JHotelSearch *hotelsearcher = [HotelPostManager tonightsearcher];
                [hotelsearcher setBrandAndStar:root];
                
                
                [[HotelSearch tonightHotels] removeAllObjects];
                [[HotelSearch tonightHotels] addObjectsFromArray:[root safeObjectForKey:RespHL_HotelList_A]];
                [HotelSearch setTonightHotelCount:[[root safeObjectForKey:RespHL_HotelCount_I] intValue]];
                
                tonightHotelCount = [[HotelSearch tonightHotels] count];
                [self refreshData];
                [self addmark];
                [listTableView setContentOffset:CGPointMake(0, 0)];
            }
                break;
            case HOTELFAV:{
                NSDictionary *root = [PublicMethods unCompressData:responseData];
                if ([Utils checkJsonIsError:root]) {
                    return ;
                }
                
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
                break;
                default:
                break;
        }
    }
    
    linktype = -1;
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if (util == moreHotelReq) {
        isRequstMore = YES;
        listTableView.tableFooterView = moreHotelButton;
    }
}


- (void)httpConnectionDidCanceled:(HttpUtil *)util {
    if (util == moreHotelReq) {
        isRequstMore = YES;
        listTableView.tableFooterView = moreHotelButton;
    }
}

#pragma mark HotelSearchFilterDelegate

// 退出
- (void) filterViewControllerDidCancel:(HotelSearchFilterController *)filterViewController{
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
    
    [self getFilterConditions:info];
    
    [self updateFilterIcon];
}

@end
