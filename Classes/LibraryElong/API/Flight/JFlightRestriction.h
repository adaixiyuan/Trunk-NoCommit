//
//  JFlightRestriction.h
//  ElongClient
//
//  Created by dengfang on 11-2-17.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <Foundation/Foundation.h>

//action=GetRestriction&compress=false&req={
//	"Header":{"ChannelId":"1234","DeviceId":"4321","AuthCode":null,"ClientType":1},
//	"IssueCityName":"北京",
//	"IssueDate":"\/Date(1298908800000)\/",
//	"AirCorpCode":"MU",
//	"DepartDate":"\/Date(1298995200000)\/",
//	"PromotionId":0,
//	"ClassTag":""}

@interface JFlightRestriction : NSObject {
	NSMutableDictionary *mDictionary;
}

- (void)buildPostData:(BOOL)clearFlightRestriction;
- (id)getObject:(NSString *)key;
- (void)setIssueCityName:(NSString *)str isClearData:(BOOL)isClearData;
- (void)setIssueDate:(NSString *)str isClearData:(BOOL)isClearData;
- (void)setAirCorpCode:(NSString *)str isClearData:(BOOL)isClearData;
- (void)setDepartDate:(NSString *)str isClearData:(BOOL)isClearData;
- (void)setClassTag:(NSString *)str isClearData:(BOOL)isClearData;
- (void)setPromotionId:(NSNumber *)pid isClearData:(BOOL)isClearData;
- (void)setIsSearch51Book:(NSNumber *)isSearch51;
// 是否搜索1小时飞人
- (void)setIsSearchOneHour:(NSNumber *)isSearchOneHour;
- (void)setIsPromotion:(NSNumber *)isPro;
- (void)setDepartFlightNumber:(NSArray *)numbers;
- (void)setDepartCity:(NSString *)departCity;
- (void)setArrivalCity:(NSString *)arrivalCity;
- (void)setClassType:(NSNumber *)type;
- (void)setDepartDate:(NSString *)str;
- (NSString *)requesString:(BOOL)iscompress;

- (void)setReturnFlightNumber:(NSArray *)numbers;
// 产品类型
- (void)setProductType:(NSNumber *)productType isClearData:(BOOL)isClearData;
- (NSNumber *)getProduceType;

@end