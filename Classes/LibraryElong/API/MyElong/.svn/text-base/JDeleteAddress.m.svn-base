//
//  JDeleteAddress.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JDeleteAddress.h"

//action=DeleteAddress&compress=false&req={"Header":{"ChannelId":"1234","DeviceId":"4321","AuthCode":null,"ClientType":1},
//"AddressId":19580728}
@implementation JDeleteAddress

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"AddressId"];
	}
}
-(id)init{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
		[self clearBuildData];
	}
	return self;
}
-(void)clearBuildData{
	[self buildPostData:YES];
}

-(void)setAddressId:(int)addressId{
	[contents safeSetObject:[NSNumber numberWithInt:addressId] forKey:@"AddressId"];
}


-(NSString *)requesString:(BOOL)iscompress{
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=DeleteAddress&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
