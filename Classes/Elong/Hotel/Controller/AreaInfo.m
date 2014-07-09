//
//  AreaInfo.m
//  ElongClient
//
//  Created by Haibo Zhao on 11-8-11.
//  Copyright 2011年 eLong. All rights reserved.
//

#import "AreaInfo.h"

NSString *const district    = @"District";
NSString *const commercial  = @"Commercial";  

@implementation AreaInfo

static AreaInfo *areaInfo = nil;


- (void)dealloc {
	[areaInfo release];
    [infoDic  release];
	
    [super dealloc];
}


- (id)init {
    if (self = [super init]) {
        infoDic = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	
	return self;
}


// get instance
+ (AreaInfo *)info {
    if (!areaInfo) {
		areaInfo = [[AreaInfo alloc] init];
	}
    
	return areaInfo;
}


// 设置某城市的行政区、商业圈
- (void)setDistricts:(NSMutableArray *)districtArray Commercials:(NSMutableArray *)commercialArray ForCity:(NSString *)city {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys: districtArray, district,
                                                                    commercialArray, commercial ,nil];   
    [infoDic safeSetObject:dic forKey:city];
}


// 获取某城市的行政区、商业圈
- (NSDictionary *)getInfoForCity:(NSString *)city {
    return [infoDic safeObjectForKey:city];
}

@end
