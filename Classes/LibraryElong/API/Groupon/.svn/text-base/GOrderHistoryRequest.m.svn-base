//
//  GOrderHistoryRequest.m
//  ElongClient
//	团购订单列表请求
//
//  Created by haibo on 11-11-28.
//  Copyright 2011 elong. All rights reserved.
//

#import "GOrderHistoryRequest.h"
#import "AccountManager.h"
#import "TimeUtils.h"


static GOrderHistoryRequest *request;

@implementation GOrderHistoryRequest
@synthesize contents;

- (void)dealloc {
	[contents release];
	[request  release];
	
	[super dealloc];
}


+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[GOrderHistoryRequest alloc] init];
		}
	}
	
	return request;
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					[PostHeader header], Resq_Header,
					NUMBER(0), ORDERID_GROUPON,
					NUMBER(50), PAGE_SIZE_,
					NUMBER(0), PAGE_INDEX,
					/*[TimeUtils makeJsonDateWithUTCDate:[NSDate dateWithTimeIntervalSinceNow:- 86400 * 365]], START_TIME,
					[TimeUtils makeJsonDateWithUTCDate:[NSDate date]], END_TIME,*/ nil];
	}
	
	return self;
}


- (void)reset{
    [contents safeSetObject:NUMBER(0) forKey:PAGE_INDEX];
}


- (void)refreshData {
	[contents safeSetObject:NUMBER(0) forKey:ORDERID_GROUPON];
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
}


- (NSString *)grouponListOrderCompress:(BOOL)animated {
	return [NSString stringWithFormat:@"action=GetOrderByCardNo&compress=%@&req=%@",
			[NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],
			[contents JSONRepresentationWithURLEncoding]];
}


@end
