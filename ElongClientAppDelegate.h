//
//  ElongClientAppDelegate.h
//  ElongClient
//
//  Created by bin xing on 10-12-28.
//  Copyright 2010 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "WXApi.h"
#import "ABNotifier.h"
#import "CalendarContentCell.h"
#import "ElCalendarView.h"
#import "QAppKeyCheck.h"

@class HomeViewController,Update;
@class GrouponHomeViewController;
@class WelcomeViewController;

@class HttpUtil;

@interface ElongClientAppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate,WXApiDelegate,ABNotifierDelegate,QAppKeyCheckDelegate> {
    UINavigationController *navigationController;
	Update* m_update;
	BOOL navDrawEnabled;
    BOOL isStart;                       // 判断程序是否刚启动
    WelcomeViewController *welcomeview;
    int netType;
    HttpUtil *net_type_checkdataUtil;
    HttpUtil *activatorUtil;            // 激活请求
    HttpUtil *pushTokenUtil;
    QAppKeyCheck* qAppKeycheck;
}

@property (nonatomic) BOOL navDrawEnabled;
@property (nonatomic) BOOL isNonmemberFlow;				// 是否处于非注册用户流程,default = NO
@property (nonatomic,retain) NSDate *dormantTime;				// 程序切入后台的时间
@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic,retain) HomeViewController *startup;
@property (nonatomic,retain) WelcomeViewController *welcomeview;
@property (nonatomic,retain) UIView *coverView;
@property (nonatomic,retain) UIWindow *window;
@property (nonatomic,assign) BOOL netCheckNeeded;
@property (nonatomic,assign) BOOL timezoneCheckNeeded;

- (BOOL)isSingleTask;
- (void)parseURL:(NSURL *)url application:(UIApplication *)application;
- (void)closeWelcomeView;
-(BOOL)checkUpdateActive:(BOOL)active;
-(void)deleteFile;
@end