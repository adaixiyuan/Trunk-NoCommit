//
//  ServiceConfig.m
//  ElongClient
//
//  Created by 赵 海波 on 13-6-14.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ServiceConfig.h"

#define MONKEY_SWITCH_DEFAULT      NO           // 默认不打开monkey
#define HTTPS_SWITCH_DEFAULT       YES          // 默认打开https

static ServiceConfig *config = nil;

@implementation ServiceConfig

@synthesize serverURL;

- (void)dealloc {
    self.serverURL = nil;
    
    [super dealloc];
}


- (id)init {
    if (self = [super init]) {
        // 默认配置，谨慎修改!
        NSString *serverUrl = [[NSUserDefaults standardUserDefaults] objectForKey:SERVERURL];
        if (serverUrl) {
            self.serverURL = serverUrl;
        }
        else {
            self.serverURL = DEFAULT_SERVER;
        }
        
        NSNumber *monkeySwitch = [[NSUserDefaults standardUserDefaults] objectForKey:MONKEY_SWITCH];
        if (monkeySwitch) {
            _monkeySwitch = [monkeySwitch boolValue];
        }
        else {
            _monkeySwitch = MONKEY_SWITCH_DEFAULT;
        }
        
        NSNumber *httpsSwitch = [[ElongUserDefaults sharedInstance] objectForKey:HTTPS_SWITCH];
        if (httpsSwitch) {
            _httpsSwitch = [httpsSwitch boolValue];
        }else{
            _httpsSwitch = HTTPS_SWITCH_DEFAULT;
        }
    }
    
    return self;
}


+ (id)share {
    @synchronized(config) {
        if (!config) {
            config = [[ServiceConfig alloc] init];
        }
    }
    
    return config;
}


@end
