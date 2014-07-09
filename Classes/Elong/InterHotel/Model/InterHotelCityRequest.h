//
//  InterHotelCityRequest.h
//  ElongClient
//  国际酒店城市列表请求
//
//  Created by 赵 海波 on 13-6-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterHotelCityRequest : NSObject {
@private
    NSMutableDictionary *contents;
    NSOperationQueue *queue;
}

@property (nonatomic, copy) NSString *CityKeyWord;

+ (id)shared;

- (void)addAddressList:(NSArray *)keyDic ForKey:(NSString *)key;		// 添加关键词相关的地址列表
- (void)clearData;														// 清空搜索数据
- (void)requestForKeyword:(NSString *)key;								// 搜索关键词列表

- (NSArray *)getAddressListByKeyword:(NSString *)key;					// 根据关键词获取地址列表

@end


@interface CityKeywordRequest : NSOperation {
    
}

- (id)initWithKeyword:(NSString *)key;

@end
