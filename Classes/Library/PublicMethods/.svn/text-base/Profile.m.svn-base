//
//  Profile.m
//  ElongClient
//
//  Created by 赵岩 on 13-9-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "Profile.h"

static Profile *instance = nil;

@interface Profile ()

@property (nonatomic, retain, readonly) NSMutableArray *segmentStack;

@end

@implementation Profile

+ (Profile *)shared
{
    if (instance == nil) {
        instance = [[Profile alloc] init];
    }
    
    return instance;
}

- (void)dealloc
{
    [_segmentStack release];
    [_lastResult release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        _segmentStack = [[NSMutableArray array] retain];
    }
    
    return self;
}

- (void)start:(NSString *)name
{
    NSDictionary *begin = [NSDictionary dictionaryWithObject:[NSDate date] forKey:name];
    [_segmentStack addObject:begin];
}

- (void)end:(NSString *)name
{
    NSDate *date = [NSDate date];
    NSDictionary *begin = [_segmentStack lastObject];
    NSDate *beginDate = [begin objectForKey:name];
    if (beginDate) {
        NSTimeInterval timeElapsed = [date timeIntervalSince1970] - [beginDate timeIntervalSince1970];
        [_lastResult release];
        _lastResult = [[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:timeElapsed], @"Time", name, @"Name", nil] retain];
    }
    else {
        
    }
}

@end
