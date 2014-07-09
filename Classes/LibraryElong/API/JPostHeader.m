//
//  JPostHeader.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "JPostHeader.h"

@implementation JPostHeader

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
	}
}

-(void)clearBuildData{
	[self buildPostData:YES];
}

- (void)dealloc {
	[contents release];
	
	[super dealloc];
}

-(id)init{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
		[self clearBuildData];
	}
	return self;
}

-(NSString *)requesString:(BOOL)iscompress action:(NSString *)action{
	return [NSString stringWithFormat:@"action=%@&compress=%@&req=%@",action,[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

-(NSString	*)requesString:(BOOL)iscompress action:(NSString *)action params:(NSDictionary *)params{
	NSArray *allkeys = [params allKeys];
	
	for (NSString *key in allkeys) {
		[contents safeSetObject:[params safeObjectForKey:key] forKey:key];
	}
	return [NSString stringWithFormat:@"action=%@&compress=%@&req=%@",action,[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
