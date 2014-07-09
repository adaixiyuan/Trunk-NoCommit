//
//  UniformCounterDataModel.h
//  ElongClient
//  统一收银台关键数据
//
//  Created by 赵 海波 on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniformCounterConfig.h"

#define Third_AlipayPayment     @"AlipayPayment"
#define Third_WapAlipayPayment  @"WapAlipayPayment"
#define Third_WeixinPayment     @"WeixinPayment"

@protocol UniformCounterDataModelProtocol <NSObject>

@required
/** 统一收银台数据刷新后执行的方法
 */
- (void)uniformCounterDataDidRefresh;

@end

@class UniformCounterViewController;

@interface UniformCounterDataModel : NSObject
{
    int net_type;
}

@property (nonatomic, assign) id <UniformCounterDataModelProtocol> delegate;

/** 纪录支付流程
 */
@property (nonatomic, assign) UniformFromType fromType;

/** 订单请求
 */
@property (nonatomic, strong) NSMutableDictionary *currentOrderReq;

/** 订单号，当更改这个值时，将清除本次预订的所有数据，设置为nil时，下次进入统一收银台页调用成单接口了；非nil值时，不调用成单接口
 */
@property (nonatomic, strong) NSString *orderID;

/** 纪录订单token
 */
@property (nonatomic, strong) NSString *tradeToken;

/** 纪录订单notifyUrl
 */
@property (nonatomic, strong) NSString *notifyUrl;

/** 纪录当前业务流程
 */
@property (nonatomic, strong) NSNumber *bizType;

/** 纪录顶部标题
 */
@property (nonatomic, strong) NSMutableArray *titlesArray;

/** 纪录信用卡银行列表
 */
@property (nonatomic, strong) NSMutableArray *banksOfCreditCard;

/** 纪录不支持与CA混合支付的信用卡银行列表
 */
@property (nonatomic, strong) NSMutableArray *nonCABanksOfCreditCard;

/** 纪录支付方式
 */
@property (nonatomic, strong) NSMutableArray *paymethods;

/** 纪录可以支持ca的支付方式
 */
@property (nonatomic, strong) NSMutableArray *caSupportPaymethods;

/** 纪录支付方式的数据对象（第三方支付方式专用）
 */
@property (nonatomic, strong) NSMutableDictionary *thirdPaymentDataDic;

/** 纪录订单信息
 */
@property (nonatomic, strong) NSMutableDictionary *orderInfo;

/** 纪录订单总金额
 */
@property (nonatomic, assign) CGFloat orderTotalMoney;

/** 纪录已使用CA支付的金额
 */
@property (nonatomic, assign) CGFloat caAmount;

/** 纪录订单还需支付金额
 */
@property (nonatomic, assign) CGFloat waitingPayMoney;

/** 纪录是否能使用CA支付
 */
@property (nonatomic, assign) BOOL canUseCA;

/** 纪录是否使用CA支付
 */
@property (nonatomic, assign) BOOL usedCA;

// ===================================================================================================

+ (id)shared;

/** 获取统一收银台支付接口的请求数据(包含公共部分和CA部分),订单不可继续支付时不返回数据
 */
- (NSMutableDictionary *)getUniformPayData:(UniformFromType)type;

/** 已经下过订单的情况下，传入订单号、token、业务类型刷新统一收银台数据（此步骤包含订单金额和CA金额验证）
 */
- (void)refreshDataWithOrderID:(NSString *)orderID
                    tradeToken:(NSString *)token
                       bizType:(NSNumber *)bizeType;

/** 清空数据
 */
- (void)clearData;

/** 将CA支付的金额归零
 */
- (void)cancelCAPayment;

@end
