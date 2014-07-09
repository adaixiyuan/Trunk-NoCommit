//
//  TaxiUtils.h
//  ElongClient
//  租车业务工具类
//  Created by Jian.Zhao on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RentCity.h"
#import "RentFlight.h"

typedef enum {
    RentHistory_Flight = 0,
    RentHistory_Airport,
}RentHistory_type;

typedef enum {
    Inner_Flight = 10,//国内航班号
    International_Flight,//国际航班号
    Error_Flight//航班号格式错误
}FlightType;

#define TIME_FORMATTER_Flight @"yyyy-MM-dd"
#define TIME_FORMATTER_Airport @"yyyy-MM-dd HH:mm"
#define TIME_FORMATTER_WITH_SS @"yyyy-MM-dd HH:mm:ss"

@interface TaxiUtils : NSObject

//给定一个类似 22:00 的时间格式，超过返回第二天日期，若不超过则显示当天
+(NSString *)checkDateOffTheGievnDateString:(NSString *)string;

//返回一个当前时间加小时数，并以分钟数取整
+(NSString *)getDateOfHours:(int)hours MinsByTen:(BOOL)accturate;

//返回一个未来多少天的数组，含有月日 周 的信息
+(NSArray *)getDateArraysFromNowWithDays:(int)days;

//租车业务中 API返回的数据结构修改（机场列表）
+(NSMutableArray *)getTheCustomAirPortOrTerminalsByGivenArrays:(NSArray *)array;

//租车业务，判定是否支持此项业务，若支持返回城市ID 若不支持返回nil
+(NSString *)getTheServiceStatusByGivenCity:(NSString *)city andSources:(NSArray *)array;

//接送机业务中，用户选择的时间需要在当前时间往后推移2小时以后
+(BOOL)checkTheTimeIsAvailable:(NSString *)dateString;

//获取租车业务中 获取用户的历史记录(航班、机场)
+(NSMutableArray *)getRentCarHistoryWithGivenType:(RentHistory_type)type;

//租车业务中，保存历史记录
+(void)saveTheHistoryData:(NSMutableArray *)array Type:(RentHistory_type )type;

//转化成带有秒的时间字符串
+(NSString *)addsecsStringByGivenTimeString:(NSString *)time;

/*
 *返回默认机场
 *规则：定位当前城市，若有机场，返回第一个（API）若无，默认返回北京的T1机场
 */
+(CustomAirportTerminal *)getTheDefaultAirportByLocationCity:(NSString *)cityName andSource:(NSArray *)source;//不适用缓存
+(CustomAirportTerminal *)getTheDefaultAirportByLocationCity:(NSString *)cityName andCustomAirports:(NSArray *)source;//缓存

//返回是否跨城市用车
+(BOOL)checkIsSameCity:(NSString *)city_a another:(NSString *)city_b;

//根据查询到的航班返回接机时间，中间需要判断航班是否跨天
+(BOOL)getFlightTimeFromGivenFlight:(RentFlight *)flight;

//根据机场三字码返回机场名字（航班查询页面使用，API返回的机场有可能没有机场名字，只有三字码）
+(CustomAirportTerminal *)getTheAirportTerminalFromGivenPortCode:(NSString *)code;

//判别输入的航班号
+(FlightType)getTheFlightTypeByGivenString:(NSString *)string;
//证件转换
+(NSInteger) convertCertificate:(int ) type;

//租车 支付订单 表头信息封装
+(NSArray *)getOrderRentInfoHeaderShowSuccess:(BOOL)yes;
@end
