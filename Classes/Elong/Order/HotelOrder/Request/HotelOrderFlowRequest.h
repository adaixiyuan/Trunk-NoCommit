//
//  HotelOrderFlowRequest.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HotelOrderFlowRequestDelgate;
@interface HotelOrderFlowRequest : NSObject<HttpUtilDelegate>{
    HttpUtil *_orderFlowUtil;        //订单处理日志查询
    
    id<HotelOrderFlowRequestDelgate> _delegate;
}

-(id)initWithDelegate:(id<HotelOrderFlowRequestDelgate>)aDelegate;

-(void)startRequestWithLookOrderFlow:(NSDictionary *)anOrder;       //查询订单处理日志

@end


@protocol HotelOrderFlowRequestDelgate <NSObject>

@optional
-(void)executeOrderFlowResult:(NSDictionary *)result;       //查看订单处理日志

@end
