//
//  FStatusListInfos.m
//  ElongClient
//
//  Created by bruce on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FStatusListInfos.h"

@implementation FStatusListInfos


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 起飞日期
    _flightDate = [dictionaryResultJson safeObjectForKey:@"flightDate"];
    
    // 航空公司
    _flightCompany = [dictionaryResultJson safeObjectForKey:@"flightCompany"];
    
    // 航班号
    _flightNo = [dictionaryResultJson safeObjectForKey:@"flightNo"];
    
    // 出发地三字码
    _flightDepcode = [dictionaryResultJson safeObjectForKey:@"flightDepcode"];
    
    // 目的地三字码
    _flightArrcode = [dictionaryResultJson safeObjectForKey:@"flightArrcode"];
    
    // 出发地城市名（汉字）
    _flightDep = [dictionaryResultJson safeObjectForKey:@"flightDep"];
    
    // 目的地城市名（汉字）
    _flightArr = [dictionaryResultJson safeObjectForKey:@"flightArr"];
    
    // 出发机场
    _flightDepAirport = [dictionaryResultJson safeObjectForKey:@"flightDepAirport"];
    
    // 目的机场
    _flightArrAirport = [dictionaryResultJson safeObjectForKey:@"flightArrAirport"];
    
    // 航班实际起飞时间，值为false代表空值
    _flightDeptimePlan = [dictionaryResultJson safeObjectForKey:@"flightDeptimePlan"];
    
    // 航班实际到达时间，值为false代表空值
    _flightArrtimePlan = [dictionaryResultJson safeObjectForKey:@"flightArrtimePlan"];
    
    // 航班实际起飞时间，值为false代表空值
    _flightDeptime = [dictionaryResultJson safeObjectForKey:@"flightDeptime"];
    
    // 航班实际到达时间，值为false代表空值
    _flightArrtime = [dictionaryResultJson safeObjectForKey:@"flightArrtime"];
    
    // 航班当前状态 起飞，计划，到达，延误，取消，备降
    _flightState = [dictionaryResultJson safeObjectForKey:@"flightState"];
    
    // 航班当前状态码1 起飞，2 计划，3 到达，4 延误，5 取消，6 备降
    _flightStateCode = [dictionaryResultJson safeObjectForKey:@"flightStateCode"];
    
    // 接机楼，值为false代表空值
    _flightTerminal = [dictionaryResultJson safeObjectForKey:@"flightTerminal"];
    
    // 登机楼，值为false代表空值
    _flightHTerminal = [dictionaryResultJson safeObjectForKey:@"flightHTerminal"];
}



@end
