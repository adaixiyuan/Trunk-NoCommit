//
//  JAddAddress.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JAddAddress.h"

@implementation JAddAddress
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
		[contents safeSetObject:@"" forKey:@"OperatorName"];
		[contents safeSetObject:@"" forKey:@"OperatorIP"];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"Id"];
		[contents safeSetObject:@"" forKey:@"Name"];
		[contents safeSetObject:@"" forKey:@"Address"];
		[contents safeSetObject:@"" forKey:@"PhoneNo"];
		[contents safeSetObject:@"" forKey:@"Postcode"];
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
//{"Id":33,"AddressContent":"33","PostCode":"33","Name":"33","PhoneNo":"33"}
-(NSMutableDictionary *)getAddress{
	
	NSMutableDictionary *customer=[[NSMutableDictionary alloc] initWithDictionary:contents];
	[customer removeObjectForKey:@"Header"];
	[customer removeObjectForKey:@"CardNo"];
	[customer removeObjectForKey:@"OperatorName"];
	[customer removeObjectForKey:@"OperatorIP"];
	
	return [customer autorelease];
	
}

-(void)setAddName:(NSString *)string{
	[contents safeSetObject:string forKey:@"Name"];
}
-(void)setAddress:(NSString *)string{
	[contents safeSetObject:string forKey:@"Address"];
}
-(void)setAddressContent:(NSString *)string{
	[contents safeSetObject:string forKey:@"AddressContent"];
}
-(void)removeAddressContent{
	[contents removeObjectForKey:@"AddressContent"];
}
-(void)setPostcode:(NSString *)string{
	[contents safeSetObject:string forKey:@"Postcode"];
}


-(NSString *)requesString:(BOOL)iscompress{
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=AddAddress&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}
@end
