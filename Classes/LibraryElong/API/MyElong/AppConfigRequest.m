//
//  AppConfigRequest.m
//  ElongClient
//
//  Created by Dawn on 13-10-12.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "AppConfigRequest.h"
#import "PostHeader.h"

@interface AppConfigRequest()
@property (nonatomic,retain) NSMutableDictionary *params;
@end

static AppConfigRequest *request;
@implementation AppConfigRequest
@synthesize appKey;
@synthesize config;
@synthesize params;


- (void)dealloc {
    self.appKey = nil;
    self.config = nil;
    self.params = nil;
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
        self.config = [NSMutableDictionary dictionaryWithCapacity:0];
        self.params = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [self.params safeSetObject:[PostHeader header] forKey:Resq_Header];
	}
	
	return self;
}

#pragma mark -
#pragma mark PublicMethods

+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[AppConfigRequest alloc] init];
		}
	}
	return request;
}


- (NSString *)getAppConfigRequest {
	[self.params safeSetObject:self.appKey forKey:@"AppKey"];
	
	return [NSString stringWithFormat:@"action=GetAppConfig&compress=true&req=%@",
			[self.params JSONRepresentationWithURLEncoding]];
}


@end
