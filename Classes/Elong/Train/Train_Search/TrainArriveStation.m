//
//  TrainArriveStation.m
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainArriveStation.h"

@implementation TrainArriveStation


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否终点站
    _isLast = [dictionaryResultJson safeObjectForKey:@"last"];
    
    // 到达车站名称
    _name = [dictionaryResultJson safeObjectForKey:@"name"];
    
    // 列车到达车站的时间(到站时间) 格式hh:mm
    _time = [dictionaryResultJson safeObjectForKey:@"time"];
}

@end
