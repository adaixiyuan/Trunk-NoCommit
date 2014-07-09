//
//  CommentHotelRequest.h
//  ElongClient
//  酒店评论请求
//
//  Created by 赵 海波 on 12-4-12.
//  Copyright 2012 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommentHotelRequest : NSObject {
@private
	NSMutableDictionary *contents;
	NSMutableDictionary *commentReq;
}

+ (id)shared;

- (void)clearHotelReqData;						// 清空请求酒店列表数据
- (void)restoreData;							// 重新构建头文件和页数
- (void)nextPage;								
- (NSString *)getCanCommentHotel;				// 获取可评论的酒店列表

- (void)clearCommentReqData;					// 清空提交评论数据
- (void)restoreComment;							// 重新构建头文件
- (void)setCommentContent:(NSString *)content;
- (void)setHotelID:(NSString *)hotelID;
- (void)setRecommendType:(NSString *)recommendType;
- (void)setOrderNO:(NSString *)orderNO;
- (void)setNickNmae:(NSString *)nickName;		// 设置用户昵称
- (NSString *)getCommentHotelReq;				// 获取提交评论的请求

@end
