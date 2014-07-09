//
//  TrainCityUpdate.h
//  ElongClient
//
//  Created by bruce on 13-11-6.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainCityUpdate : NSObject <HttpUtilDelegate>


@property (nonatomic, strong) NSArray *arrayStations;       // 车站数据
@property (nonatomic, strong) NSString *wrapperId;          // 来源厂商Id
@property (nonatomic, strong) NSNumber *isError;            // 是否出错
@property (nonatomic, strong) NSString *errorCode;          // 出错时显示出错代码
@property (nonatomic, strong) NSString *errorMessage;       // 错误信息


- (void)trainCityUpdateStart;

@end
