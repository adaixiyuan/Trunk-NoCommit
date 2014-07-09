//
//  UniformAlipayModel.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UniformAlipayModel.h"
#import "GrouponConfirmViewController.h"
#import "FlightOrderConfirm.h"
#import "ConfirmHotelOrder.h"
#import "UniformCounterDataModel.h"
#import "AlixPay.h"

static UniformAlipayModel *model = nil;

@implementation UniformAlipayModel


+ (id)shared {
    @synchronized(model)
    {
        if (!model)
        {
            model = [[UniformAlipayModel alloc] init];
        }
    }
    
    return model;
}


- (void)beginForType:(UniformFromType)type
{
    switch (type)
    {
        case UniformFromTypeGroupon:
        {
            // 支付宝客户端团购支付
            [self dealGroupon];
        }
            break;
        case UniformFromTypeFlight:
        {
            // 支付宝客户端支付机票
            [self dealFlight];
        }
            break;
        case UniformFromTypeHotel:{
            // 支付宝客户端支付酒店
            [self dealHotel];
        }
            break;
        default:
            break;
    }
}


- (id)init
{
    if (self = [super init])
    {
        dataModel = [UniformCounterDataModel shared];
    }
    
    return self;
}


#pragma mark - Model Methods

- (void)dealGroupon
{
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]])
    {
        [PublicMethods showAlertTitle:nil Message:@"未发现支付宝客户端，请您更换别的方式或下载支付宝"];
        return;
    }
    
    NSMutableDictionary *mutDict = [dataModel getUniformPayData:UniformFromTypeGroupon];
    
    if (DICTIONARYHASVALUE(mutDict))
    {
        NSString *grouponName = @"";
        if (ARRAYHASVALUE(dataModel.titlesArray))
        {
            grouponName = [NSString stringWithFormat:@"%@", [dataModel.titlesArray objectAtIndex:0]];
        }

        // 设置支付宝支付参数
        NSDictionary *dcDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               NUMBER(4201), payment_provider_id_API,
                               dataModel.orderID, order_id_API,
                               [NSNumber numberWithFloat:dataModel.waitingPayMoney], dc_amt_API,
                               NUMBER(0), dc_customer_service_amt_API,
                               NUMBER(4601), dc_currency_API,
                               NUMBER(4307), payment_method_API,
                               NUMBER(0), external_bank_id_API,
                               grouponName, subject_API,
                               grouponName, body_API,
                               @"elongIPhone://", return_url_API,
                               @"elongIPhone://", cancel_url_API, nil];
        [mutDict safeSetObject:dcDic forKey:dc_API];
        [mutDict safeSetObject:[[dataModel.thirdPaymentDataDic safeObjectForKey:Third_AlipayPayment] safeObjectForKey:productId_API] forKey:payment_product_id_API];
        
        NSString *url = [HttpUtil javaAPIPostReqInDomain:API_DOMAIN_myelong_Pay atFunction:API_FUNCTION_pay];
        [HttpUtil requestURL:url postContent:[mutDict JSONString] delegate:self];
    }
}

- (void) dealHotel{
    // 设置酒店下单支付宝参数
    [[HotelPostManager hotelorder] setAlipayInfo:@"alipay:return" withCancelURL:@"alipay:back" withName:@"hotel" withBody:@"pay"];
    [[HotelPostManager hotelorder] setVouch:VouchSetTypeAlipayApp vouchMoney:[[HotelPostManager hotelorder] getTotalPrice] vouchData:nil];
    
    hotelConfirm = [[ConfirmHotelOrder alloc] init];
    hotelConfirm.payType = VouchSetTypeAlipayApp;
    [hotelConfirm nextState];
}

- (void)dealFlight
{
    controller = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:nil];
    [controller nextState:UniformPaymentTypeAlipay];
}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return;
    }
    
    
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
        NSString *appScheme = @"elongIPhone";
        NSString *orderString = [root safeObjectForKey:pay_url_API];
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        if (ret == kSPErrorSignError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签名错误" message:@"联系服务商" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        
    }//else {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单已被取消，不能再支付！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        [alertView show];
//    }
}

@end
