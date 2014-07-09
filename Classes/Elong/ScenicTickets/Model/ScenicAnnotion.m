//
//  ScenicAnnotion.m
//  ElongClient
//
//  Created by nieyun on 14-5-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicAnnotion.h"

@implementation ScenicAnnotion
- (void)dealloc
{
    [_title release];
    [_subtitle  release];
    [_price release];
    [_name release];
    [_gradeName  release];
    [super dealloc ];
}

@end

@implementation DesAnnotion

- (void)dealloc
{
    [_title release];
    [_subtitle  release];
    [super dealloc];
}

@end