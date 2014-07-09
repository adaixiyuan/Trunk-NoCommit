//
//  TrainSeats.h
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainSeats : NSObject<NSMutableCopying>

@property (nonatomic, strong) NSString *code;             // 座席代码
@property (nonatomic, strong) NSString *name;             // 座席名称，如软卧、硬座、无座等
@property (nonatomic, strong) NSString *yupiao;           // 座席剩余量（余票）信息
@property (nonatomic, strong) NSString *price;            // 票价
@property (nonatomic, strong) NSString *lowPrice;         // 最低票价
@property (nonatomic, strong) NSNumber *ypCode;           // 余票状态
@property (nonatomic, strong) NSString *ypMessage;        // 余票状态信息

@property (nonatomic, strong) NSArray *availableTypes;              // 允许使用的乘客票种
@property (nonatomic, strong) NSString *currentTicketType;  // 这个坐席当前的票种

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
