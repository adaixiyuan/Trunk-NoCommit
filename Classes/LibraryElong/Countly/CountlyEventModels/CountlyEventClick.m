//
//  CountlyEventClick.m
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventClick.h"
#import "AccountManager.h"

@implementation CountlyEventClick

- (void) dealloc{
    self.clickSpot = nil;
    self.page = nil;
    self.status = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        if ([[AccountManager instanse] isLogin]) {
            self.status = NUMBER(1);
        }else{
            self.status = NUMBER(2);
        }
    }
    return self;
}

- (void) sendEventCount:(NSInteger)count{
    [super sendEvent:@"click" Count:count];
}
@end
