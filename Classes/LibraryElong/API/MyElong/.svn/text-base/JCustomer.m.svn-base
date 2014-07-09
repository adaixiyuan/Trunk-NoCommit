//
//  untitled.m
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "JCustomer.h"


@implementation JCustomer

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
	[contents safeSetObject:[PostHeader header] forKey:@"Header"];
	[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"CustomerType"];
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNO"];
	[contents safeSetObject:[NSNumber numberWithInt:100] forKey:@"PageSize"];
	[contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"PageIndex"];
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

-(void)setCustomerType:(int)type{
	[contents safeSetObject:[NSNumber numberWithInt:type] forKey:@"CustomerType"];
}

-(void)nextPage{
	int pageIndex = [[contents safeObjectForKey:@"PageIndex"] intValue];
	pageIndex=pageIndex+1;
	[contents safeSetObject:[NSNumber numberWithInt:pageIndex] forKey:@"PageIndex"];
	
}

-(NSString *)requesString:(BOOL)iscompress{
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNO"];
	NSLog(@"%@", contents);
	return [NSString stringWithFormat:@"action=GetCustomerList&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}
@end
