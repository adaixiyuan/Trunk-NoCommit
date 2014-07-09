//
//  HotelKeywordListRequest.h
//  ElongClient
//  酒店关键词列表请求
//
//  Created by 赵 海波 on 12-4-17.
//  Copyright 2012 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HotelKeywordListRequest : NSObject {
@private
	NSMutableDictionary *contents;
	
	NSOperationQueue *queue;
}

@property (nonatomic, copy) NSString *currentCityID;

+ (id)shared;

- (void)addAddressList:(NSArray *)keyDic ForKey:(NSString *)key;		// 添加关键词相关的地址列表
- (void)clearData;														// 清空搜索数据
- (void)requestForKeyword:(NSString *)key;								// 搜索关键词列表
- (void)saveDataToCache;                                                // 将搜索过的条件存入缓存

- (NSArray *)getAddressListByKeyword:(NSString *)key;					// 根据关键词获取地址列表

@end


@interface KeywordRequest : NSOperation {

}

- (id)initWithKeyword:(NSString *)key andCityID:(NSString *)cityID;

@end
