//
//  FStatusListInfos.h
//  ElongClient
//
//  Created by bruce on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FStatusListInfos : NSObject

@property (nonatomic, strong) NSString *flightDate;             // 起飞日期
@property (nonatomic, strong) NSString *flightCompany;          // 航空公司
@property (nonatomic, strong) NSString *flightNo;               // 航班号
@property (nonatomic, strong) NSString *flightDepcode;          // 出发地三字码
@property (nonatomic, strong) NSString *flightArrcode;          // 目的地三字码
@property (nonatomic, strong) NSString *flightDep;              // 出发地城市名（汉字）
@property (nonatomic, strong) NSString *flightArr;              // 目的地城市名（汉字）
@property (nonatomic, strong) NSString *flightDepAirport;       // 出发机场
@property (nonatomic, strong) NSString *flightArrAirport;       // 目的机场
@property (nonatomic, strong) NSString *flightDeptimePlan;      // 航班实际起飞时间，值为false代表空值
@property (nonatomic, strong) NSString *flightArrtimePlan;      // 航班实际到达时间，值为false代表空值
@property (nonatomic, strong) NSString *flightDeptime;          // 航班实际起飞时间，值为false代表空值
@property (nonatomic, strong) NSString *flightArrtime;          // 航班实际到达时间，值为false代表空值
@property (nonatomic, strong) NSString *flightState;            // 航班当前状态 起飞，计划，到达，延误，取消，备降
@property (nonatomic, strong) NSNumber *flightStateCode;        // 航班当前状态码1 起飞，2 计划，3 到达，4 延误，5 取消，6 备降
@property (nonatomic, strong) NSString *flightTerminal;         // 接机楼，值为false代表空值
@property (nonatomic, strong) NSString *flightHTerminal;        // 登机楼，值为false代表空值




// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
