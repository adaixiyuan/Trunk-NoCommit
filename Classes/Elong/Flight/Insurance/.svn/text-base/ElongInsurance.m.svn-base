//
//  ElongInsurance.m
//  ElongClient
//
//  Created by chenggong on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ElongInsurance.h"
#import "ElongURL.h"
#import "Utils.h"
#import "FlightData.h"
#import "FlightDataDefine.h"

@interface ElongInsurance()

@property (nonatomic, copy) NSString *productID;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *basePrice;
@property (nonatomic, copy) NSString *timeLimit;
@property (nonatomic, copy) NSString *insuranceAmount;
@property (nonatomic, retain) NSArray *insuranceRules;
@property (nonatomic, retain) NSMutableDictionary *insuranceRequestParams;
@property (nonatomic, retain) HttpUtil *insuranceHttpUtil;
@property (nonatomic, assign) NSUInteger errorIndex;
@property (nonatomic, copy) NSString *insuranceCount;

@end

@implementation ElongInsurance

- (void)dealloc
{
    self.insuranceRequestParams = nil;
    self.productID = nil;
    self.productName = nil;
    self.salePrice = nil;
    self.basePrice = nil;
    self.insuranceRules = nil;
    
    [_insuranceHttpUtil cancel];
    _insuranceHttpUtil.delegate = nil;
    self.insuranceHttpUtil = nil;
    
    [super dealloc];
}

+ (ElongInsurance *)shareInstance
{
    static ElongInsurance *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[ElongInsurance alloc] init];
    });
    
    return _shareInstance;
}

#pragma mark - Public methods.
- (void)getInsuranceData
{
    if (_insuranceRequestParams == nil) {
        NSMutableDictionary *tempMutableDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        self.insuranceRequestParams = tempMutableDictionary;
        [self buildPostData];
    }
    
    if (_insuranceHttpUtil) {
        [_insuranceHttpUtil cancel];
    }
    else {
        self.insuranceHttpUtil = [[[HttpUtil alloc] init] autorelease];
    }
    [_insuranceHttpUtil connectWithURLString:FLIGHT_SERACH
                             Content:[self requesStringWithCompress:YES]
                        StartLoading:NO
                          EndLoading:NO
                            Delegate:self];
    
    
//    [Utils request:FLIGHT_SERACH req:[self requesStringWithCompress:YES] delegate:self];
}

- (NSString *)getProductID
{
    return _productID;
}

- (NSString *)getProductName
{
    return _productName;
}

- (NSString *)getSalePrice
{
    return _salePrice;
}

- (NSString *)getBasePrice
{
    return _basePrice;
}

- (NSString *)getTimeLimit
{
    return _timeLimit;
}

- (NSString *)getInsuranceLimit
{
    NSString *insuranceLimitString = [[[NSString alloc] init] autorelease];
    NSArray *insuranceLimitArray = [_insuranceAmount componentsSeparatedByString:@"<br/>"];
    NSUInteger insuranceLimitIndex = 0;
    for (NSString *insuranceLimit in insuranceLimitArray) {
        if (insuranceLimitIndex > 0 && insuranceLimitIndex < 3) {
            insuranceLimitString = [insuranceLimitString stringByAppendingFormat:@"%@\n", insuranceLimit];
        }
        insuranceLimitIndex++;
    }
    
    return insuranceLimitString;
}

- (NSString *)getInsuranceAmount
{
    return _insuranceAmount;
}

- (NSString *)getInsuranceCount
{
    return _insuranceCount;
}

- (float)getInsuranceTotalPrice
{
    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
        return [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * [[[ElongInsurance shareInstance] getSalePrice] floatValue];
    }
    else {
        return [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * [[[ElongInsurance shareInstance] getSalePrice] floatValue] * 2;
    }
}

- (BOOL)insuranceCanBuy:(NSString *)age
{
    NSInteger intAge = [age integerValue];
    for (NSDictionary *insuranceLimit in _insuranceRules) {
        if ([[insuranceLimit safeObjectForKey:@"StartAge"] integerValue] <= intAge && intAge <= [[insuranceLimit safeObjectForKey:@"EndAge"] integerValue]) {
            if ([[insuranceLimit safeObjectForKey:@"MaxNumber"] integerValue] > 0) {
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - Private methods.
- (void)buildPostData {
	[_insuranceRequestParams safeSetObject:[PostHeader header] forKey:Resq_Header];
}

- (void)handleInsuranceReturn:(NSDictionary *)resultDic
{
    NSDictionary *recordDic = [resultDic safeObjectForKey:@"Record"];
    
    self.productID = [recordDic safeObjectForKey:@"ProductID"];
    self.productName = [recordDic safeObjectForKey:@"ProductName"];
    self.salePrice = [recordDic safeObjectForKey:@"SalePrice"];
    self.basePrice = [recordDic safeObjectForKey:@"BasePrice"];
    self.timeLimit = [recordDic safeObjectForKey:@"TimeLimit"];
    self.insuranceAmount = [recordDic safeObjectForKey:@"ProductDesc"];
    self.insuranceRules = [recordDic safeObjectForKey:@"InsuranceRules"];
}


- (NSString *)requesStringWithCompress:(BOOL)iscompress {
    NSString *departureCity = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_FLIGHT_DEPARTCITYNAME];
    [_insuranceRequestParams safeSetObject:departureCity forKey:@"CityName"];

	return [NSString stringWithFormat:@"action=GetInsuranceRule&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"], [_insuranceRequestParams JSONRepresentationWithURLEncoding]];
}

//-(void)generateAge{
//    NSDate *curDate = [NSDate date];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *dateComponts = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:curDate];
//    
//    NSString *tempBirth = [NSString stringWithFormat:@"%.2d%.2d",[dateComponts month], [dateComponts day]];
//    if ([birthday isKindOfClass:[NSNull class]]) {
//        return;
//    }
//    self.age = [dateComponts year] - [birthday_year intValue];
//    if ([tempBirth compare:birthday] == NSOrderedAscending) {
//        self.age = [dateComponts year] - [birthday_year intValue] - 1;
//    } else {
//        self.age = [dateComponts year] - [birthday_year intValue];
//    }
//}

- (NSString *)generateAgeWithYear:(NSString *)intYear andBirthDay:(NSString *)intBirthday{
    
    NSDate *curDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponts = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:curDate];
    
    NSString *tempBirth = [NSString stringWithFormat:@"%.2d%.2d",[dateComponts month], [dateComponts day]];
    
    int currentAge = 0;
    
//    currentAge = [dateComponts year] - [intYear intValue];
    if ([tempBirth compare:intBirthday] == NSOrderedAscending) {
        currentAge = [dateComponts year] - [intYear intValue] - 1;
    } else {
        currentAge = [dateComponts year] - [intYear intValue];
    }
    
    return [NSString stringWithFormat:@"%d", currentAge];
}

#pragma mark -
#pragma mark NetDelegate
- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (_errorIndex < 1) {
        [self getInsuranceData];
        self.errorIndex++;
    }
    else {
        self.errorIndex = 0;
    }
    
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if ([Utils checkJsonIsErrorNoAlert:root]) {
        if (_errorIndex < 1) {
            [self getInsuranceData];
            self.errorIndex++;
        }
        else {
            self.errorIndex = 0;
        }
		return;
	}
    [self handleInsuranceReturn:root];
}

@end
