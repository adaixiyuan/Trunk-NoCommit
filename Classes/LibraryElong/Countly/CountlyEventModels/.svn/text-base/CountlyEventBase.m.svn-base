//
//  CountlyEventBase.m
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventBase.h"
#import "CountlyEventShow.h"
#import "CountlyEventClick.h"

@implementation CountlyEventBase
- (void) sendEvent:(NSString *)event Count:(NSInteger)count {
    if (!COUNTLY) {
        return;
    }
    
    NSMutableArray *properties = [NSMutableArray array];
    if ([self isMemberOfClass:[CountlyEventClick class]]
        || [self isMemberOfClass:[CountlyEventShow class]]) {
        [properties addObjectsFromArray:[self getProperties:[self class]]];
    }else{
        [properties addObjectsFromArray:[self getProperties:[self class]]];
        [properties addObjectsFromArray:[self getProperties:self.superclass]];

    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *key in properties) {
        if ([self valueForKey:key]) {
            [params setObject:[self valueForKey:key] forKey:key];    
        }else{
            // 没有数据时传递空串
            [params setObject:@"" forKey:key];
        }
    }
    
    [[Countly sharedInstance] recordEvent:event segmentation:params count:count];
}

- (NSArray *)getProperties:(Class)class{
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &propertyCount);
    
    NSMutableArray *properties = [NSMutableArray array];
    for (int i = 0; i < propertyCount; i++ ) {
        objc_property_t *thisProperty = propertyList + i;
        const char* propertyName = property_getName(*thisProperty);
        [properties addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(propertyList);
    return properties;
}
@end
