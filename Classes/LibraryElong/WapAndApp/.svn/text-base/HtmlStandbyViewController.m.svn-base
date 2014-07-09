//
//  HtmlStandbyViewController.m
//  ElongClient
//
//  Created by 赵 海波 on 13-1-14.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HtmlStandbyViewController.h"
#import "HotelSearch.h"

@interface HtmlStandbyViewController ()

@end

@implementation HtmlStandbyViewController

- (id)initWithHotelOrder {
    if (self = [super init]) {
        [self addWebViewWithURL:@"http://m.elong.com/hotel"];
        [self performSelector:@selector(makeUIview) withObject:nil afterDelay:0.];
    }
    
    return self;
}

- (id)initWithHotelOrderwithHotelName:(NSString* )hotelname
{
    if (self = [super init]) {
        NSString *url = [NSString stringWithFormat:@"http://m.elong.com/hotel?keywords=%@",hotelname];
        [self addWebViewWithURL:url];
        [self performSelector:@selector(makeUIview) withObject:nil afterDelay:0.];
    }
    return self;
}

- (id)initWithFlightOrder {
    return self;
}


- (id)initWithGrouponOrder {
    if (self = [super init]) {
        [self addWebViewWithURL:@"http://m.elong.com/tuan"];
        [self performSelector:@selector(makeUIview) withObject:nil afterDelay:0.];
    }
    
    return self;
}


- (void)makeUIview {
    self.navigationController.navigationBarHidden = YES;
    
    // 构造下方得toolbar
    UIToolbar *tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 20, SCREEN_WIDTH, 44)];
    tool.barStyle = UIBarStyleBlack;
    tool.translucent = YES;
    
    NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:2];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage noCacheImageNamed:@"goback.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(webGoBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.showsTouchWhenHighlighted = YES;
    backBtn.frame = CGRectMake(0, 0, 50, 44);
    backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    backItem.enabled = NO;
    [itemsArray addObject:backItem];
    [backItem release];
    
    UIButton *forwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forwardBtn setImage:[UIImage noCacheImageNamed:@"goforward.png"] forState:UIControlStateNormal];
    [forwardBtn addTarget:self action:@selector(webGoForward) forControlEvents:UIControlEventTouchUpInside];
    forwardBtn.showsTouchWhenHighlighted = YES;
    forwardBtn.frame = CGRectMake(0, 0, 50, 44);
    forwardItem = [[UIBarButtonItem alloc] initWithCustomView:forwardBtn];
    forwardItem.enabled = NO;
    [itemsArray addObject:forwardItem];
    [forwardItem release];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexItem];
    [flexItem release];
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [itemsArray addObject:refreshItem];
    [refreshItem release];
    
    tool.items = itemsArray;
    [self.view addSubview:tool];
    [tool release];
}


- (void)webGoBack {
    [web goBack];
}


- (void)webGoForward {
    [web goForward];
}


- (void)refresh {
    [web reload];
}


- (void)addWebViewWithURL:(NSString *)url {
    CGRect rect = self.view.bounds;
    rect.size.height -= 44;
    
    web = [[UIWebView alloc] initWithFrame:rect];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    web.delegate = self;
    [self.view addSubview:web];
    [web release];
}


- (void)addLoadingView {
	if (!smallLoading) {
		smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, MAINCONTENTHEIGHT/2-20, 50, 50)];
		[self.view addSubview:smallLoading];
        [smallLoading startLoading];
	}
}


- (void)removeLoadingView {
	[smallLoading stopLoading];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self addLoadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self removeLoadingView];
    
    if ([webView canGoBack]) {
        backItem.enabled = YES;
    }
    else {
        backItem.enabled = NO;
    }
    
    if ([webView canGoForward]) {
        forwardItem.enabled = YES;
    }
    else {
        forwardItem.enabled = NO;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[self removeLoadingView];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] absoluteString] isEqualToString:@"http://m.elong.com/"]) {
        [self backhome];
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [smallLoading release];
    [super dealloc];
}

@end
