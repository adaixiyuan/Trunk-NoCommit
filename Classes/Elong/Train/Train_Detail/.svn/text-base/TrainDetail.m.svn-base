//
//  TrainDetail.m
//  ElongClient
//
//  Created by bruce on 13-11-13.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainDetail.h"
#import "TrainDetailStation.h"

@implementation TrainDetail


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 出错时显示出错代码
    _errorCode = [dictionaryResultJson safeObjectForKey:@"ErrorCode"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
    
    // 站点集合
    NSMutableArray *arrayStationTmp = [[NSMutableArray alloc] init];
	NSArray *arrayStationJson = [dictionaryResultJson safeObjectForKey:@"stations"];
    
    if(arrayStationJson != nil)
	{
		// 车次数目
		NSUInteger stationCount = [arrayStationJson count];
		
		for(NSUInteger i = 0; i < stationCount; i++)
		{
			NSDictionary *dictionaryStationJson = [arrayStationJson safeObjectAtIndex:i];
			if(dictionaryStationJson != nil)
			{
				// 解析该站点对象
				TrainDetailStation *trainDetailStation = [[TrainDetailStation alloc] init];
				[trainDetailStation parseSearchResult:dictionaryStationJson];
				[arrayStationTmp addObject:trainDetailStation];
			}
		}
	}
	_arrayStation = arrayStationTmp;
    
    
    // 票的数据来源
    _wrapperId = [dictionaryResultJson safeObjectForKey:@"wrapperId"];
}

@end
