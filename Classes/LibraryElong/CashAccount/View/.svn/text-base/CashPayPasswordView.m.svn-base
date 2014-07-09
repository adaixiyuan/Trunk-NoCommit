//
//  CashPayPasswordView.m
//  ElongClient
//
//  Created by 赵 海波 on 13-8-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CashPayPasswordView.h"
#import "EmbedTextField.h"
#import "Utils.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"
#import "ElongURL.h"
#import "CashAccountPasswordSetVC.h"

@implementation CashPayPasswordView

- (void)dealloc
{
    [cashMoney release];
    [super dealloc];
}


- (id)initWithCashMoney:(NSString *)moneyStr
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self)
    {
        cashMoney = [moneyStr copy];
        
        self.alpha = 0;
        [self makeUI];
        [self showView];
    }
    return self;
}


// 生成界面
- (void)makeUI
{
    self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.8];
    
    // 中间输入部分
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 91, 280, 242)];
    bgView.userInteractionEnabled = YES;
    bgView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_stretch.png"];
    [self addSubview:bgView];
    [bgView release];
    
    offY = 25;
    int offX = 10;
    
    // 余额显示
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX, offY, 10, 14)];
    titleLabel.text = @"账户余额：";
    titleLabel.font = FONT_14;
    titleLabel.backgroundColor = [UIColor clearColor];
    [titleLabel sizeToFit];
    [bgView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x + titleLabel.frame.size.width, offY + 1, 160, 14)];
    cashLabel.text = cashMoney;
    cashLabel.backgroundColor = [UIColor clearColor];
    cashLabel.font = FONT_16;
    cashLabel.textColor = [UIColor orangeColor];
    [bgView addSubview:cashLabel];
    [cashLabel release];
    
    // 输入框
    offY += 30;
    passwordField = [[EmbedTextField alloc] initCustomFieldWithFrame:CGRectMake(offX, offY, bgView.frame.size.width - 2*offX, 48)
                                                               Title:@"支付密码："
                                                           TitleFont:FONT_16];
    passwordField.delegate = self;
    passwordField.numberOfCharacter = 15;
	passwordField.secureTextEntry = YES;
	passwordField.abcEnabled = YES;
    passwordField.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:passwordField];
    [passwordField release];
    
    // 确定按钮
    offY += 70;
    UIButton *confirmBtn = [UIButton yellowWhitebuttonWithTitle:@"确  定"
                                                         Target:self
                                                         Action:@selector(clickNext)
                                                          Frame:CGRectMake(offX, offY, bgView.frame.size.width - 2*offX, BOTTOM_BUTTON_HEIGHT)];
    [bgView addSubview:confirmBtn];
    
    offY += BOTTOM_BUTTON_HEIGHT + 10;
    // 重置支付密码按钮
    UIButton *passwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passwordBtn.frame = CGRectMake(130, offY, 160, 40);
    [passwordBtn setImage:[UIImage noCacheImageNamed:@"ico_rightarrow.png"] forState:UIControlStateNormal];
    [passwordBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -196)];
    passwordBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [passwordBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateNormal];
    [passwordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [passwordBtn setTitle:@"重置支付密码" forState:UIControlStateNormal];
    [passwordBtn addTarget:self action:@selector(clickPasswordBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:passwordBtn];
    
    // 关闭按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton@2x.png"] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(SCREEN_WIDTH - 52, 64, 60, 60);
    [cancelBtn addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
}


// 点击重置密码按钮
- (void)clickPasswordBtn
{
    [self closeView];
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    CashAccountPasswordSetVC *controller = [[CashAccountPasswordSetVC alloc] initWithType:ECashAccountSetTypeReset];
    [appDelegate.navigationController pushViewController:controller animated:YES];
    [controller release];
}


// 点击取消按钮
- (void)clickCancelButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CASHACCOUNT_PASSERROR object:nil];
    [self closeView];
}


// 点击确定按钮
- (void)clickNext
{
    [passwordField resignFirstResponder];
    if (passwordField.text.length == 0) {
        // 没有输入密码时，给出提示
        [PublicMethods showAlertTitle:@"请输入密码" Message:nil];
        return;
    }
    
    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq verifyCashAccountPwdWithPwd:passwordField.text] delegate:self];
}


// 展示动画
- (void)showView
{
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}


// 关闭动画
- (void)closeView
{
    [UIView animateWithDuration:0.3 animations:^ {
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - HttpUtil Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return;
    }
    
    if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
    {
        [self closeView];
    }
    else
    {
        // 发送验密成功失败
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CASHACCOUNT_PASSERROR object:nil];
        [PublicMethods showAlertTitle:@"密码错误" Message:@"请检查"];
    }
}


#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

@end
