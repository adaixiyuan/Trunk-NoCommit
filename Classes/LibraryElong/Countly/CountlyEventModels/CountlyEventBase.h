//
//  CountlyEventBase.h
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CountlyEvent.h"
#import "Countly.h"
#import <objc/runtime.h>

@interface CountlyEventBase : NSObject

- (void) sendEvent:(NSString *)event Count:(NSInteger)count;
@end
