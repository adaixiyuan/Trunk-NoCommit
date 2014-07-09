//
//  HotelErrorCCViewController.h
//  ElongClient
//  酒店品牌筛选缓存
//  Created by garin on 14-1-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GListBrandFilterRequest.h"
#import "PostHeader.h"

static GListBrandFilterRequest *request = nil;
static NSInteger MAX_CACHE_NUM  = 6;				// 最多存储的区域信息数量
static NSInteger MAX_CACHE_TIME = 3600;				// 最大缓存时间

@implementation GListBrandFilterRequest

- (void)dealloc {
	[request release];
	[managerQueue release];
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
        managerQueue = [[NSMutableArray alloc] initWithCapacity:2];
	}
	
	return self;
}


#pragma mark -
#pragma mark PublicMethods

+ (id)shared {
	@synchronized(self) {
		if (!request) {
			request = [[GListBrandFilterRequest alloc] init];
		}
	}
	
	return request;
}

- (void)setBrandInfo:(NSDictionary *)infoDic forCity:(NSString *)city {
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


- (NSDictionary *)getBrandInfoForCity:(NSString *)city {
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

@end
