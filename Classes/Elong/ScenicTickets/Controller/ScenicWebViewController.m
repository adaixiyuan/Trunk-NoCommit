//
//  ScenicWebViewController.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicWebViewController.h"

@interface ScenicWebViewController ()

@end

@implementation ScenicWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    self.webHtml = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
    webview.backgroundColor = [UIColor clearColor];
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
    
    NSString *html = [NSString stringWithFormat:@"<html><head></head><body>%@</body></html>",self.webHtml];
    [webview loadHTMLString:html baseURL:nil];
    [self.view addSubview:webview];
    [webview release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
