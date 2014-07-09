//
//  JFlightRestriction.m
//  ElongClient
//
//  Created by dengfang on 11-2-17.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "JFlightRestriction.h"
#import "JFlightSearch.h"
#import "Utils.h"
#import "FlightDataDefine.h"
#import "FlightPostManager.h"
#import "DefineCommon.h"
#import "PostHeader.h"


@implementation JFlightRestriction
//action=GetRestriction&compress=false&req={
//	"Header":{"ChannelId":"1234","DeviceId":"4321","AuthCode":null,"ClientType":1},
//	"IssueCityName":"北京",
//	"IssueDate":"\/Date(1298908800000)\/",
//	"AirCorpCode":"MU",
//	"DepartDate":"\/Date(1298995200000)\/",
//	"PromotionId":0,
//	"ClassTag":""}

- (void)buildPostData:(BOOL)clearFlightRestriction {
	if (clearFlightRestriction) {
		[mDictionary safeSetObject:[PostHeader header] forKey:Resq_Header];
		[mDictionary safeSetObject:@"" forKey:KEY_DEPART_CITY];
		[mDictionary safeSetObject:@"" forKey:KEY_ARRIVE_CITY];
		[mDictionary safeSetObject:@"" forKey:KEY_DEPART_DATE];
		[mDictionary safeSetObject:@"" forKey:@"DepartTimeSpan"];
		[mDictionary safeSetObject:@"" forKey:@"FlightNumber"];
		[mDictionary safeSetObject:@"" forKey:KEY_CLASS_TYPE];
		[mDictionary safeSetObject:[NSNumber numberWithBool:YES] forKey:@"IsSearchShopping"];
        [mDictionary safeSetObject:[NSNumber numberWithBool:YES] forKey:@"IsSearchSellout"];
		//[mDictionary safeSetObject:@"" forKey:KEY_ISSUE_CITY_NAME];
//		[mDictionary safeSetObject:@"" forKey:KEY_ISSUE_DATE];
//		[mDictionary safeSetObject:@"" forKey:KEY_AIR_CORP_CODE];
//		
//		[mDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_PROMOTION_ID];
//		[mDictionary safeSetObject:@"" forKey:@"ClassLevelCode"];
//		[mDictionary safeSetObject:@"" forKey:KEY_CLASS_TAG];
	}
}

- (id)init {
    self = [super init];
    if (self) {
		mDictionary = [[NSMutableDictionary alloc] init];
		[self buildPostData:YES];
	}
	return self;
}


- (void)setReturnFlightNumber:(NSArray *)numbers {
	[self buildPostData:YES];
	//设置回程航班号
	JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
	[mDictionary safeSetObject:[jFlightSearch getDepartCityName] forKey:@"DepartCityName"];
	[mDictionary safeSetObject:[jFlightSearch getArrivalCityName] forKey:@"ArrivalCityName"];
	[mDictionary safeSetObject:[jFlightSearch getDepartDate] forKey:KEY_DEPART_DATE];
	[mDictionary safeSetObject:[jFlightSearch getClassType] forKey:@"ClassType"];
	[mDictionary safeSetObject:NUMBER(0) forKey:@"DepartTimeSpan"];
	[mDictionary safeSetObject:numbers forKey:@"FlightNumber"];
}


- (void)setDepartCity:(NSString *)departCity {
	[mDictionary safeSetObject:departCity forKey:@"DepartCityName"];
}


- (void)setArrivalCity:(NSString *)arrivalCity {
	[mDictionary safeSetObject:arrivalCity forKey:@"ArrivalCityName"];
}

- (void)setClassType:(NSNumber *)type {
	[mDictionary safeSetObject:type forKey:@"ClassType"];
}

- (void)setDepartFlightNumber:(NSArray *)numbers {
	[self buildPostData:YES];
	//设置去程航班号
	JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
	[mDictionary safeSetObject:[jFlightSearch getDepartCityName] forKey:@"DepartCityName"];
	[mDictionary safeSetObject:[jFlightSearch getArrivalCityName] forKey:@"ArrivalCityName"];
	[mDictionary safeSetObject:[jFlightSearch getDepartDate] forKey:KEY_DEPART_DATE];
	[mDictionary safeSetObject:[jFlightSearch getClassType] forKey:@"ClassType"];
	[mDictionary safeSetObject:NUMBER(0) forKey:@"DepartTimeSpan"];
	[mDictionary safeSetObject:numbers forKey:@"FlightNumber"];
	
//	[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_GO_TRIP] forKey:KEY_CURRENT_FLIGHT_TYPE];
//	[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:m_iType] forKey:KEY_SELECT_FLIGHT_TYPE];
//	[[FlightData getFDictionary] safeSetObject:begincity forKey:KEY_DEPART_CITY];
//	[[FlightData getFDictionary] safeSetObject:endcity forKey:KEY_ARRIVE_CITY];
//	[[FlightData getFDictionary] safeSetObject:departDateLabel.text forKey:KEY_DEPART_DATE];
//	[[FlightData getFDictionary] safeSetObject:(m_iType == DEFINE_SINGLE_TRIP ? @"0" : returnDateLabel.text) forKey:KEY_RETURN_DATE];
//	[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:m_iClassType] forKey:KEY_SELECT_CLASS_TYPE];	
}

- (id)getObject:(NSString *)key {
	return [mDictionary safeObjectForKey:key];
}

- (void)setIssueCityName:(NSString *)str isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[mDictionary safeSetObject:str forKey:KEY_ISSUE_CITY_NAME];
}

- (void)setIssueDate:(NSString *)str isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	//NSString *datestring = [NSString stringWithFormat:@"/Date(%.f000)/",[[Utils NSStringDateToNSDate:str] timeIntervalSince1970]];
	NSString *datestring = [TimeUtils makeJsonDateWithDisplayNSStringFormatter:str formatter:@"yyyy-MM-dd"];
	
	[mDictionary safeSetObject:datestring forKey:KEY_ISSUE_DATE];
}

- (void)setAirCorpCode:(NSString *)str isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[mDictionary safeSetObject:str forKey:KEY_AIR_CORP_CODE];
}

- (void)setDepartDate:(NSString *)str isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	//NSString *datestring = [NSString stringWithFormat:@"/Date(%.f000)/",[[Utils NSStringDateToNSDate:str] timeIntervalSince1970]];
	NSString *datestring=[TimeUtils makeJsonDateWithDisplayNSStringFormatter:str formatter:@"yyyy-MM-dd"];
	[mDictionary safeSetObject:datestring forKey:KEY_DEPART_DATE];
}


- (void)setDepartDate:(NSString *)str {
	[mDictionary safeSetObject:str forKey:KEY_DEPART_DATE];
}

// 是否搜索51
- (void)setIsSearch51Book:(NSNumber *)isSearch51
{
	[mDictionary safeSetObject:isSearch51 forKey:@"IsSearch51Book"];
}

// 是否搜索1小时飞人
- (void)setIsSearchOneHour:(NSNumber *)isSearchOneHour
{
    [mDictionary safeSetObject:isSearchOneHour forKey:@"IsSearchOneHour"];
}

// 产品类型
- (void)setProductType:(NSNumber *)productType isClearData:(BOOL)isClearData
{
    [self buildPostData:isClearData];
	[mDictionary safeSetObject:productType forKey:@"TicketChannel"];
}
- (NSNumber *)getProduceType
{
    return [mDictionary safeObjectForKey:@"TicketChannel"];
}


- (void)setClassTag:(NSString *)str isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[mDictionary safeSetObject:str forKey:KEY_CLASS_TAG];
}

- (void)setPromotionId:(NSNumber *)pid isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[mDictionary safeSetObject:pid forKey:KEY_PROMOTION_ID];
}

- (void)setIsPromotion:(NSNumber *)isPro {
	[self buildPostData:NO];
	[mDictionary safeSetObject:isPro forKey:KEY_IS_PROMOTION];
}

- (NSString *)requesString:(BOOL)iscompress {
	NSLog(@"%@", mDictionary);
	
	return [NSString stringWithFormat:@"action=GetFlightDetailV2&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[mDictionary JSONRepresentationWithURLEncoding]];
}

@end
