//
//  FlightLowPriceList.h
//  ElongClient
//
//  Created by bruce on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightLowPrice : NSObject

@property (nonatomic, strong) NSNumber *isError;            // 是否出错
@property (nonatomic, strong) NSString *errorMessage;       // 错误信息
@property (nonatomic, strong) NSArray *arrayPriceList;      // 低价列表

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
