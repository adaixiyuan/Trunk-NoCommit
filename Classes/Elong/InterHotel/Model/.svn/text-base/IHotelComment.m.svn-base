//
//  IHotelComment.m
//  ElongClient
//
//  Created by bruce on 14-6-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "IHotelComment.h"
#import "IHotelCommentItem.h"

@implementation IHotelComment

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
    _pageCount = [dictionaryResultJson safeObjectForKey:@"PageCount"];
    
    // 平均评分
    _averageScore = [dictionaryResultJson safeObjectForKey:@"AverageScore"];
    
    // 评论列表
    NSMutableArray *arrayListInfosTmp = [[NSMutableArray alloc] init];
	NSArray *arrayListInfosJson = [dictionaryResultJson safeObjectForKey:@"Comments"];
    
    if(arrayListInfosJson != nil)
	{
		// 评论数目
		NSUInteger ticketsCount = [arrayListInfosJson count];
		
		for(NSUInteger i = 0; i < ticketsCount; i++)
		{
			NSDictionary *dictionaryInfoJson = [arrayListInfosJson safeObjectAtIndex:i];
			if(dictionaryInfoJson != nil)
			{
				// 解析评论对象
				IHotelCommentItem *itemInfos = [[IHotelCommentItem alloc] init];
				[itemInfos parseSearchResult:dictionaryInfoJson];
				[arrayListInfosTmp addObject:itemInfos];
			}
		}
	}
	_arrayComments = arrayListInfosTmp;
    
    
}

@end
