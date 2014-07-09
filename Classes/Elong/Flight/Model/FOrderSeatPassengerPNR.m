//
//  FOrderSeatPassengerPNR.m
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FOrderSeatPassengerPNR.h"

@implementation FOrderSeatPassengerPNR

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 乘客信息
    FOrderSeatPassengerInfo *fOrderSeatPassengerInfo = [[FOrderSeatPassengerInfo alloc] init];
	NSDictionary *dictionaryPassengerJson = [dictionaryResultJson safeObjectForKey:@"Passenger"];
	if(dictionaryPassengerJson == nil)
	{
        dictionaryPassengerJson = [[NSDictionary alloc] init];
		
	}
	[fOrderSeatPassengerInfo parseSearchResult:dictionaryPassengerJson];
    
    _passengerInfo = fOrderSeatPassengerInfo;
    
    // 订票信息
    FOrderSeatTicketInfo *fOrderSeatTicketInfo = [[FOrderSeatTicketInfo alloc] init];
	NSDictionary *dictionaryTicketInfoJson = [dictionaryResultJson safeObjectForKey:@"Ticket"];
	if(dictionaryTicketInfoJson == nil)
	{
        dictionaryTicketInfoJson = [[NSDictionary alloc] init];
		
	}
	[fOrderSeatTicketInfo parseSearchResult:dictionaryTicketInfoJson];
    
    _ticketInfo = fOrderSeatTicketInfo;
    
    // 是否可选
    _isCanSelect = [dictionaryResultJson safeObjectForKey:@"IsCanSelect"];
    
    // 座位信息
    _seat = [dictionaryResultJson safeObjectForKey:@"Seat"];
}

@end
