//
//  TrainTickets.m
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainTickets.h"
#import "TrainSeats.h"

@implementation TrainTickets


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 车次，如G101, K123等
    _number = [dictionaryResultJson safeObjectForKey:@"number"];
    
    // 车程（从出发站点到到达站点的时间）, 格式hh:mm
    _duration = [dictionaryResultJson safeObjectForKey:@"duration"];
    
    // 里程
    _mileage = [dictionaryResultJson safeObjectForKey:@"mileage"];
    
    // 出发站信息
    TrainDepartStation *departInfoTmp = [[TrainDepartStation alloc] init];
	NSDictionary *dictionaryDepartInfoJson = [dictionaryResultJson safeObjectForKey:@"from"];
	if(dictionaryDepartInfoJson == nil)
	{
        dictionaryDepartInfoJson = [[NSDictionary alloc] init];
		
	}
	[departInfoTmp parseSearchResult:dictionaryDepartInfoJson];

    _departInfo = departInfoTmp;
    
    // 到达站信息
    TrainArriveStation *arriveInfoTmp = [[TrainArriveStation alloc] init];
	NSDictionary *dictionaryArriveInfoJson = [dictionaryResultJson safeObjectForKey:@"to"];
	if(dictionaryArriveInfoJson == nil)
	{
        dictionaryArriveInfoJson = [[NSDictionary alloc] init];
		
	}
	[arriveInfoTmp parseSearchResult:dictionaryArriveInfoJson];
    
    _arriveInfo = arriveInfoTmp;
    
    // 0:符合预订、1：不可预订
    _ticketStatus = [dictionaryResultJson safeObjectForKey:@"ticketBookStatus"];
    
    // 不可预订原因
    _ticketMsg = [dictionaryResultJson safeObjectForKey:@"ticketMsg"];
    
    // Seat集合
    NSMutableArray *arraySeatTmp = [[NSMutableArray alloc] init];
	NSArray *arraySeatJson = [dictionaryResultJson safeObjectForKey:@"seats"];
    
    if(arraySeatJson != nil)
	{
		// 坐席数目
		NSUInteger seatCount = [arraySeatJson count];
		
		for(NSUInteger i = 0; i < seatCount; i++)
		{
			NSDictionary *dictionarySeatJson = [arraySeatJson safeObjectAtIndex:i];
			if(dictionarySeatJson != nil)
			{
				// 解析该坐席对象
				TrainSeats *trainSeat = [[TrainSeats alloc] init];
				[trainSeat parseSearchResult:dictionarySeatJson];
				[arraySeatTmp addObject:trainSeat];
			}
		}
	}
	_arraySeats = arraySeatTmp;
    
    // 最低价
    _lowPrice = [dictionaryResultJson safeObjectForKey:@"lowPrice"];
    
    // 余票状态
    _ypCode = [dictionaryResultJson safeObjectForKey:@"ticketYpCode"];
    
    // 余票信息
    _ypMessage = [dictionaryResultJson safeObjectForKey:@"ticketYpName"];
}

@end
