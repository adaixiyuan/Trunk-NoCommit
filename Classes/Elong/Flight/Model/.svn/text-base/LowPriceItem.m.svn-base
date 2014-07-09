//
//  LowPriceList.m
//  ElongClient
//
//  Created by bruce on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "LowPriceItem.h"

@implementation LowPriceItem

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 日期
    _flightDate = [dictionaryResultJson safeObjectForKey:@"FlightDate"];
    
    // 价格
    _lowestPrice = [dictionaryResultJson safeObjectForKey:@"LowestPrice"];
}

@end
