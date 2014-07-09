//
//  GListFilterRequest.m
//  ElongClient
//  
//
//  Created by 赵 海波 on 12-3-13.
//  Copyright 2012 elong. All rights reserved.
//

#import "GListFilterRequest.h"
#import "PostHeader.h"

static GListFilterRequest *request = nil;
static NSInteger MAX_CACHE_NUM  = 6;				// 最多存储的区域信息数量
static NSInteger MAX_CACHE_TIME = 3600;				// 最大缓存时间

@implementation GListFilterRequest

- (void)dealloc {
	[contents		release];
	[request		release];
	[managerQueue	release];
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithCapacity:2];
		[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
        [contents safeSetObject:[NSNumber numberWithBool:YES] forKey:@"IsContainSubwayStations"];
        [contents safeSetObject:[NSNumber numberWithBool:YES] forKey:@"IsContainAirportRailways"];
        [contents safeSetObject:[NSNumber numberWithBool:YES] forKey:@"isContainCategories"];
		
		managerQueue = [[NSMutableArray alloc] initWithCapacity:2];
	}
	
	return self;
}


#pragma mark -
#pragma mark PublicMethods

+ (id)shared {
	@synchronized(self) {
		if (!request) {
			request = [[GListFilterRequest alloc] init];
		}
	}
	
	return request;
}


- (void)setCurrentCity:(NSString *)city {
	[contents safeSetObject:city forKey:CITYNAME_GROUPON];
}


- (void)setAreaInfo:(NSDictionary *)infoDic forCity:(NSString *)city {
	if ([managerQueue count] >= MAX_CACHE_NUM) {
		// 信息过多时，清除队列中的第一个对象
		[managerQueue removeObjectAtIndex:0];
	}
	
	NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSDate date], TIME_GROUPON,
							  city, CITYNAME_GROUPON,
							  infoDic, VALUE_GROUPON, nil];
	[managerQueue addObject:paramDic];
}


- (NSDictionary *)getAreaInfoForCity:(NSString *)city {
	for (NSDictionary *paramDic in managerQueue) {
		if ([[paramDic safeObjectForKey:CITYNAME_GROUPON] isEqualToString:city]) {
			NSDate *preDate = [paramDic safeObjectForKey:TIME_GROUPON];
			if ([preDate timeIntervalSinceNow] < -MAX_CACHE_TIME) {
				// 超过指定时间范围时，清除该数据
				[managerQueue removeObject:paramDic];
				return nil;
			}
			else {
				// 返回数据
				return [paramDic safeObjectForKey:VALUE_GROUPON];
			}
		}
	}
	
	return nil;
}


- (NSString *)grouponFilterAreaRequest {
	return [NSString stringWithFormat:@"action=GetGrouponDistrictBizList&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}

@end
