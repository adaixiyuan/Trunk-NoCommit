//
//  JDeleteGrouponFavorite.m
//  ElongClient
//
//  Created by Dawn on 13-9-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "JDeleteGrouponFavorite.h"

@implementation JDeleteGrouponFavorite

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
		[contents safeSetObject:@"" forKey:@"ProductID"];
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

-(void)setProdId:(NSString *)string{
	[contents safeSetObject:string forKey:@"ProductID"];
}


-(NSString *)requesString:(BOOL)iscompress{
	
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=DeleteGrouponFavorite&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end