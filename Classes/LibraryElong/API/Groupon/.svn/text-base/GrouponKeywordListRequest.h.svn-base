//
//  GrouponKeywordListRequest.h
//  ElongClient
//
//  Created by Dawn on 13-6-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrouponKeywordListRequest : NSObject {
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


@interface GrouponKeywordRequest : NSOperation {
    
}

- (id)initWithKeyword:(NSString *)key andCityID:(NSString *)cityID;

@end
