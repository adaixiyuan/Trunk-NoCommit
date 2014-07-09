//
//  CountlyEventInfo.m
//  ElongClient
//
//  Created by Dawn on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventInfo.h"
#import "AccountManager.h"

@implementation CountlyEventInfo
- (void) dealloc{
    self.action = nil;
    self.channelId = nil;
    self.appt = nil;
    self.status = nil;
    [super dealloc];
}

- (void) sendEventCount:(NSInteger)count{
    [super sendEvent:@"info" Count:count];
}

- (id) init{
    if (self = [super init]) {
        self.channelId = CHANNELID;
        self.appt = @"1";
        if ([[AccountManager instanse] isLogin]) {
            self.status = NUMBER(1);
        }else{
            self.status = NUMBER(2);
        }
    }
    return self;
}
@end
