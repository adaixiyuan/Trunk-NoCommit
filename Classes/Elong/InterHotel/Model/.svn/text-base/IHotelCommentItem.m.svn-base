//
//  IHotelCommentItem.m
//  ElongClient
//
//  Created by bruce on 14-6-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "IHotelCommentItem.h"

@implementation IHotelCommentItem

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    // 昵称
    _author = [dictionaryResultJson safeObjectForKey:@"Author"];
    
    // 艺龙卡号
    _cardNo = [dictionaryResultJson safeObjectForKey:@"CardNo"];
    
    // 评论内容
    _content = [dictionaryResultJson safeObjectForKey:@"Content"];
    
    // EAN酒店id
    _fromHotelId = [dictionaryResultJson safeObjectForKey:@"FromHotelId"];
    
    // 代理id
    _fromOtaId = [dictionaryResultJson safeObjectForKey:@"FromOtaId"];
    
    // 评论发表时间
    _publishTime = [dictionaryResultJson safeObjectForKey:@"PublishTime"];
    
    // 评论发表日期字符串
    _publishTimeStr = [dictionaryResultJson safeObjectForKey:@"PublishTimeStr"];
    
    // 评分
    _score = [dictionaryResultJson safeObjectForKey:@"Score"];
    
    // 评论标题
    _title = [dictionaryResultJson safeObjectForKey:@"Title"];
    
    // 出行目的
    _travel = [dictionaryResultJson safeObjectForKey:@"Travel"];
}


@end
