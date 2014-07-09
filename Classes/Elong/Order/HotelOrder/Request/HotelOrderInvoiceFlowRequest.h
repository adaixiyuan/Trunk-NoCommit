//
//  HotelOrderInvoiceFlowRequest.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HotelOrderInvoiceFlowRequestDelegate;
@interface HotelOrderInvoiceFlowRequest : NSObject{
    HttpUtil *_orderInvoiceFlowUtil;        //订单发票流程

    id<HotelOrderInvoiceFlowRequestDelegate> _delegate;
}


-(id)initWithDelegate:(id<HotelOrderInvoiceFlowRequestDelegate>)aDelegate;

-(void)startRequestWithLookOrderInvoiceFlow:(NSDictionary *)anOrder;       //查询订单发票流程

@end


@protocol HotelOrderInvoiceFlowRequestDelegate <NSObject>

@optional
-(void)executeOrderInvoiceFlowResult:(NSDictionary *)result;       //查看发票流程

@end
