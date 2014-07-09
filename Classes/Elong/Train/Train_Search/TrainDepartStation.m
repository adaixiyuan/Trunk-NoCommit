//
//  TrainDepartStation.m
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainDepartStation.h"

@implementation TrainDepartStation


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否始发站
    _isFirst = [dictionaryResultJson safeObjectForKey:@"first"];
    
    // 出发车站名称
    _name = [dictionaryResultJson safeObjectForKey:@"name"];
    
    // 列车从出发站出发的时间(发车时间) 格式hh:mm
    _time = [dictionaryResultJson safeObjectForKey:@"time"];
}


@end
