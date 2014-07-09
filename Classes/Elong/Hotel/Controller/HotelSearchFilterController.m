//
//  HotelSearchFilterController.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelSearchFilterController.h"
#import "Utils.h"
#import "HotelConditionRequest.h"
#import "ElongURL.h"
#import "TonightHotelListMode.h"
#import "DefineHotelReq.h"
#import "CommonDefine.h"
#import "SubConditionDisplayViewController.h"
#import "ConditionDisplayViewController.h"
#import "CountlyEventShow.h"
#import "CountlyEventClick.h"

#define NOLIMIT                        @"不限"
#define FILTERBUTTON_TAG_STAR          1025
#define FILTERBUTTON_TAG_BRAND         1026
#define FILTERBUTTON_TAG_LOCATION      1027
#define FILTERBUTTON_TAG_PAYTYPE       1028
#define FILTERBUTTON_TAG_PROMOTIONTYPE 1029
#define FILTERBUTTON_TAG_FACILITY      1030
#define FILTERBUTTON_TAG_THEME         1031
#define FILTERBUTTON_TAG_NUMBER        1032
#define FILTERBUTTON_TAG_HOTELNAME     1033
#define FILTERBUTTON_TAG_STEP          100

@interface HotelSearchFilterController ()

@property (nonatomic, retain) HotelPriceFilterController         *priceController;
@property (nonatomic, retain) HotelStarFilterController          *starController;
@property (nonatomic, retain) UINavigationController             *locationController;
@property (nonatomic, retain) HotelBrandFilterController         *brandController;
@property (nonatomic, retain) HotelOtherFilterController         *otherController;
@property (nonatomic, retain) HotelFacilityFilterController      *facilityController;
@property (nonatomic, retain) HotelRoomerFilterController        *roomerController;
@property (nonatomic, retain) HotelThemeFilterController         *themeController;
@property (nonatomic, retain) HotelPayTypeFilterController       *payTypeController;
@property (nonatomic, retain) HotelPromotionTypeFilterController *promotionTypeController;

@property (nonatomic, retain) NSMutableArray                     *brandArray;
@property (nonatomic, retain) NSMutableArray                     *chainArray;
@property (nonatomic, retain) NSMutableArray                     *facilityArray;
@property (nonatomic, retain) NSMutableArray                     *themeArray;
@property (nonatomic, retain) NSMutableArray                     *payTypeArray;
@property (nonatomic, retain) NSMutableArray                     *promotionTypeArray;
@property (nonatomic, assign) BOOL                                 isChain;

@end

@implementation HotelSearchFilterController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    // 网络请求
    if (locationUtil) {
        [locationUtil cancel];
        SFRelease(locationUtil);
    }
    if (themeUtil) {
        [themeUtil cancel];
        SFRelease(themeUtil);
    }
    
    self.location            = nil;
    self.locationCoor        = nil;
    self.locationInfo        = nil;
    
    self.priceController     = nil;
    self.starController      = nil;
    self.locationController  = nil;
    self.brandController     = nil;
    self.otherController     = nil;
    self.facilityController  = nil;
    self.roomerController    = nil;
    self.themeController     = nil;
    self.payTypeController   = nil;
    self.promotionTypeController = nil;
    
    self.brandIndexs         = nil;
    self.facilityIndexs      = nil;
    self.themeIndexs         = nil;
    self.payTypeIndexs       = nil;
    self.promotionTypeIndexs = nil;
    
    self.brandArray          = nil;
    self.chainArray          = nil;
    self.facilityArray       = nil;
    self.themeArray          = nil;
    self.payTypeArray        = nil;
    self.promotionTypeArray  = nil;
    
    [super dealloc];
}

+ (BOOL) filterLightWithLM:(BOOL)isLM{
    JHotelSearch *hotelsearcher;
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    if (isLM) {
        hotelsearcher = [HotelPostManager tonightsearcher];
    }
    else{
        hotelsearcher = [HotelPostManager hotelsearcher];
    }
    
    // all in one
    if (searchReq.keywordFilter) {
        if (searchReq.keywordFilter.keyword) {
            return YES;
        }else if (searchReq.keywordFilter.poi){
            return YES;
        }
    }
    
    // 龙翠
    BOOL isLogin = [[AccountManager instanse] isLogin];
    int userLevel = [[[AccountManager instanse] DragonVIP] intValue];
    int flag = [[hotelsearcher getMutipleFilter] integerValue];
    BOOL dragonSelected = flag & (1 << 6);
    if (isLogin && userLevel == 2 && dragonSelected) {
        return YES;
    }
    
    // 品牌
    NSArray *brandIDs = [hotelsearcher getBrandIDs];
    if (brandIDs && brandIDs.count) {
        if ([[brandIDs objectAtIndex:0] intValue] != 0) {
            return YES;
        }
    }else{
        return YES;
    }
    
    /* 星级相关
    NSArray *starIndexs = [hotelsearcher getStarCodeIndexs];
    if (starIndexs && starIndexs.count) {
        if ([[starIndexs objectAtIndex:0] intValue] != -1 && [[starIndexs objectAtIndex:0] intValue] != 0) {
            return YES;
        }
    }else{
        return YES;
    }
     */
    
    // 酒店设施
    NSArray *facilitys = [hotelsearcher getFacilitiesFilter];
    if (facilitys && facilitys.count) {
        return YES;
    }
    
    // 酒店主题
    NSArray *themes = [hotelsearcher getThemesFilter];
    if (themes && themes.count) {
        return YES;
    }
    
    // 酒店入住人数
    if ([hotelsearcher getNumbersOfRoom]) {
        return YES;
    }
    
    // 担保消费券相关
    NSString *multiFilter = [hotelsearcher getMutipleFilter];
    NSUInteger flags = [multiFilter integerValue];
    
    int coupon = flags & 1;                 // 是否返现
    int withoutGuaranteed = flags & 2;      // 是否免担保
    int prepay = flags & 512;               // 是否预付
    int limit = flags & 2048;               // 是否限时抢
    
    if (coupon) {
        return YES;
    }
    if (withoutGuaranteed) {
        return YES;
    }
    if (prepay) {
        return YES;
    }
    if (limit) {
        return YES;
    }
    
    //公寓判断
    if ([hotelsearcher getIsApartment]){
        return YES;
    }
    return NO;
}


- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style isLM:(BOOL)lm{
    self = [super initWithTitle:@"筛选" style:NavBarBtnStyleOnlyBackBtn];
    if (self) {
        self.isLM = lm;
        
        HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    
        // 设置初始筛选条件
        if (searchReq.keywordFilter) {
            self.locationInfo = [[[JHotelKeywordFilter alloc] init] autorelease];
            [self.locationInfo copyDataFrom:searchReq.keywordFilter];
        }
        
        // 支付方式
        [self dealWithPayTypes];
        
        // 促销方式
        [self dealWithPromotionTypes];

        // 品牌相关
        [self dealWithBrands];
        
        // 酒店设施
        [self dealWithFacilities];
        
        // 酒店主题
        [self dealWithThemes];
        
        // 酒店入住人数
        [self dealWithNumberOfRoom];
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];

    // countly 页面展示事件
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
    
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    JHotelSearch *hotelsearcher;
    if (self.isLM) {
        hotelsearcher = [HotelPostManager tonightsearcher];
    }
    else{
        hotelsearcher = [HotelPostManager hotelsearcher];
    }
    
    // 周边搜索，接受星级和品牌设置
    if ([hotelsearcher getIsPos]) {
        // 得到品牌
        self.brandArray = [NSMutableArray arrayWithObject:BRAND_LIMITED_NONE];
        for (int i = 0; i < hotelsearcher.brandArray.count; i++) {
            [self.brandArray addObject:[[hotelsearcher.brandArray objectAtIndex:i] objectForKey:@"BrandName"]];
        }
        
        
        self.isChain = NO;
        NSArray *brandIDs = [hotelsearcher getBrandIDs];
        self.brandIndexs = [NSMutableArray arrayWithCapacity:0];
        BOOL allSelected = NO;
        if (brandIDs && brandIDs.count) {
            if ([[brandIDs objectAtIndex:0] intValue] == 0) {
                allSelected = YES;
            }
        }else{
            allSelected = YES;
        }
        if (allSelected) { // 全选
            [self.brandIndexs addObject:[NSNumber numberWithBool:YES]];
        }else{
            [self.brandIndexs addObject:[NSNumber numberWithBool:NO]];
        }
        
        for (int i = 0; i < hotelsearcher.brandArray.count; i++) {
            NSDictionary *brand = [hotelsearcher.brandArray objectAtIndex:i];
            NSInteger brandId = [[brand safeObjectForKey:@"BrandID"] integerValue];
            BOOL selected = NO;
            for (NSString *item in brandIDs) {
                if ([item intValue] == brandId) {
                    selected = YES;
                    break;
                }
            }
            if (selected) {
                [self.brandIndexs addObject:[NSNumber numberWithBool:YES]];
            }else{
                [self.brandIndexs addObject:[NSNumber numberWithBool:NO]];
            }
        }
        
        // 隐藏区域
        [self removeSidebarItem:FilterSidebarItemRegion];
        
    }
    
    // 处理正常情况
    if (!searchReq.isAllDataLoaded) {
        [self requestLocationInfo];
    }
    else {
        if (searchReq.brandArray.count == 0) {
            // 隐藏品牌
            [self removeSidebarItem:FilterSidebarItemBrand];
        }
        if (searchReq.facilityArray.count == 0) {
            // 隐藏设施
            [self removeSidebarItem:FilterSidebarItemFacility];
        }
    }
    
    // 请求主题
    if (!searchReq.isThemeDataLoaded) {
        [self requestThemeInfo];
    }else{
        if (searchReq.themeArray.count == 0) {
            // 隐藏主题
            [self removeSidebarItem:FilterSidebarItemTheme];
        }
    }
    

    // all in one
    if (self.locationInfo) {
        if (self.locationInfo.keywordType == HotelKeywordTypeBusiness
            ||self.locationInfo.keywordType == HotelKeywordTypeDistrict
            ||self.locationInfo.keywordType == HotelKeywordTypePOI
            ||self.locationInfo.keywordType == HotelKeywordTypeSubwayStation
            ||self.locationInfo.keywordType == HotelKeywordTypeAirportAndRailwayStation) {
            if (self.locationInfo.keyword) {
                [self addTipsItem:self.locationInfo.keyword withTag:FILTERBUTTON_TAG_LOCATION animated:NO];
            }else if(self.locationInfo.poi){
                [self addTipsItem:[NSString stringWithFormat:@"%@周边",self.locationInfo.poi] withTag:FILTERBUTTON_TAG_LOCATION animated:NO];
            }
            
        }else if(self.locationInfo.keywordType == HotelKeywordTypeNormal){
            if (self.locationInfo.keyword) {
                [self addTipsItem:self.locationInfo.keyword withTag:FILTERBUTTON_TAG_HOTELNAME animated:NO];
            }else if(self.locationInfo.poi){
                [self addTipsItem:[NSString stringWithFormat:@"%@周边",self.locationInfo.poi] withTag:FILTERBUTTON_TAG_LOCATION animated:NO];
            }
        }
    }

    
    // 品牌
    for (int i = 1; i < self.brandIndexs.count; i++) {
        NSString *brandName = @"";
        if (self.isChain) {
            brandName = [self.chainArray safeObjectAtIndex:i];
        }else{
            brandName = [self.brandArray safeObjectAtIndex:i];
        }
        
        BOOL checked = [[self.brandIndexs objectAtIndex:i] boolValue];
        if (checked) {
            [self addTipsItem:brandName withTag:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }
    
    // 设施
    for (int i = 1; i < self.facilityIndexs.count; i++) {
        NSString *facilityName = @"";
        facilityName = [self.facilityArray safeObjectAtIndex:i];
        BOOL checked = [[self.facilityIndexs objectAtIndex:i] boolValue];
        if (checked) {
            [self addTipsItem:facilityName withTag:FILTERBUTTON_TAG_FACILITY + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }
    
    // 主题
    for (int i = 1; i < self.themeIndexs.count; i++) {
        NSString *themeName = @"";
        themeName = [self.themeArray safeObjectAtIndex:i];
        BOOL checked = [[self.themeIndexs objectAtIndex:i] boolValue];
        if (checked) {
            [self addTipsItem:themeName withTag:FILTERBUTTON_TAG_THEME + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }
    
    // 入住人
    if (self.numberOfRoom) {
        [self addTipsItem:[NSString stringWithFormat:@"%d人",self.numberOfRoom] withTag:FILTERBUTTON_TAG_NUMBER animated:NO];
    }
    
    // 支付方式
    for (int i = 0; i < self.payTypeIndexs.count; i++) {
        NSString *payTypeName = @"";
        payTypeName = [self.payTypeArray objectAtIndex:i];
        BOOL checked = [[self.payTypeIndexs objectAtIndex:i] boolValue];
        if (checked) {
            [self addTipsItem:payTypeName withTag:FILTERBUTTON_TAG_PAYTYPE + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }
    
    // 促销方式
    for (int i = 0; i < self.promotionTypeIndexs.count; i++) {
        NSString *promotionTypeName = @"";
        promotionTypeName = [self.promotionTypeArray objectAtIndex:i];
        BOOL checked = [[self.promotionTypeIndexs objectAtIndex:i] boolValue];
        if (checked) {
            [self addTipsItem:promotionTypeName withTag:FILTERBUTTON_TAG_PROMOTIONTYPE + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }
    
    // 如果有区域选中区域，如果没有选中星级，如果没有星级选中品牌
    for (FilterSidebarItem *item in self.sidebarItems) {
        self.selectedItemType = item.itemType;
        break;
    }
}

#pragma mark -
#pragma mark 请求区域信息和主题信息

- (void) requestLocationInfo{
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    [searchReq clearData];
    
    if (locationUtil) {
        [locationUtil cancel];
        SFRelease(locationUtil);
    }
    
    locationUtil = [[HttpUtil alloc] init];
    [locationUtil sendAsynchronousRequest:OTHER_SEARCH PostContent:[searchReq requestForAllCondition] CachePolicy:CachePolicyHotelArea Delegate:self];
}

- (void) requestThemeInfo{
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    if (themeUtil) {
        [themeUtil cancel];
        SFRelease(themeUtil);
    }
    themeUtil = [[HttpUtil alloc] init];
    [themeUtil sendAsynchronousRequest:HOTELSEARCH PostContent:[searchReq requestForThemes] CachePolicy:CachePolicyNone Delegate:self];
}

#pragma mark -
#pragma mark 处理各种带入参数

// 支付方式
- (void) dealWithPayTypes{
    JHotelSearch *hotelsearcher;
    if (self.isLM) {
        hotelsearcher = [HotelPostManager tonightsearcher];
    }
    else{
        hotelsearcher = [HotelPostManager hotelsearcher];
    }
    
    NSString *multiFilter = [hotelsearcher getMutipleFilter];
    NSUInteger flags = [multiFilter integerValue];
    
    int withoutGuaranteed = flags & 2;
    int prepay = flags & 512;

    
    self.payTypeArray = [NSMutableArray array];
    self.payTypeIndexs = [NSMutableArray array];
    
    
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    for (NSDictionary *dict in searchReq.payTypeArray) {
        if ([[dict objectForKey:@"Type"] intValue] == HotelFilterPayTypePrepay) {
            [self.payTypeArray addObject:[dict objectForKey:@"Name"]];
            [self.payTypeIndexs addObject:[NSNumber numberWithBool:prepay > 0]];
        }else if ([[dict objectForKey:@"Type"] intValue] == HotelFilterPayTypeNoGuarantee) {
            [self.payTypeArray addObject:[dict objectForKey:@"Name"]];
            [self.payTypeIndexs addObject:[NSNumber numberWithBool:withoutGuaranteed > 0]];
        }
    }
}

// 促销方式
- (void) dealWithPromotionTypes{
    JHotelSearch *hotelsearcher;
    if (self.isLM) {
        hotelsearcher = [HotelPostManager tonightsearcher];
    }
    else{
        hotelsearcher = [HotelPostManager hotelsearcher];
    }
    
    // 担保消费券相关
    NSString *multiFilter = [hotelsearcher getMutipleFilter];
    NSUInteger flags = [multiFilter integerValue];
    
    int coupon = flags & 1;

    
    // 龙翠
    BOOL isLogin = [[AccountManager instanse] isLogin];
    int userLevel = [[[AccountManager instanse] DragonVIP] intValue];
    int dragonSelected = flags & (1 << 6);
    
    // 限时抢
    int limit = flags & 2048;
    
    self.promotionTypeArray = [NSMutableArray array];
    self.promotionTypeIndexs = [NSMutableArray array];
    
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    for (NSDictionary *dict in searchReq.promotionTypeArray) {
        if ([[dict objectForKey:@"Type"] intValue] == HotelFilterPromotionTypeCash) {
            [self.promotionTypeArray addObject:[dict objectForKey:@"Name"]];
            [self.promotionTypeIndexs addObject:[NSNumber numberWithBool:coupon > 0]];
        }else if ([[dict objectForKey:@"Type"] intValue] == HotelFilterPromotionTypeVIP) {
            if (isLogin && userLevel == 2) {
                [self.promotionTypeArray addObject:[dict objectForKey:@"Name"]];
                [self.promotionTypeIndexs addObject:[NSNumber numberWithBool:dragonSelected > 0]];
            }
        }else if([[dict objectForKey:@"Type"] intValue] == HotelFilterPromotionTypeLimit){
            [self.promotionTypeArray addObject:[dict objectForKey:@"Name"]];
            [self.promotionTypeIndexs addObject:[NSNumber numberWithBool:limit > 0]];
        }
    }
}

// 处理入住人数
- (void) dealWithNumberOfRoom{
    JHotelSearch *hotelsearcher;
    if (self.isLM) {
        hotelsearcher = [HotelPostManager tonightsearcher];
    }
    else{
        hotelsearcher = [HotelPostManager hotelsearcher];
    }
    self.numberOfRoom = [hotelsearcher getNumbersOfRoom];
}

// 处理主题
- (void) dealWithThemes{
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    
    JHotelSearch *hotelsearcher;
    if (self.isLM) {
        hotelsearcher = [HotelPostManager tonightsearcher];
    }
    else{
        hotelsearcher = [HotelPostManager hotelsearcher];
    }
    
    // 主题相关
    self.themeArray = [NSMutableArray arrayWithObject:THEME_LIMITED_NONE];
    self.themeIndexs = [NSMutableArray arrayWithObject:[NSNumber numberWithBool:YES]];
    
    
   
    
    NSArray *themes = [hotelsearcher getThemesFilter];
    if (searchReq.isThemeDataLoaded) {
        //公寓判断
        [self.themeArray addObject:THEME_APARTMENT];
        for (NSDictionary *dict in searchReq.themeArray) {
            [self.themeArray addObject:[dict objectForKey:THEMENAMECN_HOTEL]];
        }
        
        // 当前主题的选择情况
        self.themeIndexs = [NSMutableArray arrayWithCapacity:0];
        if ((themes && themes.count)||[hotelsearcher getIsApartment]) {
            [self.themeIndexs addObject:[NSNumber numberWithBool:NO]];
        }else{
            // 全选
            [self.themeIndexs addObject:[NSNumber numberWithBool:YES]];
        }
        if ([hotelsearcher getIsApartment]) {
            [self.themeIndexs addObject:[NSNumber numberWithBool:YES]];
        }else{
            [self.themeIndexs addObject:[NSNumber numberWithBool:NO]];
        }
        
        for (NSDictionary *dict in searchReq.themeArray) {
            int value = [[dict objectForKey:THEMEID_HOTEL] intValue];
            BOOL selected = NO;
            for (NSString *item in themes) {
                if ([item intValue] == value) {
                    selected = YES;
                    break;
                }
            }
            if (selected) {
                [self.themeIndexs addObject:[NSNumber numberWithBool:YES]];
            }else{
                [self.themeIndexs addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
}

// 处理设施
- (void)dealWithFacilities{
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    
    JHotelSearch *hotelsearcher;
    if (self.isLM) {
        hotelsearcher = [HotelPostManager tonightsearcher];
    }
    else{
        hotelsearcher = [HotelPostManager hotelsearcher];
    }
    
    // 设施相关
    self.facilityArray = [NSMutableArray arrayWithObject:FACILITY_LIMITED_NONE];
    self.facilityIndexs = [NSMutableArray arrayWithObject:[NSNumber numberWithBool:YES]];
    NSArray *facilitys = [hotelsearcher getFacilitiesFilter];
    if (searchReq.isAllDataLoaded) {
        for (NSDictionary *dict in searchReq.facilityArray) {
            [self.facilityArray addObject:[dict objectForKey:NAME_HOTEL]];
        }
        
        // 当前设施的选择情况
        self.facilityIndexs = [NSMutableArray arrayWithCapacity:0];
        if (facilitys && facilitys.count) {
            [self.facilityIndexs addObject:[NSNumber numberWithBool:NO]];
        }else{
            // 全选
            [self.facilityIndexs addObject:[NSNumber numberWithBool:YES]];
        }
        
        for (NSDictionary *dict in searchReq.facilityArray) {
            int value = [[dict objectForKey:MISID_HOTEL] intValue];
            BOOL selected = NO;
            for (NSString *item in facilitys) {
                if ([item intValue] == value) {
                    selected = YES;
                    break;
                }
            }
            if (selected) {
                [self.facilityIndexs addObject:[NSNumber numberWithBool:YES]];
            }else{
                [self.facilityIndexs addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
}

// 处理品牌
- (void) dealWithBrands{
    HotelConditionRequest *searchReq = [HotelConditionRequest shared];
    
    JHotelSearch *hotelsearcher;
    if (self.isLM) {
        hotelsearcher = [HotelPostManager tonightsearcher];
    }
    else{
        hotelsearcher = [HotelPostManager hotelsearcher];
    }
    
    // 品牌相关
    self.brandArray = [NSMutableArray arrayWithObject:BRAND_LIMITED_NONE];
    self.chainArray = [NSMutableArray arrayWithObject:BRAND_LIMITED_NONE];
    self.brandIndexs = [NSMutableArray arrayWithObject:[NSNumber numberWithBool:YES]];
    self.isChain = hotelsearcher.isChain;
    NSArray *brandIDs = [hotelsearcher getBrandIDs];
    if (searchReq.isAllDataLoaded) {
        // 品牌
        for (NSDictionary *dic in searchReq.brandArray) {
            [self.brandArray addObject:[dic safeObjectForKey:DATANAME_HOTEL]];
        }
        
        // 连锁
        for (NSDictionary *dic in searchReq.chainArray) {
            [self.chainArray addObject:[dic safeObjectForKey:DATANAME_HOTEL]];
        }
        
        // 当前品牌的选择情况
        self.brandIndexs = [NSMutableArray arrayWithCapacity:0];
        BOOL allSelected = NO;
        if (brandIDs && brandIDs.count) {
            if ([[brandIDs objectAtIndex:0] intValue] == 0) {
                allSelected = YES;
            }
        }else{
            allSelected = YES;
        }
        if (allSelected) { // 全选
            [self.brandIndexs addObject:[NSNumber numberWithBool:YES]];
        }else{
            [self.brandIndexs addObject:[NSNumber numberWithBool:NO]];
        }
        
        BOOL AIOContentBrand = NO;
        
        if(!hotelsearcher.isChain){
            for (int i = 0; i < searchReq.brandArray.count; i++) {
                NSDictionary *brand = [searchReq.brandArray objectAtIndex:i];
                NSInteger brandId = [[brand safeObjectForKey:DATAID_HOTEL] integerValue];
                BOOL selected = NO;
                for (NSString *item in brandIDs) {
                    if ([item intValue] == brandId) {
                        selected = YES;
                        AIOContentBrand = YES;
                        break;
                    }
                }
                if (selected) {
                    [self.brandIndexs addObject:[NSNumber numberWithBool:YES]];
                }else{
                    [self.brandIndexs addObject:[NSNumber numberWithBool:NO]];
                }
            }
        }else{
            for (int i = 0; i < searchReq.chainArray.count; i++) {
                NSDictionary *brand = [searchReq.chainArray objectAtIndex:i];
                NSInteger brandId = [[brand safeObjectForKey:DATAID_HOTEL] integerValue];
                BOOL selected = NO;
                for (NSString *item in brandIDs) {
                    if ([item intValue] == brandId) {
                        selected = YES;
                        AIOContentBrand = YES;
                        break;
                    }
                }
                if (selected) {
                    [self.brandIndexs addObject:[NSNumber numberWithBool:YES]];
                }else{
                    [self.brandIndexs addObject:[NSNumber numberWithBool:NO]];
                }
            }
        }
        
        // 如果AIO包含品牌但是当前品牌列表中没有，剔除之
        if (self.locationInfo.keywordType == HotelKeywordTypeBrand) {
            if (!AIOContentBrand) {
                self.locationInfo = nil;
            }
        }
    }
}


#pragma mark Private Methods
- (void) setSelectedItemType:(FilterSidebarItemType)selectedItemType{
    [super setSelectedItemType:selectedItemType];
    
    switch (selectedItemType) {
            
        case FilterSidebarItemRegion:{
            // 区域
            // countly 筛选-区域位置点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_AREA;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
            
            if (self.locationController == nil) {
                HotelSearchConditionViewCtrontroller *controller = [[HotelSearchConditionViewCtrontroller alloc] initWithSearchCity:self.cityName title:@"" navBarBtnStyle:NavBarBtnStyleOnlyHomeBtn displaySearchBar:NO];
                controller.navigationItem.rightBarButtonItem = nil;
                [controller removeConditionItem:HotelKeywordTypeBrand]; // 不筛选品牌
                self.locationController = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
                self.locationController.navigationBarHidden = NO;
                self.locationController.wantsFullScreenLayout = YES;
                self.locationController.delegate = self;
                
                controller.independent = YES;
                controller.delegate = self;
                controller.keywordFilter = self.locationInfo;
                [controller release];
                
                [self.tabContentView addSubview:self.locationController.view];
                self.locationController.view.frame = self.tabContentView.bounds;
            }else{
                [self.tabContentView bringSubviewToFront:self.locationController.view];
                self.locationController.view.frame = self.tabContentView.bounds;
            }
        }
            break;
        case FilterSidebarItemBrand:{
            // 品牌
            // countly 筛选-酒店品牌点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BRAND;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
            
            if (self.brandController == nil) {
                self.brandController = [[[HotelBrandFilterController alloc] initWithNibName:nil bundle:nil] autorelease];
                
                self.brandController.isChain = self.isChain;
                self.brandController.brandArray = [NSArray arrayWithArray:self.brandArray];
                self.brandController.chainArray = [NSArray arrayWithArray:self.chainArray];
                self.brandController.selectedIndexs = self.brandIndexs;
                
                JHotelSearch *hotelsearcher2;
                if (self.isLM) {
                    hotelsearcher2 = [HotelPostManager tonightsearcher];
                }
                else{
                    hotelsearcher2 = [HotelPostManager hotelsearcher];
                }
                if (![hotelsearcher2 getIsPos]) {
                    [self.brandController setNeedChain];
                }
                
                self.brandController.delegate = self;
                [self.tabContentView addSubview:self.brandController.view];
                self.brandController.view.frame = self.tabContentView.bounds;
            }else{
                [self.tabContentView bringSubviewToFront:self.brandController.view];
                self.brandController.view.frame = self.tabContentView.bounds;
            }
        }
            break;
        case FilterSidebarItemPayType:{
            // 支付方式
            // countly 筛选-支付方式点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_PAYTYPE;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
            
            if (self.payTypeController == nil) {
                self.payTypeController = [[[HotelPayTypeFilterController alloc] init] autorelease];
                self.payTypeController.selectedIndexs = self.payTypeIndexs;
                self.payTypeController.payTypeArray = self.payTypeArray;
                self.payTypeController.delegate = self;
                [self.tabContentView addSubview:self.payTypeController.view];
                self.payTypeController.view.frame = self.tabContentView.bounds;
            }else{
                [self.tabContentView addSubview:self.payTypeController.view];
                self.payTypeController.view.frame = self.tabContentView.bounds;
            }
        }
            break;
        case FilterSidebarItemPromotionType:{
            // 促销方式
            // countly 筛选-促销方式点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_PROMOTION;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
            
            if (self.promotionTypeController == nil) {
                self.promotionTypeController = [[[HotelPromotionTypeFilterController alloc] init] autorelease];
                self.promotionTypeController.selectedIndexs = self.promotionTypeIndexs;
                self.promotionTypeController.promotionTypeArray = self.promotionTypeArray;
                self.promotionTypeController.delegate = self;
                [self.tabContentView addSubview:self.promotionTypeController.view];
                self.promotionTypeController.view.frame = self.tabContentView.bounds;
            }else{
                [self.tabContentView addSubview:self.promotionTypeController.view];
                self.promotionTypeController.view.frame = self.tabContentView.bounds;
            }
        }
            break;
        case FilterSidebarItemFacility:{
            // 设施
            // countly 筛选-设施服务点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_SERVICE;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
            
            if (self.facilityController == nil) {
                self.facilityController = [[[HotelFacilityFilterController alloc] init] autorelease];
                self.facilityController.selectedIndexs = self.facilityIndexs;
                self.facilityController.delegate = self;
                self.facilityController.facilityArray = self.facilityArray;
                [self.tabContentView addSubview:self.facilityController.view];
                self.facilityController.view.frame = self.tabContentView.bounds;
            }else{
                [self.tabContentView bringSubviewToFront:self.facilityController.view];
                self.facilityController.view.frame = self.tabContentView.bounds;
            }
        }
            break;
        case FilterSidebarItemRoomer:{
            // 入住人
            if (self.roomerController == nil) {
                self.roomerController = [[[HotelRoomerFilterController alloc] init] autorelease];
                self.roomerController.number = self.numberOfRoom;
                self.roomerController.delegate = self;
                [self.tabContentView addSubview:self.roomerController.view];
                self.roomerController.view.frame = self.tabContentView.bounds;
            }else{
                [self.tabContentView bringSubviewToFront:self.roomerController.view];
                self.roomerController.view.frame = self.tabContentView.bounds;
            }
        }
            break;
        case FilterSidebarItemTheme:{
            // 主题
            // countly 筛选-住宿类型点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_ACCOMMODATION;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
            
            if (self.themeController == nil) {
                self.themeController = [[[HotelThemeFilterController alloc] init] autorelease];
                self.themeController.selectedIndexs = self.themeIndexs;
                self.themeController.delegate = self;
                self.themeController.themeArray = self.themeArray;
                [self.tabContentView addSubview:self.themeController.view];
                self.themeController.view.frame = self.tabContentView.bounds;
            }else{
                [self.tabContentView bringSubviewToFront:self.themeController.view];
                self.themeController.view.frame = self.tabContentView.bounds;
            }
        }
            break;
            
        default:
            break;
    }
}

// 刷新界面
- (void) updateTabContentView{
    // 区域
    if (self.locationController) {
        // 通知更新
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELFILTER_REGIONCHANGE object:nil];
        
        for (UIViewController *vc in self.locationController.viewControllers) {
            if ([vc isKindOfClass:[HotelSearchConditionViewCtrontroller class]]) {
                HotelSearchConditionViewCtrontroller *searchConditionVC = (HotelSearchConditionViewCtrontroller *)vc;
                searchConditionVC.keywordFilter = self.locationInfo;
                [searchConditionVC reloadData];
                break;
            }
        }
    }
    
    // 品牌
    if (self.brandController) {
        self.brandController.isChain = self.isChain;
        self.brandController.brandArray = [NSArray arrayWithArray:self.brandArray];
        self.brandController.chainArray = [NSArray arrayWithArray:self.chainArray];
        self.brandController.selectedIndexs = self.brandIndexs;
        
        JHotelSearch *hotelsearcher2;
        if (self.isLM) {
            hotelsearcher2 = [HotelPostManager tonightsearcher];
        }
        else{
            hotelsearcher2 = [HotelPostManager hotelsearcher];
        }
        if (![hotelsearcher2 getIsPos]) {
            [self.brandController setNeedChain];
        }
    }
    
    // 设施
    if (self.facilityController) {
        self.facilityController.selectedIndexs = self.facilityIndexs;
        self.facilityController.delegate = self;
        self.facilityController.facilityArray = [NSArray arrayWithArray:self.facilityArray];
    }
    
    // 支付方式
    if (self.payTypeController) {
        self.payTypeController.selectedIndexs = self.payTypeIndexs;
        self.payTypeController.delegate = self;
        self.payTypeController.payTypeArray = [NSArray arrayWithArray:self.payTypeArray];
    }
    
    // 促销方式
    if (self.promotionTypeController) {
        self.promotionTypeController.selectedIndexs = self.promotionTypeIndexs;
        self.promotionTypeController.delegate = self;
        self.promotionTypeController.promotionTypeArray = [NSArray arrayWithArray:self.promotionTypeArray];
    }
    
    // 主题
    if (self.themeController) {
        self.themeController.selectedIndexs = self.themeIndexs;
        self.themeController.delegate = self;
        self.themeController.themeArray = [NSArray arrayWithArray:self.themeArray];
    }
    
    // 入住人
    if (self.roomerController) {
        self.roomerController.number = self.numberOfRoom;
        self.roomerController.delegate = self;
    }
}

- (void) checkToSelectAll:(NSMutableArray *)items{
    BOOL allUnChecked = YES;
    for (NSNumber *checked in items) {
        if ([checked boolValue]) {
            allUnChecked = NO;
        }
    }
    if (allUnChecked) {
        if (items.count) {
            [items replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
        }
    }
}

- (void) tipsItemBtnClick:(id)sender{
    [super tipsItemBtnClick:sender];
    
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    if((tag - FILTERBUTTON_TAG_BRAND) % FILTERBUTTON_TAG_STEP == 0){
        // 品牌
        NSInteger index = (tag - FILTERBUTTON_TAG_BRAND) / FILTERBUTTON_TAG_STEP;
        [self.brandIndexs replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
        
        if (self.locationInfo.keywordType == HotelKeywordTypeBrand
            && [self.locationInfo.keyword isEqualToString:btn.titleLabel.text]) {
            self.locationInfo = nil;
        }
        
        [self checkToSelectAll:self.brandIndexs];
    }else if((tag - FILTERBUTTON_TAG_FACILITY) % FILTERBUTTON_TAG_STEP == 0){
        // 设施
        NSInteger index = (tag - FILTERBUTTON_TAG_FACILITY) / FILTERBUTTON_TAG_STEP;
        [self.facilityIndexs replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
        
        [self checkToSelectAll:self.facilityIndexs];
    }else if((tag - FILTERBUTTON_TAG_THEME) % FILTERBUTTON_TAG_STEP == 0){
        // 主题
        NSInteger index = (tag - FILTERBUTTON_TAG_THEME) / FILTERBUTTON_TAG_STEP;
        [self.themeIndexs replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
        
        [self checkToSelectAll:self.themeIndexs];
    }else if((tag - FILTERBUTTON_TAG_PAYTYPE) % FILTERBUTTON_TAG_STEP == 0){
        // 支付方式
        NSInteger index = (tag - FILTERBUTTON_TAG_PAYTYPE) / FILTERBUTTON_TAG_STEP;
        [self.payTypeIndexs replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
    }else if((tag - FILTERBUTTON_TAG_PROMOTIONTYPE) % FILTERBUTTON_TAG_STEP == 0){
        // 促销方式
        NSInteger index = (tag - FILTERBUTTON_TAG_PROMOTIONTYPE) / FILTERBUTTON_TAG_STEP;
        [self.promotionTypeIndexs replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
    }else{
        switch (tag) {
            case FILTERBUTTON_TAG_LOCATION:{         // 区域
                if (self.locationInfo.keywordType == HotelKeywordTypeAirportAndRailwayStation
                    ||self.locationInfo.keywordType == HotelKeywordTypeBusiness
                    ||self.locationInfo.keywordType == HotelKeywordTypeDistrict
                    ||self.locationInfo.keywordType == HotelKeywordTypePOI
                    ||self.locationInfo.keywordType == HotelKeywordTypeSubwayStation) {
                    self.locationInfo = nil;
                }
                self.locationInfo = nil;
            }
                break;
            case FILTERBUTTON_TAG_NUMBER:{           // 入住人
                self.numberOfRoom = 0;
            }
                break;
            case FILTERBUTTON_TAG_HOTELNAME:{        // 酒店名
                if (self.locationInfo.keywordType == HotelKeywordTypeNormal) {
                    self.locationInfo = nil;
                }
            }
                break;
            default:
                break;
        }
    }
    
    [self updateTabContentView];
}

- (void) resetBtnClick:(id)sender{
    [super resetBtnClick:sender];
    
    // countly 筛选-重置点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_RESET;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    self.locationInfo = nil;

    // 品牌
    self.isChain = NO;
    self.brandIndexs = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < self.brandArray.count; i++) {
        if (i == 0) {
            [self.brandIndexs addObject:[NSNumber numberWithBool:YES]];
        }else{
            [self.brandIndexs addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    // 设施
    self.facilityIndexs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.facilityArray.count; i++) {
        if (i == 0) {
            [self.facilityIndexs addObject:[NSNumber numberWithBool:YES]];
        }else{
            [self.facilityIndexs addObject:[NSNumber numberWithBool:NO]];
        }
    }
    // 主题
    self.themeIndexs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.themeArray.count; i++) {
        if (i == 0) {
            [self.themeIndexs addObject:[NSNumber numberWithBool:YES]];
        }else{
            [self.themeIndexs addObject:[NSNumber numberWithBool:NO]];
        }
    }
    
    // 入住人
    self.numberOfRoom = 0;
    
    // 支付方式
    self.payTypeIndexs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.payTypeArray.count; i++) {
        [self.payTypeIndexs addObject:[NSNumber numberWithBool:NO]];
    }
    
    // 促销方式
    self.promotionTypeIndexs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.promotionTypeArray.count; i++) {
        [self.promotionTypeIndexs addObject:[NSNumber numberWithBool:NO]];
    }
    
    // 更新
    [self updateTabContentView];
}


- (void)actionBtnClick:(id)sender{
    [super actionBtnClick:sender];
    
    // countly 筛选-重置点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELFILTERCHOICEPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_CONFIRM;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    JHotelSearch *hotelsearcher;
    if (!self.isLM) {
        // 正常搜索
        hotelsearcher = [HotelPostManager hotelsearcher];
        hotelsearcher.isChain = self.isChain;
    }else{
        // 今日特价
        hotelsearcher = [HotelPostManager tonightsearcher];
        hotelsearcher.isChain = self.isChain;
    }
    
    NSMutableDictionary *filterInfo = [NSMutableDictionary dictionary];
    HotelConditionRequest *condition = [HotelConditionRequest shared];
    
    /*
     设置关键词
     **/
    if (self.locationInfo) {
        condition.keywordFilter.keywordType = self.locationInfo.keywordType;
        condition.keywordFilter.keyword = self.locationInfo.keyword;
        condition.keywordFilter.pid = self.locationInfo.pid;
        condition.keywordFilter.lat = self.locationInfo.lat;
        condition.keywordFilter.lng = self.locationInfo.lng;
    }
    else if (self.locationInfo == nil) {
        [condition clearKeywordFilter];
    }
	
	/*
     勾选项复合条件,注意顺序
     **/
	NSString *mutipleCondition = [NSString stringWithFormat:@"%d%d", 0, 0];
    int temp = [mutipleCondition intValue];
    // 多供应商、7天酒店和预付酒店,在二进制的基础上增加1110100.即加116
    temp += 52;
    
    // 支付方式
    for (int i = 0; i < self.payTypeIndexs.count; i++) {
        if ([[self.payTypeIndexs objectAtIndex:i] boolValue]) {
            for (NSDictionary *dict in condition.payTypeArray) {
                if ([[dict objectForKey:@"Name"] isEqualToString:[self.payTypeArray objectAtIndex:i]]) {
                    if ([[dict objectForKey:@"Type"] intValue] == HotelFilterPayTypeNoGuarantee) {
                        // 非担保
                        temp += 2;
                        break;
                    }else if([[dict objectForKey:@"Type"] intValue] == HotelFilterPayTypePrepay) {
                        // 预付
                        temp += 512;
                        break;
                    }
                }
            }
        }
    }
    
    // 促销方式
    for (int i = 0; i < self.promotionTypeIndexs.count; i++) {
        if ([[self.promotionTypeIndexs objectAtIndex:i] boolValue]) {
            for (NSDictionary *dict in condition.promotionTypeArray) {
                if ([[dict objectForKey:@"Name"] isEqualToString:[self.promotionTypeArray objectAtIndex:i]]) {
                    if ([[dict objectForKey:@"Type"] intValue] == HotelFilterPromotionTypeVIP) {
                        // 龙萃
                        temp += 64;
                        break;
                    }else if([[dict objectForKey:@"Type"] intValue] == HotelFilterPromotionTypeCash) {
                        // 使用消费券
                        temp += 1;
                        break;
                    }else if([[dict objectForKey:@"Type"] intValue] == HotelFilterPromotionTypeLimit){
                        // 限时抢
                        temp += 2048;
                        break;
                    }
                }
            }
        }
    }
    
    mutipleCondition = [NSString stringWithFormat:@"%d",temp];
    [filterInfo setValue:mutipleCondition forKey:HOTELFILTER_MUTIPLECONDITION];

    
    /*
     品牌
     **/
    NSMutableArray *brandNames = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.brandIndexs.count;i++) {
        if ([[self.brandIndexs objectAtIndex:i] boolValue]) {
            if (self.isChain) {
                // 连锁
                if ([self.chainArray objectAtIndex:i]) {
                    [brandNames addObject:[self.chainArray objectAtIndex:i]];
                }
            }else{
                if ([self.brandArray objectAtIndex:i]) {
                    [brandNames addObject:[self.brandArray objectAtIndex:i]];
                }
            }
        }
    }

    NSMutableArray *brandIDs = [NSMutableArray array];
    if (brandNames.count) {
        
        // 合并品牌数据源 城市品牌和周边品牌
		NSMutableArray *brands = [NSMutableArray array];
        for (NSDictionary *dict in condition.brandArray) {
            if ([dict objectForKey:DATANAME_HOTEL] && [dict objectForKey:DATAID_HOTEL]) {
                [brands addObject:[NSDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:DATANAME_HOTEL],@"BrandName",[dict objectForKey:DATAID_HOTEL],@"BrandID", nil]];
            }
        }
        
        JHotelSearch *hotelsearcher;
        if (self.isLM) {
            hotelsearcher = [HotelPostManager tonightsearcher];
        }
        else{
            hotelsearcher = [HotelPostManager hotelsearcher];
        }
        if (hotelsearcher.brandArray.count) {
            [brands addObjectsFromArray:hotelsearcher.brandArray];
        }
        
        //
		for (NSDictionary *dic in brands) {
            for (NSString *brandName in brandNames) {
                if ([brandName isEqualToString:[dic safeObjectForKey:@"BrandName"]]) {
                    [brandIDs addObject:[dic safeObjectForKey:@"BrandID"]];
                    break;
                }
            }
		}
    }else{
        [brandIDs addObject:[NSNumber numberWithInt:0]];
    }
    [filterInfo setValue:[brandIDs componentsJoinedByString:@","] forKey:HOTELFILTER_BRANDS];
    
    
    /*
     region
     **/
    if (self.locationInfo.keyword && self.locationInfo.keyword.length) {
        [filterInfo setValue:self.locationInfo.keyword forKey:HOTELFILTER_AREANAME];
    }
    
    
    /*
     设施
     **/
    NSMutableArray *facilitys = [NSMutableArray array];
    for (int i = 1;i < self.facilityIndexs.count;i++) {
        BOOL checked = [[self.facilityIndexs objectAtIndex:i] boolValue];
        if (checked) {
            // 排除第一项奥
            [facilitys addObject:[[condition.facilityArray objectAtIndex:i - 1] objectForKey:MISID_HOTEL]];
        }
    }
    if (facilitys.count) {
        [filterInfo setValue:[facilitys componentsJoinedByString:@","] forKey:HOTELFILTER_FACILITIES];
    }
    
    
    if (self.themeIndexs.count > 2) {
        /*
         主题
         **/
        NSMutableArray *themes = [NSMutableArray array];
        for (int i = 2;i < self.themeIndexs.count;i++) {
            BOOL checked = [[self.themeIndexs objectAtIndex:i] boolValue];
            if (checked) {
                // 排除第一项和第二项
                [themes addObject:[[condition.themeArray objectAtIndex:i - 2] objectForKey:THEMEID_HOTEL]];
            }
        }
        if (themes.count) {
            [filterInfo setValue:[themes componentsJoinedByString:@","] forKey:HOTELFILTER_THEMES];
        }
    }
    if (self.themeIndexs.count > 1) {
        /*
         公寓
         **/
        BOOL isApartmentCase = [[self.themeIndexs objectAtIndex:1] boolValue];
        [filterInfo setValue:[NSNumber numberWithBool:isApartmentCase] forKey:HOTELFILTER_APARTMENT];
    }
    
    /*
     入住人
     **/
    [filterInfo setValue:NUMBER(self.numberOfRoom) forKey:HOTELFILTER_NUMBER];


    if ([self.delegate respondsToSelector:@selector(filterViewControllerDidAction:withInfo:)]) {
        [self.delegate filterViewControllerDidAction:self withInfo:filterInfo];
    }
}

- (void) addTipsItem:(NSString *)title withTag:(NSInteger)tag{
    [super addTipsItem:title withTag:tag];
    
    // 酒店名与其他筛选项冲突，如果有其他筛选项，删除酒店名
    if (self.locationInfo.keywordType == HotelKeywordTypeNormal && tag != FILTERBUTTON_TAG_HOTELNAME) {
        self.locationInfo = nil;
        [self removeTipsItem:FILTERBUTTON_TAG_HOTELNAME animated:YES];
    }
}

#pragma mark Actions

- (IBAction)locationBack:(id)sender{
    [self.locationController popViewControllerAnimated:YES];
}


#pragma mark HotelBrandFilterDelegate

- (void) hotelBrandFilterController:(HotelBrandFilterController *)brandFilter didSelectIndexs:(NSArray *)indexs isChain:(BOOL)isChain{
    if (isChain != self.isChain) {
        // 移除所有
        for (int i = 0; i < self.brandIndexs.count; i++) {
            [self removeTipsItem:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }
    self.isChain = isChain;
    
    self.brandIndexs = [NSMutableArray arrayWithArray:indexs];
    
    
    // 全选
    BOOL checked = [[self.brandIndexs objectAtIndex:0] boolValue];
    if (checked) {
        for (int i = 1; i < self.brandIndexs.count; i++) {
            [self removeTipsItem:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }else{
        for (int i = 1; i < self.brandIndexs.count; i++) {
            BOOL checked = [[self.brandIndexs objectAtIndex:i] boolValue];
            UIButton *button = (UIButton *)[self tipsItemWithTag:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP];
            if (button) {
                if (checked) {
                    if (self.isChain) {
                        [self updateTipsItem:[self.chainArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP];
                    }else{
                        [self updateTipsItem:[self.brandArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP];
                    }
                }else{
                    [self removeTipsItem:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP animated:NO];
                }
            }else{
                if (checked) {
                    if (self.isChain) {
                        [self addTipsItem:[self.chainArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP];
                    }else{
                        [self addTipsItem:[self.brandArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_BRAND + i * FILTERBUTTON_TAG_STEP];
                    }
                }
            }
        }
    }
}

#pragma mark HotelSearchConditionDelegate

- (void)hotelSearchConditionViewCtrontroller:(HotelSearchConditionViewCtrontroller *)controller didSelect:(JHotelKeywordFilter *)locationInfo{
    self.locationInfo = [[[JHotelKeywordFilter alloc] init] autorelease];
    [self.locationInfo copyDataFrom:locationInfo];
    controller.keywordFilter = self.locationInfo;
    [controller reloadData];
    
    UIButton *button = (UIButton *)[self tipsItemWithTag:FILTERBUTTON_TAG_LOCATION];
    if (button != nil) {
        [self updateTipsItem:locationInfo.keyword withTag:FILTERBUTTON_TAG_LOCATION];
    }
    else {
        [self addTipsItem:locationInfo.keyword withTag:FILTERBUTTON_TAG_LOCATION];
    }
    [self.locationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark HotelFacilityFilterDelegate
- (void) hotelFacilityFilterController:(HotelFacilityFilterController *)facilityFilter didSelectIndexs:(NSArray *)indexs{
     self.facilityIndexs = [NSMutableArray arrayWithArray:indexs];
    
    // 全选
    BOOL checked = [[self.facilityIndexs objectAtIndex:0] boolValue];
    if (checked) {
        for (int i = 1; i < self.facilityIndexs.count; i++) {
            [self removeTipsItem:FILTERBUTTON_TAG_FACILITY + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }else{
        for (int i = 1; i < self.facilityIndexs.count; i++) {
            BOOL checked = [[self.facilityIndexs objectAtIndex:i] boolValue];
            UIButton *button = (UIButton *)[self tipsItemWithTag:FILTERBUTTON_TAG_FACILITY + i * FILTERBUTTON_TAG_STEP];
            if (button) {
                if (checked) {
                    [self updateTipsItem:[self.facilityArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_FACILITY + i * FILTERBUTTON_TAG_STEP];
                }else{
                    [self removeTipsItem:FILTERBUTTON_TAG_FACILITY + i * FILTERBUTTON_TAG_STEP animated:NO];
                }
            }else{
                if (checked) {
                    [self addTipsItem:[self.facilityArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_FACILITY + i * FILTERBUTTON_TAG_STEP];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark HotelThemeFilterDelegate
- (void)hotelThemeFilterController:(HotelThemeFilterController *)facilityFilter didSelectIndexs:(NSArray *)indexs{
    self.themeIndexs = [NSMutableArray arrayWithArray:indexs];
    
    // 全选
    BOOL checked = [[self.themeIndexs objectAtIndex:0] boolValue];
    if (checked) {
        for (int i = 1; i < self.themeIndexs.count; i++) {
            [self removeTipsItem:FILTERBUTTON_TAG_THEME + i * FILTERBUTTON_TAG_STEP animated:NO];
        }
    }else{
        for (int i = 1; i < self.themeIndexs.count; i++) {
            BOOL checked = [[self.themeIndexs objectAtIndex:i] boolValue];
            UIButton *button = (UIButton *)[self tipsItemWithTag:FILTERBUTTON_TAG_THEME + i * FILTERBUTTON_TAG_STEP];
            if (button) {
                if (checked) {
                    [self updateTipsItem:[self.themeArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_THEME + i * FILTERBUTTON_TAG_STEP];
                }else{
                    [self removeTipsItem:FILTERBUTTON_TAG_THEME + i * FILTERBUTTON_TAG_STEP animated:NO];
                }
            }else{
                if (checked) {
                    [self addTipsItem:[self.themeArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_THEME + i * FILTERBUTTON_TAG_STEP];
                }
            }
        }
    }
}

#pragma mark -
#pragma mark HotelRoomerFilterDelegate
- (void) hotelRoomerFilterController:(HotelRoomerFilterController *)facilityFilter didSelectNumber:(NSInteger)number{
    self.numberOfRoom = number;
    if (self.numberOfRoom) {
        UIButton *button = (UIButton *)[self tipsItemWithTag:FILTERBUTTON_TAG_NUMBER];
        if (button) {
            [self updateTipsItem:[NSString stringWithFormat:@"%d人",self.numberOfRoom] withTag:FILTERBUTTON_TAG_NUMBER];
        }else{
            [self addTipsItem:[NSString stringWithFormat:@"%d人",self.numberOfRoom] withTag:FILTERBUTTON_TAG_NUMBER];
        }
    }else{
        [self removeTipsItem:FILTERBUTTON_TAG_NUMBER animated:NO];
    }
}


#pragma mark -
#pragma mark HotelPayTypeFilterDelegate
- (void) hotelPayTypeFilterController:(HotelPayTypeFilterController *)payTypeFilter didSelectIndexs:(NSArray *)indexs{
    self.payTypeIndexs = [NSMutableArray arrayWithArray:indexs];
    
    // 全选
    for (int i = 0; i < self.payTypeIndexs.count; i++) {
        BOOL checked = [[self.payTypeIndexs objectAtIndex:i] boolValue];
        UIButton *button = (UIButton *)[self tipsItemWithTag:FILTERBUTTON_TAG_PAYTYPE + i * FILTERBUTTON_TAG_STEP];
        if (button) {
            if (checked) {
                [self updateTipsItem:[self.payTypeArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_PAYTYPE + i * FILTERBUTTON_TAG_STEP];
            }else{
                [self removeTipsItem:FILTERBUTTON_TAG_PAYTYPE + i * FILTERBUTTON_TAG_STEP animated:NO];
            }
        }else{
            if (checked) {
                [self addTipsItem:[self.payTypeArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_PAYTYPE + i * FILTERBUTTON_TAG_STEP];
            }
        }
    }
}

#pragma mark -
#pragma mark HotelPromotionTypeFilterDelegate
- (void) hotelPromotionTypeFilterController:(HotelPromotionTypeFilterController *)promotionTypeFilter didSelectIndexs:(NSArray *)indexs{
    self.promotionTypeIndexs = [NSMutableArray arrayWithArray:indexs];
    
    // 全选
    for (int i = 0; i < self.promotionTypeIndexs.count; i++) {
        BOOL checked = [[self.promotionTypeIndexs objectAtIndex:i] boolValue];
        UIButton *button = (UIButton *)[self tipsItemWithTag:FILTERBUTTON_TAG_PROMOTIONTYPE + i * FILTERBUTTON_TAG_STEP];
        if (button) {
            if (checked) {
                [self updateTipsItem:[self.promotionTypeArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_PROMOTIONTYPE + i * FILTERBUTTON_TAG_STEP];
            }else{
                [self removeTipsItem:FILTERBUTTON_TAG_PROMOTIONTYPE + i * FILTERBUTTON_TAG_STEP animated:NO];
            }
        }else{
            if (checked) {
                [self addTipsItem:[self.promotionTypeArray safeObjectAtIndex:i] withTag:FILTERBUTTON_TAG_PROMOTIONTYPE + i * FILTERBUTTON_TAG_STEP];
            }
        }
    }
}

#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
	NSDictionary *dic = [PublicMethods unCompressData:responseData];
	
	if ([Utils checkJsonIsErrorNoAlert:dic]) {
		return;
	}
    
    if (util == locationUtil) {
        HotelConditionRequest *searchReq = [HotelConditionRequest shared];
        
        [searchReq setAllCondition:dic];
        
        [self dealWithBrands];
        
        [self dealWithFacilities];
        
        if (searchReq.brandArray.count == 0) {
            // 移除品牌
            [self removeSidebarItem:FilterSidebarItemBrand];
        }
        if (searchReq.facilityArray.count == 0) {
            // 隐藏设施
            [self removeSidebarItem:FilterSidebarItemFacility];
        }
        
        [self updateTabContentView];
    }else if(util == themeUtil){
        HotelConditionRequest *searchReq = [HotelConditionRequest shared];
        
        [searchReq setThemes:dic];
        
        [self dealWithThemes];
        
        [self dealWithBrands];
        
        [self dealWithFacilities];
        
        if (searchReq.brandArray.count == 0) {
            // 移除主题
            [self removeSidebarItem:FilterSidebarItemTheme];
        }
        
        [self updateTabContentView];
    }
}

@end
