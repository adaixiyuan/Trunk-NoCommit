//
//  ModalDismissAnimation.m
//  TransitionTest
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "ModalAnimation.h"

@implementation ModalAnimation {

}

#pragma mark - Animated Transitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.type == AnimationTypePresent) {

        UIView* inView = [transitionContext containerView];
        
        UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [inView addSubview:toViewController.view];
        
        toViewController.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + SCREEN_HEIGHT/2);
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.01 options:UIViewAnimationOptionCurveEaseOut animations:^{
            toViewController.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else if (self.type == AnimationTypeDismiss) {
        
        UIView* inView = [transitionContext containerView];
        
        UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        [inView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        [toViewController viewWillAppear:YES];
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.01 options:UIViewAnimationOptionCurveEaseOut animations:^{
            fromViewController.view.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT + SCREEN_HEIGHT/2);
        } completion:^(BOOL finished) {
            [toViewController viewDidAppear:YES];
            [transitionContext completeTransition:YES];
        }];
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.type == AnimationTypePresent) return 0.5;
    else if (self.type == AnimationTypeDismiss) return 0.5;
    else return [super transitionDuration:transitionContext];
}

@end
