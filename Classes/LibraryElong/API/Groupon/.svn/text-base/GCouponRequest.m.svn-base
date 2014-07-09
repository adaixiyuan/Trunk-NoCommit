//
//  GCouponRequest.m
//  ElongClient
//  查询团购券请求
//
//  Created by haibo on 11-12-1.
//  Copyright 2011 elong. All rights reserved.
//

#import "GCouponRequest.h"
#import "AccountManager.h"


static GCouponRequest *request = nil;

@implementation GCouponRequest

- (void)dealloc {
	[contents release];
	[request  release];
	
	[super dealloc];
}


+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[GCouponRequest alloc] init];
		}
	}
	
	return request;
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					[PostHeader header], Resq_Header,
                    [NSNumber numberWithBool:YES], ISSEARCHREFUND,
					[NSNull null], EFFECTSTARTTIME_GROUPON,
					[NSNull null], EFFECTENDTIME_GROUPON,
					NUMBER(4), QSTATUS_GROUPON,
					NUMBER(0), PAGE_SIZE_,
					NUMBER(0), PAGE_INDEX, nil];
	}
	
	return self;
}


- (void)setOrderID:(NSNumber *)orderID {
	[contents safeSetObject:orderID forKey:ORDERID_GROUPON];
}
		

- (void)refreshData {
	NSString *cardNO = [[AccountManager instanse] cardNo] ? [[AccountManager instanse] cardNo] : NONMEMBER_GROUPONCARDNO;
	[contents safeSetObject:cardNO forKey:CARD_NUMBER];
}


- (NSString *)grouponCouponCompress:(BOOL)animated {
	return [NSString stringWithFormat:@"action=GetQuanByCardNo&compress=%@&req=%@",
			[NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],
			[contents JSONRepresentationWithURLEncoding]];
}

@end
