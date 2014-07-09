//
//  Notification.m
//  ElongClient
//
//  Created by WangHaibin on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Notification.h"
#import "AccountManager.h"
#import "NSString+URLEncoding.h"
#import "Utils.h"
#import "HomeViewController.h"
#import "WXApi.h"
#import "ShareTools.h"
#import "ElongURL.h"

@implementation Notification

-(void)dealloc{
	[myWebView release];
	[smallLoading release];
    [Notification setCurrentNotiObj:nil];
    if (notificationRequest) {
        [notificationRequest cancel];
        [notificationRequest release],notificationRequest = nil;
    }
	[super	dealloc];
}

//记录H5传过来的字典型字符串，以供中转返回给h5用
static Notification *notiObj = nil;
+(void)setCurrentNotiObj:(Notification *)obj{
    notiObj = obj;
}

+(Notification *)getCurrentNotiObj{
    return notiObj;
}

static NSMutableDictionary *h5WXInfoDict = nil;
+(void)setWXInfoDict:(NSDictionary *)dic{
    if(!h5WXInfoDict){
        h5WXInfoDict = [[NSMutableDictionary alloc] init];
    }
    [h5WXInfoDict removeAllObjects];
    [h5WXInfoDict addEntriesFromDictionary:dic];
}

+(NSDictionary *)h5WXInfoDict{
    return h5WXInfoDict;
}


- (void)back {
    if (self.navigationController.viewControllers.count == 2) {
        [PublicMethods closeSesameInView:self.navigationController.view];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadView {
	[super loadView];
	
	myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, MAINCONTENTHEIGHT)];
	myWebView.dataDetectorTypes	= UIDataDetectorTypeNone;
    [self.view addSubview:myWebView];
	
    
    // 请求加载参数
    AppConfigRequest *request = [AppConfigRequest shared];
    NSString *mpromotionurl = [request.config safeObjectForKey:@"mpromotionurl"];
    if (mpromotionurl) {
        [self notificationLoadURL:mpromotionurl];
    }else{
        if (notificationRequest) {
            [notificationRequest cancel];
            [notificationRequest release],notificationRequest = nil;
        }
        request.appKey = @"mpromotionurl";
        notificationRequest = [[HttpUtil alloc] init];
        [notificationRequest sendAsynchronousRequest:OTHER_SEARCH
                                         PostContent:[request getAppConfigRequest]
                                         CachePolicy:CachePolicyNone
                                            Delegate:self];
        
        
    }
}

-(void)updateUIWithFrame:(CGRect)aFrame{
    myWebView.frame  = aFrame;
}


- (void) notificationLoadURL:(NSString *)url{
    NSString *num = [[AccountManager instanse] phoneNo];
	if (!num) {
		num=@"";
	}
	NSString *osver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
	NSString *version = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:@"CFBundleVersion"];
    
    
	NSString *nurl=[NSString stringWithFormat:@"%@?ch=eliphone&uid=%@&num=%@&Version=%@&OsVersion=%@",url,[PublicMethods macaddress], num, version, osver];
    //NSString *nurl = @"http://m.trip.elong.com/";
//    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
//    if ([delegate.notistring  length] > 0) {
//        nurl = [NSString stringWithFormat:@"%@",delegate.notistring];
//        delegate.notistring = @"";
//    }

	[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[nurl URLDecodedString]]]];
	myWebView.scalesPageToFit = YES;
	myWebView.delegate=self;
	
}

-(void)shareWinXinWithContent:(NSDictionary *)content{
    if(![WXApi isWXAppInstalled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"您没有安装微信哟！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
   
    
    [Notification setCurrentNotiObj:self];  //用户回调跳转页面用
    [Notification setWXInfoDict:content];   //记录分享的数据，用于回调
    [ShareTools setShareTypeNameForWX:@"H5APPShareForWX"];  //来自h5的分享类型
    
    WXMediaMessage *aamessage = [WXMediaMessage message];
    NSString *title = [content safeObjectForKey:@"title"];
    if(title){
        aamessage.title = title;
    }
    NSString *desp = [content safeObjectForKey:@"content"];
    if(desp){    
        aamessage.description = desp;
    }
    NSString *logoUrl = [content safeObjectForKey:@"logourl"];
    if(logoUrl){
        [aamessage setThumbData:[NSData dataWithContentsOfURL:[NSURL URLWithString:logoUrl]]];
    }
    WXWebpageObject *webPage = [WXWebpageObject object];
    NSString *picUrl = [content safeObjectForKey:@"picurl"];
    if(picUrl){
        webPage.webpageUrl = picUrl;
    }
    aamessage.mediaObject = webPage;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = aamessage;
    req.scene = WXSceneTimeline;    //朋友圈
    [WXApi sendReq:req];
}

- (void) reloadWebView:(NSString *)urlStr{
    NSLog(@"reloadUrl:%@",urlStr);
    NSString *nurl = [NSString stringWithFormat:@"%@",urlStr];
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[nurl URLDecodedString]]]];
    
//    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
//    delegate.notistring = @"";
}

- (void)addLoadingView {
	if (!smallLoading) {
		smallLoading = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, MAINCONTENTHEIGHT/2-20, 50, 50)];
		[self.view addSubview:smallLoading];
	}
	
	[smallLoading startLoading];
}

- (void)removeLoadingView {
	[smallLoading stopLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return  NO;
    }
    NSLog(@"%@",request.URL);
    if ([[request.URL absoluteString] isEqualToString:@"app://hotel"]) {
        [PublicMethods closeSesameInView:self.navigationController.view];
        ElongClientAppDelegate *app = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        [app.startup performSelector:@selector(openModule:) withObject:[NSNumber numberWithInt:HomeHotelModule] afterDelay:0.6];
        return NO;
    }else if([[request.URL absoluteString] isEqualToString:@"app://index"]){
        [PublicMethods closeSesameInView:self.navigationController.view];
        return NO;
    }else if([[request.URL absoluteString] rangeOfString:@"h5app:"].length>0){
        NSLog(@"准备分享微信");
        NSLog(@"%@",request.URL);
        NSArray *receiveInfoArr = [[request.URL absoluteString] componentsSeparatedByString:@":"];
        if(receiveInfoArr.count>=2){
            NSString *functionName = [NSString stringWithFormat:@"%@()",[receiveInfoArr safeObjectAtIndex:1]];
            NSString *jsonstr = [myWebView stringByEvaluatingJavaScriptFromString:functionName];
            NSDictionary *dic = [jsonstr JSONValue];
            NSLog(@"JSONStr:%@",jsonstr);
            if(dic){
//                for(NSString *key in dic.allKeys){
//                    NSLog(@"%@---%@",key,[[dic safeObjectForKey:key] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//                }
                //解码
                NSMutableDictionary *decodeJsonDict = [[NSMutableDictionary alloc] init];
                for(NSString *key in dic.allKeys){
                    NSString *value = [dic safeObjectForKey:key];
                    [decodeJsonDict safeSetObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];
                }
                [self shareWinXinWithContent:decodeJsonDict];
                [decodeJsonDict release];
            }

        }

        return NO;
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


#pragma mark -
#pragma mark HttpUtilDelegate

-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root]) {
        
        return ;
    }
    
    if (!OBJECTISNULL([root objectForKey:@"AppValue"])) {
        NSString *mpromotionurl = [root objectForKey:@"AppValue"];
        AppConfigRequest *request = [AppConfigRequest shared];
        [request.config setObject:mpromotionurl forKey:@"mpromotionurl"];
        [self notificationLoadURL:mpromotionurl];
    }
    
}


@end
