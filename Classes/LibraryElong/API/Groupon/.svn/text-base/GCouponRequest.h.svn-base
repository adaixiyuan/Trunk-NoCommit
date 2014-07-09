//
//  GCouponRequest.h
//  ElongClient
//  查询团购券请求
//
//  Created by haibo on 11-12-1.
//  Copyright 2011 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GCouponRequest : NSObject {
@private
	NSMutableDictionary *contents;
}

+ (id)shared;

// 获取团购券请求字段
- (NSString *)grouponCouponCompress:(BOOL)animated;

- (void)setOrderID:(NSNumber *)orderID;				// 传入orderID
- (void)refreshData;

@end
