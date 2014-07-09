//
//  AccountManager.m
//  ElongClient
//
//  Created by bin xing on 11-1-26.
//  Copyright 2011 DP. All rights reserved.
//

#import "AccountManager.h"

static JAccount *instanse = nil;

@implementation AccountManager
+ (JAccount *)instanse  {
	@synchronized(self) {
		if(!instanse) {
			instanse = [[JAccount alloc] init];
		}
	}
	return instanse;
}
@end
