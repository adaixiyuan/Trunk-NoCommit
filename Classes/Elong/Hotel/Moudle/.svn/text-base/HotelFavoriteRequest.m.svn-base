//
//  JHotelDetail.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "HotelFavoriteRequest.h"
#import "DefineHotelReq.h"



@implementation HotelFavoriteRequest

-(id)init{
    self = [super init];
    if (self){
		[self reset];
	}
	return self;
}

- (void)reset{
    _currentIndex = 1;
    _pageSize = 200;
}

-(void)nextPage{
	++_currentIndex;
}

- (NSString *)request{
    NSMutableDictionary *contents = [NSMutableDictionary dictionary];
    if (self.cityId) {
        self.category = NO;
        [contents setValue:self.cityId forKey:@"CityId"];
    }else{
        self.category = YES;
    }
    [contents setValue:[NSNumber numberWithInteger:1] forKey:@"SortType"];
    [contents setValue:[PostHeader header] forKey:Resq_Header];
    [contents setValue:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
    [contents setValue:[NSNumber numberWithInt:_pageSize] forKey:ReqHF_PageSize_I];
    [contents setValue:[NSNumber numberWithInt:_currentIndex] forKey:ReqHF_PageIndex_I];
    
    NSString *result = [NSString stringWithFormat:@"action=GetHotelFavorites&compress=%@&req=%@", @"true", [contents JSONRepresentationWithURLEncoding]];
    return result;
}

@end
