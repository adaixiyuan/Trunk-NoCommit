//
//  SceneryList.m
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SceneryList.h"

@implementation SceneryList
- (void)dealloc
{
    [_sceneryName  release];
    [_sceneryId  release];
    [_scenerySummary  release];
    [_imgPath  release];
    [_gradeId  release];
    [_gradeName  release];
    [_themeList  release];
    [_lon  release];
    [_lat release];
    [_bookFlag  release];
    [_score  release];
    [_elongPrice  release];
    [_price  release];
    [super dealloc];
}
@end
