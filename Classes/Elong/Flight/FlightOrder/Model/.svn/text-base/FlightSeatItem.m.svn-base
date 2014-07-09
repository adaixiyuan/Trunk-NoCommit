//
//  FlightSeatItem.m
//  ElongClient
//
//  Created by bruce on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightSeatItem.h"

@implementation FlightSeatItem

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    //
    _seatIndex = [dictionaryResultJson safeObjectForKey:@"Index"];
    
    //
    _seatID = [dictionaryResultJson safeObjectForKey:@"Id"];
    
    _seatLocal = [dictionaryResultJson safeObjectForKey:@"Local"];
    
    _seatSiteCode = [dictionaryResultJson safeObjectForKey:@"SiteCode"];
    _seatDesc = [dictionaryResultJson safeObjectForKey:@"Desc"];
    
    _seatStatus = [dictionaryResultJson safeObjectForKey:@"Status"];
    
    // 座位号
    _seatNumber = [dictionaryResultJson safeObjectForKey:@"SeatId"];
}

@end
