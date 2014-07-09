//
//  UniformCounterViewController.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UniformCounterViewController.h"
#import "CounterMainInfoView.h"
#import "CashAccountTable.h"
#import "CashAccountConfig.h"
#import "CashAccountReq.h"
#import "PaymentTypeTable.h"
#import "UniformCreditCardModel.h"
#import "UniformWeiXinModel.h"
#import "UniformWapAlipayModel.h"
#import "UniformAlipayModel.h"
#import "UniformDepositModel.h"
#import "UniformCashAccountModel.h"
#import "GrouponSharedInfo.h"
#import "FlightOrderConfirmView.h"
#import "GrouponOrderConfirmView.h"
#import "GrouponSuccessController.h"
#import "ElongClientAppDelegate.h"
#import "RefreshView.h"

@interface UniformCounterViewController ()

@property (nonatomic) CGFloat totalPrice;           // 订单总价
@property (nonatomic) BOOL cashAccountAvailable;    // 是否可用现金账户
@property (nonatomic) UniformFromType fromType;     // 标志来自哪个流程

@end

static UniformPaymentType payType = UniformPaymentTypeCreditCard;

@implementation UniformCounterViewController

@synthesize totalPrice;
@synthesize cashAccountAvailable;
@synthesize fromType;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [payMethodUtil cancel];
    payMethodUtil = nil;
}


+ (void)setPaymentType:(UniformPaymentType)type
{
    payType = type;
}


+ (UniformPaymentType)paymentType
{
    return payType;
}


- (id)initWithTitles:(NSArray *)titles orderTotal:(CGFloat)totalMoney cashAccountAvailable:(BOOL)canUseCA paymentTypes:(NSArray *)types UniformFromType:(UniformFromType)accessType
{
    if (self = [super initWithTitle:@"支付订单" style:NavBarBtnStyleOnlyBackBtn])
    {
        // 获取流程
        self.fromType = accessType;
        self.totalPrice = totalMoney;
        self.cashAccountAvailable = canUseCA;
        needCheckPayState = YES;
        
        // 初始化时首先要清空CA的信息
        [self clearCashInfo];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiClickDetailBtn:) name:NOTI_FLIGHT_ORDER_DETAIL object:nil];
        
        // 添加价格展示和CA支付选择项，主界面
        caTable = [[CashAccountTable alloc] initWithTotalPrice:totalMoney CashSwitch:canUseCA Frame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) UniformFromType:self.fromType];
        [self.view addSubview:caTable];
        
        // 添加各流程不同信息
        [self makeUpTopView:caTable withTitles:titles];
        
        // 添加支付方式选择
        [self makeUpBottomView:caTable withPayments:types];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor = RGBCOLOR(62, 62, 62, 1);
        
        // 添加确认支付按钮
        UIButton *confirmBtn = [UIButton uniformButtonWithTitle:@"确认支付"
                                                      ImagePath:nil
                                                         Target:self
                                                         Action:@selector(clickConfirmBtn)
                                                          Frame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 50)];
        [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
        [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
        
        [bottomView addSubview:confirmBtn];
        [self.view addSubview:bottomView];
    }
    
    return self;
}


/** 初始化时传入参数：（真统一支付平台）
 *  顶部标题文字，titles里包含多少个对象，对应显示多少行文字
 *  订单总额
 *  是否能使用CA
 *  对应流程
 */
- (id)initWithTitles:(NSArray *)titles
          orderTotal:(CGFloat)totalMoney
cashAccountAvailable:(BOOL)canUseCA
     UniformFromType:(UniformFromType)accessType
{
    if (self = [super initWithTitle:@"支付订单" style:NavBarBtnStyleOnlyBackBtn])
    {
        // 获取流程
        self.fromType = accessType;
        self.totalPrice = totalMoney;
        self.cashAccountAvailable = canUseCA;
        needCheckPayState = YES;
        
        // 配置支付相关数据
        dataModel = [UniformCounterDataModel shared];
        dataModel.orderTotalMoney = totalMoney;
        dataModel.waitingPayMoney = dataModel.orderTotalMoney - dataModel.caAmount;        // 刷新一下需要支付的金额
        dataModel.fromType = accessType;
        [dataModel.titlesArray removeAllObjects];
        [dataModel.titlesArray addObjectsFromArray:titles];
        
        // 初始化时首先要清空CA的信息
        [self clearCashInfo];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiClickDetailBtn:) name:NOTI_FLIGHT_ORDER_DETAIL object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiWXPaySuccess) name:NOTI_WEIXIN_PAYSUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiWapAlipayPaySuccess) name:NOTI_WAPALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiWapAlipayPaySuccess) name:NOTI_ALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiAlipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
        
        // 添加价格展示和CA支付选择项，主界面
        caTable = [[CashAccountTable alloc] initWithTotalPrice:totalMoney CashSwitch:canUseCA Frame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) UniformFromType:self.fromType];
        [self.view addSubview:caTable];
        
        // 添加各流程不同信息
        [self makeUpTopView:caTable withTitles:titles];
        
        // 添加支付方式选择
        [self makeUpBottomView:caTable withPayments:nil];
        // 进入页面后刷新支付方式
        [self refreshPayMethod];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor = RGBCOLOR(62, 62, 62, 1);
        
        // 添加确认支付按钮
        UIButton *confirmBtn = [UIButton uniformButtonWithTitle:@"确认支付"
                                                      ImagePath:nil
                                                         Target:self
                                                         Action:@selector(clickConfirmBtn)
                                                          Frame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 50)];
        [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
        [confirmBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
        
        [bottomView addSubview:confirmBtn];
        [self.view addSubview:bottomView];
    }
    
    return self;
}


- (void)setSelectedPaymentType:(UniformPaymentType)selectedPaymentType
{
    payTable.selectedPayType = selectedPaymentType;
}


- (UniformPaymentType)selectedPaymentType
{
    return payTable.selectedPayType;
}


- (void)clearCashInfo
{
    [[HotelPostManager hotelorder] setCashAmount:0];
    
    GrouponSharedInfo *gSharedInfo = [GrouponSharedInfo shared];
    gSharedInfo.cashAmount = [NSNumber numberWithInt:0];
}

#pragma mark - UI Methods

// 生成顶部文字部分，显示各流程的订单概述
- (void)makeUpTopView:(UITableView *)table withTitles:(NSArray *)titles
{
    if (fromType == UniformFromTypeFlight)
    {
        // 机票
        FlightOrderConfirmView *flightView = [[FlightOrderConfirmView alloc] init];
        table.tableHeaderView = flightView;
    }
    else if (fromType == UniformFromTypeGroupon)
    {
        // 团购
        GrouponOrderConfirmView *grouponView = [[GrouponOrderConfirmView alloc] initWithContents:titles];
        table.tableHeaderView = grouponView;
    }
    else
    {
        CounterMainInfoView *infoView = [[CounterMainInfoView alloc] initWithContents:titles];
        table.tableHeaderView = infoView;
    }
}


// 生成支付方式选择部分
- (void)makeUpBottomView:(UITableView *)table withPayments:(NSArray *)paymentMethods
{
    if (ARRAYHASVALUE(paymentMethods))
    {
        // 有支付方式，直接显示支付方式
        payTable = [[PaymentTypeTable alloc] initWithPaymentTypes:paymentMethods];
        table.tableFooterView = payTable;
    }
    else
    {
        // 没有支付方式，向服务器获取支付方式
        refreshView = [[RefreshView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)
                                                  Target:self
                                                  Action:@selector(refreshPayMethod)
                                                   Title:@"获取信息失败，请刷新重试"
                                                 andIcon:[UIImage noCacheImageNamed:@"forgetPwd_fresh.png"]];
        [refreshView loadingStarWithStyle:UIActivityIndicatorViewStyleGray];
        [self refreshPayMethod];
        table.tableFooterView = refreshView;
    }
}


#pragma mark - Order Methods

// 点击确认支付按钮
- (void)clickConfirmBtn
{
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }
    
    // 检测输入数据异常
    NSString *errorMsg = [self checkData];
    if (STRINGHASVALUE(errorMsg))
    {
        [PublicMethods showAlertTitle:errorMsg Message:nil];
        return;
    }
    
    if (caTable.useCashAccount && STRINGHASVALUE(caTable.passwordField.text))
    {
        [self checkCAPassword:caTable.passwordField.text];
    }
    else
    {
        [self dealPayProgress];
    }
}


- (void)dealPayProgress
{
    // 进入不同流程的处理
    switch (fromType)
    {
        case UniformFromTypeHotel:
            [self orderNativeHotel];
            break;
        case UniformFromTypeInterHotel:
            [self orderInterHotel];
            break;
        case UniformFromTypeFlight:
            [self orderFlight];
            break;
        case UniformFromTypeGroupon:
            [self orderGroupon];
            break;
            
        default:
            break;
    }
}


// 预订国内酒店
- (void)orderNativeHotel
{
    // 酒店统一支付入口
    if (UMENG) {
        [MobClick event:Event_HotelOrder_Payment label:[NSString stringWithFormat:@"%d",payTable.selectedPayType]];
    }
    
    switch (payTable.selectedPayType)
    {
        case UniformPaymentTypeNone:
        {
            // CA余额足够支付酒店订单
            [[UniformCashAccountModel shared] beginForType:UniformFromTypeHotel TotalPrice:totalPrice Password:caTable.passwordField.text];
        }
            break;
        case UniformPaymentTypeCreditCard:
        {
            // CA余额不够支付酒店订单，需要与信用卡混合支付或者全额使用信用卡支付
            [[UniformCreditCardModel shared] beginForType:UniformFromTypeHotel TotalPrice:totalPrice usedCA:caTable.useCashAccount CAPassword:caTable.passwordField.text];
        }
            break;
        case UniformPaymentTypeDepositCard:
        {
            // 储蓄卡银联支付,暂无
            [[UniformDepositModel shared] beginForType:UniformFromTypeHotel];
        }
            break;
        case UniformPaymentTypeWeixin:
        {
            // 使用微信支付订单
            [[UniformWeiXinModel shared] beginForType:UniformFromTypeHotel];
        }
            break;
        case UniformPaymentTypeAlipayWap:
        {
            // 使用支付宝wap支付订单
            [[UniformWapAlipayModel shared] beginForType:UniformFromTypeHotel];
        }
            break;
        case UniformPaymentTypeAlipay:
        {
            // 使用支付宝客户端支付订单，暂无
            [[UniformAlipayModel shared] beginForType:UniformFromTypeHotel];
        }
            break;
            
        default:
            break;
    }
}


// 预定机票流程
- (void)orderFlight
{
    switch (payTable.selectedPayType)
    {
        case UniformPaymentTypeNone:
        {
            // CA余额足够支付酒店订单
            [[UniformCashAccountModel shared] beginForType:UniformFromTypeFlight TotalPrice:totalPrice Password:caTable.passwordField.text];
            UMENG_EVENT(UEvent_Flight_Paytype_PrepayCreditCard)
        }
            break;
        case UniformPaymentTypeCreditCard:
        {
            [[UniformCreditCardModel shared] beginForType:UniformFromTypeFlight TotalPrice:totalPrice usedCA:caTable.useCashAccount CAPassword:caTable.passwordField.text];
            UMENG_EVENT(UEvent_Flight_Paytype_PrepayCreditCard)
        }
            break;
        case UniformPaymentTypeDepositCard:
        {
            // 储蓄卡银联支付,暂无
            [[UniformDepositModel shared] beginForType:UniformFromTypeFlight];
            UMENG_EVENT(UEvent_Flight_Paytype_PrepayDepositCard)
        }
            break;
        case UniformPaymentTypeWeixin:
        {
            // 使用微信支付订单
        }
            break;
        case UniformPaymentTypeAlipayWap:
        {
            // 使用支付宝wap支付订单，暂无
            [[UniformWapAlipayModel shared] beginForType:UniformFromTypeFlight];
            UMENG_EVENT(UEvent_Flight_Paytype_PrepayAlipayWap)
        }
            break;
        case UniformPaymentTypeAlipay:
        {
            // 使用支付宝客户端支付订单
            [[UniformAlipayModel shared] beginForType:UniformFromTypeFlight];
            UMENG_EVENT(UEvent_Flight_Paytype_PrepayAlipayApp)
        }
            break;
            
        default:
            break;
    }
}


// 预定国际酒店流程
- (void)orderInterHotel
{
    switch (payTable.selectedPayType)
    {
        case UniformPaymentTypeNone:
        {
            // CA余额足够支付国际酒店订单
            [[UniformCashAccountModel shared] beginForType:UniformFromTypeInterHotel TotalPrice:totalPrice Password:caTable.passwordField.text];
        }
            break;
        case UniformPaymentTypeCreditCard:
        {
            // CA余额不够支付酒店订单，需要与信用卡混合支付或者全额使用信用卡支付
            [[UniformCreditCardModel shared] beginForType:UniformFromTypeInterHotel TotalPrice:totalPrice usedCA:caTable.useCashAccount CAPassword:caTable.passwordField.text];
        }
            break;
        case UniformPaymentTypeDepositCard:
        {
            // 储蓄卡银联支付,暂无
            [[UniformDepositModel shared] beginForType:UniformFromTypeInterHotel];
        }
            break;
        case UniformPaymentTypeAlipayWap:
        {
            // 使用支付宝wap支付订单
            [[UniformWapAlipayModel shared] beginForType:UniformFromTypeInterHotel];
        }
            break;
        case UniformPaymentTypeAlipay:
        {
            // 使用支付宝客户端支付订单，暂无
            [[UniformAlipayModel shared] beginForType:UniformFromTypeInterHotel];
        }
            break;
            
        default:
            break;
    }
}


// 预定团购流程
- (void)orderGroupon
{
    if (caTable.useCashAccount)
    {
        if (dataModel.orderTotalMoney == dataModel.waitingPayMoney)
        {
            if (caTable.caPayPrice >= totalPrice)
            {
                // 如果CA余额大于订单总额，使用CA支付全额
                dataModel.caAmount = totalPrice;
            }
            else
            {
                // CA余额不足，使用所有CA可用余额
                dataModel.caAmount = caTable.caPayPrice;
            }
            
            dataModel.waitingPayMoney = totalPrice - dataModel.caAmount;
        }
    }
    
    // 团购统一支付入口
    if (UMENG) {
        [MobClick event:Event_GrouponHotelOrder_Payment label:[NSString stringWithFormat:@"%d",payTable.selectedPayType]];
    }
    
    switch (payTable.selectedPayType)
    {
        case UniformPaymentTypeNone:
        {
            // CA余额足够支付酒店订单
            [[UniformCashAccountModel shared] beginForType:UniformFromTypeGroupon TotalPrice:totalPrice Password:nil];
        }
            break;
        case UniformPaymentTypeCreditCard:
        {
            // CA余额不够支付酒店订单，需要与信用卡混合支付或者全额使用信用卡支付
            [[UniformCreditCardModel shared] beginForType:UniformFromTypeGroupon TotalPrice:dataModel.waitingPayMoney usedCA:caTable.useCashAccount CAPassword:caTable.passwordField.text];
            UMENG_EVENT(UEvent_Groupon_Paytype_PrepayCreditCard)
        }
            break;
        case UniformPaymentTypeDepositCard:
        {
            // 储蓄卡银联支付,暂无
            [[UniformDepositModel shared] beginForType:UniformFromTypeGroupon];
        }
            break;
        case UniformPaymentTypeWeixin:
        {
            // 使用微信支付订单
            [[UniformWeiXinModel shared] beginForType:UniformFromTypeGroupon];
            UMENG_EVENT(UEvent_Groupon_Paytype_PrepayWeixin)
        }
            break;
        case UniformPaymentTypeAlipayWap:
        {
            // 使用支付宝wap支付订单，暂无
            [[UniformWapAlipayModel shared] beginForType:UniformFromTypeGroupon];
            UMENG_EVENT(UEvent_Groupon_Paytype_PrepayAlipayWap)
        }
            break;
        case UniformPaymentTypeAlipay:
        {
            // 使用支付宝客户端支付订单
            [[UniformAlipayModel shared] beginForType:UniformFromTypeGroupon];
            UMENG_EVENT(UEvent_Groupon_Paytype_PrepayAlipayApp)
        }
            break;
            
        default:
            break;
    }
}


// 校验数据正确性
- (NSString *)checkData
{
    if (!caTable.useCashAccount &&
        payTable.selectedPayType == UniformPaymentTypeNone)
    {
        return @"请选择支付方式";
    }
    
    if (caTable.useCashAccount)
    {
        if (caTable.needCAPassword &&
            caTable.passwordField.text.length == 0)
        {
            return @"请输入支付密码";
        }
    }
    
    return nil;
}


// 发起校验CA密码的请求
- (void)checkCAPassword:(NSString *)pwd
{
    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq verifyCashAccountPwdWithPwd:pwd] delegate:self];
}


// 刷新支付方式
- (void)refreshPayMethod
{
    [refreshView loadingStarWithStyle:UIActivityIndicatorViewStyleGray];
    
    NSNumber *bizType = nil;
    switch (fromType)
    {
        case UniformFromTypeGroupon:
            bizType = GROUPON_BIZTYPE;
            break;
        case UniformFormTypeRentCar:
            bizType = RENTCAR_BIZTYPE;
        default:
            break;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         CHANNEL_BIZTYPE, channelType_API,
                         bizType, bizType_API,
                         [[AccountManager instanse] cardNo], cardNo_API,
                         @"" , accessToken_API,
                         LANGUAGE_BIZTYPE, language_API,
                         NUMBER(0), productId_API,
                         dataModel.orderID, orderId_API,
                         [NSNumber numberWithFloat:dataModel.orderTotalMoney], orderAmount_API,
                         dataModel.tradeToken, tradeToken_API, nil];
    
    if (payMethodUtil)
    {
        [payMethodUtil cancel];
        payMethodUtil = nil;
    }
    
    NSString *paramJson = [dic JSONString];
    
    NSString *url = [PublicMethods composeNetSearchUrl:API_DOMAIN_myelong_Payment forService:API_FUNCTION_getPayProdsByOrderId andParam:paramJson];
    payMethodUtil = [[HttpUtil alloc] init];
    [payMethodUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
}

#pragma mark - Http Delegate

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == payMethodUtil)
    {
        [refreshView loadingEnd];
        return;
    }
}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if (util == payMethodUtil)
    {
        // 获取支付方式
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            [refreshView loadingEnd];
            return;
        }
        
        // 清空之前的支付方式，确保数据正确性
        [dataModel.paymethods removeAllObjects];
        [dataModel.banksOfCreditCard removeAllObjects];
        [dataModel.nonCABanksOfCreditCard removeAllObjects];
        
        [dataModel.paymethods addObject:[NSNumber numberWithInt:UniformPaymentTypeCreditCard]];     // 构造支付方式，信用卡是必有，其它看api返回
        BOOL creditCardSupportCA = NO;      // 标记是否有信用卡支持CA
        
        NSArray *paymentTags = [root safeObjectForKey:paymentTags_API];
        
        if (ARRAYHASVALUE(paymentTags))
        {
            for (NSDictionary *partDic in paymentTags)
            {
                // 先取出支付方式大模块
                if (DICTIONARYHASVALUE(partDic))
                {
                    NSArray *paymentTypes = [partDic safeObjectForKey:paymentTypes_API];
                    if (ARRAYHASVALUE(paymentTypes))
                    {
                        for (NSDictionary *subPartDic in paymentTypes)
                        {
                            if (DICTIONARYHASVALUE(subPartDic))
                            {
                                // 再取出下一级的支付方式集合
                                NSArray *paymentProducts = [subPartDic safeObjectForKey:paymentProducts_API];
                                if (ARRAYHASVALUE(paymentProducts))
                                {
                                    for (NSDictionary *paymentMethodDic in paymentProducts)
                                    {
                                        // 最后取出支付方式的实体对象
                                        if (DICTIONARYHASVALUE(paymentMethodDic))
                                        {
                                            if ([[paymentMethodDic safeObjectForKey:productCode_API] isEqualToString:@"0000"] &&
                                                [[paymentMethodDic safeObjectForKey:productSubCode_API] isEqualToString:@"0"])
                                            {
                                                // 如果支付对象是信用卡的银行，纪录数据，不作为和其它支付方式平级的展示
                                                [dataModel.banksOfCreditCard addObject:paymentMethodDic];
                                                
                                                if ([[paymentMethodDic safeObjectForKey:supportCA_API] safeBoolValue])
                                                {
                                                    // 只要有一张信用卡支持CA，就可以让CA与信用卡混合支付
                                                    creditCardSupportCA = YES;
                                                }
                                                else
                                                {
                                                    // 不支持CA的银行纪录入另一个数组，目前只记银行名称
                                                    [dataModel.nonCABanksOfCreditCard addObject:[paymentMethodDic safeObjectForKey: productNameCN_API]];
                                                }
                                            }
                                            else
                                            {
                                                if ([[paymentMethodDic objectForKey:productCode_API] isEqualToString:@"4201"] &&
                                                    [[paymentMethodDic objectForKey:productSubCode_API] isEqualToString:@"4307"])
                                                {
                                                    // 添加支付宝App支付方式
                                                    [dataModel.paymethods addObject:NUMBER(UniformPaymentTypeAlipay)];
                                                    
                                                    if ([[paymentMethodDic objectForKey:supportCA_API] safeBoolValue])
                                                    {
                                                        [dataModel.caSupportPaymethods addObject:NUMBER(UniformPaymentTypeAlipay)];
                                                    }
                                                    
                                                    [dataModel.thirdPaymentDataDic setObject:paymentMethodDic forKey:Third_AlipayPayment];
                                                }
                                                
                                                if ([[paymentMethodDic objectForKey:productCode_API] isEqualToString:@"4201"] &&
                                                    [[paymentMethodDic objectForKey:productSubCode_API] isEqualToString:@"4308"])
                                                {
                                                    // 添加支付宝Wap支付方式
                                                    [dataModel.paymethods addObject:NUMBER(UniformPaymentTypeAlipayWap)];
                                                    
                                                    if ([[paymentMethodDic objectForKey:supportCA_API] safeBoolValue])
                                                    {
                                                        [dataModel.caSupportPaymethods addObject:NUMBER(UniformPaymentTypeAlipayWap)];
                                                    }
                                                    
                                                    [dataModel.thirdPaymentDataDic setObject:paymentMethodDic forKey:Third_WapAlipayPayment];
                                                }
                                                
                                                if ([[paymentMethodDic objectForKey:productCode_API] isEqualToString:@"4222"] &&
                                                    [[paymentMethodDic objectForKey:productSubCode_API] isEqualToString:@"4311"])
                                                {
                                                    // 添加微信App支付方式
                                                    [dataModel.paymethods addObject:NUMBER(UniformPaymentTypeWeixin)];
                                                    if ([[paymentMethodDic objectForKey:supportCA_API] safeBoolValue])
                                                    {
                                                        [dataModel.caSupportPaymethods addObject:NUMBER(UniformPaymentTypeWeixin)];
                                                    }
                                                    
                                                    [dataModel.thirdPaymentDataDic setObject:paymentMethodDic forKey:Third_WeixinPayment];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if (creditCardSupportCA)
        {
            [dataModel.caSupportPaymethods addObject:NUMBER(UniformPaymentTypeCreditCard)];
        }
        
        payTable = [[PaymentTypeTable alloc] initWithPaymentTypes:dataModel.paymethods];
        caTable.tableFooterView = payTable;
        NSLog(@"＝＝＝%@", root);
    }
    else
    {
        if ([Utils checkJsonIsError:root])
        {
            return;
        }
        
        if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
        {
            // 校验密码成功
            [self dealPayProgress];
        }
        else
        {
            // 发送验密成功失败
            [PublicMethods showAlertTitle:@"密码错误" Message:@"请检查"];
        }
    }
}


#pragma mark - Notification

- (void)notiClickDetailBtn:(NSNotification *)noti
{
    BOOL showPassengerDetail = [[noti object] boolValue];
    
    FlightOrderConfirmView *flightView = (FlightOrderConfirmView *)caTable.tableHeaderView;
    if (showPassengerDetail)
    {
        [flightView showPassengers];
    }
    else
    {
        [flightView hiddenPassengers];
    }
    
    caTable.tableHeaderView = flightView;
}


- (void)notiWXPaySuccess
{
    if (fromType == UniformFromTypeGroupon)
    {
        needCheckPayState = NO;
        
        // 进入团购成功页面
        GrouponSuccessController *controller = [[GrouponSuccessController alloc] initWithOrderID:[dataModel.orderID intValue] payType:GrouponOrderPayTypeCreditCard];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    UMENG_EVENT(UEvent_Groupon_OrderSuccess)
}


- (void)notiWapAlipayPaySuccess
{
    if (fromType == UniformFromTypeGroupon)
    {
        needCheckPayState = NO;
        
        // 进入团购成功页面
        GrouponSuccessController *controller = [[GrouponSuccessController alloc] initWithOrderID:[dataModel.orderID intValue] payType:GrouponOrderPayTypeCreditCard];
        [self.navigationController pushViewController:controller animated:NO];
    }
}


- (void)notiAlipayPaySuccess
{
    if (fromType == UniformFromTypeGroupon)
    {
        needCheckPayState = NO;
        
        // 进入团购成功页面
        GrouponSuccessController *controller = [[GrouponSuccessController alloc] initWithOrderID:[dataModel.orderID intValue] payType:GrouponOrderPayTypeCreditCard];
        [self.navigationController pushViewController:controller animated:NO];
    }
}


- (void)notiByAppActived:(NSNotification *)noti
{
    // 如果当前流程是团购流程，需要对支付金额进行刷新
    if (fromType == UniformFromTypeGroupon)
    {
        if (needCheckPayState)
        {
            ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
            if ([appDelegate.navigationController.topViewController isKindOfClass:[SelectCard class]] ||
                [appDelegate.navigationController.topViewController isKindOfClass:[AddAndEditCard class]])
            {
                // 如果App切到前台时是处于信用卡选择页或者新增信用卡页，让它们返回到统一收银台页再刷新订单价格
                [appDelegate.navigationController popToViewController:self animated:NO];
            }
            
            if ([appDelegate.navigationController.visibleViewController isEqual:self])
            {
                // 如果仍处于当前页面的话，刷新状态
                dataModel.delegate = self;
                [dataModel refreshDataWithOrderID:dataModel.orderID tradeToken:dataModel.tradeToken bizType:GROUPON_BIZTYPE];
            }
        }
    }
}


- (void)uniformCounterDataDidRefresh
{
    self.totalPrice = dataModel.orderTotalMoney;
    ;
    self.cashAccountAvailable = dataModel.canUseCA;
    
    // 添加价格展示和CA支付选择项，主界面
    caTable.totalPrice = totalPrice;
    [caTable setCASwitchOpen:dataModel.canUseCA];
    
    if (dataModel.waitingPayMoney == 0)
    {
        if (fromType == UniformFromTypeGroupon)
        {
            // 如果已经付完所有金额，直接往成功页面跳转
            GrouponSuccessController *ctr = [[GrouponSuccessController alloc] initWithOrderID:[dataModel.orderID intValue] payType:GrouponOrderPayTypeCreditCard];
            [self.navigationController pushViewController:ctr animated:YES];
        }
    }
}


@end
