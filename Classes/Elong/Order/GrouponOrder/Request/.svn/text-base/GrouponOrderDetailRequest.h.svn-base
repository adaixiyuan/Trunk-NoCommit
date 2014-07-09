//
//  GrouponOrderDetailRequest.h
//  ElongClient
//
//  Created by Ivan.xu on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GrouponOrderDetailRequestDelegate <NSObject>

@optional
-(void)executeGotoGrouponDetailPageResult:(NSDictionary *)result;       //查看团购详情
-(void)executeCanAppointResult:(NSDictionary *)result;      //预约结果
-(void)executeAddPassbookResultData:(NSData *)resultData; //执行呢增加passbook结果
-(void)executeCancelOrder:(NSDictionary *)result;   //退款请求
-(void)executeCancelQuan:(NSDictionary *)quan;  //退券请求
-(void)executeSendMsgResult:(NSDictionary *)result;     //执行发送短信请求
-(void)executeGetPayDespFailed;     //获取支付方式失败
-(void)executeGetPayDespResult:(NSDictionary *)result;      //获取支付方式成功

@end

@interface GrouponOrderDetailRequest : NSObject<HttpUtilDelegate>

-(id)initWithDelegate:(id<GrouponOrderDetailRequestDelegate>)aDelegate;
-(void)startRequestForGrouponDetail:(NSString *)prodId;      //访问团购详情
-(void)startRequestForAppointInfo:(NSNumber *)prodId;      //访问预约信息
-(void)startRequestForAddPassbook:(NSString *)orderId;      //添加Passbook请求
-(void)startRequestForCancelOrder:(NSNumber *)orderId prodId:(NSNumber *)prodId quanIds:(NSArray *)quanIds;     //取消订单
-(void)startRequestForCancelQuanByOrderId:(NSNumber *)orderId prodId:(NSNumber *)prodId quanIds:(NSArray *)quanIds;      //取消券
-(void)startRequestForSendMsgByPhoneNum:(NSString *)phoneNum orderId:(NSNumber *)orderId quanId:(NSNumber *)quanId;   //发生短信
-(void)startRequestForGetPayDespByOrder:(NSDictionary *)anOrder;

@end
