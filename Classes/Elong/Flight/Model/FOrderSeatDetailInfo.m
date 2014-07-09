//
//  FOrderSeatDetailInfo.m
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FOrderSeatDetailInfo.h"
#import "FOrderSeatPassengerPNR.h"

@implementation FOrderSeatDetailInfo

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 航线
    FOrderSeatAirLineInfo *fOrderSeatAirLineInfo = [[FOrderSeatAirLineInfo alloc] init];
	NSDictionary *dictionaryAirlineJson = [dictionaryResultJson safeObjectForKey:@"AirLine"];
	if(dictionaryAirlineJson == nil)
	{
        dictionaryAirlineJson = [[NSDictionary alloc] init];
		
	}
	[fOrderSeatAirLineInfo parseSearchResult:dictionaryAirlineJson];
    
    _airlineInfo = fOrderSeatAirLineInfo;
    
    // 乘客信息
    NSMutableArray *arrayPassengerPnrTmp = [[NSMutableArray alloc] init];
	NSArray *arrayPassengerPnrJson = [dictionaryResultJson safeObjectForKey:@"PassengerPNR_Seats"];
    
    if(arrayPassengerPnrJson != nil)
	{
		// 结果数目
		NSUInteger passengerPnrCount = [arrayPassengerPnrJson count];
		
		for(NSUInteger i = 0; i < passengerPnrCount; i++)
		{
			NSDictionary *dictionaryPassengerPnrJson = [arrayPassengerPnrJson safeObjectAtIndex:i];
			if(dictionaryPassengerPnrJson != nil)
			{
				// 解析该对象
				FOrderSeatPassengerPNR *fOrderSeatPassengerPNR = [[FOrderSeatPassengerPNR alloc] init];
				[fOrderSeatPassengerPNR parseSearchResult:dictionaryPassengerPnrJson];
				[arrayPassengerPnrTmp addObject:fOrderSeatPassengerPNR];
			}
		}
	}
	_arrayPassengerPNR = arrayPassengerPnrTmp;
    
    // 是否可选座
    _isCanSelect = [dictionaryResultJson safeObjectForKey:@"IsCanSelect"];
    
    // 是否包含非成人
    _isContainNoAdult = [dictionaryResultJson safeObjectForKey:@"IsContainNoAdult"];
}

@end
