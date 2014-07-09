//
//  JFlightSearch.h
//  ElongClient
//
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFlightSearch : NSObject {
	NSMutableDictionary *searchDictionary;
}

- (void)buildPostData:(BOOL)clearFlightsearch;
- (id)getObject:(NSString *)key;
- (void)setDepartCityName:(NSString *)cityName isClearData:(BOOL)isClearData;
- (NSString *)getDepartCityName;
- (void)setArrivalCityName:(NSString *)cityName isClearData:(BOOL)isClearData;
- (NSString *)getArrivalCityName;
- (void)setAirCorpCode:(NSString *)airCorpCode isClearData:(BOOL)isClearData;
- (void)setClassType:(NSString *)classType isClearData:(BOOL)isClearData;
- (NSNumber *)getClassType;
- (void)setOrderBy:(int)orderBy isClearData:(BOOL)isClearData;
- (void)setDepartDate:(NSString *)date isClearData:(BOOL)isClearData;
- (NSString *)getDepartDate;
- (void)preDate:(NSString *)preDateString;
- (void)nextDate:(NSString *)nextDateString;

// 是否搜索51
- (void)setIsSearch51Book:(NSNumber *)isSearch51 isClearData:(BOOL)isClearData;
- (NSNumber *)getIsSearch51Book;

// 产品类型
- (void)setProductType:(NSNumber *)productType isClearData:(BOOL)isClearData;
- (NSNumber *)getProduceType;

// 是否搜索1小时飞人
- (void)setIsSearchOneHour:(NSNumber *)isSearchOneHour isClearData:(BOOL)isClearData;
- (NSNumber *)getIsSearchOneHour;


- (NSString *)requesString:(BOOL)iscompress;
@end
