//
//  GListFilterRequest.h
//  ElongClient
//  团购区域条件请求
//
//  Created by 赵 海波 on 12-3-13.
//  Copyright 2012 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GListFilterRequest : NSObject {
@private
	NSMutableDictionary *contents;
	
	NSMutableArray *managerQueue;					// 管理队列
}

+ (id)shared;

- (void)setAreaInfo:(NSDictionary *)infoDic	forCity:(NSString *)city;		// 按城市加入区域信息
- (NSDictionary *)getAreaInfoForCity:(NSString *)city;						// 取出城市的区域信息

- (NSString *)grouponFilterAreaRequest;				// 获取groupon的区域选择列表
- (void)setCurrentCity:(NSString *)city;			// 设置当前团购城市

@end
