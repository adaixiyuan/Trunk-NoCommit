//
//  HotelOrderDetailRequest.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  HotelOrderDetailRequestDelegate;
@interface HotelOrderDetailRequest : NSObject<HttpUtilDelegate>{
    HttpUtil *_checkFeedbackUtil;
    HttpUtil *_cancelOrderUtil;
    HttpUtil *_editOrderUtil;
    HttpUtil *_feedbackUtil;
    
    HttpUtil *_weixinPayUtil;
    HttpUtil *_alipayClientUtil;
    HttpUtil *_alipayWebUtil;
    
    HttpUtil *_bookingAgainUtil;
    HttpUtil *_passbookUtil;
    
    HttpUtil *_orderFlowUtil;
    
}

@property(nonatomic,assign) id<HotelOrderDetailRequestDelegate> delegate;

-(id)initWithDelegate:(id<HotelOrderDetailRequestDelegate>)aDelegate;
-(void)startRequestWithCheckCanBeFeedback:(NSDictionary *)anOrder;      //检查是否可以反馈
-(void)startRequestWithCancelOrder:(NSDictionary *)anOrder;         //取消订单
-(void)startRequestWithEditOrder;       //修改订单请求
-(void)startRequestWithFeedback;        //入住反馈
-(void)startAgainPayRequestByWeixin:(NSDictionary *)anOrder;       //微信支付
-(void)startAgainPayRequestByAlipayClient:(NSDictionary *)anOrder;      //支付宝客户端支付
-(void)startAgainPayRequestByAlipayWeb:(NSDictionary *)anOrder;     //支付宝网页支付
-(void)startRequestWithBookingAgain:(NSDictionary *)anOrder;        //再次预订
-(void)startRequestWIthAddOrderToPassbook:(NSDictionary *)anOrder;      //增加订单到Passbook
-(void)startRequestWithGetOrderFlowState:(NSDictionary *)anOrder;       //获取订单流程状态
@end


@protocol HotelOrderDetailRequestDelegate <NSObject>

@optional
-(void)executeCheckFeedbackResult:(NSDictionary *)result;   //执行检查入住反馈结果
-(void)executeCancelOrderResult:(NSDictionary *)result;     //执行取消订单结果
-(void)executeFeedbackResult:(NSDictionary *)result;        //执行入住反馈
-(void)executeEditOrderResult:(NSDictionary *)result;       //执行修改订单
-(void)executeAgainPayByWeixinResult:(NSDictionary *)result;        //执行微信再次支付结果
-(void)executeAgainPayByAlipayClientResult:(NSDictionary *)result;        //执行支付宝客户端再次支付结果
-(void)executeAgainPayByAlipayWebResult:(NSDictionary *)result;        //执行支付宝网页再次支付结果
-(void)executeBookingAgainResult:(NSDictionary *)result;        //执行再次预订结果
-(void)executeAddPassbookResultData:(NSData *)resultData; //执行呢增加passbook结果
-(void)executeGetOrderFlowState:(NSDictionary *)result; //执行获取订单流程状态

@end
