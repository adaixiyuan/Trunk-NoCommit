//
//  FStatusList.h
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FStatusList : NSObject


@property (nonatomic, strong) NSNumber *isError;            // 是否出错
@property (nonatomic, strong) NSString *errorCode;          // 出错时显示出错代码
@property (nonatomic, strong) NSString *errorMessage;       // 错误信息
@property (nonatomic, strong) NSString *flightDate;         // 查询航班日期
@property (nonatomic, strong) NSString *flightNote;         // 查询描述
@property (nonatomic, strong) NSArray *arrayListInfos;      // 航班信息


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
