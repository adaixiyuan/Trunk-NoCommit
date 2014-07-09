//
//  GDetailRequest.h
//  ElongClient
//  团购详细页面请求
//
//  Created by haibo on 11-11-9.
//  Copyright 2011 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GDetailRequest : NSObject {
@private
	NSMutableDictionary *contents;
}

+ (id)shared;

- (void)setProdId:(NSString *)prodId;						// 设置产品编号

- (NSString *)grouponDetailCompress:(BOOL)animated;			// 获取团购详情请求字段
- (NSString *)requestOfGrouponDetail;						// 团购详情
- (NSString *)requestOfHotelIntro;							// 酒店介绍
- (NSString *)requestOfComment;								// 点评
- (NSString *)requestOfMap;									// 地图

@end
