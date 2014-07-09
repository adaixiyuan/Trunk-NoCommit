//
//  TrainList.h
//  ElongClient
//
//  Created by bruce on 13-11-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainList : NSObject


@property (nonatomic, strong) NSNumber *isError;            // 是否出错
@property (nonatomic, strong) NSNumber *bookStatus;         // 可订状态，0：有票、1：无票
@property (nonatomic, strong) NSString *errorCode;          // 出错时显示出错代码
@property (nonatomic, strong) NSString *errorMessage;       // 错误信息
@property (nonatomic, strong) NSString *startDate;          // 出发日期
@property (nonatomic, strong) NSArray *arrayTickets;        // 车次集合
@property (nonatomic, strong) NSString *wrapperId;          // 票的数据来源
@property (nonatomic, strong) NSString *departDate;         // 出发日期
@property (nonatomic, strong) NSString *departCity;         // 出发城市
@property (nonatomic, strong) NSString *arriveCity;         // 到达城市
@property (nonatomic, strong) NSNumber *hasYp;              // 是否查询有票

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
