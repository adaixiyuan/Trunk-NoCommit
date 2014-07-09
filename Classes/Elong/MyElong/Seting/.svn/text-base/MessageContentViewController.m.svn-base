//
//  MessageContentViewController.m
//  ElongClient
//
//  Created by Ivan.xu on 14-1-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "MessageContentViewController.h"
#import "HomeAdNavi.h"

@interface MessageContentViewController ()

@end

@implementation MessageContentViewController
- (void) dealloc{
    [super dealloc];
}

-(id)initWithEMessage:(EMessage *)message{
    self = [super initWithTitle:@"消息内容" style:_NavOnlyBackBtnStyle_];
    CGSize size = [message.body sizeWithFont:FONT_16 constrainedToSize:CGSizeMake(300, 10000)];
    
    UIScrollView *scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64)];
    [self.view addSubview:scrollView_];
    [scrollView_ release];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, size.height)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = FONT_16;
    _titleLabel.text = message.body;
    [scrollView_ addSubview:_titleLabel];
    _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    _titleLabel.numberOfLines = 0;
    [_titleLabel release];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25+size.height, 300, 20)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = FONT_11;
    _timeLabel.text = [TimeUtils displayDateWithNSDate:message.time formatter:@"yyyy-MM-dd"];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [scrollView_ addSubview:_timeLabel];
    [_timeLabel release];
    
    scrollView_.contentSize = CGSizeMake(320, 25+size.height);
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
