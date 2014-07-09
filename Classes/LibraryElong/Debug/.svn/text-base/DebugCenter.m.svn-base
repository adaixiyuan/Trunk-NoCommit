//
//  DebugCenter.m
//  ElongClient
//
//  Created by 赵 海波 on 13-1-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DebugCenter.h"
#import "DebugStatbar.h"

static DebugCenter *debugCenter = nil;

@interface DebugCenter ()


@end

@implementation DebugCenter

- (void)dealloc {
    
    [super dealloc];
}


+ (id)shared {
    if (!debugCenter) {
        @synchronized (self) {
            debugCenter = [[DebugCenter alloc] init];
        }
    }
    
    return debugCenter;
}


- (void)starObserveDevice {
    if (!statBar) {
        statBar = [[DebugStatbar alloc] init];
        [statBar starScan];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
