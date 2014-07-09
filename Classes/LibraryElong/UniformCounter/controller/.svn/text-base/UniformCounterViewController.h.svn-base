//
//  UniformCounterViewController.h
//  ElongClient
//  统一收银台(本类只自动取用户的CA信息，其它的描述文字，总价，支付方式等信息)
//
//  Created by 赵 海波 on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniformCounterConfig.h"
#import "UniformCounterDataModel.h"

@class CashAccountTable, PaymentTypeTable, RefreshView, UniformCounterDataModel;
@interface UniformCounterViewController : ElongBaseViewController <UniformCounterDataModelProtocol>
{
    @private
    CashAccountTable *caTable;          // 总价和CA展示
    PaymentTypeTable *payTable;         // 支付方式选择
    
    RefreshView *refreshView;           // 支付方式选择刷新控件
    
    HttpUtil *payMethodUtil;            // 获取支付方式的请求
    UniformCounterDataModel *dataModel; // 统一收银台数据
    BOOL needCheckPayState;             // 标记是否需要检测订单的支付状态,default:YES
}

@property (nonatomic) UniformPaymentType selectedPaymentType;   // 选择的支付方式，默认为信用卡支付

+ (void)setPaymentType:(UniformPaymentType)type;
+ (UniformPaymentType)paymentType;

/** 初始化时传入参数：
 *  顶部标题文字，titles里包含多少个对象，对应显示多少行文字
 *  订单总额
 *  是否能使用CA
 *  可以使用哪些支付方式，types里传入用NSNumber封装的UniformPaymentType枚举对象
 *  对应流程
 */
- (id)initWithTitles:(NSArray *)titles
          orderTotal:(CGFloat)totalMoney
cashAccountAvailable:(BOOL)canUseCA
        paymentTypes:(NSArray *)types
     UniformFromType:(UniformFromType)accessType;

/** 初始化时传入参数：（真统一支付平台）
 *  顶部标题文字，titles里包含多少个对象，对应显示多少行文字
 *  订单总额
 *  是否能使用CA
 *  对应流程
 */
- (id)initWithTitles:(NSArray *)titles
          orderTotal:(CGFloat)totalMoney
cashAccountAvailable:(BOOL)canUseCA
     UniformFromType:(UniformFromType)accessType;

// 点击确认支付按钮
- (void)clickConfirmBtn;

@end
