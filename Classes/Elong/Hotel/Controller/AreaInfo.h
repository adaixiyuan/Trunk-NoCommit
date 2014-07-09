//
//  AreaInfo.h
//  ElongClient
//  存储各城市行政区名字的单例
//
//  Created by Haibo Zhao on 11-8-11.
//  Copyright 2011年 eLong. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const district;      // 行政区标志
UIKIT_EXTERN NSString *const commercial;    // 商业圈标志


@interface AreaInfo : NSObject {
@private 
    NSMutableDictionary *infoDic;
}

// get instance
+ (AreaInfo *)info;


// 设置某城市的行政区、商业圈
- (void)setDistricts:(NSMutableArray *)districtArray Commercials:(NSMutableArray *)commercialArray ForCity:(NSString *)city;


// 获取某城市的行政区、商业圈
- (NSDictionary *)getInfoForCity:(NSString *)city;

@end
