//
//  JLogin.h
//  ElongClient
//
//  Created by bin xing on 11-1-16.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
@interface JLogin : NSObject {
	NSMutableDictionary *contents;
}
-(void)setAccount:(NSString *)username password:(NSString *)password;
-(NSString *)requesString:(BOOL)iscompress;
-(NSString *)password;
@end
