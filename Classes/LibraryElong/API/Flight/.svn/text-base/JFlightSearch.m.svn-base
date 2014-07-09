//
//  JFlightSearch.m
//  ElongClient
//
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "JFlightSearch.h"
#import "Utils.h"
#import "PostHeader.h"
#import "DefineCommon.h"

@implementation JFlightSearch

- (void)buildPostData:(BOOL)clearFlightsearch {
	if (clearFlightsearch) {
		[searchDictionary safeSetObject:[PostHeader header] forKey:Resq_Header];
		[searchDictionary safeSetObject:@"" forKey:@"DepartCityName"];
		[searchDictionary safeSetObject:@"" forKey:@"ArrivalCityName"];
		[searchDictionary safeSetObject:@"" forKey:@"AirCorpCode"];
		[searchDictionary safeSetObject:@"1" forKey:@"ClassType"];
		[searchDictionary safeSetObject:[NSNull null] forKey:@"DepartDate"];
		[searchDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:@"DepartTimeSpan"];
		[searchDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:@"OrderBy"];
        [searchDictionary safeSetObject:[NSNumber numberWithBool:YES] forKey:@"IsSearchShopping"];
        [searchDictionary safeSetObject:[NSNumber numberWithBool:YES] forKey:@"IsSearchSellout"];
	}
}

- (id)init {
    self = [super init];
    if (self) {
		searchDictionary = [[NSMutableDictionary alloc] init];
		[self buildPostData:YES];
	}
	return self;
}

- (id)getObject:(NSString *)key {
	return [searchDictionary safeObjectForKey:key];
}

- (void)setDepartCityName:(NSString *)cityName isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[searchDictionary safeSetObject:cityName forKey:@"DepartCityName"];
}


- (NSString *)getDepartCityName {
	return [searchDictionary safeObjectForKey:@"DepartCityName"];
}

- (void)setArrivalCityName:(NSString *)cityName isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[searchDictionary safeSetObject:cityName forKey:@"ArrivalCityName"];
}

- (NSString *)getArrivalCityName {
	return [searchDictionary safeObjectForKey:@"ArrivalCityName"];
}

- (void)setAirCorpCode:(NSString *)airCorpCode isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[searchDictionary safeSetObject:airCorpCode forKey:@"AirCorpCode"];
}


- (void)setClassType:(NSString *)classType isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[searchDictionary safeSetObject:classType forKey:@"ClassType"];
}

- ( NSString *)getClassType {
	return [searchDictionary safeObjectForKey:@"ClassType"];
}

- (void)setOrderBy:(int)orderBy isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[searchDictionary safeSetObject:[NSNumber numberWithInt:orderBy] forKey:@"OrderBy"];
}

- (void)setDepartDate:(NSString *)date isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];

	NSString *datestring=[TimeUtils makeJsonDateWithDisplayNSStringFormatter:date formatter:@"yyyy-MM-dd"];
	[searchDictionary safeSetObject:datestring forKey:@"DepartDate"];
}

- (NSString *)getDepartDate {
	return [searchDictionary safeObjectForKey:@"DepartDate"];
}

// 是否搜索51
- (void)setIsSearch51Book:(NSNumber *)isSearch51 isClearData:(BOOL)isClearData
{
    [self buildPostData:isClearData];
	[searchDictionary safeSetObject:isSearch51 forKey:@"IsSearch51Book"];
}
- (NSNumber *)getIsSearch51Book
{
    return [searchDictionary safeObjectForKey:@"IsSearch51Book"];
}


// 产品类型
- (void)setProductType:(NSNumber *)productType isClearData:(BOOL)isClearData
{
    [self buildPostData:isClearData];
	[searchDictionary safeSetObject:productType forKey:@"TicketChannel"];
}
- (NSNumber *)getProduceType
{
    return [searchDictionary safeObjectForKey:@"TicketChannel"];
}

// 是否搜索1小时飞人
- (void)setIsSearchOneHour:(NSNumber *)isSearchOneHour isClearData:(BOOL)isClearData
{
    [self buildPostData:isClearData];
	[searchDictionary safeSetObject:isSearchOneHour forKey:@"IsSearchOneHour"];
}
- (NSNumber *)getIsSearchOneHour
{
    return [searchDictionary safeObjectForKey:@"IsSearchOneHour"];
}

- (void)preDate:(NSString *)preDateString {

	
	NSString *datestring=[TimeUtils makeJsonDateWithDisplayNSStringFormatter:preDateString formatter:@"yyyy-MM-dd"];
	[searchDictionary safeSetObject:datestring forKey:@"DepartDate"];
}

- (void)nextDate:(NSString *)nextDateString {

	NSString *datestring=[TimeUtils makeJsonDateWithDisplayNSStringFormatter:nextDateString formatter:@"yyyy-MM-dd"];
	[searchDictionary safeSetObject:datestring forKey:@"DepartDate"];
}

- (NSString *)requesString:(BOOL)iscompress {
    NSLog(@"GetFlightListV2=%@", searchDictionary);
	return [NSString stringWithFormat:@"action=GetFlightListV2&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[searchDictionary JSONRepresentationWithURLEncoding]];
}

@end
