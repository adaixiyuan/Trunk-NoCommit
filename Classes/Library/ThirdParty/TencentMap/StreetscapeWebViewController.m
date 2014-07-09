//
//  StreetscapeViewController.m
//  ElongClient
//
//  Created by Dawn on 14-6-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "StreetscapeWebViewController.h"

@interface StreetscapeWebViewController ()

@end

@implementation StreetscapeWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT)];
    [self.view addSubview:webView];
    [webView release];
    //webView.backgroundColor = [UIColor redColor];
    
    NSString *html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Streetscape" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    html = [html stringByReplacingOccurrencesOfString:@"{key}" withString:TENCENTMAP_KEY];
    html = [html stringByReplacingOccurrencesOfString:@"{lat}" withString:[NSString stringWithFormat:@"%f",self.lat]];
    html = [html stringByReplacingOccurrencesOfString:@"{lng}" withString:[NSString stringWithFormat:@"%f",self.lng]];
    html = [html stringByReplacingOccurrencesOfString:@"{width}" withString:[NSString stringWithFormat:@"%.0f",SCREEN_WIDTH]];
    html = [html stringByReplacingOccurrencesOfString:@"{height}" withString:[NSString stringWithFormat:@"%.0f",MAINCONTENTHEIGHT]];
    
    [webView loadHTMLString:html baseURL:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
