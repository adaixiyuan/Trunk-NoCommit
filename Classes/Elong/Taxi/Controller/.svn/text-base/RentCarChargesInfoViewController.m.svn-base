//
//  RentCarChargesInfoViewController.m
//  ElongClient
//
//  Created by licheng on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentCarChargesInfoViewController.h"
#import "PickupModel.h"
#import "RentCarExpensesModel.h"
#import "RentCarSuburbanlinesViewController.h"
#import "LzssUncompress.h"
@interface RentCarChargesInfoViewController ()<UIWebViewDelegate>
@property(nonatomic,retain)NSMutableArray *typeArray;
@end

@implementation RentCarChargesInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init
{
    self = [super initWithTitle:@"资费说明" style:NavBarBtnStyleOnlyBackBtn];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
    webview.backgroundColor = [UIColor clearColor];
    webview.delegate = self;
    webview.scalesPageToFit = YES;
    
    for (UIView *aView in [webview subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            for (UIView *shadowView in aView.subviews)
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                    
                {
                    shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                }
            }
        }
    }
    
    NSString *bundle = [[NSBundle mainBundle]bundlePath];
    NSURL *url =  [NSURL fileURLWithPath:bundle];
    [webview loadHTMLString:_fullhtmlString baseURL:url];
    [self.view addSubview:webview];
    [webview release];

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *realURL = [request.URL absoluteString];
    realURL=[realURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];    
    NSLog(@"aaa==%@",realURL);

    if ([realURL hasPrefix:@"http://lookbuslimit"]){
        
        RentCarSuburbanlinesViewController *suberbanLin = newObject(RentCarSuburbanlinesViewController);
        [self.navigationController pushViewController:suberbanLin animated:YES];
        [suberbanLin release];
        
        return NO;
    }
        return YES;
}

#pragma mark -
#pragma mark 网络层

-(void)dealloc{
    
    setFree(_fullhtmlString);
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
