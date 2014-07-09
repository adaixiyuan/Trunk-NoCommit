//
//  JDeleteHotelFavorite.m
//  ElongClient
//
//  Created by WangHaibin on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JDeleteHotelFavorite.h"

@implementation JDeleteHotelFavorite
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:@"Header"];
		[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
		[contents safeSetObject:@"" forKey:@"HotelId"];
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

-(void)setHotelId:(NSString *)string{
	[contents safeSetObject:string forKey:@"HotelId"];
}


-(NSString *)requesString:(BOOL)iscompress{
	
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
	COMMONREQUEST(@"%@",[contents JSONRepresentation]);
	return [NSString stringWithFormat:@"action=DeleteHotelFavorite&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}

@end
