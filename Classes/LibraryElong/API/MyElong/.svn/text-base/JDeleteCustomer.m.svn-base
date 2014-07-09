//
//  JDeleteCustomer.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JDeleteCustomer.h"


@implementation JDeleteCustomer

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
        [contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"CustomerId"];
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

-(void)setCustomerId:(int)customerId{
	[contents safeSetObject:[NSNumber numberWithInt:customerId] forKey:@"CustomerId"];
}


-(NSString *)requesString:(BOOL)iscompress{
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=DeleteCustomer&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
