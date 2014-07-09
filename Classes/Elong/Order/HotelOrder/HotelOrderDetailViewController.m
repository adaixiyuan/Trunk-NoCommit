//
//  HotelOrderDetailViewController.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderDetailViewController.h"
#import "AccountManager.h"
#import "TokenReq.h"
#import "Html5WebController.h"
#import "AlipayViewController.h"
#import "AlixPay.h"
#import "HotelDetailController.h"
#import "HotelOrderFlowViewController.h"
#import "HotelOrderInvoiceFlowViewController.h"
#import "ElongClientAppDelegate.h"
#import "HotelPromotionInfoRequest.h"
#import "ForecastInformation.h"

#define TelPhone_ActionSheetTag 1001
#define AgainPay_ActionSheetTag 1002
#define CancelOrder_AlertTag 2001
#define Alipay_AlertTag 2002
#define PKPass_AlertTag 2003

#define kForecastMaskViewTag 10024
#define kForecastTopMaskViewTag (kForecastMaskViewTag + 1)

@interface HotelOrderDetailViewController ()

@property (nonatomic, retain) ForecastViewController *forecastVC;

@end

@implementation HotelOrderDetailViewController

- (void)dealloc
{
    [_detailTable release];
    [_detailArray release];
    [_currentOrder release];
    [_pkPass release];
    [_dataSource release];
    
    _orderListRequest.delegate= nil;
    _orderDetailRequest.delegate = nil;
    [_orderListRequest release];
    [_orderDetailRequest release];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_GET_TOKEN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_HOTEL_FEEDBACK object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ORDER_MODIFY object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ALIPAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_WEIXIN_PAYSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTI_ALIPAY_PAYSUCCESS object:nil];
    [super dealloc];
}

-(id)initWithHotelOrder:(NSDictionary *)order{
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[order safeObjectForKey:@"OrderNo"] doubleValue]];
    NSString *title = [NSString stringWithFormat:@"订单 %@",orderNO];
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    if(appDelegate.isNonmemberFlow){
        self = [super initWithTitle:title style:NavBarBtnStyleNormalBtn];       //非会员漏出电话，已供打电话取消用
    }else{
        self = [super initWithTitle:title style:NavBarBtnStyleOnlyBackBtn];
    }
    if(self){
        _currentOrder = [[NSDictionary alloc]  initWithDictionary:order];
        NSArray *anOrderFlows = [order safeObjectForKey:@"OrderFlows"];
        _currentOrderFlows = [[NSMutableArray alloc] initWithCapacity:1];
        if(ARRAYHASVALUE(anOrderFlows)){
            [_currentOrderFlows addObjectsFromArray:anOrderFlows];
        }
        //初始化网络请求
        _orderListRequest = [[HotelOrderListRequest alloc] initWithDelegate:self];
        _orderDetailRequest = [[HotelOrderDetailRequest alloc] initWithDelegate:self];
        //初始化一些通知
        [self initSomeNotifications];
    }
    return self;
}

-(void)initSomeNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_GetToken) name:NOTI_GET_TOKEN object:nil];     //获取AcessToken后进行通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_checkCanBeFeedback) name:NOTI_HOTEL_FEEDBACK object:nil]; //入住反馈后通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_modifyOrder) name:NOTI_ORDER_MODIFY object:nil];  //修改订单后通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_paySuccessByAgainPay:) name:NOTI_ALIPAY_SUCCESS object:nil];   //程序内web支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_paySuccessByAppActive:) name:UIApplicationDidBecomeActiveNotification object:nil];//程序外safari支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_paySuccessByAgainPay:) name:NOTI_WEIXIN_PAYSUCCESS object:nil];    //微信支付成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_paySuccessByAgainPay:) name:NOTI_ALIPAY_PAYSUCCESS object:nil];    //支付宝客户端支付成功通知
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataSource = [[HotelOrderDetailDataSource alloc] initWithOrder:_currentOrder table:_detailTable];      //初始化table委托和数据源
    _dataSource.parentViewController = self;
    _detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTable.backgroundColor = [UIColor clearColor];
    [self buildTableHeaderViewUI];      //构建顶部UI
    [self buildTableFooterViewUI];      //构建底部UI
    [self buildBottomBar];      //构建BottomBar
    [self notification_checkCanBeFeedback];      //检查是否可以入住反馈
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    if(appDelegate.isNonmemberFlow){
        //非会员进行异步加载
        [_orderDetailRequest startRequestWithGetOrderFlowState:_currentOrder];      //发送请求再次检查订单流程
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
//构建BaseBottomBar
-(void)buildBottomBar{
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    //分享订单
    BaseBottomBarItem *shareOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"分享订单"
                                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                                              image:@"hotelOrder_shareOrder_N.png"
                                                                    highligtedImage:@"hotelOrder_shareOrder_H.png"];
    
    BaseBottomBarItem  *saveOrderBarItem;
    if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passHotelOn]) {
        //Passbook
        saveOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"Passbook"
                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                              image:@"addToPassBook.png"
                                                    highligtedImage:@"addToPassBook.png"];
    }else{
        // 订单保存
        saveOrderBarItem= [[BaseBottomBarItem alloc] initWithTitle:@"保存订单"
                                                         titleFont:[UIFont systemFontOfSize:12.0f]
                                                             image:@"orderDetail_SaveOrder_N.png"
                                                   highligtedImage:@"orderDetail_SaveOrder_H.png"];
    }
    
    shareOrderBarItem.autoReverse = YES;
    shareOrderBarItem.allowRepeat = YES;
    
    saveOrderBarItem.autoReverse = YES;
    saveOrderBarItem.allowRepeat = YES;
    
    NSArray *items = [NSArray arrayWithObjects:shareOrderBarItem,saveOrderBarItem, nil];
    bottomBar.baseBottomBarItems = items;
    [self.view addSubview:bottomBar];
    
    [shareOrderBarItem release];
    [saveOrderBarItem release];
    [bottomBar release];
}

//自定义类型的Button适用于 去支付，修改订单，入住反馈和 再次预订等
-(UIButton *)customizableButtonWithTitle:(NSString *)title
                                  targer:(id)target
                                  action:(SEL)action
                                   frame:(CGRect)frame{
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tmpBtn.frame = frame;
    [tmpBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    //设置againPayBtn的背景图
    [tmpBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [tmpBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    //设置字体颜色
    [tmpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tmpBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [tmpBtn setTitle:title forState:UIControlStateNormal];
    
    return tmpBtn;
}

//构建_detailTable的顶部UI
-(void)buildTableHeaderViewUI{
    _detailTable.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)] autorelease];
    _detailTable.tableHeaderView.clipsToBounds = YES;
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"订单状态：";
    [_detailTable.tableHeaderView addSubview:titleLabel];
    [titleLabel release];
    
    //内容
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 220, 30)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = RGBACOLOR(254, 75, 32, 1);
    contentLabel.font = [UIFont systemFontOfSize:14];
    [_detailTable.tableHeaderView addSubview:contentLabel];
    [contentLabel release];
    
    //订单状态
    NSString *orderStatus = [_currentOrder safeObjectForKey:@"ClientStatusDesc"];      //订单状态
    orderStatus = STRINGHASVALUE(orderStatus)?orderStatus:@"暂无状态";
    contentLabel.text = orderStatus;

    //能否继续支付     add againPayBtn
    if (([[_currentOrder safeObjectForKey:@"IsCanContinuePay"] boolValue] == YES)){
        BOOL vouch  = ([[_currentOrder safeObjectForKey:@"VouchMoney"] floatValue] > 0);
        NSString *againPayTitle = vouch?@"去担保":@"去支付";
        
        UIButton *againPayBtn = [self customizableButtonWithTitle:againPayTitle targer:self action:@selector(clickAgainPayBtn:) frame:CGRectMake(250, 5, 60, 25)];
        [_detailTable.tableHeaderView addSubview:againPayBtn];
    }
    
    //add Btn
    _lookOrderFlowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookOrderFlowBtn.frame = CGRectMake(160, 30, 150, 30);
    _lookOrderFlowBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_lookOrderFlowBtn setTitle:@"查看订单处理日志" forState:UIControlStateNormal];
    [_lookOrderFlowBtn setTitleColor:RGBACOLOR(46, 126, 234, 1) forState:UIControlStateNormal];
    [_lookOrderFlowBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [_lookOrderFlowBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 145, 11, 0)];
    [_lookOrderFlowBtn setImage:[UIImage noCacheImageNamed:@"ico_rightarrow.png"] forState:UIControlStateNormal];
    [_lookOrderFlowBtn addTarget:self action:@selector(clickLookOrderFlowBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_detailTable.tableHeaderView addSubview:_lookOrderFlowBtn];
    
    if(ARRAYHASVALUE(_currentOrderFlows)){
        [self buildOrderFlowWithOrderFlows:_currentOrderFlows];
    }
//    //添加订单处理进度
//    NSArray *array = [NSArray arrayWithObjects:@"提交订单",@"酒店担保",@"酒店确认", nil];
//    [self buildOrderFlowStateViewWithStateNames:array currentState:@"酒店担保"];
}


-(void)buildOrderFlowWithOrderFlows:(NSArray *)orderFlows{
    _lookOrderFlowBtn.frame = CGRectMake(160, 70, 150, 30);     //挪挪位置

    CGRect frame = CGRectMake(10, 33 , 300, 40);
    UIView *orderFlowStateView =  [[UIView alloc] initWithFrame:frame];
    orderFlowStateView.clipsToBounds = YES;
    orderFlowStateView.backgroundColor = [UIColor clearColor];
    
    //标题宽度固定为60、如若更换宽度，请更改对应的值
    int width = 60;
    int space = (frame.size.width-width)/(orderFlows.count-1);
    BOOL isBlueColor = YES;     //来标记已经执行过的流程
    for(int i=0; i<orderFlows.count;i++){
        NSDictionary *orderFlow = [orderFlows objectAtIndex:i];
        NSString *flowDesc = [orderFlow objectForKey:@"FlowDesc"];
        BOOL isCurrentFlow = [[orderFlow objectForKey:@"IsCurrentFlow"] boolValue];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, width, 20)];
        [titleLabel setCenter:CGPointMake(width/2+i*space, 25)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = RGBACOLOR(136, 136, 136, 1);
        titleLabel.text = flowDesc;
        titleLabel.numberOfLines = 0;
        [orderFlowStateView addSubview:titleLabel];
        [titleLabel release];
        
        CGSize flowDescSize = [flowDesc sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(width, INT_MAX)];
        int height = flowDescSize.height > 20?flowDescSize.height+6:20;
        titleLabel.frame = CGRectMake(0, 15, width, height);
        [titleLabel setCenter:CGPointMake(width/2+i*space, 25)];

        //
        UIImageView *icoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        icoImgView.image = [UIImage noCacheImageNamed:@"orderFlowGray_ico.png"];
        [orderFlowStateView addSubview:icoImgView];
        [icoImgView setCenter:CGPointMake(titleLabel.frame.origin.x+width/2, 8)];
        [icoImgView release];
        
        if(isBlueColor){
            icoImgView.image = [UIImage noCacheImageNamed:@"orderFlowBlue_ico.png"];
        }
        if(isCurrentFlow){
            isBlueColor = NO;
        }
    }
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 8, frame.size.width-60, SCREEN_SCALE)];
    lineImgView.backgroundColor = [UIColor grayColor];
    [orderFlowStateView addSubview:lineImgView];
    [orderFlowStateView sendSubviewToBack:lineImgView];
    [lineImgView release];

    UIView *tableHeaderView = _detailTable.tableHeaderView;
    tableHeaderView.frame =   CGRectMake(0, 0, SCREEN_WIDTH, 100);
    _detailTable.tableHeaderView = tableHeaderView;

    [_detailTable.tableHeaderView addSubview:orderFlowStateView];
    [orderFlowStateView release];
}

 //构建底部UI
-(void)buildTableFooterViewUI{
    _detailTable.tableFooterView  = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)] autorelease];
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    int x = 20;
    int y = 20;
    //修改订单按钮
    if([[_currentOrder safeObjectForKey:@"IsCanBeEdited"] boolValue] && !appDelegate.isNonmemberFlow){
        //非会员状态不能显示修改订单
        UIButton *modifyOrderBtn = [self customizableButtonWithTitle:@"修改订单" targer:self action:@selector(clickModifyOrderBtn:) frame:CGRectMake(x, y, 80, 30)];
        [_detailTable.tableFooterView addSubview:modifyOrderBtn];
        
        x+=100;
    }
    
    //核查取消订单按钮
    if ([[_currentOrder safeObjectForKey:@"Cancelable"] boolValue] && [[_currentOrder safeObjectForKey:@"CancelStatus"] intValue]==2 && !appDelegate.isNonmemberFlow) {
        //CancelStatus :1 表示 不可取消， 2表示 在线取消， 3表示 可电话取消
        UIButton *cancelOrderBtn = [self customizableButtonWithTitle:@"取消订单" targer:self action:@selector(clickCancelOrderBtn:) frame:CGRectMake(x, y, 80, 30)];
        [_detailTable.tableFooterView addSubview:cancelOrderBtn];
        
        x+=100;
    }
    
    //再次预订
    UIButton *againBookingBtn = [self customizableButtonWithTitle:@"再次预订" targer:self action:@selector(clickAgainBookingBtn:) frame:CGRectMake(x, y, 80, 30)];
    [_detailTable.tableFooterView addSubview:againBookingBtn];
    x+=100;
    
    if(x>220){
        //判断是否需要换行显示
        x =20;
        y+=50;
    }
    
    // 天气预报是否显示
    NSString *arriveDateString = [_currentOrder safeObjectForKey:@"ArriveDate"];
    NSDate *arriveDate = [TimeUtils parseJsonDate:arriveDateString];
    
    NSDate *createOrderDate = [TimeUtils parseJsonDate:[_currentOrder safeObjectForKey:@"CreateTime"]];

    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    int timeOffset = [nowTimeZone secondsFromGMTForDate:arriveDate];
    NSDate *newArriveDate = [arriveDate dateByAddingTimeInterval:timeOffset];
    
    NSDate *nowDate = [NSDate date];
    int nowTimeOffset = [nowTimeZone secondsFromGMTForDate:nowDate];
    NSDate *newNowDate = [[NSDate date] dateByAddingTimeInterval:nowTimeOffset];
    
    int createTimeOffset = [nowTimeZone secondsFromGMTForDate:nowDate];
    NSDate *newCreateOrderDate = [createOrderDate dateByAddingTimeInterval:createTimeOffset];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:newNowDate toDate:newArriveDate options:0];
    NSDateComponents *otherComps = [gregorian components:unitFlags fromDate:newCreateOrderDate toDate:newArriveDate options:0];
    int days = [comps day];
    int otherDays = [otherComps day];
    [gregorian release];
    
//    NSDate *tempDate = [NSDate dateFromString:destDateString withFormat:@"yyyyMMdd"];
//    NSTimeInterval distance = -[tempDate timeIntervalSinceNow];
//    if (distance < 0) {
//        distance = -distance;
//    }
//    NSInteger distanceDay = distance / 86400;

    if (days >= 0 && days <= 2) {
        UIButton *forecastBtn = [self customizableButtonWithTitle:@"查看天气" targer:self action:@selector(clickForecastBtn:) frame:CGRectMake(x, y, 80, 30)];
        [_detailTable.tableFooterView addSubview:forecastBtn];
        x+=100;
    }
    else if (days == -1 && otherDays == -1) {
        UIButton *forecastBtn = [self customizableButtonWithTitle:@"查看天气" targer:self action:@selector(clickForecastBtn:) frame:CGRectMake(x, y, 80, 30)];
        [_detailTable.tableFooterView addSubview:forecastBtn];
        x+=100;
    }
    
    if(x>220){
        //判断是否需要换行显示
        x =20;
        y+=50;
    }
    
    //入住反馈
    _feedbackBtn = [self customizableButtonWithTitle:@"入住反馈" targer:self action:@selector(clickFeedbackBtn:) frame:CGRectMake(x, y, 80, 30)];
    [_detailTable.tableFooterView addSubview:_feedbackBtn];
    _feedbackBtn.hidden = YES;  //默认隐藏
}

//刷新入住反馈按钮状态
-(void)refreshFeedBackStateWithResult:(NSDictionary *)result{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    if(!appDelegate.isNonmemberFlow){
        NSArray *feedbackList = [result safeObjectForKey:@"FeedbackStatus"];
        NSDictionary *feedbackStatusInfo = [feedbackList objectAtIndex:0];
        int feedbackStatus = [[feedbackStatusInfo objectForKey:@"FeedbackStatus"] intValue];
        NSString *statusDesp = [feedbackStatusInfo objectForKey:@"statusDesc"];
        
        if(STRINGHASVALUE(statusDesp)){
            [_feedbackBtn setTitle:statusDesp forState:UIControlStateNormal];
        }
        
        if(feedbackStatus==0){
            _feedbackBtn.hidden = NO;       //展示出来
        }
        //feedbackStatus 值0为可反馈，1为不可反馈 ,2为反馈处理中
        if(feedbackStatus==2){
            //处理反馈中时，按钮置灰
            [_feedbackBtn setImage:nil forState:UIControlStateNormal];
            [_feedbackBtn setImage:nil forState:UIControlStateHighlighted];
            [_feedbackBtn setBackgroundColor:RGBACOLOR(204, 205, 205, 1)];
        }
    }
}

//查看订单处理日志
-(void)clickLookOrderFlowBtn:(id)sender{
    HotelOrderFlowViewController *orderFLowViewController = [[HotelOrderFlowViewController  alloc] initWithOrder:_currentOrder];
    [self.navigationController pushViewController:orderFLowViewController animated:YES];
    [orderFLowViewController release];
}

//点击取消订单按钮
-(void)clickCancelOrderBtn:(id)sender{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	if (appDelegate.isNonmemberFlow) {
		// 非会员流程只能打电话取消
		[self calltel400];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您确定要取消该订单?"
														message:nil
													   delegate:self
											  cancelButtonTitle:@"否"
											  otherButtonTitles:@"是",nil];
        alert.tag = CancelOrder_AlertTag;
		[alert show];
		[alert release];
	}
}

-(void)clickModifyOrderBtn:(id)sender{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    if(UMENG){
        [MobClick event:Event_HotelOrderModify];
    }
    // 获取修改订单的h5链接
    TokenReq *token = [TokenReq shared];
    if(STRINGHASVALUE([token accessToken])){
        //如果有Token，则直接请求H5链接
        [_orderDetailRequest startRequestWithEditOrder];
    }else{
        //先获取Token
        _tokenRequestType = MODIFTYORDER;
        [token requestTokenWithLoading:YES];
    }
}

//再次预订
-(void)clickAgainBookingBtn:(id)sender{
    //再次预订
    [_orderDetailRequest startRequestWithBookingAgain:_currentOrder];
    UMENG_EVENT(UEvent_UserCenter_InnerOrder_Rebook)
}

- (void)clickForecastBtn:(id)sender
{
    // 请求天气预报
    if (!_forecastVC) {
        NSString *city = [_currentOrder safeObjectForKey:@"CityName"];
        NSString *dateString = [_currentOrder safeObjectForKey:@"ArriveDate"];
        NSDate *arriveDate = [TimeUtils parseJsonDate:dateString];
        
        NSDate *createOrderDate = [TimeUtils parseJsonDate:[_currentOrder safeObjectForKey:@"CreateTime"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
        NSString *arriveDateString = [dateFormatter stringFromDate:arriveDate];
        NSString *createOrderDateString = [dateFormatter stringFromDate:createOrderDate];
        [dateFormatter release];

        NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
        int timeOffset = [nowTimeZone secondsFromGMTForDate:arriveDate];
        NSDate *newArriveDate = [arriveDate dateByAddingTimeInterval:timeOffset];
        
        NSDate *nowDate = [NSDate date];
        int nowTimeOffset = [nowTimeZone secondsFromGMTForDate:nowDate];
        NSDate *newNowDate = [[NSDate date] dateByAddingTimeInterval:nowTimeOffset];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSDayCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:newNowDate toDate:newArriveDate options:0];
        
        int days = [comps day];

        [gregorian release];
        
        if (days == -1) {
            arriveDateString = createOrderDateString;
        }
        
        
        UIView *maskView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, MAINCONTENTHEIGHT)] autorelease];
        maskView.tag = kForecastMaskViewTag;
        maskView.backgroundColor = [UIColor clearColor];
        maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        maskView.hidden = YES;
        // 单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        [maskView addGestureRecognizer:singleTap];
        [singleTap release];
        [self.view addSubview:maskView];
        
        UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
        UIView *topMaskView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, 64.0f)] autorelease];
        topMaskView.tag = kForecastTopMaskViewTag;
        topMaskView.backgroundColor = [UIColor blackColor];
        topMaskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        topMaskView.hidden = YES;
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        [topMaskView addGestureRecognizer:singleTap];
        [singleTap release];
        [window addSubview:topMaskView];
        
        ForecastViewController *tempForecastVC = [[ForecastViewController alloc] init];
        tempForecastVC.delegate = self;
        tempForecastVC.view.frame = CGRectMake(kForecastHorizontalMargin, (MAINCONTENTHEIGHT - kForecastPopUpViewHeight) / 2, SCREEN_WIDTH - 2 * kForecastHorizontalMargin, kForecastPopUpViewHeight);
        tempForecastVC.view.hidden = YES;
        self.forecastVC = tempForecastVC;
        [tempForecastVC release];
        [maskView addSubview:_forecastVC.view];
        
        // 关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.exclusiveTouch = YES;
        [closeBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
        [maskView addSubview:closeBtn];
        [closeBtn addTarget:self action:@selector(closeForecast) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.frame = CGRectMake(SCREEN_WIDTH - kForecastHorizontalMargin - 12, (MAINCONTENTHEIGHT - kForecastPopUpViewHeight) / 2 - 12, 24, 24);
        
        [_forecastVC startRequestWithCity:city withDate:arriveDateString];
    }
    else {
        if (ARRAYHASVALUE([[ForecastInformation shareInstance] list]) && [[[ForecastInformation shareInstance] list] count] > 0) {
            [_forecastVC buildupForcastPopView];
            __block UIView *maskView = [self.view viewWithTag:kForecastMaskViewTag];
            UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
            __block UIView *topMaskView = (UIView *)[window viewWithTag:kForecastTopMaskViewTag];
            __block UIView *forecastView = _forecastVC.view;
            if (maskView) {
                [UIView animateWithDuration:0.3 animations:^{
                    maskView.hidden = NO;
                    forecastView.hidden = NO;
                    topMaskView.hidden = NO;
                } completion:^(BOOL finished) {
                }];
            }
        }
        else {
            [Utils alert:@"抱歉, 未获取到相关天气信息"];
        }
    }
}

//再次支付
-(void)clickAgainPayBtn:(id)sender{
    BOOL vouch  = ([[_currentOrder safeObjectForKey:@"VouchMoney"] floatValue] > 0);
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"选择支付方式"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:(vouch ? @"微信担保" : @"微信支付"),(vouch ? @"支付宝客户端担保" : @"支付宝客户端支付"),(vouch ? @"支付宝网页担保" : @"支付宝网页支付"),nil];
	
	menu.delegate = self;
    menu.tag = AgainPay_ActionSheetTag;
	menu.actionSheetStyle=UIBarStyleBlackTranslucent;
	[menu showInView:self.view];
	[menu release];
}

//点击入住反馈
-(void)clickFeedbackBtn:(id)sender{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    if(UMENG){
        [MobClick event:Event_HotelFeedBack];
    }
    UMENG_EVENT(UEvent_UserCenter_InnerOrder_Feedback)
    // 获取入住反馈的h5链接
    TokenReq *token = [TokenReq shared];
    // 有accesstoken就使用，没有的情况重新请求新的accesstoken
    if (STRINGHASVALUE([token accessToken]))
    {
        [_orderDetailRequest startRequestWithFeedback];
    }
    else
    {
        _tokenRequestType = FEEDBACK;
        [token requestTokenWithLoading:YES];
    }
}

- (void)singleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self closeForecast];
}


- (void)maskSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self closeForecast];
}

- (void)closeForecast
{
    __block UIView *maskView = [self.view viewWithTag:kForecastMaskViewTag];
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    __block UIView *topMaskView = (UIView *)[window viewWithTag:kForecastTopMaskViewTag];
    
    if (maskView) {
        [UIView animateWithDuration:0.3 animations:^{
//            maskView.alpha = 0.0;
            maskView.hidden = YES;
            topMaskView.hidden = YES;
        } completion:^(BOOL finished) {
//            [maskView removeFromSuperview];
//            maskView = nil;
        }];
    }
}

//分享的短信内容
-(NSString *) smsContent{
	NSString *date_str = [NSString stringWithFormat:@"%@至%@",[TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"ArriveDate"] formatter:@"MM月dd日"],[TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"LeaveDate"] formatter:@"MM月dd日"]];
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订一家酒店，订单号：%@，%@ ,地址：%@ 日期：%@。",[_currentOrder safeObjectForKey:@"OrderNo"],[_currentOrder safeObjectForKey:@"HotelName"],
						 [_currentOrder safeObjectForKey:@"HotelAddress"],date_str];
	
	NSString *messageBody = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
	return messageBody;
}

//分享的邮件内容
-(NSString *) mailContent{
	NSString *date_str = [NSString stringWithFormat:@"%@至%@",[TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"ArriveDate"] formatter:@"MM月dd日"],[TimeUtils displayDateWithJsonDate:[_currentOrder safeObjectForKey:@"LeaveDate"] formatter:@"MM月dd日"]];
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订一家酒店，既便捷又超值。订单号：%@，%@ ,地址：%@ 日期：%@。",[_currentOrder safeObjectForKey:@"OrderNo"],[_currentOrder safeObjectForKey:@"HotelName"],
						 [_currentOrder safeObjectForKey:@"HotelAddress"],date_str];
	
	NSString *messageBody = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166\n订单详情见附件图片：",message];
	return messageBody;
}

//分享的微博内容
-(NSString *) weiboContent{
    NSString *currency = [_currentOrder safeObjectForKey:@"Currency"];  //货币符号
    NSString *currencyMark = currency;
    if ([currency isEqualToString:@"HKD"]) {
        currencyMark = @"HK$";
    }
    else if ([currency isEqualToString:@"RMB"]) {
        currencyMark = @"¥";
    }
	NSString *price_str = [NSString stringWithFormat:@"%@%.f",currencyMark,[[_currentOrder safeObjectForKey:@"SumPrice"] doubleValue]];
	
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订一家酒店，既便捷又超值。%@ ,地址：%@，艺龙价仅售%@。",[_currentOrder safeObjectForKey:@"HotelName"],
						 [_currentOrder safeObjectForKey:@"HotelAddress"],price_str];
	NSString *content = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
	return content;
}

//屏幕截图
-(UIImage *)screenshotOnCurrentView
{
    CGRect originFrame = _detailTable.frame;        //原大小
    //此处重新设置_detailTable,是为了刷新table得到所有数据
    CGRect tableFrame = _detailTable.frame;
    tableFrame.size.height = _detailTable.contentSize.height;
    _detailTable.frame = tableFrame;
    
    CGSize size = _detailTable.contentSize;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

	CGContextRef ctx = UIGraphicsGetCurrentContext();
    _detailTable.layer.masksToBounds=NO;        //防止截图被截掉
	[_detailTable.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    _detailTable.layer.masksToBounds = YES;
    _detailTable.layer.frame = originFrame;     //重置回原来大小
    return newImage;
}

//分享订单
-(void)shareOrderInfo{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
	shareTools.mailImage = [self screenshotOnCurrentView];
    NSDictionary *hotel = _currentOrder;
    NSString *hotelId = [hotel safeObjectForKey:@"HotelId"];
    shareTools.hotelId = hotelId;
	
	shareTools.weiBoContent = [self weiboContent];
	shareTools.msgContent = [self smsContent];
	shareTools.mailTitle = @"使用艺龙旅行客户端预订酒店成功！";
	shareTools.mailContent = [self mailContent];
	
	[shareTools  showItems];
    UMENG_EVENT(UEvent_UserCenter_InnerOrder_Share)
}

//保存到照片库
-(void)saveOrderToPhotosAlbum{
    self.view.userInteractionEnabled = NO;
    //获取屏幕截图
    UIImage *captureImg = [self screenshotOnCurrentView];
    
    //将截图装入ImgView进行动画
    UIImageView *animationImgView = [[UIImageView alloc] initWithImage:captureImg];
    animationImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-64);
    [self.view addSubview:animationImgView];
    [animationImgView release];
    [self performSelector:@selector(startAnimationsWithImgView:) withObject:animationImgView afterDelay:0.3];
    
    //保存图片到相册
    UIImageWriteToSavedPhotosAlbum(captureImg,
                                   self,
                                   @selector(imageSavedToPhotosAlbum:
                                             didFinishSavingWithError:
                                             contextInfo:),
                                   nil);
}

//保存订单到图片库时进行动画
-(void)startAnimationsWithImgView:(UIImageView *)imgView{
    [imgView.layer removeAnimationForKey:@"marioJump"];     //先移除这个动画序列
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = .5;
    scaleAnimation.toValue = [NSNumber numberWithFloat:.1];
    
    CABasicAnimation *slideDownx = [CABasicAnimation animationWithKeyPath:@"position.x"];
    slideDownx.toValue = [NSNumber numberWithFloat: 280];
    slideDownx.duration = .5f;
    slideDownx.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *slideDowny = [CABasicAnimation animationWithKeyPath:@"position.y"];
    slideDowny.toValue = [NSNumber numberWithFloat: SCREEN_HEIGHT-44];
    slideDowny.duration = .5f;
    slideDowny.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:scaleAnimation, slideDownx,slideDowny, nil];
    group.duration = .5;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.autoreverses = NO;
//    group.delegate = self;
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeForwards;
    
    [imgView.layer addAnimation:group forKey:@"marioJump"];     //添加动画序列
    [imgView performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5];        //隐藏
    [imgView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];     //动画执行0.5s，延迟0.5s将imgView移除视图
}

#pragma mark - NSNotification Methods
//当accessToken获取到后，被通知执行此方法
-(void)notification_GetToken{
    if(_tokenRequestType==FEEDBACK){
        //入住反馈
        [_orderDetailRequest startRequestWithFeedback];
    }else if(_tokenRequestType == MODIFTYORDER){
        //修改订单
        [_orderDetailRequest startRequestWithEditOrder];
    }
}

//检查是否可以入住反馈
-(void)notification_checkCanBeFeedback{
    [_orderDetailRequest startRequestWithCheckCanBeFeedback:_currentOrder];     //检查订单是否可以入住反馈
}

//修改订单后，被通知刷新订单
-(void)notification_modifyOrder
{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.userInteractionEnabled = NO;
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:1];
    [appDelegate.window performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:1];
    //此处无须通知Refresh，因为List中本身在修改完成后会主动刷新，只需做一个返回页的动作
}


//支付成功
-(void)notification_paySuccessByAgainPay:(NSNotification *)notification{
    //继续支付，返回列表重新刷新
    //是重新获取数据刷新还是本地设置？？
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self];   //通知订单列表页刷新订单列表
//    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.3];
    [self.navigationController popViewControllerAnimated:YES];
}

//从外部切换到本程序做支付成功判断处理
-(void)notification_paySuccessByAppActive:(NSNotification *)notification{
    if(_isJumpToSafari){
        // 监测到程序被从后台激活时，询问用户支付情况
        UIAlertView *askingAlert = [[UIAlertView alloc] initWithTitle:@"是否已完成支付宝支付"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"未完成"
                                                    otherButtonTitles:@"已支付", nil];
        askingAlert.tag = Alipay_AlertTag;
        [askingAlert show];
        [askingAlert release];
        
        _isJumpToSafari = NO;
    }
}

#pragma mark - HotelOrderDetailCellDelegate
//点击酒店电话
-(void)clickOrderDetailCell_TelPhoneBtn:(id)sender{
    if (STRINGHASVALUE([_currentOrder safeObjectForKey:@"HotelPhone"]))
    {
        NSString *hotelPhoneString = [_currentOrder safeObjectForKey:@"HotelPhone"];
        NSArray *hotelPhones = [hotelPhoneString componentsSeparatedByString:@"、"];
        UIActionSheet *menu =[[UIActionSheet alloc] initWithTitle:@"前台电话" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil,nil];
        for(NSString *hotelPhone in hotelPhones){
            [menu addButtonWithTitle:hotelPhone];
        }
        [menu addButtonWithTitle:@"取消"];
        menu.cancelButtonIndex = hotelPhones.count;
        
        menu.delegate = self;
        menu.actionSheetStyle=UIBarStyleBlackTranslucent;
        [menu showInView:self.view];
        menu.tag = TelPhone_ActionSheetTag;
        [menu release];
    }
}

//查看发票处理流程
-(void)clickOrderDetailCell_LookInvoiceFlowBtn:(id)sender{
    HotelOrderInvoiceFlowViewController *orderInvoiceFLowViewController = [[HotelOrderInvoiceFlowViewController  alloc] initWithOrder:_currentOrder];
    [self.navigationController pushViewController:orderInvoiceFLowViewController animated:YES];
    [orderInvoiceFLowViewController release];
}

//点击带我去酒店
-(void)clickOrderDetailCell_GoHotelBtn:(id)sender{
    [_orderListRequest startRequestWithGoHotel:_currentOrder];
}

#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if(index==0){
        //分享
        [self shareOrderInfo];
    }else{
        //Add Passbook 或 保存
        if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passHotelOn]) {
            [_orderDetailRequest startRequestWIthAddOrderToPassbook:_currentOrder];
            UMENG_EVENT(UEvent_UserCenter_InnerOrder_Passbook)
        }else{
            [self saveOrderToPhotosAlbum];  //保存订单到相册
        }
    }
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == CancelOrder_AlertTag){
        //取消订单确认
        if(buttonIndex==1){
            [_orderDetailRequest startRequestWithCancelOrder:_currentOrder];
        }
    }else if(alertView.tag == Alipay_AlertTag){
        //支付成功确认
        if(buttonIndex==1){
            [self notification_paySuccessByAgainPay:nil];        //支付成功
        }
    }else if(alertView.tag == PKPass_AlertTag){
        //查看Passbook
        if(buttonIndex==1){
            // 前往更新passbook
            PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:_pkPass];
            [self presentViewController:addPassVC animated:YES completion:^{}];
            [addPassVC release];
        }
    }
}

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == TelPhone_ActionSheetTag){
        
        NSString *hotelPhoneString = [_currentOrder safeObjectForKey:@"HotelPhone"];
        NSArray *hotelPhones = [hotelPhoneString componentsSeparatedByString:@"、"];
        
        if (buttonIndex < hotelPhones.count) {
            NSString *telText = [hotelPhones objectAtIndex:buttonIndex];//[_currentOrder safeObjectForKey:@"HotelPhone"];
            NSError *error;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d+-)*\\d+" options:0 error:&error];
            NSString *tel = nil;
            
            NSTextCheckingResult *firstMatch = [regex firstMatchInString:telText options:0 range:NSMakeRange(0, [telText length])];
            if (firstMatch) {
                NSRange resultRange = [firstMatch rangeAtIndex:0];
                tel = [telText substringWithRange:resultRange];
                
                if (![[UIApplication sharedApplication] newOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", tel]]]) {
                    [PublicMethods showAlertTitle:CANT_TEL_TIP Message:nil];
                }
            }
            else {
                [PublicMethods showAlertTitle:@"电话格式错误" Message:nil];
            }
        }
    }else if(actionSheet.tag == AgainPay_ActionSheetTag){
        UMENG_EVENT(UEvent_UserCenter_InnerOrder_Repay)
        if (buttonIndex == 0){
            //微信支付
            [_orderDetailRequest startAgainPayRequestByWeixin:_currentOrder];
        }else if(buttonIndex == 1){
            // 支付宝客户端支付
            [_orderDetailRequest startAgainPayRequestByAlipayClient:_currentOrder];
        }else if(buttonIndex == 2){
            // 支付宝网页支付
            [_orderDetailRequest startAgainPayRequestByAlipayWeb:_currentOrder];
        }
    }
}

#pragma mark - PKAddPassbook Delegate
-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
    if ([passLibrary containsPass:_pkPass]) {
        [PublicMethods showAlertTitle:@"添加成功！" Message:nil];
    }
}

#pragma mark - SavePhotosAblum Delegate
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message;
    NSString *title;
    if (!error){
        title = nil;
        message = NSLocalizedString(@"订单已经保存到相册", @"");
    } else {
        title = NSLocalizedString(@"保存失败", @"");
        message = [error description];
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"知道了", @"")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - HotelOrderListRequest Delegate
//带我去酒店
-(void)executeGoHotelResult:(NSDictionary *)result{
    double latitude  = [[result safeObjectForKey:@"Latitude"] doubleValue];
    double longitude = [[result safeObjectForKey:@"Longitude"] doubleValue];
    
    if (latitude != 0 || longitude != 0) {
        if (IOSVersion_6 && ![[ServiceConfig share] monkeySwitch]) {
            [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(latitude, longitude) title:[result safeObjectForKey:@"HotelName"]];
        }else{
            // 酒店有坐标时用酒店坐标导航
            [PublicMethods pushToMapWithDesLat:latitude Lon:longitude];
        }
    }
    else {
        // 酒店没有坐标时用酒店地址导航
        [PublicMethods pushToMapWithDestName:[result safeObjectForKey:ADDRESS_GROUPON]];
    }
}


#pragma mark - HotelOrderDetailRequest Delegate
//检查是否显示入住反馈
-(void)executeCheckFeedbackResult:(NSDictionary *)result{
    [self refreshFeedBackStateWithResult:result];        //刷新入住反馈UI
}

//取消订单
-(void)executeCancelOrderResult:(NSDictionary *)result{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderList" object:self];   //通知订单列表页刷新订单列表
    [Utils alert:@"已取消订单"];
    [self.navigationController popViewControllerAnimated:YES];
}

//入住反馈请求
-(void)executeFeedbackResult:(NSDictionary *)result{
    NSString *html5Link = [result objectForKey:APP_VALUE];
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[_currentOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    //            NSString *orderNO = @"67799725";
    html5Link = [[TokenReq shared] getOrderHtml5LinkFromString:html5Link OrderNumber:orderNO];
    
    Html5WebController *html5Ctr = [[Html5WebController alloc] initWithTitle:@"入住反馈" Html5Link:html5Link FromType:HOTEL_FEEDBACK];
    [self.navigationController pushViewController:html5Ctr animated:YES];
    [html5Ctr release];
}

//修改订单请求
-(void)executeEditOrderResult:(NSDictionary *)result{
    NSString *html5Link = [result objectForKey:@"AppValue"];
    html5Link = [[TokenReq shared] getOrderHtml5LinkFromString:html5Link OrderNumber:[NSString stringWithFormat:@"%@", [_currentOrder safeObjectForKey:@"OrderNo"]]];
    
    Html5WebController *html5Ctr = [[Html5WebController alloc] initWithTitle:@"修改订单" Html5Link:html5Link FromType:HOTEL_MODIFYORDER];
    [self.navigationController pushViewController:html5Ctr animated:YES];
    [html5Ctr release];
}

//执行微信再次支付结果
-(void)executeAgainPayByWeixinResult:(NSDictionary *)result{
    NSString *url = [result objectForKey:@"PaymentUrl"];
    if (!STRINGHASVALUE(url)) {
        [PublicMethods showAlertTitle:@"" Message:@"未能获取支付页面"];
        return;
    }
    PayReq *req = [[[PayReq alloc] init] autorelease];
    NSDictionary *dict = [url JSONValue];
    req.partnerId = [dict objectForKey:@"partnerId"];
    req.prepayId = [dict objectForKey:@"prepayId"];
    req.package = [dict objectForKey:@"package"];
    req.sign = [dict objectForKey:@"sign"];
    req.nonceStr = [dict objectForKey:@"nonceStr"];
    req.timeStamp = [[dict objectForKey:@"timeStamp"] longLongValue];
    [WXApi safeSendReq:req];
}

//执行支付宝客户端再次支付结果
-(void)executeAgainPayByAlipayClientResult:(NSDictionary *)result{
    if([[result safeObjectForKey:@"IsSuccessful"] boolValue]){
        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
        NSString *appScheme = @"elongIPhone";
        NSString *orderString = [result safeObjectForKey:@"PaymentUrl"];
        //获取安全支付单例并调用安全支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        if (ret == kSPErrorSignError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签名错误" message:@"联系服务商" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单已被取消，不能再支付！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

 //执行支付宝网页再次支付结果
-(void)executeAgainPayByAlipayWebResult:(NSDictionary *)result{
    NSURL *url = [NSURL URLWithString:[result objectForKey:@"PaymentUrl"]];

    if ([[UIApplication sharedApplication] canOpenURL:url]){
        // 能用safari打开优先用safari打开
        [[UIApplication sharedApplication] newOpenURL:url];
        _isJumpToSafari = YES;
    }
    else{
        AlipayViewController *alipayVC = [[AlipayViewController alloc] init];
        alipayVC.requestUrl = url;
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
    }
}

 //执行再次预订结果
-(void)executeBookingAgainResult:(NSDictionary *)result{
    if ([[result safeObjectForKey:HOTELID_REQ] isEqual:[NSNull null]]) {
        [PublicMethods showAlertTitle:@"酒店信息已过期" Message:nil];
        return;
    }
    HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
    promotionInfoRequest.orderEntrance = OrderEntranceRebooking;
    promotionInfoRequest.hotelId = [result safeObjectForKey:@"HotelId"];
    promotionInfoRequest.hotelName = [result safeObjectForKey:@"HotelName"];
    promotionInfoRequest.cityName = [result safeObjectForKey:@"CityName"];
    promotionInfoRequest.star = [result safeObjectForKey:@"NewStarCode"];
    
    //传递详情数据并进入酒店详情页面
    [[HotelDetailController hoteldetail] addEntriesFromDictionary:result];
    [[HotelDetailController hoteldetail] removeRepeatingImage];
    
    HotelDetailController *hoteldetail = [[HotelDetailController alloc] init:_string(@"s_detail") style:_NavNormalBtnStyle_];
    [self.navigationController pushViewController:hoteldetail animated:YES];
    [hoteldetail release];
}

//执行呢增加passbook结果
-(void)executeAddPassbookResultData:(NSData *)resultData{
    NSError *error = nil;
    if(_pkPass){
        [_pkPass release];
        _pkPass = nil;
    }
    _pkPass = [[PKPass alloc] initWithData:resultData error:&error];
    PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
    
    if ([passLibrary containsPass:_pkPass]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passbook已存在该酒店订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alert.tag = PKPass_AlertTag;
        [alert show];
        [alert release];
    }else{
        PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:_pkPass];
        if (addPassVC) {
            addPassVC.delegate = self;
            [self presentViewController:addPassVC animated:YES completion:^{}];
            [addPassVC release];
        }
        else {
            [PublicMethods showAlertTitle:@"非常抱歉，该订单无法生成Passbook" Message:nil];
        }
    }
}

-(void)executeGetOrderFlowState:(NSDictionary *)result{
    NSArray *orderFlowsArray = [result objectForKey:@"OrderFlows"];
    if(ARRAYHASVALUE(orderFlowsArray)){
        NSDictionary *orderFlow = [orderFlowsArray objectAtIndex:0];
        NSArray *orderVisualFlows = [orderFlow objectForKey:@"OrderFlows"];
        
        if(ARRAYHASVALUE(orderVisualFlows)){
            [self buildOrderFlowWithOrderFlows:orderVisualFlows];
        }
    }
}

#pragma mark - ForecastDelegate
- (void)forecastViewShouldPopUp
{
    __block UIView *maskView = [self.view viewWithTag:kForecastMaskViewTag];
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    __block UIView *topMaskView = (UIView *)[window viewWithTag:kForecastTopMaskViewTag];
    __block UIView *forecastView = _forecastVC.view;
    if (maskView) {
        [UIView animateWithDuration:0.3 animations:^{
            maskView.hidden = NO;
            forecastView.hidden = NO;
            topMaskView.hidden = NO;
        } completion:^(BOOL finished) {
        }];
    }
}

@end
