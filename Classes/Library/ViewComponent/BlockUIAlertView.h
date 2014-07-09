//
//  AppDelegate.m
//  AAA
//
//  Created by licheng on 14-3-29.
//  Copyright (c) 2014年 licheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(NSInteger);

@interface BlockUIAlertView : UIAlertView

@property(nonatomic,copy)ButtonBlock block;

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles
        buttonBlock:(ButtonBlock)block;

@end
