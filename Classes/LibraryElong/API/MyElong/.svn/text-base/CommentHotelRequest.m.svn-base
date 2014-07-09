//
//  CommentHotelRequest.m
//  ElongClient
//
//  Created by 赵 海波 on 12-4-12.
//  Copyright 2012 elong. All rights reserved.
//

#import "CommentHotelRequest.h"
#import "AccountManager.h"

static CommentHotelRequest *request = nil;

static int REQ_PAGE_SIZE = 500;
static int REQ_PAGE_NUM	 = 0;

@implementation CommentHotelRequest


- (void)dealloc {
	[contents release];
	[commentReq release];
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		contents	= [[NSMutableDictionary alloc] initWithCapacity:2];
		commentReq	= [[NSMutableDictionary alloc] initWithCapacity:2];
	}
	
	return self;
}


#pragma mark -
#pragma mark PublicMethods

+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[CommentHotelRequest alloc] init];
		}
	}
	
	return request;
}


- (void)clearHotelReqData {
	[contents removeAllObjects];
}


- (void)clearCommentReqData {
	[commentReq removeAllObjects];
}


- (void)nextPage {
	REQ_PAGE_NUM ++;
}


- (void)restoreData {
	REQ_PAGE_NUM = 0;
	[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
}


- (void)restoreComment {
	[commentReq safeSetObject:[PostHeader header] forKey:Resq_Header];
}


- (NSString *)getCanCommentHotel {
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
	[contents safeSetObject:NUMBER(REQ_PAGE_NUM) forKey:PAGE_INDEX];
	[contents safeSetObject:NUMBER(REQ_PAGE_SIZE) forKey:PAGE_SIZE_];
	
	return [NSString stringWithFormat:@"action=GetCanCommentHotelInfos&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}


- (NSString *)getCommentHotelReq {
	[commentReq safeSetObject:@"false" forKey:ISNOTNEEDCHECK_REQ];
	[commentReq safeSetObject:[[AccountManager instanse] cardNo] forKey:MEMBERID_REQ];
	
	return [NSString stringWithFormat:@"action=PublishHotelComment&compress=true&req=%@",
			[commentReq JSONRepresentationWithURLEncoding]];
}


- (void)setCommentContent:(NSString *)content {
	[commentReq safeSetObject:content forKey:CONTENT_REQ];
}


- (void)setHotelID:(NSString *)hotelID {
	[commentReq safeSetObject:hotelID forKey:HOTELID_REQ];
}


- (void)setRecommendType:(NSString *)recommendType {
	[commentReq safeSetObject:recommendType forKey:RECOMMENDTYPE_REQ];
}


- (void)setOrderNO:(NSString *)orderNO {
	[commentReq safeSetObject:orderNO forKey:ORDERNO_REQ];
}


- (void)setNickNmae:(NSString *)nickName {
	if (nickName && STRINGHASVALUE(nickName)) {
		[commentReq safeSetObject:nickName forKey:MEMBERNAME_REQ];
	}
	else {
		// 不填昵称的话默认使用用户卡号，屏蔽后四位作为昵称
		NSString *cardNo = [[AccountManager instanse] cardNo];
		cardNo = [cardNo stringByReplaceWithAsteriskFromIndex:cardNo.length - 4];
		[commentReq safeSetObject:cardNo forKey:MEMBERNAME_REQ];
	}
}

@end
