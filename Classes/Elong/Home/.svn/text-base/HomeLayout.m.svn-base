//
//  HomeLayout.m
//  Home
//
//  Created by Dawn on 13-12-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "HomeLayout.h"
#import "HomeItem.h"

@interface HomeLayout()
@property (nonatomic,copy) NSString *layoutFilePath;
@property (nonatomic,retain) NSMutableDictionary *layoutDict;
@property (nonatomic,assign) float version;
@end

@implementation HomeLayout

- (void) dealloc{
    self.layoutFilePath = nil;
    self.layoutDict = nil;
    self.items = nil;
    [super dealloc];
}

// 通过布局文件名构造布局类
- (id) initWithFileName:(NSString *)fileName{
    if (self = [super init]) {
        // 首先检测用户配置文件是否存在，如果存在直接读取用户配置文件，如果不存在读取默认配置文件
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.layoutFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.layoutFilePath]){
            NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
            self.layoutDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        }else{
            self.layoutDict = [NSMutableDictionary dictionaryWithContentsOfFile:self.layoutFilePath];
            // 校验数据正确性
            if (!self.layoutDict || [[self.layoutDict allKeys] count] == 0) {
                // 出现文件损坏情况，读取原始配置文件
                NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
                self.layoutDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
            }else{
                // 校验版本，如果发现新版本就读取原始配置文件
                NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
                NSMutableDictionary *localDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
                float newVersion = [[localDict objectForKey:@"version"] floatValue];
                float currentVersion = [[self.layoutDict objectForKey:@"version"] floatValue];
                if (newVersion > currentVersion) {
                    self.layoutDict = localDict;
                }
            }
        }
        
        // 填充数据模型
        [self fillDataModel];
    }
    return self;
}

// 读取默认配置文件
- (id) initWithDefaultFileName:(NSString *)fileName{
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.layoutFilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        self.layoutDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        // 填充数据模型
        [self fillDataModel];
    }
    return self;
}


// 保存配置信息到本地
- (void) save{
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:self.items.count];
    for (HomeItem *item in self.items) {
        NSMutableDictionary *itemDict = [self fillDictWithItem:item];
        [itemDict retain];
        [itemArray addObject:itemDict];
        [itemDict release];
    }
    if (SCREEN_4_INCH) {
        [self.layoutDict setObject:itemArray forKey:@"screen_4.0"];
    }else{
        [self.layoutDict setObject:itemArray forKey:@"screen_3.5"];
    }
    [self.layoutDict writeToFile:self.layoutFilePath atomically:YES];
    
    NSLog(@"save layout file version%.2f",self.version);
}

// 填充数据模型
- (void) fillDataModel{
    self.version =  [[self.layoutDict objectForKey:@"version"] floatValue];
    NSArray *itemArray = nil;
    if (SCREEN_4_INCH) {
        // 4inch屏幕
        itemArray = [self.layoutDict objectForKey:@"screen_4.0"];
    }else{
        // 3.5inch屏幕
        itemArray = [self.layoutDict objectForKey:@"screen_3.5"];
    }
    self.items = [NSMutableArray arrayWithCapacity:itemArray.count];
    for (NSDictionary *itemDict in itemArray) {
        HomeItem *item = [self fillItemWithDict:itemDict];
        item.superItem = nil;
        [item retain];
        [self.items addObject:item];
        [item release];
    }
}

- (NSMutableDictionary *)fillDictWithItem:(HomeItem *)item{
    NSMutableDictionary *itemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:item.tag],@"tag",
                                     [NSNumber numberWithBool:item.fixed],@"fixed",
                                     [NSNumber numberWithBool:item.deletable],@"deletable",
                                     [NSString stringWithFormat:@"%@",item.title],@"title",
                                     [NSString stringWithFormat:@"%@",item.subtitle],@"subtitle",
                                     [NSNumber numberWithFloat:item.x],@"x",
                                     [NSNumber numberWithFloat:item.y],@"y",
                                     [NSNumber numberWithFloat:item.width],@"width",
                                     [NSNumber numberWithFloat:item.height],@"height",
                                     [NSNumber numberWithBool:item.scrollable],@"scrollable",
                                     [NSNumber numberWithBool:item.action],@"action",
                                     [NSNumber numberWithFloat:item.contentWidth],@"content_width",
                                     [NSNumber numberWithFloat:item.contentHeight],@"content_height",
                                     [NSNumber numberWithFloat:item.timeInterval],@"time_interval",
                                     [NSNumber numberWithFloat:item.animationInterval],@"animation_interval",
                                     item.background,@"background",nil];
    
    if (item.subitems) {
        NSMutableArray *itemArray = [NSMutableArray array];
        for (HomeItem *subitem in item.subitems) {
            [itemArray addObject:[self fillDictWithItem:subitem]];
        }
        [itemDict setObject:itemArray forKey:@"subitems"];
    }
    
    if (item.actions) {
        NSMutableArray *actionArray = [NSMutableArray array];
        for (HomeItem *actionItem in item.actions) {
            [actionArray addObject:[self fillDictWithItem:actionItem]];
        }
        [itemDict setObject:actionArray forKey:@"actions"];
    }
    
    return itemDict;
}

- (HomeItem *) fillItemWithDict:(NSDictionary *)dict{
    HomeItem *item = [[HomeItem alloc] init];
    item.tag = [[dict objectForKey:@"tag"] intValue];
    item.fixed = [[dict objectForKey:@"fixed"] boolValue];
    item.deletable = [[dict objectForKey:@"deletable"] boolValue];
    item.title = [dict objectForKey:@"title"];
    item.subtitle = [dict objectForKey:@"subtitle"];
    item.x = [[dict objectForKey:@"x"] floatValue];
    item.y = [[dict objectForKey:@"y"] floatValue];
    item.width = [[dict objectForKey:@"width"] floatValue];
    item.height = [[dict objectForKey:@"height"] floatValue];
    item.background = [dict objectForKey:@"background"];
    item.scrollable = [[dict objectForKey:@"scrollable"] boolValue];
    item.contentWidth = [[dict objectForKey:@"content_width"] floatValue];
    item.contentHeight = [[dict objectForKey:@"content_height"] floatValue];
    item.action = [[dict objectForKey:@"action"] boolValue];
    item.timeInterval = [[dict objectForKey:@"time_interval"] floatValue];
    item.animationInterval = [[dict objectForKey:@"animation_interval"] floatValue];
    
    if ([dict objectForKey:@"actions"]) {
        item.actions = [NSMutableArray array];
        for (NSDictionary *action in [dict objectForKey:@"actions"]) {
            [item.actions addObject:[self fillItemWithDict:action]];
        }
    }
    if (item.scrollable) {
        item.subitems = [NSMutableArray array];
         for (NSDictionary *subitemDict in [dict objectForKey:@"subitems"]) {
             HomeItem *subitem = [self fillItemWithDict:subitemDict];
             subitem.superItem = item;
             [subitem retain];
             [item.subitems addObject:subitem];
             [subitem release];
         }
    }
    return [item autorelease];
}

@end
