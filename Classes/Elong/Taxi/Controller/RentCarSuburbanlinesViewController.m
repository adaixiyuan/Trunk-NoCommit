//
//  RentCarSuburbanlinesViewController.m
//  ElongClient
//
//  Created by licheng on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentCarSuburbanlinesViewController.h"

@interface RentCarSuburbanlinesViewController ()

@end

@implementation RentCarSuburbanlinesViewController

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
    self = [super initWithTitle:@"城郊界限" style:NavBarBtnStyleOnlyBackBtn];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
    webview.scalesPageToFit = YES;
    webview.backgroundColor = [UIColor clearColor];
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

    NSString *htmlString = [self loadHTMLString];
    
    NSString *bundle = [[NSBundle mainBundle]bundlePath];
    NSURL *url = [NSURL fileURLWithPath:bundle];
    
    [webview loadHTMLString:htmlString baseURL:url];
    [self.view addSubview:webview];
    [webview release];
	// Do any additional setup after loading the view.
}

-(NSString *)loadHTMLString{
//    #F8F8F8
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"suburbanline" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return html;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
