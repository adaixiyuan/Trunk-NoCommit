//
//  RootViewController.h
//  Home
//
//  Created by Dawn on 13-12-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeLayout.h"
#import "HomeItemView.h"
#import "HomeItemsViewController.h"
#import "HomeAdView.h"
#import "PositioningManager.h"
#import "FastPositioning.h"
#import "PrecisePositioning.h"
#import "HomeAdNavi.h"
#import "HomePhoneViewController.h"

typedef enum{
    HomeHotelModule,
    HomeGrouponModule,
    HomeFlightModule,
    HomeTrainModule
}HomeModule;

@class MainPageController, ElongClientAppDelegate,WelcomeViewController;
@interface HomeViewController : UIViewController<HomeItemViewDelegate,HomeItemsViewControllerDelegate,UIActionSheetDelegate,HomeAdNaviDelegate,HomePhoneViewControllerDelegate>{
@private
    BOOL firstrun;                              // 是否第一次启动
    BOOL displayAllBtn;
    BOOL animationBlock;
    MainPageController *mainPageController;
    BOOL addShake;          // 是否启动摇动手势
    WelcomeViewController *welcomeview;
    
    HttpUtil *loginUtil;
    HttpUtil *pushUtil;
    int m_netstate;  //网络请求状态
    HttpUtil *bindUserPushUtil;     // pushtoken绑定
    HttpUtil *unbindUserPushUtil;   // pushtoken解绑
    
    HttpUtil *logUtil;
    HomeAdNavi *adNavi;
}
@property (nonatomic, retain) WelcomeViewController *welcomeview;
@property (nonatomic, retain) MainPageController *mainPageController;
@property (nonatomic,retain) HomeLayout *homeLayout;        // 布局数据源;
@property (nonatomic,retain) UIView     *layoutView;        // 布局容器
@property (nonatomic,assign) BOOL isOpen;

- (void) animtadForClose;				// 芝麻关门动画
- (void) animtadForOpen;
- (void) addwelclomeview;
- (void) goMessageBoxPage;
- (void) goMessageBoxPageUrl:(NSString *)url;
- (void) afterInit;
- (void) endEdit;
- (void) reloadAdSystem;
- (void) openModule:(NSNumber *)objmodule;
- (void) stopAdLoop;
- (void) startAdLoop;
@end
