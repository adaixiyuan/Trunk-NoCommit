//
//  PulsingHaloLayer.h
//  ElongClient
//
//  旋转光圈动画
//
//  Created by Dawn on 14-3-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface LightCycleLayer : CALayer

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSTimeInterval pulseInterval;

- (void) startAnimation;
- (void) stopAnimation;
@end
