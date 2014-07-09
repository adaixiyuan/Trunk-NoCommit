//
//  UniformCounterDataModel.m
//  ElongClient
//
//  Created by 赵 海波 on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "UniformCounterDataModel.h"
#import "UniformCounterViewController.h"
#import "AccountManager.h"
#import "ElongURL.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"
#import "UniformCounterViewController.h"

#define NET_TYPE_CA         9090
#define NET_TYPE_PAYDETAIL  9191
#define NET_TYPE_GETTOKEN   9292

static UniformCounterDataModel *model = nil;

@implementation UniformCounterDataModel

+ (id)shared
{
    @synchronized(model)
    {
        if (!model)
        {
            model = [[UniformCounterDataModel alloc] init];
        }
    }
    
    return model;
}


- (id)init
{
    if (self = [super init])
    {
        self.titlesArray = [[NSMutableArray alloc] initWithCapacity:2];
        self.banksOfCreditCard = [[NSMutableArray alloc] initWithCapacity:2];
        self.paymethods = [[NSMutableArray alloc] initWithCapacity:2];
        self.caSupportPaymethods = [[NSMutableArray alloc] initWithCapacity:2];
        self.thirdPaymentDataDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        self.orderInfo = [[NSMutableDictionary alloc] init];
        self.nonCABanksOfCreditCard = [[NSMutableArray alloc] init];
        self.currentOrderReq = [[NSMutableDictionary alloc] init];
        
        self.canUseCA = NO;
        self.usedCA = NO;
    }
    
    return self;
}


- (NSMutableDictionary *)getUniformPayData:(UniformFromType)type
{
    // 检测订单是否能够继续支付
    NSString *tradeToken;
    if (DICTIONARYHASVALUE(_orderInfo))
    {
        tradeToken = [_orderInfo objectForKey:tradeToken_API];
    }
    else
    {
        tradeToken = _tradeToken;
    }
    
    NSString *notifyUrl;
    if (DICTIONARYHASVALUE(_orderInfo))
    {
        notifyUrl = [_orderInfo objectForKey:notifyUrl_API];
    }
    else
    {
        notifyUrl = _notifyUrl;
    }
    
//    CGFloat payMoney = _usedCA ? _orderTotalMoney : _waitingPayMoney;
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict safeSetObject:tradeToken forKey:trade_no_API];                // 请求交易号token
    [mutDict safeSetObject:_orderID forKey:order_id_API];
    [mutDict safeSetObject:[NSNumber numberWithFloat:_orderTotalMoney] forKey:total_amt_API];      // 支付订单金额
    [mutDict safeSetObject:notifyUrl forKey:notify_url_API];     // 异步通知回调Url
    
    if (type == UniformFromTypeGroupon)
    {
        [mutDict safeSetObject:@"1006" forKey:business_type_API];           // 固定业务类型
    }
    
    if (_usedCA && _caAmount > 0)
    {
        // 如使用了CA账户，需要加入CA支付信息
        NSDictionary *caDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithFloat:_caAmount], ca_amt_API,       // CA金额
                               NUMBER(4601), ca_currency_API,       // CA币种，目前只支持人民币
                               [[AccountManager instanse] cardNo], member_card_no_API, nil];  // 会员卡号
        [mutDict safeSetObject:caDic forKey:ca_API];
    }
    
    // 支付产品ID,纯CA为0，预设为纯CA，由其他流程来改变此值
    [mutDict safeSetObject:NUMBER(0) forKey:payment_product_id_API];
    
    return mutDict;
}


- (void)refreshDataWithOrderID:(NSString *)orderID
                    tradeToken:(NSString *)token
                       bizType:(NSNumber *)bizeType
{
    self.orderID = orderID;
    self.tradeToken = token;
    self.bizType = bizeType;
    net_type = NET_TYPE_GETTOKEN;
    
    // 第一步验证订单是否可用，并且取到回调的url
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                orderID, OrderID_API, nil];
    
    NSString *url = [HttpUtil javaAPIGetReqInDomain:API_DOMAIN_tuan atFunction:API_FUNCTION_getBefundToken andParam:dic];
    
    [HttpUtil requestURL:url postContent:nil delegate:self];
}


- (void)setOrderTotalMoney:(CGFloat)money
{
    _orderTotalMoney = money;
    self.waitingPayMoney = _orderTotalMoney;
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if ([Utils checkJsonIsError:root])
    {
        return;
    }
    
    if (net_type == NET_TYPE_GETTOKEN)
    {
        self.tradeToken = [root objectForKey:tradeNo_API];
        self.notifyUrl = [root objectForKey:notifyUrl_API];
        self.orderTotalMoney = [[root objectForKey:@"payAmount"] doubleValue];
        
        net_type = NET_TYPE_PAYDETAIL;
        // 首先请求该订单具体的支付金额
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    _bizType, bizType_API,
                                    _orderID, orderId_API,
                                    _tradeToken, tradeToken_API, nil];
        
        NSString *url = [HttpUtil javaAPIGetReqInDomain:API_DOMAIN_myelong_Pay atFunction:API_FUNCTION_getDefrayDetail andParam:dic];
        
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
    else if (net_type == NET_TYPE_CA)
    {
        if ([[root safeObjectForKey:CACHE_ACCOUNT_AVAILABLE] safeBoolValue] &&
            [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue] > 0)
        {
            // CA可用的情况
            CashAccountReq *cashAccount = [CashAccountReq shared];
            cashAccount.needPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
            cashAccount.cashAccountRemain = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
            
            self.canUseCA = YES;
        }
        else
        {
            self.canUseCA = NO;
        }
        
        if ([_delegate respondsToSelector:@selector(uniformCounterDataDidRefresh)])
        {
            [_delegate uniformCounterDataDidRefresh];
        }

    }
    else if (net_type == NET_TYPE_PAYDETAIL)
    {
        NSLog(@"%@", root);
        BOOL caPaid = NO;               // 标记是否有CA部分付款
        CGFloat totalPayPrice = 0;      // 纪录订单内已经支付过的部分款项
        NSArray *detailsArray = [root objectForKey:details_API];
        if (ARRAYHASVALUE(detailsArray))
        {
            for (NSDictionary *dic in detailsArray)
            {
                if (DICTIONARYHASVALUE(dic))
                {
                    totalPayPrice += [[dic safeObjectForKey:price_API] floatValue];
                    
                    if ([[dic safeObjectForKey:@"type"] intValue] == 3001)
                    {
                        caPaid = YES;
                        self.usedCA = NO;
                        self.caAmount = [[dic safeObjectForKey:price_API] floatValue];
                    }
                }
            }
        }
        
        // 刷新订单数据
        self.waitingPayMoney = _orderTotalMoney - totalPayPrice;

        if (caPaid == NO)
        {
            // ca未付款的情况下，检测ca账户状态，看用户能用ca继续支付
            net_type = NET_TYPE_CA;
            
            [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeGroupon] delegate:self];
        }
        else
        {
            self.canUseCA = NO;
            // ca已付款的情况下，直接执行回调方法
            if ([_delegate respondsToSelector:@selector(uniformCounterDataDidRefresh)])
            {
                [_delegate uniformCounterDataDidRefresh];
            }
        }
    }
}


- (void)clearData
{
    self.canUseCA = NO;
    self.usedCA = NO;
    self.waitingPayMoney = 0;
    self.caAmount = 0;
    self.orderTotalMoney = 0;
    self.fromType = 0;
    self.tradeToken = nil;
    self.orderID = nil;
    self.delegate = nil;
    self.notifyUrl = nil;
    self.bizType = nil;
    
    [_currentOrderReq removeAllObjects];
    [_orderInfo removeAllObjects];
    [_caSupportPaymethods removeAllObjects];
    [_paymethods removeAllObjects];
    [_nonCABanksOfCreditCard removeAllObjects];
    [_banksOfCreditCard removeAllObjects];
    [_titlesArray removeAllObjects];
    [_thirdPaymentDataDic removeAllObjects];
}


- (void)cancelCAPayment
{
    self.usedCA = NO;
    self.caAmount = 0;
    self.waitingPayMoney = _orderTotalMoney;
}

@end
