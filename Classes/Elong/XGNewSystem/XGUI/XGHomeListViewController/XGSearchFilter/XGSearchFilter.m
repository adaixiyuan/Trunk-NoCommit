//
//  XGSearchFilter.m
//  ElongClient
//
//  Created by guorendong on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.

//

#import "XGSearchFilter.h"
#import "XGHelper.h"
#import "XGApplication+Common.h"
#import "XGHelper.h"
#import "AccountManager.h"
@implementation XGSearchFilter

-(NSString *)cityName
{
    if (_cityName ==nil) {
        _cityName =XGSearchCityName;
    }
    return _cityName;
}

-(NSString *)getCheckinString
{
    NSDateFormatter * oFormat = [[NSDateFormatter alloc] init];
	[oFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *ci =[oFormat stringFromDate:self.cinDate];
    return ci;
}
-(NSString *)getCheckoutString
{
    NSDateFormatter * oFormat = [[NSDateFormatter alloc] init];
	[oFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *co =[oFormat stringFromDate:self.coutDate];
    return co;
}


#pragma mark - NSCoding处理串行化
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cinDate forKey: @"cinDate"];
    [aCoder encodeObject:self.coutDate forKey: @"coutDate"];
    [aCoder encodeObject:self.cityArea forKey: @"cityArea"];
    [aCoder encodeObject:self.maxPrice forKey: @"maxPrice"];
    [aCoder encodeObject:self.cityName forKey: @"cityName"];

    [aCoder encodeObject:self.minPrice forKey:@"minPrice"];
    [aCoder encodeObject:self.longtitude forKey: @"longtitude"];
    [aCoder encodeObject:self.lattitude forKey: @"lattitude"];
    [aCoder encodeObject:self.searchType forKey: @"searchType"];
    
    [aCoder encodeInt:self.sendNum forKey: @"sendNum"];//请求来源
    
    [aCoder encodeObject:[NSNumber numberWithLong:self.timestamp] forKey:@"timestamp"];
    
    [aCoder encodeInt:self.reponseReplayNum forKey: @"reponseReplayNum"];//请求来源
    [aCoder encodeInt:self.perResponseNum forKey: @"perResponseNum"];//上次请求来源
    if (self.reqId) {
        [aCoder encodeObject:self.reqId forKey:@"RequestId"];
    }
    [aCoder encodeObject:self.customerRequestDate forKey: @"customerRequestDate"];//
    [aCoder encodeFloat:self.pinglvForgetResponseCount forKey:@"pinglvForgetResponseCount"];

}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super init];
    if(self)
    {
        self.pinglvForgetResponseCount =[aDecoder decodeFloatForKey:@"pinglvForgetResponseCount"];
        self.cityName = (NSString *)[aDecoder decodeObjectForKey: @"cityName"];
        self.cinDate = (NSDate *)[aDecoder decodeObjectForKey: @"cinDate"];
        self.coutDate = (NSDate *)[aDecoder decodeObjectForKey: @"coutDate"];
        self.cityArea = (NSString *)[aDecoder decodeObjectForKey: @"cityArea"];
        self.maxPrice = (NSString *)[aDecoder decodeObjectForKey: @"maxPrice"];
        self.minPrice = (NSString *)[aDecoder decodeObjectForKey:@"minPrice"];
        self.longtitude = (NSNumber *)[aDecoder decodeObjectForKey: @"longtitude"];
        self.lattitude = (NSNumber *)[aDecoder decodeObjectForKey: @"lattitude"];
        self.searchType = (NSNumber *)[aDecoder decodeObjectForKey: @"searchType"];
        self.reqId =(NSString *)[aDecoder decodeObjectForKey:@"RequestId"];
        self.timestamp=[[aDecoder decodeObjectForKey:@"timestamp"] longValue];
        self.customerRequestDate = [aDecoder decodeObjectForKey:@"customerRequestDate"];
        self.sendNum=[aDecoder decodeIntegerForKey:@"sendNum"];
        self.reponseReplayNum=[aDecoder decodeIntegerForKey:@"reponseReplayNum"];
        self.perResponseNum =(NSNumber *)[aDecoder decodeObjectForKey: @"perResponseNum"];


    }
    return self;
}
#pragma mark - 基类方法

-(id)init
{
    self =[super init];
    if (self) {
        self.pinglvForgetResponseCount=4;
        self.sendNum=0;
        self.reponseReplayNum=0;
        self.perResponseNum =0;
        self.maxPrice=@"-1";
        self.cinDate =[NSDate date];
        self.cityName =XGSearchCityName;
        self.coutDate =[self.cinDate dateByAddingTimeInterval:60*60*24];
    }
    return self;
}

#pragma mark - 自定义方法
//设置获取属性
-(void)setReponseReplayNum:(int)reponseReplayNum
{
    if (reponseReplayNum>self.sendNum) {
        _reponseReplayNum = self.sendNum;
    }
    else
    {
        _reponseReplayNum=reponseReplayNum;
    }
}

//判断是否计时超时
-(BOOL)isTimingOut
{
    if (self.customerRequestDate ==nil) {
        return NO;
    }
    NSTimeInterval now =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    NSTimeInterval start =[self.customerRequestDate timeIntervalSince1970];
    NSTimeInterval different =now-start;
    
    NSNumber *minutes = [[NSUserDefaults standardUserDefaults]objectForKey:C2CRUNLOOP_MINUTES];
    
    int timeout = timeOutMinute;
    if (minutes==nil||[minutes isKindOfClass:[NSNull class]]) {
        
    }else{
        timeout = [minutes intValue];
    }
    
    if (different>60*timeout||different<-60*timeout) {
        return YES;
    }
    return NO;
}

-(NSTimeInterval)getDifferent
{
    NSTimeInterval now =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    NSTimeInterval start =[self.customerRequestDate timeIntervalSince1970];
    NSTimeInterval different =now-start;
    return different;
}
//当前时间与上面时间的误差 当前时间减去参数时间
-(NSTimeInterval)getDifferentSecond:(NSDate *)date
{
    NSTimeInterval now =[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
    NSTimeInterval start =[date timeIntervalSince1970];
    NSTimeInterval different =now-start;
    return different;
    
}

-(NSInteger)loadingDate//过了多少秒了0
{
    if (self.customerRequestDate ==nil) {
        return 0;
    }
    NSTimeInterval different =[self getDifferent];
    return different;
}
-(NSInteger)remainDate//剩余多少秒了0
{
    NSInteger *secondTotal =timeOutMinute*60;
    if (self.customerRequestDate ==nil) {
        return secondTotal;
    }
    NSInteger different =secondTotal-[self loadingDate];
    
    return different;
}


+(NSString *)getPath
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [document stringByAppendingPathComponent:@"XGSearchFilter.txt"];
    return path;
}

-(void)saveFilter
{
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToFile:[XGSearchFilter getPath] atomically:YES];
}

+(XGSearchFilter *)getFilter
{
    NSData *data =[NSData dataWithContentsOfFile:[self getPath]];
    XGSearchFilter *filter =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return filter;
}
//上次搜索条件
+(NSString *)getPerPath
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [document stringByAppendingPathComponent:@"XGSearchPerFilter.txt"];
    return path;
}
-(void)savePerFilter
{
    NSData *data =[NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToFile:[XGSearchFilter getPerPath] atomically:YES];
}

+(XGSearchFilter *)getPerFilter
{
    NSData *data =[NSData dataWithContentsOfFile:[self getPerPath]];
    XGSearchFilter *filter =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return filter;
}



-(XGHotelSearch *)hotelSearch
{
    if (_hotelSearch ==nil) {
        _hotelSearch =[[XGHotelSearch alloc] init];
    }
    return _hotelSearch;
}
//将返回的数据转化为请求后台数据串
-(void)setHotelSearchFilterForSelf
{
    if (self.cityName==nil) {
        self.cityName =XGSearchCityName;
    }
    [self.hotelSearch clearBuildData];
    HotelKeywordType searchType =[self.searchType intValue];
    if (searchType==HotelKeywordTypeBusiness||searchType==HotelKeywordTypeDistrict){
        [self.hotelSearch setAreaName:self.cityArea];
    }
    else if(searchType==HotelKeywordTypeNormal){
        [self.hotelSearch setHotelName:self.cityArea];
    }
    else{
        [self.hotelSearch setCurrentPos:5000 Longitude:[self.longtitude doubleValue] Latitude:[self.lattitude doubleValue]];
    }

    [self.hotelSearch setDisplayText:self.cityArea];
    [self.hotelSearch setCheckDataForNSDate:self.cinDate checkoutdate:self.coutDate];
    [self.hotelSearch setMinPrice:self.minPrice MaxPrice:self.maxPrice];
    //写死,第一期只是支持北京
    //[self.hotelSearch setCityName: @"北京"];
    [self.hotelSearch setCityName: self.cityName];
    
    BOOL islogin=[[AccountManager instanse]isLogin];
    
    NSString *phoneNo;
    phoneNo = [[AccountManager instanse]phoneNo];
    if (islogin&&STRINGHASVALUE(phoneNo)) {  //登陆
        [self.hotelSearch setPhoneNumber:phoneNo];
    }
    
    // 增加7天可选性 不加下面一行
    [self.hotelSearch setXGMutipleFilter:@"52"];  // 对应开关110100
    [self.hotelSearch setFacilitiesFilter: self.FacilitiesFilter.length>0? self.FacilitiesFilter:nil];
    //[self.hotelSearch setXGMutipleFilter:@"1460"];  // 对应开关10110110100 ？？很奇怪，为什么获取不到呢？
}

//by lc  清理酒店搜索条件
-(void)clearSearChCondition{
    self.cityArea =nil;
    self.longtitude =nil;
    self.lattitude =nil;
    self.searchType =nil;
}


-(BOOL)hadEqualAndNoTimeOut:(XGSearchFilter *)filter
{
    if (![self.cinDate isEqualToDate:filter.cinDate]||![self.coutDate isEqualToDate:filter.coutDate]||![self.cityArea isEqualToString:filter.cityArea]||![self.maxPrice isEqualToString:filter.maxPrice]||![self.minPrice isEqualToString:filter.minPrice]||[self.longtitude doubleValue]!=[filter.longtitude doubleValue]||[self.lattitude doubleValue] != [filter.lattitude doubleValue]||[self.searchType intValue] !=[filter.searchType intValue]||![self.FacilitiesFilter isEqualToString:filter.FacilitiesFilter]) {
        return NO;
    }
    else if ([self getDifferent]>60*5) {
        return NO;
    }
    return YES;
    
}
@end
