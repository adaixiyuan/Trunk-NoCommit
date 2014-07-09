//
//  TrainDetailStation.m
//  ElongClient
//
//  Created by bruce on 13-11-13.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainDetailStation.h"

@implementation TrainDetailStation

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 车站名称
    _stationName = [dictionaryResultJson safeObjectForKey:@"stationName"];
    
    // 进站时间（始发站无该信息）
    _arrivalTime = [dictionaryResultJson safeObjectForKey:@"arrivalTime"];
    
    // 出站时间（终点站无该信息）
    _departTime = [dictionaryResultJson safeObjectForKey:@"departTime"];
    
    // 停留时间
    _stayTime = [dictionaryResultJson safeObjectForKey:@"stopOver"];
    
    // 里程
    _mileage = [dictionaryResultJson safeObjectForKey:@"mileage"];
}

@end
