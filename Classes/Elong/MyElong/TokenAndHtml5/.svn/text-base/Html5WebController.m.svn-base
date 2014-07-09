//
//  Html5WebController.m
//  ElongClient
//  
//
//  Created by 赵 海波 on 13-9-5.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "Html5WebController.h"

@interface Html5WebController ()

@end

@implementation Html5WebController


- (void)dealloc
{
    myWebView.delegate = nil;
	[smallLoading release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url FromType:(H5Type)type{
    self =  [self initWithTitle:title Html5Link:url];
    if(self){
        fromType = type;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url style:(NavBtnStyle )navStyle{
    self = [super initWithTopImagePath:nil andTitle:title style:navStyle];
    if (self){
        modifySuccess = NO;
        NSLog(@"%@", url);
        myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
        myWebView.delegate = self;
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.view addSubview:myWebView];
        [myWebView release];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url
{
    return [self initWithTitle:title Html5Link:url style:_NavNoTelStyle_];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)back
{
    [super back];
    
    switch (fromType) {
        case HOTEL_MODIFYORDER:
        {
            if (modifySuccess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ORDER_MODIFY object:nil];
            }
        }
            break;
        case HOTEL_FEEDBACK:
        {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTEL_FEEDBACK object:nil];
        }
            break;
        default:
            break;
    }

}


- (void)addLoadingView {
	if (!smallLoading) {
		smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, (MAINCONTENTHEIGHT - 50) / 2, 50, 50)];
		[self.view addSubview:smallLoading];
	}
	
	[smallLoading startLoading];
}

- (void)removeLoadingView {
	[smallLoading stopLoading];
}

#pragma mark - UIWebviewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@",[request.URL absoluteString]);
    if ([[request.URL absoluteString] hasPrefix:@"http://m.elong.com/Hotel/EditOrderComplete"])
    {
        // 进入h5的成功页面时，发送修改成功的通知
        modifySuccess = YES;
    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self addLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self removeLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[self removeLoadingView];
}

@end
