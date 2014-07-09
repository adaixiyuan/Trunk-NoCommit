//
//  FlightSeatDeck.m
//  ElongClient
//
//  Created by bruce on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightSeatDeck.h"
#import "FlightSeatRow.h"

@implementation FlightSeatDeck

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 座位行
    NSMutableArray *arrayRowTmp = [[NSMutableArray alloc] init];
	NSArray *arrayRowJson = [dictionaryResultJson safeObjectForKey:@"Rows"];
    
    if(arrayRowJson != nil)
	{
		// 行数目
		NSUInteger rowCount = [arrayRowJson count];
		
		for(NSUInteger i = 0; i < rowCount; i++)
		{
			NSDictionary *dictionaryRowJson = [arrayRowJson safeObjectAtIndex:i];
			if(dictionaryRowJson != nil)
			{
				// 解析该对象
				FlightSeatRow *flightRow = [[FlightSeatRow alloc] init];
				[flightRow parseSearchResult:dictionaryRowJson];
				[arrayRowTmp addObject:flightRow];
			}
		}
	}
	_arrayRow = arrayRowTmp;
    
    //
    _deckIndex = [dictionaryResultJson safeObjectForKey:@"Index"];
    
}

@end
