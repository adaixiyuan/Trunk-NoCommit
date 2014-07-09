//
//  TrainIdentifyiCodeView.m
//  ElongClient
//  火车票验证码view
//  Created by garin on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TrainIdentifyiCodeView.h"

@implementation TrainIdentifyiCodeView

- (void) dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        if (self)
        {
            [UIView setAnimationsEnabled:NO];
            
            self.backgroundColor=[UIColor whiteColor];
            
            // title
            _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,0, 150, 44)];
            _titleLbl.font = [UIFont systemFontOfSize:16.0f];
            _titleLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
            _titleLbl.backgroundColor = [UIColor clearColor];
            [self addSubview:_titleLbl];
            [_titleLbl release];
            
            // 文本框
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(70 + 12, 0, 115, 44)];
            _textField.borderStyle = UITextBorderStyleNone;
            _textField.font = [UIFont systemFontOfSize:16.0f];
            _textField.textAlignment = NSTextAlignmentLeft;
            _textField.returnKeyType=UIReturnKeyDone;
            _textField.textColor = RGBACOLOR(52, 52, 52, 1);
            _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self addSubview:_textField];
            [_textField release];
            
            //验证码图片
            //RoundCornerView
            _checkCodeImageView = [[RoundCornerView alloc] initWithFrame:CGRectMake(203, 4, 70, 37)];
            [self addSubview:_checkCodeImageView];
            [_checkCodeImageView release];
            
            //checkCodeIndicatorView
            _checkCodeIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [_checkCodeImageView addSubview:_checkCodeIndicatorView];
            [_checkCodeIndicatorView setCenter:CGPointMake(_checkCodeImageView.frame.size.width/2, _checkCodeImageView.frame.size.height/2)];
            [_checkCodeIndicatorView release];
            
            // 按钮
            _getIdentifyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_getIdentifyCodeBtn setImage:[UIImage noCacheImageNamed:@"forgetPwd_fresh.png"] forState:UIControlStateNormal];
            [_getIdentifyCodeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 12, 10, 13)];
            [self addSubview:_getIdentifyCodeBtn];
            _getIdentifyCodeBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
            
            //上分割线
            _topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
            _topLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
            _topLine.backgroundColor = [UIColor clearColor];
            [self addSubview:_topLine];
            [_topLine release];
            
            //竖分割线
            _dashView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, SCREEN_SCALE, 44)];
            _dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
            [self addSubview:_dashView];
            [_dashView release];
            
            //下分割线
            _buttomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
            _buttomLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
            _buttomLine.backgroundColor = [UIColor clearColor];
            [self addSubview:_buttomLine];
            [_buttomLine release];
            
            [UIView setAnimationsEnabled:YES];
        }
    }
    return self;
}


// 设置左侧标题
- (void) setTitle:(NSString *)title
{
    _titleLbl.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
