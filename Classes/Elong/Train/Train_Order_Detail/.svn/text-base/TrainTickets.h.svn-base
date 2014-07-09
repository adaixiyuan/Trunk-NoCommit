//
//  TrainTickets.h
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrainDepartStation.h"
#import "TrainArriveStation.h"

@interface TrainTickets : NSObject


@property (nonatomic, strong) NSString *number;                     // 车次，如G101, K123等
@property (nonatomic, strong) NSNumber *duration;                   // 车程（从出发站点到到达站点的时间）
@property (nonatomic, strong) NSString *mileage;                    // 里程
@property (nonatomic, strong) TrainDepartStation *departInfo;       // 出发站信息
@property (nonatomic, strong) TrainArriveStation *arriveInfo;       // 到达站信息
@property (nonatomic, strong) NSNumber *ticketStatus;               // 0:符合预订、1：不可预订
@property (nonatomic, strong) NSString *ticketMsg;                  // 不可预订原因
@property (nonatomic, strong) NSArray *arraySeats;                  // Seat集合
@property (nonatomic, strong) NSString *lowPrice;                   // 最低价
@property (nonatomic, strong) NSNumber *ypCode;                     // 余票状态
@property (nonatomic, strong) NSString *ypMessage;                  // 余票信息
//
@property (nonatomic, strong) NSString *departDate;                 // 出发日期
@property (nonatomic, strong) NSString *departShowDate;             // 出发显示日期
@property (nonatomic, strong) NSString *arriveShowDate;             // 到达显示日期
@property (nonatomic, strong) NSString *durationShow;               // 历程显示

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
