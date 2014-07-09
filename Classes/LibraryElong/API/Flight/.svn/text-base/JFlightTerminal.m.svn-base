//
//  JFlightTerminal.m
//  ElongClient
//
//  Created by dengfang on 11-2-21.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "JFlightTerminal.h"
#import "FlightDataDefine.h"
#import "PostHeader.h"
#import "DefineCommon.h"

//action=GetTerminal&compress=false&req={"Header":{
//"ChannelId":"1234",
//"DeviceId":"4321",
//"AuthCode":null,
//"ClientType":1},
//"AirPortName":"上海虹桥",
//"FlightNumber":"GS7417"}
@implementation JFlightTerminal
- (void)buildPostData:(BOOL)clearFlightRestriction {
	if (clearFlightRestriction) {
		[mDictionary safeSetObject:[PostHeader header] forKey:Resq_Header];
		[mDictionary safeSetObject:@"" forKey:KEY_AIR_PORT_CODE];
		[mDictionary safeSetObject:@"" forKey:KEY_FLIGHT_NUMBER];
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

- (void)setAirPortCode:(NSString *)str isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[mDictionary safeSetObject:str forKey:KEY_AIR_PORT_CODE];
}

- (void)setFlightNumber:(NSString *)str isClearData:(BOOL)isClearData {
	[self buildPostData:isClearData];
	[mDictionary safeSetObject:str forKey:KEY_FLIGHT_NUMBER];
}

- (NSString *)requesString:(BOOL)iscompress {
		FLIGHTREQUEST(@"%@",[mDictionary JSONRepresentation]);
	return [NSString stringWithFormat:@"action=GetTerminal&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[mDictionary JSONRepresentationWithURLEncoding]];
}
@end
