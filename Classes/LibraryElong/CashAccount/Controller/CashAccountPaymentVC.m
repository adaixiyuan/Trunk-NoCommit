//
//  CashAccountPaymentVC.m
//  ElongClient
//  现金账户支付页
//
//  Created by 赵 海波 on 13-7-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CashAccountPaymentVC.h"
#import "CashAccountReq.h"
#import "PaymentTypeVC.h"
#import "HotelPostManager.h"

@interface CashAccountPaymentVC ()

@end

@implementation CashAccountPaymentVC

- (void)dealloc {
    [tipButton release];
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil) {
        self.view = nil;
    }
}


- (id)init
{
    if (self = [super initWithTopImagePath:nil andTitle:@"艺龙现金账户支付" style:_NavNoTelStyle_]) {
        
        tipButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        tipButton.frame = CGRectMake(0, -45, SCREEN_WIDTH, 44);
        tipButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        tipButton.titleLabel.font = FONT_14;
        tipButton.adjustsImageWhenHighlighted = NO;
        [tipButton setTitle:@"使用艺龙现金账户支付，需输入支付密码" forState:UIControlStateNormal];
        [tipButton addTarget:self action:@selector(closeTip) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tipButton];
        
        [self performSelector:@selector(showTip) withObject:nil afterDelay:.8f];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (!closeTip)
    {
        // 内存警告时，如果提示栏没有被关的话需要继续加上
        tipButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [self.view addSubview:tipButton];
    }
    
    // ==================================================
    offY = 70;
    
    UILabel *cashTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offY, 10, 14)];
    cashTitleLabel.text = @"账户余额：";
    cashTitleLabel.font = FONT_14;
    [cashTitleLabel sizeToFit];
    [self.view addSubview:cashTitleLabel];
    [cashTitleLabel release];
    
    UILabel *cashNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(cashTitleLabel.frame.origin.x + cashTitleLabel.frame.size.width, cashTitleLabel.frame.origin.y - 1, 10, 14)];
    cashNumLabel.text = [NSString stringWithFormat:@"¥%.f", [[CashAccountReq shared] cashAccountRemain]];
    cashNumLabel.font = FONT_16;
    cashNumLabel.textColor = [UIColor orangeColor];
    [cashNumLabel sizeToFit];
    [self.view addSubview:cashNumLabel];
    [cashNumLabel release];
    
    offY += cashTitleLabel.frame.size.height + 10;
    
    if ([[CashAccountReq shared] needPassword])
    {
        passwordField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(10, offY, 300, BOTTOM_BUTTON_HEIGHT) Title:@"支付密码：" TitleFont:FONT_16];
        passwordField.placeholder = @"     请输入支付密码";
        passwordField.delegate = self;
        passwordField.textFont = FONT_16;
        passwordField.abcToSystemKeyboard = YES;
        [self.view addSubview:passwordField];
        [passwordField release];
        
        offY += BOTTOM_BUTTON_HEIGHT;
    }
    
    //====================================================
    offY += 20;
    
    [self.view addSubview:[UIButton uniformButtonWithTitle:@"确 定"
                                                 ImagePath:@"confirm_sign.png"
                                                    Target:self
                                                    Action:@selector(clickConfirmBtn)
                                                     Frame:CGRectMake(15,offY, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)]];
}


- (void)showTip
{
    [UIView animateWithDuration:0.3 animations:^{
        tipButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    }];
}


- (void)closeTip
{
    [UIView animateWithDuration:0.3 animations:^{
        tipButton.frame = CGRectMake(0, -45, SCREEN_WIDTH, 44);
    }];
}


- (void)clickConfirmBtn
{
    if ([_root canUseCashToPayAll])
    {
        // 余额足够时，直接下单
        NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
        [[HotelPostManager hotelorder] setCurrency:[room safeObjectForKey:CURRENCY]];
        [[HotelPostManager hotelorder] setToPrePay];
        [Utils request:HOTELSEARCH req:[[HotelPostManager hotelorder] requesString:NO] delegate:self];
    }
    else
    {
        // 余额不够时，返回上一页面
        [self back];
    }
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	return [textField resignFirstResponder];
}


@end
