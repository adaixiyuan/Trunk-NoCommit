//
//  GrouponOrderPaymentFlowRequest.m
//  ElongClient
//
//  Created by Ivan.xu on 14-4-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponOrderPaymentFlowRequest.h"

@interface GrouponOrderPaymentFlowRequest ()

@property (nonatomic,assign) id<GrouponOrderPaymentFlowDelegate> delegate;
@property (nonatomic,retain) HttpUtil *paymentFlowUtil;

@end

@implementation GrouponOrderPaymentFlowRequest

- (void)dealloc
{
    [_paymentFlowUtil cancel];
    [_paymentFlowUtil release];
    [super dealloc];
}

-(id)initWithDelegate:(id<GrouponOrderPaymentFlowDelegate>)aDelegate{
    self = [super init];
    if(self){
        _delegate = aDelegate;
        _paymentFlowUtil = [[HttpUtil alloc] init];
    }
    return self;
}

//访问团购支付流程可视化
-(void)startRequestForGrouponOrderPaymentFlow:(NSDictionary *)anOrder{
    NSString *orderNo = [anOrder safeObjectForKey:@"OrderID"];
    NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:orderNo,@"OrderId",[NSNumber numberWithInt:1006],@"BusinessType",nil]; //1006代表的是团购业务线
    NSString *paramJson = [reqDictInfo JSONString];
    
    // 发起请求Get请求
    NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"transInfoList" andParam:paramJson];
    [self.paymentFlowUtil requestWithURLString:url Content:nil Delegate:self];
}

#pragma mark - HttpUtil delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if(util == self.paymentFlowUtil){
        if([Utils checkJsonIsError:root]){
            return;
        }
        
        if([_delegate respondsToSelector:@selector(executePaymentFlow:)]){
            [_delegate executePaymentFlow:root];     //查询成功处理
        }
    }
}

@end
