//
//  FlightOrderSuccess.m
//  ElongClient
//
//  Created by dengfang on 11-1-26.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightOrderSuccess.h"
#import "Utils.h"
#import "FlightDataDefine.h"
#import "OrderManagement.h"
#import "FillFlightOrder.h"
#import "AlipayViewController.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "ShareTools.h"
#import "FlightData.h"
#import "FStatusDetail.h"
#import "UniformCounterViewController.h"
#import "ElongInsurance.h"
#import "FStatusDetailInfos.h"
//#import "ForecastViewController.h"


#define kTableViewCellHeight 44.0f
#define BackAlertTag 8701
#define AliapyAlertTag 8702


@interface FlightOrderSuccess()
@property (nonatomic,assign) FlightOrderPayType orderPayType;
@property (nonatomic, retain) UIButton *saveAlbumButton;
//@property (nonatomic, retain) ForecastViewController *forecastVC;

@end

@implementation FlightOrderSuccess

static FlightOrderSuccess *instance = nil;
@synthesize payNoteLable;
@synthesize orderDate;
@synthesize noteLabel;
@synthesize imagefromparentview;
@synthesize havePNR;

+(FlightOrderSuccess *) currentInstance{
    return  instance;
}

+(void)setInstance:(FlightOrderSuccess *)inst{
	instance = inst;
}



- (IBAction)okButtonPressed {
    
    [Utils clearFlightData];
	[self.navigationController popToViewController:[self.navigationController.viewControllers safeObjectAtIndex:1] animated:YES];
}


- (id)init {
	return [self initWithPayType:FlightOrderPayTypeCreditCard];
}

- (id)initWithPayType:(FlightOrderPayType)type
{
    NavBtnStyle style = type == FlightOrderPayTypeCreditCard ? _NavNormalBtnStyle_ : _NavNoBackBtnStyle_;
    if (self = [super initWithTopImagePath:@"" andTitle:@"预订成功" style:style]) {
        self.orderPayType = type;
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT);
        self.view.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f / 255 alpha:1.0f];

        
        payType = @"Client";
		isCouldPay = NO;
        payNoteLable.hidden = YES;
		//add payBtn
		payBtn.hidden = YES;
		havePNR = YES;
        
        if (self.orderPayType == FlightOrderPayTypeCreditCard) {
            UMENG_EVENT(UEvent_Flight_OrderSuccess)
        }
        
        // 添加下方按钮
        if (self.orderPayType == FlightOrderPayTypeAlipay) {
            //支付宝支付相关控件
            switch ([UniformCounterViewController paymentType])
            {
                case UniformPaymentTypeAlipay:
                {
                    confirmButton = [UIButton uniformButtonWithTitle:@"支付宝支付"
                                                           ImagePath:@"confirm_sign.png"
                                                              Target:self
                                                              Action:@selector(payByalipay)
                                                               Frame:CGRectMake(15,295, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
                }
                    break;
                case UniformPaymentTypeAlipayWap:
                {
                    confirmButton = [UIButton uniformButtonWithTitle:@"支付宝支付"
                                                           ImagePath:@"confirm_sign.png"
                                                              Target:self
                                                              Action:@selector(payByalipay)
                                                               Frame:CGRectMake(15,295, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
                }
                    break;
                case UniformPaymentTypeDepositCard:
                {
                    confirmButton = [UIButton uniformButtonWithTitle:@"储蓄卡支付"
                                                           ImagePath:@"confirm_sign.png"
                                                              Target:self
                                                              Action:@selector(payByalipay)
                                                               Frame:CGRectMake(15,295, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
                }
                    break;
                    
                default:
                    break;
            }
        }
        [self.view addSubview:confirmButton];
        [self.view bringSubviewToFront:bgView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAlipayWap:) name:NOTI_ALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
	}
	
	return self;
}

- (void)backhome {
	if (isCouldPay) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"支付未完成，您可以到个人中心－机票订单内完成支付"
													   delegate:self 
											  cancelButtonTitle:@"取消"
											  otherButtonTitles:@"确认", nil];
        alert.tag = BackAlertTag;
		[alert show];
		[alert release];
	}
	else {
		[super backhome];
	}
}


- (void)back
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers safeObjectAtIndex:1] animated:YES];
}


-(void) setCouldPay:(BOOL) couldPay{
	isCouldPay = couldPay;
    
	if([FillFlightOrder getIsPayment] && isCouldPay){
		payBtn.hidden = NO;
        payNoteLable.text = FORMAT_ALIPAY_TIP;
        payNoteLable.font = [UIFont boldSystemFontOfSize:13];
        payNoteLable.textColor = [UIColor colorWithRed:215/255 green:39/255 blue:65/255 alpha:1];
		payNoteLable.hidden = NO;
		
		shareBtn.hidden = YES;
		noteLabel.hidden = YES;
		confirmButton.hidden = YES;
		upLine.hidden = YES;
		bottomLine.hidden = YES;
		goMyOrderBtn.hidden = YES;
		successTipLabel.text = @"已下单！";
		[self setNavTitle:@"支付订单"];
		[self setShowBackBtn:NO];
        selectedView.frame = CGRectMake(10, 200, SCREEN_WIDTH, 50);
        [self setshowTelAndHome];
        selectedView.hidden = YES;
	}else {
        NSLog(@"支付已经成功！");
        [FillFlightOrder setIsPayment:NO];
		payBtn.hidden = YES;
        
        if (couponCount > 0) {
            // 显示使用消费券的提示
            payNoteLable.text = [NSString stringWithFormat:FORMAT_FLIGHT_COUPON_TIP, couponCount];
            payNoteLable.font = FONT_14;
            payNoteLable.textColor = [UIColor colorWithRed:254.0f / 255 green:75.0f / 255 blue:32.0f / 255 alpha:1.0f];
            payNoteLable.hidden = NO;
        }
        else {
//            payNoteLable.hidden = YES;
            // Add.
            payNoteLable.text = FORMAT_ALIPAY_TIP;
            // End.
        }
		
//		successTipLabel.hidden = NO;
		shareBtn.hidden = NO;
		noteLabel.hidden = NO;
		confirmButton.hidden = NO;
		upLine.hidden = NO;
		bottomLine.hidden = NO;
		goMyOrderBtn.hidden = NO;
		successTipLabel.text = @"预订成功!";
		[self setNavTitle:@"预订成功"];
		[self setShowBackBtn:NO];
        selectedView.frame = CGRectMake(10, 230, SCREEN_WIDTH, 50);
        selectedView.hidden = NO;

	} 
    // Add.
    if (isCouldPay) {
        _payStatelabel.text = @"已下单!";
    }
    else {
        _payStatelabel.text = @"预订成功!";
    }
    
    _flightOrderSucTableView.hidden = isCouldPay;
//    payNoteLable.hidden = isCouldPay;
//    _saveAlbumButton.hidden = isCouldPay;
    noteLabel.hidden = isCouldPay;
    confirmButton.hidden = !isCouldPay;
    // End.
}

-(void) paySuccess{
    [self setCouldPay:NO];
    [self setshowShareAndHome];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.orderDate = [NSDate date];
    
    self.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, SCREEN_HEIGHT - 64.0f);
    
	// 是否已关注
    _isAttentioned = [self hasAddtoAttention];
    
    // 跳转链接
    if (_homeAdNavi == nil)
    {
        _homeAdNavi = [[HomeAdNavi alloc] init];
    }
    
    
	double priceAll = 0;
    
    // 计算成人和儿童
    NSArray *passengerList = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
    NSInteger adultCount = 0;
    NSInteger childCount = 0;
    for (NSDictionary *passenger in passengerList) {
        if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 0) {
            adultCount++;
        }
        else if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 1) {
            childCount++;
        }
    }
    
    couponCount = 0;
    NSString *city = [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY];
    NSString *arrivalDate = nil;
    
	int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
	if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
		Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
        
        arrivalDate = [TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"yyyyMMddHHmm"];
        
//		priceAll = [[flight getPrice] intValue] +[[flight getOilTax] doubleValue] +[[flight getAirTax] intValue];
        priceAll = ([[flight getAdultPrice] integerValue] + [[flight getAdultOilTax] integerValue] + [[flight getAdultAirTax] integerValue]) * adultCount + ([[flight getChildPrice] integerValue] + [[flight getChildOilTax] integerValue] + [[flight getChildAirTax] integerValue]) * childCount;
        couponCount += [flight.currentCoupon intValue];
	}
	arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
	if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil) {
		Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
        
        arrivalDate = [TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"yyyyMMddHHmm"];
        
		priceAll += ([[flight getAdultPrice] integerValue] + [[flight getAdultOilTax] integerValue] + [[flight getAdultAirTax] integerValue]) * adultCount + ([[flight getChildPrice] integerValue] + [[flight getChildOilTax] integerValue] + [[flight getChildAirTax] integerValue]) * childCount;
        couponCount += [flight.currentCoupon intValue];
	}
    
    if (couponCount > [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue]) {
        // 返券不能大于可用返券
        couponCount = [[[Coupon activedcoupons] safeObjectAtIndex:0] intValue];
    }
    
    // 请求天气预报
//    if (!_forecastVC) {
//        ForecastViewController *tempForecastVC = [[ForecastViewController alloc] init];
//        tempForecastVC.view.frame = CGRectMake(SCREEN_WIDTH - kForecastViewWidth, 10.0f, kForecastViewWidth, kForecastViewHeight);
//        self.forecastVC = tempForecastVC;
//        [tempForecastVC release];
//        
//        [bgView addSubview:_forecastVC.view];
//        
//        if (STRINGHASVALUE(arrivalDate)) {
//            [_forecastVC startRequestWithCity:city withDate:arrivalDate];
//        }
//    }
    
//	int pCount = [[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count];
    totalPrice = priceAll + [[ElongInsurance shareInstance] getInsuranceTotalPrice];
    // 如果是1小时飞人
    NSNumber *isOneHourObj = [[FlightData getFDictionary] safeObjectForKey:KEY_ISONEHOUR];
    if (isOneHourObj != nil && ([isOneHourObj boolValue] == YES))
    {
        totalPrice = priceAll;
    }
    
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(moneyTitleLabel.frame) + CGRectGetWidth(moneyTitleLabel.frame), CGRectGetMinY(moneyTitleLabel.frame), 171, CGRectGetHeight(moneyTitleLabel.frame))];
	priceLabel.text					= [NSString stringWithFormat:@"¥%.f", totalPrice];
    priceLabel.textColor = [UIColor colorWithRed:250.0f / 255 green:50.0f / 255 blue:26.0f / 255 alpha:1.0f];
	priceLabel.font					= FONT_B16;
	priceLabel.backgroundColor		= [UIColor clearColor];
	[bgView addSubview:priceLabel];
	[priceLabel release];
	
	idLabel.hidden = NO;
    idLabel.textColor = RGBACOLOR(52, 52, 52, 1);
	idLabel.text = [NSString stringWithFormat:@"%lli", [[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO] longLongValue]];
    if ([idLabel.text isEqualToString:@"0"]) {
        // 没有订单号时，调整界面布局
        idLabel.hidden = YES;
        idTitleLabel.hidden = YES;
    }
  
    UIButton *saveToAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveToAlbumButton.frame = CGRectMake(0.0f, (CGRectGetMinY(bgView.frame) + CGRectGetHeight(bgView.frame) + 15.0f) * COEFFICIENT_Y, 320.0f, 44.0f);
    saveToAlbumButton.backgroundColor = [UIColor whiteColor];
    [saveToAlbumButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [saveToAlbumButton setTitle:@"保存订单到相册" forState:UIControlStateNormal];
    [saveToAlbumButton setImage:[UIImage imageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
    saveToAlbumButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 12.0f, 10.0f, 278.0f);
    saveToAlbumButton.titleEdgeInsets = UIEdgeInsetsMake(10.0f, 25.0f, 10.0f, 140.0f);
    [saveToAlbumButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    self.saveAlbumButton = saveToAlbumButton;
//    [self.view addSubview:saveToAlbumButton];
    UIImageView* line = [UIImageView graySeparatorWithFrame:CGRectMake(0.0f,  0.0f , CGRectGetWidth(saveToAlbumButton.frame), 0.5f)];
	[saveToAlbumButton addSubview:line];
	UIImageView* lineimg = [UIImageView graySeparatorWithFrame:CGRectMake(0.0f, CGRectGetHeight(saveToAlbumButton.frame), CGRectGetWidth(saveToAlbumButton.frame), 0.5f)];
	[saveToAlbumButton addSubview:lineimg];
    
    // Set notelabel's rect.
    CGRect noteLabelRect = noteLabel.frame;
    noteLabelRect.origin.y = CGRectGetHeight(saveToAlbumButton.frame) + CGRectGetMinY(saveToAlbumButton.frame) + 15.0f;
//    noteLabelRect.origin.y *= COEFFICIENT_Y;
    noteLabel.frame = noteLabelRect;
    
    UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.view.frame) - kTableViewCellHeight * 3, 320.0f, kTableViewCellHeight * 3)];
    tempTableView.dataSource = self;
    tempTableView.delegate = self;
    tempTableView.scrollEnabled = NO;
    self.flightOrderSucTableView = tempTableView;
    [tempTableView release];
    [self.view addSubview:_flightOrderSucTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    // 初始化推荐hotel的标志
    _isPushHotel = NO;
}

- (void)mutipleConditionBeSelected:(id)sender
{
	UIButton *btn = (UIButton *)sender;
    saveordertoalbum = !saveordertoalbum;
    NSString *imgPath = saveordertoalbum ? @"btn_checkbox_checked.png" : @"btn_checkbox.png";
    [btn setImage:[UIImage imageNamed:imgPath] forState:UIControlStateNormal];
}

- (void)goMyOrder {
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
    
    UMENG_EVENT(UEvent_Flight_OrderSuccess_Orders)
}

- (void) goHotel{

    // 是否已经点击推荐
    if (_isPushHotel)
    {
        return;
    }
    // 设置标志
    _isPushHotel = YES;
    
    
    NSString *targetCity = @"";
    
    // 选择的乘机类型
    int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
    if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
        Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
        
        targetCity = [flight getArriveAirport];
    }
//    arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
//    if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil) {
//        Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
//        
//        targetCity = [flight getArriveAirport];
//    }
    
    if (STRINGHASVALUE(targetCity))
    {
        // 是否包含"机场"
        NSString *suffixString = @"机场";
        
        NSRange foundObj=[targetCity rangeOfString:suffixString options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
        } else {
            targetCity = [targetCity stringByAppendingString:suffixString];
        }
        
        // 获取位置信息跳转酒店
        PositioningManager *positionManager = [PositioningManager shared];
        [positionManager getPositionFromAddress:targetCity];
        [positionManager setDelegate:self];
    }
    
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[idLabel release];
	[okButton release];
    [idTitleLabel release];
    [moneyTitleLabel release];
    self.payNoteLable = nil;
    
    if (_homeAdNavi != nil)
    {
        SFRelease(_homeAdNavi);
    }
    
    _flightOrderSucTableView.dataSource = nil;
    _flightOrderSucTableView.delegate = nil;
    self.flightOrderSucTableView = nil;
    
    self.saveAlbumButton = nil;
//    self.forecastVC = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)payByalipay{
    
    if ([[ServiceConfig share] monkeySwitch])
    {
        // 开着monkey时不发生事件
        return;
    }

	[FlightOrderSuccess setInstance:nil];
	[FlightOrderHistoryDetail setInstance:nil];
	//判断是否可以支付
	netType = @"isAllowPay";
	JGetFlightOrder *jgfol=[OrderHistoryPostManager getFlightOrder];
	[jgfol clearBuildData];
	[jgfol setOrderNo:[[FlightData getFDictionary] safeObjectForKey:@"OrderNo"] ];
	//	[jgfol setOrderNo:[NSNumber numberWithInt:33857784]];

	[Utils request:MYELONG_SEARCH req:[jgfol requesString:YES] delegate:self];
}

// 判断是否已关注
- (BOOL)hasAddtoAttention
{
    BOOL hasAdded = NO;
    
    NSMutableArray *arrayAttention = [Utils arrayAttention];
    
    if (arrayAttention)
    {
        for (NSInteger i=0; i<[arrayAttention count]; i++)
        {
            FStatusDetail *fStatusDetailTmp = [arrayAttention safeObjectAtIndex:i];
            
            if (fStatusDetailTmp != nil)
            {
                Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
                NSString *flightNumber = [flight getFlightNumber];
                
                NSString *flightDate = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE];
                
                if (STRINGHASVALUE(flightNumber) && [flightNumber isEqualToString:[[fStatusDetailTmp detailInfos] flightNo]] &&
                    STRINGHASVALUE(flightDate) && [flightDate isEqualToString:[[fStatusDetailTmp detailInfos] flightDate]])
                {
                    hasAdded = YES;
                    break;
                }
            }
        }
    }
    
    return hasAdded;
    
}

// 序列化参航班动态数据
- (void)serialAttentionDate:(FStatusDetail *)fStatusDetail
{
    Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
    
    //
    FStatusDetailInfos *fStatusDetailInfos = [[FStatusDetailInfos alloc] init];
    
    // 航班号
    NSString *flightNumber = [flight getFlightNumber];
    if (STRINGHASVALUE(flightNumber))
    {
        [fStatusDetailInfos setFlightNo:flightNumber];
    }
    
    // 航班日期
    NSString *flightDate = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE];;
    if (STRINGHASVALUE(flightDate))
    {
        [fStatusDetailInfos setFlightDate:flightDate];
    }
    
    // 航空公司
    NSString *flightCompany = [flight getAirCorpName];
    if (STRINGHASVALUE(flightCompany))
    {
        [fStatusDetailInfos setFlightCompany:flightCompany];
    }
    
    // 出发机场
    NSString *departAirport = [flight getDepartAirport];
    if (STRINGHASVALUE(departAirport))
    {
        [fStatusDetailInfos setFlightDepAirport:departAirport];
    }
    
    // 到达机场
    NSString *arriveAirport = [flight getArriveAirport];
    if (STRINGHASVALUE(arriveAirport))
    {
        [fStatusDetailInfos setFlightArrAirport:arriveAirport];
    }
    
//    // 预计起飞时间
//    NSString *departTime = [flight getDepartTime];
//    if (STRINGHASVALUE(departTime))
//    {
//        [fStatusDetailInfos setFlightDeptimePlan:departTime];
//    }
//    
//    // 预计到达时间
//    NSString *arriveTime = [flight getArriveTime];
//    if (STRINGHASVALUE(arriveTime))
//    {
//        [fStatusDetailInfos setFlightArrtimePlan:arriveTime];
//    }
    
    // 保存
    [fStatusDetail setDetailInfos:fStatusDetailInfos];
    [fStatusDetailInfos release];
}

// 移除关注
- (void)removeAttention
{
    // 获取关注列表
    NSMutableArray *arrayAttention = [Utils arrayAttention];
    
    NSInteger currIndex;
    BOOL hasAttentioned = NO;
    
    for (NSInteger i=0; i<[arrayAttention count]; i++)
    {
        FStatusDetail *fStatusDetailTmp = [arrayAttention safeObjectAtIndex:i];
        
        if (fStatusDetailTmp != nil)
        {
            Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
            NSString *flightNumber = [flight getFlightNumber];
            NSString *flightDate = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE];
            
            if (STRINGHASVALUE(flightNumber) && [flightNumber isEqualToString:[[fStatusDetailTmp detailInfos] flightNo]] &&
                STRINGHASVALUE(flightDate) && [flightDate isEqualToString:[[fStatusDetailTmp detailInfos] flightDate]])
            {
                currIndex = i;
                hasAttentioned = YES;
                break;
            }
            
        }
    }
    
    if (hasAttentioned)
    {
        [arrayAttention removeObjectAtIndex:currIndex];
    }
    
    // 保存
    [Utils saveAttention:arrayAttention];
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

#pragma mark -
#pragma mark NetDelegate
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    CFShow(root);
	if([netType isEqualToString:@"isAllowPay"]){
		//做了一下改动
		if([[[root safeObjectForKey:@"Order"] safeObjectForKey:@"IsAllowContinuePay"] boolValue]){
            instance = [self retain];    //将当前VC赋值给变量，以供回调使用
            
            switch ([UniformCounterViewController paymentType]){
                case UniformPaymentTypeAlipay:{
                    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
                        //客户端存在，打开客户端
                        CFShow(self.orderDate);
                        netType = @"pay";
                        payType = @"Client";
                        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
                        [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
                        [mutDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO] forKey:@"OrderId"];
                        [mutDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_CODE] forKey:@"OrderCode"];
                        payFee = [[root safeObjectForKey:@"Order"] safeObjectForKey:@"PayFee"];
                        [mutDict safeSetObject:payFee forKey:@"TotalPrice"];
                        [mutDict safeSetObject:@"elongIPhone://" forKey:@"ReturnUrl"];
                        [mutDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"PayMethod"];
                        NSString *guid = [NSString stringWithFormat:@"zsafe-%@",[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO]];
                        [mutDict safeSetObject:guid forKey:@"Guid"];
                        
                        NSString *reqParam = [NSString stringWithFormat:@"action=GetAlipayBefundInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
                        [Utils orderRequest:FLIGHT_SERACH req:reqParam delegate:self];
                        [mutDict release];
                    }else{
                        // 提示用户安装支付宝客户端
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"未发现支付宝客户端，请您更换别的支付方式或下载支付宝客户端！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        [alert show];
                        [alert release];
                    }
                }
                    break;
                case UniformPaymentTypeAlipayWap:{
                    netType = @"pay";
                    payType = @"wap";
                    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
                    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
                    [mutDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO] forKey:@"OrderId"];
                    [mutDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_CODE] forKey:@"OrderCode"];
                    payFee = [[root safeObjectForKey:@"Order"] safeObjectForKey:@"PayFee"];
                    [mutDict safeSetObject:payFee forKey:@"TotalPrice"];
                    [mutDict safeSetObject:@"elongIPhone://wappay/" forKey:@"ReturnUrl"];
                    [mutDict safeSetObject:[NSNumber numberWithInt:2] forKey:@"PayMethod"];
                    NSString *guid = [NSString stringWithFormat:@"zwap-%@",[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO]];
                    [mutDict safeSetObject:guid forKey:@"Guid"];
                    
                    NSString *reqParam = [NSString stringWithFormat:@"action=GetAlipayBefundInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
                    [Utils orderRequest:FLIGHT_SERACH req:reqParam delegate:self];
                    [mutDict release];
                }
                    break;
                case UniformPaymentTypeDepositCard:{
                    netType = @"pay";
                    payType = @"wap";
                    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
                    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
                    [mutDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO] forKey:@"OrderId"];
                    [mutDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_CODE] forKey:@"OrderCode"];
                    payFee = [[root safeObjectForKey:@"Order"] safeObjectForKey:@"PayFee"];
                    [mutDict safeSetObject:payFee forKey:@"TotalPrice"];
                    [mutDict safeSetObject:@"elongIPhone://wappay/" forKey:@"ReturnUrl"];
                    [mutDict safeSetObject:[NSNumber numberWithInt:2] forKey:@"PayMethod"];
                    NSString *guid = [NSString stringWithFormat:@"zwap-%@",[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO]];
                    [mutDict safeSetObject:guid forKey:@"Guid"];
                    
                    NSString *reqParam = [NSString stringWithFormat:@"action=GetAlipayBefundInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
                    [Utils orderRequest:FLIGHT_SERACH req:reqParam delegate:self];
                    [mutDict release];
                }
                    break;
                    
                default:
                    break;
            }
		}else {
			if(havePNR){
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单已被取消，不能再支付！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单无法支付，稍后会有客服人员与您联系！" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
				[alert show];
				[alert release];
			}
		}
        
	}else if([netType isEqualToString:@"pay"]){
		if([payType isEqualToString:@"Client"]){
			//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
			NSString *appScheme = @"elongIPhone";
			NSString *orderString = [root safeObjectForKey:@"Url"];
			//获取安全支付单例并调用安全支付接口
			AlixPay * alixpay = [AlixPay shared];
			int ret = [alixpay pay:orderString applicationScheme:appScheme];
			if (ret == kSPErrorSignError) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"签名错误" message:@"联系服务商" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
				[alert show];
				[alert release];
			}
		}else if([payType isEqualToString:@"wap"]){
			NSString *urlString = [root safeObjectForKey:@"Url"];
			NSRange range = [urlString rangeOfString:@"sign="];
			NSString *prefixString = [urlString substringToIndex:range.location+range.length];
			NSString *signString = [urlString substringFromIndex:range.location+range.length];
			NSString *combineString = [NSString stringWithFormat:@"%@%@",[prefixString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],signString];
			NSURL *url = [NSURL URLWithString:combineString];
            
            if(!STRINGHASVALUE(combineString)){
                //如果url无效
                [PublicMethods showAlertTitle:@"" Message:@"未获取到支付地址！"];
            }

            if ([[UIApplication sharedApplication] canOpenURL:url]){
                // 能用safari打开优先用safari打开
                [[UIApplication sharedApplication] newOpenURL:url];
                jumpToSafari = YES;
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
                jumpToSafari = NO;
            }
		}
	}
}


- (void)shareInfo {
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
	shareTools.mailImage = imagefromparentview;//[self screenshotOnCurrentView];
	shareTools.weiBoContent = [self weiboContent];
	shareTools.msgContent = [self smsContent];
	shareTools.mailTitle = @"使用艺龙旅行客户端预订机票成功！";
	shareTools.mailContent = [self mailContent];
	
	[shareTools  showItems];
	
    UMENG_EVENT(UEvent_Flight_OrderSuccess_Share)
}


-(UIImage *) screenshotOnCurrentView{
	shareBtn.hidden = YES;
	confirmButton.hidden = YES;
	upLine.hidden = YES;
	bottomLine.hidden = YES;
	goMyOrderBtn.hidden = YES;
	
	UIImage *screenShot = [self.view imageByRenderingViewWithSize:self.view.bounds.size];
	
	shareBtn.hidden = NO;
	confirmButton.hidden = NO;
	upLine.hidden = NO;
	bottomLine.hidden = NO;
	goMyOrderBtn.hidden = NO;
    [self setCouldPay:isCouldPay];
	return screenShot;
}


-(NSString *) smsContent{

	NSString *message  = nil;

	if([[FlightData getFArrayReturn] count] >0){
		//往返程
		//单程
		Flight *flight_1 = nil;
		Flight *flight_2 = nil;
		int arrayIndex_1 = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
		if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex_1] != nil) {
			// 第一行
			flight_1 = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex_1];
		}
		//返程
		int arrayIndex_2 = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
		if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex_2] != nil) {
			flight_2 = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex_2];
		}
		NSString *orderNo = [NSString stringWithFormat:@"%lli", [[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO] longLongValue]];
		NSString *airCorpName_1 = [flight_1 getAirCorpName];
		NSString *flightNumber_1 = [flight_1 getFlightNumber];
		NSString *departAirPort_1 = [flight_1 getDepartAirport];
		NSString *arriveAirport_1 =  [flight_1 getArriveAirport];
		
		NSString *airCorpName_2 = [flight_2 getAirCorpName];
		NSString *flightNumber_2 = [flight_2 getFlightNumber];
		NSString *departTime_str_1 = [TimeUtils displayDateWithJsonDate:[flight_1 getDepartTime] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str_1 = [TimeUtils displayDateWithJsonDate:[flight_1 getArriveTime] formatter:@"MM月dd日 HH:mm"];
		NSString *departTime_str_2 = [TimeUtils displayDateWithJsonDate:[flight_2 getDepartTime] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str_2 = [TimeUtils displayDateWithJsonDate:[flight_2 getArriveTime] formatter:@"MM月dd日 HH:mm"];
		
		message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订了一张%@至%@的往返机票，订单号：%@，去程：%@ %@，起飞时间：%@，降落时间：%@， 返程：%@ %@，起飞时间：%@，降落时间：%@。",departAirPort_1,arriveAirport_1,
				   orderNo,airCorpName_1,flightNumber_1,departTime_str_1,arriveTime_str_1,airCorpName_2,flightNumber_2,departTime_str_2,arriveTime_str_2];

		
	}else {
		//单程
		int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
		if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
			// 第一行
			Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
			//单程
			//		NSDictionary *ticketsDict = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:0];
			NSString *orderNo = [NSString stringWithFormat:@"%lli", [[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO] longLongValue]];
			NSString *airCorpName = [flight getAirCorpName];
			NSString *flightNumber = [flight getFlightNumber];
			NSString *departAirPort = [flight getDepartAirport];
			NSString *arriveAirport = [flight getArriveAirport];
			NSString *departTime_str = [TimeUtils displayDateWithJsonDate:[flight getDepartTime] formatter:@"MM月dd日 HH:mm"];
			NSString *arriveTime_str = [TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"MM月dd日 HH:mm"];
			
			message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订了一张%@至%@的机票，订单号：%@，%@ %@，起飞时间：%@，降落时间：%@。",departAirPort,arriveAirport,
					   orderNo,airCorpName,flightNumber,departTime_str,arriveTime_str];
		}
		
	}	
	NSString *messageBody = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
	return messageBody;
}

-(NSString *) mailContent{
	
	NSString *message  = nil;
	
	if([[FlightData getFArrayReturn] count] >0){
		//往返程
		//单程
		Flight *flight_1 = nil;
		Flight *flight_2 = nil;
		int arrayIndex_1 = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
		if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex_1] != nil) {
			// 第一行
			flight_1 = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex_1];
		}
		//返程
		int arrayIndex_2 = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
		if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex_2] != nil) {
			flight_2 = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex_2];
		}
		NSString *orderNo = [NSString stringWithFormat:@"%lli", [[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO] longLongValue]];
		NSString *airCorpName_1 = [flight_1 getAirCorpName];
		NSString *flightNumber_1 = [flight_1 getFlightNumber];
		NSString *departAirPort_1 = [flight_1 getDepartAirport];
		NSString *arriveAirport_1 =  [flight_1 getArriveAirport];
		
		NSString *airCorpName_2 = [flight_2 getAirCorpName];
		NSString *flightNumber_2 = [flight_2 getFlightNumber];
		NSString *departTime_str_1 = [TimeUtils displayDateWithJsonDate:[flight_1 getDepartTime] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str_1 = [TimeUtils displayDateWithJsonDate:[flight_1 getArriveTime] formatter:@"MM月dd日 HH:mm"];
		NSString *departTime_str_2 = [TimeUtils displayDateWithJsonDate:[flight_2 getDepartTime] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str_2 = [TimeUtils displayDateWithJsonDate:[flight_2 getArriveTime] formatter:@"MM月dd日 HH:mm"];
		
		message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订了一张%@至%@的往返机票，既便捷又超值。订单号：%@，去程：%@ %@，起飞时间：%@，降落时间：%@， 返程：%@ %@，起飞时间：%@，降落时间：%@。",departAirPort_1,arriveAirport_1,
				   orderNo,airCorpName_1,flightNumber_1,departTime_str_1,arriveTime_str_1,airCorpName_2,flightNumber_2,departTime_str_2,arriveTime_str_2];
		
		
	}else {
		//单程
		int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
		if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
			// 第一行
			Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
			//单程
			//		NSDictionary *ticketsDict = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:0];
			NSString *orderNo = [NSString stringWithFormat:@"%lli", [[[FlightData getFDictionary] safeObjectForKey:KEY_ORDER_NO] longLongValue]];
			NSString *airCorpName = [flight getAirCorpName];
			NSString *flightNumber = [flight getFlightNumber];
			NSString *departAirPort = [flight getDepartAirport];
			NSString *arriveAirport = [flight getArriveAirport];
			NSString *departTime_str = [TimeUtils displayDateWithJsonDate:[flight getDepartTime] formatter:@"MM月dd日 HH:mm"];
			NSString *arriveTime_str = [TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"MM月dd日 HH:mm"];
			
			message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订了一张%@至%@的机票，既便捷又超值。订单号：%@，%@ %@，起飞时间：%@，降落时间：%@。",departAirPort,arriveAirport,
					   orderNo,airCorpName,flightNumber,departTime_str,arriveTime_str];
		}
		
	}	
	
	NSString *messageBody = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166\n订单详情见附件图片：",message];
	return messageBody;
}

- (NSString *) weiboContent{
	NSString *message = nil;
	if([[FlightData getFArrayReturn] count] >0){
		//往返程
		//单程
		Flight *flight_1 = nil;
		Flight *flight_2 = nil;
		int arrayIndex_1 = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
		if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex_1] != nil) {
			// 第一行
			flight_1 = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex_1];
		}
		//返程
		int arrayIndex_2 = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
		if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex_2] != nil) {
			flight_2 = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex_2];
		}
		
		NSString *airCorpName_1 = [flight_1 getAirCorpName];
		NSString *flightNumber_1 = [flight_1 getFlightNumber];
		NSString *departAirPort_1 =  [flight_1 getDepartAirport];
		NSString *arriveAirport_1 = [flight_1 getArriveAirport];
		NSString *price_str_1 = [NSString stringWithFormat:@"%.f",[[flight_1 getPrice] floatValue]];
		
		NSString *airCorpName_2 = [flight_2 getAirCorpName];
		NSString *flightNumber_2 = [flight_2 getFlightNumber];
		NSString *price_str_2 = [NSString stringWithFormat:@"%.f",[[flight_2 getPrice] floatValue]];
		message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订了一张%@至%@的往返机票，去程：%@ %@,艺龙价仅售￥%@  返程：%@ %@,艺龙价仅售￥%@。",departAirPort_1,arriveAirport_1,
				   airCorpName_1,flightNumber_1,price_str_1,airCorpName_2,flightNumber_2,price_str_2];
		
	}else {
		//单程
		int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
		if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
			// 第一行
			Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
			//单程
			NSString *airCorpName = [flight getAirCorpName];
			NSString *flightNumber = [flight getFlightNumber];
			NSString *departAirPort =  [flight getDepartAirport];
			NSString *arriveAirport = [flight getArriveAirport];
			NSString *price_str = [NSString stringWithFormat:@"%.f",[[flight getPrice] floatValue]];
			message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订了一张%@至%@的机票，%@ %@,艺龙价仅售￥%@。",departAirPort,arriveAirport,airCorpName,flightNumber,price_str];
			
		}
		
	}
	NSString *content  = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
	return content;
}


-(void)takePicture:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = NO;
    [button setImage:[UIImage imageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateNormal];
    
    self.view.userInteractionEnabled = NO;
    
    UIImageWriteToSavedPhotosAlbum(imagefromparentview, 
                                   self, 
                                   @selector(imageSavedToPhotosAlbum: 
                                             didFinishSavingWithError: 
                                             contextInfo:), 
                                   nil);  	

    
}
- (void)moveview {
    [m_imgview.layer removeAnimationForKey:@"marioJump"];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = .5;
    scaleAnimation.toValue = [NSNumber numberWithFloat:.1];
    
    
    CABasicAnimation *slideDownx = [CABasicAnimation animationWithKeyPath:@"position.x"];
    slideDownx.toValue = [NSNumber numberWithFloat: confirmButton.frame.origin.x + confirmButton.frame.size.width/2];
    slideDownx.duration = .5f;
    slideDownx.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];    
    
    CABasicAnimation *slideDowny= [CABasicAnimation animationWithKeyPath:@"position.y"];
    slideDowny.toValue = [NSNumber numberWithFloat: confirmButton.frame.origin.y + confirmButton.frame.size.height/2];
    slideDowny.duration = .5f;
    slideDowny.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:scaleAnimation, slideDownx, slideDowny, nil];
    group.duration = .5;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.autoreverses = NO;
    group.delegate = self;
    group.removedOnCompletion = YES;
    group.fillMode = kCAFillModeForwards;
    
    
    [m_imgview.layer addAnimation:group forKey:@"marioJump"];
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished {
    if(finished) {
        [m_imgview removeFromSuperview];
        //        captureBtn.enabled = NO;
        UIImageWriteToSavedPhotosAlbum(imagefromparentview, 
                                       self, 
                                       @selector(imageSavedToPhotosAlbum: 
                                                 didFinishSavingWithError: 
                                                 contextInfo:), 
                                       nil);  	
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
    NSString *message = nil;

    if (!error) 
	{
        message = @"订单信息已经保存到相册";
    } else {  
        message = @"保存失败，为允许访问相册，请在设置中打开！";
        [_saveAlbumButton setImage:[UIImage imageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
	}  
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil  
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];  
    [alert show];  
    [alert release]; 
    self.view.userInteractionEnabled = YES;
    if (!error) {
        [Utils clearFlightData];
        [self.navigationController popToViewController:[self.navigationController.viewControllers safeObjectAtIndex:1] animated:YES];
    }
}

#pragma mark - PositioningManager Delegate
- (void)getPositionInfoBack:(NSDictionary *)dicPosition
{
    if (dicPosition != nil)
    {
        // 获取位置信息
        NSString *latlonInfo = [dicPosition safeObjectForKey:@"latlonInfo"];
        NSString *cityName = [dicPosition safeObjectForKey:@"cityName"];
        
        // 航班到达时间
        NSString *stringArrivalDate = @"";
        int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
        if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
            Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
            
            stringArrivalDate = [TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"yyyyMMddHHmm"];
        }
//        arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
//        if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil) {
//            Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
//            
//            stringArrivalDate = [TimeUtils displayDateWithJsonDate:[flight getArriveTime] formatter:@"yyyyMMddHHmm"];
//        }
        if (STRINGHASVALUE(stringArrivalDate))
        {
            NSDate *arrivalDate = [NSDate dateFromString:stringArrivalDate withFormat:@"yyyyMMddHHmm"];
            
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
                [_homeAdNavi adNaviJumpUrl:jumpParam title:@"跳转酒店" active:YES];
                
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
                
                [_homeAdNavi adNaviJumpUrl:jumpParam title:@"跳转酒店" active:YES];
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
                    
                    [_homeAdNavi adNaviJumpUrl:jumpParam title:@"跳转酒店" active:YES];
                    
                }
                else    // 不是同一天
                {
                    // 城市经纬度搜索
                    NSString *jumpParam = [NSString stringWithFormat:@"gotohotelcity:%@",cityName];
                    
                    [_homeAdNavi adNaviJumpUrl:jumpParam title:@"跳转酒店" active:YES];
                    
                }
            }
        }
    }
}

#pragma mark -
#pragma mark Delegate
#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.5f)];
//    cellLineView.backgroundColor = [UIColor grayColor];
    //                [cell bringSubviewToFront:cellLineView];
    
    UIImageView* line = [UIImageView graySeparatorWithFrame:CGRectMake(0.0f,  0.0f , 320.0f, 0.5f)];
	return line;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *flightOrderSucCellKey = @"flightOrderSucCellKey";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:flightOrderSucCellKey];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flightOrderSucCellKey] autorelease];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView* line = [UIImageView graySeparatorWithFrame:CGRectMake(0.0f, kTableViewCellHeight - 0.5f, 320.0f, 0.5f)];
        [cell addSubview:line];
    }
    
    if (indexPath.row > 0) {
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 9.0f)];
        arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        cell.accessoryView = arrow;
        [arrow release];
    }
//    cell.textLabel.font =  [UIFont fontWithName:@"STHeitiSC-Light" size:16];
//    cell.textLabel.textColor = [UIColor colorWithRed:53.0f / 255 green:53.0f / 255 blue:53.0f / 255 alpha:1.0f];
    cell.textLabel.font = FONT_14;
    cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
    cell.textLabel.highlightedTextColor = RGBACOLOR(52, 52, 52, 1);
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.imageView.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row) {
        case 0: {
            
            NSString *titleText = @"";
            if (_isAttentioned)
            {
                titleText = @"取消关注该航班";
            }
            else
            {
                titleText = @"关注该航班";
            }
            
            cell.textLabel.text = titleText;
            cell.imageView.image = [UIImage imageNamed:@"flight_trends_cell.png"];
        }
            break;
        case 1: {
            cell.textLabel.text = @" 查看订单";
            cell.imageView.image = [UIImage imageNamed:@"watch_order_cell.png"];
        }
            break;
        case 2: {
            NSString *arrivalCity = [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY];
            cell.textLabel.text = [NSString stringWithFormat:@"看%@酒店", arrivalCity];
            cell.imageView.image = [UIImage imageNamed:@"search_arrival_hotel_cell.png"];
        }
            break;
        default:
            break;
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            // 添加关注
            if (!_isAttentioned)
            {
                NSMutableArray *arrayAttention = [Utils arrayAttention];
                if (arrayAttention && [arrayAttention count] == 5)
                {
                    [Utils alert:@"您关注的航班已达到5条，请进入航班动态模块删除其他航班来关注该航班"];
                }
                else
                {
                    FStatusDetail *fStatusDetail = [[FStatusDetail alloc] init];
                    // 序列化数据
                    [self serialAttentionDate:fStatusDetail];
                    // 添加
                    [arrayAttention insertObject:fStatusDetail atIndex:0];
                    // 保存
                    [Utils saveAttention:arrayAttention];
                    
                    [fStatusDetail release];
                    
                    // 改变状态
                    _isAttentioned = !_isAttentioned;
                }
            }
            // 取消关注
            else
            {
                [self removeAttention];
                
                // 改变状态
                _isAttentioned = !_isAttentioned;
            }
            
            // 刷新
            [tableView reloadData];
            
        }
            break;
        case 1:
            [self goMyOrder];
            break;
        case 2:
            [self goHotel];
            break;
        default:
            break;
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 第一个otherButton
    //NSUInteger otherButtonIndex = [alertView firstOtherButtonIndex];
    
    if (alertView.tag == AliapyAlertTag) {
        if (0 != buttonIndex){
            // 已支付
            [self paySuccess];
        }else{
            
        }
    }else if(alertView.tag == BackAlertTag){
        if (0 != buttonIndex) {
            [super backhome];
        }
    }
    
}


#pragma mark -
#pragma mark Notification
#pragma mark - Notification Methods
- (void) weixinPaySuccess{
    [self paySuccess];
    UMENG_EVENT(UEvent_Flight_OrderSuccess)
}


- (void)notiByAlipayWap:(NSNotification *)noti{
    [self paySuccess];
    UMENG_EVENT(UEvent_Flight_OrderSuccess)
}


- (void)notiByAppActived:(NSNotification *)noti{
    // 监测到程序被从后台激活时，询问用户支付情况
    if (jumpToSafari){
        UIAlertView *askingAlert = [[UIAlertView alloc] initWithTitle:@"是否已完成支付宝支付"
                                                              message:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"未完成"
                                                    otherButtonTitles:@"已支付", nil];
        [askingAlert show];
        askingAlert.tag = AliapyAlertTag;
        [askingAlert release];
        
        jumpToSafari = NO;
    }
}

- (void) alipayPaySuccess{
    [self paySuccess];
    UMENG_EVENT(UEvent_Flight_OrderSuccess)
}


@end
