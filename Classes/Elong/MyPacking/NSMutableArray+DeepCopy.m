//
//  NSMutableArray+DeepCopy.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "NSMutableArray+DeepCopy.h"

@implementation NSMutableArray (DeepCopy)

- (NSMutableArray *)mutableDeepCopy
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[self count]];
    for (id value in self)
    {
         id  oneCopy = nil;
        if ([value respondsToSelector:@selector(mutableDeepCopy)]){
            NSMutableArray *array = [value mutableDeepCopy];
            oneCopy = array;
            
            [ret addObject: oneCopy];
            
        }else if ([value respondsToSelector:@selector(mutableCopy)]){
            oneCopy = [value mutableCopy];
            
            [ret addObject: oneCopy];
            [oneCopy release];
            
        }else{
            oneCopy = [value copy];
            [ret addObject: oneCopy];
            [oneCopy release];
        }
    }
    return ret;
}
@end
