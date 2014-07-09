//
//  XGTabView.h
//  ElongClient
//
//  Created by guorendong on 14-4-24.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGTabView;
typedef void(^XGTouchTabView)(XGTabView *tabView);
#define XGTabBackColor [UIColor colorWithRed:60.0f/255.0 green:60.0f/255.0 blue:60.0f/255.0 alpha:1]
@interface XGTabView : UIButton

@property(nonatomic,copy)XGTouchTabView touchTabView;
@property(nonatomic,copy)UIImageView *sortArrowImageView;//用于显示上下箭头

@property(nonatomic)BOOL isSelected;

-(void)setTabInfoForText:(NSString *)text;
-(void)setTabInfoForText:(NSString *)text touchTabView:(XGTouchTabView)touchTabView;
-(void)setTabInfoForText:(NSString *)text textColor:(UIColor *)textColor;
-(void)setTabInfoForText:(NSString *)text textColor:(UIColor *)textColor touchTabView:(XGTouchTabView)touchTabView;
-(void)setTabInfoForTextColor:(UIColor *)textColor;
-(void)setTabInfoForTextColor:(UIColor *)textColor touchTabView:(XGTouchTabView)touchTabView;

@end