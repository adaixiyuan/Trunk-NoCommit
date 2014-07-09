//
//  UIRangeSlider.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIRangeSlider : UIControl

@property (nonatomic, assign) double minimumValue;
@property (nonatomic, assign) double maximumValue;
@property (nonatomic, assign) double minimumRange;

@property (nonatomic, assign) double horizontalInset;

@property (nonatomic, retain) UIImage *minimumThumbImage;
@property (nonatomic, retain) UIImage *maximumThumbImage;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) UIImage *inRangeTrackImage;
@property (nonatomic, retain) UIImage *trackImage;

@end
