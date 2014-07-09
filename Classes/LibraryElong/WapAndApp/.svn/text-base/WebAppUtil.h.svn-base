//
//  WebAppUtil.h
//  ElongClient
//  工具类
//  Created by garin on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebAppUtil : NSObject

//是否匹配正则
+(BOOL) isMatchRegex:(NSString *) txt regexStr:(NSString *) regexStr;

//解析queryString
+(NSDictionary *)parseQueryString:(NSString *)query;

//查找指定rp,currentRoomIndex(返回指定选中的index)
+(NSDictionary *) getBookingRoom:(NSArray *) rooms currentRoomIndex:(int *)currentRoomIndex findRoomId:(NSString *) findRoomid
                  findRatePlanId:(NSString *) findRatePlanId;

@end
