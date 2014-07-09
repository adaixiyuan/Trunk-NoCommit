//
//  JDeleteCustomer.h
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
#import "AccountManager.h"

@interface JDeleteCustomer : NSObject {
	NSMutableDictionary *contents;
}
-(void)clearBuildData;
-(void)setCustomerId:(int)customerId;
-(NSString *)requesString:(BOOL)iscompress;
@end
