//
//  untitled.m
//  ElongClient
//
//  Created by bin xing on 11-2-14.
//  Copyright 2011 DP. All rights reserved.
//

#import "JCard.h"


@implementation JCard

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:[PublicMethods getUserElongCardNO] forKey:@"CardNO"];
//		[contents safeSetObject:[NSNumber numberWithLongLong:2000000000619705016] forKey:@"CardNO"];
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

-(NSString *)requesString:(BOOL)iscompress{
	[contents safeSetObject:[PublicMethods getUserElongCardNO] forKey:@"CardNO"];

    NSLog(@"%@", contents);
	return [NSString stringWithFormat:@"action=GetCreditCardHistory&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
