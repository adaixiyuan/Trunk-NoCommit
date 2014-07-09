//
//  untitled.h
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
#import "AccountManager.h"
@interface JCard : NSObject {
	NSMutableDictionary *contents;
	
}
-(void)clearBuildData;
-(NSString *)requesString:(BOOL)iscompress;
@end
