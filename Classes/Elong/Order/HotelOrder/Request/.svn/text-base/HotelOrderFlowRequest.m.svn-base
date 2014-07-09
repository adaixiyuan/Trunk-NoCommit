//
//  HotelOrderFlowRequest.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderFlowRequest.h"

@implementation HotelOrderFlowRequest


- (void)dealloc
{
    [_orderFlowUtil cancel];
    [_orderFlowUtil release];
    [super dealloc];
}

-(id)initWithDelegate:(id<HotelOrderFlowRequestDelgate>)aDelegate{
    self = [super init];
    if(self){
        _orderFlowUtil = [[HttpUtil alloc] init];
        _delegate = aDelegate;
    }
    return self;
}

//查询订单处理日志
-(void)startRequestWithLookOrderFlow:(NSDictionary *)anOrder{
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:orderNO,@"OrderNo", nil];
    NSString *paramJson = [reqDictInfo JSONString];
    
    // 发起请求Get请求
    NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"getOrderFlowDetail" andParam:paramJson];
    [_orderFlowUtil requestWithURLString:url Content:nil Delegate:self];
}


#pragma mark - httpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if(util == _orderFlowUtil){
        if([Utils checkJsonIsError:root]){
            return;
        }

        if([_delegate respondsToSelector:@selector(executeOrderFlowResult:)]){
            [_delegate executeOrderFlowResult:root];     //查询成功处理
        }
    }
}

@end
