//
//  DebugStatbar.m
//  ElongClient
//
//  Created by 赵 海波 on 13-1-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DebugStatbar.h"
#import "UIDevice-Hardware.h"
#import "ServiceConfig.h"
#import "DebugServerListViewController.h"
#import "DebugDataCacheViewController.h"
#import "DebugNetworkViewController.h"
#import "CrashListVC.h"
#import "DebugModulesViewController.h"
#import "DebugNetStatisticsViewController.h"

#define BACK_COLOR [UIColor colorWithRed:212 / 255.0 green:209 / 255.0 blue:207 / 255.0 alpha:1]



@implementation DebugStatbar

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [cpuLabel release];
    [ramLabel release];
    [profileLabel release];
    [timer invalidate];
    
    [super dealloc];
}


- (id)init {
    if (self = [super initWithFrame:CGRectMake(100, 0, 220, 19)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarningTip:) name:@"UIApplicationDidReceiveMemoryWarningNotification" object:nil];
        
        self.backgroundColor = BACK_COLOR;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        displaySelf = YES;
        
        UILabel *label = nil;
        UIDevice *device = [UIDevice currentDevice];
        
        // 添加cpu显示
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 73, 19)];
        NSArray *usage = [device cpuUsage];
        NSMutableString *usageStr = [NSMutableString stringWithFormat:@""];
        for (NSNumber *u in usage) {
            [usageStr appendString:[NSString stringWithFormat:@"%.1f%% ", [u floatValue]]];
        }
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = FONT_10;
        label.textAlignment = UITextAlignmentRight;
        label.text = usageStr;
        [self addSubview:label];
        cpuLabel = label;
        SFRelease(label);
        
        // 添加ram显示
        label = [[UILabel alloc] initWithFrame:CGRectMake(73, 0, 73, 19)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = FONT_10;
        label.textAlignment = UITextAlignmentRight;
        label.text = [NSString stringWithFormat:@"%.1f / %uM", [device freeMemoryBytes] / 1024.0 / 1024.0, [device totalMemoryBytes] / 1024 / 1024];
        [self addSubview:label];
        ramLabel = label;
        SFRelease(label);
        
        // 添加性能分析显示
        label = [[UILabel alloc] initWithFrame:CGRectMake(146, 0, 73, 19)];
        label.text = @"秒";
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = FONT_10;
        label.textAlignment = UITextAlignmentRight;
        [self addSubview:label];
        profileLabel = label;
        SFRelease(label);
        
        // 添加长按手势出配置界面
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(popConfigView)];
        [self addGestureRecognizer:gesture];
        [gesture release];
    }
    
    return self;
}


// 推出配置页面
- (void)popConfigView {
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    float transA = delegate.window.rootViewController.view.transform.a;
    
    if (transA < 1.0) {
        if ([delegate.startup modalViewController]){
            return;
        }
    }else{
        if([delegate.window.rootViewController modalViewController]){
            return;
        }
    }
    
    
    DebugServerListViewController *serverListVC = [[DebugServerListViewController alloc] init];
    UINavigationController *serverListNav = [[UINavigationController alloc] initWithRootViewController:serverListVC];
    [serverListVC release];
    DebugDataCacheViewController *dataCacheVC = [[DebugDataCacheViewController alloc] init];
    UINavigationController *dataCacheNav = [[UINavigationController alloc] initWithRootViewController:dataCacheVC];
    [dataCacheVC release];
    
    
    DebugNetworkViewController *networkVC = [[DebugNetworkViewController alloc] initWithType:NetworkChartList key:nil page:NO];
    UINavigationController *networkNav = [[UINavigationController alloc] initWithRootViewController:networkVC];
    [networkVC release];
    
    
//    DebugNetStatisticsViewController *networkVC = [[DebugNetStatisticsViewController alloc] init];
//    UINavigationController *networkNav = [[UINavigationController     alloc] initWithRootViewController:networkVC];
//    [networkVC release];
    
    CrashListVC *crashListVC = [[CrashListVC alloc] init];
    
    NSArray *arrayCrashInfo = [Utils arrayDateSaved:kCrashInfoFile andSaveKey:kCrashInfoArchiverKey];
    
    if (ARRAYHASVALUE(arrayCrashInfo))
    {
        [crashListVC setArrayCrashInfo:arrayCrashInfo];
    }
    UINavigationController *crashListNav = [[UINavigationController alloc] initWithRootViewController:crashListVC];
    [crashListVC release];
    DebugModulesViewController *modulesVC = [[DebugModulesViewController alloc] init];
    UINavigationController *modulesNav = [[UINavigationController alloc] initWithRootViewController:modulesVC];
    [modulesVC release];
    
    serverListVC.title = @"服务指向";
    serverListVC.tabBarItem.image = [UIImage noCacheImageNamed:@"debug_item0.png"];
    dataCacheVC.title = @"数据存储";
    dataCacheVC.tabBarItem.image = [UIImage noCacheImageNamed:@"debug_item1.png"];
    networkVC.title = @"网络请求";
    networkVC.tabBarItem.image = [UIImage noCacheImageNamed:@"debug_item2.png"];
    crashListVC.title = @"Crash日志";
    crashListVC.tabBarItem.image = [UIImage noCacheImageNamed:@"debug_item3.png"];
    modulesVC.title = @"模块开关";
    modulesVC.tabBarItem.image = [UIImage noCacheImageNamed:@"debug_item4.png"];
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:serverListNav,dataCacheNav,networkNav, crashListNav,modulesNav,nil];
    [serverListNav release];
    [dataCacheNav release];
    [crashListNav release];
    [modulesNav release];
    [networkNav release];
    
    
    
    if (IOSVersion_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [tabBarController setNeedsStatusBarAppearanceUpdate];
    }

    if (transA < 1.0) {
        [delegate.startup presentModalViewController:tabBarController animated:YES];
        [tabBarController release];
    }else{
        [delegate.window.rootViewController presentModalViewController:tabBarController animated:YES];
        [tabBarController release];
    }
}


- (void)memoryWarningTip:(NSNotification *)noti {
    NSLog(@"noti:%@", [noti object]);
    NSLog(@"noti:%@", [noti userInfo]);
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionAutoreverse animations:^{
                            self.backgroundColor = [UIColor yellowColor];
                        }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.backgroundColor = BACK_COLOR;
                         }
                     }];
}


- (void)starScan {
    self.hidden = NO;
    
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshInfo) userInfo:nil repeats:YES];
    }
}


- (void)refreshInfo {
    // 实时更新资源使用情况
    UIDevice *device = [UIDevice currentDevice];
    NSArray *usage = [device cpuUsage];
    
    NSMutableString *usageStr = [NSMutableString stringWithFormat:@""];
    for (NSNumber *u in usage) {
        [usageStr appendString:[NSString stringWithFormat:@"%.1f%% ", [u floatValue]]];
    }
    cpuLabel.text = usageStr;
    
    ramLabel.text = [NSString stringWithFormat:@"%.1f / %uM", [device freeMemoryBytes] / 1024.0 / 1024.0, [device totalMemoryBytes] / 1024 / 1024];
    
    profileLabel.text = [NSString stringWithFormat:@"%.3f秒", [[[Profile shared].lastResult objectForKey:@"Time"] doubleValue]];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
	if (CGRectContainsPoint(CGRectMake(0, 0, self.bounds.size.width - 60, self.bounds.size.height), [touch locationInView:self])) {
        // 防止与点home键时误点击，缩小区域
        if (displaySelf) {
            self.backgroundColor = [UIColor clearColor];
            for (UIView *subView in self.subviews) {
                subView.hidden = YES;
            }
            
            displaySelf = NO;
            [timer invalidate];
            timer = nil;
        }
        else {
            self.backgroundColor = BACK_COLOR;
            for (UIView *subView in self.subviews) {
                subView.hidden = NO;
            }
            
            displaySelf = YES;
            [self starScan];
        }
	}
}

@end
