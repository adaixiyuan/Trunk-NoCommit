//
//  RootViewController.m
//  Home
//
//  Created by Dawn on 13-12-4.
//  Copyright (c) 2013年 Dawn. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeItem.h"
#import "HomeItemView.h"
#import "HomeItemsViewController.h"
#import "HomeAdView.h"
#import "ElongClientAppDelegate.h"
#import "MainPageController.h"
#import "DPNavigationBar.h"
#import <QuartzCore/QuartzCore.h>
#import "WelcomeViewController.h"
#import "TokenReq.h"
#import "HomeAdRequest.h"
#import "HomeItemRequest.h"
#import "CountlyEventHomePageBlock.h"
#import "CountlyEventHomePageAdbanner.h"
#import "CountlyEventShow.h"
#import "HomeAdNavi.h"

static float aniTime  = .5f;			// 芝麻开门动画执行时间
static float scalRate = .8f;			// 芝麻开门动画缩放比例
static float offset = 10.0f;
static double adcachetime = 30 * 60;     // 广告的缓存时间 30min to do by dawn
static double adlasttime = 0;

#define kUserInfo    1002
#define kHotelDetail 1003

@interface HomeViewController ()

@property (nonatomic,assign) NSInteger  actionItemIndex;    // 当前活动的Item的Index
@property (nonatomic,assign) NSInteger  itemCount;          // 可滑动的Item的数量
@property (nonatomic,assign) CGRect     itemFrame;          // 记录活动Item的初始位置
@property (nonatomic,assign) float      offsetY;            // 用来判断手指滑动的方向
@property (nonatomic,assign) UIScrollView *scrollView;
@property (nonatomic,assign) HomeItemView *scrollItemView;
@property (nonatomic,assign) ElongClientAppDelegate *appDelegate;

@property (nonatomic,retain) UIView     *coverView;         // 蒙版
@property (nonatomic,retain) HomeItemView *adItem;
@property (nonatomic,retain) HttpUtil   *adsUtil;
@property (nonatomic,retain) HttpUtil   *adsClickUtil;
@property (nonatomic,retain) NSArray    *adArray;
@end

@implementation HomeViewController
@synthesize mainPageController;
@synthesize welcomeview;
@synthesize adItem;

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void) dealloc{
    self.homeLayout  = nil;
    self.layoutView  = nil;
    self.appDelegate = nil;
    self.coverView   = nil;
    self.mainPageController = nil;
    self.adItem      = nil;
    [self.adsUtil cancel];
    self.adsUtil    = nil;
    [self.adsClickUtil cancel];
    self.adsClickUtil = nil;
    self.adArray    = nil;
    
    self.welcomeview = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (pushUtil) {
        [pushUtil cancel];
        SFRelease(pushUtil);
    }
	
    if (loginUtil) {
        [loginUtil cancel];
        SFRelease(loginUtil);
    }
    if (logUtil) {
        [logUtil cancel];
        [logUtil release];
        logUtil = nil;
    }
    if (bindUserPushUtil) {
        [bindUserPushUtil cancel];
        SFRelease(bindUserPushUtil);
    }
    if (unbindUserPushUtil) {
        [unbindUserPushUtil cancel];
        SFRelease(unbindUserPushUtil);
    }
    [adNavi release];
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        // app delegate
        self.appDelegate = (ElongClientAppDelegate*)[[UIApplication sharedApplication] delegate];
        self.mainPageController = (MainPageController *)self.appDelegate.navigationController.topViewController;
        
        //
        NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:(NSString *)kCFBundleVersionKey];
        NSString* firstrunstring = [dater objectForKey:@"firstrunwithoutnetwork"];
        
        //第一次启动
        if(firstrunstring == nil || ![firstrunstring isEqualToString:version]){
            firstrun = YES;
            NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
            [dater setValue:version forKey:@"firstrunwithoutnetwork"];
            [dater synchronize];
        }else{
            firstrun = NO;
        }
        
		displayAllBtn = NO;
		animationBlock = NO;
        
        // 监听龙萃登录
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setcount:) name:NOTI_LONGVIP object:nil];
		
		// 定位
		[[FastPositioning shared] fastPositioning];
		
        // 设置自动登录时，在此发起登录请求
		Setting *set = [SettingManager instanse];
		if ([set isAutoLogin]) {
            if ([set defaultAccount] && [set defaultPwd] && ![[set defaultAccount] isEqualToString:@""] && ![[set defaultPwd] isEqualToString:@""]) {
                
                JLogin *jlogin = [LoginRegisterPostManager instanse];
                [jlogin setAccount:[set defaultAccount] password:[set defaultPwd]];
                
                if (loginUtil) {
                    [loginUtil cancel];
                    SFRelease(loginUtil);
                }
                
                loginUtil = [[HttpUtil alloc] init];
                [loginUtil connectWithURLString:LOGINURL Content:[jlogin requesString:NO] StartLoading:NO EndLoading:NO Delegate:self];
            }else{
                TokenReq *tokenReq = [TokenReq shared];
                NSString *token = [tokenReq accessToken];
                if (token) {
                    if (loginUtil) {
                        [loginUtil cancel];
                        SFRelease(loginUtil);
                    }
                    
                    loginUtil = [[HttpUtil alloc] init];
                    
                    JToken *jtoken = [LoginRegisterPostManager tokenInstanse];
                    [jtoken setToken:token];
                    [loginUtil connectWithURLString:LOGINURL Content:[jtoken requesString:NO] StartLoading:NO EndLoading:NO Delegate:self];
                }
            }
		}
        
        adNavi = [[HomeAdNavi alloc] init];
        adNavi.delegate = self;
    }
    return self;
}

- (void) afterInit{
    if (!IOSVersion_7) {
        self.appDelegate.navigationController.navigationBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        self.appDelegate.navigationController.view.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
    }
    self.appDelegate.navigationController.view.transform = CGAffineTransformMakeScale(scalRate, scalRate);
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // bg color
    self.view.backgroundColor = [UIColor clearColor];
    
    // 禁用多指触摸
    self.view.multipleTouchEnabled = NO;

    // 蒙版
	self.coverView = [[[UIView alloc] initWithFrame:self.view.frame] autorelease];
	self.coverView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:self.coverView];
    
    // 全屏布局
    self.wantsFullScreenLayout = YES;
    self.layoutView = [[[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT- 20)] autorelease];
    [self.view addSubview:self.layoutView];
    
    // 初始化布局数据源
    self.homeLayout = [[[HomeLayout alloc] initWithFileName:@"HomeLayout"] autorelease];
    
    // 加载布局
    for (HomeItem *item in self.homeLayout.items) {
        HomeItemView *homeItemView = [[HomeItemView alloc] initWithDataSource:item];
        homeItemView.delegate = self;
        [self.layoutView addSubview:homeItemView];
        [homeItemView release];
        if (item.scrollable) {
            self.scrollView = homeItemView.scrollView;
            self.scrollItemView = homeItemView;
        }
        
        // 记录广告模块
        switch (item.tag) {
            case 1100:{
                self.adItem = homeItemView;
            }
                break;
        }
    }
    
    // 程序重新启动，并且有新增模块
    if (self.scrollItemView.subitems.count > 3) {
        // 活动功能模块晃动
        [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, 80)];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                [self.scrollView setContentOffset:CGPointMake(0, 0)];
            }];
        }];
    }

    
    addShake = YES;
    
    
    // 引导页面
    //firstrun = YES;
    if (firstrun) {
        welcomeview = [[WelcomeViewController alloc] init];
        welcomeview.view.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT);
        [self.view addSubview:welcomeview.view];
    }

    
    // 加载广告系统
    [self loadAdSystem];
    
    // countly 统计
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_HOMEPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOME;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
}

- (void) loadAdSystem{
    [self.adItem.adView loadAdsWithUrls:[NSArray arrayWithObjects:@"", nil] defaultImage:[UIImage noCacheImageNamed:self.adItem.item.background]];
    [self.adItem.adView startAutoPage];
    
    
    if (self.adsUtil) {
        [self.adsUtil cancel];
        self.adsUtil = nil;
    }
    self.adsUtil = [[[HttpUtil alloc] init] autorelease];
    
    HomeAdRequest *adRequest = [[HomeAdRequest alloc] init];
    NSString *url = [PublicMethods composeNetSearchUrl:@"adv"
                                            forService:@"advInfos"
                                              andParam:[adRequest requestForAds]];
    [adRequest release];
    
    [self.adsUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
    
    // 记录上一次的加载时间
    adlasttime = [[NSDate date] timeIntervalSince1970];
    
}

- (void) reloadAdSystem{
    double nowtime = [[NSDate date] timeIntervalSince1970];
    if (nowtime - adlasttime > adcachetime || self.adArray.count == 0) {
        if (self.adsUtil) {
            [self.adsUtil cancel];
            self.adsUtil = nil;
        }
        self.adsUtil = [[[HttpUtil alloc] init] autorelease];
        
        HomeAdRequest *adRequest = [[HomeAdRequest alloc] init];
        NSString *url = [PublicMethods composeNetSearchUrl:@"adv"
                                                forService:@"advInfos"
                                                  andParam:[adRequest requestForAds]];
        [adRequest release];
        
        [self.adsUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
        // 记录上一次的加载时间
        adlasttime = nowtime;
        
        NSLog(@"超过%.f分钟，更新广告",adcachetime/60);
    }
    
}

- (void) loadAdData{
    if (self.adArray && self.adArray.count) {
        NSMutableArray *ads = [NSMutableArray array];
        for (NSDictionary *dict in self.adArray) {
            [ads addObject:[dict objectForKey:@"picUrl"]];
        }
        if (ads.count > 1) {
            self.adItem.adView.pageControl.hidden = NO;
        }else{
            self.adItem.adView.pageControl.hidden = YES;
        }
        [self.adItem.adView loadAdsWithUrls:ads defaultImage:[UIImage noCacheImageNamed:self.adItem.item.background]];
        [self.adItem.adView startAutoPage];
    }
}

// These methods control the attributes of the status bar when this view controller is shown. They can be overridden in view controller subclasses to return the desired status bar attributes.
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}

// This should be called whenever the return values for the view controller's status bar attributes have changed. If it is called from within an animation block, the changes will be animated along with the rest of the animation block.
//- (void)setNeedsStatusBarAppearanceUpdate NS_AVAILABLE_IOS(7_0);

#pragma mark -
#pragma mark 芝麻开门
- (void)animtadForOpen {
	// 芝麻开门
	if (!animationBlock) {
		animationBlock = YES;
        self.isOpen = YES;
        
        NSMutableArray *activeViews = [NSMutableArray array];
        
        for (HomeItem *item in self.homeLayout.items) {
            if (item.subitems) {
                for (HomeItem *subitem in item.subitems) {
                    HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:subitem.tag];
                    [activeViews addObject:itemView];
                }
            }else{
                HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:item.tag];
                [activeViews addObject:itemView];
            }
        }
		
        self.appDelegate.navigationController.view.transform = CGAffineTransformMakeScale(scalRate, scalRate);
        for (int i = 0; i < activeViews.count; i++) {
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:arc4random()%4];
            [UIView setAnimationDuration:aniTime];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(transformView)];
            
            HomeItemView *itemView = (HomeItemView *)[activeViews objectAtIndex:i];
            if (itemView.adView) {
                [itemView.adView stopAutoPage];
            }
            
            if (itemView.tag == 1100) {
                // 广告
                itemView.frame = CGRectMake(itemView.item.x, itemView.item.y - itemView.item.height - NAVIGATION_BAR_HEIGHT - 20 - offset, itemView.item.width, itemView.item.height);
            }else if(itemView.tag == 1200 || itemView.tag == 1300){
                // 酒店、团购
                itemView.frame = CGRectMake(itemView.item.x - itemView.item.width - offset, itemView.item.y, itemView.item.width, itemView.item.height);
            }else{
                // 其他
                itemView.frame = CGRectMake(itemView.item.x + itemView.item.width + offset, itemView.item.y, itemView.item.width, itemView.item.height);
            }
            
            self.appDelegate.navigationController.view.transform = CGAffineTransformIdentity;
            self.coverView.alpha = 0;
            
            [UIView commitAnimations];
        }

    }
}

- (void)animtadForClose {
	if (!animationBlock) {
		animationBlock = YES;
        
        self.isOpen = NO;

        NSMutableArray *activeViews = [NSMutableArray array];
        
        for (HomeItem *item in self.homeLayout.items) {
            if (item.subitems) {
                for (HomeItem *subitem in item.subitems) {
                    HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:subitem.tag];
                    [activeViews addObject:itemView];
                }
            }else{
                HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:item.tag];
                [activeViews addObject:itemView];
            }
        }
        
        self.appDelegate.navigationController.view.transform = CGAffineTransformIdentity;
		
        for (int i = 0; i < activeViews.count; i++) {
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:arc4random()%4];
            [UIView setAnimationDuration:aniTime];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(clearDelegateNavgationController)];
            HomeItemView *itemView = (HomeItemView *)[activeViews objectAtIndex:i];
            if (itemView.adView) {
                [itemView.adView startAutoPage];
            }
            
            [itemView refresh];
            self.appDelegate.navigationController.view.transform = CGAffineTransformMakeScale(scalRate, scalRate);
            self.coverView.alpha = 1;
            [UIView commitAnimations];
        }
	}
}

- (void)addwelclomeview{
    addShake = YES;
    [self becomeFirstResponder];
    
    animationBlock = NO;
    if (!animationBlock) {
		animationBlock = YES;
        self.coverView.alpha = 0.0f;
		[self.view bringSubviewToFront:self.coverView];
		[self.view bringSubviewToFront:self.layoutView];
		
        
        NSMutableArray *activeViews = [NSMutableArray array];
        
        for (HomeItem *item in self.homeLayout.items) {
            if (item.subitems) {
                for (HomeItem *subitem in item.subitems) {
                    HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:subitem.tag];
                    [activeViews addObject:itemView];
                }
            }else{
                HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:item.tag];
                [activeViews addObject:itemView];
            }
        }
        
        for (int i = 0; i < activeViews.count; i++) {
            HomeItemView *itemView = (HomeItemView *)[activeViews objectAtIndex:i];
            
            if (itemView.tag == 1100) {
                // 广告
                itemView.frame = CGRectMake(itemView.item.x, itemView.item.y - itemView.item.height - NAVIGATION_BAR_HEIGHT - 20 - offset, itemView.item.width, itemView.item.height);
            }else if(itemView.tag == 1200 || itemView.tag == 1300){
                // 酒店、团购
                itemView.frame = CGRectMake(itemView.item.x - itemView.item.width, itemView.item.y - offset, itemView.item.width, itemView.item.height);
            }else{
                // 其他
                itemView.frame = CGRectMake(itemView.item.x + itemView.item.width + offset, itemView.item.y, itemView.item.width, itemView.item.height);
            }
        }

        
		for (int i = 0; i < activeViews.count; i++) {
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:arc4random()%4];
            [UIView setAnimationDuration:aniTime];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(clearWelcomeController)];
            
            HomeItemView *itemView = (HomeItemView *)[activeViews objectAtIndex:i];
            
            [itemView refresh];
            self.appDelegate.navigationController.view.transform = CGAffineTransformMakeScale(scalRate, scalRate);
            self.coverView.alpha = 1;
            [UIView commitAnimations];
        }
	}
}


#pragma mark -
#pragma mark Private
- (void)setcount:(NSNotification *)noti {
    [[AccountManager instanse] setDragon_VIP:[NSString stringWithFormat:@"%d",2]];
}

-(void) goMessageBoxPage{
    //去消息盒子
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    
	[mainPageController goModule:MainTypeMessageBox];
	[self animtadForOpen];
}

- (void) goMessageBoxPageUrl:(NSString *)url{
    if (STRINGHASVALUE(url)) {
        if ([url rangeOfString:@"goto"].length) {
            [adNavi adNaviJumpUrl:url title:@"消息内容"];
        }else{
            [adNavi adNaviJumpUrl:[NSString stringWithFormat:@"gotourl:%@",url] title:@"消息内容"];
        }
    }else{
        [mainPageController goModule:MainTypeMessageBox];
        [self animtadForOpen];
    }
}
    
- (void)transformView {
    // 移除本页，显示内容页
    if (animationBlock) {
        [self.view removeFromSuperview];
        animationBlock = NO;
    }
}

- (void)clearDelegateNavgationController {
	// 清空delegate的堆栈
    if (animationBlock) {
        [self.appDelegate.navigationController popToRootViewControllerAnimated:NO];
        self.appDelegate.navigationController.navigationBarHidden = NO;
        animationBlock = NO;
    }
}

- (void)clearWelcomeController {
	// 清空delegate的堆栈
    if (self.welcomeview) {
        [self.welcomeview.view removeFromSuperview];
        self.welcomeview = nil;
    }
	animationBlock = NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:@"tel://4006661166"]]) {
            [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
        }
    }
}

- (void) adsJump{
    if (self.adArray && self.adArray.count) {
        NSDictionary *item = [self.adArray objectAtIndex:self.adItem.adView.currentPage];
        NSString *jumpLink = [item objectForKey:@"jumpLink"];
        
        // countly 广告点击事件
        CountlyEventHomePageAdbanner *countlyEventHomePageAdbanner = [[CountlyEventHomePageAdbanner alloc] init];
        countlyEventHomePageAdbanner.bannerId = NUMBER([[item safeObjectForKey:@"adId"] intValue]);
        countlyEventHomePageAdbanner.bannerUrl = jumpLink;
        [countlyEventHomePageAdbanner sendEventCount:1];
        [countlyEventHomePageAdbanner release];
        
        // 跳转
        [adNavi adNaviJumpUrl:jumpLink title:[item safeObjectForKey:@"adName"]];
        
        if (self.adsClickUtil) {
            [self.adsClickUtil cancel];
            self.adsClickUtil = nil;
        }
        self.adsClickUtil = [[[HttpUtil alloc] init] autorelease];
        HomeAdRequest *adRequest = [[HomeAdRequest alloc] init];
        adRequest.adId = [[item safeObjectForKey:@"adId"] intValue];
        adRequest.adType = [[item safeObjectForKey:@"adType"] intValue];
        adRequest.jumpType = [[item safeObjectForKey:@"jumpType"] intValue];
        adRequest.jumpLink = [item safeObjectForKey:@"jumpLink"];
        
        NSString *url = [PublicMethods composeNetSearchUrl:@"adv" forService:@"clickRecord"];

        [self.adsClickUtil requestWithURLString:url Content:[adRequest requestForClickAds] StartLoading:NO EndLoading:NO Delegate:nil];
        [adRequest release];
        
        if (UMENG) {
            [MobClick event:Event_Home_Ad label:[NSString stringWithFormat:@"%d",[[item safeObjectForKey:@"adId"] intValue]]];
        }
        
        NSLog(@"记录广告点击");
    }else{
        [mainPageController goModule:MainTypeMessage];
        [self animtadForOpen];
    }
}

#pragma mark -
#pragma mark HomeAdNaviDelegate
- (void) homeAdNaviOpen:(HomeAdNavi *)homeAdNavi{
    if (!self.isOpen) {
        [self animtadForOpen];
    }
}

- (void) homeAdNaviItems:(HomeAdNavi *)homeAdNavi{
    HomeItemsViewController *itemsVC = [[HomeItemsViewController alloc] initWithHomeLayout:self.homeLayout];
    itemsVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:itemsVC];
    if (IOSVersion_7) {
        nav.transitioningDelegate = [ModalAnimationContainer shared];
        nav.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    [itemsVC release];
    
    itemsVC.delegate = self;
    
    [self.adItem.adView stopAutoPage];
    if (IOSVersion_7) {
        [self presentViewController:nav animated:YES completion:nil];
        [nav release];
    }else{
        [self presentModalViewController:nav animated:YES];
        [nav release];
    }
}

#pragma mark -
#pragma mark ShakeGuesture Method

- (BOOL)canBecomeFirstResponder {
	return addShake;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self becomeFirstResponder];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (IOSVersion_7) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self resignFirstResponder];
}

- (void) aroundHotel{
    [self animtadForOpen];
	[mainPageController goModule:MainShakeType];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion != UIEventSubtypeMotionShake) return;
	
	if ([[PositioningManager shared] myCoordinate].longitude==0
        && [[PositioningManager shared] myCoordinate].latitude == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:@"定位失败，请确认已打开手机定位功能"
													   delegate:self
											  cancelButtonTitle:@"确认"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return ;
	}
	
	if ([[PositioningManager shared] isGpsing]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:@"正在校准定位，请稍后尝试"
													   delegate:self
											  cancelButtonTitle:@"确认"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        FastPositioning *position = [FastPositioning shared];
        position.autoCancel = YES;
        [position fastPositioning];
        
		return ;
	}
	
    if (!animationBlock){
        [self aroundHotel];
    }
}

- (void) openModule:(NSNumber *)objmodule{
    NSInteger module = [objmodule intValue];
    switch (module) {
        case HomeHotelModule:{
            // 酒店
            [mainPageController goModule:MainTypeHotel];
            [self animtadForOpen];
        }
            break;
        case HomeGrouponModule:{
            // 团购
            [mainPageController goModule:MainTypeGroupon];
            [self animtadForOpen];
        }
            break;
        case HomeFlightModule:{
            // 机票
            [mainPageController goModule:MainTypeAirplane];
            [self animtadForOpen];
        }
            break;
        case HomeTrainModule:{
            // 火车票
            [mainPageController goModule:MainTypeTrain];
            [self animtadForOpen];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark HomeItemViewDelegate
- (void) homeItemViewAction:(HomeItemView *)itemView{
    
    if (DEBUGBAR_SWITCH) {
        // 如果开着调试控制台，进行拦截
        if ([[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_DEBUG_MODULES]) {
            NSArray *itemArray = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_DEBUG_MODULES];
            for (NSNumber *tag in itemArray) {
                if ([tag intValue] == itemView.tag) {
                    return;
                }
            }
        }
    }
    
    // countly 非广告模块点击
    if (itemView.item.tag != 1100) {
        CountlyEventHomePageBlock *countlyEventHomePageBlock = [[CountlyEventHomePageBlock alloc] init];
        countlyEventHomePageBlock.blockId = NUMBER([PublicMethods getHomeItemType:itemView.item.tag]);
        countlyEventHomePageBlock.blockName = [PublicMethods getHomeItemName:itemView.item.tag];
        [countlyEventHomePageBlock sendEventCount:1];
        [countlyEventHomePageBlock release];
    }
    
    switch (itemView.item.tag) {
        case 1100:{
            NSLog(@"点击第%d个广告",self.adItem.adView.currentPage);
            if ([[ServiceConfig share] monkeySwitch]){
                // 开着monkey时不发生事件
                return;
            }
            [self adsJump];
            
            UMENG_EVENT(UEvent_Home_Ads)
        }
            break;
        case 1200:{
            NSLog(@"点击酒店");
            [mainPageController goModule:MainTypeHotel];
            [self animtadForOpen];
            UMENG_EVENT(UEvent_Home_Hotel)
        }
            break;
        case 1300:{
            NSLog(@"点击团购");
            [mainPageController goModule:MainTypeGroupon];
            [self animtadForOpen];
            UMENG_EVENT(UEvent_Home_Groupon)
        }
            break;
        case 1410:{
            NSLog(@"点击机票");
            [mainPageController goModule:MainTypeAirplane];
            [self animtadForOpen];
            UMENG_EVENT(UEvent_Home_Flight)
        }
            break;
        case 1420:{
            NSLog(@"火车票");
            [mainPageController goModule:MainTypeTrain];
            [self animtadForOpen];
            UMENG_EVENT(UEvent_Home_Train)
        }
            break;
        case 1431:{
            NSLog(@"个人中心");
            [mainPageController goModule:MainTypePerson];
            [self animtadForOpen];
            UMENG_EVENT(UEvent_Home_UserCenter)
        }
            break;
        case 1432:{
            NSLog(@"客服电话");
            NSLog(@"客服电话");
            HomePhoneViewController *phoneVC = [[HomePhoneViewController alloc] init];
            phoneVC.delegate = self;
            if (IOSVersion_7) {
                phoneVC.transitioningDelegate = [ModalAnimationContainer shared];
                phoneVC.modalPresentationStyle = UIModalPresentationCustom;
            }
            
            [self.adItem.adView stopAutoPage];
            if (IOSVersion_7) {
                [self presentViewController:phoneVC animated:YES completion:nil];
                [phoneVC release];
            }else{
                [self presentModalViewController:phoneVC animated:YES];
                [phoneVC release];
            }

            //[mainPageController goModule:MainTypeService];
           // [self animtadForOpen];
            UMENG_EVENT(UEvent_Home_Phone)
        }
            break;
        case 1433:{
            NSLog(@"添加模块");
            HomeItemsViewController *itemsVC = [[HomeItemsViewController alloc] initWithHomeLayout:self.homeLayout];
            itemsVC.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:itemsVC];
            if (IOSVersion_7) {
                nav.transitioningDelegate = [ModalAnimationContainer shared];
                nav.modalPresentationStyle = UIModalPresentationCustom;
            }
            
            [itemsVC release];
            
            itemsVC.delegate = self;
            
            [self.adItem.adView stopAutoPage];
            if (IOSVersion_7) {
                [self presentViewController:nav animated:YES completion:nil];
                [nav release];
            }else{
                [self presentModalViewController:nav animated:YES];
                [nav release];
            }
            
            // 标记已阅
            [[ElongUserDefaults sharedInstance] setObject:[NSNumber numberWithBool:YES] forKey:USERDEFAULT_HOME_ADDNEWTIPS];
            for (UIImageView *subView in itemView.subviews) {
                if(subView.tag == itemView.tag + 1){
                    [subView removeFromSuperview];
                    break;
                }
            }
            
            UMENG_EVENT(UEvent_Home_Tools)
        }
            break;
        case 1440:{
            if (UMENG) {
                [MobClick event:Event_Home_FlightStatus];
            }
            [mainPageController goModule:MainTypeFlightStatus];
            [self animtadForOpen];
            NSLog(@"航班动态");
            
            // 记录日志
            [self doLog:itemView.item.tag];
            UMENG_EVENT(UEvent_Home_FlightStatus)
        }
            break;
        case 1450:{
            if (UMENG) {
                [MobClick event:Event_Home_PackingList];
            }
            NSLog(@"旅行清单");
            [mainPageController goModule:MainTypePackingList];
            [self animtadForOpen];
            
            // 记录日志
            [self doLog:itemView.item.tag];
            UMENG_EVENT(UEvent_Home_PackingList)
        }
            break;
        case 1460:{
            if (UMENG) {
                [MobClick event:Event_Home_ExchangeRate];
            }
            NSLog(@"汇率模块");
            [mainPageController goModule:MainTypeExchangeRate];
            [self animtadForOpen];
            
            // 记录日志
            [self doLog:itemView.item.tag];
            UMENG_EVENT(UEvent_Home_ExchangeRate)
        }
            break;
        case 1470:{

            NSLog(@"打车模块");
            [mainPageController goModule:MainTypeTaxi];
            [self animtadForOpen];
            
            // 记录日志
            [self doLog:itemView.item.tag];
            UMENG_EVENT(UEvent_Home_Car)
        }
            break;
        case 1480:{
            NSLog(@"旅游指南");
            if ([[ServiceConfig share] monkeySwitch]){
                // 开着monkey时不发生事件
                return;
            }
            [mainPageController goModule:MainTypeTravelingTips];
            [self animtadForOpen];
            
            // 记录日志
            [self doLog:itemView.item.tag];
            UMENG_EVENT(UEvent_Home_TravelingTips)
        }
            break;
        case 1490:{
            NSLog(@"每日特惠");
            [mainPageController goModule:MainTypeEveryDayShopping];
            [self animtadForOpen];
        }
            break;
        case 1500:{
            NSLog(@"门票");
            [mainPageController goModule:MainTypeTicket];
            [self animtadForOpen];
        }
            break;
        default:
            break;
    }
}

- (void) doLog:(NSInteger)tag{
    int index = [PublicMethods getHomeItemType:tag];
    
    if (logUtil) {
        [logUtil cancel];
        [logUtil release];
        logUtil = nil;
    }
    HomeItemRequest *request = [[HomeItemRequest alloc] init];
    request.logRecords = nil;
    request.logRecordStatus = [NSString stringWithFormat:@"%d",index];
    
    NSString *url = [PublicMethods composeNetSearchUrl:@"mtools"
                                            forService:@"doLog"
                                              andParam:[request requestForLog]];
    logUtil = [[HttpUtil alloc] init];
    [logUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
    
    [request release];
}


- (void) homeItemViewWillBeginDelete:(HomeItemView *)itemView{
    NSInteger index = [itemView.item.superItem.subitems indexOfObject:itemView.item];
    NSMutableArray *items = itemView.item.superItem.subitems;
    for (int i = index + 1; i < items.count; i++) {
        HomeItem *item = [items objectAtIndex:i];
        item.y -= (itemView.item.height + 5);
    }
    itemView.item.superItem.contentHeight -= (itemView.item.height + 5);

    CGSize contentSize = CGSizeMake(itemView.item.superItem.contentWidth, itemView.item.superItem.contentHeight);
    
    [items removeObject:itemView.item];
    [itemView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        for (HomeItemView *view in self.scrollView.subviews) {
            [view refresh];
            [self.scrollView setContentSize:contentSize];
        }
    }];
    
}

- (void) homeItemViewWillBeginEdit:(HomeItemView *)itemView{
    for (int j = 0;j < self.homeLayout.items.count;j++) {
        HomeItem *item = [self.homeLayout.items objectAtIndex:j];
        
        if (item.subitems) {
            for (int i = 0; i < item.subitems.count; i++) {
                HomeItem *subitem = [item.subitems objectAtIndex:i];
                HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:subitem.tag];
                if (i % 2 == 0) {
                    [itemView beginEditFromLeft:YES];
                }else{
                    [itemView beginEditFromLeft:NO];
                }
            }
        }else{
            HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:item.tag];
            if (j % 2 == 0) {
                [itemView beginEditFromLeft:YES];
            }else{
                [itemView beginEditFromLeft:NO];
            }
        }
    }
}

- (void) homeItemViewWillEndEdit:(HomeItemView *)itemView{
    [self endEdit];
}

- (void) endEdit{
    for (HomeItem *item in self.homeLayout.items) {
        if (item.subitems) {
            for (HomeItem *subitem in item.subitems) {
                HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:subitem.tag];
                [itemView endEdit];
            }
        }else{
            HomeItemView *itemView = (HomeItemView *)[self.layoutView viewWithTag:item.tag];
            [itemView endEdit];
        }
    }
}

- (void) stopAdLoop{
    NSLog(@"stop ad loop");
    [self.adItem.adView stopAutoPage];
}
- (void) startAdLoop{
    NSLog(@"start ad loop");
    [self.adItem.adView startAutoPage];
}

- (void) homeItemViewBeginMove:(HomeItemView *)itemView{
    self.actionItemIndex = [itemView.item.superItem.subitems indexOfObject:itemView.item];
    self.itemCount = itemView.item.superItem.subitems.count;
    self.itemFrame = itemView.frame;
    self.offsetY = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        itemView.transform = CGAffineTransformMakeScale(1.03, 1.03);
        //self.alpha = 0.9f;
        [itemView.superview bringSubviewToFront:itemView];
    }];
}

- (void) homeItemViewMoved:(HomeItemView *)itemView offset:(CGPoint)offset position:(CGPoint)position{
    itemView.frame = CGRectMake(itemView.frame.origin.x, self.itemFrame.origin.y + offset.y, self.itemFrame.size.width, self.itemFrame.size.height);
    
    // scroll view 跟随滚动
    [self.scrollView scrollRectToVisible:CGRectMake(0, itemView.frame.origin.y, itemView.frame.size.width, itemView.frame.size.height) animated:NO];
    
    NSMutableArray *dataSource = itemView.item.superItem.subitems;
    if (offset.y - self.offsetY < 0) {
        // 上移
        // 超出边界直接跳出
        if (self.actionItemIndex == 0) {
            return;
        }
        HomeItem *formerItem = [dataSource objectAtIndex:self.actionItemIndex - 1];
        HomeItem *currentItem = itemView.item;
        if (itemView.frame.origin.y < formerItem.y + formerItem.height /2) {
            float newY = currentItem.y + currentItem.height - formerItem.height;
            float oldY = formerItem.y;
            formerItem.y = newY;
            currentItem.y = oldY;
            
            
            // 交换数据源
            [dataSource exchangeObjectAtIndex:self.actionItemIndex withObjectAtIndex:self.actionItemIndex - 1];
            self.actionItemIndex = self.actionItemIndex - 1;
            
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.2];
            HomeItemView *formerView = (HomeItemView *)[self.layoutView viewWithTag:formerItem.tag];
            [formerView refresh];
            [UIView commitAnimations];
        }
        
    }else if(offset.y - self.offsetY > 0){
        // 下移
        if (self.actionItemIndex == self.itemCount - 1) {
            // 超出边界直接跳出
            return;
        }
        HomeItem *nextItem = [dataSource objectAtIndex:self.actionItemIndex + 1];
        HomeItem *currentItem = itemView.item;
        if (itemView.frame.origin.y + itemView.frame.size.height > nextItem.y + nextItem.height /2) {
            float newY = currentItem.y;
            float oldY = nextItem.y + nextItem.height - currentItem.height;
            nextItem.y = newY;
            currentItem.y = oldY;
            
            [dataSource exchangeObjectAtIndex:self.actionItemIndex withObjectAtIndex:self.actionItemIndex + 1];
            self.actionItemIndex = self.actionItemIndex + 1;
            
            [UIView beginAnimations:@"move" context:nil];
            [UIView setAnimationDuration:0.2];
            HomeItemView *nextView = (HomeItemView *)[self.layoutView viewWithTag:nextItem.tag];
            [nextView refresh];
            [UIView commitAnimations];
            
            
        }
    }
    self.offsetY = offset.y;
}


- (void) homeItemViewEndMove:(HomeItemView *)itemView{
    if (!itemView.item.fixed) {
        [UIView animateWithDuration:0.2 animations:^{
            itemView.transform = CGAffineTransformIdentity;
            //itemView.alpha = 1.0f;
            itemView.frame = CGRectMake(itemView.item.x, itemView.item.y, itemView.item.width, itemView.item.height);
        }];
    }
}

#pragma mark -
#pragma mark HomePhoneViewControllerDelegate
- (void) homePhoneVCDismiss:(HomePhoneViewController *)homePhoneVC{
    [self.adItem.adView startAutoPage];
}

#pragma mark -
#pragma mark HomeItemsViewControllerDelegate
- (void) homeItemsVC:(HomeItemsViewController *)homeItemsVC didEndEditWithItems:(NSMutableArray *)items{
    int formerCount = self.scrollItemView.item.subitems.count;
    
    float y = 0;

    self.scrollItemView.item.subitems = items;
    for (HomeItem *newItem in self.scrollItemView.item.subitems) {
        newItem.y = y;
        y += newItem.height;
        y += 5;
    }
    y-=5;
    self.scrollItemView.item.contentHeight = y;
    
    // 加载布局
    [self.scrollItemView reloadItems];
    

    // 如果之前只有三个现在大于三个进行滑动提示
    if (items.count > 3 && formerCount <= 3) {
        // 活动功能模块晃动
        [self performSelector:@selector(shakeNewmodels) withObject:nil afterDelay:0.3];
    }
    
    [self.adItem.adView startAutoPage];
}

- (void) homeItemsVCDismiss:(HomeItemsViewController *)homeItemsVC{
    [self.adItem.adView startAutoPage];
}

- (void) shakeNewmodels{
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, 80)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
        }];
    }];
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if (loginUtil == util) {
        [[SettingManager instanse] setAutoLogin:NO];
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if (self.adsClickUtil == util) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        NSLog(@"%@",infoDict);
        return;
    }
    if (self.adsUtil == util) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        self.adArray = [infoDict objectForKey:@"arounds"];
        [self loadAdData];
        return;
    }
    if (m_netstate == 1002){
        NSString *receiveString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *infoDict = [receiveString JSONValue];
        if ([[infoDict safeObjectForKey:@"UserLever"] intValue] >= 2) {
            int userno = [[infoDict safeObjectForKey:@"UserLever"] intValue];
            [[AccountManager instanse] setDragon_VIP:[NSString stringWithFormat:@"%d",userno]];
        }
        else
        {
            int userno = [[infoDict safeObjectForKey:@"UserLever"] intValue];
            [[AccountManager instanse] setDragon_VIP:[NSString stringWithFormat:@"%d",userno]];
        }
        return;
    }
    
    if (pushUtil == util) {
		NSString *receiveString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
		NSDictionary *infoDict = [receiveString JSONValue];
		if([[infoDict safeObjectForKey:@"IsError"] intValue]!=1){
            NSString *nosver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:[[AccountManager instanse] cardNo] forKey:@"PushCardNo"];
            [userDefaults setValue:nosver forKey:@"OsVersion"];
            [userDefaults synchronize];
		}
        return;
	}
    if (loginUtil == util) {
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
		NSDictionary *root = [string JSONValue];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *deviceToken = [userDefaults objectForKey:@"DeviceToken"];
        
		if (![Utils checkJsonIsErrorNoAlert:root]) {
			// 自动登陆后加入用户信息
			[[AccountManager instanse] buildPostData:root];
			
            // token请求
            [[TokenReq shared] requestTokenWithLoading:NO];
            
            // 龙萃会员请求
            [PublicMethods getLongVIPInfo];
            
			if (deviceToken) {
				NSString *cardNo = [root safeObjectForKey:@"CardNo"];
				NSString *phoneNo = [root safeObjectForKey:@"PhoneNo"];
				
				/*如果发现上次已经注册过，并且绑定卡号相同，则直接跳出*/
				NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
				NSString *pushCardNo = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"PushCardNo"]];
				
                NSString *oosver = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"OsVersion"]];
                NSString *nosver = [NSString stringWithFormat:@"iphone_%@",[[UIDevice currentDevice] systemVersion]];
                
                if (pushCardNo && [pushCardNo isEqualToString:cardNo] && oosver && [oosver isEqualToString:nosver]) {
				}else {
					if (pushUtil) {
						[pushUtil cancel];
                        SFRelease(pushUtil);
					}
                    pushUtil = [[HttpUtil alloc] init];
                    [pushUtil connectWithURLString:[NSString stringWithFormat:@"%@?DeviceToken=%@&ClientType=0&CardNo=%@&Mobile=%@&OsVersion=%@",PUSHREGURL,deviceToken,cardNo,phoneNo,nosver] Content:nil StartLoading:NO EndLoading:NO Delegate:nil];
				}
                
                
                // 新的推送绑定接口
                if (bindUserPushUtil) {
                    [bindUserPushUtil cancel];
                    SFRelease(bindUserPushUtil);
                }
                bindUserPushUtil = [[HttpUtil alloc] init];
                NSDictionary *pushDict = [NSDictionary dictionaryWithObjectsAndKeys:cardNo,@"UserId",deviceToken,@"PushId",APPTYPE,@"AppType", nil];
                [bindUserPushUtil requestWithURLString:[PublicMethods  composeNetSearchUrl:@"user" forService:@"bindUserPush"]
                                               Content:[pushDict JSONString]
                                          StartLoading:NO
                                            EndLoading:NO
                                              Delegate:self];
                
			}
		}
		else {
            // 新的推送解绑接口
            if (unbindUserPushUtil) {
                [unbindUserPushUtil cancel];
                SFRelease(unbindUserPushUtil);
            }
            unbindUserPushUtil = [[HttpUtil alloc] init];
            NSDictionary *pushDict = [NSDictionary dictionaryWithObjectsAndKeys:[AccountManager instanse].cardNo,@"UserId",deviceToken,@"PushId",APPTYPE,@"AppType", nil];
            [unbindUserPushUtil requestWithURLString:[PublicMethods  composeNetSearchUrl:@"user" forService:@"unBindUserPush"]
                                             Content:[pushDict JSONString]
                                        StartLoading:NO
                                          EndLoading:NO
                                            Delegate:self];
            
            // 自动登录的密码错误时，取消自动登录状态
			[[SettingManager instanse] setAutoLogin:NO];
		}
        return;
    }
    
    if (logUtil == util) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        NSLog(@"%@",infoDict);
        return;
    }
    
    if (util == bindUserPushUtil) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        NSLog(@"pushtoken 绑定：%@",infoDict);
        return;
    }
    
    if (util == unbindUserPushUtil) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        NSLog(@"pushtoken 解绑：%@",infoDict);
        return;
    }
}

@end
