//
//  HomeItemRequest.m
//  ElongClient
//
//  Created by Dawn on 14-1-9.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HomeItemRequest.h"

@implementation HomeItemRequest

- (void) dealloc{
    self.logRecords = nil;
    self.logRecordStatus = nil;
    [content release];
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        content = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return self;
}

- (NSString *) requestForLog{
    if (self.logRecords) {
         [content setObject:self.logRecords forKey:@"logRecords"];
    }
    if (self.logRecordStatus) {
        [content setObject:self.logRecordStatus forKey:@"logRecordStatus"];
    }
    return [content JSONString];
}
@end
