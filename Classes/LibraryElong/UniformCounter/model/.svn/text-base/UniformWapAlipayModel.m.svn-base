//
//  UniformWapAlipayModel.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UniformWapAlipayModel.h"
#import "HotelPostManager.h"
#import "FlightOrderConfirm.h"
#import "GrouponConfirmViewController.h"
#import "ConfirmHotelOrder.h"
#import "UniformCounterDataModel.h"
#import "GrouponSuccessController.h"

static UniformWapAlipayModel *model = nil;

@implementation UniformWapAlipayModel

+ (id)shared
{
    @synchronized(model)
    {
        if (!model)
        {
            model = [[UniformWapAlipayModel alloc] init];
        }
    }
    
    return model;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)init
{
    if (self = [super init])
    {
        dataModel = [UniformCounterDataModel shared];
        jumpToSafari = NO;
        appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiWapAlipayPaySuccess) name:NOTI_WAPALIPAY_SUCCESS object:nil];
    }
    
    return self;
}


- (void)beginForType:(UniformFromType)type
{
    switch (type) {
        case UniformFromTypeHotel:
        {
            // 支付宝wap酒店支付
            [self dealNativeHotel];
        }
            break;
        case UniformFromTypeGroupon:
        {
            // 支付宝客户端团购支付
            [self dealGroupon];
        }
            break;
        case UniformFromTypeFlight:
        {
            // 支付宝客户端机票支付
            [self dealFlight];
        }
            
        default:
            break;
    }
}


#pragma mark - Model Methods

- (void)dealNativeHotel
{
    // 设置酒店下单支付宝参数
    [[HotelPostManager hotelorder] setAlipayInfo:@"alipay:return" withCancelURL:@"alipay:back" withName:@"hotel" withBody:@"pay"];
    [[HotelPostManager hotelorder] setVouch:VouchSetTypeAlipayWap vouchMoney:[[HotelPostManager hotelorder] getTotalPrice] vouchData:nil];
    
    // 设置支付类型
    hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
    hotelconfirmorder.payType = VouchSetTypeAlipayWap;
    [hotelconfirmorder nextState];
}


- (void)dealGroupon
{
    NSMutableDictionary *mutDict = [dataModel getUniformPayData:UniformFromTypeGroupon];
    // 设置支付宝Wap支付参数
    if (DICTIONARYHASVALUE(mutDict))
    {
        NSString *grouponName = @"";
        if (ARRAYHASVALUE(dataModel.titlesArray))
        {
            grouponName = [NSString stringWithFormat:@"%@", [dataModel.titlesArray objectAtIndex:0]];
        }
        
        NSDictionary *dcDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               NUMBER(4201), payment_provider_id_API,
                               dataModel.orderID, order_id_API,
                               [NSNumber numberWithFloat:dataModel.waitingPayMoney], dc_amt_API,
                               NUMBER(0), dc_customer_service_amt_API,
                               NUMBER(4601), dc_currency_API,
                               NUMBER(4308), payment_method_API,
                               NUMBER(0), external_bank_id_API,
                               grouponName, subject_API,
                               grouponName, body_API,
                               @"elongIPhone://1", return_url_API,
                               @"elongIPhone://0", cancel_url_API, nil];
        [mutDict safeSetObject:dcDic forKey:dc_API];
        [mutDict safeSetObject:[[dataModel.thirdPaymentDataDic safeObjectForKey:Third_WapAlipayPayment] safeObjectForKey:productId_API] forKey:payment_product_id_API];
        
        NSString *url = [HttpUtil javaAPIPostReqInDomain:API_DOMAIN_myelong_Pay atFunction:API_FUNCTION_pay];
        [HttpUtil requestURL:url postContent:[mutDict JSONString] delegate:self];
    }
}


- (void)dealFlight
{
    controller = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:nil];
    [controller nextState:UniformPaymentTypeAlipayWap];
}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return;
    }
    
    NSString *urlString = [root safeObjectForKey:pay_url_API];
    
    if (STRINGHASVALUE(urlString))
    {
        NSRange range = [urlString rangeOfString:@"sign="];
        NSString *prefixString = [urlString substringToIndex:range.location+range.length];
        NSString *signString = [urlString substringFromIndex:range.location+range.length];
        NSString *combineString = [NSString stringWithFormat:@"%@%@",[prefixString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],signString];
        NSURL *url = [NSURL URLWithString:combineString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            // 能用safari打开优先用safari打开
            [[UIApplication sharedApplication] newOpenURL:url];
            jumpToSafari = YES;
        }
        else
        {
            AlipayViewController *alipayVC = [[AlipayViewController alloc] init];
            alipayVC.requestUrl = url;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:alipayVC];

            if (IOSVersion_7) {
                nav.transitioningDelegate = [ModalAnimationContainer shared];
                nav.modalPresentationStyle = UIModalPresentationCustom;
            }
            
            [appDelegate.navigationController presentModalViewController:nav animated:YES];
            
            jumpToSafari = NO;
        }
    }
    else
    {
        [PublicMethods showAlertTitle:@"获取支付地址失败" Message:@"请重试"];
    }
}


- (void)notiWapAlipayPaySuccess
{
    // 如果已经收到支付宝的成功回调，那么不再给用户弹框
    jumpToSafari = NO;
}


#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 != buttonIndex)
    {
        // 发送支付程功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WAPALIPAY_SUCCESS object:nil];
    }
}


@end
