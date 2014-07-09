//
//  IHotelCommentItem.h
//  ElongClient
//
//  Created by bruce on 14-6-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHotelCommentItem : NSObject

@property (nonatomic, strong) NSString *author;                 // 昵称
@property (nonatomic, strong) NSString *cardNo;                 // 艺龙卡号
@property (nonatomic, strong) NSString *content;                // 评论内容
@property (nonatomic, strong) NSNumber *fromHotelId;            // EAN酒店id
@property (nonatomic, strong) NSNumber *fromOtaId;              // 代理id
@property (nonatomic, strong) NSNumber *publishTime;            // 评论发表时间
@property (nonatomic, strong) NSString *publishTimeStr;         // 评论发表日期字符串
@property (nonatomic, strong) NSNumber *score;                  // 评分
@property (nonatomic, strong) NSString *title;                  // 评论标题
@property (nonatomic, strong) NSNumber *travel;                 // 出行目的




// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
