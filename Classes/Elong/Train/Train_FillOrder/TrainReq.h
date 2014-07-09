//
//  TrainReq.h
//  ElongClient
//
//  Created by 赵 海波 on 13-10-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainCommitOrderAppendData.h"

@class TrainTickets, TrainSeats;
@interface TrainReq : NSObject

@property (nonatomic, retain) TrainTickets *currentRoute;       // 当前的火车票行程
@property (nonatomic, retain) TrainSeats *currentSeat;          // 当前的火车票座位
@property (nonatomic, assign) NSInteger currentTicketNum;       // 当前火车票购买数量

+ (id)shared;

- (NSString *)testing;
- (NSString *)testingOrderDetail;

+ (NSString *)submitOrderByPassengers:(NSMutableArray *)passengers mobilePhone:(NSString *)mobile otherData:(TrainCommitOrderAppendData *) otherData;
- (void)test;
- (void)clearData;          // 清空本身所纪录的数据

@end