//
//  JActivateCoupon.h
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
#import "AccountManager.h"

@interface JActivateCoupon : NSObject {
	NSMutableDictionary *contents;
}
-(void)clearBuildData;
-(NSString *)requesString:(BOOL)iscompress;

-(void)setCouponCode:(NSString *)string;
-(void)setCouponPassWord:(NSString *)string;
@end
