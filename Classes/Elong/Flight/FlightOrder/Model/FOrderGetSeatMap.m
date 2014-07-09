//
//  FOrderGetSeatMap.m
//  ElongClient
//
//  Created by bruce on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FOrderGetSeatMap.h"

@implementation FOrderGetSeatMap

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
    
    // 座位表
    FlightSeatMap *flightSeatMapTmp = [[FlightSeatMap alloc] init];
	NSDictionary *dictionarySeatMapJson = [dictionaryResultJson safeObjectForKey:@"SeatMap"];
	if(dictionarySeatMapJson == nil)
	{
        dictionarySeatMapJson = [[NSDictionary alloc] init];
		
	}
	[flightSeatMapTmp parseSearchResult:dictionarySeatMapJson];
    
    _flightSeatMap = flightSeatMapTmp;
    
}

@end
