//
//  PulsingHaloLayer.m
//  ElongClient
//
//  Created by Dawn on 14-3-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PulsingHaloLayer.h"

@interface PulsingHaloLayer ()
@property (nonatomic, retain) CAAnimationGroup *animationGroup;
@end


@implementation PulsingHaloLayer

- (void) dealloc{
    self.animationGroup = nil;
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0;
        
        // default
        self.toRadius = 60;
        self.animationDuration = 3;
        self.pulseInterval = 0;
        self.backgroundColor = [[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1] CGColor];
        
    }
    return self;
}
- (void) setFromRadius:(CGFloat)fromRadius{
    _fromRadius = fromRadius;
    if (_fromRadius > _toRadius) {
        self.toRadius = _fromRadius;
    }
}

- (void) setToRadius:(CGFloat)toRadius{
    _toRadius = toRadius;
    if (_fromRadius > _toRadius) {
        self.fromRadius = _toRadius;
    }
    CGPoint tempPos = self.position;
    
    CGFloat diameter = self.toRadius * 2;
    
    self.bounds = CGRectMake(0, 0, diameter, diameter);
    self.cornerRadius = self.toRadius;
    self.position = tempPos;
}


- (void) startAnimation{
    [self setupAnimationGroup];
    [self addAnimation:self.animationGroup forKey:@"pulse"];
}

- (void) stopAnimation{
    [self removeAnimationForKey:@"pulse"];
}

- (void)setupAnimationGroup {
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;
    self.animationGroup.repeatCount = INFINITY;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:self.fromRadius/self.toRadius];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration = self.animationDuration;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.45],[NSNumber numberWithFloat:0.45],[NSNumber numberWithFloat:0.0], nil];
    opacityAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:0.2],[NSNumber numberWithFloat:1.0], nil];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = [NSArray arrayWithObjects:scaleAnimation, opacityAnimation, nil];
    
    self.animationGroup.animations = animations;
}

@end
