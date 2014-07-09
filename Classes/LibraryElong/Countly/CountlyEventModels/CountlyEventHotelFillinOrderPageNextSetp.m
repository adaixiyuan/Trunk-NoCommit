//
//  CountlyEventHotelMemberFillinOrderPageNextSetp.m
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventHotelFillinOrderPageNextStep.h"

@implementation CountlyEventHotelFillinOrderPageNextStep
- (void) dealloc{
    self.vouchType = nil;
    self.payType = nil;
    self.hotelName = nil;
    self.hotelId = nil;
    self.roomName = nil;
    self.roomId = nil;
    self.bedType = nil;
    self.webFree = nil;
    self.breakfast = nil;
    self.roomNum = nil;
    self.checkIn = nil;
    self.checkOut = nil;
    self.amount = nil;
    self.invoiceStatus = nil;
    self.title = nil;
    self.invoiceType = nil;
    self.invoiceAddress = nil;
    [super dealloc];
}


- (id) init{
    if (self = [super init]) {
        self.clickSpot = COUNTLY_CLICKSPOT_NEXTSTEP;
        self.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
    }
    return self;
}
@end
