//
//  ScenicUtils.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScenicUtils : NSObject
//获取字符串高度
+(CGFloat)getTheStringHeight:(NSString *)originString FontSize:(CGFloat)size Width:(CGFloat)width;
//从给定的购买须知 html串中，抽出部分展示
+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

+(void)savaHistory:(NSObject *)object toPath:(NSString *)toPath withCount:(int)count;
+(NSArray  *)getHistoryFromPath:(NSString *)fromPath;
+ (void)clearHistoryFromPath:(NSString *)fromPath;
@end
