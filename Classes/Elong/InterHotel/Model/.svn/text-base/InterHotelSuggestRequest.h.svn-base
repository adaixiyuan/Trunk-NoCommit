//
//  InterHotelSuggestRequest.h
//  ElongClient
//  国际酒店
//
//  Created by 赵 海波 on 13-7-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InterHotelSuggestRequest : NSObject {
@private
    NSMutableDictionary *contents;
    NSOperationQueue *queue;
}

@property (nonatomic, copy) NSString *keyWord;

+ (id)shared;

- (void)addSuggestList:(NSArray *)list ForKey:(NSString *)key;          // 添加关键词相关的地址列表
- (void)clearData;														// 清空搜索数据
- (void)requestForKeyword:(NSString *)key;								// 搜索关键词列表

- (NSArray *)getSuggestByKeyword:(NSString *)key;					// 根据关键词获取地址列表

@end


@interface InterHotelRequest : NSOperation {
    
}

- (id)initWithKeyword:(NSString *)key destinationID:(NSString *)destID countryCode:(NSString *)code;

@end
