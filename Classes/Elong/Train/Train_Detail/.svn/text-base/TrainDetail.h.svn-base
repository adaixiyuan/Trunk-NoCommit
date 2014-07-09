//
//  TrainDetail.h
//  ElongClient
//
//  Created by bruce on 13-11-13.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainDetail : NSObject

@property (nonatomic, strong) NSNumber *isError;            // 是否出错
@property (nonatomic, strong) NSString *errorCode;          // 出错时显示出错代码
@property (nonatomic, strong) NSString *errorMessage;       // 错误信息
@property (nonatomic, strong) NSArray *arrayStation;        // 站点集合
@property (nonatomic, strong) NSString *wrapperId;          // ota厂商

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
