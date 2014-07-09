//
//  CountlyEventHotelListPageHotelItem.m
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventHotelListPageHotelItem.h"

@implementation CountlyEventHotelListPageHotelItem

- (void) dealloc{
    self.hotelId = nil;
    self.line = nil;
    self.starcode = nil;
    [super dealloc];
}


- (id) init{
    if(self = [super init]){
        self.page = COUNTLY_PAGE_HOTELLISTPAGE;
        self.clickSpot = COUNTLY_CLICKSPOT_HOTELITEM;
    }
    return self;
}
@end
