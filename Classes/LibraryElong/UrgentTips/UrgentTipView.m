//
//  UrgentTipView.m
//  ElongClient
//
//  Created by 赵 海波 on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "UrgentTipView.h"
#import "UrgentTipModel.h"
#import "ElongClientAppDelegate.h"
#import "HtmlViewController.h"

@interface UrgentTipView ()

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *tipLabel;
@property (nonatomic,retain) UIButton *tipButton;

@end

@implementation UrgentTipView

- (void)dealloc
{
    [_titleLabel release];
    [_tipLabel release];
    [_tipModel release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=RGBACOLOR(255, 248, 207, 1);
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, 21)];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:13]];
        self.titleLabel.textColor=RGBACOLOR(52, 52, 52, 1);
        self.titleLabel.text=@"温馨提示：";
        [self addSubview:self.titleLabel];
        
        //内容提示
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width-20, frame.size.height)];
        [self.tipLabel setBackgroundColor:[UIColor clearColor]];
        [self.tipLabel setLineBreakMode:UILineBreakModeCharacterWrap];
        [self.tipLabel setNumberOfLines:0];
        [self.tipLabel setFont:[UIFont systemFontOfSize:12]];
        self.tipLabel.textColor=RGBACOLOR(140, 140, 140, 1);
        [self addSubview:self.tipLabel];
        
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tipButton setFrame:frame];
        [self.tipButton addTarget:self action:@selector(goUrlLink:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.tipButton];
    }
    return self;
}

-(void)setTipModel:(UrgentTipModel *)tipModel{
    _tipModel = [tipModel retain];
    
    self.tipLabel.text = [NSString stringWithFormat:@"                  %@",tipModel.content];
    CGSize tipSize = [tipModel.content sizeWithFont:self.tipLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, INT_MAX)];

    self.frame = CGRectMake(0, 0, self.frame.size.width, tipSize.height+8);
    self.tipLabel.frame = CGRectMake(10, 0, self.frame.size.width-20, tipSize.height+8);
    self.tipButton.frame = CGRectMake(0, 0, self.frame.size.width, tipSize.height+8);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)goUrlLink:(id)sender{
    if(STRINGHASVALUE(self.tipModel.tipUrlString)){
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        HtmlViewController *urgentTipController = [[HtmlViewController alloc] initWithTitle:@"温馨提示" targetUrl:self.tipModel.tipUrlString style:_NavOnlyBackBtnStyle_];
        [appDelegate.navigationController pushViewController:urgentTipController animated:YES];
        [urgentTipController release];
    }
}

@end
