//
//  HomeAdWebViewController.m
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HomeAdWebViewController.h"
#import "JHotelDetail.h"
#import "HotelPostManager.h"
#import "HotelPromotionInfoRequest.h"


#define kHotelDetail 1003

@interface HomeAdWebViewController (){
@private
    UIBarButtonItem *backItem;
    UIBarButtonItem *forwardItem;
    UIBarButtonItem *refreshItem;
    UIToolbar *tool;
    HomeAdNavi *adNavi;
}

@end

@implementation HomeAdWebViewController

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    myWebView.delegate = nil;
	[smallLoading release];
    
    hotelOderWebToAppLogic.delegate=nil;
    [hotelOderWebToAppLogic release];
    
    grouponOrderWebToAppLogic.delegate = nil;
    [grouponOrderWebToAppLogic release];
    
    SFRelease(hotelOrderQueryString);
    SFRelease(grouponOrderQueryString);
    SFRelease(adNavi);
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithTitle:(NSString *)title targetUrl:(NSString *)url style:(NavBtnStyle )navStyle{
    self = [super initWithTopImagePath:nil andTitle:title style:navStyle];
    if (self){
//        url=@"http://ean.elong.com/test.htm";
        NSLog(@"%@", url);
        
        hotelOderWebToAppLogic = [[HotelOrderWebToAppLogic alloc] init];
        hotelOderWebToAppLogic.delegate=self;
        
        grouponOrderWebToAppLogic = [[GrouponOrderWebToAppLogic alloc] init];
        grouponOrderWebToAppLogic.delegate = self;
        
        myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
        myWebView.delegate = self;
        myWebView.scalesPageToFit = YES;
        [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.view addSubview:myWebView];
        [myWebView release];
    }
    return self;
}

- (void) setIsNavBarShow:(BOOL)isNavBarShow{
    _isNavBarShow = isNavBarShow;
    if (self.isNavBarShow) {
        if (!tool) {
            [self makeNavBottomBar];
        }
    }else{
        if (tool) {
            [tool removeFromSuperview];
        }
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    adNavi = [[HomeAdNavi alloc] init];
    adNavi.delegate = self;
}

- (void) makeNavBottomBar {
    myWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44);
    
    // 构造下方得toolbar
    tool = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 20 - 44, SCREEN_WIDTH, 44)];
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
    
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage noCacheImageNamed:@"webrefresh_btn.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    refreshBtn.showsTouchWhenHighlighted = YES;
    refreshBtn.frame = CGRectMake(0, 0, 50, 44);
    refreshItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
    [itemsArray addObject:refreshItem];
    [refreshItem release];
    
    tool.items = itemsArray;
    [self.view addSubview:tool];
    [tool release];
}


- (void)webGoBack {
    [myWebView goBack];
}


- (void)webGoForward {
    [myWebView goForward];
}


- (void)refresh {
    [myWebView reload];
}


//- (void)back{
//    //super backhome];
//}


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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    // 
    if ([adNavi adNaviJumpUrl:url active:self.active]) {
        return NO;
    }
    
    NSString *queryString=request.URL.query;
    NSLog(@"%@",queryString);
    
    
    // 酒店订单填写
    if (![self couldToHotelFillOrder:queryString]){
        return NO;
    }
    // 团购订单填写
    if (![self couldToGrouponFillOrder:queryString]) {
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self addLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[self removeLoadingView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self removeLoadingView];
    
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

#pragma mark --WebToAppLogicProtocol delegate
-(void) webToAppLogicIsComplicated:(WebToAppBaseLogic *) logic
{
    if (logic==hotelOderWebToAppLogic){
        [self removeLoadingView];
        [self performSelector:@selector(clearHotelOrderString) withObject:nil afterDelay:2];
    }else if(logic == grouponOrderWebToAppLogic){
        [self removeLoadingView];
        [self performSelector:@selector(clearGrouponOrderString) withObject:nil afterDelay:2];
    }
}



-(void) clearHotelOrderString
{
    NSLog(@"clearHotelOrderString");
    SFRelease(hotelOrderQueryString);
}

- (void) clearGrouponOrderString{
    NSLog(@"clearGrouponOrderString");
    SFRelease(grouponOrderQueryString);
}

//测试跳转到酒店订单填写页(返回是否跳转)
-(BOOL) couldToHotelFillOrder:(NSString *) queryString
{
//    queryString = @"hotelid=90040206&roomid=0004&rateplanid=371224&checkindate=20140509&checkoutdate=20140510&app=hotelorder&ref=elongapp";
    
    if (!STRINGHASVALUE(queryString))
    {
        return YES;
    }

    if ([hotelOrderQueryString isEqualToString:queryString])
    {
        return NO;
    }
    
    if ([hotelOderWebToAppLogic convertQueryStringToDictionary:queryString])
    {
        if ([hotelOderWebToAppLogic isCouldhanle])
        {
            [self addLoadingView];
            
            if (hotelOrderQueryString)
            {
                SFRelease(hotelOrderQueryString);
            }
            
            hotelOrderQueryString=[queryString retain];
            
            [hotelOderWebToAppLogic hanldeData];
            return NO;
        }
    }
    
    return YES;
}

// 测试跳转到团购订单填写页
- (BOOL) couldToGrouponFillOrder:(NSString *) queryString{
    // queryString = @"ref=mbaidu&prodid=110651&app=tuanorder";
    if (!STRINGHASVALUE(queryString)) {
        return YES;
    }
    
    if ([grouponOrderQueryString isEqualToString:queryString]) {
        return NO;
    }
    
    if ([grouponOrderWebToAppLogic convertQueryStringToDictionary:queryString]) {
        if ([grouponOrderWebToAppLogic isCouldhanle]) {
            [self addLoadingView];
            if (grouponOrderQueryString) {
                SFRelease(grouponOrderQueryString);
            }
            grouponOrderQueryString = [queryString retain];
            [grouponOrderWebToAppLogic hanldeData];
            return NO;
        }
    }
    return YES;
}
@end
