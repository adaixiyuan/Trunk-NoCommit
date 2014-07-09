//
//  HomeItem.m
//  Home
//
//  Created by Dawn on 13-12-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "HomeItem.h"

@implementation HomeItem

- (void) dealloc{
    self.title = nil;
    self.background = nil;
    self.subitems = nil;
    self.subtitle = nil;
    self.actions = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone{
    HomeItem *item = [[[self class] allocWithZone:zone] init];
    item.tag = self.tag;
    item.fixed = self.fixed;
    item.deletable = self.deletable;
    item.scrollable = self.scrollable;
    item.action = self.action;
    item.title = [NSString stringWithFormat:@"%@",self.title];
    item.subtitle = [NSString stringWithFormat:@"%@",self.subtitle];
    item.x = self.x;
    item.y = self.y;
    item.width = self.width;
    item.height = self.height;
    item.contentWidth = self.contentWidth;
    item.contentHeight = self.contentHeight;
    item.background = [NSString stringWithFormat:@"%@",self.background];
    item.superItem = self.superItem;
    item.selected = self.selected;
    item.timeInterval = self.timeInterval;
    item.animationInterval = self.animationInterval;
    
    if (self.subitems) {
        item.subitems = [NSMutableArray array];
        for (HomeItem *subitem in self.subitems) {
            HomeItem *newSubitem = [subitem copy];
            [item.subitems addObject:newSubitem];
            [newSubitem release];
        }
    }
    if (self.actions) {
        item.actions = [NSMutableArray array];
        for (HomeItem *action in self.actions) {
            HomeItem *newAction = [action copy];
            [item.actions addObject:newAction];
            [newAction release];
        }
    }
    return item;
}
@end
