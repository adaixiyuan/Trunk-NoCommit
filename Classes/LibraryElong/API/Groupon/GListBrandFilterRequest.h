//
//  HotelErrorCCViewController.h
//  ElongClient
//  酒店品牌筛选缓存
//  Created by garin on 14-1-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GListBrandFilterRequest : NSObject {
@private
	NSMutableArray *managerQueue;					// 管理队列
}

+ (id)shared;

- (void)setBrandInfo:(NSDictionary *)infoDic	forCity:(NSString *)city;		// 按城市加入品牌信息
- (NSDictionary *)getBrandInfoForCity:(NSString *)city;						// 取出城市的品牌信息

@end
