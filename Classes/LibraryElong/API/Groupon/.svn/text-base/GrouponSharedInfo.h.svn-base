//
//  GrouponSharedInfo.h
//  ElongClient
//	团购共享数据
//
//  Created by haibo on 11-11-24.
//  Copyright 2011 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GrouponConfig.h"

@interface GrouponSharedInfo : NSObject {

}

@property (nonatomic, retain) NSNumber *expressFee;			// 发票快递费(double)
@property (nonatomic, retain) NSNumber *grouponID;			// 团购ID
@property (nonatomic, retain) NSNumber *isInvoice;			// 是否需要发票
@property (nonatomic, retain) NSNumber *purchaseNum;		// 购买数量(int)
@property (nonatomic, retain) NSNumber *prodID;				// 产品ID
@property (nonatomic, retain) NSNumber *prodType;			// 产品类型
@property (nonatomic, retain) NSNumber *realTotalPrice;		// 实际的总价(double)
@property (nonatomic, retain) NSNumber *realCost;			// 底价
@property (nonatomic, retain) NSNumber *salePrice;			// 团购卖价（double）
@property (nonatomic, retain) NSNumber *showTotalPrice;		// 显示的总价(long)
@property (nonatomic, retain) NSNumber *mobileProductType;  // 手机专享产品,0:正常产品，1：手机专享
@property (nonatomic, retain) NSNumber *cashAmount;         // 现金帐户支付余额

@property (nonatomic, copy) NSString *email;				// 电子邮箱（从订单填写页输入）
@property (nonatomic, copy) NSString *mobile;				// 手机号码（从订单填写页输入）
@property (nonatomic, copy) NSString *prodName;				// 酒店名称
@property (nonatomic, copy) NSString *title;				// 团购信息
@property (nonatomic, copy) NSString *inDateDescription;    // 有效期描述文字

@property (nonatomic, retain) NSDictionary *invoiceInfo;	// 发票信息
@property (nonatomic, retain) NSDictionary *creditCardInfo;	// 信用卡信息

@property (nonatomic, retain) NSNumber *InvoiceMode;		// 判断是酒店开具发票还是艺龙开具发票

@property (nonatomic,copy) NSString *startTime_str;
@property (nonatomic,copy) NSString *endTime_str;

@property (nonatomic, assign) GrouponOrderPayType payType;  // 支付方式 0:信用卡 1：支付宝 2：银联 3：微信支付
@property (nonatomic, assign) WeiXinPayMethod payMethod;    // 微信支付相关 0：微信JS，1：微信native，2：微信APP方式，3：微信WEB扫描
@property (nonatomic, assign) CGFloat cashPayment;      // 现金账户支付金额
@property (nonatomic,copy) NSString *appointmentPhone;

@property (nonatomic, retain) NSDictionary *detailDic;				//产品详情
@property (nonatomic,copy) NSString *qianDianUrl;                   //千店url

+ (id)shared;
- (void)clearData;

@end
