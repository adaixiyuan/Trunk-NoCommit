//
//  TrainArriveStation.h
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainArriveStation : NSObject

@property (nonatomic, strong) NSString *isLast;             // 是否终点站
@property (nonatomic, strong) NSString *name;               // 到达车站名称
@property (nonatomic, strong) NSString *time;               // 列车到达车站的时间(到站时间) 格式hh:mm

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
