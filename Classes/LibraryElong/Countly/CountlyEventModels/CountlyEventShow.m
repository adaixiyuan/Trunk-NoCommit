//
//  CountEventShow.m
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventShow.h"
#import "AccountManager.h"

//static NSString *ipAddress = nil;
//static NSDate *ipLastDate = nil;

@implementation CountlyEventShow

- (void) dealloc{
    self.page = nil;
    self.ch = nil;
    self.channelId = nil;
    self.appt = nil;
    self.status = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        self.channelId = CHANNELID;
        self.ch = @"";
        self.appt = @"1";
        if ([[AccountManager instanse] isLogin]) {
            self.status = NUMBER(1);
        }else{
            self.status = NUMBER(2);
        }
    }
    return self;
}

- (void) sendEventCount:(NSInteger)count{
    [super sendEvent:@"show" Count:count];
}

@end
