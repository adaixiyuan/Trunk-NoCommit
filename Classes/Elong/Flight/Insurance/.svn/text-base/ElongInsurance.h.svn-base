//
//  ElongInsurance.h
//  ElongClient
//
//  Created by chenggong on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ElongInsurance : NSObject

+ (ElongInsurance *)shareInstance;

- (void)getInsuranceData;
- (NSString *)getProductID;
- (NSString *)getProductName;
- (NSString *)getSalePrice;
- (NSString *)getBasePrice;
- (NSString *)getTimeLimit;
- (NSString *)getInsuranceLimit;
- (NSString *)getInsuranceAmount;
- (NSString *)getInsuranceCount;
- (void)setInsuranceCount:(NSString *)count;
- (float) getInsuranceTotalPrice;
- (NSString *)generateAgeWithYear:(NSString *)intYear andBirthDay:(NSString *)intBirthday;
- (BOOL)insuranceCanBuy:(NSString *)age;

@end
