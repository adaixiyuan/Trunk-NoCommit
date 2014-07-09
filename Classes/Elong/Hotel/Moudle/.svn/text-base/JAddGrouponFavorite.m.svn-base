//
//  JAddGrouponFavorite.m
//  ElongClient
//
//  Created by Dawn on 13-9-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "JAddGrouponFavorite.h"
#import "DefineHotelReq.h"

@implementation JAddGrouponFavorite
@synthesize contents;

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
		[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
		[contents safeSetObject:EmptyString forKey:@"ProductID"];
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
-(void)setProdId:(NSString *)hotelId{
	[contents safeSetObject:hotelId forKey:@"ProductID"];
}

-(NSString *)requesString:(BOOL)iscompress{
	HOTELREQUEST(@"%@",[contents JSONRepresentation]);
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
	return [NSString stringWithFormat:@"action=AddGrouponFavorite&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

-(NSString *)existRequestString:(BOOL)iscompress{
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
	return [NSString stringWithFormat:@"action=HasGrouponFavorite&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}
@end
