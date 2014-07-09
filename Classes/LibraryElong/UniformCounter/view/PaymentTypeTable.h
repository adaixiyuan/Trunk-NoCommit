//
//  PaymentTypeTable.h
//  ElongClient
//  支付方式选择
//
//  Created by 赵 海波 on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniformCounterViewController.h"

@protocol PaymentTypeTableDelegate <NSObject>

@required
- (void) selectPayment:(UniformPaymentType)type;
@optional
- (void) paymentTypeRuleAction:(PaymentTypeTable *)paymentType;
@end


@class AttributedLabel, UniformCounterViewController;

@interface PaymentTypeTable : UITableView <UITableViewDataSource, UITableViewDelegate>
{
    AttributedLabel *headerTitleLabel;        // 不使用CA时的顶部标题栏
    AttributedLabel *caHeaderTitleLabel;      // 使用CA时候的顶部标题栏
    UIButton *ruleBtn;
    UniformCounterDataModel *dataModel;
}

@property (nonatomic) UniformPaymentType selectedPayType;   // 选择的支付方式,默认选中信用卡
@property (nonatomic, assign) id <PaymentTypeTableDelegate> root;
@property (nonatomic, assign) UniformPaySection paySection;
@property (nonatomic, readonly) UIButton *ruleBtn;

- (id)initWithPaymentTypes:(NSArray *)types;        // 使用可支付类型初始化,数组内传入NSNumber封装的支付类型枚举
- (id)initWithPaymentTypes:(NSArray *)types paySection:(UniformPaySection)section; // 重载，增加担保预付的选择项
@end

