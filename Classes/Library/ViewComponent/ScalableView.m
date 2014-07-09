//
//  ScalableView.m
//  ElongClient
//
//  Created by Wang Shuguang on 12-12-11.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "ScalableView.h"

#define SCALABLEBUTTONTAG 1010
@implementation ScalableView
@synthesize delegate;
@synthesize imageArray;
@synthesize hightlightedArray;

- (void) dealloc{
    [buttons release];
    self.imageArray = nil;
    self.hightlightedArray = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images highlightedImages:(NSArray *)hImages{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = images;
        self.hightlightedArray = hImages;
        // Initialization code
        buttons = [[NSMutableArray alloc] initWithCapacity:[images count]];
        buttonSize = CGSizeMake(frame.size.height, frame.size.height);
        buttonCount = [images count];
        buttonSpace = (frame.size.width - buttonSize.width + 0.0)/(buttonCount - 1);
        expand = NO;
        frameTime = 0.8/(buttonCount - 1);
        bounceSpace = 16;
        
        for (int i = 0; i < [images count]; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(frame.size.width - buttonSize.width, 0, buttonSize.width, buttonSize.height);
            [button setImage:[UIImage noCacheImageNamed:[images safeObjectAtIndex:i]] forState:UIControlStateNormal];
            if (hImages && [hImages count] > i) {
                [button setImage:[UIImage noCacheImageNamed:[hImages safeObjectAtIndex:i]] forState:UIControlStateHighlighted];
            }
            [self addSubview:button];
            [buttons addObject:button];
            button.tag = i + SCALABLEBUTTONTAG;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setAdjustsImageWhenDisabled:NO];
        }
        
        UIButton *button =  (UIButton *)[self viewWithTag:0 + SCALABLEBUTTONTAG];
        lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bounceSpace, 5)];
        lineView.center = CGPointMake(round(button.center.x),round(button.center.y));
        lineView.image = [UIImage noCacheImageNamed:@"nav_line.png"];
        [self addSubview:lineView];
        [self sendSubviewToBack:lineView];
        [lineView release];
        
        lastIndex = -1;
    }
    return self;
}
- (void) moveBack{
    if (expand) {
        
        int index = imageArray.count - 1;
        UIButton *button = (UIButton *)[self viewWithTag:index + SCALABLEBUTTONTAG];
        [button setImage:[UIImage noCacheImageNamed:[self.imageArray safeObjectAtIndex:index]] forState:UIControlStateNormal];
        [self beginAnimation];
    }
}

- (void) moveOut{
    if (!expand) {
        frameTime = 0;
        int index = imageArray.count - 1;
        UIButton *button = (UIButton *)[self viewWithTag:index + SCALABLEBUTTONTAG];
        [button setImage:[UIImage noCacheImageNamed:[self.hightlightedArray safeObjectAtIndex:index]] forState:UIControlStateNormal];
        [self beginAnimation];
        frameTime = 0.8/(buttonCount - 1);
    }
}

- (void) buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (lastIndex != imageArray.count - 1 && lastIndex != -1) {
        UIButton *lastButton = (UIButton *)[self viewWithTag:lastIndex + SCALABLEBUTTONTAG];
        [lastButton setImage:[UIImage noCacheImageNamed:[self.imageArray safeObjectAtIndex:lastIndex]] forState:UIControlStateNormal];
    }
    lastIndex = button.tag - SCALABLEBUTTONTAG;
    if (lastIndex != imageArray.count - 1 && lastIndex != -1) {
        [button setImage:[UIImage noCacheImageNamed:[self.hightlightedArray safeObjectAtIndex:lastIndex]] forState:UIControlStateNormal];
    }
    
    if (lastIndex == imageArray.count - 1) {
        if (!expand) {
            [button setImage:[UIImage noCacheImageNamed:[self.hightlightedArray safeObjectAtIndex:lastIndex]] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage noCacheImageNamed:[self.imageArray safeObjectAtIndex:lastIndex]] forState:UIControlStateNormal];
        }
    }

    
    if (button.tag-SCALABLEBUTTONTAG == buttonCount - 1) {
        // 最上层的触发按钮
        [self beginAnimation];
        if ([delegate respondsToSelector:@selector(scalableViewDidMoveout:)]) {
            [delegate scalableViewDidMoveout:self];
        }
    }else{
        if ([delegate respondsToSelector:@selector(scalableView:didSelectedAtIndex:)]) {
            [delegate scalableView:self didSelectedAtIndex:button.tag - SCALABLEBUTTONTAG];
        }
    }
}

#pragma mark -
#pragma mark HitTest
-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIButton *baseButton =  (UIButton *)[self viewWithTag:SCALABLEBUTTONTAG + buttonCount - 1];
    if (point.x > baseButton.frame.origin.x
        && point.x < baseButton.frame.origin.x + baseButton.frame.size.width
        && point.y > baseButton.frame.origin.y
        && point.y < baseButton.frame.origin.y + baseButton.frame.size.height) {
        return baseButton;
    }
    
    
    
    for (int i = 0; i < buttonCount-1; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:SCALABLEBUTTONTAG + i];
        if (point.x > button.frame.origin.x
            && point.x < button.frame.origin.x + button.frame.size.width
            && point.y > button.frame.origin.y
            && point.y < button.frame.origin.y + button.frame.size.height) {
            return button;
        }
    }
    
    return nil;
}

- (void) beginAnimation{
   
    if (!expand) {
        expand = YES;
        
        CGPoint startPoint = CGPointZero;
        CGPoint endPoint = CGPointZero;
        for (int i = 0; i < buttonCount - 1; i++) {
            startPoint = CGPointMake(self.frame.size.width - buttonSize.width/2, buttonSize.width/2);
            endPoint = CGPointMake(startPoint.x - (buttonCount - i - 1) * buttonSpace, buttonSize.width/2);
            
            
            UIButton *button = (UIButton *)[buttons safeObjectAtIndex:i];
            
            // 旋转
            float duration = (buttonCount - i - 1) * frameTime;
            CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotateAnimation.values = [NSArray arrayWithObjects:
                                      [NSNumber numberWithFloat:0],
                                      [NSNumber numberWithFloat:-M_PI],
                                      [NSNumber numberWithFloat:-M_PI * 2], nil];
            rotateAnimation.duration = duration;
            rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                        [NSNumber numberWithFloat:0],
                                        [NSNumber numberWithFloat:duration * 1/2],
                                        [NSNumber numberWithFloat:duration], nil];
            
            
            // 按轨迹移动
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
            for (int j = 0; j < buttonCount - 1 - i; j++) {
                if (j == buttonCount - 1 - i - 1) {
                    CGPathAddLineToPoint(path, NULL, startPoint.x - (buttonCount - 1 - i) * buttonSpace - bounceSpace, startPoint.y);
                }else{
                    CGPathAddLineToPoint(path, NULL, startPoint.x - (j + 1) * buttonSpace, startPoint.y);
                }
            }
            CGPathAddLineToPoint(path, NULL, startPoint.x - (buttonCount - 1 - i) * buttonSpace, startPoint.y);
            
            positionAnimation.path = path;
            CGPathRelease(path);
            positionAnimation.duration = duration;
            
            
            CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
            if (IOSVersion_5) {
                animationgroup.animations = [NSArray arrayWithObjects:rotateAnimation,positionAnimation, nil];
            }else{
                animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
            }
            
            animationgroup.duration = duration;
            animationgroup.fillMode = kCAFillModeForwards;
            animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            [button.layer addAnimation:animationgroup forKey:@"out"];
            button.center = endPoint;
        }
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:frameTime*(buttonCount-1) - 0.22];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        lineView.frame = CGRectMake(startPoint.x - (buttonCount - 1) * buttonSpace - buttonSize.width/2 + 6, round(buttonSize.height/2 -2), (buttonCount - 1) * buttonSpace + buttonSize.width - 12, 5);
        [UIView commitAnimations];
    }else{
        expand = NO;
        CGPoint endPoint = CGPointZero;
        CGPoint startPoint = CGPointZero;
        for (int i = 0; i < buttonCount - 1; i++) {
            endPoint = CGPointMake(self.frame.size.width - buttonSize.width/2, buttonSize.width/2);
            startPoint = CGPointMake(endPoint.x - (buttonCount - i - 1) * buttonSpace, buttonSize.width/2);
            
            UIButton *button = (UIButton *)[buttons safeObjectAtIndex:i];
            
            // 旋转
            float duration = (buttonCount - i - 1) * frameTime;
            CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotateAnimation.values = [NSArray arrayWithObjects:
                                      [NSNumber numberWithFloat:0],
                                      [NSNumber numberWithFloat:M_PI],
                                      [NSNumber numberWithFloat:M_PI * 2], nil];
            rotateAnimation.duration = duration;
            rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                        [NSNumber numberWithFloat:0],
                                        [NSNumber numberWithFloat:duration * 1/2],
                                        [NSNumber numberWithFloat:duration], nil];
            
            // 按轨迹移动
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
            CGPathAddLineToPoint(path, NULL, startPoint.x - bounceSpace/2, startPoint.y);
            for (int j = 0; j < buttonCount - 1 - i; j++) {
                CGPathAddLineToPoint(path, NULL, startPoint.x + (j + 1) * buttonSpace, startPoint.y);
            }
            //CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
            positionAnimation.path = path;
            CGPathRelease(path);
            positionAnimation.duration = (buttonCount - i - 1) * frameTime;
            
            
            CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
            animationgroup.animations = [NSArray arrayWithObjects:rotateAnimation,positionAnimation, nil];
            animationgroup.duration = duration;
            animationgroup.speed = 2;
            animationgroup.fillMode = kCAFillModeForwards;
            animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            [button.layer addAnimation:animationgroup forKey:@"in"];
            button.center = endPoint;

        }

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:frameTime*(buttonCount-1)/2];
        [UIView setAnimationDelay:0.01];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        lineView.frame = CGRectMake(endPoint.x,round(buttonSize.height/2 -2), bounceSpace, 5);
        [UIView commitAnimations];
    }
   
}
@end
