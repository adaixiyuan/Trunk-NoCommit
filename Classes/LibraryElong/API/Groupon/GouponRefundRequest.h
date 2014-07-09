//
//  GouponRefundRequest.h
//  ElongClient
//
//  Created by 赵 海波 on 13-3-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GouponRefundRequest : NSObject {
@private
	NSMutableDictionary *contents;
}

+ (id)shared;

- (void)setRefundOrder:(NSNumber *)orderID Pord:(NSNumber *)prodID Quans:(NSArray *)quansArray;
- (NSString *)getRefundRequest;

@end
