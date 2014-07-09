//
//  FlightSeatItem.h
//  ElongClient
//
//  Created by bruce on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightSeatItem : NSObject

@property (nonatomic, strong) NSNumber *seatIndex;
@property (nonatomic, strong) NSNumber *seatID;
@property (nonatomic, strong) NSString *seatLocal;
@property (nonatomic, strong) NSString *seatSiteCode;
@property (nonatomic, strong) NSString *seatDesc;
@property (nonatomic, strong) NSString *seatStatus;
@property (nonatomic, strong) NSString *seatNumber;    // 座位号

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
