//
//  FStatusList.m
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FStatusList.h"
#import "FStatusListInfos.h"

@implementation FStatusList

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 出错时显示出错代码
    _errorCode = [dictionaryResultJson safeObjectForKey:@"ErrorCode"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
    
    // 查询航班日期
    _flightDate = [dictionaryResultJson safeObjectForKey:@"flightDate"];
    
    // 查询描述
    _flightNote = [dictionaryResultJson safeObjectForKey:@"flightNote"];
    
    // 航班信息
    NSMutableArray *arrayListInfosTmp = [[NSMutableArray alloc] init];
	NSArray *arrayListInfosJson = [dictionaryResultJson safeObjectForKey:@"flightInfos"];
    
    if(arrayListInfosJson != nil)
	{
		// 车次数目
		NSUInteger ticketsCount = [arrayListInfosJson count];
		
		for(NSUInteger i = 0; i < ticketsCount; i++)
		{
			NSDictionary *dictionaryInfoJson = [arrayListInfosJson safeObjectAtIndex:i];
			if(dictionaryInfoJson != nil)
			{
				// 解析该航班对象
				FStatusListInfos *fStatusListInfos = [[FStatusListInfos alloc] init];
				[fStatusListInfos parseSearchResult:dictionaryInfoJson];
				[arrayListInfosTmp addObject:fStatusListInfos];
			}
		}
	}
	_arrayListInfos = arrayListInfosTmp;
    
    
}

@end
