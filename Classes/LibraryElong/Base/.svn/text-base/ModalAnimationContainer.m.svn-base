//
//  ModalAnimationContainer.m
//  ElongClient
//
//  Created by Dawn on 14-1-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ModalAnimationContainer.h"

static ModalAnimationContainer *modalAnimationContainer;

@implementation ModalAnimationContainer
- (void) dealloc{
    [modalAnimationController release];
    [super dealloc];
}

+ (id)shared {
	@synchronized(modalAnimationContainer) {
		if (!modalAnimationContainer) {
			modalAnimationContainer = [[ModalAnimationContainer alloc] init];
		}
	}
	
    // 暂时屏蔽自定义弹起状态
	return nil;// modalAnimationContainer;
}

- (id) init{
    if (self = [super init]) {
        modalAnimationController = [[ModalAnimation alloc] init];
    }
    return self;
}

#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    modalAnimationController.type = AnimationTypePresent;
    return modalAnimationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    modalAnimationController.type = AnimationTypeDismiss;
    return modalAnimationController;
}

@end
