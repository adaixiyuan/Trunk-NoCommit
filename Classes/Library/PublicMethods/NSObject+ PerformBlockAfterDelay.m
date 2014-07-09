//
//  NSObject+ PerformBlockAfterDelay.m
//  LeiJiaStar
//
//  Created by 李 程 on 13-7-19.
//  Copyright (c) 2013年 licheng. All rights reserved.
//

#import "NSObject+ PerformBlockAfterDelay.h"
//延迟操作



@implementation NSObject(PerformBlockAfterDelay)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay

{
    block = [[block copy] autorelease];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {

    block();
    
}

-(void)cancelBlock:(void (^)(void))block{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fireBlockAfterDelay:) object:block];
}


@end
