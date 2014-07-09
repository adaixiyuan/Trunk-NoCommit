//
//  FStatusDetailInfos.m
//  ElongClient
//
//  Created by bruce on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FStatusDetailInfos.h"

@implementation FStatusDetailInfos

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
    
    // 出发地经纬度
    _startPlaceCoordinates = [dictionaryResultJson safeObjectForKey:@"startPlaceCoordinates"];
    
    // 目的地经纬度
     _endPlaceCoordinates = [dictionaryResultJson safeObjectForKey:@"endPlaceCoordinates"];
    
    // 已飞行时间（分钟）
    _elapsedTime = [dictionaryResultJson safeObjectForKey:@"elapsedTime"];
    
    // 剩余飞行时间（分钟）
    _remainTime = [dictionaryResultJson safeObjectForKey:@"remainingTime"];
    
    // 已飞行时间百分比
    _elapsedTimePercent = [dictionaryResultJson safeObjectForKey:@"elapsedTimePercent"];
    
    // 起飞延误时间
    _flightDeptimeDelay = [dictionaryResultJson safeObjectForKey:@"flightDeptimeDelay"];
    
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    encodeObject(encoder, _flightDate, Object);
	encodeObject(encoder, _flightCompany, Object);
	encodeObject(encoder, _flightNo, Object);
    encodeObject(encoder, _flightDepcode, Object);
    encodeObject(encoder, _flightArrcode, Object);
    encodeObject(encoder, _flightDep, Object);
    encodeObject(encoder, _flightArr, Object);
    encodeObject(encoder, _flightDepAirport, Object);
    encodeObject(encoder, _flightArrAirport, Object);
    encodeObject(encoder, _flightDeptimePlan, Object);
    encodeObject(encoder, _flightArrtimePlan, Object);
    encodeObject(encoder, _flightDeptime, Object);
    encodeObject(encoder, _flightArrtime, Object);
    encodeObject(encoder, _flightState, Object);
    encodeObject(encoder, _flightStateCode, Object);
    encodeObject(encoder, _flightTerminal, Object);
    encodeObject(encoder, _flightHTerminal, Object);
    encodeObject(encoder, _startPlaceCoordinates, Object);
    encodeObject(encoder, _endPlaceCoordinates, Object);
    encodeObject(encoder, _elapsedTime, Object);
    encodeObject(encoder, _remainTime, Object);
    encodeObject(encoder, _elapsedTimePercent, Object);
    encodeObject(encoder, _flightDeptimeDelay, Object);
}

- (id)initWithCoder:(NSCoder *)decoder
{
    decodeObject(decoder, _flightDate, Object);
	decodeObject(decoder, _flightCompany, Object);
	decodeObject(decoder, _flightNo, Object);
    decodeObject(decoder, _flightDepcode, Object);
    decodeObject(decoder, _flightArrcode, Object);
    decodeObject(decoder, _flightDep, Object);
    decodeObject(decoder, _flightArr, Object);
    decodeObject(decoder, _flightDepAirport, Object);
    decodeObject(decoder, _flightArrAirport, Object);
    decodeObject(decoder, _flightDeptimePlan, Object);
    decodeObject(decoder, _flightArrtimePlan, Object);
    decodeObject(decoder, _flightDeptime, Object);
    decodeObject(decoder, _flightArrtime, Object);
    decodeObject(decoder, _flightState, Object);
    decodeObject(decoder, _flightStateCode, Object);
    decodeObject(decoder, _flightTerminal, Object);
    decodeObject(decoder, _flightHTerminal, Object);
    decodeObject(decoder, _startPlaceCoordinates, Object);
    decodeObject(decoder, _endPlaceCoordinates, Object);
    decodeObject(decoder, _elapsedTime, Object);
    decodeObject(decoder, _remainTime, Object);
    decodeObject(decoder, _elapsedTimePercent, Object);
    decodeObject(decoder, _flightDeptimeDelay, Object);
    
	return self;
}

@end
