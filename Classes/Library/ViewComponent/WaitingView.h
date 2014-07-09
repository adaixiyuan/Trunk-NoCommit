//
//  WaitingView.h
//  OpenSesameDemo
//
//  Created by haibo on 11-12-8.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaitingView : UIView {
	CGImageRef alphaImage;
	
	NSTimer *timer;
	
	int drawHeight;
}

- (void)startLoading;
- (void)stopLoading;

@end
