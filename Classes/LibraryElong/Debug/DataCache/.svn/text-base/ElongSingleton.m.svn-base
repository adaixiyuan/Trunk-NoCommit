//
//  ElongSingleton.m
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

static NSMutableArray *singletonSet = nil;

#import "ElongSingleton.h"

@implementation ElongSingleton

DEF_SINGLETON(ElongSingleton)

+ (NSMutableArray *)singletonSet{
    if (!singletonSet) {
        singletonSet = [[NSMutableArray alloc] init];
    }
    return singletonSet;
}


#pragma mark -
#pragma mark ElongCacheDebugProtocol

- (NSString *) dataLogs{
    return [singletonSet JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
}

- (NSArray *) allKeys{
    NSMutableArray *array = [NSMutableArray array];
    for (NSObject *object in singletonSet) {
        [array addObject:[NSString stringWithUTF8String:object_getClassName(object)]];
    }
    return array;
}

- (NSArray *) allObjects{
    NSMutableArray *array = [NSMutableArray array];
    for (NSObject *object in singletonSet) {
        [array addObject:[NSString stringWithUTF8String:object_getClassName(object)]];
    }
    return array;
}

- (NSObject *) objectForKey:(NSString *)key{
    for (NSString *value in [self allObjects]) {
        if ([key isEqualToString:value]) {
            return value;
        }
    }
    return @"";
}

@end
