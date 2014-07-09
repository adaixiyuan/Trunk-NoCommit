//
//  UIViewController+DaodaoWebVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DaodaoWebVC.h"

@implementation DaodaoWebVC

- (id)initWithURL:(NSString *)url {
    if (self = [super initWithTopImagePath:nil andTitle:@"酒店评论" style:_NavOnlyBackBtnStyle_]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
        webView.delegate = self;
        [self.view addSubview:webView];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [webView release];
    }
    
    return self;
}


#pragma mark - webView delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [webView endLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    [webView startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView endLoading];
}

@end
