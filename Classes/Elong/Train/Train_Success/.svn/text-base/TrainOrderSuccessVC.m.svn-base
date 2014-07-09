//
//  TrainOrderSuccessVC.m
//  ElongClient
//
//  Created by Zhao Haibo on 13-11-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainOrderSuccessVC.h"
#import "FXLabel.h"
#import "TrainReq.h"
#import "TrainSeats.h"
#import "TrainTickets.h"
#import "ShareTools.h"
#import "OrderManagement.h"
#import "TrainOrderTicketRuleVC.h"
#import "TrainHomeVC.h"
#import "AlixPay.h"
#import "AttributedLabel.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kTOrderSuccessTableHeadViewHeight               228
#define kTOrderSuccessTableHeadUpViewHeight             116
#define kTOrderSuccessCellSeparateLineHeight            1
#define kTOrderSuccessTableHeadUpBGHeight               7
#define kTOrderSuccessTrainIconWidth                    63
#define kTOrderSuccessTrainIconHeight                   44
#define kTOrderSuccessDirectionArrowWidth               50
#define kTOrderSuccessDirectionArrowHeight              5
#define kTOrderSuccessCellOrderIconWidth                17
#define kTOrderSuccessCellOrderIconHeight               17
#define kTOrderSuccessCellArrowIconWidth                5
#define kTOrderSuccessCellArrowIconHeight               9


// 边框局
#define kTOrderSuccessRootVMargin                       15
#define kTOrderSuccessTableHeadMiddleHMargin            8
#define kTOrderSuccessTableHeadHMargin                  20
#define kTOrderSuccessTableHeadVMargin                  10
#define kTOrderSuccessOrderInfoViewVMargin              15
#define kTOrderSuccessTrainDriveViewVMargin             18
#define kTOrderSuccessCellHMargin                       20
#define kTOrderSuccessCellMiddleYMargin                 8
#define kTOrderSuccessHeaderHMargin                     20
#define kTOrderSuccessHeaderMiddleHMargin               8
#define kTOrderSuccessHeaderVMargin                     10


// 控件Tag
enum TrainOrderSuccessVCTag {
    kTOrderSuccessTableHeadUpBGTag = 100,
    kTOrderSuccessTableHeadDownBGTag,
    kTOrderSuccessTableHeadOrderInfoViewTag,
    kTOrderSuccessTableHeadTrainInfoViewTag,
    kTOrderSuccessTableHeadTrainIconTag,
    kTOrderSuccessBookHintLabelTag,
    kTOrderSuccessOrderNumHintLabelTag,
    kTOrderSuccessOrderNumLabelTag,
    kTOrderSuccessSeatHintLabelTag,
    kTOrderSuccessSeatLabelTag,
    kTOrderSuccessPriceHintLabelTag,
    kTOrderSuccessPriceSignLabelTag,
    kTOrderSuccessPriceLabelTag,
    kTOrderSuccessPriceDetailLabelTag,
    kTOrderSuccessTrainDepartViewTag,
    kTOrderSuccessTrainArriveViewTag,
    kTOrderSuccessTrainDriveViewTag,
    kTOrderSuccessDepartNameLabelTag,
    kTOrderSuccessDepartTimeLabelTag,
    kTOrderSuccessDepartStationDateLabelTag,
    kTOrderSuccessArriveNameLabelTag,
    kTOrderSuccessArriveTimeLabelTag,
    kTOrderSuccessArriveStationDateLabelTag,
    kTOrderSuccessTrainNumberLabelTag,
    kTOrderSuccessDirectionArrowIconTag,
    kTOrderSuccessDurationLabelTag,
    kTOrderSuccessOrderListLinkLabelTag,
    kTOrderSuccessHotelLinkLabelTag,
    kTOrderSuccessHeadBookTipLabelTag,
    kTOrderSuccessHeadPayTipLabelTag,
    kTOrderSuccessHeadRuleTipLabelTag,
};


#define CELL_HEIGHT         44
#define PAYTYPE_ALIPAY      5
#define PAYTYPE_WAPALIPAY   2
#define TIP_WAITING_PAY     @"●  请在1小时内支付，否则订单将自动被取消"
#define TIP_PAY_SUCCESS     @"●  由于各铁路局相关政策、火车票票源紧张等原因，支付后无法保证100%出票成功，敬请谅解\n● 我们会在30分钟内给您短信通知，请您等待或者查看订单状态\n● 您的资金是安全的，如出票失败，票款会在3-7个工作日内退回到您的原支付账号"

@interface TrainOrderSuccessVC ()

@property (nonatomic, copy) NSString *orderID;              // 订单号
@property (nonatomic, copy) NSString *alipayAddress;        // 支付宝wap地址

@end

@implementation TrainOrderSuccessVC


- (void)dealloc
{
    if (_getPayStateUtil)
    {
        [_getPayStateUtil cancel];
        SFRelease(_getPayStateUtil);
    }
    
    if (payAddressRequest)
    {
        [payAddressRequest cancel];
        SFRelease(payAddressRequest);
    }
    
    if (_homeAdNavi)
    {
        SFRelease(_homeAdNavi);
    }
    
    SFRelease(_orderID);
    SFRelease(_alipayAddress);
    
    [super dealloc];
}


- (id)initWithOrderInfo:(NSDictionary *)order isStudent:(BOOL)stu
{
    if (self = [super initWithTopImagePath:nil andTitle:@"支付订单" style:_NavBackShareHomeTelStyle_])
    {
        [self setShowBackBtn:YES];
        jumpToSafari = NO;
        paySuccess = NO;
        
        self.isStudent = stu;
        self.orderID = [order objectForKey:k_order_id];
        self.alipayAddress = [order objectForKey:k_notifyAddress];
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, kTOrderSuccessRootVMargin, SCREEN_WIDTH, MAINCONTENTHEIGHT-kTOrderSuccessRootVMargin) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = [UIColor clearColor];
        table.backgroundView = nil;
        table.scrollEnabled = YES;
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor clearColor];
        [self.view addSubview:table];
        [table release];
        
        // =======================================================================
        // TableHeader
        // =======================================================================
        UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectZero];
        int height = (self.isStudent)?kTOrderSuccessTableHeadViewHeight+30:kTOrderSuccessTableHeadViewHeight;
        [viewHeader setFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [viewHeader setBackgroundColor:[UIColor whiteColor]];
        
        // 创建子界面
        [self setupTableHeaderSubs:viewHeader];
        
        // 保存
        [table setTableHeaderView:viewHeader];
        
        [viewHeader release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAlipayWap:) name:NOTI_ALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
        
        if (![[AccountManager instanse] isLogin])
        {
            [self saveOrderInfo];
        }
    }
    
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    // 跳转链接
    if (_homeAdNavi == nil)
    {
        _homeAdNavi = [[HomeAdNavi alloc] init];
    }
    
    viewStatus = eStatusBookSuccess;
    
    // 保存和填充分享信息
    TrainTickets *ticket = [[TrainReq shared] currentRoute];
    NSUserDefaults *trainShareDefaults = [NSUserDefaults standardUserDefaults];
    [trainShareDefaults setObject:[self shareContent] forKey:[NSString stringWithFormat:@"%@,%@",ticket.departDate,ticket.number]];
    [trainShareDefaults synchronize];
    
    
    if (UMENG) {
        // 火车票成单
        [MobClick event:Event_TrainOrder_Succeed label:self.orderID];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    // 初始化推荐hotel的标志
    _isPushHotel = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)saveOrderInfo
{
    // 非会员存储订单信息
    NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_TRAIN_ORDERS];
	NSMutableArray *trainOrders = nil;
	
	if (!orderData) {
		trainOrders = [NSMutableArray arrayWithCapacity:2];
	}
	else {
		trainOrders = [NSKeyedUnarchiver unarchiveObjectWithData:orderData];
	}
    
    NSData *passengerData = [[NSUserDefaults standardUserDefaults] objectForKey:RECORD_TRAIN_PASSAGERS];
    NSArray *passengerArray = [NSKeyedUnarchiver unarchiveObjectWithData:passengerData];
    
    TrainSeats *seat = [[TrainReq shared] currentSeat];
    NSDictionary *seatDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             seat.name, k_name,
                             seat.code, k_seatCode, nil];
    
    // 订单金额
    NSString *orderPrice = @"";
    UILabel *labelPrice = (UILabel *)[self.view viewWithTag:kTOrderSuccessPriceLabelTag];
    if (labelPrice != nil)
    {
        orderPrice = [labelPrice text];
    }
    
    // 存储订单号和身份证号
	NSMutableDictionary *order = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								  _orderID, ORDERID_GROUPON,            // 纪录订单号
                                  orderPrice, k_paymentlPrice,     // 纪录金额
								  passengerArray, k_passengers,         // 纪录乘客信息
								  seatDic, k_seat,                      // 纪录座位信息
								  nil];
	
	[trainOrders insertObject:order atIndex:0];
	orderData = [NSKeyedArchiver archivedDataWithRootObject:trainOrders];
	[[NSUserDefaults standardUserDefaults] setObject:orderData forKey:NONMEMBER_TRAIN_ORDERS];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


// 返回首页
- (void)back
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[TrainHomeVC class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}


- (void)backhome
{
    if (!paySuccess)
    {
        backAlert = [[UIAlertView alloc] initWithTitle:@"提示"
                                               message:@"支付未完成，您可以到个人中心－火车票订单内完成支付"
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"确认", nil];
        [backAlert show];
        [backAlert release];
    }
    else
    {
        [super backhome];
    }
}

- (void)getPayState
{
    if (_isPayStateLoading)
    {
        return;
    }
    
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    
    // wrapperId
    [dictionaryJson safeSetObject:@"ika0000000" forKey:@"wrapperId"];
    
    // 订单流水号
    if (_orderID != nil)
    {
        [dictionaryJson safeSetObject:_orderID forKey:@"orderId"];
    }
    
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain"
                                            forService:@"syncPayed"
                                              andParam:paramJson];
    [dictionaryJson release];
    if (STRINGHASVALUE(url))
    {
        // 开始请求
        _isPayStateLoading = YES;
        
        // 请求
        if (_getPayStateUtil == nil)
        {
            _getPayStateUtil = [[HttpUtil alloc] init];
        }
        [_getPayStateUtil requestWithURLString:url
                                       Content:nil
                                  StartLoading:YES
                                    EndLoading:YES
                                      Delegate:self];
    }
    
    
    
}


- (void)changeStateToPaySuccess
{
    // UI变为预订成功状态
    
    UILabel *labelHint = (UILabel *)[self.view viewWithTag:kTOrderSuccessBookHintLabelTag];
    if (labelHint != nil)
    {
        [labelHint setText:@"预订成功!"];
    }
    
    [self setNavTitle:@"订单成功"];
    
    viewStatus = eStatusPaySuccess;
    [table reloadData];
    paySuccess = YES;
    
    UMENG_EVENT(UEvent_Train_OrderSuccess)
}

#pragma mark - Event Methods
- (void)clickPayBtn
{
    if (UMENG)
    {
        // 去支付宝支付
        [MobClick event:Event_TrainOrder_Pay];
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝客户端支付", @"支付宝网页支付", nil];
    [sheet showInView:self.view];
    [sheet release];
}

//执行支付
-(void) execPay
{
    //能用支付宝app支付先用app
    if ([PublicMethods couldPayByAlipayApp])
    {
        [PublicMethods payByAlipayApp:_alipayAddress];
        return;
    }
    
    // 点击支付按钮
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_alipayAddress]])
    {
        // 能用safari打开优先用safari打开
        [[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:_alipayAddress]];
        jumpToSafari = YES;
    }
    else
    {
        // 不能用safari打开的情况使用webView展示
        AlipayViewController *alipayVC = [[AlipayViewController alloc] init];
        alipayVC.requestUrl = [NSURL URLWithString:_alipayAddress];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:alipayVC];
        
        if (IOSVersion_7) {
            nav.transitioningDelegate = [ModalAnimationContainer shared];
            nav.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [self presentViewController:nav animated:YES completion:nil];
        }else{
            [self presentModalViewController:nav animated:YES];
        }
        [alipayVC release];
        [nav release];
        
        jumpToSafari = NO;
    }
}

//获取支付链接地址
-(void) getAliPayAddressByType:(int)payType
{
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setValue:_orderID forKey:@"orderId"];
    [jsonDictionary setValue:@"ika0000000" forKey:@"wrapperId"];
    [jsonDictionary setValue:[NSNumber numberWithInt:payType] forKey:@"payChannel"];
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    NSString *cardno = [[AccountManager instanse] cardNo];
//    islogin = TRUE;
    if (islogin) {
        [jsonDictionary setValue:cardno forKey:@"uid"];
        [jsonDictionary setValue:cardno forKey:@"CardNo"];
        [jsonDictionary setValue:@"1" forKey:@"isLogin"];
    }
    else {
        [jsonDictionary setValue:@"0" forKey:@"isLogin"];
        //        [jsonDictionary setValue:@"ika0000000" forKey:@"certNos"];
    }
    self.alipayAddress = nil;
    NSString *paramJson = [jsonDictionary JSONString];
    NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain" forService:@"repayLink" andParam:paramJson];
    
    if (payAddressRequest)
    {
        [payAddressRequest cancel];
        SFRelease(payAddressRequest);
    }
    
    payAddressRequest = [[HttpUtil alloc] init];
    [payAddressRequest requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
}

- (void)goMyOrderManager
{
    // 点击订单管理按钮
    OrderManagement *order = nil;
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
        order = [[OrderManagement alloc] initWithNibName:@"OrderManagementNoInterHotel" bundle:nil];
    }
    else {
        order = [[OrderManagement alloc] initWithNibName:nil bundle:nil];
    }
	order.isFromOrder = YES;
	[self.navigationController pushViewController:order animated:YES];
	[order release];
    
    UMENG_EVENT(UEvent_Train_OrderSuccess_Orders)
}


- (void)clickConfirmBtn
{
    // 点击确认按钮
    [super backhome];
}

// 到取票退票规则页
- (void)goTicketTule
{
    TrainOrderTicketRuleVC *controller = [[TrainOrderTicketRuleVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

// 跳转酒店
- (void)goHotel
{
    // 是否已经点击推荐
    if (_isPushHotel)
    {
        return;
    }
    // 设置标志
    _isPushHotel = YES;
    
    // 数据
    TrainReq *req = [TrainReq shared];
    TrainTickets *ticket = [req currentRoute];
    // 到达站
    NSString *arriveName = [[ticket arriveInfo] name];
    
    if (STRINGHASVALUE(arriveName))
    {
        // 是否包含"站"
        NSString *suffixString = @"站";
        
        NSRange foundObj=[arriveName rangeOfString:suffixString options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
        } else {
            arriveName = [arriveName stringByAppendingString:suffixString];
        }
        
        // 获取位置信息跳转酒店
        PositioningManager *positionManager = [PositioningManager shared];
        [positionManager getPositionFromAddress:arriveName];
        [positionManager setDelegate:self];
    }
}

// 显示日期信息
- (void) showFlashTips:(NSString *)tips
{
    if (!tips) {
        return;
    }
    UIImageView *flashView = (UIImageView *)[self.view viewWithTag:3110];
    if (flashView) {
        [flashView removeFromSuperview];
        flashView = nil;
    }
    flashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
    flashView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    flashView.alpha = 0;
    flashView.tag = 3110;
    flashView.clipsToBounds = YES;
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [window addSubview:flashView];
    
    //    [self.view addSubview:flashView];
    [flashView release];
    
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [flashView frame].size.width-20, [flashView frame].size.height)];
    tipsLbl.font = [UIFont boldSystemFontOfSize:14.0f];
    tipsLbl.textAlignment = UITextAlignmentCenter;
    tipsLbl.numberOfLines = 0;
    tipsLbl.lineBreakMode = UILineBreakModeWordWrap;
    tipsLbl.textColor = [UIColor whiteColor];
    tipsLbl.backgroundColor = [UIColor clearColor];
    [flashView addSubview:tipsLbl];
    [tipsLbl release];
    tipsLbl.text = tips;
    
    flashView.center = CGPointMake(SCREEN_WIDTH/2, 44);
    [UIView animateWithDuration:0.3 animations:^{
        flashView.alpha = 1;
        flashView.center = CGPointMake(SCREEN_WIDTH/2, 56);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:4 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            flashView.center = CGPointMake(SCREEN_WIDTH/2, 44);
            flashView.alpha = 0;
        } completion:^(BOOL finished) {
            [flashView removeFromSuperview];
        }];
    }];
}

#pragma mark - Share Methods
- (void)shareInfo
{
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
	shareTools.mailImage = [self screenshotOnCurrentView];
    shareTools.weiBoContent = [self shareContent];
	shareTools.msgContent = [self shareContent];
	shareTools.mailTitle = @"使用艺龙旅行客户端预订火车票成功！";
	shareTools.mailContent = [self shareContent];
	
	[shareTools  showItems];
}


- (UIImage *)screenshotOnCurrentView
{
    CGSize size = table.contentSize;
    if (size.height < SCREEN_HEIGHT)
    {
        size.height = SCREEN_HEIGHT;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    }
    else
    {
        UIGraphicsBeginImageContext(size);
    }
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    table.layer.masksToBounds = NO;
	[table.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    table.layer.masksToBounds = YES;
    return newImage;
}


- (NSString *) shareContent
{
    TrainTickets *ticket = [[TrainReq shared] currentRoute];
    TrainSeats *seat = [[TrainReq shared] currentSeat];
    
    NSString *date_str = [NSString stringWithFormat:@"我用艺龙客户端购买了火车票，车次：%@，%@座位，%@%@从%@站出发；%@%@到达%@站，客服电话：%@",[ticket number],[seat name],[ticket departShowDate],[[ticket departInfo] time],[[ticket departInfo] name],[ticket arriveShowDate],[[ticket arriveInfo] time],[[ticket arriveInfo] name],TRAIN_SERVER_NUM_TIPS];
    return date_str;
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 第一个otherButton
//    NSUInteger otherButtonIndex = [alertView firstOtherButtonIndex];
    
    if (alertView == backAlert)
    {
        if (0 != buttonIndex)
        {
            [super backhome];
        }
    }
    else if (alertView == askingAlert)
    {
        if (0 != buttonIndex)   // 重试
        {
            [self getPayState];
        }
        else    // 取消
        {
            
        }
    }
}


#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([PublicMethods couldPayByAlipayApp])
            {
                [self getAliPayAddressByType:PAYTYPE_ALIPAY];
            }
            else
            {
                [PublicMethods showAlertTitle:@"您未安装支付宝客户端" Message:nil];
            }
        }
            break;
        case 1:
        {
            [self getAliPayAddressByType:PAYTYPE_WAPALIPAY];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - PositioningManager Delegate
- (void)getPositionInfoBack:(NSDictionary *)dicPosition
{
    // 数据
    TrainReq *req = [TrainReq shared];
    TrainTickets *ticket = [req currentRoute];
    
    if (dicPosition != nil)
    {
        // 获取位置信息
        NSString *latlonInfo = [dicPosition safeObjectForKey:@"latlonInfo"];
        NSString *cityName = [dicPosition safeObjectForKey:@"cityName"];
        
        // 到达时间
        NSString *stringArrivalDate = @"";

        // 组合日期
        NSString *departDate = [ticket departDate];
        NSString *departTime = [[ticket departInfo] time];
        NSNumber *duration = [ticket duration];
        if (STRINGHASVALUE(departDate) && STRINGHASVALUE(departTime) && (duration != nil))
        {
            //
            NSDate *arriveDate = [[NSDate alloc] initWithTimeInterval:[duration integerValue]*60 sinceDate:[NSDate dateFromString:[NSString stringWithFormat:@"%@ %@",departDate,departTime] withFormat:@"yyyy-MM-dd HH:mm"]];
            
            stringArrivalDate = [NSDate stringFromDate:arriveDate withFormat:@"yyyy-MM-dd HH:mm"];
            
            [arriveDate release];
        }
        
        // 判断并跳转酒店
        if (STRINGHASVALUE(stringArrivalDate))
        {
            NSDate *arrivalDate = [NSDate dateFromString:stringArrivalDate withFormat:@"yyyy-MM-dd HH:mm"];
            
            NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
            NSDateComponents *components= [calendar components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit fromDate:arrivalDate];
            NSInteger hour = [components hour];
            
            // 设置日期  到店离店日期
            NSString *stringCheckin = [NSDate stringFromDate:arrivalDate withFormat:@"yyyy-MM-dd"];
            [_homeAdNavi setCheckInDate:stringCheckin];
            NSDate *checkOutDate = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate dateFromString:stringCheckin withFormat:@"yyyy-MM-dd"]];
            [_homeAdNavi setCheckOutDate:[NSDate stringFromDate:checkOutDate withFormat:@"yyyy-MM-dd"]];
            
            // 判断时间 跳转酒店
            if (hour >= 0 && hour < 6)
            {
                // 跳转日期和参数
                NSString *stringNoteDate = @"";
                NSString *jumpParam = @"";
                
                // 凌晨预定
                if (hour < 3)
                {
                    // 按照附近酒店搜索 跳转参数
                    if (STRINGHASVALUE(latlonInfo))
                    {
                        jumpParam = [NSString stringWithFormat:@"gotopoihotel:%@",latlonInfo];
                    }
                    else
                    {
                        jumpParam = [NSString stringWithFormat:@"gotohotelcity:%@",cityName];
                    }
                    
                    // 设置跳转日期
                    NSDate *dawnCheckIn = [NSDate dateWithTimeInterval:-86400 sinceDate:[NSDate dateFromString:stringCheckin withFormat:@"yyyy-MM-dd"]];
                    NSString *stringDawnCheckIn = [NSDate stringFromDate:dawnCheckIn withFormat:@"yyyy-MM-dd"];
                    [_homeAdNavi setCheckInDate:stringDawnCheckIn];
                    [_homeAdNavi setCheckOutDate:stringCheckin];
                    
                    // 提示信息日期
                    stringNoteDate = [NSDate stringFromDate:dawnCheckIn withFormat:@"MM月dd日"];
                    
                }
                // 非凌晨预定
                else if (hour >= 3)
                {
                    // 按城市搜索跳转
                    jumpParam = [NSString stringWithFormat:@"gotohotelcity:%@",cityName];
                    
                    stringNoteDate = [NSDate stringFromDate:arrivalDate withFormat:@"MM月dd日"];
                }
                // 预定提示
                NSString *noteTip = [NSString stringWithFormat:@"为您加载的为%@的酒店，请确认入住日期，返回或到酒店详情页都可修改日期。",stringNoteDate];
                
                [self showFlashTips:noteTip];
                
                // 酒店预定
                [_homeAdNavi adNaviJumpUrl:jumpParam title:@"列车跳转酒店" active:YES];
                
            }
            else if (hour >= 21)
            {
                NSString *jumpParam = @"";
                
                // 按照附近酒店搜索
                if (STRINGHASVALUE(latlonInfo))
                {
                    jumpParam = [NSString stringWithFormat:@"gotopoihotel:%@",latlonInfo];
                }
                else
                {
                    jumpParam = [NSString stringWithFormat:@"gotohotelcity:%@",cityName];
                }
                
                [_homeAdNavi adNaviJumpUrl:jumpParam title:@"列车跳转酒店" active:YES];
            }
            else if (hour >=6 && hour <21)
            {
                // 判断是否同一天
                BOOL isSameDay = [PublicMethods twoDateIsSameDay:[NSDate date] second:arrivalDate];
                if (isSameDay)  // 同一天
                {
                    [_homeAdNavi setCheckInDate:nil];
                    [_homeAdNavi setCheckOutDate:nil];
                    // 今日特价
                    NSString *jumpParam = [NSString stringWithFormat:@"gotolmhotel:%@",cityName];
                    
                    [_homeAdNavi adNaviJumpUrl:jumpParam title:@"列车跳转酒店" active:YES];
                    
                }
                else    // 不是同一天
                {
                    // 城市纬度搜索
                    NSString *jumpParam = [NSString stringWithFormat:@"gotohotelcity:%@",cityName];
                    
                    [_homeAdNavi adNaviJumpUrl:jumpParam title:@"列车跳转酒店" active:YES];
                    
                }
            }
        }
    }
}


#pragma mark - UI

// 创建TableHeader的子界面
- (void)setupTableHeaderSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    // ===========================================
    // 上背景
    // ===========================================
    CGSize upBGSize = CGSizeMake(parentFrame.size.width, kTOrderSuccessTableHeadUpBGHeight);
    
    UIImageView *upBG = (UIImageView *)[viewParent viewWithTag:kTOrderSuccessTableHeadUpBGTag];
    if (upBG == nil)
    {
        upBG = [[UIImageView alloc] initWithFrame:CGRectZero];
        [upBG setImage:[UIImage imageNamed:@"orderSuccess_envelopImgUp.png"]];
        [upBG setTag:kTOrderSuccessTableHeadUpBGTag];
        
        // 添加到父窗口
        [viewParent addSubview:upBG];
        [upBG release];
        
    }
    [upBG setFrame:CGRectMake(0, 0, upBGSize.width, upBGSize.height)];
    
    // 子窗口大小
    spaceYStart += upBGSize.height;
    
    // ===========================================
    // 下背景
    // ===========================================
    CGSize downBGSize = CGSizeMake(parentFrame.size.width, kTOrderSuccessTableHeadUpBGHeight);
    
    UIImageView *downBG = (UIImageView *)[viewParent viewWithTag:kTOrderSuccessTableHeadDownBGTag];
    if (downBG == nil)
    {
        downBG = [[UIImageView alloc] initWithFrame:CGRectZero];
        [downBG setImage:[UIImage imageNamed:@"orderSuccess_envelopImgDown.png"]];
        [downBG setTag:kTOrderSuccessTableHeadDownBGTag];
        
        // 添加到父窗口
        [viewParent addSubview:downBG];
        [downBG release];
        
    }
    [downBG setFrame:CGRectMake(0, spaceYEnd-downBGSize.height, downBGSize.width, downBGSize.height)];
    
    // 子窗口大小
    spaceYEnd -= downBGSize.height;
    
    // ===========================================
    // 列车Icon
    // ===========================================
    CGSize trainIconSize = CGSizeMake(kTOrderSuccessTrainIconWidth, kTOrderSuccessTrainIconHeight);
    
    UIImageView *trainIcon = (UIImageView *)[viewParent viewWithTag:kTOrderSuccessTableHeadTrainIconTag];
    if (trainIcon == nil)
    {
        trainIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [trainIcon setImage:[UIImage imageNamed:@"trainOrder_logoBg.png"]];
        [trainIcon setTag:kTOrderSuccessTableHeadTrainIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:trainIcon];
        [trainIcon release];
        
    }
    [trainIcon setFrame:CGRectMake(spaceXEnd-kTOrderSuccessTableHeadHMargin-trainIconSize.width, 0, trainIconSize.width, trainIconSize.height)];
    
    
    // 间隔
    spaceXStart += kTOrderSuccessTableHeadHMargin;
    spaceYStart += kTOrderSuccessTableHeadVMargin;
    
    
    // ===========================================
    // 订单信息
    // ===========================================
    CGSize viewOrderInfoSize = CGSizeMake(spaceXEnd-spaceXStart, kTOrderSuccessTableHeadUpViewHeight);
    
    UIView *viewOrdeInfo = [viewParent viewWithTag:kTOrderSuccessTableHeadOrderInfoViewTag];
    if (viewOrdeInfo == nil)
    {
        viewOrdeInfo = [[UIView alloc] initWithFrame:CGRectZero];
        [viewOrdeInfo setTag:kTOrderSuccessTableHeadOrderInfoViewTag];
        // 保存
        [viewParent addSubview:viewOrdeInfo];
        [viewOrdeInfo release];
    }
    [viewOrdeInfo setFrame:CGRectMake(spaceXStart, spaceYStart, viewOrderInfoSize.width, viewOrderInfoSize.height)];
    
    // 子窗口大小
    spaceYStart += viewOrderInfoSize.height;
    
    // 创建子界面
    [self setupTableHeadOrderInfoSubs:viewOrdeInfo];
    
    // ===========================================
    // 分隔线
    // ===========================================
    UIImageView *imageViewLine = [[UIImageView alloc] initWithFrame:CGRectZero];
	[imageViewLine setFrame:CGRectMake(spaceXStart, spaceYStart, spaceXEnd-spaceXStart, kTOrderSuccessCellSeparateLineHeight)];
	[imageViewLine setImage:[UIImage imageNamed:@"dashed.png"]];
    [imageViewLine setAlpha:0.8];
    
    // 子窗口大小
    spaceYStart += kTOrderSuccessCellSeparateLineHeight;
	
	// 添加到父窗口
	[viewParent addSubview:imageViewLine];
    [imageViewLine release];
    
    // ===========================================
    // 列车信息
    // ===========================================
    CGSize viewTrainInfoSize = CGSizeMake(spaceXEnd-spaceXStart, spaceYEnd-spaceYStart);
    
    UIView *viewTrainInfo = [viewParent viewWithTag:kTOrderSuccessTableHeadTrainInfoViewTag];
    if (viewTrainInfo == nil)
    {
        viewTrainInfo = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainInfo setTag:kTOrderSuccessTableHeadTrainInfoViewTag];
        // 保存
        [viewParent addSubview:viewTrainInfo];
        [viewTrainInfo release];
    }
    [viewTrainInfo setFrame:CGRectMake(0, spaceYStart, viewTrainInfoSize.width, viewTrainInfoSize.height)];
    
    
    // 创建子界面
    [self setupTableHeadTrainInfoSubs:viewTrainInfo];
    
    
}

// 创建订单信息子界面
- (void)setupTableHeadOrderInfoSubs:(UIView *)viewParent
{
    // 数据
    TrainReq *req = [TrainReq shared];
    TrainSeats *seat = [req currentSeat];
    
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // ===========================================
    // 预定成功Label
    // ===========================================
    NSString *bookHint = @"已下单!";
    CGSize hintSize = [bookHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:17.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kTOrderSuccessBookHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:17.0f]];
        [labelHint setTextColor:RGBCOLOR(252, 152, 44, 1)];
        [labelHint setTextAlignment:UITextAlignmentLeft];
        [labelHint setTag:kTOrderSuccessBookHintLabelTag];
        // 保存
        [viewParent addSubview:labelHint];
        [labelHint release];
    }
    [labelHint setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width*0.4, hintSize.height)];
    [labelHint setText:bookHint];
    
    // 子窗口大小
    spaceYStart += hintSize.height;
    
    // 间隔
    spaceYStart += kTOrderSuccessOrderInfoViewVMargin;
    
    
    // ===========================================
    // 订单号 Hint
    // ===========================================
    NSString *orderNumHint = @"订  单  号：";
    CGSize orderNumHintSize = [orderNumHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16.0f]];
    
    UILabel *labelOrderNumHint = (UILabel *)[viewParent viewWithTag:kTOrderSuccessOrderNumHintLabelTag];
    if (labelOrderNumHint == nil)
    {
        labelOrderNumHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelOrderNumHint setBackgroundColor:[UIColor clearColor]];
        [labelOrderNumHint setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16.0f]];
        [labelOrderNumHint setTextColor:RGBCOLOR(102, 102, 102, 1)];
        [labelOrderNumHint setTextAlignment:UITextAlignmentCenter];
        [labelOrderNumHint setTag:kTOrderSuccessOrderNumHintLabelTag];
        // 保存
        [viewParent addSubview:labelOrderNumHint];
        [labelOrderNumHint release];
    }
    [labelOrderNumHint setFrame:CGRectMake(0, spaceYStart, orderNumHintSize.width, orderNumHintSize.height)];
    [labelOrderNumHint setText:orderNumHint];
    
    // ===========================================
    // 订单号
    // ===========================================
    NSString *orderNum = [NSString stringWithFormat:@"%@", _orderID];
    CGSize orderNumSize = [orderNum sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:16.0f]];
    
    UILabel *labelOrderNum = (UILabel *)[viewParent viewWithTag:kTOrderSuccessOrderNumLabelTag];
    if (labelOrderNum == nil)
    {
        labelOrderNum = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelOrderNum setBackgroundColor:[UIColor clearColor]];
        [labelOrderNum setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:16.0f]];
        [labelOrderNum setTextColor:RGBCOLOR(52, 52, 52, 1)];
        [labelOrderNum setTextAlignment:UITextAlignmentCenter];
        [labelOrderNum setTag:kTOrderSuccessOrderNumLabelTag];
        // 保存
        [viewParent addSubview:labelOrderNum];
        [labelOrderNum release];
    }
    [labelOrderNum setFrame:CGRectMake(orderNumHintSize.width, spaceYStart, orderNumSize.width, orderNumSize.height)];
    [labelOrderNum setText:orderNum];
    
    // 子窗口大小
    spaceYStart += hintSize.height;
    // 间隔
    spaceYStart += kTOrderSuccessCellMiddleYMargin;
    
    // ===========================================
    // 座位Hint
    // ===========================================
    NSString *seatHint = @"座        位：";
    CGSize seatHintSize = [seatHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16.0f]];
    
    UILabel *labelSeatHint = (UILabel *)[viewParent viewWithTag:kTOrderSuccessSeatHintLabelTag];
    if (labelSeatHint == nil)
    {
        labelSeatHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelSeatHint setBackgroundColor:[UIColor clearColor]];
        [labelSeatHint setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16.0f]];
        [labelSeatHint setTextColor:RGBCOLOR(102, 102, 102, 1)];
        [labelSeatHint setTextAlignment:UITextAlignmentCenter];
        [labelSeatHint setTag:kTOrderSuccessSeatHintLabelTag];
        // 保存
        [viewParent addSubview:labelSeatHint];
        [labelSeatHint release];
    }
    [labelSeatHint setFrame:CGRectMake(0, spaceYStart, seatHintSize.width, seatHintSize.height)];
    [labelSeatHint setText:seatHint];
    
    
    
    // ===========================================
    // 座位
    // ===========================================
    if (STRINGHASVALUE(seat.name))
    {
        NSString *seatName;
        if (self.isStudent) {
            seatName = [NSString stringWithFormat:@"%@学生票", seat.name];
        }
        else {
            seatName = [NSString stringWithFormat:@"%@成人票", seat.name];
        }
        
        CGSize seatNameSize = [seatName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:16.0f]];
        
        UILabel *labelSeat = (UILabel *)[viewParent viewWithTag:kTOrderSuccessSeatLabelTag];
        if (labelSeat == nil)
        {
            labelSeat = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelSeat setBackgroundColor:[UIColor clearColor]];
            [labelSeat setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:16.0f]];
            [labelSeat setTextColor:RGBCOLOR(52, 52, 52, 1)];
            [labelSeat setTextAlignment:UITextAlignmentCenter];
            [labelSeat setTag:kTOrderSuccessSeatLabelTag];
            // 保存
            [viewParent addSubview:labelSeat];
            [labelSeat release];
        }
        [labelSeat setFrame:CGRectMake(seatHintSize.width, spaceYStart, seatNameSize.width, seatNameSize.height)];
        [labelSeat setText:seatName];
    }
    
    // 子窗口大小
    spaceYStart += hintSize.height;
    // 间隔
    spaceYStart += kTOrderSuccessCellMiddleYMargin;
    
    // ===========================================
    // 订单金额hint
    // ===========================================
    NSString *priceHint = @"消费金额：";
    CGSize priceHintSize = [priceHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16.0f]];
    
    UILabel *labelPriceHint = (UILabel *)[viewParent viewWithTag:kTOrderSuccessPriceHintLabelTag];
    if (labelPriceHint == nil)
    {
        labelPriceHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelPriceHint setBackgroundColor:[UIColor clearColor]];
        [labelPriceHint setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:16.0f]];
        [labelPriceHint setTextColor:RGBCOLOR(102, 102, 102, 1)];
        [labelPriceHint setTextAlignment:UITextAlignmentCenter];
        [labelPriceHint setTag:kTOrderSuccessPriceHintLabelTag];
        // 保存
        [viewParent addSubview:labelPriceHint];
        [labelPriceHint release];
    }
    [labelPriceHint setFrame:CGRectMake(0, spaceYStart, priceHintSize.width, priceHintSize.height)];
    [labelPriceHint setText:priceHint];
    
    // ===========================================
    // 订单金额
    // ===========================================
    if (STRINGHASVALUE(seat.price))
    {
        // ===========================================
        // 价格符号
        // ===========================================
        NSString *currencySign = @"¥";
        CGSize signSize = [currencySign sizeWithFont:[UIFont systemFontOfSize:12.0f]];
        UILabel *labelSign = (UILabel *)[viewParent viewWithTag:kTOrderSuccessPriceSignLabelTag];
        if (labelSign == nil)
        {
            labelSign = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelSign setBackgroundColor:[UIColor clearColor]];
            [labelSign setFont:[UIFont systemFontOfSize:12.0f]];
            [labelSign setTextColor:RGBCOLOR(254, 75, 32, 1)];
            [labelSign setTextAlignment:UITextAlignmentCenter];
            [labelSign setTag:kTOrderSuccessPriceSignLabelTag];
            // 保存
            [viewParent addSubview:labelSign];
            [labelSign release];
        }
        [labelSign setFrame:CGRectMake(priceHintSize.width, spaceYStart*1.03, signSize.width, signSize.height)];
        [labelSign setText:currencySign];
        
        // ===========================================
        // 价格
        // ===========================================
        CGFloat totalPriceValue = req.currentTicketNum * [seat.price floatValue];
        NSString *totalPrice = [NSString stringWithFormat:@"%.1f", totalPriceValue];
        
        NSString *totalPriceText = [totalPrice stringByReplacingOccurrencesOfString:@".0"withString:@""];
        
        CGSize priceTextSize = [totalPriceText sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
        
        UILabel *labelPrice = (UILabel *)[viewParent viewWithTag:kTOrderSuccessPriceLabelTag];
        if (labelPrice == nil)
        {
            labelPrice = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelPrice setBackgroundColor:[UIColor clearColor]];
            [labelPrice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f]];
            [labelPrice setTextColor:RGBCOLOR(254, 75, 32, 1)];
            [labelPrice setTextAlignment:UITextAlignmentCenter];
            [labelPrice setTag:kTOrderSuccessPriceLabelTag];
            // 保存
            [viewParent addSubview:labelPrice];
            [labelPrice release];
        }
        [labelPrice setFrame:CGRectMake(priceHintSize.width+signSize.width*1.3, spaceYStart-2, priceTextSize.width, priceTextSize.height)];
        [labelPrice setText:totalPriceText];
        
        
        // ===========================================
        // 价格详细
        // ===========================================
        NSString *priceDetail = [NSString stringWithFormat:@"(¥%@ x %d)", seat.price, req.currentTicketNum];
        CGSize priceDetailSize = [priceDetail sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15.0f]];
        
        UILabel *labelPriceDetail = (UILabel *)[viewParent viewWithTag:kTOrderSuccessPriceDetailLabelTag];
        if (labelPriceDetail == nil)
        {
            labelPriceDetail = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelPriceDetail setBackgroundColor:[UIColor clearColor]];
            [labelPriceDetail setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15.0f]];
            [labelPriceDetail setTextColor:RGBCOLOR(52, 52, 52, 1)];
            [labelPriceDetail setTextAlignment:UITextAlignmentCenter];
            [labelPriceDetail setTag:kTOrderSuccessPriceDetailLabelTag];
            // 保存
            [viewParent addSubview:labelPriceDetail];
            [labelPriceDetail release];
        }
        [labelPriceDetail setFrame:CGRectMake(priceHintSize.width+signSize.width+priceTextSize.width+kTOrderSuccessTableHeadMiddleHMargin,
                                              spaceYStart*1.03,
                                              priceDetailSize.width,
                                              priceDetailSize.height)];
        [labelPriceDetail setText:priceDetail];
        
    }
}


// 创建列车信息子界面
- (void)setupTableHeadTrainInfoSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    
    // ===========================================
    // 出发站信息
    // ===========================================
    CGSize viewTrainDepartSize = CGSizeMake(parentFrame.size.width/3, 0);
    
    UIView *viewTrainDepart = [viewParent viewWithTag:kTOrderSuccessTrainDepartViewTag];
    if (viewTrainDepart == nil)
    {
        viewTrainDepart = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainDepart setTag:kTOrderSuccessTrainDepartViewTag];
        // 保存
        [viewParent addSubview:viewTrainDepart];
        [viewTrainDepart release];
    }
    [viewTrainDepart setFrame:CGRectMake(spaceXStart, spaceYStart, viewTrainDepartSize.width, viewTrainDepartSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainDepartSubs:viewTrainDepart inSize:&viewTrainDepartSize];
    if (!self.isStudent) {
        [viewTrainDepart setViewY:(parentFrame.size.height - viewTrainDepartSize.height)/2];
    }else{
        [viewTrainDepart setViewY:(parentFrame.size.height - viewTrainDepartSize.height)/4];
    }
    
    // 子界面大小
    spaceXStart += viewTrainDepartSize.width;
    
    
    // ===========================================
    // 到达站信息
    // ===========================================
    CGSize viewTrainArriveSize = CGSizeMake(parentFrame.size.width/3, 0);
    
    UIView *viewTrainArrive = [viewParent viewWithTag:kTOrderSuccessTrainArriveViewTag];
    if (viewTrainArrive == nil)
    {
        viewTrainArrive = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainArrive setTag:kTOrderSuccessTrainArriveViewTag];
        // 保存
        [viewParent addSubview:viewTrainArrive];
        [viewTrainArrive release];
    }
    [viewTrainArrive setFrame:CGRectMake(spaceXEnd-viewTrainArriveSize.width, spaceYStart, viewTrainArriveSize.width, viewTrainArriveSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainArriveSubs:viewTrainArrive inSize:&viewTrainArriveSize];
    if (!self.isStudent) {
        [viewTrainArrive setViewY:(parentFrame.size.height - viewTrainArriveSize.height)/2];
    }else{
        [viewTrainArrive setViewY:(parentFrame.size.height - viewTrainArriveSize.height)/4];
    }
    
    // 子界面大小
    spaceXEnd -= viewTrainArriveSize.width;
    
    
    // ===========================================
    // 车程信息
    // ===========================================
    CGSize viewTrainDriveSize = CGSizeMake(spaceXEnd-spaceXStart, parentFrame.size.height);
    
    UIView *viewTrainDrive = [viewParent viewWithTag:kTOrderSuccessTrainDriveViewTag];
    if (viewTrainDrive == nil)
    {
        viewTrainDrive = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainDrive setTag:kTOrderSuccessTrainDriveViewTag];
        // 保存
        [viewParent addSubview:viewTrainDrive];
        [viewTrainDrive release];
    }
    [viewTrainDrive setFrame:CGRectMake(spaceXStart, spaceYStart, viewTrainDriveSize.width, viewTrainDriveSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainDriveSubs:viewTrainDrive];

    if (self.isStudent) {
        [self setupTableHeadStudentsTicketsTip:viewParent];
    }
}

-(void)setupTableHeadStudentsTicketsTip:(UIView*)view{

    //NSLog(@"view frame is %@",view);
    AttributedLabel *label = [[AttributedLabel alloc] initWithFrame:CGRectMake(kTOrderSuccessRootVMargin, 80,SCREEN_WIDTH-kTOrderSuccessRootVMargin*2, view.bounds.size.height-80) wrapped:YES];
    label.backgroundColor = [UIColor clearColor];
    NSString *tip = @"请根据实际情况酌情选择学生票，艺龙不承担因学生信息不符而无法取票或进站的责任。";
    label.text = tip;
    [label setColor:[UIColor redColor] fromIndex:0 length:14];
    [label setFont:FONT_13 fromIndex:0 length:[tip length]];
    [view addSubview:label];
    [label release];
}

// 出发站信息
- (void)setupTableHeadTrainDepartSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 数据
    TrainReq *req = [TrainReq shared];
    TrainTickets *ticket = [req currentRoute];
    
    // 子窗口高宽
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    
    // ===========================================
    // 出发站
    // ===========================================
    NSString *departName = [[ticket departInfo] name];
    if (STRINGHASVALUE(departName))
    {
        CGSize nameSize = [departName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14.0f]];
        
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTOrderSuccessDepartNameLabelTag];
        if (labelName == nil)
        {
            labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelName setBackgroundColor:[UIColor clearColor]];
            [labelName setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14.0f]];
            [labelName setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelName setAdjustsFontSizeToFitWidth:YES];
            [labelName setMinimumFontSize:10.0f];
            [labelName setTextAlignment:UITextAlignmentCenter];
            [labelName setTag:kTOrderSuccessDepartNameLabelTag];
            // 保存
            [viewParent addSubview:labelName];
            [labelName release];
        }
        
        [labelName setFrame:CGRectMake(spaceXEnd-nameSize.width, spaceYStart, nameSize.width, nameSize.height)];
        [labelName setText:departName];
        
        // 子窗口大小
        spaceYStart += nameSize.height;
    }
    
    
    // ===========================================
    // 出发时间
    // ===========================================
    NSString *departTime = [[ticket departInfo] time];
    if (STRINGHASVALUE(departTime))
    {
        CGSize timeSize = [departTime sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f]];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTOrderSuccessDepartTimeLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f]];
            [labelTime setTextColor:[UIColor blackColor]];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setTag:kTOrderSuccessDepartTimeLabelTag];
            // 保存
            [viewParent addSubview:labelTime];
            [labelTime release];
        }
        
        [labelTime setFrame:CGRectMake(spaceXEnd-timeSize.width, spaceYStart, timeSize.width, timeSize.height)];
        [labelTime setText:departTime];
        
        // 子窗口大小
        spaceYStart += timeSize.height;
    }
    
    // ===========================================
    // 出发日期
    // ===========================================
    NSString *_departShowDate = [ticket departShowDate];
    if (STRINGHASVALUE(_departShowDate))
    {
        CGSize dateSize = [_departShowDate sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10.0f]];
        
        UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kTOrderSuccessDepartStationDateLabelTag];
        if (labelDate == nil)
        {
            labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDate setBackgroundColor:[UIColor clearColor]];
            [labelDate setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10.0f]];
            [labelDate setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelDate setTextAlignment:UITextAlignmentCenter];
            [labelDate setTag:kTOrderSuccessDepartStationDateLabelTag];
            // 保存
            [viewParent addSubview:labelDate];
            [labelDate release];
        }
        
        [labelDate setFrame:CGRectMake(spaceXEnd-dateSize.width, spaceYStart, dateSize.width, dateSize.height)];
        [labelDate setText:_departShowDate];
        
        // 子窗口大小
        spaceYStart += dateSize.height;
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}


// 到达站信息
- (void)setupTableHeadTrainArriveSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 数据
    TrainReq *req = [TrainReq shared];
    TrainTickets *ticket = [req currentRoute];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    
    // ===========================================
    // 到达站
    // ===========================================
    NSString *arriveName = [[ticket arriveInfo] name];
    if (STRINGHASVALUE(arriveName))
    {
        CGSize nameSize = [arriveName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14.0f]];
        
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTOrderSuccessArriveNameLabelTag];
        if (labelName == nil)
        {
            labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelName setBackgroundColor:[UIColor clearColor]];
            [labelName setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14.0f]];
            [labelName setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelName setAdjustsFontSizeToFitWidth:YES];
            [labelName setMinimumFontSize:10.0f];
            [labelName setTextAlignment:UITextAlignmentCenter];
            [labelName setTag:kTOrderSuccessArriveNameLabelTag];
            // 保存
            [viewParent addSubview:labelName];
            [labelName release];
        }
        
        [labelName setFrame:CGRectMake(0, spaceYStart, nameSize.width, nameSize.height)];
        [labelName setText:arriveName];
        
        // 子窗口大小
        spaceYStart += nameSize.height;
    }
    
    
    // ===========================================
    // 到达时间
    // ===========================================
    NSString *arriveTime = [[ticket arriveInfo] time];
    if (STRINGHASVALUE(arriveTime))
    {
        CGSize timeSize = [arriveTime sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f]];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTOrderSuccessArriveTimeLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0f]];
            [labelTime setTextColor:[UIColor blackColor]];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setTag:kTOrderSuccessArriveTimeLabelTag];
            // 保存
            [viewParent addSubview:labelTime];
            [labelTime release];
        }
        
        [labelTime setFrame:CGRectMake(0, spaceYStart, timeSize.width, timeSize.height)];
        [labelTime setText:arriveTime];
        
        // 子窗口大小
        spaceYStart += timeSize.height;
    }
    
    // ===========================================
    // 到达日期
    // ===========================================
    NSString *arriveShowDate = [ticket arriveShowDate];
    if (STRINGHASVALUE(arriveShowDate))
    {
        CGSize dateSize = [arriveShowDate sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10.0f]];
        
        UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kTOrderSuccessArriveStationDateLabelTag];
        if (labelDate == nil)
        {
            labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDate setBackgroundColor:[UIColor clearColor]];
            [labelDate setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:10.0f]];
            [labelDate setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelDate setTextAlignment:UITextAlignmentCenter];
            [labelDate setTag:kTOrderSuccessArriveStationDateLabelTag];
            // 保存
            [viewParent addSubview:labelDate];
            [labelDate release];
        }
        
        [labelDate setFrame:CGRectMake(0, spaceYStart, dateSize.width, dateSize.height)];
        [labelDate setText:arriveShowDate];
        
        // 子窗口大小
        spaceYStart += dateSize.height;
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}

// 车程信息
- (void)setupTableHeadTrainDriveSubs:(UIView *)viewParent
{
    // 数据
    TrainReq *req = [TrainReq shared];
    TrainTickets *ticket = [req currentRoute];
    
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    // 间隔
    spaceYStart += kTOrderSuccessTrainDriveViewVMargin;
    spaceYEnd -= kTOrderSuccessTrainDriveViewVMargin;
    
    
    // ===========================================
    // 列车号
    // ===========================================
    NSString *number = [ticket number];
    if (STRINGHASVALUE(number))
    {
        CGSize numberSize = [number sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]];
        
        UILabel *labelNumber = (UILabel *)[viewParent viewWithTag:kTOrderSuccessTrainNumberLabelTag];
        if (labelNumber == nil)
        {
            labelNumber = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelNumber setBackgroundColor:[UIColor clearColor]];
            [labelNumber setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [labelNumber setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelNumber setTextAlignment:UITextAlignmentCenter];
            [labelNumber setTag:kTOrderSuccessTrainNumberLabelTag];
            // 保存
            [viewParent addSubview:labelNumber];
            [labelNumber release];
        }
        
        [labelNumber setFrame:CGRectMake((parentFrame.size.width-numberSize.width)/2, spaceYStart, numberSize.width, numberSize.height)];
        [labelNumber setText:number];
        
//        spaceYStart += numberSize.height;
    }
    
    // ===========================================
    // 指示箭头
    // ===========================================
    CGSize directionIconSize = CGSizeMake(kTOrderSuccessDirectionArrowWidth, kTOrderSuccessDirectionArrowHeight);
    UIImageView *directionIcon = (UIImageView *)[viewParent viewWithTag:kTOrderSuccessDirectionArrowIconTag];
    if (directionIcon == nil)
    {
        directionIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [directionIcon setImage:[UIImage noCacheImageNamed:@"ico_traindetailarrow.png"]];
        [directionIcon setTag:kTOrderSuccessDirectionArrowIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:directionIcon];
        [directionIcon release];
    }
    if (!self.isStudent) {
        [directionIcon setFrame:CGRectMake((parentFrame.size.width-directionIconSize.width)/2, (parentFrame.size.height-directionIconSize.height)/2, directionIconSize.width, directionIconSize.height)];
    }else{
        [directionIcon setFrame:CGRectMake((parentFrame.size.width-directionIconSize.width)/2, (parentFrame.size.height-directionIconSize.height)/3, directionIconSize.width, directionIconSize.height)];
    }
    
    
    
    // ===========================================
    // 历时
    // ===========================================
    NSString *durationShow = [ticket durationShow];
    if (STRINGHASVALUE(durationShow))
    {
        
        CGSize durationSize = [durationShow sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:10.0f]];
        
        UILabel *labelDuration = (UILabel *)[viewParent viewWithTag:kTOrderSuccessDurationLabelTag];
        if (labelDuration == nil)
        {
            labelDuration = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDuration setBackgroundColor:[UIColor clearColor]];
            [labelDuration setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:10.0f]];
            [labelDuration setTextColor:[UIColor blackColor]];
            [labelDuration setTextAlignment:UITextAlignmentCenter];
            [labelDuration setAdjustsFontSizeToFitWidth:YES];
            [labelDuration setMinimumFontSize:10.0f];
            [labelDuration setTag:kTOrderSuccessDurationLabelTag];
            // 保存
            [viewParent addSubview:labelDuration];
            [labelDuration release];
        }
        if (!self.isStudent) {
            [labelDuration setFrame:CGRectMake((parentFrame.size.width-durationSize.width)/2, spaceYEnd-durationSize.height, durationSize.width, durationSize.height)];
        }else{
            [labelDuration setFrame:CGRectMake((parentFrame.size.width-durationSize.width)/2, (parentFrame.size.height-directionIconSize.height)/3+20, durationSize.width, durationSize.height)];
        }
        [labelDuration setText:durationShow];
    }
}

// 创建HeaderView的子界面
- (void)setupTableViewHeaderSubs:(UIView *)viewParent inSection:(NSInteger)section inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXStart += kTOrderSuccessHeaderHMargin;
    spaceXEnd -= kTOrderSuccessHeaderHMargin;
    spaceYStart += kTOrderSuccessHeaderVMargin;
    
    // 订单预定成功
    if (viewStatus == eStatusBookSuccess)
    {
        // ===========================================
        // 订单提示
        // ===========================================
        UIFont *tipFont = [UIFont fontWithName:@"STHeitiJ-Light" size:12.0f];
        CGSize orderTipSize = [TIP_WAITING_PAY sizeWithFont:tipFont constrainedToSize:CGSizeMake(spaceXEnd - spaceXStart, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
        UILabel *labelTip = (UILabel *)[viewParent viewWithTag:kTOrderSuccessHeadBookTipLabelTag];
        if (labelTip == nil)
        {
            labelTip = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTip setBackgroundColor:[UIColor clearColor]];
            [labelTip setTextColor:RGBACOLOR(118, 118, 118, 1)];
            [labelTip setLineBreakMode:UILineBreakModeCharacterWrap];
            [labelTip setNumberOfLines:0];
            [labelTip setFont:tipFont];
            
            [labelTip setTag:kTOrderSuccessHeadBookTipLabelTag];
            [viewParent addSubview:labelTip];
            [labelTip release];
        }
        [labelTip setFrame:CGRectMake(spaceXStart, spaceYStart, orderTipSize.width, orderTipSize.height)];
        [labelTip setText:TIP_WAITING_PAY];
        
        // 调整子窗口大小
        spaceYStart += orderTipSize.height;
        
        // 间隔
        spaceYStart += kTOrderSuccessHeaderVMargin;
        
        // ===========================================
        // 支付按钮
        // ===========================================
        UIButton *payButton = [UIButton uniformButtonWithTitle:@"去支付" ImagePath:@"ico_flightfillorderbtn.png" Target:self Action:@selector(clickPayBtn) Frame:CGRectMake((pViewSize->width-BOTTOM_BUTTON_WIDTH)/2, spaceYStart, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
        [viewParent addSubview:payButton];
        
        // 调整子窗口大小
        spaceYStart += BOTTOM_BUTTON_HEIGHT;
        
    }
    // 订单支付成功
    else if (viewStatus == eStatusPaySuccess)
    {
        // ===========================================
        // 订单提示
        // ===========================================
        UIFont *tipFont = [UIFont systemFontOfSize:12.0f];
        CGSize orderTipSize = [TIP_PAY_SUCCESS sizeWithFont:tipFont constrainedToSize:CGSizeMake(spaceXEnd - spaceXStart, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
        UILabel *labelTip = (UILabel *)[viewParent viewWithTag:kTOrderSuccessHeadPayTipLabelTag];
        if (labelTip == nil)
        {
            labelTip = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTip setBackgroundColor:[UIColor clearColor]];
            [labelTip setTextColor:RGBACOLOR(118, 118, 118, 1)];
            [labelTip setLineBreakMode:UILineBreakModeCharacterWrap];
            [labelTip setNumberOfLines:0];
            [labelTip setFont:tipFont];
            
            [labelTip setTag:kTOrderSuccessHeadPayTipLabelTag];
            [viewParent addSubview:labelTip];
            [labelTip release];
        }
        [labelTip setFrame:CGRectMake(spaceXStart, spaceYStart, orderTipSize.width, orderTipSize.height)];
        [labelTip setText:TIP_PAY_SUCCESS];
        
        // 调整子窗口大小
        spaceYStart += orderTipSize.height;
        
        
        // ===========================================
        // 规则链接
        // ===========================================
        // 箭头
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewArrow setFrame:CGRectMake(spaceXEnd-kTOrderSuccessCellArrowIconWidth, spaceYStart+3, kTOrderSuccessCellArrowIconWidth, kTOrderSuccessCellArrowIconHeight)];
        [imageViewArrow setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        
        // 子窗口大小
        spaceXEnd -= kTOrderSuccessCellArrowIconWidth;
        // 间隔
        spaceXEnd -= kTOrderSuccessHeaderMiddleHMargin;
        
        // 添加到父窗口
        [viewParent addSubview:imageViewArrow];
        [imageViewArrow release];
        
        // 文字
        NSString *ruleTip = @"取票退票规则";
        UIFont *ruleFont = [UIFont systemFontOfSize:12.0f];
        CGSize ruleSize = [ruleTip sizeWithFont:ruleFont];
        UILabel *labelRule = (UILabel *)[viewParent viewWithTag:kTOrderSuccessHeadRuleTipLabelTag];
        if (labelRule == nil)
        {
            labelRule = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelRule setBackgroundColor:[UIColor clearColor]];
            [labelRule setTextColor:RGBACOLOR(29, 94, 226, 1)];
            [labelRule setFont:tipFont];
            
            [labelRule setTag:kTOrderSuccessHeadRuleTipLabelTag];
            [viewParent addSubview:labelRule];
            [labelRule release];
        }
        [labelRule setFrame:CGRectMake(spaceXEnd-ruleSize.width, spaceYStart, ruleSize.width, ruleSize.height)];
        [labelRule setText:ruleTip];
        
        // 调整子窗口大小
        spaceXEnd -= ruleSize.width;
        
        // 事件按钮
        UIControl *controlLink = [[UIControl alloc] initWithFrame:CGRectMake(spaceXEnd, spaceYStart, pViewSize->width-spaceXEnd, ruleSize.height)];
        [controlLink addTarget:self action:@selector(goTicketTule) forControlEvents:UIControlEventTouchUpInside];
        [controlLink setBackgroundColor:[UIColor clearColor]];
        
        // 保存
        [viewParent addSubview:controlLink];
        [controlLink release];
        
        // 调整子窗口大小
        spaceYStart += ruleSize.height;
    }
    
    // 间隔
    spaceYStart += kTOrderSuccessHeaderVMargin;

    // =======================================================================
    // 设置父窗口尺寸
    // =======================================================================
    pViewSize->height = spaceYStart;
    
    if(viewParent != nil)
    {
        [viewParent setViewHeight:pViewSize->height];
    }
}

// 创建Cell跳转链接子界面
- (void)setupCellLinkSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize andIndex:(NSUInteger)rowIndex
{
    // 数据
    TrainReq *req = [TrainReq shared];
    TrainTickets *ticket = [req currentRoute];
    
    if (rowIndex == 0)
    {
        // ===========================================
        // 上分隔线
        // ===========================================
        UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTOrderSuccessCellSeparateLineHeight)];
        topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [viewParent addSubview:topSplitView];
        [topSplitView release];
    }
    
    // ===========================================
    // 下分隔线
    // ===========================================
    UIImageView *bottomSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT-kTOrderSuccessCellSeparateLineHeight,SCREEN_WIDTH, kTOrderSuccessCellSeparateLineHeight)];
    bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [viewParent addSubview:bottomSplitView];
    [bottomSplitView release];
    
    // 位置变量
    CGRect parentFrame = [viewParent frame];
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    // 间隔
    spaceXStart += kTOrderSuccessCellHMargin;
    spaceXEnd -= kTOrderSuccessCellHMargin;
    
    // ===========================================
    // 箭头
    // ===========================================
    UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageViewArrow setFrame:CGRectMake(spaceXEnd-kTOrderSuccessCellArrowIconWidth, (parentFrame.size.height - kTOrderSuccessCellArrowIconHeight)/2, kTOrderSuccessCellArrowIconWidth, kTOrderSuccessCellArrowIconHeight)];
    [imageViewArrow setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
    
    // 添加到父窗口
    [viewParent addSubview:imageViewArrow];
    [imageViewArrow release];
    
    // ===========================================
    // 图标
    // ===========================================
    UIImageView *imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageViewIcon setFrame:CGRectMake(spaceXStart, (parentFrame.size.height - kTOrderSuccessCellOrderIconHeight)/2, kTOrderSuccessCellOrderIconWidth, kTOrderSuccessCellOrderIconHeight)];
    [imageViewIcon setImage:[UIImage imageNamed:@"viewOrder.png"]];
    if (rowIndex == 1)
    {
        [imageViewIcon setImage:[UIImage imageNamed:@"search_arrival_hotel_cell.png"]];
    }
    
    // 子窗口大小
    spaceXStart += kTOrderSuccessCellOrderIconWidth;
    
    // 添加到父窗口
    [viewParent addSubview:imageViewIcon];
    [imageViewIcon release];
    
    // 间隔
    spaceXStart += kTOrderSuccessCellHMargin;
    
    // ===========================================
    // 提示Label
    // ===========================================
    NSString *linkHint = @"查看订单";
    if (rowIndex == 1)
    {
        // 到达站
        NSString *arriveName = [[ticket arriveInfo] name];
        
        linkHint = [NSString stringWithFormat:@"看%@酒店",arriveName];
    }
    
    CGSize linkSize = [linkHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15.0f]];
    
    UILabel *labelLink = (UILabel *)[viewParent viewWithTag:kTOrderSuccessOrderListLinkLabelTag];
    if (labelLink == nil)
    {
        labelLink = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelLink setBackgroundColor:[UIColor clearColor]];
        [labelLink setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:15.0f]];
        [labelLink setTextColor:RGBCOLOR(52, 52, 52, 1)];
        [labelLink setTextAlignment:UITextAlignmentLeft];
        [labelLink setAdjustsFontSizeToFitWidth:YES];
        [labelLink setMinimumFontSize:10.0f];
        [labelLink setTag:kTOrderSuccessOrderListLinkLabelTag];
        // 保存
        [viewParent addSubview:labelLink];
        [labelLink release];
    }
    [labelLink setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-linkSize.height)/2, linkSize.width, linkSize.height)];
    [labelLink setText:linkHint];
}


#pragma mark - Notification Methods
- (void)notiByAlipayWap:(NSNotification *)noti{
    // 监测到支付宝wap页面支付成功时，改变相应状态
//    [self changeStateToPaySuccess];
    
//    [self getPayState];
}


- (void) alipayPaySuccess
{
    if (!jumpToSafari)
    {
        [self changeStateToPaySuccess];
    }
    
//    [self getPayState];
}



- (void)notiByAppActived:(NSNotification *)noti
{
    // 监测到程序被从后台激活时，询问用户支付情况
    if (jumpToSafari)
    {
        // 发起支付宝支付回调请求
        [self getPayState];
     
        jumpToSafari = NO;
    }
    
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IOSVersion_5)
    {
        return 2;
    }
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return CELL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    
    NSUInteger row = [indexPath row];
    
    NSString *reusedIdentifier = @"cellOrderLinkIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:reusedIdentifier] autorelease];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
    }
    
    // 创建contentView
    CGSize contentViewSize = CGSizeMake(parentFrame.size.width, CELL_HEIGHT);
    [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
    [self setupCellLinkSubs:[cell contentView] inSize:&contentViewSize andIndex:row];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGSize viewHeaderSize = CGSizeMake(tableView.frame.size.width, 0);
    CGRect rect = CGRectMake(0, 0, viewHeaderSize.width, viewHeaderSize.height);
    UIView* parent = [[UIView alloc] initWithFrame:rect];
    [self setupTableViewHeaderSubs:parent inSection:section inSize:&viewHeaderSize];
    
    [parent release];
    return viewHeaderSize.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGSize viewHeaderSize = CGSizeMake(tableView.frame.size.width, 0);
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewHeaderSize.width, viewHeaderSize.height)];
    [self setupTableViewHeaderSubs:viewHeader inSection:section inSize:&viewHeaderSize];
    
    return [viewHeader autorelease];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if (row == 0)
    {
        [self goMyOrderManager];
    }
    else if (row == 1)
    {
        [self goHotel];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - http

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util==payAddressRequest)
    {
        [Utils alert:@"抱歉，获取支付信息失败，请重试！"];
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if (util==payAddressRequest)
    {
        if ([Utils checkJsonIsErrorNoAlert:root]==YES)
        {
            if (root)
            {
                NSString *message = [root safeObjectForKey:@"ErrorMessage"];
                
                if (STRINGHASVALUE(message))
                {
                    [Utils alert:message];
                    return;
                }
            }
            
            [Utils alert:@"抱歉，获取支付信息失败，请重试！"];
            return;
        }
        
        if (STRINGHASVALUE([root safeObjectForKey:@"repayAddress"]))
        {
            self.alipayAddress=[root safeObjectForKey:@"repayAddress"];
            [self execPay];
        }
        else
        {
            if (root)
            {
                NSString *message = [root safeObjectForKey:@"ErrorMessage"];
                
                if (STRINGHASVALUE(message))
                {
                    [Utils alert:message];
                    return;
                }
            }
            
            [Utils alert:@"抱歉，获取支付信息失败，请重试！"];
        }
        
        return;
    }
    else if (util == _getPayStateUtil)
    {
        _isPayStateLoading = NO;
        
        if ([Utils checkJsonIsErrorNoAlert:root]==YES)
        {
            NSString *message = [root safeObjectForKey:@"ErrorMessage"];
            if (!STRINGHASVALUE(message))
            {
                message = @"服务器错误，是否重试?";
            }
            
            askingAlert = [[UIAlertView alloc] initWithTitle:message
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"重试", nil];
            [askingAlert show];
            [askingAlert release];
            
            jumpToSafari = YES;
            
            return;
        }
        
        NSString *returnCode = [root safeObjectForKey:@"code"];
        if (STRINGHASVALUE(returnCode) && [returnCode isEqualToString:@"0"])
        {
            if (UMENG) {
                // 火车票已支付
                [MobClick event:Event_TrainOrder_HavePay];
            }

            
            // 支付成功
            [self changeStateToPaySuccess];
        }
        else
        {
            NSString *returnDesc = [root safeObjectForKey:@"desc"];
            if (!STRINGHASVALUE(returnDesc))
            {
                returnDesc = @"";
            }
            
            askingAlert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:returnDesc
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"重试", nil];
            [askingAlert show];
            [askingAlert release];
            
            
            if (UMENG) {
                // 火车票未支付
                [MobClick event:Event_TrainOrder_HavenotPay];
            }
        }
    }
}

@end
