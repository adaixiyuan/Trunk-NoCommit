//
//  ForecastInformation.h
//  ElongClient
//
//  Created by chenggong on 14-6-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForecastInformation : NSObject

// 3天天气预报信息
@property (nonatomic, copy) NSString *daytimeMP;                // 白天气象现象
@property (nonatomic, copy) NSString *nightMP;                  // 夜晚气象现象
@property (nonatomic, copy) NSString *dayTimeTemperature;       // 白天天气温度(摄氏度)
@property (nonatomic, copy) NSString *nightTemperature;         // 夜晚天气温度(摄氏度)
@property (nonatomic, copy) NSString *dayTimeWD;                // 白天风向
@property (nonatomic, copy) NSString *nightWD;                  // 夜晚风向
@property (nonatomic, copy) NSString *dayTimeWP;                // 白天风力
@property (nonatomic, copy) NSString *nightWP;                  // 夜晚风力
@property (nonatomic, copy) NSString *sunriseSunsetTime;        // 日出日落时间(中间用|分割)

@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSMutableArray *indexes;

// 天气指数(列表)。如果请求日期超过今天，则返回值中无该字段

- (NSString *)getDaytimeMPAtIndex:(NSUInteger)index;
- (NSString *)getNightMPAtIndex:(NSUInteger)index;
- (NSString *)getDayTimeTemperatureAtIndex:(NSUInteger)index;
- (NSString *)getNightTemperatureAtIndex:(NSUInteger)index;
- (NSString *)getDayTimeWDAtIndex:(NSUInteger)index;
- (NSString *)getNightWDAtIndex:(NSUInteger)index;
- (NSString *)getDayTimeWPAtIndex:(NSUInteger)index;
- (NSString *)getNightWPAtIndex:(NSUInteger)index;
- (NSString *)getSunriseSunsetTimeAtIndex:(NSUInteger)index;

- (NSString *)getAdviceFromIndexesAtIndex:(NSUInteger)index;

// 单例
+ (ForecastInformation *)shareInstance;

@end
