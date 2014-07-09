//
//  NHotelOrderReq.m
//  ElongClient
//
//  Created by 赵 海波 on 12-6-7.
//  Copyright 2012 elong. All rights reserved.
//

#import "NHotelOrderReq.h"
#import "PostHeader.h"

static NHotelOrderReq *request = nil;

@implementation NHotelOrderReq

- (void)dealloc {
	[contents release];
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					[PostHeader header], Resq_Header, nil];
	}
	
	return self;
}

#pragma mark -
#pragma mark PublicMethods

+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[NHotelOrderReq alloc] init];
		}
	}
	
	return request;
}


- (void)clearData {
	[contents removeAllObjects];
}


- (void)setOrderState:(NOrderState)state {
	[contents safeSetObject:[NSString stringWithFormat:@"%d", state] forKey:SEARCH_TYPE];
}


- (NSString *)requestOrderStateWithOrders:(NSArray *)orderArray {
	[contents safeSetObject:orderArray forKey:ORDER_IDS];
	
	return [NSString stringWithFormat:@"action=GetOrderStatusByIDs&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}

@end
