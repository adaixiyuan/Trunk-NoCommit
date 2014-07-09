//
//  HomeAdRequest.m
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HomeAdRequest.h"
#import "PostHeader.h"
#import <sys/sysctl.h>

@implementation HomeAdRequest

- (void) dealloc{
    [content release];
    self.phoneType = nil;
    self.dimension = nil;
    self.adId = 0;
    self.adType = 0;
    self.jumpType = 0;
    self.jumpLink = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        content = [[NSMutableDictionary alloc] init];
        self.phoneType = @"";
        self.dimension = @"";
        self.adId = 0;
        self.adType = 0;
        self.jumpLink = @"";
        self.jumpType = 0;
        
        #if TARGET_IPHONE_SIMULATOR
            self.phoneType = @"iPhone Simulator";
        #else
            size_t size = 256;
            char *machine = malloc(size);
            #if TARGET_OS_IPHONE
                sysctlbyname("hw.machine", machine, &size, NULL, 0);
            #else
                sysctlbyname("hw.model", machine, &size, NULL, 0);
        #endif
            self.phoneType = [[[NSString alloc] initWithCString:machine encoding:NSUTF8StringEncoding] autorelease];
            free(machine);
        #endif

        float scale = [UIScreen mainScreen].scale;
        //[UIScreen mainScreen].scale
        self.dimension = [NSString stringWithFormat:@"%.f*%.f",SCREEN_WIDTH * scale,SCREEN_HEIGHT * scale];
    }
    return self;
}

- (NSString *) requestForAds{
    [content safeSetObject:self.phoneType forKey:@"phoneType"];
    [content safeSetObject:self.dimension forKey:@"dimension"];
    
    NSLog(@"%@",content);
    return [content JSONString];
}

- (NSString *) requestForClickAds{
    [content safeSetObject:self.phoneType forKey:@"phoneType"];
    [content safeSetObject:self.dimension forKey:@"dimension"];
    [content safeSetObject:[NSNumber numberWithInt:self.adId] forKey:@"adId"];
    [content safeSetObject:[NSNumber numberWithInt:self.adType] forKey:@"adType"];
    [content safeSetObject:[NSNumber numberWithInt:self.jumpType] forKey:@"jumpType"];
    [content safeSetObject:self.jumpLink forKey:@"jumpLink"];
    
    NSLog(@"%@",content);
    return [content JSONString];
}

@end
