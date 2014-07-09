//
//  FOrderSeatPassengerInfo.h
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FOrderSeatPassengerInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *certificateType;
@property (nonatomic, strong) NSString *certificateNumber;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *passengerType;

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
