//
//  TrainCity.m
//  ElongClient
//
//  Created by bruce on 13-11-6.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainCity.h"

@implementation TrainCity

// 解析酒店搜索详情房间数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 车站代码
    _stationCode = [dictionaryResultJson safeObjectForKey:@"stationCode"];
    
    // 车站名称
    _stationName = [dictionaryResultJson safeObjectForKey:@"stationName"];
    
    // 车站名称的拼音
    _stationPY = [dictionaryResultJson safeObjectForKey:@"stationPY"];
    
    // 车站名称拼音的首字母缩写
    _stationPYS = [dictionaryResultJson safeObjectForKey:@"stationPYS"];
}

@end
