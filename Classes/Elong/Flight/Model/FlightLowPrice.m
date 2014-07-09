//
//  FlightLowPriceList.m
//  ElongClient
//
//  Created by bruce on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightLowPrice.h"
#import "LowPriceItem.h"

@implementation FlightLowPrice

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 是否出错
    _isError = [dictionaryResultJson safeObjectForKey:@"IsError"];
    
    // 错误信息
    _errorMessage = [dictionaryResultJson safeObjectForKey:@"ErrorMessage"];
    
    // 低价列表
    NSMutableArray *arrayPriceListTmp = [[NSMutableArray alloc] init];
	NSArray *arrayPriceListJson = [dictionaryResultJson safeObjectForKey:@"PricesList"];
    
    if(arrayPriceListJson != nil)
	{
		// 低价数目
		NSUInteger priceCount = [arrayPriceListJson count];
		
		for(NSUInteger i = 0; i < priceCount; i++)
		{
			NSDictionary *dictionaryPriceJson = [arrayPriceListJson safeObjectAtIndex:i];
			if(dictionaryPriceJson != nil)
			{
				// 解析该低价对象
				LowPriceItem *lowPrice = [[LowPriceItem alloc] init];
				[lowPrice parseSearchResult:dictionaryPriceJson];
				[arrayPriceListTmp addObject:lowPrice];
			}
		}
	}
	_arrayPriceList = arrayPriceListTmp;
}

@end
