//
//  AlipayViewController.h
//  ElongClient
//
//  Created by Ivan.xu on 12-8-2.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElongBaseViewController.h"

@class AlipayViewController;

@protocol AlipayViewControllerDelegate <NSObject>

- (void)alipayDidPayed:(AlipayViewController *)controller;

@end

@interface AlipayViewController : ElongBaseViewController <UIWebViewDelegate> {
	UIWebView *mainWebView;
	NSURL *requestUrl;
	UIActivityIndicatorView *activityView;
	
	UIBarButtonItem *forwardItem;
	UIBarButtonItem *backItem;
	int count;
	BOOL isSuccess;
}

@property (nonatomic,retain) NSURL *requestUrl;
@property (nonatomic, assign) id<AlipayViewControllerDelegate> delegate;

-(void) forwardPage;
-(void) backPage;
-(void) refreshPage;
-(void)setBtnState;

@end
