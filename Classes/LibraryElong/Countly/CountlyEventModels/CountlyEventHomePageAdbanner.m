//
//  CountlyEventHomePageAdbanner.m
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventHomePageAdbanner.h"

@implementation CountlyEventHomePageAdbanner

- (void) dealloc{
    self.bannerId = nil;
    self.bannerUrl = nil;
    [super dealloc];
}

- (id) init{
    if(self = [super init]){
        self.clickSpot = COUNTLY_CLICKSPOT_ADBANNER;
        self.page = COUNTLY_PAGE_HOMEPAGE;
    }
    return self;
}
@end
