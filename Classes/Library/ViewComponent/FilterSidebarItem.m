//
//  FilterSidebarItem.m
//  ElongClient
//
//  Created by Dawn on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FilterSidebarItem.h"

@implementation FilterSidebarItem

- (void) dealloc{
    self.image = nil;
    self.color = nil;
    self.highlightColor = nil;
    self.image = nil;
    self.viewController = nil;
    [super dealloc];
}

@end
