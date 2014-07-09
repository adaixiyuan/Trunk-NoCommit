//
//  CountlyEventShowCreateOrder.m
//  ElongClient
//
//  Created by Dawn on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventShowCreateOrder.h"

@implementation CountlyEventShowCreateOrder
- (void) dealloc{
    self.orderId = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        self.page = COUNTLY_PAGE_ORDERCONFIRMEDPAGE;
        self.ch = COUNTLY_CH_HOTEL;
    }
    return self;
}
@end
