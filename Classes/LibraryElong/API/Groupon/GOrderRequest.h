//
//  GOrderRequest.h
//  ElongClient
//	团购订单提交请求
//
//  Created by haibo on 11-11-28.
//  Copyright 2011 elong. All rights reserved.
//
//  加入先成单后支付的新接口请求方式（JAVA）by 赵海波 on 14-4-23

#import <Foundation/Foundation.h>


@interface GOrderRequest : NSObject {
@private
	NSMutableDictionary *contents;
}

+ (id)shared;

// 重新获取数据
- (void)reGatherData;

// 非会员获取数据
- (void)nonNumberReGatherData;

// 获取数据字典
- (NSDictionary *)getContent;

// 获取订单请求字段
- (NSString *)grouponOrderCompress:(BOOL)animated;

// 获取统一收银台的成单请求
- (NSString *)getGrouponOrderReq;

@end
