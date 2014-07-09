//
//  GrouponOrderPaymentFlowRequest.h
//  ElongClient
//
//  Created by Ivan.xu on 14-4-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GrouponOrderPaymentFlowDelegate <NSObject>

@optional
-(void)executePaymentFlow:(NSDictionary *)result;

@end

@interface GrouponOrderPaymentFlowRequest : NSObject<HttpUtilDelegate>

-(id)initWithDelegate:(id<GrouponOrderPaymentFlowDelegate>)aDelegate;
-(void)startRequestForGrouponOrderPaymentFlow:(NSDictionary *)anOrder;      //访问团购支付流程可视化

@end
