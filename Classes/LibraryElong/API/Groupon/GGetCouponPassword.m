//
//  GGetCouponPassword.m
//  ElongClient
//  获取团购券密码
//
//  Created by haibo on 11-12-2.
//  Copyright 2011 elong. All rights reserved.
//

#import "GGetCouponPassword.h"
#import "AccountManager.h"

static GGetCouponPassword *request = nil;

@implementation GGetCouponPassword

- (void)dealloc {
	[contents release];
	[request  release];
	
	[super dealloc];
}


+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[GGetCouponPassword alloc] init];
		}
	}
	
	return request;
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					[PostHeader header], Resq_Header, nil];
	}
	
	return self;
}


- (void)setOrderID:(NSNumber *)orderID {
	[contents safeSetObject:orderID forKey:ORDERID_GROUPON];
}


- (void)setPhone:(NSString *)phoneNum {
	[contents safeSetObject:phoneNum forKey:MOBILE];
}


- (void)setCouponId:(NSNumber *)quanID {
	[contents safeSetObject:quanID forKey:QUANID_GROUPON];
}


- (NSString *)grouponSetMessageCompress:(BOOL)animated {
	NSLog(@"request:%@",contents);
	return [NSString stringWithFormat:@"action=SendQuanMsg&compress=%@&req=%@",
			[NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],
			[contents JSONRepresentationWithURLEncoding]];
}


@end
