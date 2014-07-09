//
//  IHotelComment.h
//  ElongClient
//
//  Created by bruce on 14-6-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IHotelComment : NSObject

@property (nonatomic, strong) NSNumber *isError;            // 是否出错
@property (nonatomic, strong) NSString *errorCode;          // 出错时显示出错代码
@property (nonatomic, strong) NSString *errorMessage;       // 错误信息
@property (nonatomic, strong) NSNumber *pageCount;          // 分页总数
@property (nonatomic, strong) NSNumber *averageScore;       // 平均评分
@property (nonatomic, strong) NSArray *arrayComments;       // 评论列表


// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson;

@end
