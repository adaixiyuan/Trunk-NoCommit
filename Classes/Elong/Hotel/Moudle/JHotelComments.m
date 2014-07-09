//
//  JHotelComments.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "JHotelComments.h"
#import "DefineHotelReq.h"
#import "DefineHotelResp.h"

@implementation JHotelComments

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
		[contents safeSetObject:[NSNull null] forKey:ReqHC_HotelId_S];
		[contents safeSetObject:[NSNumber numberWithInt:20] forKey:ReqHC_PageSize_I];
		[contents safeSetObject:[NSNumber numberWithInt:0] forKey:ReqHF_PageIndex_I];
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

-(void)setHotelId{
	[contents safeSetObject:[[HotelPostManager hoteldetailer] getObject:RespHD_HotelId_S] forKey:ReqHC_HotelId_S];
}

- (void) setGrouponHotelId:(NSString *)pid{
    [contents safeSetObject:pid forKey:ReqHC_HotelId_S];
}
-(void)setCommentsTpye:(int)_tpye
{
    if (_tpye) 
        [contents safeSetObject:[NSString stringWithFormat:@"%d",_tpye] forKey:@"CommnetType"];
    else
        [contents removeObjectForKey:@"CommnetType"];
}
-(void)clearBuildData{
	[self buildPostData:YES];
}

-(void)nextPage{
	int pageIndex = [[contents safeObjectForKey:ReqHF_PageIndex_I] intValue];
	pageIndex=pageIndex+1;
	[contents safeSetObject:[NSNumber numberWithInt:pageIndex] forKey:ReqHF_PageIndex_I];
	
}

-(NSString *)requesString:(BOOL)iscompress{
	NSString *iscomp=[[NSString alloc] initWithFormat:@"%@",iscompress?@"true":@"false"];
	NSString *request=[[[NSString alloc] initWithFormat:@"action=GetHotelComments&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]] autorelease];
	[iscomp release];
	return request;
}
@end
