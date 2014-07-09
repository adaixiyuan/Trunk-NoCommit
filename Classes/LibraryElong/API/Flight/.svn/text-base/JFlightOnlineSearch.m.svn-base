//
//  JFlightSearch.m
//  ElongClient
//
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "JFlightOnlineSearch.h"
#import "Utils.h"
#import "PostHeader.h"
#import "DefineCommon.h"

@implementation JFlightOnlineSearch

- (void)buildPostData:(BOOL)clearFlightsearch {
	if (clearFlightsearch) {
		[searchDictionary safeSetObject:[PostHeader header] forKey:Resq_Header];
	}
}

- (id)init {
    self = [super init];
    if (self) {
		searchDictionary = [[NSMutableDictionary alloc] init];
		[self buildPostData:YES];
	}
	return self;
}

- (id)getObject:(NSString *)key {
	return [searchDictionary safeObjectForKey:key];
}
- (void)setDate:(NSString *)date{
	[searchDictionary safeSetObject:date forKey:@"VDate"];
}

- (void)setVNum:(NSString *)VNum{
	[searchDictionary safeSetObject:VNum forKey:@"VNum"];
}

- (void)setvOrg:(NSString *)vOrg{
	[searchDictionary safeSetObject:vOrg forKey:@"vOrg"];
}

- (void)setvDst:(NSString *)vDst{
	[searchDictionary safeSetObject:vDst forKey:@"vDst"];
}

- (NSString *)requesStringwithVNum:(BOOL)iscompress {
	return [NSString stringWithFormat:@"action=GetFlightDynamicsByVNum&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[searchDictionary JSONRepresentationWithURLEncoding]];
}
- (NSString *)requesStringwithvOrgandvDst:(BOOL)iscompress {
	return [NSString stringWithFormat:@"action=GetFlightDynamics&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[searchDictionary JSONRepresentationWithURLEncoding]];
}

@end
