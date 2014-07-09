//
//  XGMotionView.h
//  CRMotionViewDemo
//
//  Created by 李程 on 14-6-11.
//  Copyright (c) 2014年 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGMotionView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, getter = isMotionEnabled) BOOL motionEnabled;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;


-(void)startMotion;
-(void)stopMotion;

@end
