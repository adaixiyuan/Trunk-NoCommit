//
//  FlightSeatRow.m
//  ElongClient
//
//  Created by bruce on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightSeatRow.h"
#import "FlightSeatItem.h"

@implementation FlightSeatRow

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 座位项
    NSMutableArray *arraySeatTmp = [[NSMutableArray alloc] init];
	NSArray *arraySeatJson = [dictionaryResultJson safeObjectForKey:@"AirSeats"];
    
    if(arraySeatJson != nil)
	{
		// 座位数目
		NSUInteger seatCount = [arraySeatJson count];
		
		for(NSUInteger i = 0; i < seatCount; i++)
		{
			NSDictionary *dictionarySeatJson = [arraySeatJson safeObjectAtIndex:i];
			if(dictionarySeatJson != nil)
			{
				// 解析该对象
				FlightSeatItem *flightSeat = [[FlightSeatItem alloc] init];
				[flightSeat parseSearchResult:dictionarySeatJson];
				[arraySeatTmp addObject:flightSeat];
			}
		}
	}
	_arraySeatItem = arraySeatTmp;
    
    
    //
    _rowIndex = [dictionaryResultJson safeObjectForKey:@"Index"];
    
    //
    _rowId = [dictionaryResultJson safeObjectForKey:@"Id"];
}

@end
