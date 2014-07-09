//
//  IFlyDataAnalyzer.m
//  ElongClient
//
//  Created by Dawn on 14-3-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "IFlyDataAnalyzer.h"
#import "FastPositioning.h"
#import "HotelConditionRequest.h"
#import "PositioningManager.h"
#import "HotelPostManager.h"

typedef void (^CaseBlock)();

@interface IFlyDataAnalyzer(){
      NSDateFormatter *_dateFormat;           // 时期格式化
}
@property (nonatomic,retain) NSDictionary           *slotDict;
@property (nonatomic,copy)   NSString               *text;
@property (nonatomic,copy)   NSString               *checkindate;
@property (nonatomic,copy)   NSString               *checkoutdate;
@property (nonatomic,copy)   NSString               *city;
@property (nonatomic,assign) NSInteger                minPrice;
@property (nonatomic,assign) NSInteger                maxPrice;
@property (nonatomic,assign) CLLocationCoordinate2D   coordinate2D;
@property (nonatomic,copy)   NSString               *star;
@property (nonatomic,copy)   NSString               *hotelName;
@property (nonatomic,copy)   NSString               *poi;
@property (nonatomic,copy)   NSString               *region;
@property (nonatomic,assign) BOOL                     position;
@property (nonatomic,assign) BOOL                     isPrepay;
@property (nonatomic,assign) BOOL                     isCoupon;
@property (nonatomic,assign) BOOL                     isNoGuarantee;
@property (nonatomic,assign) BOOL                     isLM;
@property (nonatomic,assign) BOOL                     isHouse;
@property (nonatomic,assign) BOOL                     isVIP;
@property (nonatomic,assign) NSInteger                peopleCount;
@property (nonatomic,copy)   NSString               *facility;
@property (nonatomic,copy)   NSString               *brand;
@property (nonatomic,copy)   NSString               *theme;
@end

@implementation IFlyDataAnalyzer

- (void) dealloc{
    [_dateFormat   release];
    self.slotDict     = nil;
    self.delegate     = nil;
    [self resetData];
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        [self resetData];
        
        _dateFormat       = [[NSDateFormatter alloc] init];
        [_dateFormat setDateFormat:@"yyyy-MM-dd"];
    }
    return self;
}

- (void) resetData{
    self.checkindate   = nil;
    self.checkoutdate  = nil;
    self.city          = nil;
    self.position      = NO;
    self.minPrice      = -1;
    self.maxPrice      = -1;
    self.star          = nil;
    self.hotelName     = nil;
    self.poi           = nil;
    self.region        = nil;
    self.text          = nil;
    self.isPrepay      = NO;
    self.isCoupon      = NO;
    self.isNoGuarantee = NO;
    self.isLM          = NO;
    self.isHouse       = NO;
    self.isVIP         = NO;
    self.peopleCount   = -1;
    self.facility      = nil;
    self.brand         = nil;
    self.theme         = nil;
}

- (void) dealWithResult:(NSArray *)results{
    BOOL canAction = NO;
    BOOL failed = NO;
    [self resetData];
    
    for (NSString *resultStr in results) {
        NSDictionary *result = [resultStr JSONValue];
        // 识别结果
        if ([[result objectForKey:IFLY_SERVICE] isEqualToString:IFLY_HOTEL]) {
            // 只处理可识别为酒店类型的情况
            self.text = [result objectForKey:IFLY_TEXT];
            // 处理有语意的结果
            if ([result objectForKey:IFLY_SEMANTIC]) {
                // 处理有槽点情况
                NSDictionary *slots = [[result objectForKey:IFLY_SEMANTIC] objectForKey:IFLY_SLOTS];
                for (NSString *key in [slots allKeys]) {
                    [self dealWithSlots:slots key:key];
                }
                canAction = YES;
            }
        }
        if (result) {
            failed = YES;
        }
    }
    
    if (canAction) {
        // 搜索
        [self search];
    }else{
        if (failed) {
            if ([self.delegate respondsToSelector:@selector(iFlyDataAnalyzerFailed:errorCode:)]) {
                [self.delegate iFlyDataAnalyzerFailed:self errorCode:IFlyDataAnalyzerNotHotel];
            }
        }
    }
}

// 配置搜索参数
- (void) search{
    // 快速定位一下
    FastPositioning *position = [FastPositioning shared];
    position.autoCancel = YES;
    [position fastPositioning];
    
    // 数据预处理
    // 城市
    if(!self.city){
        self.city = [[PositioningManager shared] currentCity];
    }
    // 入住日期
    if(!self.checkindate){
        self.checkindate = [_dateFormat stringFromDate:[NSDate date]];
    }
    // 离店日期
    if(!self.checkoutdate){
        self.checkoutdate = [_dateFormat stringFromDate:[[_dateFormat dateFromString:self.checkindate] dateByAddingTimeInterval:24 * 60 * 60]];
    }
    
    // 价格
    if (self.position) {
        if(self.poi){
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:[NSString stringWithFormat:@"%@%@",self.city,self.poi] completionHandler:^(NSArray *placemarks,NSError *error){
                //地理信息编码查询
                if ([placemarks count] >0) {
                    CLPlacemark *placemark = [placemarks objectAtIndex:0];
                    CLLocationCoordinate2D coordinate = placemark.location.coordinate;  //坐标的经纬度信息
                    self.coordinate2D = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
                    if(ABS(self.coordinate2D.latitude) > 0.0f || ABS(self.coordinate2D.longitude) > 0.0f){
                        [self action];
                    }else{
                        if ([self.delegate respondsToSelector:@selector(iFlyDataAnalyzerFailed:errorCode:)]) {
                            [self.delegate iFlyDataAnalyzerFailed:self errorCode:IFlyDataAnalyzerUnFindPOI];
                        }
                    }
                }
            }];
        }else{
            self.coordinate2D = CLLocationCoordinate2DMake([[PositioningManager shared] myCoordinate].latitude, [[PositioningManager shared] myCoordinate].longitude);
            [self action];
        }
    }else{
        [self action];
    }
}


// 开始应用内酒店搜索
- (void) action{
    // 清理关键词
    HotelConditionRequest *hcReq = [HotelConditionRequest shared];
	[hcReq clearKeywordFilter];
    
    // 清理搜索页关键词
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTELSEARCH_KEYWORDCHANGE
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:@"" forKey:HOTEL_SEARCH_KEYWORD]];
    
    // 设置搜索条件
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [hotelsearcher clearBuildData];
    [hotelsearcher setCityName:self.city];
    if (self.position) {
        
        [hotelsearcher setCurrentPos:HOTEL_NEARBY_RADIUS
                           Longitude:self.coordinate2D.longitude
                            Latitude:self.coordinate2D.latitude];
        if (self.poi) {
            HotelConditionRequest *request = [HotelConditionRequest shared];
            request.keywordFilter.keywordType = HotelKeywordTypePOI;
            request.keywordFilter.keyword = self.poi;
            request.keywordFilter.lat = self.coordinate2D.latitude;
            request.keywordFilter.lng = self.coordinate2D.longitude;
        }else{
            
        }
    }
    
    // 区域
    if(self.region){
        [hotelsearcher setAreaName:self.region];
        HotelConditionRequest *request = [HotelConditionRequest shared];
        request.keywordFilter.keywordType = HotelKeywordTypeBusiness;
        request.keywordFilter.keyword = self.region;
    }
    
    // 星级
    if (self.star) {
        [hotelsearcher setStarCodes:self.star];
    }
    
    // 价格
    if (self.minPrice > 0 || self.maxPrice >0) {
        [hotelsearcher setMinPrice:[NSString stringWithFormat:@"%d",self.minPrice]
                          MaxPrice:[NSString stringWithFormat:@"%d",self.maxPrice]];
    }
    
    // 酒店名
    if (self.hotelName) {
        // 有酒店名时去掉周边搜索
        [hotelsearcher resetPosition];
        [hotelsearcher setHotelName:self.hotelName];
        HotelConditionRequest *request = [HotelConditionRequest shared];
        request.keywordFilter.keywordType = HotelKeywordTypeNormal;
        request.keywordFilter.keyword = self.hotelName;
    }

    
    // 入离日期
    [hotelsearcher setCheckData:self.checkindate checkoutdate:self.checkoutdate];
    
    // 特殊酒店类型
    NSString *mutipleCondition = [NSString stringWithFormat:@"%d%d", 0, 0];
    int temp = [mutipleCondition intValue];
    // 多供应商、7天酒店和预付酒店,在二进制的基础上增加1110100.即加116
    temp += 52;
    //龙萃
    if (self.isVIP) {
        // 登录状态
        BOOL isLogin = [[AccountManager instanse] isLogin];
        int userLevel = [[[AccountManager instanse] DragonVIP] intValue];
        if (isLogin && userLevel == 2) {
            temp += 64;
        }
    }
    
    // 使用消费券
    if (self.isCoupon) {
        temp += 1;
    }
    
    // 非担保
    if (self.isNoGuarantee) {
        temp += 2;
    }
    
    // 预付
    if (self.isPrepay) {
        temp += 512;
    }
    
    mutipleCondition = [NSString stringWithFormat:@"%d",temp];
    [hotelsearcher setMutipleFilter:mutipleCondition];
    
    // 公寓
    if (self.isHouse) {
        // 公寓
        [hotelsearcher setIsApartment:YES];
    }
    
    // 今日特价
    if (self.isLM) {
        [hotelsearcher setFilter:YES];
    }
    
    // 入住人数
    if (self.peopleCount>0) {
        [hotelsearcher setNumbersOfRoom:self.peopleCount];
    }
    
    // 设置
    if(self.facility){
        [hotelsearcher setFacilitiesFilter:self.facility];
    }
    
    // 主题
    if (self.theme) {
        [hotelsearcher setThemesFilter:self.theme];
    }
    
    // 品牌
    if (self.brand) {
        [hotelsearcher setBrandIDs:self.brand];
    }
    
    if([self.delegate respondsToSelector:@selector(iFlyDataAnalyzer:doneWithContent:)]){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.text forKey:@"Text"];
        [dict setObject:self.city forKey:@"City"];
        if (self.position) {
            if (self.poi) {
                [dict setObject:self.poi forKey:@"POI"];
            }else{
                [dict setObject:@"周边" forKey:@"POI"];
            }
        }
        if (self.region) {
            [dict setObject:self.region forKey:@"Region"];
        }
        if (self.minPrice > 0 || self.maxPrice > 0) {
            [dict setObject:[NSString stringWithFormat:@"%d",self.minPrice] forKey:@"MinPrice"];
        }
        if (self.maxPrice > 0 || self.minPrice > 0) {
            [dict setObject:[NSString stringWithFormat:@"%d",self.maxPrice] forKey:@"MaxPrice"];
        }
        if (self.star) {
            [dict setObject:self.star forKey:@"Stars"];
        }
        if (self.isPrepay) {
            [dict setObject:@"预付" forKey:@"Category"];
        }else if (self.isNoGuarantee) {
            [dict setObject:@"非担保" forKey:@"Category"];
        }else if (self.isVIP) {
            [dict setObject:@"龙萃" forKey:@"Category"];
        }else if(self.isCoupon){
            [dict setObject:@"可返现" forKey:@"Category"];
        }else if (self.isHouse){
            [dict setObject:@"公寓" forKey:@"Category"];
        }else if(self.isLM){
            [dict setObject:@"今日特价" forKey:@"Category"];
        }
        
        if (self.peopleCount > 0) {
            [dict setObject:[NSString stringWithFormat:@"%d",self.peopleCount] forKey:@"PeopleCount"];
        }
        
        if (self.facility) {
            [dict setObject:self.facility forKey:@"Facility"];
        }
        
        if (self.theme) {
            [dict setObject:self.theme forKey:@"Theme"];
        }
        
        if (self.brand) {
            [dict setObject:self.brand forKey:@"Brand"];
        }
        
        [self.delegate iFlyDataAnalyzer:self doneWithContent:dict];
    }
}

#pragma mark -
#pragma mark 识别结果处理，分析各类槽点

- (void) dealWithSlots:(NSDictionary *)slots key:(NSString *)key{
    self.slotDict = @{
                      IFLY_CHECKINDATE:Block_copy(^() {
                          // 入住日期
                          [self dealWithDate:slots];
                      }),IFLY_CHECKOUTDATE:Block_copy(^() {
                          // 离店日期
                          [self dealWithDate:slots];
                      }),IFLY_NAME:Block_copy(^(){
                          // 酒店名
                          [self dealWithHotelName:slots];
                      }),IFLY_LOCATION:Block_copy(^(){
                          // 酒店地址
                          [self dealWithLocation:slots];
                      }),IFLY_PRICEMAX:Block_copy(^(){
                          // 最高价格
                          [self dealWithPrice:slots];
                      }),IFLY_PRICEMIN:Block_copy(^(){
                          // 最低价格
                          [self dealWithPrice:slots];
                      }),IFLY_PRICEMOD:Block_copy(^(){
                          // 特殊价格类型
                          [self dealWithPrice:slots];
                      }),IFLY_HOTELLVLMIN:Block_copy(^(){
                          // 最低星级
                          [self dealWithStar:slots];
                      }),IFLY_HOTELLVLMAX:Block_copy(^(){
                          // 最高星级
                          [self dealWithStar:slots];
                      }),IFLY_HOTELLVLMOD:Block_copy(^(){
                          // 特殊星级类型
                          [self dealWithStar:slots];
                      }),IFLY_THEME:Block_copy(^(){
                          // 酒店主题
                          [self dealWithTheme:slots];
                      }),IFLY_FACILITY:Block_copy(^(){
                          // 酒店设施
                          [self dealWithFacility:slots];
                      }),IFLY_CATEGORY:Block_copy(^(){
                          // 酒店类型
                          [self dealWithCategory:slots];
                      }),IFLY_PEOPLECOUNT:Block_copy(^(){
                          // 酒店入住人数 暂不处理 by Dawn
                          // [self dealWithPeopleCount:slots];
                      }),IFLY_BRAND:Block_copy(^(){
                          // 酒店品牌
                          [self dealWithBrand:slots];
                      })};
    
    if ([self.slotDict objectForKey:key]) {
        ((CaseBlock)[self.slotDict objectForKey:key])();
    }
}

// 处理酒店类型
- (void) dealWithCategory:(NSDictionary *)slots{
    /**
     可预付
     可返现
     免担保
     今日特价
     公寓     
     龙萃
     */
    NSString *category = [slots objectForKey:IFLY_CATEGORY];
    if ([category rangeOfString:@"可预付"].length) {
        self.isPrepay = YES;
    }else if([category rangeOfString:@"可返现"].length){
        self.isCoupon = YES;
    }else if([category rangeOfString:@"免担保"].length){
        self.isNoGuarantee = YES;
    }else if([category rangeOfString:@"今日特价"].length){
        self.isLM = YES;
    }else if([category rangeOfString:@"公寓"].length){
        self.isHouse = YES;
    }else if([category rangeOfString:@"龙萃"].length){
        self.isVIP = YES;
    }
}

// 处理酒店入住人数
- (void) dealWithPeopleCount:(NSDictionary *)slots{
    NSString *peopleCount = [slots objectForKey:IFLY_PEOPLECOUNT];
    self.peopleCount = [self getPeopleCount:peopleCount];
}

- (NSInteger) getPeopleCount:(NSString *)people{
    if([people rangeOfString:@"一"].length){
        return 1;
    }else if([people rangeOfString:@"二"].length || [people rangeOfString:@"两"].length){
        return 2;
    }else if([people rangeOfString:@"三"].length){
        return 3;
    }else if([people rangeOfString:@"四"].length){
        return 4;
    }else if([people rangeOfString:@"五"].length){
        return 5;
    }else if([people rangeOfString:@"六"].length){
        return 6;
    }
    return -1;
}

// 处理酒店主题
- (void) dealWithTheme:(NSDictionary *)slots{
    self.theme = [slots objectForKey:IFLY_THEME];
}

// 处理酒店设施
- (void) dealWithFacility:(NSDictionary *)slots{
    self.facility = [slots objectForKey:IFLY_FACILITY];
}

// 处理酒店品牌
- (void) dealWithBrand:(NSDictionary *)slots{
    self.brand = [slots objectForKey:IFLY_BRAND];
}

// 处理入离店日期
- (void) dealWithDate:(NSDictionary *)slots{
    // 入住日期
    if ([slots objectForKey:IFLY_CHECKINDATE]) {
        NSString *type = [[slots objectForKey:IFLY_CHECKINDATE] objectForKey:IFLY_CHECKINDATE_TYPE];
        if([type isEqualToString:IFLY_DT_BASIC] || [type isEqualToString:IFLY_DT_INTERVAL]){
            NSString *checkindate = [[slots objectForKey:IFLY_CHECKINDATE] objectForKey:IFLY_CHECKINDATE_DATE];
            if ([checkindate isEqualToString:IFLY_CURRENT_DAY]) {
                // 当天
                self.checkindate = [_dateFormat stringFromDate:[NSDate date]];
            }else{
                // 读取日期
                self.checkindate = checkindate;
            }
        }
    }
    if(!self.checkindate){
        self.checkindate = [_dateFormat stringFromDate:[NSDate date]];
    }
    
    // 如果没有离店日期
    if(![slots objectForKey:IFLY_CHECKOUTDATE]){
        // 入住日期的后一天
        self.checkoutdate = [_dateFormat stringFromDate:[[_dateFormat dateFromString:self.checkindate] dateByAddingTimeInterval:24 * 60 * 60]];
    }else{
        NSString *type = [[slots objectForKey:IFLY_CHECKOUTDATE] objectForKey:IFLY_CHECKOUTDATE_TYPE];
        if([type isEqualToString:IFLY_DT_BASIC] || [type isEqualToString:IFLY_DT_INTERVAL]){
            NSString *checkoutdate = [[slots objectForKey:IFLY_CHECKOUTDATE] objectForKey:IFLY_CHECKOUTDATE_DATE];
            if ([checkoutdate isEqualToString:IFLY_CURRENT_DAY]) {
                // 入住日期的后一天
                self.checkoutdate = [_dateFormat stringFromDate:[[_dateFormat dateFromString:self.checkindate] dateByAddingTimeInterval:24 * 60 * 60]];
            }else{
                // 读取日期
                self.checkoutdate = checkoutdate;
            }
        }
    }
    if(!self.checkoutdate){
        self.checkoutdate = [_dateFormat stringFromDate:[[_dateFormat dateFromString:self.checkindate] dateByAddingTimeInterval:24 * 60 * 60]];
    }
}

// 处理酒店名
- (void) dealWithHotelName:(NSDictionary *)slots{
    if([slots objectForKey:IFLY_NAME]){
        self.hotelName = [slots objectForKey:IFLY_NAME];
    }
}

// 处理位置信息
- (void) dealWithLocation:(NSDictionary *)slots{
    NSDictionary *location = [slots objectForKey:IFLY_LOCATION];
    NSString *type = [location objectForKey:IFLY_LOCATION_TYPE];
    NSString *city = [location objectForKey:IFLY_LOCATION_CITYADDR];
    if(!city){
        city = [location objectForKey:IFLY_LOCATION_CITY];
    }
    if([city isEqualToString:IFLY_CURRENT_CITY]){
        // 当前城市
        self.city = [[PositioningManager shared] currentCity];
    }else{
        self.city = city;
    }
    
    // 强制设为默认城市
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    self.city = hotelsearcher.cityName;
    
    self.position = NO;
    self.poi = nil;
    self.region = nil;
    
    if ([type isEqualToString:IFLY_LOC_BASIC]) {
        // 只有城市的情况
        if ([location objectForKey:IFLY_LOCATION_AREA]) {
            self.region = [location objectForKey:IFLY_LOCATION_AREA];
        }
    }else if([type isEqualToString:IFLY_LOC_STREET]){
        self.position = YES;
        // 街道
        self.poi = [NSString stringWithFormat:@"%@",[location objectForKey:IFLY_LOCATION_STREET]];
    }else if([type isEqualToString:IFLY_LOC_CROSS]){
        self.position = YES;
        // 十字路口
        self.poi = [NSString stringWithFormat:@"%@",[location objectForKey:IFLY_LOCATION_STREET]];
    }else if([type isEqualToString:IFLY_LOC_REGION]){
        // 区域
        self.region = [location objectForKey:IFLY_LOCATION_REGION];
    }else if([type isEqualToString:IFLY_LOC_POI]){
        // poi
        self.position = YES;
        if ([[location objectForKey:IFLY_LOCATION_POI] isEqualToString:IFLY_CURRENT_POI]) {
            self.poi = nil;
            
            // 对于用户所选城市与定位城市不一致情况，不进行周边搜索
            if (![self.city isEqualToString:[[PositioningManager shared] currentCity]]) {
                self.position = NO;
            }
        }else{
            self.poi = [NSString stringWithFormat:@"%@",[location objectForKey:IFLY_LOCATION_POI]];
        }
    }
}

// 处理价格信息
- (void) dealWithPrice:(NSDictionary *)slots{
    if([slots objectForKey:IFLY_PRICEMOD]){
        NSString *mod = [slots objectForKey:IFLY_PRICEMOD];
        if([mod isEqualToString:@"左右"]||[mod isEqualToString:@"上下"]){
            if([slots objectForKey:IFLY_PRICEMIN]){
                self.minPrice = [[slots objectForKey:IFLY_PRICEMIN] intValue];
            }else if([slots objectForKey:IFLY_PRICE]){
                self.minPrice = [[slots objectForKey:IFLY_PRICE] intValue];
            }
            
            if([slots objectForKey:IFLY_PRICEMAX]){
                self.maxPrice = [[slots objectForKey:IFLY_PRICEMAX] intValue];
            }else if([slots objectForKey:IFLY_PRICE]){
                self.maxPrice = [[slots objectForKey:IFLY_PRICE] intValue];
            }
        }else if([mod isEqualToString:@"以上"]){
            if ([slots objectForKey:IFLY_PRICE]) {
                self.minPrice = [[slots objectForKey:IFLY_PRICE] intValue];
                self.maxPrice = -1;
            }
        }else if([mod isEqualToString:@"以下"]||[mod isEqualToString:@"以内"]){
            if ([slots objectForKey:IFLY_PRICE]) {
                self.minPrice = -1;
                self.maxPrice = [[slots objectForKey:IFLY_PRICE] intValue];
            }
        }
    }else{
        if([slots objectForKey:IFLY_PRICEMIN]){
            self.minPrice = [[slots objectForKey:IFLY_PRICEMIN] intValue];
        }
        
        if([slots objectForKey:IFLY_PRICEMAX]){
            self.maxPrice = [[slots objectForKey:IFLY_PRICEMAX] intValue];
        }
    }
   
    // 处理价格相等的情况
    if (self.minPrice == self.maxPrice && self.minPrice > 0) {
        NSInteger price = 50;
        if (self.minPrice > 500) {
            price = 100;
        }else{
            price = 50;
        }
        self.minPrice = MAX(0, self.minPrice - price);
        self.maxPrice = self.maxPrice + price;
    }
    
    // 处理价格反转的情况
    if(self.minPrice > self.maxPrice && self.maxPrice > 0){
        NSInteger price = self.minPrice;
        self.minPrice = self.maxPrice;
        self.maxPrice = price;
    }
}

// 处理星级
- (void) dealWithStar:(NSDictionary *)slots{
    NSInteger minStar = 0;
    NSInteger maxStr = 0;
    if ([slots objectForKey:IFLY_HOTELLVLMOD]) {
        NSString *mod = [slots objectForKey:IFLY_HOTELLVLMOD];
        if([mod isEqualToString:@"左右"]||[mod isEqualToString:@"上下"]){
            minStar = [self numOfStar:[slots objectForKey:IFLY_HOTELLVL]];
            maxStr = minStar;
        }else if([mod isEqualToString:@"以上"]){
            minStar = [self numOfStar:[slots objectForKey:IFLY_HOTELLVL]];
            minStar++;
            maxStr = 5;
        }else if([mod isEqualToString:@"以下"]||[mod isEqualToString:@"以内"]){
            maxStr = [self numOfStar:[slots objectForKey:IFLY_HOTELLVL]];
            maxStr--;
            minStar = 0;
        }
    }else{
        minStar = [self numOfStar:[slots objectForKey:IFLY_HOTELLVLMIN]];
        maxStr = [self numOfStar:[slots objectForKey:IFLY_HOTELLVLMAX]];
        
    }
    
    // 处理星级大于5的情况
    if (minStar > 5) {
        minStar = 5;
    }
    if (maxStr > 5) {
        maxStr = 5;
    }
    
    // 处理星级小于0的情况
    if (minStar < 0) {
        minStar = 0;
    }
    
    if (maxStr < 0) {
        maxStr = 0;
    }
    
    
    // 处理星级反转的情况
    if(minStar > maxStr){
        NSInteger star = minStar;
        minStar = maxStr;
        maxStr = star;
    }
    
    
    //STAR_LIMITED_NONE
    NSMutableArray *stars = [NSMutableArray array];
    for (int i = minStar; i <= maxStr; i++) {
        switch (i) {
            case 0:
            case 1:
            case 2:{
                if (![stars containsObject:STAR_LIMITED_OTHER]) {
                    [stars addObject:STAR_LIMITED_OTHER];
                }
            }
                break;
            case 3:{
                [stars addObject:STAR_LIMITED_THREE];
            }
                break;
            case 4:{
                [stars addObject:STAR_LIMITED_FOUR];
            }
                break;
            case 5:{
                [stars addObject:STAR_LIMITED_FIVE];
            }
                break;
            default:
                break;
        }
    }
    if (stars.count) {
        self.star = [stars componentsJoinedByString:@","];
    }
}

- (NSInteger) numOfStar:(NSString *)star{
    if([star rangeOfString:@"一"].length){
        return 1;
    }else if([star rangeOfString:@"二"].length || [star rangeOfString:@"两"].length){
        return 2;
    }else if([star rangeOfString:@"三"].length){
        return 3;
    }else if([star rangeOfString:@"四"].length){
        return 4;
    }else if([star rangeOfString:@"五"].length){
        return 5;
    }
    return 0;
}

@end
