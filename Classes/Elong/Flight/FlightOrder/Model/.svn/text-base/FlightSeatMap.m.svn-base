//
//  FlightSeatMap.m
//  ElongClient
//
//  Created by bruce on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightSeatMap.h"
#import "FlightSeatDeck.h"

@implementation FlightSeatMap

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 舱位层
    NSMutableArray *arrayDeckTmp = [[NSMutableArray alloc] init];
	NSArray *arrayDeckJson = [dictionaryResultJson safeObjectForKey:@"Decks"];
    
    if(arrayDeckJson != nil)
	{
		// 层数目
		NSUInteger deckCount = [arrayDeckJson count];
		
		for(NSUInteger i = 0; i < deckCount; i++)
		{
			NSDictionary *dictionaryDeckJson = [arrayDeckJson safeObjectAtIndex:i];
			if(dictionaryDeckJson != nil)
			{
				// 解析该对象
				FlightSeatDeck *flightDeck = [[FlightSeatDeck alloc] init];
				[flightDeck parseSearchResult:dictionaryDeckJson];
				[arrayDeckTmp addObject:flightDeck];
			}
		}
	}
	_arrayDeck = arrayDeckTmp;
}



@end
