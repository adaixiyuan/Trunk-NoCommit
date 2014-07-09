//
//  WBLoginViewController.h
//  Elong_iPad
//
//  Created by Wang Shuguang on 12-8-9.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElongBaseViewController.h"

@interface WBLoginViewController : ElongBaseViewController<UIWebViewDelegate> {
    UIWebView *_webView;
    NSURL *loadingUrl;
    NSString *fromType;
    NSString *loginType;
    UIActivityIndicatorView *indicatorView;
}
-(id)initwithUrl:(NSURL *)url fromType:(NSString *)type loginType:(NSString *)type_1;
-(void)prensentTencentSendPage;
-(void)presentSinaSendPage;

@property (nonatomic,retain) UIWebView *_webView;
@property(nonatomic,retain) NSURL *loadingUrl;
@property(nonatomic,copy) NSString *fromType;
@property(nonatomic,copy) NSString *loginType;

@end
