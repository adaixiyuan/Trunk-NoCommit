//
//  CacheManage.h
//  ElongClient
//  缓存管理类
//
//  Created by 赵 海波 on 13-4-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManage : NSObject {
@private
    NSFileManager *fileManager;
    UIDevice *device;
    
    long long cacheHotelSuggestTime;            // 酒店suggest缓存保留时间
    long long cacheHotelSuggestSize;            // 酒店suggest缓存文件夹最大size
    long long cacheHotelListTime;               // 酒店列表缓存保留时间
    NSInteger cacheHotelListCount;              // 酒店列表缓存数
    long long cacheHotelListImageSize;          // 酒店列表图片缓存大小
    long long cacheHotelListImageTime;          // 酒店列表图片缓存时间
    long long cacheHotelDetailTime;             // 酒店详情缓存时间
    NSInteger cacheHotelDetailCount;            // 酒店详情缓存数
    long long cacheHotelAreaTime;               // 酒店行政区、商圈缓存时间
    long long cacheGrouponListTime;             // 团购列表缓存时间
    NSInteger cacheGrouponListCount;            // 团购列表缓存数
    long long cacheGrouponDetailTime;           // 团购详情缓存时间
    NSInteger cacheGrouponDetailCount;          // 团购列表缓存数
    long long cacheBankTime;                    // 银行列表缓存时间
    
    BOOL canUseHotelSuggestCache;       // 是否使用suggest缓存
    BOOL canUseHotelAreaCache;          // 是否使用酒店行政区、商圈缓存
    BOOL canUseHotelListCache;          // 是否使用酒店列表缓存
    BOOL canUseHotelListImageCache;     // 是否使用酒店列表图片缓存
    BOOL canUseHotelDetailCache;        // 是否使用酒店详情缓存
    BOOL canUseGrouponListCache;        // 是否使用团购列表缓存
    BOOL canUseGrouponDetailCache;      // 是否使用团购详情缓存
    BOOL canUseBankCache;               // 是否使用银行列表缓存
}

@property (nonatomic, assign) BOOL canUseCache;
@property (nonatomic, copy) NSString *cacheVersion;         // 缓存配置版本
@property (nonatomic, copy) NSString *currentDelFile;       // 当前删除的文件名

+ (id)manager;

- (void)setCacheValueFromDataSource:(NSDictionary *)cacheDic;       // 设置数据源

// 设置(获取)酒店suggest缓存
- (void)setHotelSuggests:(NSDictionary *)paramDic forCity:(NSString *)cityID;
- (id)getHotelSuggestFromCity:(NSString *)cityID;

// 设置（获取）行政区、商圈缓存
- (void)setHotelArea:(NSData *)areaData forSearching:(NSString *)searchCondition;
- (id)getHotelAreaFromSearching:(NSString *)searchCondition;

// 设置（获取）酒店列表缓存
- (void)setHotelListData:(NSData *)listData forSearching:(NSString *)searchCondition;
- (NSData *)getHotelListFromSearching:(NSString *)searchCondition;

// 设置（获取）酒店列表图片缓存
- (void)setHotelListImage:(NSData *)imageData forURL:(NSString *)imageURL;
- (UIImage *)getHotelListImageByURL:(NSString *)imageURL;

// 设置（获取）酒店详情缓存
- (void)setHotelDetailData:(NSData *)detailData forSearching:(NSString *)searchCondition;
- (NSData *)getHotelDetailFromSearching:(NSString *)searchCondition;

// 设置（获取）团购列表缓存
- (void)setGrouponListData:(NSData *)listData forSearching:(NSString *)searchCondition;
- (NSData *)getGrouponListFromSearching:(NSString *)searchCondition;

// 设置（获取）团购详情缓存
- (void)setGrouponDetailData:(NSData *)detailData forSearching:(NSString *)searchCondition;
- (NSData *)getGrouponDetailFromSearching:(NSString *)searchCondition;

// 设置（获取）银行列表缓存
- (void)setBankListData:(NSData *)bankData;
- (NSData *)getBankListData;

/** 获取所有图片的缓存大小
*/
- (unsigned long long)getCacheSizeOfImage;

/** 清空所有图片的缓存
 */
- (void)clearImageCache;

@end
