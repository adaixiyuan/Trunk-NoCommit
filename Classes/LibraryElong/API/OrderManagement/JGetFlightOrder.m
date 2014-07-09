//
//  JGetFlightOrder.m
//  ElongClient
//
//  Created by WangHaibin on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JGetFlightOrder.h"


@implementation JGetFlightOrder
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:[PublicMethods getUserElongCardNO] forKey:@"CardNo"];
		[contents safeSetObject:[NSNull null] forKey:@"OrderNo"];
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

-(void)setOrderNo:(id)orderNo{
	[contents safeSetObject:orderNo forKey:@"OrderNo"];
}

-(void)nextPage{
	int pageIndex = [[contents safeObjectForKey:@"PageIndex"] intValue];
	pageIndex=pageIndex+1;
	[contents safeSetObject:[NSNumber numberWithInt:pageIndex] forKey:@"PageIndex"];
	
}



-(NSString *)requesString:(BOOL)iscompress{
	[contents safeSetObject:[PublicMethods getUserElongCardNO] forKey:@"CardNo"];
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=GetFlightOrder&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
