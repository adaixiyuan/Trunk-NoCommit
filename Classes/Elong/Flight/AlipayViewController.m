    //
//  AlipayViewController.m
//  ElongClient
//
//  Created by Ivan.xu on 12-8-2.
//  Copyright 2012 elong. All rights reserved.
//

#import "AlipayViewController.h"
#import "PublicMethods.h"
#import "FlightOrderHistoryDetail.h"
#import "FlightOrderSuccess.h"
#import "GrouponSuccessController.h"
#import "GrouponOrderHistoryController.h"


@implementation AlipayViewController

@synthesize requestUrl;

- (id)init {
    if (self = [super initWithTitle:@"支付宝支付" style:_NavOnlyBackBtnStyle_])
    {
        self.navigationItem.hidesBackButton = YES;
        
        UIBarButtonItem *cancelBarItem = [UIBarButtonItem navBarLeftButtonItemWithTitle:@"取消" Target:self Action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelBarItem;
    }
	
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	isSuccess = NO;
	self.view.backgroundColor = [UIColor whiteColor];

		
	mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64-40)];
	mainWebView.delegate = self;
	[mainWebView loadRequest:[NSURLRequest requestWithURL:requestUrl]];
	[self.view addSubview:mainWebView];
	[self.view sendSubviewToBack:mainWebView];
	[mainWebView release];
	
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 40, SCREEN_WIDTH, 40)];
	[toolBar setBarStyle:UIBarStyleBlackTranslucent];
	UIBarButtonItem *sepratorItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
	sepratorItem.enabled = NO;
	forwardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next.png"] style:UIBarButtonItemStylePlain target:self action:@selector(forwardPage)];
	forwardItem.enabled = NO;
	UIBarButtonItem *sepratorItem_1 = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
	sepratorItem_1.enabled = NO;
	backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(backPage)];
	backItem.enabled = NO;
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshPage)];
	NSArray *itemArray = [NSArray arrayWithObjects:sepratorItem,backItem,sepratorItem_1,forwardItem,flexItem,refreshItem,nil];
	[toolBar setItems:itemArray]; 
	[forwardItem release];
	[backItem release];
	[flexItem release];
	[refreshItem release];
	[sepratorItem release];
	[sepratorItem_1 release];

	[self.view addSubview:toolBar];
	[toolBar release];
	
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityView setFrame:CGRectMake(240, 430, 20, 20)];
	[self.view addSubview:activityView];
	[activityView release];
    [super viewDidLoad];
}

- (void)dealloc {
	[requestUrl release];
    [super dealloc];
}

-(void) forwardPage{
	[mainWebView goForward];
	[self setBtnState];
}

-(void) backPage{
	[mainWebView goBack];
	[self setBtnState];

}

-(void) refreshPage{
	[mainWebView reload];
}

-(void)setBtnState{
	if([mainWebView canGoBack]){
		backItem.enabled = YES;
	}else {
		backItem.enabled = NO;
		
	}
	
	if([mainWebView canGoForward]){
		forwardItem.enabled = YES;
	}else {
		forwardItem.enabled = NO;
	}
}

-(void)cancel{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark UIWebView delegate
-(void) webViewDidStartLoad:(UIWebView *)webView{
	//start load
	[activityView startAnimating];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
	//did finish
	[activityView stopAnimating];
	[self setBtnState];

}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	//fail load
	[activityView stopAnimating];
	[self setBtnState];

}

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	[self setBtnState];

	count++;
	NSString *url_Str = [[[request URL] absoluteString] lowercaseString];
	NSLog(@"begin产生Url地址为%d,%@：%@",count,[NSDate date],url_Str);

	NSRange range = [url_Str rangeOfString:@"elongiphone://wappay/?"];
    
	if(range.length>0){
		NSRange range = [url_Str rangeOfString:@"elongiphone://wappay/?"];
		NSString *subStr = [url_Str substringFromIndex:range.location+range.length];
		NSArray *array = [subStr componentsSeparatedByString:@"&"];
		NSArray *array_1 = nil;
		for(NSString *str in array){
			if([str rangeOfString:@"result"].length>0){
				array_1 = [str componentsSeparatedByString:@"="];
				break;
			}
		}
		NSString *status = @"";
		if([array_1 count]==2){
			status = [array_1 safeObjectAtIndex:1];
		}
		NSLog(@"status :%@",status);
		
		if([status isEqualToString:@"success"]){
            // 发送支付成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ALIPAY_SUCCESS object:nil];
            
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:@"支付成功" 
																delegate:nil 
													   cancelButtonTitle:@"确定" 
													   otherButtonTitles:nil];
			[alertView show];
			[alertView release];
			isSuccess = YES;
            if (IOSVersion_7) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self dismissModalViewControllerAnimated:YES];
            }
            
            if (self.delegate) {
                [self.delegate alipayDidPayed:self];
            }
			
			FlightOrderSuccess *currentObj =  [FlightOrderSuccess currentInstance];
			
			if(currentObj !=NULL ){
				[currentObj paySuccess];
			}
            
			FlightOrderHistoryDetail *flightOrderDetail = [FlightOrderHistoryDetail instance];
			if(flightOrderDetail !=NULL ){
				[flightOrderDetail paySuccess];
			}
			
			GrouponSuccessController *grouponSuccessObj = [GrouponSuccessController currentInstance];
			if(grouponSuccessObj!=NULL){
				NSLog(@"团购safe成功页执行");
				[grouponSuccessObj paySuccess];
			}
			GrouponOrderHistoryController *grouponOrderObj = [GrouponOrderHistoryController currentInstance];
			if(grouponOrderObj!=NULL){
				NSLog(@"团购safe订单页执行");
				[grouponOrderObj paySuccess];
			}
			
		}
        

	}
    else if ([url_Str rangeOfString:@"cashierreturnmiddlepage.htm?tradeno="].length >0) {
        // 发送支付成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ALIPAY_SUCCESS object:nil];
        
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"支付成功"
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        isSuccess = YES;
        
        if (IOSVersion_7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
        
        if (self.delegate) {
            [self.delegate alipayDidPayed:self];
        }
        
        return NO;
    }
    else if ([url_Str rangeOfString:@"asyn_payment_result.htm"].length > 0)
    {
        // 发送支付成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ALIPAY_SUCCESS object:nil];
        isSuccess = YES;
        if (IOSVersion_7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
        
        if (self.delegate) {
            [self.delegate alipayDidPayed:self];
        }
        
        return NO;
    }
	
	return YES;
}

@end
