//
//  HotelOrderInvoiceFlowRequest.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderInvoiceFlowRequest.h"

@implementation HotelOrderInvoiceFlowRequest


- (void)dealloc
{
    [_orderInvoiceFlowUtil cancel];
    [_orderInvoiceFlowUtil release];
    [super dealloc];
}

-(id)initWithDelegate:(id<HotelOrderInvoiceFlowRequestDelegate>)aDelegate{
    self = [super init];
    if(self){
        _orderInvoiceFlowUtil = [[HttpUtil alloc] init];
        _delegate = aDelegate;
    }
    return self;
}

//查询订单处理日志
-(void)startRequestWithLookOrderInvoiceFlow:(NSDictionary *)anOrder{
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:orderNO,@"OrderNo", nil];
    NSString *paramJson = [reqDictInfo JSONString];
    
    // 发起请求Get请求
    NSString *url = [PublicMethods composeNetSearchUrl:@"hotel" forService:@"getInvoiceDeliveryInfo" andParam:paramJson];
    [_orderInvoiceFlowUtil requestWithURLString:url Content:nil Delegate:self];
}


#pragma mark - httpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if(util == _orderInvoiceFlowUtil){
        if([Utils checkJsonIsError:root]){
            return;
        }
        
        if([_delegate respondsToSelector:@selector(executeOrderInvoiceFlowResult:)]){
            [_delegate executeOrderInvoiceFlowResult:root];     //查询成功处理
        }
    }
}

@end
