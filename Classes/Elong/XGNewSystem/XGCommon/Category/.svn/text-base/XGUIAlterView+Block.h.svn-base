//
//  UIActionSheet+Block.h
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UIAlterSelectedIndex)(UIAlertView *alterView,NSInteger buttonIndex);
@interface UIAlertView (Block)<UIAlertViewDelegate>

-(void)setBlockAndShow:(UIAlterSelectedIndex)x;

@property(nonatomic,copy)UIAlterSelectedIndex selectIndex;

+(UIAlertView *)show:(NSString *)message butionTitle:(NSString *)title;
+(UIAlertView *)show:(NSString *)message delaySecond:(NSInteger)second;
+(UIAlertView *)show:(NSString *)message title:(NSString *)title delaySecond:(NSInteger)second;

+(UIAlertView *)show:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle selectIndex:(UIAlterSelectedIndex)alter otherButtonTitles:(NSString *)otherButtonTitles, ...;


+(UIAlertView *)show:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
