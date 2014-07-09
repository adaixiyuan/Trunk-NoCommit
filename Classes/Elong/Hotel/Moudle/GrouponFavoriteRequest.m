//
//  GrouponFavoriteRequest.m
//  ElongClient
//
//  Created by Dawn on 13-9-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponFavoriteRequest.h"
#import "DefineHotelReq.h"

@implementation GrouponFavoriteRequest

-(id)init
{
    self = [super init];
    if (self)
    {
		[self reset];
	}
	return self;
}

- (void)reset{
    _currentIndex = 1;
    _pageSize = 100;
}

-(void)nextPage
{
	++_currentIndex;
}

- (NSString *)request
{
    NSMutableDictionary *contents = [NSMutableDictionary dictionary];
    [contents setValue:[PostHeader header] forKey:Resq_Header];
    [contents setValue:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
    [contents setValue:[NSNumber numberWithInt:_pageSize] forKey:ReqHF_PageSize_I];
    [contents setValue:[NSNumber numberWithInt:_currentIndex] forKey:ReqHF_PageIndex_I];
    
    NSString *result = [NSString stringWithFormat:@"action=GetGrouponFavorites&compress=%@&req=%@", @"true", [contents JSONRepresentationWithURLEncoding]];
    return result;
}

@end
