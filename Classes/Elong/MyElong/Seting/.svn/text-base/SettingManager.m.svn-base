    //
//  SettingManager.m
//  ElongClient
//
//  Created by bin xing on 11-1-28.
//  Copyright 2011 DP. All rights reserved.
//

#import "SettingManager.h"

static Setting *instanse = nil;

@implementation SettingManager
+ (Setting *)instanse  {
	
	@synchronized(self) {
		if(!instanse) {
			instanse = [[Setting alloc] init];
		}
	}
	return instanse;
}
@end
