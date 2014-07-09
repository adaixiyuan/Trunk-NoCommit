//
//  FOrderGetSeatMap.h
//  ElongClient
//
//  Created by bruce on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightSeatMap.h"

@interface FOrderGetSeatMap : NSObject

@property (nonatomic, strong) NSNumber *isError;                // 是否出错
@property (nonatomic, strong) NSString *errorMessage;           // 错误信息
@property (nonatomic, strong) FlightSeatMap *flightSeatMap;     // 座位表

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
