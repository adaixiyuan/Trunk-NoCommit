//
//  GrouponOrderDetailRequest.m
//  ElongClient
//
//  Created by Ivan.xu on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponOrderDetailRequest.h"
#import "GDetailRequest.h"
#import "ElongURL.h"
#import "GouponRefundRequest.h"
#import "GGetCouponPassword.h"
#import "GListRequest.h"

@interface GrouponOrderDetailRequest ()

@property (nonatomic,assign) id<GrouponOrderDetailRequestDelegate> delegate;
@property (nonatomic,retain) HttpUtil *grouponDetailUtil;
@property (nonatomic,retain) HttpUtil *appointUtil;
@property (nonatomic,retain) HttpUtil *passUtil;
@property (nonatomic,retain) HttpUtil *cancelOrderUtil;
@property (nonatomic,retain) HttpUtil *cancelQuanUtil;
@property (nonatomic,retain) HttpUtil *sendMsgUtil;
@property (nonatomic,retain) HttpUtil *payDespUtil;           //支付方式请求

@end

@implementation GrouponOrderDetailRequest

-(void)dealloc{
    [_grouponDetailUtil cancel];
    [_grouponDetailUtil release];
    
    [_appointUtil cancel];
    [_appointUtil release];
    
    [_passUtil cancel];
    [_passUtil release];
    
    [_cancelOrderUtil cancel];
    [_cancelOrderUtil release];
    
    [_cancelQuanUtil cancel];
    [_cancelQuanUtil release];
    
    [_sendMsgUtil cancel];
    [_sendMsgUtil release];
    
    [_payDespUtil cancel];
    [_payDespUtil release];
    
    [super dealloc];
}

-(id)initWithDelegate:(id<GrouponOrderDetailRequestDelegate>)aDelegate{
    self = [super init];
    if(self){
        _delegate = aDelegate;
        _grouponDetailUtil = [[HttpUtil alloc] init];
        _appointUtil = [[HttpUtil alloc] init];
        _passUtil = [[HttpUtil alloc] init];
        _cancelQuanUtil = [[HttpUtil alloc] init];
        _cancelOrderUtil = [[HttpUtil alloc] init];
        _sendMsgUtil = [[HttpUtil alloc] init];
        _payDespUtil = [[HttpUtil alloc] init];
    }
    return self;
}

//团购详情
-(void)startRequestForGrouponDetail:(NSString *)prodId{
    GDetailRequest *gDReq = [GDetailRequest shared];
	[gDReq setProdId:prodId];
    
    GListRequest *cityListReq	= [GListRequest shared];
    cityListReq.cityName = @"";     //主动置为空
    [_grouponDetailUtil connectWithURLString:GROUPON_SEARCH Content:[gDReq grouponDetailCompress:YES] Delegate:self];
}


//预约详情
-(void)startRequestForAppointInfo:(NSNumber *)prodId{
    GDetailRequest *gDReq = [GDetailRequest shared];
    [gDReq setProdId:[NSString stringWithFormat:@"%d",[prodId intValue]]];
    
    GListRequest *cityListReq	= [GListRequest shared];
    cityListReq.cityName = @"";     //主动置为空
    [_appointUtil sendSynchronousRequest:GROUPON_SEARCH PostContent:[gDReq grouponDetailCompress:YES] CachePolicy:CachePolicyGrouponDetail Delegate:self];
}

   //添加Passbook请求
-(void)startRequestForAddPassbook:(NSString *)orderId{
    NSString *cardNum = [[AccountManager instanse] cardNo];
    NSString *url = [PublicMethods getPassUrlByType:GrouponPass orderID:orderId cardNum:cardNum lat:@"0" lon:@"0"];

    [_passUtil connectWithURLString:url Content:nil Delegate:self];
}

//退款
-(void)startRequestForCancelOrder:(NSNumber *)orderId prodId:(NSNumber *)prodId quanIds:(NSArray *)quanIds{
    GouponRefundRequest *request = [GouponRefundRequest shared];
    [request setRefundOrder:orderId
                       Pord:prodId
                      Quans:quanIds];
    [_cancelOrderUtil connectWithURLString:GROUPON_SEARCH Content:[request getRefundRequest] Delegate:self];
}

//退券
-(void)startRequestForCancelQuanByOrderId:(NSNumber *)orderId prodId:(NSNumber *)prodId quanIds:(NSArray *)quanIds{
    GouponRefundRequest *request = [GouponRefundRequest shared];
    [request setRefundOrder:orderId
                       Pord:prodId
                      Quans:quanIds];
    [_cancelQuanUtil connectWithURLString:GROUPON_SEARCH Content:[request getRefundRequest] Delegate:self];
}

//发送短信
-(void)startRequestForSendMsgByPhoneNum:(NSString *)phoneNum orderId:(NSNumber *)orderId quanId:(NSNumber *)quanId{
    GGetCouponPassword *getPasReq = [GGetCouponPassword shared];
	[getPasReq setPhone:phoneNum];
	[getPasReq setOrderID:orderId];
	[getPasReq setCouponId:quanId];
    
    [_sendMsgUtil connectWithURLString:GROUPON_SEARCH Content:[getPasReq grouponSetMessageCompress:YES] Delegate:self];
}

//获取支付方式
-(void)startRequestForGetPayDespByOrder:(NSDictionary *)anOrder{
    NSString *orderNo = [anOrder safeObjectForKey:@"OrderID"];
    NSString *tradeToken = [NSString stringWithFormat:@"%lld",[[anOrder safeObjectForKey:@"TradeNo"] longLongValue]];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         GROUPON_BIZTYPE, bizType_API,
                         orderNo, orderId_API,
                         tradeToken, tradeToken_API, nil];
    
    NSString *paramJson = [dic JSONString];
    
    NSString *url = [PublicMethods composeNetSearchUrl:API_DOMAIN_myelong_Pay forService:API_FUNCTION_getDefrayDetail andParam:paramJson];
    
    [self.payDespUtil requestWithURLString:url Content:nil Delegate:self];
}


#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if(util == _passUtil){
        if (!responseData) {
            [PublicMethods showAlertTitle:@"Pass文件生成失败" Message:nil];
            return;
        }
        //增加Passbook 请求
        if([_delegate respondsToSelector:@selector(executeAddPassbookResultData:)]){
            [_delegate executeAddPassbookResultData:responseData];
        }
    }else if(util == self.payDespUtil){
        if([Utils checkJsonIsErrorNoAlert:root]){
            if([_delegate respondsToSelector:@selector(executeGetPayDespFailed)]){
                [_delegate executeGetPayDespFailed];
            }
            return;
        }else{
            if([_delegate respondsToSelector:@selector(executeGetPayDespResult:)]){
                [_delegate executeGetPayDespResult:root];
            }
        }
    }
    else{
        if([Utils checkJsonIsError:root]){
            return;
        }
        
        if(util == self.grouponDetailUtil){
            if([_delegate respondsToSelector:@selector(executeGotoGrouponDetailPageResult:)]){
                [_delegate executeGotoGrouponDetailPageResult:root];     //查询成功处理
            }
        }else if(util == self.appointUtil){
            if([_delegate respondsToSelector:@selector(executeCanAppointResult:)]){
                [_delegate executeCanAppointResult:root];     //预约接口
            }
        }else if(util == self.cancelQuanUtil){
            if([_delegate respondsToSelector:@selector(executeCancelQuan:)]){
                [_delegate executeCancelQuan:root];     //退券
            }
        }else if(util == self.cancelOrderUtil){
            if([_delegate respondsToSelector:@selector(executeCancelOrder:)]){
                [_delegate executeCancelOrder:root];     //退款
            }
        }else if(util == self.sendMsgUtil){
            if([_delegate respondsToSelector:@selector(executeSendMsgResult:)]){
                [_delegate executeSendMsgResult:root];     //发送短信
            }
        }
    }
    
}


@end
