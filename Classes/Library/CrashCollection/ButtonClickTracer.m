//
//  ButtonClickTracer.m
//  ElongClient
//
//  Created by chenggong on 13-9-29.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ButtonClickTracer.h"
#import "TraceCommonDefine.h"
#import "CrashCollectionLog.h"

static ButtonClickTracer *instance = Nil;

@implementation ButtonClickTracer

- (id)init {
    self = [super init];
    if (self) {
        // Initialize self.
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

+ (id)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ButtonClickTracer alloc] init];
    });
    return instance;
}

- (void)buttonClickTarget:(id)target action:(SEL)action {
    const char *targetObjectCName = object_getClassName(target);
    NSString *targetObjectNSName = [NSString stringWithUTF8String:targetObjectCName];
    NSString *actionSelectorName = NSStringFromSelector(action);

    // TODO: Invoke MobClick to statistics
//    NSDictionary *traceInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:targetObjectNSName, kTraceButtonClickTarget, actionSelectorName, kTraceButtonCLickAction, nil];
//    [MobClick event:Event_TraceButtonClick attributes:traceInfoDic];
    
    // TODO: Log click track.
    [[CrashCollectionLog sharedInstance] logTarget:targetObjectNSName action:actionSelectorName];
//    kill(getpid(), SIGABRT);
//    [(id)1 release];
//    [NSObject hi];
}

@end
