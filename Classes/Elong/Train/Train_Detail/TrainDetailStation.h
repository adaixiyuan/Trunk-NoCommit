//
//  TrainDetailStation.h
//  ElongClient
//
//  Created by bruce on 13-11-13.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainDetailStation : NSObject

@property (nonatomic, strong) NSString *stationName;                    // 车站名称
@property (nonatomic, strong) NSString *arrivalTime;                    // 进站时间（始发站无该信息）
@property (nonatomic, strong) NSString *departTime;                     // 出站时间（终点站无该信息）
@property (nonatomic, strong) NSString *mileage;                        // 里程
@property (nonatomic, strong) NSString *stayTime;                       // 停留时间

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
