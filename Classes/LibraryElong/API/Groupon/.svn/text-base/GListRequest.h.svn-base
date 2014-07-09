//
//  GListRequest.h
//  ElongClient
//
//  Created by haibo on 11-10-20.
//  Copyright 2011 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const orderStrings[6];

@interface GListRequest : NSObject {
@private
	NSMutableDictionary *contents;

	NSDate *reqDate;		// 上一次请求的时间
}

@property (nonatomic, retain) NSMutableArray *grouponCitys;			// 团购城市列表
@property (nonatomic, copy)	  NSString *cityName;					// 搜索城市
@property (nonatomic, assign) NSInteger grouponNum;					// 城市团购产品数量
@property (nonatomic, assign) NSInteger ImageSizeType;				// 城市团购图片大小标示
@property (nonatomic, retain) NSMutableDictionary *aioCondition;
@property (nonatomic, copy)   NSString *keyword;
@property (nonatomic, copy)   NSString *hitType;
@property (nonatomic, retain) NSDictionary *location;
@property (nonatomic, retain) NSDictionary *brand;
@property (nonatomic, retain) NSDictionary *typpee;

+ (id)shared;

- (BOOL)isNeedRequestForCityList;								// 是否需要发起城市列表的请求

- (NSString *)grouponCityRequestCompress:(BOOL)animated;		// 获取groupon的城市列表
- (NSString *)grouponListCompress:(BOOL)animated;				// 获取相应城市的团购产品列表
- (NSString *)grouponKeywordSearchCompress:(BOOL)animated;      // 获取关键词搜索团购产品列表

- (void)clearData;												// 清空数据 
- (void)nextPage;												// 请求团购产品下一页的数据
- (void)restoreGrouponListReqest;								// 恢复团购产品列表请求字段
- (void)orderByType:(NSString *)type;							// 根据类型排序
- (NSString *)getOrderType;											// 获取排序类型

- (NSUInteger)getStarLevel;
- (void)setStarLevel:(NSUInteger)level;                         // 设置星级
- (NSUInteger)getMinPrice;
- (void)setMinPrice:(NSUInteger)minPrice;						// 设置最小价格
- (NSUInteger)getMaxPrice;
- (void)setMaxPrice:(NSUInteger)maxPrice;						// 设置最大价格
- (void)setNeedAdition:(BOOL)animated;							// 设置是否需要额外的信息（如酒店坐标）
- (void)setLocationName:(NSString *)name;                       // 地标名称
- (void)setDistrictID:(NSString *)disID;						// 设置行政区ID
- (void)setBizsectionID:(NSString *)bizID;						// 设置商圈ID
- (void)setLatitude:(double)latitude;                           // 设置纬度
- (void)setLongitude:(double)longitude;                         // 设置经度
- (BOOL)isPosition;                                             // 判断当前是否为周边搜索
- (void)setBrandId;                              //品牌
- (void)setTypeId;                               //筛选类型
@end
