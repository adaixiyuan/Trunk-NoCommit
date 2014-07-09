//
//  JCancelHotelOrder.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "JCancelHotelOrder.h"


@implementation JCancelHotelOrder
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

-(NSString *)requesString:(BOOL)iscompress{
	[contents safeSetObject:[PublicMethods getUserElongCardNO] forKey:@"CardNo"];
	NSLog(@"%@",contents);
	return [NSString stringWithFormat:@"action=CancelHotelOrder&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
}
@end


