//
//  JAddFavorite.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "JAddFavorite.h"
#import "DefineHotelReq.h"

@implementation JAddFavorite
@synthesize contents;

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
		[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
		[contents safeSetObject:EmptyString forKey:ReqHAF_HotelId_S];
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
-(void)setHotelId:(NSString *)hotelId{
	[contents safeSetObject:hotelId forKey:ReqHAF_HotelId_S];
}

-(NSString *)requesString:(BOOL)iscompress{	
	HOTELREQUEST(@"%@",[contents JSONRepresentation]);
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
	return [NSString stringWithFormat:@"action=AddHotelFavorite&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

- (NSString *)haveFavString:(BOOL)iscompress{
    [contents safeSetObject:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
	return [NSString stringWithFormat:@"action=HasHotelFavorite&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}
@end
