    //
//  TrainOrderDetailViewController.m
//  ElongClient
//
//  Created by chenggong on 13-11-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainOrderDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "TrainOrderDetailTicketView.h"
#import "HttpUtil.h"
#import "TrainReq.h"
#import "TrainTicketRefundView.h"
#import "PublicMethods.h"
#import "StringEncryption.h"
#import "AccountManager.h"
#import "base64.h"
#import "ShareTools.h"
#import "AlipayViewController.h"
#import "ServiceConfig.h"
#import "Mytrain_submitOrder.h"
#import "TrainOrderTicketRuleVC.h"
#import "PublicMethods.h"

#define kScrollViewFrameWidth 304.0f
#define kTicketViewHeight     100
#define kRefundTicketTag        1000
#define kRefundViewTag          1024
#define kOrderKey               @"order"
#define kOrderNumberDes         @"orderId"
#define kArrivalDateDes         @"arriveDate"
#define kDepartureDateDes       @"departDate"
#define kArrivalTimeDes         @"arriveTime"
#define kDepartureTimeDes       @"departTime"
#define kOrderCreatedDateDes    @"createDate"
#define kOrderStateDes          @"orderStatusName"
#define kOrderStateCodeDes      @"orderStatusCode"
#define kTicketKey              @"tickets"
#define kCheckCodeStream        @"checkCodeStream"
#define kCheckCode              @"checkCode"
#define kTrainNo                @"trainNo"
#define kTotalPrice             @"totalPrice"
#define kTicketState            @"status"
#define kTicketSeatNo           @"seatNo"
#define kTicketSeatType         @"seatType"
#define kTicketCertNo           @"certNo"
#define kTicketCertType         @"certType"
#define kTicketMobileNo         @"mobileNo"
#define kTicketPassengerName    @"name"
#define kTicketBalance          @"balance"
#define kOrderCancelable        @"cancelable"
#define kOrderFromStation       @"fromStation"
#define kOrderToStation         @"toStation"
#define kOrderDuration          @"duration"
#define kOrderCreateDate        @"creatDate"
#define kOrderRepayAddress      @"repayAddress"
#define kOrderTradeNumber       @"tradeNo"
#define kOrderNumber12306       @"webOrderId"

#define kNetStateGetOrderDetail         10000
#define kNetStateGetVerificationCode    10001
#define kNetStateOrderCancel            10002
#define kNetStateRefundInfo             10003
#define kNetStateRefundMoney            10004
#define kNetStateGetPayAddress          10005
#define kNetStateGetPayState            10006
#define PAYTYPE_ALIPAY                  5
#define PAYTYPE_WAPALIPAY               2
#define kShareViewTag                   10240

#define kAlertViewPayStateTag           1024
#define kAlertViewCancelOrderTag        (kAlertViewPayStateTag + 1)

@interface TrainOrderDetailViewController ()

@property (nonatomic, retain) NSDictionary *currentLocalTicket;     // 当前存在本地的车票信息
@property (nonatomic, retain) HttpUtil *httpUtil;
@end

@implementation TrainOrderDetailViewController
@synthesize topView;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_httpUtil cancel];
    SFRelease(_httpUtil);
    
    if (_getPayStateUtil)
    {
        [_getPayStateUtil cancel];
        SFRelease(_getPayStateUtil);
    }
    
    self.orderNumber = nil;
    self.orderState = nil;
    self.orderTotalAmount = nil;
    self.trainNumber = nil;
    self.date = nil;
    self.orderCreateDate = nil;
    self.departureTime = nil;
    self.arrivalTime = nil;
    self.departureStation = nil;
    self.arrivalStation = nil;
    self.ticketInfoArray = nil;
    self.stationView = nil;
    self.ticketArray = nil;
    self.alipayButton = nil;
    self.ticketInfoArray = nil;
    self.orders = nil;
    self.ticketRefundView = nil;
    self.ticketRefundCheckView = nil;
    self.checkCodeStream = nil;
    self.ticketKeys = nil;
    self.balanceNotice = nil;
    self.duration = nil;
    self.alipayAddress = nil;
    self.orderStatusCode = nil;
    self.currentLocalTicket = nil;
    
    [topView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil orders:(NSDictionary *)dictionary
{
    self.orders = dictionary;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStateToPaySuccess) name:NOTI_ALIPAY_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
    
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil	{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        UIView *titleView = [[UIView alloc] init];
		titleView.userInteractionEnabled = YES;
        jumpToSafari = NO;
		int offX = 0;
        NSString *imgPath = @"";
        NSString *titleStr = @"订单详情";
		if (STRINGHASVALUE(imgPath)) {
			UIImage *topImg = [UIImage noCacheImageNamed:imgPath];
			float imgWidth  = topImg.size.width;
			float imgHeight = topImg.size.height;
			
			UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (44 - imgHeight)/2, imgWidth, imgHeight)];
			imgView.image = topImg;
			[titleView addSubview:imgView];
			[imgView release];
			
			offX = imgWidth;
		}
		
		CGSize size = [titleStr sizeWithFont:FONT_B18];
		if (size.width >= 200) {
			size.width = 195;
		}
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 3, 13, size.width, 18)];
		label.tag = 101;
		label.backgroundColor	= [UIColor clearColor];
		label.font				= FONT_B18;
		label.textColor			= [UIColor blackColor];
		label.text				= titleStr;
		label.textAlignment		= UITextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumFontSize = 14.0f;
		
		titleView.frame = CGRectMake(0, 0, size.width + offX + 5, 44);
		[titleView addSubview:label];
        
        
		self.navigationItem.titleView = titleView;
        self.navigationItem.titleView.userInteractionEnabled = YES;
		
		[label		release];
		[titleView	release];
        
        [self setShowBackBtn:YES];
        
        self.ticketArray = [NSMutableArray arrayWithCapacity:0];
        self.ticketKeys = [NSMutableDictionary dictionaryWithCapacity:0];
        
    }
    return self;
}

#pragma mark - Private method.
- (void)back
{
    if (STRINGHASVALUE(_orderState.text) && STRINGHASVALUE(_orderStatusCode)) {
        NSDictionary *orderInfo = [NSDictionary dictionaryWithObjectsAndKeys:_orderState.text, @"orderStatusName", _orderStatusCode, @"orderStatusCode", nil];
        if (_delegate && [_delegate respondsToSelector:@selector(orderDetailReturn:)]) {
            [_delegate orderDetailReturn:orderInfo];
        }
    }
    
    [super back];
}


-(NSString *)changeFloat:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    int i = length - 1;
    for(; i >= 0; i--)
    {
        if(floatChars[i] == '0') {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i + 1];
    }
    return returnString;
}

- (void)addTicketViews:(NSArray *)tickets
{
    NSUInteger index = 0;
    NSString *seatType = @"";
    NSString *ticketPrice = nil;

    
    for(int i=0;i<_ticketArray.count;i++){
        TrainOrderDetailTicketView *ticketView = (TrainOrderDetailTicketView *)[_ticketArray objectAtIndex:i];
        [ticketView setHidden:YES];
        [ticketView removeFromSuperview];
    }
    [_ticketArray removeAllObjects];
    
    for (; index < [tickets count]; index++) {
        TrainOrderDetailTicketView *ticketView = (TrainOrderDetailTicketView *)[_stationView viewWithTag:kRefundViewTag + index];
        if(ticketView){
            [ticketView setHidden:YES];
            [ticketView removeFromSuperview];
        }
        ticketView = [[TrainOrderDetailTicketView alloc] initWithFrame:CGRectMake(0.0f, 115+index*kTicketViewHeight, SCREEN_WIDTH, kTicketViewHeight)];
        ticketView.tag = kRefundViewTag + index;
        ticketView.autoresizingMask = UIViewAutoresizingNone;
        NSDictionary *ticketsDic = [tickets objectAtIndex:index];
        if (ticketsDic == nil && [ticketsDic count] == 0) {
            return;
        }
        
        NSDictionary *passengerDic = [ticketsDic safeObjectForKey:@"passenger"];
        NSDictionary *seatDic = [ticketsDic safeObjectForKey:k_seat];
        
        NSString *refundable = [ticketsDic safeObjectForKey:@"refundable"];
        
        NSString *ticketKey = [ticketsDic safeObjectForKey:@"key"];
        _seatNumber.text = [seatDic safeObjectForKey:kTicketSeatType];
        
        if (STRINGHASVALUE(ticketKey)) {
            [_ticketKeys setValue:ticketKey forKey:[NSString stringWithFormat:@"%d", index]];
        }
        else {
            [_ticketKeys setValue:@"" forKey:[NSString stringWithFormat:@"%d", index]];
        }
        
        // TODO: Ticket info fill in.
        ticketView.ticketState.text = @"";
        NSString *tmpTicketState = [ticketsDic objectForKey:kTicketState];
        ticketView.ticketState.text = tmpTicketState;
        if([@"出票成功" isEqualToString:tmpTicketState] || [@"订票成功" isEqualToString:tmpTicketState]){
            ticketView.ticketState.textColor = RGBACOLOR(20, 157, 52, 1);
            ticketView.trainSeat.textColor = RGBACOLOR(20, 157, 51, 1);
        }
        
        NSString *seatNumber = nil;     // 座位号
        NSString *passengerName = nil;  // 乘客姓名
        if ([[AccountManager instanse] isLogin])
        {
            seatType = [seatDic objectForKey:kTicketSeatType];
            passengerName = [passengerDic safeObjectForKey:kTicketPassengerName];
            if (!STRINGHASVALUE(passengerName)) {
                passengerName = @"";
            }
        }
        else
        {
            seatType = [[_currentLocalTicket objectForKey:k_seat] objectForKey:k_name];
            Passenger *passenger = [[_currentLocalTicket objectForKey:k_passengers] objectAtIndex:index];
            if (passenger)
            {
                passengerName = passenger.name;
            }
        }
        
        ticketPrice = [ticketsDic safeObjectForKey:@"ticketPrice"];
        
        if ([seatDic objectForKey:kTicketSeatNo])
        {
            seatNumber = [seatDic objectForKey:kTicketSeatNo];
        }
        else
        {
            seatNumber = @"";
        }
        
        ticketView.trainSeat.text = seatNumber;     //座位号显示
        
        NSString *certType = [passengerDic safeObjectForKey:kTicketCertType];
        if (STRINGHASVALUE(passengerName)) {
            ticketView.passengerName.text = [NSString stringWithFormat:@"%@", passengerName];
        }
        else {
            ticketView.passengerName.text = [NSString stringWithFormat:@"%@", [passengerDic objectForKey:kTicketCertType]];
        }
        

        NSString *certNo = [passengerDic safeObjectForKey:kTicketCertNo];
        if (!STRINGHASVALUE(certNo)) {
            certNo = @"";
        }
        if ([certType rangeOfString:@"身份证"].location != NSNotFound) {
            certNo = [certNo stringByReplacingCharactersInRange:NSMakeRange(certNo.length - 4, 4) withString:@"****"];
        }
        ticketView.certificate.text = [NSString stringWithFormat:@"%@ / %@",certType,certNo]
        ;
        ticketView.requestRefundButton.tag = kRefundTicketTag + index;
        ticketView.requestRefundButton.hidden = ![refundable boolValue];
        [ticketView.requestRefundButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
        
        [_stationView addSubview:ticketView];
        [_ticketArray addObject:ticketView];
        [ticketView release];
        
        if ([[passengerDic safeObjectForKey:@"passengerType"] isEqualToString:@"1"]) {
            seatType = [NSString stringWithFormat:@"%@成人票", seatType];
        }
        else if ([[passengerDic safeObjectForKey:@"passengerType"] isEqualToString:@"3"]) {
            seatType = [NSString stringWithFormat:@"%@学生票", seatType];
        }
    }
    
    NSString *ticketPriceText = [ticketPrice stringByReplacingOccurrencesOfString:@".0"withString:@""];
    
    CGRect howmuchRect = _howmuch.frame;
    howmuchRect.size.width += 100;
    _howmuch.frame = howmuchRect;
    _howmuch.text = [NSString stringWithFormat:@"%@ (￥%@ x %d )", seatType, ticketPriceText, index];
    
    CGRect stationFrame = _stationView.frame;
    stationFrame.size.height = 115+tickets.count*kTicketViewHeight;
    _stationView.frame = stationFrame;
    
     //add Line
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, stationFrame.size.height- SCREEN_SCALE, 320, SCREEN_SCALE)];
    bottomLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [_stationView addSubview:bottomLine];
    [bottomLine release];
    //ContentSize
    CGSize contentSize = CGSizeMake(_detailScrollView.frame.size.width, _stationView.frame.origin.y+115+tickets.count*kTicketViewHeight);
    _detailScrollView.contentSize = contentSize;
    _detailScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
}


- (void)notiByAppActived:(NSNotification *)noti
{
    if (jumpToSafari)
    {
        [self getPayState];
        
        jumpToSafari = NO;
    }
    
}

#pragma mark - view life cycle.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //topView
    [topView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)]];
    [topView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, topView.frame.size.height- SCREEN_SCALE, 320, SCREEN_SCALE)]];
    //取消订单
    UIBarButtonItem *cancelBarItem = [UIBarButtonItem navBarRightButtonItemWithTitle:@"取消订单" Target:self Action:@selector(cancelOrder:)];
    self.navigationItem.rightBarButtonItem = cancelBarItem;
    //BottomBar
    BaseBottomBar *bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    //分享订单
    BaseBottomBarItem *shareOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"分享订单"
                                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                                              image:@"hotelOrder_shareOrder_N.png"
                                                                    highligtedImage:@"hotelOrder_shareOrder_H.png"];
    
    
    shareOrderBarItem.autoReverse = YES;
    shareOrderBarItem.allowRepeat = YES;
    
    NSArray *items = [NSArray arrayWithObjects:shareOrderBarItem, nil];
    bottomBar.baseBottomBarItems = items;
    [self.view addSubview:bottomBar];
    [shareOrderBarItem release];
    [bottomBar release];
    //alipayButton setting
    [_alipayButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
    [_alipayButton setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
    [_alipayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _balanceNotice.hidden = YES;        //卧铺原因退款提示
    
    self.detailScrollView.frame = CGRectMake(0.0f, 0.0f, 320.0f, SCREEN_HEIGHT - 64.0f);
    
    // Send order request.
    [self getOrderDetail];
    
    
    UMENG_EVENT(UEvent_UserCenter_TrainOrder_DetailEnter)
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showRefundVerificationView
{
    if (_ticketRefundCheckView == nil) {
        TrainTicketRefundCheckView *tempView = [[TrainTicketRefundCheckView alloc] initWithViewController:self frame:CGRectMake(25.0f, 60.0f, 270.0f, 361.0f)];
        self.ticketRefundCheckView = tempView;
        [tempView release];
    }
    else {
        _ticketRefundCheckView.checkCodeView.image = [UIImage imageWithData:_checkCodeData];
    }
}

- (void)releaseTicketRefundCheckView
{
    SFRelease(_ticketRefundCheckView);
}

- (void)releaseTicketRefundView
{
    SFRelease(_ticketRefundView);
}

- (void)showRefundView:(NSDictionary *)refundInfo
{
    TrainTicketRefundView *tempView = [[TrainTicketRefundView alloc] initWithViewController:self frame:CGRectMake(25.0f, 60.0f, 270.0f, 361.0f)];
    self.ticketRefundView = tempView;
    TrainOrderDetailTicketView *ticketView = [_ticketArray objectAtIndex:_currentRefundButtonIndex];
    _ticketRefundView.noticeLabel.text = [refundInfo safeObjectForKey:@"policy"];
    _ticketRefundView.trainNumLabel.text = _trainNumber.text;
    _ticketRefundView.daStation.text = [NSString stringWithFormat:@"(%@ - %@)", _departureStation.text, _arrivalStation.text];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:_date.text];
    [df setDateFormat:@"M月d日"];
    NSString *dateStr = [df stringFromDate:date];
    _ticketRefundView.daDate.text = [NSString stringWithFormat:@"%@  %@ - %@", dateStr, _departureTime.text, _arrivalTime.text];
    
    _ticketRefundView.seatNumLabel.text = ticketView.trainSeat.text;
    _ticketRefundView.passengerDynamicLabel.text = ticketView.passengerName.text;
    _ticketRefundView.identifyCard.text = ticketView.certificate.text;
    _ticketRefundView.refundLabel.text = [NSString stringWithFormat:@"%.f", [[refundInfo safeObjectForKey:@"refundMoney"] floatValue]];
    _ticketRefundView.feeLabel.text = [NSString stringWithFormat:@"(手续费:%@)", [refundInfo safeObjectForKey:@"feeMoney"]];
    [tempView release];
    [df  release];
}

-(IBAction)goRuleAboutTakeTicket:(id)sender{
    TrainOrderTicketRuleVC *controller = [[TrainOrderTicketRuleVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


//获取支付链接地址
- (void) getAliPayAddressByType:(int)payType
{
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setValue:[_orders safeObjectForKey:@"orderId"] forKey:@"orderId"];
    [jsonDictionary setValue:@"ika0000000" forKey:@"wrapperId"];
    
    [jsonDictionary setValue:[NSNumber numberWithInt:payType] forKey:@"payChannel"];
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    NSString *cardno = [[AccountManager instanse] cardNo];
    //islogin = TRUE;
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
    
    if (STRINGHASVALUE(url)) {
        self.m_netState = kNetStateGetPayAddress;
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
}

#pragma mark -
#pragma mark Share
-(UIImage *)screenshotOnCurrentView{
    CGSize size = self.detailScrollView.contentSize;
    if (size.height<SCREEN_HEIGHT) {
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
    self.detailScrollView.layer.masksToBounds=NO;
	[self.detailScrollView.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    self.detailScrollView.layer.masksToBounds = YES;
    return newImage;
}

-(NSString *) shareContent{
	NSString *shareContentKey = [NSString stringWithFormat:@"%@,%@",_date.text,_trainNumber.text];
    NSUserDefaults *trainShareDefaults = [NSUserDefaults standardUserDefaults];
    NSString *date_str = [trainShareDefaults objectForKey:shareContentKey];
    if (!STRINGHASVALUE(date_str))
    {
        date_str = [NSString stringWithFormat:@"我用艺龙旅行客户端成功购买了火车票，订单号：%@，车次：%@，日期：%@。客服电话：%@",_orderNumber.text, _trainNumber.text, _date.text,TRAIN_SERVER_NUM_TIPS];
    }
    
    
    return date_str;
}


- (void)shareOrder{
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

    
#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if(index==0){
        [self shareOrder];
    }
}

#pragma mark - UIButton action.
- (IBAction)alipay:(id)sender
{
    if (UMENG) {
        // 火车票订单再次支付
        [MobClick event:Event_TrainOrderRepay];
    }
    
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择支付方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"支付宝客户端支付", @"支付宝网页支付", nil];
    [sheet showInView:self.view];
    [sheet release];
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


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewPayStateTag)
    {
        if (0 != buttonIndex)   // 重试
        {
            [self getPayState];
            
        }else   // 取消
        {
        }
    }
    else if (alertView.tag == kAlertViewCancelOrderTag) {
        if (0 != buttonIndex)
        {
            NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
            [jsonDictionary setValue:[_orders safeObjectForKey:@"orderId"] forKey:@"orderId"];
            [jsonDictionary setValue:@"ika0000000" forKey:@"wrapperId"];
            NSString *paramJson = [jsonDictionary JSONString];
            NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain" forService:@"cancelOrder"];
            self.m_netState = kNetStateOrderCancel;
            
            if (STRINGHASVALUE(url)) {
                self.m_netState = kNetStateOrderCancel;
                
                if (self.httpUtil) {
                    [self.httpUtil cancel];
                    self.httpUtil = nil;
                }
                self.httpUtil = [[[HttpUtil alloc] init] autorelease];
                [self.httpUtil requestWithURLString:url Content:paramJson StartLoading:YES EndLoading:YES Delegate:self];
            }
            
            if (UMENG) {
                // 火车票订单取消
                [MobClick event:Event_TrainOrderCancel];
            }
        }
    }
}


#pragma mark -
#pragma mark NetDelegate && Net related method.
- (void)changeStateToPaySuccess
{
    [self getOrderDetail];
}

- (void) alipayPaySuccess
{
    if (!jumpToSafari)
    {
        [self changeStateToPaySuccess];
    }
}

- (void)cancelOrder:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定取消订单？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = kAlertViewCancelOrderTag;
    [alert show];
    [alert release];    
}

- (void)getVerificationCode:(id)sender
{
    UIButton *refundButton = sender;
    if (refundButton != nil) {
        self.currentRefundButtonIndex = refundButton.tag - kRefundTicketTag;
    }
    
//    kNetStateGetVerificationCode
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setValue:[_orders safeObjectForKey:@"orderId"] forKey:@"orderId"];
    [jsonDictionary setValue:@"ika0000000" forKey:@"wrapperId"];
    self.checkCodeStream = nil;
    NSString *paramJson = [jsonDictionary JSONString];
    NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain" forService:@"getRefundCheckCode" andParam:paramJson];
    
    if (STRINGHASVALUE(url)) {
        if (self.httpUtil) {
            [self.httpUtil cancel];
            self.httpUtil = nil;
        }
        self.httpUtil = [[[HttpUtil alloc] init] autorelease];
        self.m_netState = kNetStateGetVerificationCode;
        if (refundButton) {
            [self.httpUtil requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
        }
        else {
            [self.httpUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
        }
//        self.m_netState = kNetStateGetVerificationCode;
//        [HttpUtil requestURL:url postContent:nil delegate:self ];
//        [HttpUtil requestW];
//        - (void)requestWithURLString:(NSString *)urlString Content:(NSString *)content StartLoading:(BOOL)autoStart EndLoading:(BOOL)autoEnd Delegate:(id)object {
    }
}

- (void)getOrderDetail
{
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setValue:[_orders safeObjectForKey:@"orderId"] forKey:@"orderId"];
    [jsonDictionary setValue:@"ika0000000" forKey:@"wrapperId"];
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    NSString *cardno = [[AccountManager instanse] cardNo];
    if (islogin)
    {
        [jsonDictionary setValue:cardno forKey:@"uid"];
        [jsonDictionary setValue:cardno forKey:@"CardNo"];
        [jsonDictionary setValue:@"1" forKey:@"isLogin"];
    }
    else
    {
        NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_TRAIN_ORDERS];
        
        if (!orderData)
        {
            // 没有订单直接提示
            [PublicMethods showAlertTitle:@"未查询到您的火车票订单" Message:@""];
            return;
        }
        else
        {
            // 有预订过火车票
			NSArray *localOrderArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:orderData]];
            
            NSMutableString *certNums = [NSMutableString string];
            
            for (NSDictionary *dic in localOrderArray)
            {
                if ([[dic objectForKey:ORDERID_GROUPON] isEqualToString:[_orders objectForKey:k_order_id]])
                {
                    self.currentLocalTicket = dic;
                    // 取出本地对应订单号纪录匹配的订单，填充数据
                    NSArray *passengers = [dic objectForKey:k_passengers];
                    if (ARRAYHASVALUE(passengers))
                    {
                        for (Passenger *passenger in passengers)
                        {
                            [certNums appendFormat:@"%@,", [StringEncryption DecryptString:passenger.certNumber]];
                        }
                    }
                }
            }
            
            [jsonDictionary setValue:[PublicMethods macaddress] forKey:k_uid];
            [jsonDictionary setValue:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
            [jsonDictionary setValue:certNums forKey:k_certNos];
        }
    }
    NSString *paramJson = [jsonDictionary JSONString];
    NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"getTrainOrderDetail" andParam:paramJson];
//    NSString *url = @"http://192.168.14.51/myelong/getTrainOrderDetail?req=jKR0zUOs7BQu1cp8XHDPGpZ89JZvOPcGF0jdH0Os%2F6bqMHMjGGwOaW2dQuv8NP8wamYU%2FWX9A2H5GfQL6Obuef%2FygAnZ1vnxN13KaPZ2OivcHwIYFpxcRxVcMyVqcQ6HyqQ2Ev5ZOYM9xwoNYR7hzMU%2FePr%2BUWdEu9UDSFy4SVQ%2BccNtnw6KApPOaYNzrNHA";
    
    if (STRINGHASVALUE(url)) {
        self.m_netState = kNetStateGetOrderDetail;
        if (self.httpUtil) {
            [self.httpUtil cancel];
            self.httpUtil = nil;
        }
        self.httpUtil = [[[HttpUtil alloc] init] autorelease];
        [self.httpUtil requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
    }
}

- (void)requestRefundInfo
{
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setValue:[_orders safeObjectForKey:@"orderId"] forKey:@"orderId"];
    [jsonDictionary setValue:@"ika0000000" forKey:@"wrapperId"];
    [jsonDictionary setValue:[_ticketKeys objectForKey:[NSString stringWithFormat:@"%d", _currentRefundButtonIndex]] forKey:@"ticketKey"];
    NSString *checkCodeString = _ticketRefundCheckView.verificationCodeTextField.text;
    if (STRINGHASVALUE(checkCodeString)) {
        [jsonDictionary setValue:checkCodeString forKey:@"verifyCode"];
    }
    
    NSString *paramJson = [jsonDictionary JSONString];
    NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain" forService:@"refundInfo" andParam:paramJson];
    
//    SFRelease(_ticketRefundCheckView);
    
    if (STRINGHASVALUE(url)) {
        self.m_netState = kNetStateRefundInfo;
        if (self.httpUtil) {
            [self.httpUtil cancel];
            self.httpUtil = nil;
        }
        self.httpUtil = [[[HttpUtil alloc] init] autorelease];
        [self.httpUtil requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
    }
}

- (void)confirmRefund
{
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setValue:[_orders safeObjectForKey:@"orderId"] forKey:@"orderId"];
    [jsonDictionary setValue:@"ika0000000" forKey:@"wrapperId"];
    [jsonDictionary setValue:[_ticketKeys objectForKey:[NSString stringWithFormat:@"%d", _currentRefundButtonIndex]] forKey:@"ticketKey"];
    NSString *paramJson = [jsonDictionary JSONString];
    NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain" forService:@"refundMoney" andParam:paramJson];
    
    if (STRINGHASVALUE(url)) {
        self.m_netState = kNetStateRefundMoney;
        if (self.httpUtil) {
            [self.httpUtil cancel];
            self.httpUtil = nil;
        }
        self.httpUtil = [[[HttpUtil alloc] init] autorelease];
        [self.httpUtil requestWithURLString:url Content:paramJson StartLoading:YES EndLoading:YES Delegate:self];
    }
}

- (void)clearSubView
{
    for (UIView *subView in [_detailScrollView subviews]) {
        subView.hidden = YES;
        [subView removeFromSuperview];
    }
    UIImageView *shareView = (UIImageView *)[self.view viewWithTag:kShareViewTag];
    [shareView removeFromSuperview];
}

//
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
    NSString *orderID = _orderNumber.text;
    
    if (orderID != nil)
    {
        [dictionaryJson safeSetObject:orderID forKey:@"orderId"];
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
        
        _m_netState = kNetStateGetPayState;
        
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

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if (_m_netState != kNetStateGetOrderDetail) {
        if (_ticketRefundCheckView) {
            [_ticketRefundCheckView stopRefresh];
        }
    }
//    else {
//        [super back];
//    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (_m_netState == kNetStateGetOrderDetail) {
        [self clearSubView];
        [self.view showTipMessage:@"没有获取到您的订单详情"];
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary *root = [PublicMethods unCompressData:responseData];
//    NSLog(@"%@ %@", root, [[root safeObjectForKey:@"ErrorMessage"] description]);
    NSDictionary *orderDic = [root safeObjectForKey:@"order"];
    BOOL isError = [[root safeObjectForKey:@"IsError"] boolValue];
    NSString *errorCode = [root safeObjectForKey:@"ErrorCode"];
    NSString *errorMessage = [root safeObjectForKey:@"ErrorMessage"];
    NSInteger status = [[root safeObjectForKey:@"status"] integerValue];
    if (!DICTIONARYHASVALUE(orderDic) && status == 0 && !isError && !STRINGHASVALUE(errorMessage) && !STRINGHASVALUE(errorCode) && _m_netState == kNetStateGetOrderDetail) {
        [self clearSubView];
        [self.view showTipMessage:@"没有获取到您的订单详情"];
        return;
    }
    
    
    if([Utils checkJsonIsErrorNoAlert:root] && (_m_netState == kNetStateGetPayState))
    {
        // 结束请求
        _isPayStateLoading = NO;
        
        NSString *message = [root safeObjectForKey:@"ErrorMessage"];
        if (!STRINGHASVALUE(message))
        {
            message = @"服务器错误，是否重试?";
        }
        
        UIAlertView *askingAlert = [[UIAlertView alloc] initWithTitle:message
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"重试", nil];
        askingAlert.tag = kAlertViewPayStateTag;
        [askingAlert show];
        [askingAlert release];
        
        jumpToSafari = YES;
        
        return ;

    }
    else if ([Utils checkJsonIsError:root])
    {
        if (!root)
        {
            return;
        }
        
        if (_m_netState == kNetStateRefundMoney) {
            TrainOrderDetailTicketView *ticketView = [_ticketArray objectAtIndex:_currentRefundButtonIndex];
            ticketView.ticketState.text = [root safeObjectForKey:@"ticketStatusName"];
            [Utils alert:[root safeObjectForKey:@"ErrorMessage"]];
        }
        return ;
    }
    
    [self.view removeTipMessage];
    
    if (_m_netState == kNetStateGetOrderDetail) {
        NSDictionary *order = [root safeObjectForKey:kOrderKey];
        _orderNumber.text = [order safeObjectForKey:kOrderNumberDes];
        _arrivalTime.text = [order safeObjectForKey:kArrivalTimeDes];
        _departureTime.text = [order safeObjectForKey:kDepartureTimeDes];
        _orderState.text = [order safeObjectForKey:kOrderStateDes];
        if(_orderState.text.length>4){
            _orderState.font = FONT_12;
        }
        
        // 12306订单号
        NSString *orderNo12306Text = [order safeObjectForKey:kOrderNumber12306];
        if (STRINGHASVALUE(orderNo12306Text))
        {
            _orderNo12306.text = orderNo12306Text;
        }
        else
        {
            _orderNo12306.text = @"无";
        }
        
        // 流水号
        NSString *tradeNoText = [order safeObjectForKey:kOrderTradeNumber];
        if (STRINGHASVALUE(tradeNoText))
        {
            _tradeNumber.text = tradeNoText;
        }
        else
        {
            _tradeNumber.text = @"无";
        }
        
        self.orderStatusCode = [NSString stringWithFormat:@"%@", [order safeObjectForKey:kOrderStateCodeDes]];
        _trainNumber.text = [order safeObjectForKey:kTrainNo];
        _orderCreateDate.text = [order safeObjectForKey:kOrderCreateDate];
        _date.text = [order safeObjectForKey:kDepartureDateDes];
        _departureStation.text = [order safeObjectForKey:kOrderFromStation];
        _arrivalStation.text = [order safeObjectForKey:kOrderToStation];
        
        NSString *orderPriceText = [ [order safeObjectForKey:kTotalPrice] stringByReplacingOccurrencesOfString:@".0"withString:@""];
        _orderTotalAmount.text = orderPriceText;
        NSString *cancelableStr = [order safeObjectForKey:kOrderStateCodeDes];
        if ([cancelableStr integerValue] == 1 && [[order safeObjectForKey:@"isRepayStatus"] integerValue] == 0) {
            _alipayButton.hidden = NO;
        }
        else {
            _alipayButton.hidden = YES;
        }

        if (![[order safeObjectForKey:kOrderCancelable] boolValue]) {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        NSString *balance = [order safeObjectForKey:kTicketBalance];
        BOOL balanceable = [balance boolValue];
        if (balanceable) {
            _balanceNotice.hidden = !balanceable;
            _balanceNotice.text = [NSString stringWithFormat:@"卧铺原因, 已退款¥ %@", [self changeFloat:balance]];
        }
        NSString *duration = [order safeObjectForKey:kOrderDuration];
        if (STRINGHASVALUE(duration)) {
            _duration.text = [NSString stringWithFormat:@"历时%@", duration];
        }
        else {
            _duration.text = @"";
        }
        
        self.ticketInfoArray = [order safeObjectForKey:kTicketKey];
        if ([_ticketInfoArray count] > 0) {
            [self addTicketViews:_ticketInfoArray];
        }
        return;
    }
    else if (_m_netState == kNetStateGetVerificationCode) {
        if (_ticketRefundCheckView) {
            [_ticketRefundCheckView stopRefresh];
        }
        
        BOOL isNeed = [root safeObjectForKey:@"isNeed"];
        if (isNeed) {
            self.checkCodeStream = [root safeObjectForKey:kCheckCodeStream];
            self.checkCodeData = [Base64 decodeString:_checkCodeStream];
            //                self.checkCodeStream = [StringEncryption DecryptString:_checkCodeStream];
            [self showRefundVerificationView];
        }
        else {
            [Utils alert:[root safeObjectForKey:@"ErrorMessage"]];
        }
    }
    else if (_m_netState == kNetStateRefundInfo) {
        NSArray *resultArray = [root safeObjectForKey:@"result"];
        if (ARRAYHASVALUE(resultArray)) {
            [self showRefundView:[resultArray objectAtIndex:0]];
        }
    }
    else if (_m_netState == kNetStateOrderCancel) {
        [Utils alert:@"取消订单成功"];
        [self performSelectorOnMainThread:@selector(getOrderDetail) withObject:nil waitUntilDone:NO];
    }
    else if (_m_netState == kNetStateRefundMoney) {
        [Utils alert:@"退票成功"];
        [_ticketRefundView closeTicketRefundView:nil];
        [self getOrderDetail];
    }
    else if (_m_netState == kNetStateGetPayAddress)
    {
        self.alipayAddress = [root safeObjectForKey:kOrderRepayAddress];
        
        if (UMENG) {
            // 去支付宝支付
            [MobClick event:Event_TrainOrder_Pay];
        }
        
        //如果是支付宝app支付
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
    // 支付宝回调请求
    else if (_m_netState == kNetStateGetPayState)
    {
        _isPayStateLoading = NO;
        
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
            
            UIAlertView *askingAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                  message:returnDesc
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                        otherButtonTitles:@"重试", nil];
            askingAlert.tag = kAlertViewPayStateTag;
            [askingAlert show];
            [askingAlert release];
            
            
            if (UMENG) {
                // 火车票未支付
                [MobClick event:Event_TrainOrder_HavenotPay];
            }
        }
        
    }
    
//    if (util == self.checkcodeHttpUtil) {
//        if (_ticketRefundCheckView) {
//            [_ticketRefundCheckView stopRefresh];
//        }
//        
//        BOOL isNeed = [root safeObjectForKey:@"isNeed"];
//        if (isNeed) {
//            self.checkCodeStream = [root safeObjectForKey:kCheckCodeStream];
//            self.checkCodeData = [Base64 decodeString:_checkCodeStream];
//            //                self.checkCodeStream = [StringEncryption DecryptString:_checkCodeStream];
//            [self showRefundVerificationView];
//        }
//        else {
//            [Utils alert:[root safeObjectForKey:@"ErrorMessage"]];
//        }
//    }else{
//        
//    }
}

@end
