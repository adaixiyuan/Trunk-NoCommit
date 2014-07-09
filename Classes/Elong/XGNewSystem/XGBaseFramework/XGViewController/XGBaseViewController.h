//
//  XGBaseViewController.h
//  ElongClient
//
//  Created by guorendong on 14-4-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"

@interface XGBaseViewController : ElongBaseViewController
- (void)setNavTitle:(NSString *)title;//设置导航Title
-(NSString *)viewName;//viewName
-(void)ReleaseMemory;//释放内存
-(BOOL)checkJsonIsError:(NSDictionary *)root;
-(BOOL)checkJsonIsError:(NSDictionary *)root delaySecond:(NSTimeInterval)second;
+(BOOL)checkJsonIsError:(NSDictionary *)root delaySecond:(NSTimeInterval)second;
-(BOOL)isHasNavigationController;



@end
