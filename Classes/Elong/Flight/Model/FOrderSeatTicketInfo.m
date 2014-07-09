//
//  FOrderSeatTicketInfo.m
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FOrderSeatTicketInfo.h"

@implementation FOrderSeatTicketInfo

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    //
    _pnrNo = [dictionaryResultJson safeObjectForKey:@"PnrNo"];
    
    //
    _ticketStatus = [dictionaryResultJson safeObjectForKey:@"TicketStatus"];
    
    _ticketChannel = [dictionaryResultJson safeObjectForKey:@"TicketChannel"];
    
}

@end
