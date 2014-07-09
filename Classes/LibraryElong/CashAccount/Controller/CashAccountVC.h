//
//  CashAccountVC.h
//  ElongClient
//  现金账户页面（MyElong）
//
//  Created by 赵 海波 on 13-7-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//
//  “礼品卡充值”改为“礼品卡/红包充值” by 赵海波 on 14-3-21

#import <UIKit/UIKit.h>

typedef enum
{
    WithDrawTypeBank = 0,   // 提现到银行
    WithDrawTypePhone       // 提现到手机
}WithDrawType;              // 提现种类

@interface CashAccountVC : DPNav <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    @private
    CGFloat cashAccountRemain;        // 现金账户余额
    double cashLockedAccount;       //冻结金额
    
    HttpUtil *couponListUtil;         // (接口尚无）
    HttpUtil *cashDespUtil;     
    
    BOOL havePassword;                // 是否有支付密码
    
    UILabel *cashRemainLabel;         // 显示现金账户余额
    UIImageView *tipBg;               // 设置密码提示
    UILabel *passBtnLabel;            // 密码按钮标题卡金额
    
    UITableView *table;
    UIView *cashDetailView;           // 余额详情view
    UIImageView *cashDetailBg;        // 余额详情背景图
    
    NSDictionary *cashAccountDic;     // 现金账户余额
    
    WithDrawType withDrawType;        // 提现种类
    
    UIImageView *despBgImgView;
    UIButton *cashDespBtn;
}

- (id)initWithCashDetail:(NSDictionary *)dic;     // 传入现金账户详情初始化
@property(nonatomic,copy) NSString *cashDesp;

@end
