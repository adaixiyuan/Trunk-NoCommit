//
//  ElongClientAppDelegate.m
//  ElongClient
//
//  Created by bin xing on 10-12-28.
//  Copyright 2010 DP. All rights reserved.
//

#import "ElongClientAppDelegate.h"
#import "HomeViewController.h"
#import "TimeUtils.h"
#import "Utils.h"
#import "Update.h"
#import "HotelSearch.h"
#import "TapjoyConnect.h"
#import "Notification.h"
#import <AudioToolbox/AudioToolbox.h>
#import <sys/utsname.h>
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "FlightOrderSuccess.h"
#import "FlightOrderHistoryDetail.h"
#import "GrouponSuccessController.h"
#import "GrouponOrderHistoryController.h"
#import "WXApi.h"
#import "GrouponHomeViewController.h"
#import "GoogleConversionPing.h"
#import "WelcomeViewController.h"
#import "DebugCenter.h"
#import "jUpdate.h"
#import "MessageManager.h"
#import "IMAdTracker.h"
#import "IMCommonUtil.h"
#import "BaiduMobStat.h"
#import "SwizzMethod.h"
#import "MainPageController.h"
#import "MessageContentViewController.h"
#import "Countly.h"
#import "CountlyEventInfo.h"

//#import <GoogleMaps/GoogleMaps.h>

#define net_type_update     1
#define net_type_checkdata  2

#define INMOBI_ADTRACKER_APP_ID @"656e155de5ab45a0bb9cf9e78f804eed"
#define ACTIVITI_END_TIME @"ACTIVITI_END_TIME"      // 用户关闭或把APP切到后台的时间

@implementation ElongClientAppDelegate

@synthesize navigationController;
@synthesize window;
@synthesize startup;
@synthesize coverView;
@synthesize dormantTime;
@synthesize navDrawEnabled;
@synthesize welcomeview;
@synthesize isNonmemberFlow;
@synthesize netCheckNeeded;
@synthesize timezoneCheckNeeded;

#pragma mark -
#pragma mark Application lifecycle

// 加入第三方控件方法
- (void)configThirdPartySDK {
    //向微信注册
    [WXApi registerApp:WEIXIN_ID withDescription:@"艺龙旅行"];
    
	// Tapjoy相关
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectSuccess:) name:TJC_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tjcConnectFail:) name:TJC_CONNECT_FAILED object:nil];
    [TapjoyConnect enableLogging:NO];
	[TapjoyConnect requestTapjoyConnect:@"03898ac3-8213-47c8-A477-95b863d24561" secretKey:@"ef6QOjLFrZ0Wy7SOCTlX"];
    
    // Admob相关
    [GoogleConversionPing pingWithConversionId:@"983846556" label:@"zhkvCNzl9wQQnJ2R1QM" value:@"0" isRepeatable:NO];
    
    // Inmobi相关
    [IMAdTracker initWithAppID:INMOBI_ADTRACKER_APP_ID];
    [IMAdTracker reportAppDownloadGoal];
    
    [IMCommonUtil setLogLevel:IMLogLevelTypeNone];
    NSLog(@"inmobi version:%@", [NSString stringWithFormat:@"%@", [IMCommonUtil getReleaseVersion]]);
    
    // TencentMap
    qAppKeycheck = [[QAppKeyCheck alloc] init];
    [qAppKeycheck start:TENCENTMAP_KEY withDelegate:self];
}

// 检测激活或更新
-(BOOL)checkUpdateActive:(BOOL)active{
	NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
	NSString* firstrun = [dater objectForKey:@"appactive"];
	NSString *deviceToken = [dater objectForKey:@"DeviceToken"];
	if (deviceToken == nil) {
        deviceToken = @"";
    }
    
    if (active) {
        if(firstrun == nil)
        {
            // 第一次启动，统计激活
            NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [PostHeader header], Resq_Header,
                                        [PublicMethods macaddress], @"Mac",deviceToken,@"PushToken", nil];
            
            NSString *reqContent = [NSString stringWithFormat:@"action=AppActivator&compress=true&req=%@", [requestDic JSONRepresentationWithURLEncoding]];
                        
            if (activatorUtil) {
                [activatorUtil cancel];
                SFRelease(activatorUtil);
            }
            activatorUtil = [[HttpUtil alloc] init];
            [activatorUtil connectWithURLString:OTHER_SEARCH Content:reqContent StartLoading:NO EndLoading:NO Delegate:self];
            netType = net_type_update;
            
            // countly active
            CountlyEventInfo *countlyEventInfo = [[CountlyEventInfo alloc] init];
            countlyEventInfo.action = COUNTLY_ACTION_ACTIVATE;
            [countlyEventInfo sendEventCount:1];
            [countlyEventInfo release];
            return YES;
        }
        else
        {
            m_update = [[Update alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            [m_update initData];
            return NO;
        }
    }else{
        m_update = [[Update alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [m_update initData];
        return NO;
    }
}

- (void) sendPushToken{
    NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [dater objectForKey:@"DeviceToken"];
	if (deviceToken == nil) {
        deviceToken = @"";
    }
    
    NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                [PostHeader header], Resq_Header,
                                [PublicMethods macaddress], @"Mac",deviceToken,@"PushToken", nil];
    
    NSString *reqContent = [NSString stringWithFormat:@"action=SavePushToken&compress=true&req=%@", [requestDic JSONRepresentationWithURLEncoding]];
    
    if (pushTokenUtil) {
        [pushTokenUtil cancel];
        SFRelease(pushTokenUtil);
    }
    pushTokenUtil = [[HttpUtil alloc] init];
    [pushTokenUtil connectWithURLString:OTHER_SEARCH Content:reqContent StartLoading:NO EndLoading:NO Delegate:nil];
}

- (BOOL)isSingleTask{
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
		return YES;
	}
	else {
		return NO;
	}
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
    NSLog(@"url:%@",[url absoluteString]);
    
    if ([url host] != NULL && [[url host] isEqualToString:@"safepay"]){
		AlixPay *alixpay = [AlixPay shared];
		AlixPayResult *result = [alixpay handleOpenURL:url];
		if (result) {
			//是否支付成功
			if (9000 == result.statusCode) {
                // 发送支付成功的通知
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ALIPAY_PAYSUCCESS object:nil userInfo:nil];
			}
			//如果支付失败,可以通过result.statusCode查询错误码
			else {
				UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																	 message:result.statusMessage
																	delegate:nil
														   cancelButtonTitle:@"确定"
														   otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
            
		}
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef BaiduModStat
    [BaiduMobStat defaultStat].logStrategy = BaiduMobStatLogStrategyCustom;
    [BaiduMobStat defaultStat].logSendInterval = 1;
    [BaiduMobStat defaultStat].logSendWifiOnly = NO;
    [BaiduMobStat defaultStat].sessionResumeInterval = 60;
    [BaiduMobStat defaultStat].enableExceptionLog = YES;
    [[BaiduMobStat defaultStat] startWithAppId:@"efd4478e91"];
#endif
    
    NSLog(@"----%@", NSHomeDirectory());
    
    [[Profile shared] start:@"程序启动"];
    
    // 系统启动时间记录
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kSystemLaunchTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //[[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:str]];
    
    // Add by chenggong 10/17/2013.
    SwizzMethod *swizzMethod = [[SwizzMethod alloc] init];
    [swizzMethod release];
    // End add.
    
    // 清空上次搜索的城市纪录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHotelLastSelectedCityKey];
    
    // 列车城市列表
    [self configTrainCityData];
    
	isNonmemberFlow = NO;
    isStart = YES;
    
    //激活并检测更新
    [self checkUpdateActive:YES];
	
	/*检测DeviceToken是否存在，如果不存在就重新注册*/
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *deviceToken = [userDefaults objectForKey:@"DeviceToken"];
	if (deviceToken ==  nil) {
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
	}else{
        // 发送PushToken
        [self sendPushToken];
    }
    
	//检测错误报告
	if (IOSVersion_4) {
        ElongClientAppDelegate *app = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		[ABNotifier startNotifierWithAPIKey:@"com.elong.iphone" environmentName:ABNotifierAutomaticEnvironment useSSL:NO delegate:app installExceptionHandler:YES installSignalHandler:YES displayUserPrompt:NO];
		[ABNotifier setEnvironmentValue:@"elong_iphone" forKey:@"软件分类"];
	}
	
	if (IOSVersion_6) {
		// ios6目前只能设成黑色没有问题
		[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
	}
    
    [self configThirdPartySDK];
    
    if (DEBUGBAR_SWITCH) {
        // debug模式启动资源扫瞄
        [[DebugCenter shared] starObserveDevice];
    }
    
    /************UMeng数据统计分析*********************/
    if (UMENG) {
        [MobClick setCrashReportEnabled:NO];
        [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:CHANNELID];
        NSLog(@"!!!!!!!!UMeng数据统计开始监听!!!!!!!!!");
    }
    
    /************Countly数据统计分析*******************/
    if (COUNTLY) {
        [[Countly sharedInstance] start:COUNTLY_KEY withHost:COUNTLY_HOST];
        NSLog(@"!!!!!!!!!Countly数据统计开始监听!!!!!!!!!!");
    }
    
	/*
	 *单任务handleURL处理
	 */
	if ([self isSingleTask]) {
		NSURL *url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
		if (nil != url) {
			[self parseURL:url application:application];
		}
	}
    
    
    if (launchOptions) {
        if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]) {
            [self application:application didReceiveRemoteNotification:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
        }
    }
    application.applicationIconBadgeNumber = 0;
    
    if(IOSVersion_5){
        // google map
        //[GMSServices provideAPIKey:@"AIzaSyDuaLngGYyfmGb50_iOIqwYD6Afv2HOnho"];
    }
    
    [self performSelectorOnMainThread:@selector(initCacheData) withObject:nil waitUntilDone:YES];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor blackColor];
    
    MainPageController *mainPageController = [[MainPageController alloc] init];
    UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:mainPageController];
    [mainPageController  release];
    
    self.window.rootViewController = navCtr;
    self.navigationController = navCtr;
    [navCtr release];
    
    [window makeKeyAndVisible];
    
    self.startup = [[[HomeViewController alloc] init] autorelease];
	[startup.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [window addSubview:self.startup.view];
    
    [self.startup afterInit];
	return YES;
}

- (void)initCacheData
{
    [ElCalendarView getTableViewCellStaticList];
}

-(void)deleteFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    
    NSLog(@"%@",paths);
    //文件名
    NSString *uniquePath=[[paths safeObjectAtIndex:0] stringByAppendingPathComponent:@"com.elong.app"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}
//
- (void)closeWelcomeView
{
	[UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
	[self.window exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[UIView commitAnimations];
    [self.welcomeview.view removeFromSuperview];
}

//
- (void)configTrainCityData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    // 数据文件
    NSString *fTrainCityPath = [documentDirectory stringByAppendingPathComponent:@"railwaycity.plist"];
    
    if (![fileManager fileExistsAtPath:fTrainCityPath]) //如果不存在
    {
        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/railwaycity.plist"]; //获取程序包中相应文件的路径
        NSError *error;
        if ([fileManager copyItemAtPath:dataPath toPath:fTrainCityPath error:&error])
        {
            // 将版本号保存本地，设置为初始版本号
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:@"1.0.0" forKey:@"trainCityVersion"];
            [defaults synchronize];
            
//            NSLog(@"copy success");
        }
        else
        {
//            NSLog(@"copy error");
        }
    }
}


// 返回程序是否打开接口的参数
- (NSString *)getOpenStatistics:(BOOL)isOpen
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [PostHeader header], HEADER,
                         [NSNumber numberWithBool:isOpen], @"OpenStatus",nil];
    
    return [NSString stringWithFormat:@"action=SaveOpenStatistics&version=1.2&compress=false&req=%@", [dic JSONRepresentationWithURLEncoding]];
}

#pragma mark -
#pragma mark RemoteNotifications

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
	NSString *deviceTokenstring = [[[[deviceToken description]
									 stringByReplacingOccurrencesOfString:@"<"withString:@""]
									stringByReplacingOccurrencesOfString:@">" withString:@""]
								   stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue:deviceTokenstring forKey:@"DeviceToken"];
	[userDefaults synchronize];
    NSLog(@"%@",deviceTokenstring);
    
    // 发送PushToken
    [self sendPushToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error in registration. Error: %@", error);
    
    NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
    [dater removeObjectForKey:@"appactive"];
    [dater synchronize];
    
    
    [self checkUpdateActive:YES];  //激活并检测更新
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *flag = (NSString*)[userInfo objectForKey:@"flag"];
    NSString *msg = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *url = [[userInfo objectForKey:@"aps"] objectForKey:@"url"];
    
    if ([flag isEqualToString:@"Normal"]) {
        EMessage *m = [[[EMessage alloc] init] autorelease];
        m.body = msg;
        m.time = [NSDate date];
        m.url = url;
        [[MessageManager sharedInstance] addMessage:m];
        [[MessageManager sharedInstance] save];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:m.body//@"收到新的消息内容,是否打开？"
                                                       delegate:self
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:@"打开",nil];
        alert.tag = 102;
        [alert show];
        [alert release];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RECEIVEREMOTENOTIFICATION object:nil];     // 收到推送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_MESSAGECOUNT object:nil];                 // 更新消息
    }
    
    //播放声音
	//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //设置图标右上角的数字
	application.applicationIconBadgeNumber = 0;
}

- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertview.tag == 102) {
        if (buttonIndex == 0) {
            return;
        }
        else if (buttonIndex == 1) {
            ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            if ([delegate.navigationController.viewControllers count] > 1) {
                [[self getModalViewController] dismissModalViewControllerAnimated:YES];
                if (IOSVersion_5) {
                    [[self getModalViewController] dismissViewControllerAnimated:YES completion:nil];
                }
                [PublicMethods closeSesameInView:nil];
                [Utils clearFlightData];
                [Utils clearHotelData];
                
                [self performSelector:@selector(getPushMsgGo2NotiView) withObject:nil afterDelay:0.8];
            }
            else{
                [[self getModalViewController] dismissModalViewControllerAnimated:NO];
                if (IOSVersion_5) {
                    [[self getModalViewController] dismissViewControllerAnimated:YES completion:nil];
                }
                [self performSelector:@selector(getPushMsgGo2NotiView) withObject:nil afterDelay:0.0];
            }
        }
    }
}

- (UIViewController *)getModalViewController{
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.navigationController.modalViewController) {
        return delegate.navigationController.modalViewController;
    }else if(delegate.startup.modalViewController){
        return delegate.startup.modalViewController;
    }else if(delegate.navigationController.topViewController.modalViewController){
        return delegate.navigationController.topViewController.modalViewController;
    }
    return nil;
}

- (void)getPushMsgGo2NotiView{
    //[adNavi adNaviJumpUrl:jumpLink item:item];
    int count = [[MessageManager sharedInstance] messageCount];
    EMessage *emsg = [[MessageManager sharedInstance] getMessageByIndex:count-1];
    emsg.hasRead = YES;
    [self.startup goMessageBoxPageUrl:emsg.url];
}

- (NSString *)hashedISU {
    return @"";
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.dormantTime = [NSDate date];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_TIME_PAUSE object:nil];
    NSLog(@"aaa");
    
    // 保存首页设置
    [self.startup.homeLayout save];
    [self.startup endEdit];
    [self.startup stopAdLoop];
    
    // 告诉服务器程序已关闭
    HttpUtil *req = [[[HttpUtil alloc] init] autorelease];
    [req connectWithURLString:OTHER_SEARCH Content:[self getOpenStatistics:NO] StartLoading:NO EndLoading:NO Delegate:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:ACTIVITI_END_TIME];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    self.netCheckNeeded = YES;
    self.timezoneCheckNeeded = YES;
	NSDate *activeTime = [NSDate date];
	
	// 通知有计时器的页面更新时间
	NSString *addTime  = [NSString stringWithFormat:@"%.f", [dormantTime timeIntervalSinceDate:activeTime]];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTI_TIME_ADDITION object:addTime];
    
    // 检测广告更新
    [self.startup reloadAdSystem];
    [self.startup startAdLoop];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // 广告轮播中断
    [self.startup endEdit];
    [self.startup stopAdLoop];
}

// 电话接入时触发
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame{
    NSLog(@"statusbar change");
    self.startup.layoutView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20);
    self.navigationController.view.transform = CGAffineTransformIdentity;
    self.navigationController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 广告轮播恢复
    [self.startup startAdLoop];
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:ACTIVITI_END_TIME];
    if ([[NSDate date] timeIntervalSinceDate:date] >= 1800)
    {
        // 关闭时间超过半小时的情况，告诉服务器程序已打开
        HttpUtil *req = [[[HttpUtil alloc] init] autorelease];
        [req connectWithURLString:OTHER_SEARCH Content:[self getOpenStatistics:YES] StartLoading:NO EndLoading:NO Delegate:nil];
    }
    
	// 重新打开程序时，纠正定位（写在此处可以使程序在初始化、解锁和后台切回时都执行）
	[[PositioningManager shared] setGpsing:YES];
	
	FastPositioning *position = [FastPositioning shared];
	position.autoCancel = YES;
	[position fastPositioning];
    
    if (!isStart && [ProcessSwitcher shared].dataOutTime) {
        // 开关数据过期的话需要更新
        jUpdate *jupdate = [[jUpdate alloc] init];
        
        if(net_type_checkdataUtil) {
            [net_type_checkdataUtil cancel];
            SFRelease(net_type_checkdataUtil);
        }
        
        net_type_checkdataUtil = [[HttpUtil alloc] init];
        [net_type_checkdataUtil connectWithURLString:OTHER_SEARCH Content:[jupdate requesString:YES]  StartLoading:NO EndLoading:NO Delegate:self];
        [jupdate release];
        
    }
    isStart = NO;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	if([[url scheme] isEqualToString:WEIXIN_ID]){
		//微信
		return [WXApi handleOpenURL:url delegate:self];
	}else if([[url scheme] isEqualToString:@"elongIPhone"]){
		//用于支付宝
		[self parseURL:url application:application];
	}
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if([[url scheme] isEqualToString:WEIXIN_ID]){
		//微信
		return [WXApi handleOpenURL:url delegate:self];
	}else if([[url scheme] isEqualToString:@"elongIPhone"]){
		//用于支付宝App
		[self parseURL:url application:application];
	}
    else if([[url scheme] isEqualToString:@"elongiphone"])
    {
		//用于支付宝Wap
        NSString *urlStr = [url absoluteString];
        unichar payStateChar = [urlStr characterAtIndex:urlStr.length - 1];
        
		if (payStateChar == '0')
        {
            // 支付取消
            
        }
        else if (payStateChar == '1')
        {
            // 支付成功
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WAPALIPAY_SUCCESS object:nil];
        }
	}
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // 告诉服务器程序已关闭
    HttpUtil *req = [[[HttpUtil alloc] init] autorelease];
    [req connectWithURLString:OTHER_SEARCH Content:[self getOpenStatistics:NO] StartLoading:NO EndLoading:NO Delegate:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:ACTIVITI_END_TIME];
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate deleteFile];
    
    // 保存首页设置
    [self.startup.homeLayout save];
}

#pragma mark TapjoyConnect Observer methods

- (void)tjcConnectSuccess:(NSNotification*)notifyObj
{
}

- (void)tjcConnectFail:(NSNotification*)notifyObj
{
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if(net_type_checkdataUtil) {
        [net_type_checkdataUtil cancel];
        SFRelease(net_type_checkdataUtil);
    }
    
    if (activatorUtil) {
        [activatorUtil cancel];
        SFRelease(activatorUtil);
    }
    
    if (pushTokenUtil) {
        [pushTokenUtil cancel];
        SFRelease(pushTokenUtil);
    }
    
	[navigationController release];
	[window release];
    [m_update release];
    
	self.coverView	 = nil;
	self.startup	 = nil;
	self.dormantTime = nil;
	
    [super dealloc];
}

#pragma mark - weibxin delegate

-(void) onReq:(BaseReq *)req{
	//收到微信的请求
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        //处理微信请求app内容
        NSLog(@"微信请求");
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        //微信通知第三方显示或处理某些内容
        NSLog(@"第三方显示");
    }
}

-(NSString *)receiveResult:(int)codeId{
    if(codeId == 0){
        return @"信息发送成功！";
    }else if(codeId == -2){
        return @"用户取消信息发送！";
    }else{
        return @"信息发送失败！";
    }
}

-(void) onResp:(BaseResp *)resp{
    NSLog(@"收到信息响应");
	//收到微信的回应
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        NSLog(@"from Type Name:%@",[ShareTools shareTypeNameForWX]);
        NSString *strTitle = [NSString stringWithFormat:@"提醒"];
        NSString *strMsg = [self receiveResult:resp.errCode];
        //提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        //来自Html5的微信分享
        if([@"H5APPShareForWX" isEqualToString:[ShareTools shareTypeNameForWX]]){
            NSDictionary *dic = [Notification h5WXInfoDict];
            CFShow(dic);
            NSString *callBackUrl = [dic objectForKey:@"callbackurl"];
            if(callBackUrl){
                NSMutableString *loadUrl = [NSMutableString stringWithFormat:@"%@?",callBackUrl];
                NSString *activeId = [dic objectForKey:@"activeid"];
                [loadUrl appendFormat:@"activeid=%@",activeId];
                NSString *mobileNo = [dic objectForKey:@"mobileno"];
                [loadUrl appendFormat:@"&mobileno=%@",mobileNo];
                if(resp.errCode==0){
                    //分享成功
                    [loadUrl appendFormat:@"&isSuccess=%@",@"true"];
                }else{
                    //分享失败
                    [loadUrl appendFormat:@"&isSuccess=%@",@"false"];
                }
                NSString *ext = [dic objectForKey:@"ext"];
                if(STRINGHASVALUE(ext)){
                    [loadUrl appendFormat:@"&ext=%@",ext];
                }
                [[Notification getCurrentNotiObj] reloadWebView:loadUrl];
            }
        }
    }else if ([resp isKindOfClass:[PayResp class]]) {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WEIXIN_PAYSUCCESS object:nil];
            }
                break;
            case WXErrCodeUserCancel:{
                [PublicMethods showAlertTitle:nil Message:@"您已放弃支付"];
            }
                break;
            case WXErrCodeSentFail:{
                [PublicMethods showAlertTitle:nil Message:@"支付信息发送失败"];
            }
                break;
            case WXErrCodeAuthDeny:{
                [PublicMethods showAlertTitle:nil Message:@"支付认证授权失败"];
            }
                break;
            default: {
                [PublicMethods showAlertTitle:nil Message:@"支付失败，请选择其他支付方式或稍后再试"];
            }
                break;
        }
    }else if([resp isKindOfClass:[SendAuthResp class]]){
        SendAuthResp *response = (SendAuthResp *)resp;
        switch (response.errCode) {
            case WXSuccess:{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_WEIXIN_OAUTHSUCCESS object:nil userInfo:[NSDictionary dictionaryWithObject:response.code forKey:@"code"]];
            }
                break;
            
            case WXErrCodeUserCancel:{
                [PublicMethods showAlertTitle:nil Message:@"您已放弃授权"];
            }
                break;
            case WXErrCodeSentFail:{
                [PublicMethods showAlertTitle:nil Message:@"授权信息发送失败"];
            }
                break;
            case WXErrCodeAuthDeny:{
                [PublicMethods showAlertTitle:nil Message:@"认证授权失败"];
            }
                break;
            default: {
                [PublicMethods showAlertTitle:nil Message:@"授权失败"];
            }
                break;
        }
    }
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    
    if (net_type_update == netType) {
        
        if (!m_update)
        {
            m_update = [[Update alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
            [m_update initData];
        }
        
        NSUserDefaults* dater = [NSUserDefaults standardUserDefaults];
        [dater setValue:@"1" forKey:@"appactive"];
        [dater synchronize];
    }
	else if(net_type_checkdataUtil == util) {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:root]) {
            return ;
        }
        
        NSArray *switchArray = [root objectForKey:@"SwitchInfos"];
        for (NSDictionary *dic in switchArray) {
            if ([[dic safeObjectForKey:@"Key"] isEqualToString:@"notMemberBooking"]) {
                NSLog(@"%d",[[dic safeObjectForKey:@"IsOpen"] intValue]);
                [ProcessSwitcher shared].allowNonmember = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
            else if([[dic safeObjectForKey:@"Key"] isEqualToString:@"flightAlipay"]){
                NSLog(@"%d",[[dic safeObjectForKey:@"IsOpen"] intValue]);
                [ProcessSwitcher shared].allowAlipayForFlight = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
            else if([[dic safeObjectForKey:@"Key"] isEqualToString:@"groupAlipay"]){
                NSLog(@"%d",[[dic safeObjectForKey:@"IsOpen"] intValue]);
                [ProcessSwitcher shared].allowAlipayForGroupon = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
            else if([[dic safeObjectForKey:@"Key"] isEqualToString:@"passbookHotel"]){
                [ProcessSwitcher shared].hotelPassOn = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
            else if([[dic safeObjectForKey:@"Key"] isEqualToString:@"passbookGroupon"]){
                [ProcessSwitcher shared].grouponPassOn = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
            else if([[dic safeObjectForKey:@"Key"] isEqualToString:Html_Hotel_Switch]){
                [ProcessSwitcher shared].hotelHtml5On = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
            else if([[dic safeObjectForKey:@"Key"] isEqualToString:Html_Flight_Switch]){
                [ProcessSwitcher shared].flightHtml5On = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
            else if([[dic safeObjectForKey:@"Key"] isEqualToString:Html_Groupon_Switch]){
                [ProcessSwitcher shared].grouponHtml5On = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
            else if([[dic safeObjectForKey:@"Key"] isEqualToString:IFLY_VoiceSearch]){
                [ProcessSwitcher shared].allowIFlyMSC = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }else if([[dic safeObjectForKey:@"Key"] isEqualToString:HTTPSORHTTP]){
                [ProcessSwitcher shared].allowHttps = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }else if([[dic safeObjectForKey:@"Key"] isEqualToString:SHOWC2CINHOTELSEARCH]){
                [ProcessSwitcher shared].showC2CInHotelSearch = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }else if([[dic safeObjectForKey:@"Key"] isEqualToString:SHOWC2CORDER]){
                [ProcessSwitcher shared].showC2COrder = [[dic safeObjectForKey:@"IsOpen"] boolValue];
            }
        }
    }
}

#pragma mark - ABnotifierDelegate

-(id)rootViewControllerForNotice{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate.navigationController;
}

#pragma mark -
#pragma mark QAppKeyCheckDelegate

- (void)notifyAppKeyCheckResult:(QErrorCode)errCode{
    NSLog(@"errcode = %d",errCode);
    printf("ILOve you!");
    
    if (errCode == QErrorNone) {
        NSLog(@"恭喜您，APPKey验证通过！");
    }
    else if(errCode == QNetError){
        //[self showAlertView:@"AppKey验证结果" widthMessage:@"网络好像不太给力耶！请检查下网络是否畅通?"];
    }
    else if(errCode == QAppKeyCheckFail){
        //[self showAlertView:@"AppKey验证结果" widthMessage:@"您的APPKEY好像是有问题喔，请检查下APPKEY是否正确？"];
    }
}
@end
