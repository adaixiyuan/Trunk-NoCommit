//
//  NHotelOrderReq.h
//  ElongClient
//  非会员订单状态请求
//
//  Created by 赵 海波 on 12-6-7.
//  Copyright 2012 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	NOrderStateHotel = 0,
	NOrderStateFlight = 1,
	NOrderStateGroupon = 2
}NOrderState;

@interface NHotelOrderReq : NSObject {
@private
	NSMutableDictionary *contents;
}

+ (id)shared;

- (void)clearData;
- (void)setOrderState:(NOrderState)state;						// 设置非会员订单查询类型
- (NSString *)requestOrderStateWithOrders:(NSArray *)orderArray;

@end
