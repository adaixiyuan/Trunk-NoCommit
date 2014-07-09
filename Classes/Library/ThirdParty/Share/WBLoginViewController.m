    //
//  WBLoginViewController.m
//  Elong_iPad
//
//  Created by Wang Shuguang on 12-8-9.
//  Copyright 2012 elong. All rights reserved.
//

#import "WBLoginViewController.h"
#import "ShareKit.h"
#import "WBSendViewController.h"
#import "ShareTools.h"

@implementation WBLoginViewController
@synthesize _webView;
@synthesize loadingUrl;
@synthesize fromType;
@synthesize loginType;

-(id)initwithUrl:(NSURL *)url fromType:(NSString *)type  loginType:(NSString *)type_1{
    self = [super initWithTitle:@"微博分享" style:NavBarBtnStyleOnlyBackBtn];
    if(self){
        self.loadingUrl = url;
        self.fromType = type;
        self.loginType = type_1;
        self.navigationItem.hidesBackButton  = YES;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor redColor];
    //初始化WebView实例
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.loadingUrl];
    [_webView loadRequest:urlRequest];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[indicatorView setCenter:CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64)/2)];
	[self.view addSubview:indicatorView];
	[indicatorView release];
    
    UIBarButtonItem *cancelBarItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(cancelPage)];
    self.navigationItem.leftBarButtonItem = cancelBarItem;
}

#pragma mark - general methods
-(void)cancelPage{
	[_webView resignFirstResponder];
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void) startLoading{
	[indicatorView startAnimating];
}

- (void) stopLoading{
	[indicatorView stopAnimating];
}

-(void)prensentTencentSendPage{
    if([loginType isEqualToString:@"login"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginTencentSuccess" object:nil];
        if (IOSVersion_7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
    }else if([loginType isEqualToString:@"send"]){
        WBSendViewController *sendVC = [[WBSendViewController alloc] init];
        sendVC.weiboStyle = Tencent;
        //分享信息
        ShareTools *shareTools = [ShareTools shared];
        [sendVC setImageBox:shareTools.hotelImage];
        [sendVC setContent:shareTools.weiBoContent];
        
        [self.navigationController pushViewController:sendVC animated:YES];
        [sendVC release];
    }
}

-(void)presentSinaSendPage{
    if([loginType isEqualToString:@"login"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSinaSuccess" object:nil];
        if (IOSVersion_7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
    }else  if([loginType isEqualToString:@"send"]){
        WBSendViewController *sendVC = [[WBSendViewController alloc] init];
        sendVC.weiboStyle = Sina;
        //分享信息
        ShareTools *shareTools = [ShareTools shared];
        [sendVC setImageBox:shareTools.hotelImage];
        [sendVC setContent:shareTools.weiBoContent];
        
        [self.navigationController pushViewController:sendVC animated:YES];
        [sendVC release];
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [loadingUrl release];
    [fromType release];
    [loginType release];
    [_webView release];
    [super dealloc];
}


#pragma mark - UIWebView delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = [request.URL absoluteString];
    
    if([fromType isEqualToString:@"TENCENT"]){
        //来自腾讯微博
        NSRange range = [urlString rangeOfString:@"access_token="];
        if(range.location != NSNotFound){
            NSString *access_token = [[ShareKit instance] getStringFromUrl:urlString forNeedKey:@"access_token="];
            NSString *open_id = [[ShareKit instance] getStringFromUrl:urlString forNeedKey:@"openid="];
            NSString *open_key = [[ShareKit instance] getStringFromUrl:urlString forNeedKey:@"openkey="];
            NSString *expire_in = [[ShareKit instance] getStringFromUrl:urlString forNeedKey:@"expires_in="];
            
            if ((access_token == (NSString *) [NSNull null]) || (access_token.length == 0)
                || (open_id == (NSString *) [NSNull null]) || (open_id.length == 0)
                || (open_key == (NSString *) [NSNull null]) || (open_key.length == 0)) {
                //[_OpenSdkOauth oauthDidFail:InWebView success:YES netNotWork:NO];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"腾讯微博授权失败，请重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
            }else{
                //验证成功 ，记录获取到的用户信息
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:access_token,@"accessToken",open_id,@"openId",open_key,@"openKey",expire_in,@"expireIn", nil];
                [[ShareKit instance] saveTencentAuthInfo:dict];
                
                //其它操作
                [self prensentTencentSendPage];
            }
            return  NO;
        }
        
    }
    
    if([fromType isEqualToString:@"SINA"]){
        //来自新浪微博
        NSRange start = [urlString rangeOfString:@"code="];
        if(start.location != NSNotFound){
            NSString *code = [[request.URL query] substringWithRange:NSMakeRange([[request.URL query] length]-32, 32)];
            
            if([[ShareKit instance] startSinaAccessWithVerifier_V2:code]){
                //其它操作
                [self presentSinaSendPage];
            }else{
                //验证失败
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"新浪微博授权失败，请重试" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];

                if (IOSVersion_7) {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.navigationController dismissModalViewControllerAnimated:YES];
                }
            }
        }
        
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)aWebView{
	if (![indicatorView isAnimating]) {
		[indicatorView startAnimating];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error{
    [indicatorView stopAnimating];
}



@end
