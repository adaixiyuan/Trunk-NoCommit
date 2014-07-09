//
//  HotelListConfig.m
//  ElongClient
//
//  Created by Dawn on 14-1-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelListConfig.h"

@interface HotelListConfig()

@end

static HotelListConfig *config;
@implementation HotelListConfig

- (id) init{
    if (self = [super init]) {
        
    }
    return self;
}

+ (HotelListConfig *) share{
    @synchronized(config) {
		if (!config) {
			config = [[HotelListConfig alloc] init];
		}
	}
	
	return config;
}
@end
