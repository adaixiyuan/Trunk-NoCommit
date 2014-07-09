//
//  jUpdate.m
//  ElongClient
//
//  Created by elong lide on 11-11-4.
//  Copyright 2011 elong. All rights reserved.
//

#import "jUpdate.h"


@implementation jUpdate

- (void)dealloc {
	[contents release];
	
	[super dealloc];
}

-(void)buildPostData{
	
	[contents safeSetObject:[PostHeader header] forKey:@"Header"];
}

-(id)init{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
		[self buildPostData];
	}
	return self;
}


-(NSString *)requesString:(BOOL)iscompress{
	NSLog(@"%@",contents);
	NSString *requestStr = [[NSString alloc] initWithFormat:@"action=GetVersionInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
	return [requestStr autorelease];
}

@end


// ====================================================================================


@implementation CacheConfigRequest

- (void)dealloc {
	[contents release];
	
	[super dealloc];
}


- (id)init {
    self = [super init];
    if (self) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    [PostHeader header], @"Header",
                    [NSNumber numberWithInt:0] , @"SubRegion",
                    [[CacheManage manager] cacheVersion], @"Version", nil];

	}
    
	return self;
}


-(NSString *)requesString {
	NSLog(@"%@",contents);
	NSString *requestStr = [[NSString alloc] initWithFormat:@"action=GetCachingPolicy&compress=true&req=%@", [contents JSONRepresentationWithURLEncoding]];
	return [requestStr autorelease];
}

@end
