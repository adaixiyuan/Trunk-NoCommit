//
//  CountlyEventHotelSearchPageSearch'.m
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventHotelSearchPageSearch.h"

@implementation CountlyEventHotelSearchPageSearch

- (void) dealloc{
    self.keyword = nil;
    self.checkInDate = nil;
    self.checkOutDate = nil;
    self.city = nil;
    self.highestPrice = nil;
    self.lowestPrice = nil;
    self.hotelBrandid = nil;
    self.isApartment = nil;
    self.isPositioning = nil;
    self.latitude = nil;
    self.longitude = nil;
    self.memberLevel = nil;
    self.mutilpleFilter = nil;
    self.orderBy = nil;
    self.pageIndex = nil;
    self.pageSize = nil;
    self.radius = nil;
    self.searchType = nil;
    self.starCode = nil;
    self.facilitiesFilter = nil;
    self.themesFilter = nil;
    self.filter = nil;
    self.areaName = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        self.action = COUNTLY_ACTION_SEARCH;
        self.highestPrice = NUMBER(-1);
        self.lowestPrice = NUMBER(-1);
        self.isApartment = NUMBER(0);
        self.isPositioning = NUMBER(0);
        self.memberLevel = NUMBER(0);
        self.orderBy = NUMBER(0);
        self.searchType = NUMBER(1);
        self.filter = 0;
    }
    return self;
}
@end
