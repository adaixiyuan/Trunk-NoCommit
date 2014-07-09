//
//  GrouponInvoiceFillController.h
//  ElongClient
//  发票填写
//
//  Created by haibo on 11-11-25.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "FilterView.h"
#import "SelectTable.h"
#import "GrouponConfirmViewController.h"
#import "ConfirmHotelOrder.h"

typedef enum
{
    InvoiceTypeGroupon = 0, // 团购发票（默认）
    InvoiceTypeHotel,       // 酒店发票
    InvoiceTypeHotelZhifubao
}InvoiceType;               // 发票类型

@class SelectedAddressView, EmbedTextField;
@interface GrouponInvoiceFillController : DPNav <FilterDelegate, UITextFieldDelegate, UIAlertViewDelegate> {
@private
	NSMutableArray *addArray;		// 地址信息
	
	EmbedTextField *titleField;		// 发票抬头
	
	UIButton *typeButton;			// 发票类型
	
	FilterView *invoiceSelect;		// 发票类型选择器
	
	SelectedAddressView *address;	// 邮寄地址选择器
    
    BOOL noCardRecord;              // 是否有保存过的信用卡
    
    NSInteger netType;
    GrouponConfirmViewController *grouponConfirmVC;
    
    ConfirmHotelOrder *hotelconfirmorder;
}

@property (nonatomic) InvoiceType invoiceType;        // 发票类型，default:团购
@property (nonatomic) BOOL cashAmountAvailable;       // 检查现金帐户是否可用,default = YES

- (id)initWithAddressInfo:(NSDictionary *)addressInfo;

@end
