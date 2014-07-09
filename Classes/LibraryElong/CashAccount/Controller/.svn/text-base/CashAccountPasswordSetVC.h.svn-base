//
//  CashAccountPasswordSetVC.h
//  ElongClient
//  CA账户密码设置页面
//
//  Created by 赵 海波 on 13-7-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupStyleCell.h"

typedef enum
{
    ECashAccountSetTypeSet = 1,        // 设置
    ECashAccountSetTypeReset = 2       // 重置
}ECashAccountSetType;  // 密码校验类型

@interface CashAccountPasswordSetVC : DPNav <UITableViewDataSource, UITableViewDelegate, GroupStyleCellDelegate>
{
    UITextField *phoneField;           // 手机号输入框
    UITextField *oldPasswordField;     // 原有密码输入框
    UITextField *passwordField;        // 密码输入框
    UITextField *rePasswordField;      // 密码确认框
    UITextField *checkcodeField;       // 校验码输入框
    
    UIButton *checkcodeBtn;            // 校验码按钮
    
    UITableView *table;
    
    HttpUtil *checkcodeUtil;           // 请求校验码
    ECashAccountSetType passwordType;
    
    int net_type;
}

@property (nonatomic, assign) BOOL nextToRecharge;      // 下一页是否跳转入礼品卡充值页面,default = NO

- (id)initWithType:(ECashAccountSetType)type;

@end
