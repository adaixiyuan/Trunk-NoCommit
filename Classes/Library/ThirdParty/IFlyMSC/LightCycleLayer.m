//
//  LightCycleLayer.m
//  ElongClient
//
//  Created by Dawn on 14-3-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "LightCycleLayer.h"

@interface LightCycleLayer ()
@property (nonatomic, retain) CAAnimationGroup *animationGroup;
@end


@implementation LightCycleLayer

- (void) dealloc{
    self.animationGroup = nil;
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.hidden = YES;
        // default
        self.animationDuration = 3;
        self.pulseInterval = 0;
        
        

        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ifly_btn_light.png"]].CGColor;
    }
    return self;
}

- (void) setRadius:(CGFloat)radius{
    _radius = radius;
    
    CGPoint tempPos = self.position;
    
    CGFloat diameter = self.radius * 2;
    
    self.bounds = CGRectMake(0, 0, diameter, diameter);
    self.cornerRadius = self.radius;
    self.position = tempPos;
}


- (void) startAnimation{
    self.hidden = NO;
    [self setupAnimationGroup];
    [self addAnimation:self.animationGroup forKey:@"rotate"];
}

- (void) stopAnimation{
    self.hidden = YES;
    [self removeAnimationForKey:@"rotate"];
}

- (void)setupAnimationGroup {
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;
    self.animationGroup.repeatCount = INFINITY;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    rotateAnimation.duration = self.animationDuration;
    
    NSArray *animations = [NSArray arrayWithObjects:rotateAnimation, nil];
    
    self.animationGroup.animations = animations;
}

@end
