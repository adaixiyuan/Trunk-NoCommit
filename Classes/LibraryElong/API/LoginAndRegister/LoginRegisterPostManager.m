//
//  LoginRegisterPostManager.m
//  ElongClient
//
//  Created by bin xing on 11-1-16.
//  Copyright 2011 DP. All rights reserved.
//

#import "LoginRegisterPostManager.h"


static JLogin *instanse = nil;
static JRegister *registerInstanse = nil;
static JToken *tokenInstanse = nil;

@implementation LoginRegisterPostManager
+ (JLogin *)instanse  {
	@synchronized(self) {
		if(!instanse) {
			instanse = [[JLogin alloc] init];
		}
	}
	return instanse;
}

+ (JRegister *)registerInstanse  {
	@synchronized(self) {
		if(!registerInstanse) {
			registerInstanse = [[JRegister alloc] init];
		}
	}
	return registerInstanse;
}

+ (JToken *)tokenInstanse{
    @synchronized(self) {
		if(!tokenInstanse) {
			tokenInstanse = [[JToken alloc] init];
		}
	}
	return tokenInstanse;
}
@end
