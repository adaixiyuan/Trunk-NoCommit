//
//  GrouponFillOrder.h
//  ElongClient
//  团购订单填写
//
//  Created by haibo on 11-11-23.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "GrouponOrderInfoCell.h"
#import "GrouponOrderPhoneCell.h"
#import "GrouponOrderPayCell.h"
#import "GrouponOrderPhoneCell.h"
#import "GrouponOrderInvoiceCell.h"
#import "GrouponConfirmViewController.h"
#import "FlightDataDefine.h"
#import "HotelOrderCell.h"
#import "HotelOrderInvoiceCell.h"
#import "AddAddress.h"
#import "FilterView.h"
#import "StringFormat.h"
#import "UniformCounterDataModel.h"


@class OnOffView, GrouponSharedInfo, FXLabel, EmbedTextField;
@interface GrouponFillOrder : DPNav <UITextFieldDelegate, UIAlertViewDelegate, CustomABDelegate,UITableViewDataSource,UITableViewDelegate,GrouponOrderInfoCellDelegate,GrouponOrderPhoneCellDelegate,GrouponOrderPayCellDelegate,GrouponOrderInvoiceCellDelegate,FilterDelegate,UniformCounterDataModelProtocol> {
@private
	NSInteger showUnitPrice;			// 展示单价
	NSInteger purchaseNum;				// 购买数量
    NSInteger netType;
	BOOL keyboardShowing;               // 键盘是否显示
    BOOL noCardRecord;                  // 是否有保存过的信用卡
	CGFloat	realUnitPrice;				// 实际单价
	GrouponSharedInfo *gInfo;			// 团购共享数据
    UITableView *orderList;             // list
    UILabel *salePriceLbl;              // 下一步按钮的价格
    GrouponConfirmViewController *grouponConfirmVC;
    UIButton *nextButton;
    HttpUtil *addressUtil;
    NSMutableArray *invoiceAddresses;   //发票数组
    FilterView *invoiceSelect;
    UITextField *currentTextField;      //当前编辑的textbox
}

@property (nonatomic, assign) BOOL isSkipLogin;				// 跳过登录页

+(BOOL)getIsGrouponPayment;             // 是否是支付宝支付
+(void)setIsGrouponPayment:(BOOL)grouponPay;
@end
