//
//  FunctionUtils.h
//  ElongClient
//  机票详情页 功能抽离
//  Created by Janven on 14-3-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlightOrderDetail.h"
typedef enum {
    ShareContent_SMS = 10,
    ShareContent_Mail,
    ShareContent_WeiBo,
}ShareContent;

@interface FunctionUtils : NSObject
//将行程添加到日历
+(void)addScheduleToCalendarOn:(UIViewController *)_controller andDataModel:(NSObject *)object;

//截屏
+(UIImage *)captureViewOfScrollow:(UIScrollView *)scrollow;

//分享内容设置
+(NSString *)getTheShareContentType:(ShareContent )type AndSource:(NSObject *)object;

//保存相册动画
+(void)animationOfSaveToPhotosAlbum:(UIImageView *)view andViewController:(UIViewController *)vc;

//返回支付宝请求参数
+(NSDictionary *)getAlipayRequestDictionaryWithType:(NSString *)type AndSource:(FlightOrderDetail *)flight;

@end
