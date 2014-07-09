//
//  LoadingView.h
//  TestLoading
//
//  Created by bin xing on 11-1-24.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaitingView;
@interface LoadingView : UIView {
@private
	CGRect alertFrame;
    HttpUtil *m_util;
	BOOL alertShowing;			// 警告框正被展示

	UIView *content;
    UIImageView *flashView;
    
    UIButton *cancelReqBtn;
}

@property (nonatomic, assign) int outTime;
@property (nonatomic, assign) BOOL loadHidden; 

+ (LoadingView *)sharedLoadingView;
- (void)showAlertMessage:(NSString *)message utils:(HttpUtil *)httpUtil;
- (void)showAlertMessageNoCancel;
- (void)hideAlertMessage;
@end