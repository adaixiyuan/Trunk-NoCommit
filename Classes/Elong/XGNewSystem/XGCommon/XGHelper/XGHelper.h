//
//  XGHelper.h
//  ElongClient
//
//  Created by guorendong on 14-4-23.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#define C2CSUCCESSORDERID @"C2CSUCCESSORDERID"

#define C2C_LIST_FRIST_BACK @"C2C_LIST_FRIST_BACK"

#define C2C_LASTRUNLOOP_DATE @"C2C_LASTRUNLOOP_DATE"  //上次请求的日期

#define C2CRUNLOOP_MINUTES @"C2CRUNLOOP_MINUTES"    // 轮训的时间间隔 单位是分钟

#define XGSearchCityName @"北京"  //漠河  //北京

#import <Foundation/Foundation.h>

@interface XGHelper : NSObject

+(void)saveEntityFromEntity:(id<NSCoding>)entity fileName:(NSString *)fileName;
+(id<NSCoding>)getEntityFromFileName:(NSString *)fileName;


@end
