//
//  UniformWeiXinModel.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UniformWeiXinModel.h"
#import "HotelPostManager.h"
#import "ConfirmHotelOrder.h"
#import "GrouponConfirmViewController.h"
#import "UniformCounterDataModel.h"

static UniformWeiXinModel *model = nil;

@implementation UniformWeiXinModel

+ (id)shared
{
    @synchronized(model)
    {
        if (!model)
        {
            model = [[UniformWeiXinModel alloc] init];
        }
    }
    
    return model;
}


- (void)beginForType:(UniformFromType)type
{
    switch (type) {
        case UniformFromTypeHotel:
        {
            // 微信国内酒店支付
            [self dealNativeHotel];
        }
            break;
        case UniformFromTypeGroupon:
        {
            // 微信团购支付
            [self dealGroupon];
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

- (void)dealNativeHotel
{
    [[HotelPostManager hotelorder] setAlipayInfo:@"weixin:return" withCancelURL:@"weixin:back" withName:@"hotel" withBody:@"hotel"];
    
    // 设置支付类型
    [[HotelPostManager hotelorder] setVouch:VouchSetTypeWeiXinPayByApp vouchMoney:[[HotelPostManager hotelorder] getTotalPrice]];
    
    hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
    hotelconfirmorder.payType = VouchSetTypeWeiXinPayByApp;
    [hotelconfirmorder nextState];
}


- (void)dealGroupon
{
    if(![WXApi isWXAppInstalled]){
        [PublicMethods showAlertTitle:nil Message:@"未发现微信客户端，请您更换别的支付方式或下载微信"];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        [PublicMethods showAlertTitle:nil Message:@"您微信客户端版本过低，请您更换别的支付方式或更新微信"];
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
        
        // 设置微信支付参数
        NSDictionary *dcDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               NUMBER(4222), payment_provider_id_API,
                               dataModel.orderID, order_id_API,
                               [NSNumber numberWithFloat:dataModel.waitingPayMoney], dc_amt_API,
                               NUMBER(0), dc_customer_service_amt_API,
                               NUMBER(4601), dc_currency_API,
                               NUMBER(4311), payment_method_API,
                               NUMBER(0), external_bank_id_API,
                               grouponName, subject_API,
                               grouponName, body_API,
                               @"elongIPhone://", return_url_API,
                               @"elongIPhone://", cancel_url_API, nil];
        [mutDict safeSetObject:dcDic forKey:dc_API];
        [mutDict safeSetObject:[[dataModel.thirdPaymentDataDic safeObjectForKey:Third_WeixinPayment] safeObjectForKey:productId_API] forKey:payment_product_id_API];
        NSLog(@"WWWXXX:%@", mutDict);
        
        NSString *url = [HttpUtil javaAPIPostReqInDomain:API_DOMAIN_myelong_Pay atFunction:API_FUNCTION_pay];
        [HttpUtil requestURL:url postContent:[mutDict JSONString] delegate:self];
    }
}


#pragma mark - Http Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return;
    }
    
    NSString *WXPath = [root safeObjectForKey:pay_url_API];
    if (STRINGHASVALUE(WXPath))
    {
        PayReq *req = [[PayReq alloc] init];
        NSDictionary *dict = [WXPath JSONValue];
        req.partnerId = [dict objectForKey:@"partnerId"];
        req.prepayId = [dict objectForKey:@"prepayId"];
        req.package = [dict objectForKey:@"package"];
        req.sign = [dict objectForKey:@"sign"];
        req.nonceStr = [dict objectForKey:@"nonceStr"];
        req.timeStamp = [[dict objectForKey:@"timeStamp"] longLongValue];
        [WXApi safeSendReq:req];
    }
}

@end
