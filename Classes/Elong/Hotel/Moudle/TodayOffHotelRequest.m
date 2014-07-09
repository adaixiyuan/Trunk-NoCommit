//
//  TodayOffHotelRequest.m
//  ElongClient
//
//  Created by haibo on 12-2-6.
//  Copyright 2012 elong. All rights reserved.
//

#import "TodayOffHotelRequest.h"
#import "PostHeader.h"
#import "AccountManager.h"

static TodayOffHotelRequest *request = nil;

@implementation TodayOffHotelRequest

- (void)dealloc {
	[contents release];
	[request  release];
	
	[super dealloc];
}


+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[TodayOffHotelRequest alloc] init];
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


- (NSString *)requestForCityList {
	[contents removeObjectForKey:CITYNAME_GROUPON];
	
	return [NSString stringWithFormat:@"action=GetLimitTimeCityList&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}


- (NSString *)requestForCity:(NSString *)cityName {
	[contents safeSetObject:cityName forKey:CITYNAME_GROUPON];
    return [NSString stringWithFormat:@"action=GetLimitTimeSaleCity&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}

@end
