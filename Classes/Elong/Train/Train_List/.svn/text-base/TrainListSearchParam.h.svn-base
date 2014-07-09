//
//  TrainListSearchParam.h
//  ElongClient
//
//  Created by bruce on 13-11-11.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainListSearchParam : NSObject

@property (nonatomic, strong, getter = startStation, setter = setStartStation:) NSString *startStation; // 出发车站
@property (nonatomic, strong, getter = endStation, setter = setEndStation:) NSString *endStation;       // 到达车站
@property (nonatomic, strong, getter = startDate, setter = setStartDate:) NSString *startDate;          // 出发日期
@property (nonatomic, strong, getter = trainType, setter = setTrainType:) NSString *trainType;          // 列车类型
@property (nonatomic, strong, getter = wrapperId, setter = setWrapperId:) NSString *wrapperId;          // OTA厂商
@property (nonatomic, strong, getter = hasYp, setter = setHasYp:) NSNumber *hasYp;                      // 是否查询有票

// 序列化参数数据
- (void)serialSearchParam:(NSMutableDictionary *)jsonDictionary;

@end
