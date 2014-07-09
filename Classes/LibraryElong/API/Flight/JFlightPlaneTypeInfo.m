//
//  JFlightPlaneTypeInfo.m
//  ElongClient
//
//  Created by dengfang on 11-2-21.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "JFlightPlaneTypeInfo.h"
#import "FlightDataDefine.h"
#import "PostHeader.h"
#import "DefineCommon.h"
//action=GetPlaneTypeInfo&compress=false&req={"Header":{
//	"ChannelId":"1234",
//	"DeviceId":"4321",
//	"AuthCode":null,
//	"ClientType":1},
//	"TypeCode":"731"}
@implementation JFlightPlaneTypeInfo
- (void)buildPostData:(BOOL)clearFlightRestriction {
	if (clearFlightRestriction) {
		[mDictionary safeSetObject:[PostHeader header] forKey:Resq_Header];
		[mDictionary safeSetObject:@"" forKey:KEY_PLANE_TYPE_CODE];
	}
}

- (id)init {
    self = [super init];
    if (self) {
		mDictionary = [[NSMutableDictionary alloc] init];
		[self buildPostData:YES];
	}
	return self;
}

- (id)getObject:(NSString *)key {
	return [mDictionary safeObjectForKey:key];
}

- (void)setTypeCode:(NSString *)str isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[mDictionary safeSetObject:str forKey:KEY_PLANE_TYPE_CODE];
}

- (NSString *)requesString:(BOOL)iscompress {
	FLIGHTREQUEST(@"%@",[mDictionary JSONRepresentation]);
	return [NSString stringWithFormat:@"action=GetPlaneTypeInfo&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[mDictionary JSONRepresentationWithURLEncoding]];
}
@end
