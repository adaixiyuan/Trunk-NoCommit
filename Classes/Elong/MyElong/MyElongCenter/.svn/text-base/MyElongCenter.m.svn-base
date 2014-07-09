//
//  MyElongCenter.m
//  ElongClient
//
//  Created by elong lide on 11-12-26.
//  Copyright 2011 elong. All rights reserved.
//

#import "MyElongCenter.h"
#import "OrderManagement.h"
#import "DragonVIP.h"
#import "HotelOrderCell.h"
#import "GroupStyleCell.h"
#import "InterHotelOrderHistoryController.h"
#import "GOrderHistoryRequest.h"
#import "GrouponOrderHistoryController.h"
#import "HotelFavorite.h"
#import "CommentHotelRequest.h"
#import "CommentHotelListViewController.h"
#import "UserInfoSettingVC.h"
#import "CashAccountVC.h"
#import "CashAccountConfig.h"
#import "CashAccountReq.h"
#import "CouponListController.h"
#import "AccountInform.h"
#import "GrouponFavoriteRequest.h"
#import "GrouponFavorite.h"
#import "TokenReq.h"
#import "TrainOrderListVC.h"
#import "TrainReq.h"
#import "MessageManager.h"
#import "TaxiListContrl.h"
#import "TaxiListModel.h"
#import "TaxiOrderManager.h"
#import "HotelOrderListViewController.h"
#import "RentCarOrderViewController.h"
#import "RentOrderModel.h"
#import "Feedback_HotelOrderListViewController.h"
#import "CountlyEventClick.h"
#import "UniformCreditCardModel.h"
#import "NSString+URLEncoding.h"
#import "XGApplication.h"
#import "XGHttpRequest.h"
#import "XGOrderModel.h"
#import "XGHomeOrderViewController.h"
#import "XGApplication+Common.h"


#define LONGCUI_MEMBER_TIP              @"龙萃礼遇"
#define NOT_LONGCUI_MEMBER_TIP          @"参与龙萃计划"

#define CELL_HEGHT      44

#define GETCOUPON_STATE 1
#define GET_NATIVE_HOTEL_ORDER 2
#define GET_INTER_HOTEL_ORDER 3
#define GET_C2C_ORDER 33
#define GET_GROUPON_ORDER 4
#define GET_FLIGHT_ORDER 5
#define GET_TRAIN_ORDER 51
#define GET_RENTCAR_ORDER 52
#define GETHOTELFAVORITES_STATE 6
#define GETHOTEL 7
#define GET_CASHACCOUNT_INFO    8
#define GETGROUPONFAVORITES_STATE  9
#define GETGROUPON_COMMENT 11
#define GET_TAXILIST  10
#define GET_FEEDBACKLIST  12
#define GET_FEEDBACKSTATUS 13
#define TableTopBgTag 2055

static NSString *const titles[] = {
    @"国内酒店订单",
    @"国际酒店订单",
    @"酒店直销订单",   //c2c by lc
    @"团购订单",
    @"机票订单",
    @"火车票订单",
    @"打车订单",
    @"租车订单",
    @"入住反馈酒店",
    @"常用信息设置",
    @"酒店点评",
    @"团购点评",
    @"收藏酒店",
    @"收藏团购"
};

static int customerIndex;
static NSMutableArray *allUserInfo;
static NSMutableArray *allAddressInfo;
static NSMutableArray *allCardsInfo;
static NSMutableArray *allCouponInfo;
static NSMutableArray *allActiveCouponInfo;
static NSMutableArray *allHotelFInfo;

@interface MyElongCenter ()

@property (nonatomic, copy) NSString *scoreString_m;      // 纪录积分（内存被回收时使用）
@property (nonatomic, copy) NSString *couponString_m;     // 纪录消费券（内存被回收时使用）
@property (nonatomic, copy) NSString *cashString_m;       // 纪录现金账户（内存被回收时使用）
@property (nonatomic, retain) NSMutableDictionary *cashDetailDic;     // 现金账户详情

@end

@implementation MyElongCenter


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATE_MESSAGECOUNT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_HAD_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_LONGVIP object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_CASHACCOUNT_SETPASSWORDSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_CASHACCOUNT_RECHARGE object:nil];
    
    [scoreUtil cancel];
    SFRelease(scoreUtil);
    [couponUtil cancel];
    SFRelease(couponUtil);
    [cashUtil cancel];
    SFRelease(cashUtil);
    [unbindUserPushUtil cancel];
    SFRelease(unbindUserPushUtil);
    
    self.scoreString_m = nil;
    self.couponString_m = nil;
    self.cashString_m = nil;
    self.cashDetailDic = nil;
    
    [_edit_btn release];
    [couponBtn release];
    [cashBtn release];
    [_userName release];
    [scorelabel release];
    [DragonVIPLabel release];
    [_nameArrow release];
    [_goVIPDetailArrow release];
    [_goVIPDetailLabel release];
    [table release];
    [go2DragonVIPDetai_btn release];
    [couponLabel release];
    [couponMarkLabel release];
    [cashLabel release];
    [cashMarkLabel release];
    [headerView release];
    
    [_messageBoxCtrl.view removeFromSuperview];
    [_notification.view removeFromSuperview];
    [_adviceAndFeedBack.view removeFromSuperview];
    [_messageBoxCtrl release];
    [_notification release];
    [_adviceAndFeedBack release];
    [_feedBackHotelOrderList release];
    
    UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
    [dataModel clearData];
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil) {
        self.view = nil;
    }
}


- (id)init {
    if (self = [super initWithTopImagePath:@"" andTitle:@"个人中心" style:_NavOnlyBackBtnStyle_])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserData) name:NOTI_HAD_LOGIN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setcount:) name:NOTI_LONGVIP object:nil];
        // 设置密码成功后，接受通知，刷新页面
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCashAccountState) name:NOTI_CASHACCOUNT_SETPASSWORDSUCCESS object:nil];
        // 充值成功后，刷新CA账户数额
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshForRemain:) name:NOTI_CASHACCOUNT_RECHARGE object:nil];
        
        if (STRINGHASVALUE([[AccountManager instanse] cardNo]))
        {
            // 登陆成功异步请求个人信息
            [self startLoadingPersonInfo];
        }
        
        existCashPayPassword = NO;
    }
	
    return self;
}


// 发起用户的积分、余额和现金账户数目的请求
- (void)startLoadingPersonInfo
{
    JPostHeader *postheader = [[JPostHeader alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
    
    if (scoreUtil) {
        [scoreUtil cancel];
        SFRelease(scoreUtil);
    }
    scoreUtil = [[HttpUtil alloc] init];
    [scoreUtil connectWithURLString:MYELONG_SEARCH
                            Content:[postheader requesString:YES action:@"GetUseableCredits" params:dict]
                       StartLoading:NO
                         EndLoading:NO
                           Delegate:self];
    [scorelabel startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    
    if (couponUtil) {
        [couponUtil cancel];
        SFRelease(couponUtil);
    }
    couponUtil = [[HttpUtil alloc] init];
    [couponUtil connectWithURLString:MYELONG_SEARCH
                             Content:[postheader requesString:YES action:@"GetCouponValue" params:dict]
                        StartLoading:NO
                          EndLoading:NO
                            Delegate:self];
    [couponLabel startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    
    if (cashUtil) {
        [cashUtil cancel];
        SFRelease(cashUtil);
    }
    cashUtil = [[HttpUtil alloc] init];
    [cashUtil connectWithURLString:GIFTCARD_SEARCH
                           Content:[CashAccountReq getCashAmountByBizType:BizTypeMyelong]
                      StartLoading:NO
                        EndLoading:NO
                          Delegate:self];
    [cashLabel startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    
    [dict release];
    [postheader release];
}

-(void)updateCashValue:(NSString *)valueStr{
    cashLabel.text = valueStr;
    cashMarkLabel.text = @"¥";
    CGSize cashSize = [cashLabel.text sizeWithFont:cashLabel.font];
    CGRect cashMarkRect = cashMarkLabel.frame;
    cashMarkRect.origin.x = cashLabel.frame.origin.x+cashLabel.frame.size.width/2-cashSize.width/2-cashMarkRect.size.width;
    cashMarkLabel.frame   = cashMarkRect;
}

-(void)updateCouponValue:(NSString *)valueStr{
    couponLabel.text = valueStr;
    couponMarkLabel.text = @"¥";
    CGSize couponSize = [couponLabel.text sizeWithFont:couponLabel.font];
    CGRect couponMarkRect = couponMarkLabel.frame;
    couponMarkRect.origin.x = couponLabel.frame.origin.x+couponLabel.frame.size.width/2-couponSize.width/2-couponMarkRect.size.width;
    couponMarkLabel.frame   = couponMarkRect;
}


// 更新现金账户余额
- (void)refreshForRemain:(NSNotification *)noti
{
    NSDictionary *root = (NSDictionary *)[noti object];
    
    double remainingAmount = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
    double lockedAccount = [[root safeObjectForKey:LOCKEDAMOUNT] safeDoubleValue];
    [self updateCashValue:[NSString stringWithFormat:@"%.f", floor(remainingAmount)+floor(lockedAccount)]];
    self.cashDetailDic = [NSMutableDictionary dictionaryWithDictionary:root];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果是内存发生回收时，添加已获取到的数据
    if (STRINGHASVALUE(_scoreString_m)) {
        scorelabel.text = _scoreString_m;
    }
    if (STRINGHASVALUE(_couponString_m)) {
        couponLabel.text = _couponString_m;
    }
    if (STRINGHASVALUE(_cashString_m)) {
        [self updateCashValue:[NSString stringWithFormat:@"%@",_cashString_m]];
    }
    
    //设置入口
    UIBarButtonItem *settingBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"设置" Target:self Action:@selector(goSettingPage)];
    self.navigationItem.rightBarButtonItem = settingBarItem;
    
    // 配置顶部UI
    [self configTopUI];
    
    // 生成下方Table
    table.tableHeaderView = headerView;
    table.showsHorizontalScrollIndicator = NO;
    table.backgroundColor = [UIColor clearColor];
    table.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT - 64-44);
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(10, 10, 300, 40);
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"elongcenter_logoutBg_N.png"] forState:UIControlStateNormal];
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"elongcenter_logoutBg_H.png"] forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(clickLogout) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setTitle:@"注销" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footView addSubview:logoutBtn];
    table.tableFooterView = footView;
    [footView release];
    
    //add MessageBox and Activity
    _messageBoxCtrl = [[MessageBoxController alloc] init];
    [self.view addSubview:_messageBoxCtrl.view];
    _messageBoxCtrl.view.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    [_messageBoxCtrl updateUIWithFrame:_messageBoxCtrl.view.bounds];
    _messageBoxCtrl.view.hidden = YES;      //默认隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessageCount) name:UPDATE_MESSAGECOUNT object:nil];
    
    _notification = [[Notification alloc] init];
    [self.view addSubview:_notification.view];
    _notification.view.frame  = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
    [_notification updateUIWithFrame:_notification.view.bounds];
    _notification.view.hidden = YES;        //默认隐藏
    
    _adviceAndFeedBack = [[AdviceAndFeedback alloc] initWithTopImagePath:@"" andTitle:@"意见反馈" style:_NavLeftBtnImageStyle_];
    [self.view addSubview:_adviceAndFeedBack.view];
    _adviceAndFeedBack.view.hidden = YES;       //默认隐藏
    
    [self addBottomBarUI];      //增加新的底部导航栏
    
    _feedBackHotelOrderList = [[NSMutableArray alloc] initWithCapacity:1];       //初始化可反馈酒店列表
    
}

-(void)addBottomBarUI{
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    
    // 个人中心
    BaseBottomBarItem *elongCenterBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"个人中心"
                                                                           titleFont:[UIFont systemFontOfSize:12.0f]
                                                                               image:@"elongCenter_myelong_N.png"
                                                                     highligtedImage:@"elongCenter_myelong_H.png"];
    //消息盒子
    BaseBottomBarItem *messageBoxBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"消息"
                                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                                              image:@"elongCenter_messageBox_N.png"
                                                                    highligtedImage:@"elongCenter_messageBox_H.png"];
    
    // 活动公告
    BaseBottomBarItem  *notificationBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"活动"
                                                                             titleFont:[UIFont systemFontOfSize:12.0f]
                                                                                 image:@"elongCenter_notificationIcon_N.png"
                                                                       highligtedImage:@"elongCenter_notificationIcon_H.png"];
    
    // 活动公告
    BaseBottomBarItem  *feedbackBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"反馈"
                                                                         titleFont:[UIFont systemFontOfSize:12.0f]
                                                                             image:@"elongCenter_feedback_N.png"
                                                                   highligtedImage:@"elongCenter_feedback_H.png"];
    
    elongCenterBarItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    messageBoxBarItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    notificationBarItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    feedbackBarItem.customerTitleColor = BASEBOTTOMBAR_TITLE_COLOR_NORMAL;
    
    NSArray *items = [NSArray arrayWithObjects:elongCenterBarItem,messageBoxBarItem,notificationBarItem, feedbackBarItem,nil];
    bottomBar.baseBottomBarItems = items;
    [elongCenterBarItem changeStateToPressed:YES];
    bottomBar.selectedItem = elongCenterBarItem;    //默认选中
    
    [self.view addSubview:bottomBar];
    [elongCenterBarItem release];
    [messageBoxBarItem release];
    [notificationBarItem release];
    [feedbackBarItem  release];
    [bottomBar release];
    
    //add badgeBgImgView
    _badgeBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 5, 11, 11)];
    _badgeBgImgView.image = [UIImage imageNamed:@"elongCenter_message_badgeBg.png"];
    [bottomBar addSubview:_badgeBgImgView];
    [_badgeBgImgView release];
    _badgeBgImgView.hidden = YES;       //默认隐藏
    
    _badgeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
    _badgeNumLabel.backgroundColor = [UIColor clearColor];
    _badgeNumLabel.textAlignment = NSTextAlignmentCenter;
    _badgeNumLabel.textColor = [UIColor whiteColor];
    _badgeNumLabel.font = [UIFont systemFontOfSize:9];
    _badgeNumLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [_badgeBgImgView addSubview:_badgeNumLabel];
    [_badgeNumLabel release];
    
    [self updateMessageCount];
}

- (void)configTopUI {
    [couponBtn setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
    [cashBtn setBackgroundImage:COMMON_BUTTON_PRESSED_IMG forState:UIControlStateHighlighted];
    
    DragonVIPLabel.hidden = YES;
    NSString *vipNO = [[AccountManager instanse] DragonVIP];
    if ([[AccountManager instanse] cardNo] && [vipNO length] == 0) {//取到账号 但是没有取到是否是艺龙会员
        // 龙萃会员请求
        [PublicMethods getLongVIPInfo];
	}
	else if ([[AccountManager instanse] cardNo] && [vipNO intValue] == 2) {//取到账号 是艺龙会员
        DragonVIPLabel.text = @"龙萃会员";
        DragonVIPLabel.hidden = NO;
        _goVIPDetailLabel.text = LONGCUI_MEMBER_TIP;
        
        _goVIPDetailArrow.hidden = NO;
        _goVIPDetailLabel.hidden = NO;
        go2DragonVIPDetai_btn.hidden = NO;
	}
    else if ([[AccountManager instanse] cardNo] && [vipNO intValue] != 2) {//取到账号 不是艺龙会员
        _goVIPDetailLabel.text = NOT_LONGCUI_MEMBER_TIP;
        
        _goVIPDetailArrow.hidden = NO;
        _goVIPDetailLabel.hidden = NO;
        go2DragonVIPDetai_btn.hidden = NO;
    }
	else {
		// 还未登录成功时，先加上一个遮罩层，等待数据
		[[LoadingView sharedLoadingView] showAlertMessage:LOADINGTIPSTRING utils:nil];
        
        _goVIPDetailArrow.hidden = YES;
        _goVIPDetailLabel.hidden = YES;
        go2DragonVIPDetai_btn.hidden = YES;
	}
    
    NSString *userName = [[AccountManager instanse] name];
    [self setPersonName:userName];
    
    //add TopBgView
    table.backgroundView = [[[UIView alloc] initWithFrame:table.bounds] autorelease];
    UIImageView *elongCenter_topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 125-400, 320, 400)];
    elongCenter_topBgView.image = [UIImage noCacheImageNamed:@"elongCenter_topBg.jpg"];
    elongCenter_topBgView.tag = TableTopBgTag;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:elongCenter_topBgView.bounds];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.alpha = 0.25;
    [elongCenter_topBgView addSubview:whiteView];
    [whiteView release];
    
    [table.backgroundView addSubview:elongCenter_topBgView];
    [elongCenter_topBgView release];
    
    //add separateLine
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 76, 320, SCREEN_SCALE)];
    topLine.image = [UIImage imageNamed:@"dashed.png"];
    [headerView addSubview:topLine];
    [topLine release];
    //BottomLine
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 128 - SCREEN_SCALE, 320, SCREEN_SCALE)];
    bottomLine.image = [UIImage imageNamed:@"dashed.png"];
    [headerView addSubview:bottomLine];
    [bottomLine release];
    //SepLine
    UIImageView *sepLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(106, 77, SCREEN_SCALE, 50)];
    sepLine1.image = [UIImage imageNamed:@"dashed.png"];
    [headerView addSubview:sepLine1];
    [sepLine1 release];
    
    UIImageView *sepLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(213, 77, SCREEN_SCALE, 50)];
    sepLine2.image = [UIImage imageNamed:@"dashed.png"];
    [headerView addSubview:sepLine2];
    [sepLine2 release];
}

- (void)setcount:(NSNotification *)noti
{
    DragonVIPLabel.text = @"龙萃会员";
    DragonVIPLabel.hidden = NO;
    _goVIPDetailLabel.text = LONGCUI_MEMBER_TIP;
    _goVIPDetailArrow.hidden = NO;
    _goVIPDetailLabel.hidden = NO;
    go2DragonVIPDetai_btn.hidden = NO;
}

-(void)setPersonName:(NSString *)name{
    if (STRINGHASVALUE(name)) {
        _userName.text = name;
    }
    else {
        _userName.text = @"编辑信息";
    }
    //setting arrow frame by username text
    CGSize nameSize = [_userName.text sizeWithFont:_userName.font];
    int nameWidth = nameSize.width>=(295-_userName.frame.origin.x)?(295-_userName.frame.origin.x):nameSize.width;
    CGRect nameArrowFrame = _nameArrow.frame;
    nameArrowFrame.origin.x = _userName.frame.origin.x+nameWidth+5;
    _nameArrow.frame = nameArrowFrame;
}


- (void)refreshUserData
{
	// 更新用户数据
    NSString *userName = [[AccountManager instanse] name];
    [self setPersonName:userName];
    
    // 如果有遮罩层，去掉遮罩层
    [[LoadingView sharedLoadingView] hideAlertMessage];
    
    if (STRINGHASVALUE([[AccountManager instanse] cardNo])) {
        // 登陆成功异步请求个人信息
        [self startLoadingPersonInfo];
    }
}


// 更新现金账户状态
- (void)refreshCashAccountState
{
    // 设置为必须输入密码
    [_cashDetailDic setObject:[NSNumber numberWithBool:YES] forKey:EXIST_PAYMENT_PASSWORD];
}


- (void)back
{
	[PublicMethods closeSesameInView:self.navigationController.view];
}


-(void)clickLogout{
    if ([[ServiceConfig share] monkeySwitch]) {
        return;
    }
    
    //解除pushtoken绑定
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [userDefaults objectForKey:@"DeviceToken"];
    
    if (deviceToken) {
        
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
    }
    
	UILabel* lable = (UILabel*)[[self.navigationItem.rightBarButtonItem customView]  viewWithTag:10];
	lable.textColor = [UIColor whiteColor] ;
	
	[Utils alert:@"您已成功登出"];
	// 清空登录数据
	[[AccountManager instanse] clearData];
	// 就取消自动登录状态
	[[SettingManager instanse] setAutoLogin:NO];
    [[SettingManager instanse] clearPwd];
    
	// 清空信用卡信息
	[[SelectCard allCards] removeAllObjects];
	
	[PublicMethods closeSesameInView:self.navigationController.view];
    
    [[TokenReq shared] clearAllToken];
    
    UMENG_EVENT(UEvent_UserCenter_Home_Logout)
}


#pragma mark - IBAction
- (IBAction)go2DragonVIPDetail:(UIButton*)sender {
    BOOL isLongCuiVIP = [_goVIPDetailLabel.text isEqualToString:LONGCUI_MEMBER_TIP] ? YES : NO;
    
    DragonVIP *vipvc = [[DragonVIP alloc] initWithLongCui:isLongCuiVIP];
    [self.navigationController pushViewController:vipvc animated:YES];
    [vipvc release];
    
    UMENG_EVENT(UEvent_UserCenter_Home_VIP)
}


-(IBAction)editinfo_click:(UIButton*)sender{
	AccountInform *accountinform = [[AccountInform alloc] initWithTopImagePath:@"" andTitle:@"个人信息" style:_NavOnlyBackBtnStyle_];
	accountinform.myElongCenter = self;
	[self.navigationController pushViewController:accountinform animated:YES];
	[accountinform release];
    
    UMENG_EVENT(UEvent_UserCenter_Home_UserInfo)
}


- (IBAction)couponBtnClick:(id)sender {
    m_netstate = GETCOUPON_STATE;
    JCoupon *jcoupon=[MyElongPostManager coupon];
    [jcoupon clearBuildData];
    [Utils request:MYELONG_SEARCH req:[jcoupon requesCounponString:YES] delegate:self];
    
    if (UMENG) {
        //消费券列表
        [MobClick event:Event_CACouponList];
    }
    
    UMENG_EVENT(UEvent_UserCenter_Home_Coupon)
}


- (IBAction)cashBtnClick:(id)sender
{
    if (!STRINGHASVALUE(_cashString_m))
    {
        // 如果没有获取到金额，那么需要发起一次阻断请求，下页的布局由本页获取的数据决定
        m_netstate = GET_CASHACCOUNT_INFO;
        [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeMyelong] delegate:self];
        return;
    }
    
    // 已经请求到cash信息，直接进入下个页面
    CashAccountVC *controller = [[CashAccountVC alloc] initWithCashDetail:_cashDetailDic];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    if (UMENG) {
        //现金账户
        [MobClick event:Event_CAInfo];
    }
    
    UMENG_EVENT(UEvent_UserCenter_Home_CA)
}


- (BOOL)dealAsynchronizedUtil:(HttpUtil *)util data:(NSDictionary *)root {
    // 异步请求处理
    if (util == scoreUtil) {
        [scorelabel endLoading];
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            scorelabel.text = @"--";
        }
        else {
            self.scoreString_m = [NSString stringWithFormat:@"%@",[root safeObjectForKey:@"CreditCount"]];
            scorelabel.text = _scoreString_m;
        }
        
        return YES;
    }
    else if (util == couponUtil) {
        [couponLabel endLoading];
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            [self updateCouponValue:@"--"];
        }
        else {
            self.couponString_m = [NSString stringWithFormat:@"%@", [root safeObjectForKey:@"UsableValue"]];
            [self updateCouponValue:_couponString_m];
        }
        
        return YES;
    }
    else if (util == cashUtil)
    {
        [cashLabel endLoading];
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            [self updateCashValue:@"--"];
        }
        else
        {
            self.cashDetailDic = [NSMutableDictionary dictionaryWithDictionary:root];
            
            double remainingAmount = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
            double lockedAccount = [[root safeObjectForKey:LOCKEDAMOUNT] safeDoubleValue];
            self.cashString_m = [NSString stringWithFormat:@"%.f", floor(remainingAmount)+floor(lockedAccount)];
            [self updateCashValue:self.cashString_m];
            existCashPayPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
        }
        
        return YES;
    }else if(util == unbindUserPushUtil){
        NSLog(@"puchtoken解绑：%@",root);
    }
    
    return NO;
}

-(void)goSettingPage{
    ElongClientSetting *setting = [[ElongClientSetting alloc] initWithTopImagePath:@"" andTitle:@"设置" style:_NavNoTelStyle_];
    
    [self.navigationController pushViewController:setting animated:YES];
    [setting release];
    
    UMENG_EVENT(UEvent_UserCenter_Home_Setting)
    
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_LOGINPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_LOGINSET;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

-(void)submitAdviceFeedback{
    [_adviceAndFeedBack clickConfirm];  //点确认
}

-(void)updateMessageCount{
    int unreadCount = [[MessageManager sharedInstance] unreadMessageCount];
    if(unreadCount>0){
        _badgeBgImgView.hidden = NO;
        _badgeNumLabel.text = [NSString stringWithFormat:@"%d",unreadCount];
    }else{
        //清除消息显示
        _badgeBgImgView.hidden = YES;
        _badgeNumLabel.text = @"";
    }
}


#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if(index==0){
        //个人中心
        table.hidden = NO;
        _messageBoxCtrl.view.hidden = YES;
        _notification.view.hidden = YES;
        _adviceAndFeedBack.view.hidden = YES;
        
        UIImageView *topBgImgView = (UIImageView *)[table.backgroundView viewWithTag:TableTopBgTag];
        topBgImgView.frame = CGRectMake(0, 125-400-table.contentOffset.y, 320, 400);      //重置TOPBGVIEW位置
        
        [self setNavTitle:@"个人中心"];
        //设置入口
        UIBarButtonItem *settingBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"设置" Target:self Action:@selector(goSettingPage)];
        self.navigationItem.rightBarButtonItem = settingBarItem;
    }else if(index==1){
        //消息盒子
        table.hidden = YES;
        _messageBoxCtrl.view.hidden = NO;
        _notification.view.hidden = YES;
        _adviceAndFeedBack.view.hidden = YES;
        
        [self setNavTitle:@"消息盒子"];
        self.navigationItem.rightBarButtonItem = nil;
        
        UMENG_EVENT(UEvent_UserCenter_Home_Messages)
    }else if(index==2){
        //活动公告
        table.hidden = YES;
        _messageBoxCtrl.view.hidden = YES;
        _notification.view.hidden = NO;
        _adviceAndFeedBack.view.hidden = YES;
        
        [self setNavTitle:@"活动公告"];
        self.navigationItem.rightBarButtonItem = nil;
        
        UMENG_EVENT(UEvent_UserCenter_Home_Activities)
    }else{
        //意见反馈
        table.hidden = YES;
        _messageBoxCtrl.view.hidden = YES;
        _notification.view.hidden = YES;
        _adviceAndFeedBack.view.hidden = NO;
        
        [self setNavTitle:@"意见反馈"];
        //提交入口
        UIBarButtonItem *settingBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"提交" Target:self Action:@selector(submitAdviceFeedback)];
        self.navigationItem.rightBarButtonItem = settingBarItem;;
        
        UMENG_EVENT(UEvent_UserCenter_Home_Feedback)
    }
    
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@ %@", root, [root safeObjectForKey:@"ErrorMessage"]);
    
    if ([self dealAsynchronizedUtil:util data:root])
    {
        // 这里的异步请求都交给另一个方法实现
        return;
    }
    else {
        // 同步请求
        if ([Utils checkJsonIsError:root])
        {
            return ;
        }
        
        switch (m_netstate) {
            case GETCOUPON_STATE:
            {
				NSArray *mCouponArray = [root safeObjectForKey:@"CouponList"];
				[[MyElongCenter allCouponInfo] removeAllObjects];
				if (ARRAYHASVALUE(mCouponArray)) {
					[[MyElongCenter allCouponInfo] addObjectsFromArray:mCouponArray];
				}
				
				CouponListController *mCoupon = [[[CouponListController alloc] init] autorelease];
                mCoupon.detailList = [MyElongCenter allCouponInfo];
				[self.navigationController pushViewController:mCoupon animated:YES];
			}
                break;
            case GET_NATIVE_HOTEL_ORDER:
            {
                NSArray *tmpOrders = [root safeObjectForKey:ORDERS];
                int totalNumber = [[root safeObjectForKey:TOTALCOUNT] intValue];
                
                HotelOrderListViewController *hotelOrderListViewCtrl = [[HotelOrderListViewController alloc] initWithHotelOrders:tmpOrders totalNumber:totalNumber];
                [self.navigationController pushViewController:hotelOrderListViewCtrl animated:YES];
                [hotelOrderListViewCtrl release];
            }
                break;
            case GET_INTER_HOTEL_ORDER:
            {
                InterHotelOrderHistoryRequest *request = [OrderHistoryPostManager getInterHotelOrderHistory];
                NSDictionary *pageDic = [root safeObjectForKey:@"Page"];
                if (DICTIONARYHASVALUE(pageDic)) {
                    NSNumber *pageCount = [pageDic safeObjectForKey:@"PageCount"];
                    if (!OBJECTISNULL(pageCount)) {
                        request.totalPage = [pageCount integerValue];
                    }
                }
                
                InterHotelOrderHistoryController *controller = [[[InterHotelOrderHistoryController alloc] init] autorelease];
                controller.orderList = [root safeObjectForKey:@"OrderList"];
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
            case GET_C2C_ORDER:{  //国际酒店c2c
                
            }
                break;
            case GET_GROUPON_ORDER:
            {
                GrouponOrderHistoryController *controller = [[GrouponOrderHistoryController alloc] initWithOrderArray:[root safeObjectForKey:ORDERS]];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];
            }
                break;
            case GET_FLIGHT_ORDER:
            {
                FlightOrderHistory *order = [[FlightOrderHistory alloc] initWithDatas:root];
                [self.navigationController pushViewController:order animated:YES];
                [order release];
            }
                break;
            case GET_TRAIN_ORDER:
            {
                TrainOrderListVC *controller = [[TrainOrderListVC alloc] initWithArray:[root safeObjectForKey:k_orders]];
                [self.navigationController pushViewController:controller animated:controller];
                [controller release];
            }
                break;
            case GET_FEEDBACKLIST:
            {
                //针对获取的20条列表数据，再次访问反馈状态列表
                NSArray *tmpOrders = [root safeObjectForKey:ORDERS];
                [_feedBackHotelOrderList addObjectsFromArray:tmpOrders];
                
                NSMutableArray *orderIds = [NSMutableArray arrayWithCapacity:1];
                for(NSDictionary *anOrder in tmpOrders){
                    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
                    [orderIds addObject:orderNO];
                }
                
                
                m_netstate = GET_FEEDBACKSTATUS;
                long long cardNo = 0;
                if ([[AccountManager instanse] isLogin]){
                    cardNo = [[[AccountManager instanse] cardNo] longLongValue];
                }
                
                NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:cardNo],@"CardNo",orderIds,@"orderNos", nil];
                NSString *reqContent = [reqDictInfo JSONString];
                
                // 发起请求
                [[HttpUtil shared] requestWithURLString:[PublicMethods composeNetSearchUrl:@"myelong" forService:@"getFeedbackStatusList"] Content:reqContent Delegate:self];
            }
                break;
            case GET_FEEDBACKSTATUS:
            {
                //针对获取的20条列表数据，再次访问反馈状态列表
                NSArray *statusList = [root objectForKey:@"FeedbackStatus"];
                NSMutableArray *canFeedbackList = [NSMutableArray arrayWithCapacity:1];
                for(NSDictionary *feedbackStatus in statusList){
                    NSString *orderId = [feedbackStatus objectForKey:@"orderId"];
                    int status = [[feedbackStatus objectForKey:@"FeedbackStatus"] intValue];
                    
                    for(NSDictionary *hotelOrder in _feedBackHotelOrderList){
                        NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[hotelOrder safeObjectForKey:@"OrderNo"] doubleValue]];
                        if([orderId isEqualToString:orderNO]){
                            if(status==0 || status == 2){
                                //0 可反馈   1 不可反馈  2  反馈处理中
                                [canFeedbackList addObject:hotelOrder];
                            }
                            break;
                        }
                    }
                }
                
                
                //跳转到入住反馈酒店列表页
                Feedback_HotelOrderListViewController  *feedBackHotelOrderListCtrl = [[Feedback_HotelOrderListViewController alloc] initWithFeedBackList:canFeedbackList statusList:statusList];
                [self.navigationController pushViewController:feedBackHotelOrderListCtrl animated:YES];
                [feedBackHotelOrderListCtrl release];
            }
                break;
            case GETHOTELFAVORITES_STATE:
            {
                NSArray *mHFavorites;
				//判断返回的数据是否为空
				if ([root safeObjectForKey:@"HotelFavorites"] == [NSNull null]) {
					mHFavorites = [[[NSArray alloc] initWithObjects:nil] autorelease];
				}else {
					mHFavorites = [root safeObjectForKey:@"HotelFavorites"];
				}
				
				[[MyElongCenter allHotelFInfo] removeAllObjects];
				[[MyElongCenter allHotelFInfo] addObjectsFromArray:mHFavorites];
                
                HotelFavoriteRequest *jghf=[HotelPostManager favorite];
                
				HotelFavorite *mFavorite = [[HotelFavorite alloc] initWithEditStyle:YES category:jghf.category];
                mFavorite.totalCount = [[root objectForKey:@"TotalCount"] intValue];
				[self.navigationController pushViewController:mFavorite animated:YES];
				[mFavorite release];
            }
                break;
            case GETGROUPONFAVORITES_STATE:{
                GrouponFavorite *favorite = [[GrouponFavorite alloc]initWithEditStyle:YES grouponDict:root];
                
                [self.navigationController pushViewController:favorite animated:YES];
                [favorite release];
            }
                break;
            case GETHOTEL:
            {
                CommentHotelListViewController *controller = [[CommentHotelListViewController alloc] initWithHotelInfos:root commentType:HOTEL];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];
				
				[[CommentHotelRequest shared] clearHotelReqData];
            }
                break;
            case GETGROUPON_COMMENT:
            {
                CommentHotelListViewController *controller = [[CommentHotelListViewController alloc] initWithHotelInfos:root commentType:GROUPON];
				[self.navigationController pushViewController:controller animated:YES];
				[controller release];
				
				[[CommentHotelRequest shared] clearHotelReqData];
            }
                break;
            case GET_CASHACCOUNT_INFO:
            {
                [cashLabel endLoading];
                
                self.cashDetailDic = [NSMutableDictionary dictionaryWithDictionary:root];
                
                double remainingAmount = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
                double lockedAccount = [[root safeObjectForKey:LOCKEDAMOUNT] safeDoubleValue];
                self.cashString_m = [NSString stringWithFormat:@"%.f", floor(remainingAmount)+floor(lockedAccount)];
                [self updateCashValue:self.cashString_m];
                
                existCashPayPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
                CashAccountVC *controller = [[CashAccountVC alloc] initWithCashDetail:_cashDetailDic];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
                break;
            case GET_TAXILIST:
            {
                NSMutableArray  *modelAr = [NSMutableArray  array];
                
                NSArray  *ar = [root  objectForKey:@"list"];
                for(NSDictionary  *dic  in ar)
                {
                    TaxiListModel  *model = [[TaxiListModel  alloc]initWithDataDic:dic];
                    [modelAr addObject:model];
                    //NSLog(@"modelmodel%@",model.orderTitle);
                    [model release];
                }
                
                TaxiListContrl  *taxiList = [[TaxiListContrl  alloc] initWithTopImagePath:nil andTitle:@"打车订单" style:_NavNormalBtnStyle_   andArray:modelAr];
                //  taxiList.listAr = modelAr;
                
                [self.navigationController  pushViewController:taxiList animated:YES];
                
                [taxiList  release];
                
            }
                break;
            case GET_RENTCAR_ORDER:
            {
                NSMutableArray  *modelAr = [NSMutableArray  array];
                
                NSArray  *ar = [root  objectForKey:@"list"];
                for(NSDictionary  *dic  in ar)
                {
                    RentOrderModel  *model = [[RentOrderModel  alloc]initWithDataDic:dic];
                    [modelAr addObject:model];
                    //NSLog(@"modelmodel=%@",model.orderId);
                    [model release];
                }
                
                RentCarOrderViewController *rentCarVC = [[RentCarOrderViewController alloc]initWithRentCarOrders:modelAr];
                [self.navigationController pushViewController:rentCarVC animated:YES];
                [rentCarVC release];
                
            }
                break;
            default:
                break;
        }
    }
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == scoreUtil) {
        [scorelabel endLoading];
        scorelabel.text = @"--";
    }
    else if (util == couponUtil) {
        [couponLabel endLoading];
        [self updateCouponValue:@"--"];
    }
    else if (util == cashUtil) {
        [cashLabel endLoading];
        [self updateCashValue:@"--"];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }
    else if (section == 1) {
        return 1;
    }else if(section == 2){
        return 1;
    }
    else {
        return 4;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 18, 5, 9)];
        rightArrow.image = [UIImage imageNamed:@"ico_rightarrow.png"];
        cell.accessoryView =rightArrow;
        [rightArrow release];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bgView;
        [bgView release];
        
        UIImageView *selectedBgView = [[UIImageView alloc] initWithFrame:cell.bounds];
        selectedBgView.image = COMMON_BUTTON_PRESSED_IMG;
        cell.selectedBackgroundView  = selectedBgView;
        [selectedBgView release];
        
        cell.textLabel.font = FONT_16;
        cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
        cell.textLabel.highlightedTextColor = cell.textLabel.textColor;
        
        //第一行
        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
        topLine.tag = 4998;
        topLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:topLine];
        [topLine release];
        
        UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, 320, SCREEN_SCALE)];
        bottomLine.tag = 4999;
        bottomLine.image = [UIImage imageNamed:@"dashed.png"];
        [cell addSubview:bottomLine];
        [bottomLine release];
    }
    
    
    cell.detailTextLabel.font = FONT_13;
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.highlightedTextColor = cell.detailTextLabel.textColor;
    cell.detailTextLabel.text = @"";
    
    if(indexPath.section==0){
        cell.textLabel.text = titles[indexPath.row];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:250/255.0 green:33/255.0 blue:0 alpha:1];
        cell.detailTextLabel.highlightedTextColor = cell.detailTextLabel.textColor;
        
        //Detail属性值没有给出，暂时不设置
    }
    else if(indexPath.section==1){
        cell.textLabel.text = titles[8];
    }
    else if(indexPath.section==2){
        cell.textLabel.text = titles[9];
        cell.detailTextLabel.text = @"常用入住人/信用卡/地址";
    }else
    {
        if(indexPath.row == 0){
            cell.textLabel.text = titles[10];
            cell.detailTextLabel.text = @"点评得¥100消费券";
        }else if (indexPath.row == 1){
            cell.textLabel.text = titles[11];
        }else if (indexPath.row == 2)
        {
            cell.textLabel.text = titles[12];
        }else{
            cell.textLabel.text = titles[13];
        }
    }
    
    UIImageView *topLine = (UIImageView *)[cell viewWithTag:4998];
    UIImageView *bottomLine = (UIImageView *)[cell viewWithTag:4999];
    topLine.hidden = YES;
    if(indexPath.row==0){
        topLine.hidden = NO;
    }
    bottomLine.frame = CGRectMake(0, 44 - SCREEN_SCALE, 320, SCREEN_SCALE);
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView =  [[UIView alloc] init];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    return [sectionHeaderView autorelease];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                // 点击国内酒店订单
                m_netstate = GET_NATIVE_HOTEL_ORDER;
                
                JHotelOrderHistory *jhol=[OrderHistoryPostManager hotelorderhistory];
                [jhol clearBuildData];
                [jhol setHalfYear];
                [jhol setPageZero];
                [Utils request:MYELONG_SEARCH req:[jhol requesString:YES] delegate:self];
                
                UMENG_EVENT(UEvent_UserCenter_Home_InnerHotelOrders)
            }
                break;
            case 1:
            {
                // 点击国际酒店订单
                m_netstate = GET_INTER_HOTEL_ORDER;
                
                InterHotelOrderHistoryRequest *interHotelHistory = [OrderHistoryPostManager getInterHotelOrderHistory];
                interHotelHistory.currentPage = 1;
                interHotelHistory.countPerPage = 10;
                [Utils request:INTER_SEARCH req:[interHotelHistory request] delegate:self];
                
                UMENG_EVENT(UEvent_UserCenter_Home_InternationalHotelOrders)
            }
                break;
            case 2:  //c2c 酒店直销订单  勿删 by lc
            {
                [self inC2COrder];
            }
                break;
            case 3:
            {
                // 点击团购订单
                m_netstate = GET_GROUPON_ORDER;
                
                GOrderHistoryRequest *grouponListReq = [GOrderHistoryRequest shared];
                [grouponListReq refreshData];
                [grouponListReq reset];
                [Utils request:GROUPON_SEARCH req:[grouponListReq grouponListOrderCompress:YES] delegate:self];
                
                UMENG_EVENT(UEvent_UserCenter_Home_GrouponOrders)
            }
                break;
            case 4:
            {
                // 点击机票订单
                m_netstate = GET_FLIGHT_ORDER;
                
                JGetFlightOrderList *jgfol=[OrderHistoryPostManager getFlightOrderList];
                [jgfol clearBuildData];
                [jgfol setHalfYear];
                
                [Utils request:MYELONG_SEARCH req:[jgfol requesString:YES] delegate:self];
                
                UMENG_EVENT(UEvent_UserCenter_Home_FlightOrders)
            }
                break;
            case 5:
            {
                // 点击火车票订单
                m_netstate = GET_TRAIN_ORDER;
                NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
                [jsonDictionary setValue:@"ika0000000" forKey:@"wrapperId"];
                BOOL islogin = [[AccountManager instanse] isLogin];
                NSString *cardno = [[AccountManager instanse] cardNo];
                islogin = TRUE;
                if (islogin) {
                    [jsonDictionary setValue:cardno forKey:@"uid"];
                    [jsonDictionary setValue:cardno forKey:@"CardNo"];
                    [jsonDictionary setValue:@"1" forKey:@"isLogin"];
                }
                else {
                    [jsonDictionary setValue:[PublicMethods macaddress] forKey:@"uid"];
                    [jsonDictionary setValue:@"0" forKey:@"isLogin"];
                }
                NSString *paramJson = [jsonDictionary JSONString];
                NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"getTrainOrderList" andParam:paramJson];
                
                if (STRINGHASVALUE(url)) {
                    [HttpUtil requestURL:url postContent:nil delegate:self];
                }
                
                UMENG_EVENT(UEvent_UserCenter_Home_TrainOrders)
            }
                break;
            case 6:
            {
                // 点击打车订单
                //打车后面需要修改的参数
                m_netstate = GET_TAXILIST;
                NSMutableDictionary  *jsonDic = [NSMutableDictionary  dictionary];
                [jsonDic  setObject:@"01" forKey:@"productType"];
                NSString  *oId = [[AccountManager  instanse] cardNo];
                [jsonDic  setObject:oId forKey:@"uid"];
                NSString *jsonString = [jsonDic  JSONString];
                NSString  *url = [PublicMethods  composeNetSearchUrl:@"myelong" forService:@"takeTaxi/orderList" andParam:jsonString];
                [HttpUtil  requestURL:url postContent:Nil delegate:self];
                
                UMENG_EVENT(UEvent_UserCenter_Home_CarOrders)
                
            }
                break;
            case 7:
            {
                // 点击租车订单
                m_netstate = GET_RENTCAR_ORDER;
                NSString  *oId = [[AccountManager  instanse] cardNo];
                NSDictionary *jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:oId,@"uid",@"02",@"productType", nil];
                NSLog(@"会员号===%@",oId);
                NSString *jsonString = [jsonDic  JSONString];
                NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"rentCar/orderList" andParam:jsonString];
                if (STRINGHASVALUE(url)) {
                    [HttpUtil  requestURL:url postContent:Nil delegate:self];
                    UMENG_EVENT(UEvent_UserCenter_Home_RentOrders);
                }
            }
                break;
            default:
                break;
        }
        
    }
    else if (indexPath.section == 1)
    {
        m_netstate = GET_FEEDBACKLIST;
        
        JHotelOrderHistory *jhol=[OrderHistoryPostManager hotelorderhistory];
        [jhol clearBuildData];
        [jhol setHalfYear];
        [jhol setPageZero];
        [jhol setPageSize:20];      //获取前20个
        [Utils request:MYELONG_SEARCH req:[jhol requesString:YES] delegate:self];
    }
    else if (indexPath.section == 2)
    {
        // 点击常用信息
        UserInfoSettingVC *controller = [[UserInfoSettingVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        UMENG_EVENT(UEvent_UserCenter_Home_CommonInfo)
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                // 点击酒店点评
                m_netstate = GETHOTEL;
                
                CommentHotelRequest *commentReq = [CommentHotelRequest shared];
                [commentReq restoreData];
                [Utils orderRequest:HOTELSEARCH req:[commentReq getCanCommentHotel] delegate:self];
                
                UMENG_EVENT(UEvent_UserCenter_Home_HotelComment)
            }
                break;
            case 1:
            {
                // 点击团购点评
                m_netstate = GETGROUPON_COMMENT;
                
                long long cardNo = [[[AccountManager instanse] cardNo] longLongValue];
                NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithLongLong:cardNo] forKey:@"CardNo"];
                NSString *paramJson = [jsonDictionary JSONString];
                NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"getCanCommentOrders" andParam:paramJson];
                [HttpUtil requestURL:url postContent:nil delegate:self];
                
            }
                break;
            case 2:
            {
                // 点击收藏酒店
                m_netstate = GETHOTELFAVORITES_STATE;
                HotelFavoriteRequest *jghf=[HotelPostManager favorite];
                [jghf reset];
                jghf.cityId = nil;
                [Utils request:HOTELSEARCH req:[jghf request] delegate:self];
                
                if(UMENG){
                    //个人中心进收藏酒店列表页面
                    [MobClick event:Event_FavHotelList_MyElong];
                }
                
                UMENG_EVENT(UEvent_UserCenter_Home_HotelFavList)
            }
                break;
            case 3:
            {
                // 点击收藏团购
                m_netstate = GETGROUPONFAVORITES_STATE;
                GrouponFavoriteRequest *grouponFavReq = [HotelPostManager grouponFav];
                [grouponFavReq reset];
                [Utils request:GROUPON_SEARCH req:[grouponFavReq request] delegate:self];
                
                if (UMENG) {
                    //个人中心进入团购收藏列表
                    [MobClick event:Event_GrouponFavList_MyElong];
                }
                
                UMENG_EVENT(UEvent_UserCenter_Home_GrouponFavList)
            }
                break;
            default:
                break;
        }
    }
}


//酒店直销订单  勿删
-(void)inC2COrder{
    
    NSString *carNoValue = [[AccountManager instanse]cardNo];  //卡号
    carNoValue = STRINGHASVALUE(carNoValue)?carNoValue:@"";
    NSDictionary *dict =@{
                          @"CardNo":carNoValue,
                          @"page":@"0"
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    
    NSString *reqbody=[dict JSONString];
    
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"orderList"];
    
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    
    __unsafe_unretained  typeof(self) viewself = self;

    [XGHttpRequest evalForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        //        [viewself.httpArray removeObject:r];
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            [Utils alert:@"网络错误，请稍后再试"];
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        NSDictionary *dict =returnValue;
        NSArray *array =dict[@"Orders"];
        NSMutableArray *dataArray =[[NSMutableArray alloc] init];
        [dataArray addObjectsFromArray:[XGOrderModel comvertModelForJsonArray:array]];
        NSArray *tmpOrders = [NSArray arrayWithArray:dataArray];//[dict safeObjectForKey:ORDERS];
        id t =[dict safeObjectForKey:@"totalCount"];
        if (t ==nil) {
            t=[dict safeObjectForKey:@"TotalCount"];
        }
        int totalNumber = [t intValue];
        XGHomeOrderViewController *orderVC = [[XGHomeOrderViewController alloc]initWithHotelOrders:tmpOrders originArrayCount:array.count totalNumber:totalNumber];
        [viewself.navigationController pushViewController:orderVC animated:YES];
        [orderVC release];
        [dataArray release];
        
        NSLog(@"aaaaa==%@",dict);
        
    }];

    
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!table.hidden){
        UIImageView *topBgImgView = (UIImageView *)[table.backgroundView viewWithTag:TableTopBgTag];
        
        CGRect frame = topBgImgView.frame;
        frame.origin.y = (125-400 - scrollView.contentOffset.y)<0?(125-400 - scrollView.contentOffset.y):0;
        topBgImgView.frame = frame;
    }
}


+ (NSMutableArray *)allHotelFInfo  {
	
	@synchronized(self) {
		if(!allHotelFInfo) {
			allHotelFInfo = [[NSMutableArray alloc] init];
		}
	}
	return allHotelFInfo;
}

+ (void)customerIndex:(int)index  {
	customerIndex = index;
}
+ (int)getcustomerIndex{
	
	return customerIndex;
}

+ (NSMutableArray *)allUserInfo  {
    
	@synchronized(self) {
		if(!allUserInfo) {
			allUserInfo = [[NSMutableArray alloc] init];
		}
	}
	return allUserInfo;
}

+ (NSMutableArray *)allAddressInfo  {
    
	@synchronized(self) {
		if(!allAddressInfo) {
			allAddressInfo = [[NSMutableArray alloc] init];
		}
	}
	return allAddressInfo;
}

+ (NSMutableArray *)allCardsInfo  {
	
	@synchronized(self) {
		if(!allCardsInfo) {
			allCardsInfo = [[NSMutableArray alloc] init];
		}
	}
	return allCardsInfo;
}

+ (NSMutableArray *)allCouponInfo  {
	
	@synchronized(self) {
		if(!allCouponInfo) {
			allCouponInfo = [[NSMutableArray alloc] init];
		}
	}
	return allCouponInfo;
}

+ (NSMutableArray *)allActiveCouponInfo  {
	
	@synchronized(self) {
		if(!allActiveCouponInfo) {
			allActiveCouponInfo = [[NSMutableArray alloc] init];
		}
	}
	return allActiveCouponInfo;
}

@end