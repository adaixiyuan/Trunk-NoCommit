//
//  TrainTicketRefundCheckView.m
//  ElongClient
//
//  Created by cglw on 13-11-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainTicketRefundCheckView.h"
#import "TrainOrderDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"

@implementation TrainTicketRefundCheckView

- (void)dealloc
{
    self.trainOrderDetailViewController = nil;
    self.markView = nil;
    self.ticketInfoView = nil;
    self.closeButton = nil;
//    self.verificationCodeLabel = nil;
    self.reloadButton = nil;
    self.checkCodeView = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithViewController:(TrainOrderDetailViewController *)viewController frame:(CGRect)frame
{
    self.trainOrderDetailViewController = viewController;
    //    self = [super initWithFrame:frame];
    if (self = [super init]) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        // markview
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        self.markView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
        _markView.backgroundColor = [UIColor whiteColor];
        _markView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
        [window addSubview:_markView];

        // Ticket info view.
        self.ticketInfoView = [[[UIView alloc] initWithFrame:frame] autorelease];
        _ticketInfoView.backgroundColor = RGBACOLOR(246, 246, 246, 1);
        _ticketInfoView.alpha = 0.0f;
        
        // Title.
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 15.0f, 120.0f, 20.0f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.text = @"退票申请";
        [_ticketInfoView addSubview:titleLabel];
        [titleLabel release];
        
        // Ticket.
        UIView *ticketView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, frame.size.width, 92)];
        ticketView.backgroundColor = [UIColor whiteColor];
        
        [ticketView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, frame.size.width, SCREEN_SCALE)]];
        
        UILabel *verificationCodeStaticLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0, 60.0f, 45)];
        verificationCodeStaticLabel.backgroundColor = [UIColor clearColor];
        verificationCodeStaticLabel.font = [UIFont systemFontOfSize:15.0f];
        verificationCodeStaticLabel.text = @"验证码:";
        [ticketView addSubview:verificationCodeStaticLabel];
        [verificationCodeStaticLabel release];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0f + 60.0f + 5.0f, 14.0f, 58.0f, 18.0f)];
        tempImageView.image = [UIImage imageWithData:((TrainOrderDetailViewController *)_trainOrderDetailViewController).checkCodeData];
        self.checkCodeView = tempImageView;
        [ticketView addSubview:tempImageView];
        [tempImageView release];
        
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tempButton.frame = CGRectMake(frame.size.width-44, 0, 44, 44);
        [tempButton setImage:[UIImage imageNamed:@"forgetPwd_fresh"] forState:UIControlStateNormal];
        [tempButton setImageEdgeInsets:UIEdgeInsetsMake(10, 12, 10, 13)];
        [tempButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        [ticketView addSubview:tempButton];
        self.reloadButton = tempButton;
        // Dash imageview.
        UIImageView *sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-45, 2, SCREEN_SCALE, 41)];
        sepLine.image = [UIImage imageNamed:@"dashed.png"];
        [ticketView addSubview:sepLine];
        [sepLine release];
        
        [ticketView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 45 - SCREEN_SCALE, frame.size.width, SCREEN_SCALE)]];
        
        UITextField *tempTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 46.0f, 238.0f, 45.0f)];
        tempTextField.delegate = self;
        tempTextField.placeholder = @"请输入验证码";
        tempTextField.font = FONT_15;
        tempTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tempTextField.returnKeyType = UIReturnKeyDone;
        [ticketView addSubview:tempTextField];
        self.verificationCodeTextField = tempTextField;
        [tempTextField release];
        
        [_ticketInfoView addSubview:ticketView];
        [ticketView release];
        
        [ticketView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 91, frame.size.width, SCREEN_SCALE)]];

        // Next step button.
        UIButton *nextButton =  [UIButton yellowWhitebuttonWithTitle:@"下一步"
                                                              Target:self
                                                              Action:@selector(next:)
                                                               Frame:CGRectMake(frame.size.width/2-70, frame.size.height-60, 140, 40)];
        [_ticketInfoView addSubview:nextButton];
        
        [_markView addSubview:_ticketInfoView];
        
        
        // 附加
        // 关闭按钮
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        [window addSubview:_closeButton];
        [_closeButton addTarget:self action:@selector(closeTicketRefundView:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.alpha = 0.0;
        _closeButton.frame = CGRectMake(frame.size.width + 25.0f - 57.0f / 2, frame.origin.y - 28.0f, 57.0f, 57.0f);
        [_markView addSubview:_closeButton];
//        [_markView addSubview:coverView];
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailMarkSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        [_markView addGestureRecognizer:singleTap];
        [singleTap release];
        
        // 动画开始整
        [UIView animateWithDuration:0.3f animations:^{
            _ticketInfoView.alpha = 1.0f;
            _closeButton.alpha = 1.0f;
        } completion:^(BOOL finished) {
        }];
    }
    return self;
}

- (void)closeTicketRefundView:(id)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        _ticketInfoView.alpha = 0.0f;
        _closeButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_markView removeFromSuperview];
        [(TrainOrderDetailViewController *)_trainOrderDetailViewController releaseTicketRefundCheckView];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != _markView) { // accept only touchs on superview, not accept touchs on subviews
        return NO;
    }
    
    return YES;
//    if ([touch.view isDescendantOfView:_ticketInfoView])
//        return NO;
}

- (void)detailMarkSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    [self closeTicketRefundView:nil];
}

- (void)next:(id)sender
{
    if (STRINGHASVALUE(_verificationCodeTextField.text)) {
        [UIView animateWithDuration:0.5f animations:^{
            _ticketInfoView.frame = CGRectMake(_ticketInfoView.frame.origin.x, -_ticketInfoView.frame.size.height , _ticketInfoView.frame.size.width, _ticketInfoView.frame.size.height);
        } completion:^(BOOL finished) {
            [(TrainOrderDetailViewController *)_trainOrderDetailViewController requestRefundInfo];
            [self closeTicketRefundView:nil];
        }];
    }
    else {
        [Utils alert:@"请您输入正确的验证码"];
    }
}

- (void)refresh:(id)sender
{
    CALayer *refreshLayer = (CALayer *)[self.reloadButton layer] ;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
    [refreshLayer addAnimation:animation forKey:nil];
    
    [(TrainOrderDetailViewController *)_trainOrderDetailViewController getVerificationCode:nil];
}

- (void)stopRefresh
{
//    NSArray *layers = [self.reloadButton.layer sublayers];
//    for (CALayer *layer in layers) {
//        [layer removeAllAnimations];
//    }
    [self.reloadButton.layer  removeAllAnimations];
}

- (UIImage *)imageWithColor:(UIColor *)color  inRect:(CGRect)rect{
    //    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_verificationCodeTextField resignFirstResponder];
    return YES;
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
