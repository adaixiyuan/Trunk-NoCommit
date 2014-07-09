//
//  FOrderSeatInfo.h
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FOrderSeatInfo : NSObject

@property (nonatomic, strong) NSNumber *isError;                // 是否出错
@property (nonatomic, strong) NSString *errorMessage;           // 错误信息
@property (nonatomic, strong) NSArray *arrayDetailInfo;         // 订单选座详细信息



// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
