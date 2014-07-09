//
//  FOrderSeatPassengerPNR.h
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FOrderSeatPassengerInfo.h"
#import "FOrderSeatTicketInfo.h"
#import "FOrderSeatAirLineInfo.h"

@interface FOrderSeatPassengerPNR : NSObject

@property (nonatomic, strong) FOrderSeatPassengerInfo *passengerInfo;       // 乘客信息
@property (nonatomic, strong) FOrderSeatTicketInfo *ticketInfo;             // 订票信息
@property (nonatomic, strong) NSNumber *isCanSelect;                        // 是否可选
@property (nonatomic, strong) NSString *seat;                               // 座位信息

// 设置每个乘客的航线信息
@property (nonatomic, strong) FOrderSeatAirLineInfo *airlineInfo;


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
