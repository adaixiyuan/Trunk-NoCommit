//
//  GuaranteeIntroductionView.m
//  ElongClient
//
//  Created by 赵岩 on 13-9-11.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GuaranteeIntroductionView.h"

#define WIDTH (280)
#define DEFAULT_HEIGHT  (150)

@interface GuaranteeIntroductionView ()

@property (nonatomic, assign) UIView *contentView;
@property (nonatomic, assign) UIButton *cancelReqBtn;

@end

@implementation GuaranteeIntroductionView

- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        self.frame = delegate.window.bounds;
        
        UIColor* bgColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.8];
        [self setBackgroundColor:bgColor];
        [bgColor release];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width -  WIDTH) / 2, (self.frame.size.height - DEFAULT_HEIGHT) / 2, WIDTH, DEFAULT_HEIGHT)];
        _contentView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        UITapGestureRecognizer *gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonTapped:)] autorelease];
        [self addGestureRecognizer:gesture];
        [self addSubview:_contentView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 4, WIDTH - 32, 44)];
        titleLabel.text = @"艺龙消费者保障计划";
        titleLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(34, 14, 20, 25)];
        imageView.image = [UIImage noCacheImageNamed:@"guaranteeIcon.png"];
        [_contentView addSubview:imageView];
        [imageView release];
        
        NSUInteger posY = 55;
        
        UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake(40, posY, WIDTH - 32, 20)] autorelease];
        label1.font = [UIFont systemFontOfSize:13];
        label1.textColor = RGBACOLOR(93, 93, 93, 1);
        label1.backgroundColor = [UIColor clearColor];
        label1.text = @"●    到店无房赔首晚房费";
        [_contentView addSubview:label1];
        
        posY += 26;
        
        UILabel *label2 = [[[UILabel alloc] initWithFrame:CGRectMake(40, posY, WIDTH - 32, 20)] autorelease];
        label2.font = [UIFont systemFontOfSize:13];
        label2.textColor = RGBACOLOR(93, 93, 93, 1);
        label2.backgroundColor = [UIColor clearColor];
        label2.text = @"●    预订高于酒店门市价，3倍差额赔付";
        [_contentView addSubview:label2];
        
        posY += 26;
        
        UILabel *label3 = [[[UILabel alloc] initWithFrame:CGRectMake(40, posY, WIDTH - 32, 20)] autorelease];
        label3.font = [UIFont systemFontOfSize:13];
        label3.textColor = RGBACOLOR(93, 93, 93, 1);
        label3.backgroundColor = [UIColor clearColor];
        label3.text = @"●    7X24小时客服服务";
        [_contentView addSubview:label3];
        
        posY += 6;
        
        UILabel *secondTitle = [[UILabel alloc] initWithFrame:CGRectMake(117, posY, WIDTH - 32, 44)];
        secondTitle.text = @"国内酒店";
        secondTitle.textColor = RGBACOLOR(93, 93, 93, 1);
        secondTitle.textAlignment = NSTextAlignmentCenter;
        secondTitle.font = [UIFont systemFontOfSize:12];
        secondTitle.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:secondTitle];
        [secondTitle release];
        
        // 右上角取消按钮
		_cancelReqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_cancelReqBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
		[_cancelReqBtn addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		_cancelReqBtn.frame = CGRectMake(_contentView.frame.origin.x + WIDTH - 28, _contentView.frame.origin.y - 28, 57, 57);
		[self addSubview:_cancelReqBtn];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)cancelButtonTapped:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
