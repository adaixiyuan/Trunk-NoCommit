//
//  ForecastInformation.m
//  ElongClient
//
//  Created by chenggong on 14-6-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ForecastInformation.h"

@implementation ForecastInformation

- (void)dealloc
{
    self.list = nil;
    self.indexes = nil;
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        NSMutableArray *tempMutableArray = [NSMutableArray arrayWithCapacity:0];
        self.list = tempMutableArray;
        
        NSMutableArray *tempMutableIndexes = [NSMutableArray arrayWithCapacity:0];
        self.indexes = tempMutableIndexes;
    }
    return self;
}

+ (ForecastInformation *)shareInstance
{
    static ForecastInformation *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[ForecastInformation alloc] init];
    });
    
    return _shareInstance;
}

- (NSString *)getDaytimeMPAtIndex:(NSUInteger)index
{
    return [[_list safeObjectAtIndex:index] safeObjectForKey:@"dayTimeMP"];
}

- (NSString *)getNightMPAtIndex:(NSUInteger)index
{
    return [[_list safeObjectAtIndex:index] safeObjectForKey:@"nightMP"];
}

- (NSString *)getDayTimeTemperatureAtIndex:(NSUInteger)index
{
    return [[_list safeObjectAtIndex:index] safeObjectForKey:@"dayTimeTemperature"];
}

- (NSString *)getNightTemperatureAtIndex:(NSUInteger)index
{
    return [[_list safeObjectAtIndex:index] safeObjectForKey:@"nightTemperature"];
}

- (NSString *)getDayTimeWDAtIndex:(NSUInteger)index
{
    return [[_list safeObjectAtIndex:index] safeObjectForKey:@"dayTimeWD"];
}

- (NSString *)getNightWDAtIndex:(NSUInteger)index
{
  return [[_list safeObjectAtIndex:index] safeObjectForKey:@"nightWD"];
}

- (NSString *)getDayTimeWPAtIndex:(NSUInteger)index
{
    return [[_list safeObjectAtIndex:index] safeObjectForKey:@"dayTimeWP"];
}

- (NSString *)getNightWPAtIndex:(NSUInteger)index
{
    return [[_list safeObjectAtIndex:index] safeObjectForKey:@"nightWP"];
}

- (NSString *)getSunriseSunsetTimeAtIndex:(NSUInteger)index
{
    return [[_list safeObjectAtIndex:index] safeObjectForKey:@"sunriseSunsetTime"];
}

- (NSString *)getAdviceFromIndexesAtIndex:(NSUInteger)index
{
    return [[_indexes safeObjectAtIndex:index] safeObjectForKey:@"content"];
}

@end
