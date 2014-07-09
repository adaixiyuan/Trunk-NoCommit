//
//  GouponRefundRequest.m
//  ElongClient
//  团购退券请求
//
//  Created by 赵 海波 on 13-3-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GouponRefundRequest.h"
#import "AccountManager.h"

static GouponRefundRequest *request = nil;

@implementation GouponRefundRequest

- (void)dealloc {
	[contents release];
	[request  release];
	
	[super dealloc];
}


+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[GouponRefundRequest alloc] init];
		}
	}
	
	return request;
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					[PostHeader header], Resq_Header,   
					[[AccountManager instanse] cardNo], @"Operator", // 操作人
                    [[AccountManager instanse] cardNo], CARD_NUMBER, // 卡号
                    [[AccountManager instanse] cardNo], @"Confirmor", // 退款确认者
                    [NSNumber numberWithBool:NO], @"IsFromMisr", // 是否从MIS系统退款
                    @"我的行程变更了", @"RefundReason", // 退款原因
                    @"1003", @"RefundReasonID", nil]; // 退款原因ID
	}
	
	return self;
}


- (void)setRefundOrder:(NSNumber *)orderID Pord:(NSNumber *)prodID Quans:(NSArray *)quansArray {
    [contents safeSetObject:orderID forKey:ORDERID_GROUPON];
    [contents safeSetObject:prodID forKey:PRODID_GROUPON];
    [contents safeSetObject:quansArray forKey:QUANID_GROUPONS];
}


- (NSString *)getRefundRequest {
    NSLog(@"action=Refund:%@",contents);
	return [NSString stringWithFormat:@"action=Refund&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}


@end
