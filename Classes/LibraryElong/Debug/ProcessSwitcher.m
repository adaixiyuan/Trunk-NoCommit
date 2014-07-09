//
//  ProcessSwitcher.m
//  ElongClient
//  控制各个流程的开关
//
//  Created by 赵 海波 on 13-1-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ProcessSwitcher.h"

#define OUT_TIME   86400                    // 超时时间

static ProcessSwitcher *switcher = nil;

@implementation ProcessSwitcher

@synthesize allowNonmember;
@synthesize allowAlipayForFlight;
@synthesize allowAlipayForGroupon;
@synthesize hotelPassOn;
@synthesize grouponPassOn;
@synthesize hotelHtml5On;
@synthesize grouponHtml5On;
@synthesize flightHtml5On;
@synthesize dataOutTime;
@synthesize getDate;
@synthesize allowIFlyMSC;
@synthesize allowHttps;

- (void)dealloc {
    self.getDate = nil;
    
    [super dealloc];
}


+ (ProcessSwitcher *)shared {
    if (!switcher) {
        @synchronized(self) {
            switcher = [[ProcessSwitcher alloc] init];
        }
    }
    
    return switcher;
}


- (id)init {
    if (self = [super init]) {
        allowNonmember          = YES;
        allowAlipayForFlight    = NO;
        allowAlipayForGroupon   = NO;
        hotelPassOn             = NO;
        grouponPassOn           = NO;
        hotelHtml5On            = NO;
        grouponHtml5On          = NO;
        flightHtml5On           = NO;
        allowIFlyMSC            = NO;
        allowHttps              = YES;
        self.showC2CInHotelSearch = NO;
        self.showC2COrder = NO;
    }
    
    return self;
}


- (void)setAllowNonmember:(BOOL)animated {
    allowNonmember = animated;
    
    self.getDate = [NSDate date];
}


- (BOOL)dataOutTime {
    if (!getDate) {
        return YES;
    }
    
    return [[NSDate date] timeIntervalSinceDate:getDate] > OUT_TIME;
}

@end
