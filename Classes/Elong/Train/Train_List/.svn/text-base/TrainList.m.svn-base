//
//  TrainList.m
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainList.h"
#import "TrainTickets.h"

@implementation TrainList


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 出错时显示出错代码
    _errorCode = [dictionaryResultJson safeObjectForKey:@"ErrorCode"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
    
    // 可订状态，0：有票、1：无票
    _bookStatus = [dictionaryResultJson safeObjectForKey:@"bookStatus"];
    
    // 出发日期
    _startDate = [dictionaryResultJson safeObjectForKey:@"startDate"];
    
    // 车次集合
    NSMutableArray *arrayTicketsTmp = [[NSMutableArray alloc] init];
	NSArray *arrayTicketsJson = [dictionaryResultJson safeObjectForKey:@"tickets"];
    
    if(arrayTicketsJson != nil)
	{
		// 车次数目
		NSUInteger ticketsCount = [arrayTicketsJson count];
		
		for(NSUInteger i = 0; i < ticketsCount; i++)
		{
			NSDictionary *dictionaryTicketJson = [arrayTicketsJson safeObjectAtIndex:i];
			if(dictionaryTicketJson != nil)
			{
				// 解析该列车对象
				TrainTickets *trainTicket = [[TrainTickets alloc] init];
				[trainTicket parseSearchResult:dictionaryTicketJson];
				[arrayTicketsTmp addObject:trainTicket];
			}
		}
	}
	_arrayTickets = arrayTicketsTmp;
    
    // 票的数据来源
    _wrapperId = [dictionaryResultJson safeObjectForKey:@"wrapperId"];
    
    // 是否查询有票
    _hasYp = [dictionaryResultJson safeObjectForKey:@"hasYp"];
}

@end
