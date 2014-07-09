//
//  FlightCashAccountTable.h
//  ElongClient
//  机票统一收银台金额及CA开关显示部分
//
//  Created by 赵 海波 on 14-3-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelDetailController.h"
#import "UniformCounterViewController.h"
#import "DefineHotelResp.h"

@class EmbedTextField;
@interface FlightCashAccountTable : UITableView <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSInteger cellNum;        // 当前显示的行数
    BOOL needShowMoney;       // 是否需要展示金额,default:YES
}

@property (nonatomic) NSInteger contentHeight;   // 本页内容高度
@property (nonatomic) CGFloat totalPrice;        // 订单总价
@property (nonatomic) CGFloat caPayPrice;        // CA支付额
@property (nonatomic) BOOL useCashAccount;       // 标志是否使用CA
@property (nonatomic) BOOL needCAPassword;       // 标志CA是否需要密码
@property (nonatomic, strong) CustomTextField *passwordField;    // CA密码输入框
@property (nonatomic) UniformFromType fromType;     // 标志来自哪个流程

- (id)initWithTotalPrice:(CGFloat)price CashSwitch:(BOOL)canUseCash Frame:(CGRect)rect;       // 使用是否可以使用消费权进行初始化

- (id)initWithTotalPrice:(CGFloat)price CashSwitch:(BOOL)canUseCash Frame:(CGRect)rect UniformFromType:(UniformFromType)accessType;

- (id)initNoMoneyDisplayWithTotalPrice:(CGFloat)price CashSwitch:(BOOL)canUseCash Frame:(CGRect)rect UniformFromType:(UniformFromType)accessType;       // 不要显示金额的

@end
