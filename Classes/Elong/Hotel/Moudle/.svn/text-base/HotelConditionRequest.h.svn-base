//
//  HotelConditionRequest.h
//  ElongClient
//  酒店条件搜索请求
//
//  Created by haibo on 11-12-30.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHotelKeywordFilter.h"


@interface HotelConditionRequest : NSObject {
@private
	NSMutableDictionary *contents;
    JHotelKeywordFilter *hotelKeywordFilter;
    JHotelKeywordFilter *tonightHotelKeywordFilter;
}

@property (nonatomic, assign) BOOL isAllDataLoaded;
@property (nonatomic, assign) BOOL isThemeDataLoaded;

@property (nonatomic, retain) NSArray *trafficSubArray;				// 交通枢纽子列表
@property (nonatomic, retain) NSArray *metroSubArray;				// 地铁子列表
@property (nonatomic, retain) NSMutableArray *commercialArray;		// 商圈列表
@property (nonatomic, retain) NSMutableArray *districtArray;		// 行政区列表
@property (nonatomic, retain) NSMutableArray *brandArray;			// 酒店品牌列表
@property (nonatomic, retain) NSMutableArray *chainArray;           // 连锁酒店品牌列表
@property (nonatomic, retain) NSMutableArray *metroArray;			// 地铁列表
@property (nonatomic, retain) NSMutableArray *trafficArray;			// 交通枢纽列表
@property (nonatomic, retain) NSMutableArray *facilityArray;        // 酒店设施列表
@property (nonatomic, retain) NSMutableArray *themeArray;           // 酒店主题列表
@property (nonatomic, retain) NSMutableArray *payTypeArray;         // 支付方式
@property (nonatomic, retain) NSMutableArray *promotionTypeArray;   // 促销方式

@property (nonatomic, assign) BOOL isFromLastMinute;

@property (nonatomic, readonly) JHotelKeywordFilter *keywordFilter;


+ (id)shared;

// 清空数据但不清空选择数据
- (void)clearDataOnly;

// 清空搜索数据
- (void)clearData;

// 设置搜索城市
- (void)setSearchCity:(NSString *)city;	

// 设置搜索条件字典
- (void)setAllCondition:(NSDictionary *)allDictionary;

// 设施主题
- (void) setThemes:(NSDictionary *)themes;

// 获取搜索城市
- (NSString *)getSearchCity;

// 一次获取所有的搜索条件
- (NSString *)requestForAllCondition;

// 获取主题搜索条件
- (NSString *)requestForThemes;

// 情况筛选条件
- (void) clearKeywordFilter;

@end
