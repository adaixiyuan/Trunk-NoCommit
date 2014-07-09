//
//  FOrderSeatDetailInfo.h
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FOrderSeatAirLineInfo.h"

@interface FOrderSeatDetailInfo : NSObject

@property (nonatomic, strong) FOrderSeatAirLineInfo *airlineInfo;
@property (nonatomic, strong) NSArray *arrayPassengerPNR;
@property (nonatomic, strong) NSNumber *isCanSelect;
@property (nonatomic, strong) NSString *isContainNoAdult;

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
