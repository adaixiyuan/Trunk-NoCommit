//
//  GGetCouponPassword.h
//  ElongClient
//  获取团购券密码
//
//  Created by haibo on 11-12-2.
//  Copyright 2011 elong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GGetCouponPassword : NSObject {
@private
	NSMutableDictionary *contents;
}

+ (id)shared;

// 获取团购券请求字段
- (NSString *)grouponSetMessageCompress:(BOOL)animated;

- (void)setOrderID:(NSNumber *)orderID;				// 传入orderID
- (void)setPhone:(NSString *)phoneNum;				// 传入手机号码
- (void)setCouponId:(NSNumber *)quanID;				// 传入quanID

@end
