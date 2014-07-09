//
//  PaymentTypeVC.h
//  ElongClient
//  选择支付方式页
//
//  Created by 赵 海波 on 13-7-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAndEditCard.h"
#import "SelectCardCell.h"

typedef enum
{
    PaymentTypeNativeHotel,         // 国内酒店
    PaymentTypeInterHotel,          // 国际酒店
    PaymentTypeGroupon              // 团购
}PaymentType;

@class ConfirmHotelOrder;
@interface PaymentTypeVC : DPNav <ButtonViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AddAndEditCardDelegate, SelectCardCellDelegate>
{
    PaymentType payType;            // 支付流程使用的类型
    
    int offY;                       // 各控件的y轴偏移量
    int currentOverDueRow;          // 标志已过期的信用卡
    
    CGFloat payMoney;               // 订单总额
    NSInteger couponPrice;          // 消费券使用额度
    
    UISwitch *cashSwitch;           // 现金支付开关
    ButtonView *switchBtn;          // 现金支付开关
    UIButton *creditBtn;            // 信用卡选择按钮
    SmallLoadingView *loadingView;  // 读取客史时加的loading框
    ConfirmHotelOrder *confirmController;
    GrouponConfirmViewController *grouponConfirmVC;
    
    UILabel *cashLeftLabel;         // 现金数字左边label
    UILabel *cashRightLabel;        // 现金数字右边label
    UILabel *cashNumLabel;          // 现金账户余额(使用额)
    UILabel *creditLeftLabel;       // 信用卡金额左边文字
    UILabel *creditNumLabel;        // 信用卡需要支付金额
    UILabel *invoiceTipLabel;       // 现金账户不能开具发票提示
    UILabel *invoiceNumLabel;       // 使用CA后发票金额显示
    
    int netType;                    // 请求类型
    int currentRow;                 // 当前选中的cell
    int preSelectRow;               // 上次选中的cell
    int defaultCardCount;
    int sectionNum;                 // 关系到是否展示信用卡， default：2
    
    BOOL preloadOver;               // 预加载银行列表是否结束
    
    HttpUtil *bankUntil;            // 银行预加载请求
    HttpUtil *cardsUtil;            // 客史信用卡请求
}

@property (nonatomic, retain) UITableView *creditCardTable;   // 信用卡列表
@property (nonatomic, assign) BOOL selectedCard;              // 标志是否选中信用卡，default = NO
@property (nonatomic, assign) BOOL showHotelInvoiceTip;       // 是否展示酒店发票提示,default = NO

- (id)initWithType:(PaymentType)type;

- (BOOL)canUseCashToPayAll;     // 能使用现金账户里的金额全额付款
- (void)refreshTable;           // 刷新表格数据

@end
