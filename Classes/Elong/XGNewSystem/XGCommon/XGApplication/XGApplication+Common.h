//
//  XGApplication+Common.h
//  ElongClient
//
//  Created by guorendong on 14-4-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGApplication.h"

@interface XGApplication (Common)

-(BOOL)isLogin;//判断是否登录
//是否内网 1内网0外网，2自定义网址
-(NSInteger)isNeiWang;
//是否外网
-(void)setIsNeiWang:(NSInteger)isNeiWang;

-(NSString *)getUrlString:(NSString *)model methodName:(NSString *)methodName;
-(void)setCurrCustomNet:(NSString *)ip;
-(NSString *)getCurrCustomNet;

-(void)setCurrCustomNetDK:(NSString *)ipDK;
-(NSString *)getCurrCustomNetDK;
-(UIImage*) getViewImage:(UIView *)view;
//设置是否动画进入朴树ViewController

-(BOOL)isAnimationForSaerch;

//by lc
//请求失败的时候绑定
-(void)c2c_RequestBangding2id:(NSDictionary *)root;
//by lc
//价格划块  最终的返回数据
-(NSString *)priceRangeMin:(int)minPrice Max:(int)maxPrice bedIndex:(int)bedIndex;


//启动配置请求实效时间范围
-(void)requestRunLoopRang;


//判断是否是同一天
-(BOOL)isSameDay:(NSDate *)judgeDay;

//取消上次请求的接口
-(void)cancelLastRequestId:(NSString *)lastRequestid;

//从zhu app 进入首页或者进入列表  非常重要
-(void)pushViewAnimation:(UINavigationController *)nav;
@end
