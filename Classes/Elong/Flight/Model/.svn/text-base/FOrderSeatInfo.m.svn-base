//
//  FOrderSeatInfo.m
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FOrderSeatInfo.h"
#import "FOrderSeatDetailInfo.h"

@implementation FOrderSeatInfo

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
    
    // 座位详细信息
    NSMutableArray *arrayDetailInfosTmp = [[NSMutableArray alloc] init];
	NSArray *arrayDetailInfosJson = [dictionaryResultJson safeObjectForKey:@"AirLine_PassengerInfos"];
    
    if(arrayDetailInfosJson != nil)
	{
		// 结果数目
		NSUInteger detailCount = [arrayDetailInfosJson count];
		
		for(NSUInteger i = 0; i < detailCount; i++)
		{
			NSDictionary *dictionaryInfoJson = [arrayDetailInfosJson safeObjectAtIndex:i];
			if(dictionaryInfoJson != nil)
			{
				// 解析该对象
				FOrderSeatDetailInfo *fOrderSeatDetailInfo = [[FOrderSeatDetailInfo alloc] init];
				[fOrderSeatDetailInfo parseSearchResult:dictionaryInfoJson];
				[arrayDetailInfosTmp addObject:fOrderSeatDetailInfo];
			}
		}
	}
	_arrayDetailInfo = arrayDetailInfosTmp;
    
}

@end
