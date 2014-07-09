//
//  TrainFillOrderVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-11-6.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainFillOrderVC.h"
#import "CheckBoxButton.h"
#import "TrainOrderCell.h"
#import "HotelOrderLinkmanCell.h"
#import "TrainPassagerCell.h"
#import "TrainTickets.h"
#import "TrainReq.h"
#import "TrainSeats.h"
#import "CommonSelectView.h"
#import "Mytrain_submitOrder.h"
#import "JCustomer.h"
#import "MyElongPostManager.h"
#import "ElongURL.h"
#import "StringEncryption.h"
#import "TrainOrderSuccessVC.h"
#import "TrainOrderTicketRuleVC.h"
#import "HtmlViewController.h"
#import "NSData+Base64.h"
#import "UrgentTipManager.h"
#import "TrainOrderStudentTicketRuleVC.h"

// 控件尺寸
#define kTrainOrderViewBottomHeight                 44
#define kTrainOrderTableHeadHeight                  118
#define kTrainOrderTableFootHeight                  40+44
#define kTrainOrderCellSeparateLineHeight           1
#define kTrainOrderDirectionArrowWidth              50
#define kTrainOrderDirectionArrowHeight             5
#define kTrainOrderSectionPassagerHeight            15
#define kTrainOrderCellArrowIconWidth               5
#define kTrainOrderCellArrowIconHeight              9

// 边框局
#define kTrainOrderBottomHMargin                    12
#define kTrainOrderBottomMiddleHMargin              8
#define kTrainOrderTrainDriveViewVMargin            26
#define kTrainOrderCellHMargin                      12
#define kTrainOrderFooterHMargin                    12
#define kTrainOrderFooterVMargin                    10
#define kTrainOrderFooterMiddleHMargin              8

#define kSeatsPickerViewHeight          216.0f


#define TEXT_FIELD_TAG      5001
#define MAX_TICKET_NUM      5

#define k_creditCard_btn        101
#define k_debit_btn             102

#define cell_height_normal      44

#define CODE_IDENTICARD         @"1"        // 二代身份证
#define CODE_GATEPASS_GANGAO    @"C"        // 港澳通行证
#define CODE_GATEPASS_TAIWAN    @"G"        // 台湾通行证
#define CODE_PASSPORT           @"B"        // 护照

#define PHONENUM_TEXT_FIELD_TAG      5098   //联系电话textfield tag
#define VERRIFYCODE_FIELD_TAG      5099     //验证码textfield tag


// 控件Tag
enum TrainOrderVCTag {
    kTrainOrderTrainHeadTopLineTag = 100,
    kTrainOrderTrainDepartViewTag,
    kTrainOrderTrainArriveViewTag,
    kTrainOrderTrainDriveViewTag,
    kTrainOrderTrainHeadBottomLineTag,
    kTrainOrderDepartNameLabelTag,
    kTrainOrderDepartTimeLabelTag,
    kTrainOrderDepartStationDateLabelTag,
    kTrainOrderArriveNameLabelTag,
    kTrainOrderArriveTimeLabelTag,
    kTrainOrderArriveStationDateLabelTag,
    kTrainOrderDurationLabelTag,
    kTrainOrderDirectionArrowIconTag,
    kTrainOrderTrainNumberLabelTag,
    kTrainOrderBottomOrderPriceLabelTag,
    kTrainOrderCellPassageTitleLabelTag,
    kTrainOrderCellPassageSplitViewTag,
    kTrainOrderCellPassageBottomLineTag,
    kTrainOrderCellAddPassagerButtonTag,
    kTrainOrderFooterRuleTipLabelTag,
    kTrainOrderFooterStudentTipLabelTag,
    kTrainOrderFooterStudentRuleTipLabelTag
};

static NSString * staticStudentTips  = @"温馨提示:1.学生票暂按成人票价收取，出票成功后，您的账号将在3-7个工作日收到差价部分的退款。\n2.请根据实际酌情选择学生票，认真填写学生证上优惠乘车区间，艺龙不承担因学生等信息不符而无法取票或进站的责任。";


@interface TrainFillOrderVC ()

@property (nonatomic, copy) NSString *phoneNumber;          // 电话号码
@property (nonatomic, copy) NSString *seatName;             // 座席名称
@property (nonatomic, retain) NSArray *recordArray;         // 纪录过的乘客
@property (nonatomic, assign) CGPoint tableViewPreOffset;   //键盘显示前 tableView的offset
@property (nonatomic,copy) NSString *utoken;              //用户的表示token，下单传给后端

@property (nonatomic, retain) UIPickerView *seatsPicker;
@property (nonatomic, retain) UIView *seatsPickerView;
@property (nonatomic, assign) BOOL isStudent;
@property (nonatomic, retain) NSMutableArray *mixedSeatsArray;  // 混合了成人票和学生票的数组
@property (nonatomic, copy) NSString *selectedSeatString;       // 选择的坐席
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation TrainFillOrderVC

@synthesize phoneNumber;
@synthesize utoken;
@synthesize tableViewPreOffset = _tableViewPreOffset;

+ (NSString *)getCertTypeNameByTypeEnum:(NSString *)enumName
{
    // 根据卡号类型获取类型名字
    if ([enumName isEqualToString:CODE_IDENTICARD])
    {
        return @"身份证";
    }
    else if ([enumName isEqualToString:CODE_GATEPASS_GANGAO])
    {
        return @"港澳通行证";
    }
    else if ([enumName isEqualToString:CODE_GATEPASS_TAIWAN])
    {
        return @"台湾通行证";
    }
    else if ([enumName isEqualToString:CODE_PASSPORT])
    {
        return @"护照";
    }
    else
    {
        return @"未知";
    }
}


- (void)dealloc
{
    [getCustomerListUtil cancel];
    SFRelease(getCustomerListUtil);
    // 记录用户填写信息，方便下次恢复
    [self recordRassengersInfo];
    
    [[PassengerListVC allPassengers] removeAllObjects];
    
    SFRelease(phoneNumber);
    SFRelease(passengersArray);
    SFRelease(_recordArray);
    
    self.seatName = nil;
    self.utoken=nil;
    
    _seatsPicker.dataSource = nil;
    _seatsPicker.delegate = nil;
    self.seatsPickerView = nil;
    self.mixedSeatsArray = nil;

    if (identifyCodeRequest)
    {
        [identifyCodeRequest cancel];
        SFRelease(identifyCodeRequest);
    }
    
    [[UrgentTipManager sharedInstance] cancelUrgentTip];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([self.view window] == nil)
    {
        self.view = nil;
        
        
    }
}


- (id)init
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"填写订单" style:_NavNormalBtnStyle_])
    {
        passengersArray = [[NSMutableArray alloc] initWithCapacity:2];
        
        if (ARRAYHASVALUE(_recordArray))
        {
            // 有历史纪录的情况,根据乘客人数添加乘客历史
            for (int i = 0; i < passagerCount; i++)
            {
                if ([_recordArray count] > i)
                {
                    NSDictionary *dic = [_recordArray objectAtIndex:i];
                    [passengersArray addObject:dic];
                }
            }
        }
        
        [self preLoadPassengers];
    
        reqListOver = NO;
        _isSkipLogin = NO;
        currentPassagerIndex = 0;
        _tableViewPreOffset=CGPointMake(0, -1);
    }
    
    return self;
}


// 返回
- (void)back
{
	if (_isSkipLogin)
    {
		NSArray *navCtrls = self.navigationController.viewControllers;
		[self.navigationController popToViewController:[navCtrls safeObjectAtIndex:[navCtrls count] - 3] animated:YES];
	}
	else
    {
		[super back];
	}
}

// 到取票退票规则页
- (void)goTicketTule
{
    TrainOrderTicketRuleVC *controller = [[TrainOrderTicketRuleVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    UMENG_EVENT(UEvent_Train_FillOrder_Rule)
}


- (void)goStudentTicketTule
{
    TrainOrderStudentTicketRuleVC *controller = [[TrainOrderStudentTicketRuleVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)preLoadPassengers
{
    // 预加载乘客列表
    JCustomer *customer = [MyElongPostManager customer];
    [customer clearBuildData];
    [customer setCustomerType:1];
    
    getCustomerListUtil = [[HttpUtil alloc] init];
    [getCustomerListUtil connectWithURLString:MYELONG_SEARCH
                                      Content:[customer requesString:YES]
                                 StartLoading:NO
                                   EndLoading:NO
                                     Delegate:self];
}

// 记录用户填写的相关信息：手机号、预定房间数量、所填写的房间入住人等
- (void)recordRassengersInfo
{
    // 记录手机号和房间数
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:passengersArray] forKey:RECORD_TRAIN_PASSAGERS];
//    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:RECORD_TRAIN_PASSAGERS_COUNT];
    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:NONMEMBER_PHONE];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:RECORD_TRAIN_RECORDTIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (BOOL)checkInfoRight
{
    // 监测用户输入信息是否正确
    if ([passengersArray count] == 0 || [passengersArray count] < passagerCount)
    {
        [PublicMethods showAlertTitle:@"乘客信息不全" Message:@"请检查"];
        return NO;
    }
    
    if (!STRINGHASVALUE(phoneNumber))
    {
        [PublicMethods showAlertTitle:@"请填写手机号码" Message:nil];
        return NO;
    }
    
    if (identifyCodeView.hidden==NO)
    {
        NSString *verifyCode =  [identifyCodeView.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!STRINGHASVALUE(verifyCode))
        {
            [PublicMethods showAlertTitle:@"请填写验证码" Message:nil];
            
            float offset=passagerList.tableFooterView.frame.origin.y+passagerList.tableFooterView.frame.size.height-passagerList.frame.size.height+5;
            
            if (offset>0&&passagerList.contentOffset.y<offset)
            {
                [passagerList setContentOffset:CGPointMake(0, offset)];
            }
            
            return NO;
        }
    }
    
    self.phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!MOBILEPHONEISRIGHT(phoneNumber)) {
        [PublicMethods showAlertTitle:_string(@"s_phonenum_iserror") Message:nil];
        return NO;
    }
    
    return YES;
}

// 注册通知
- (void)registerNotification
{
    // 键盘显示消息
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	
	// 键盘隐藏消息
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

// 注销通知
- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 键盘显示
- (void)keyboardDidShow:(NSNotification *)notification
{
    NSValue *frameEnd = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [frameEnd CGRectValue];
    NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [passagerList setViewHeight:self.view.frame.size.height - keyboardRect.size.height ];
    
    // 滚动键盘
	CGPoint topPointInTable = [viewResponder convertPoint:CGPointZero toView:passagerList];
	CGPoint bottomPointInFocus = CGPointMake(0, [viewResponder frame].size.height);
	CGPoint bottomPointInView = [viewResponder convertPoint:bottomPointInFocus toView:[self view]];
	
	CGRect viewFrame = [[self view] frame];
	NSInteger keyboardYInView = viewFrame.size.height - keyboardRect.size.height;
    
    CGPoint tableViewInfoOffset = [passagerList contentOffset];
    //只记录第一次的
    if (_tableViewPreOffset.y==-1)
    {
        _tableViewPreOffset = tableViewInfoOffset;
    }
    
	if(bottomPointInView.y > keyboardYInView)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:animationDuration];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [passagerList setContentOffset:CGPointMake(tableViewInfoOffset.x, tableViewInfoOffset.y + bottomPointInView.y - keyboardYInView)];
        [UIView commitAnimations];
	}
	else if(topPointInTable.y < tableViewInfoOffset.y)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:animationDuration];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [passagerList setContentOffset:CGPointMake(tableViewInfoOffset.x, topPointInTable.y)];
		[UIView commitAnimations];
	}
}

// 键盘消失
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    [passagerList setViewHeight:MAINCONTENTHEIGHT-BLACK_BANNER_HEIGHT];
    
    // 动画
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (_tableViewPreOffset.y!=-1)
    {
        [passagerList setContentOffset:_tableViewPreOffset];
    }
    
    [UIView commitAnimations];
    
    //还原
    _tableViewPreOffset=CGPointMake(0, -1);
}

// 刷新乘客选择状态
- (void)refreshPassageCheckStatus
{
    // 乘客列表
    for (NSMutableDictionary *dic in [PassengerListVC allPassengers])
    {
        [dic setObject:[NSNumber numberWithBool:NO] forKey:k_checked_key];
        
        // 重新设置
        for (NSInteger i=0; i<[passengersArray count]; i++)
        {
            Passenger *passenger = [passengersArray safeObjectAtIndex:i];
            if (passenger != nil && STRINGHASVALUE([passenger name]))
            {
                if ([[dic safeObjectForKey:@"Name"] isEqualToString:[passenger name]] && [[dic safeObjectForKey:@"IdNumber"] isEqualToString:[passenger certNumber]])
                {
                    [dic setObject:[NSNumber numberWithBool:YES] forKey:k_checked_key];
                }
            }
        }
    }
}

// 是否支持学生票
- (BOOL)supportStudentTicket
{
    for (TrainSeats *trainSeat in ticket.arraySeats) {
        if ([trainSeat.availableTypes indexOfObject:@"3"] != NSNotFound) {
            return TRUE;
        }
    }
    return FALSE;
}

#pragma mark - UI

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
	
    passagerList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT-BLACK_BANNER_HEIGHT) style:UITableViewStylePlain];
    passagerList.backgroundColor = [UIColor clearColor];
    passagerList.backgroundView = nil;
    passagerList.delegate = self;
    passagerList.dataSource = self;
    passagerList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    passagerList.separatorColor = [UIColor clearColor];
    [passagerList setEditing:YES];
    [passagerList setAllowsSelectionDuringEditing:YES];
    //    [passagerList setAllowsSelection:YES];
    [self.view addSubview:passagerList];
    [passagerList release];
    
    // =======================================================================
	// TableHeader
	// =======================================================================
	UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectZero];
	[viewHeader setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTrainOrderTableHeadHeight)];
    [viewHeader setBackgroundColor:[UIColor whiteColor]];
	
	// 创建子界面
	[self setupTableHeaderSubs:viewHeader];
	
	// 保存
	[passagerList setTableHeaderView:viewHeader];
    [viewHeader release];

    // =======================================================================
	// TableFooter
	// =======================================================================
	viewFoot = [[UIView alloc] initWithFrame:CGRectZero];
    [viewFoot setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTrainOrderTableFootHeight)];
    [viewFoot setBackgroundColor:[UIColor clearColor]];

	// 创建子界面
	[self setupTableViewFooterSubs:viewFoot];
	
	// 保存
	[passagerList setTableFooterView:viewFoot];
    [viewFoot release];
    
    
    [self adjustTheBottomTip];
    
    // 选择常用联系人按钮
    //    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    //    if (!appDelegate.isNonmemberFlow)
    //    {
    //        [self setUpCustomerSelBtn];
    //    }
    
    // 底栏
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - BLACK_BANNER_HEIGHT, [self.view frame].size.width, BLACK_BANNER_HEIGHT)];
    [viewBottom setBackgroundColor:RGBACOLOR(62, 62, 62, 1)];
    [self setupViewBottom:viewBottom];
    [self.view addSubview:viewBottom];
    [viewBottom release];
    
    
    if (UMENG) {
        // 火车票订单填写
        [MobClick event:Event_TrainFillOrder label:ticket.number];
    }
}

-(void)adjustTheBottomTip{

    //获取紧急提示
    UITableView *weakPassergerList = passagerList;
    
    for (UIView *v  in passagerList.tableFooterView.subviews) {
        if ([v isKindOfClass:[UrgentTipView class]]) {
            [v removeFromSuperview];
        }
    }
    
    UIView*tipLabel = (UIView *)[viewFoot viewWithTag:kTrainOrderFooterStudentTipLabelTag];
    UIView *weakIdentifyCodeView;
    if (tipLabel) {
        if (self.isStudent) {
            tipLabel.hidden = NO;
            weakIdentifyCodeView = tipLabel;
        }else{
            tipLabel.hidden = YES;
            weakIdentifyCodeView = identifyCodeView;
        }
    }
    else {
        weakIdentifyCodeView = identifyCodeView;
    }
    
    [[UrgentTipManager sharedInstance] urgentTipViewofCategory:TrainFillOrderUrgentTip completeHandle:^(UrgentTipView *urgentTipView) {
        
        //判断验证码是否存在，根据验证码设置坐标
        int urgentTipViewOriginY = weakIdentifyCodeView.frame.origin.y;
        if (weakIdentifyCodeView && !weakIdentifyCodeView.hidden)
        {
            urgentTipViewOriginY=weakIdentifyCodeView.frame.origin.y+weakIdentifyCodeView.frame.size.height;
        }
        
        CGRect frame = urgentTipView.frame;
        frame.origin.y = urgentTipViewOriginY;
        urgentTipView.frame = frame;
        
        UIView *tmpViewRoot = weakPassergerList.tableFooterView;
        [tmpViewRoot addSubview:urgentTipView];
        
        //根据urgentTipView坐标设置footerView
        CGRect viewRootFrame = tmpViewRoot.frame;
        viewRootFrame.size.height = urgentTipView.frame.origin.y + urgentTipView.frame.size.height;
        tmpViewRoot.frame = viewRootFrame;
        [weakPassergerList setTableFooterView:tmpViewRoot];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    // 注册通知
    [self registerNotification];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
    // 注销通知
    [self unregisterNotification];
}

- (void)initData
{
    passagerCount = 1;
    
    ticket = [[TrainReq shared] currentRoute];
    seat = [[TrainReq shared] currentSeat];
    
    // 拼接选择器数组数据源
    NSMutableArray *tempMutableArray = [NSMutableArray arrayWithCapacity:0];
    for (TrainSeats *trainSeat in ticket.arraySeats) {
        if ([trainSeat.yupiao isEqualToString:@"0"]) {
            continue;
        }
        
        if (!ARRAYHASVALUE(trainSeat.availableTypes) || [trainSeat.availableTypes indexOfObject:@"3"] == NSNotFound) {
            [tempMutableArray addObject:[NSString stringWithFormat:@"%@成人票", trainSeat.name]];
        }
        else {
            [tempMutableArray addObject:[NSString stringWithFormat:@"%@成人票", trainSeat.name]];
            [tempMutableArray addObject:[NSString stringWithFormat:@"%@学生票", trainSeat.name]];
        }
    }
    self.mixedSeatsArray = tempMutableArray;
    
    self.seatName = [NSString stringWithFormat:@"%@", seat.name];
    if ([AccountManager instanse].isLogin)
    {
        // 登陆用户首先取自己的手机号
        self.phoneNumber = [AccountManager instanse].phoneNo;
    }
    if (!STRINGHASVALUE(phoneNumber))
    {
        self.phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE];
    }
    
    /*************** 获取非会员和会员的乘客纪录 ************/
    // 超过12小时，清理数据
    NSData *passengerData = [[NSUserDefaults standardUserDefaults] objectForKey:RECORD_TRAIN_PASSAGERS];
    if ([passengerData isKindOfClass:[NSData class]] &&
        passengerData.length > 0)
    {
        self.recordArray = [NSKeyedUnarchiver unarchiveObjectWithData:passengerData];
    }
    
//    NSNumber *roomnum = [[NSUserDefaults standardUserDefaults] objectForKey:RECORD_TRAIN_PASSAGERS_COUNT];
//    if (roomnum)
//    {
//        passagerCount = [roomnum intValue];
//        
//        NSLog(@"%@", seat.yupiao);
//        // 有历史纪录得情况还需要判断历史纪录人数是否大于目前最多可预订得票量
//        if ([seat.yupiao intValue] < passagerCount)
//        {
//            passagerCount = [seat.yupiao intValue];
//        }
//    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:RECORD_TRAIN_RECORDTIME])
    {
        double timerInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:RECORD_TRAIN_RECORDTIME] doubleValue];
        if ([[NSDate date] timeIntervalSince1970] - timerInterval > 12 * 60 * 60)
        {
            self.recordArray = nil;
            passagerCount = 1;
        }
    }
}


// 创建底栏
- (void)setupViewBottom:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
	NSInteger spaceXStart = 0;
    
    // 间隔
    spaceXStart += kTrainOrderBottomHMargin;
    
    // 价格title
    NSString *priceTitle = @"总价：";
    CGSize titleSize = [priceTitle sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:14.0f]];
    UILabel *labelTitle = [[UILabel alloc] init];
    [labelTitle setFrame:CGRectMake(spaceXStart, parentFrame.size.height*0.34, titleSize.width, titleSize.height)];
    [labelTitle setBackgroundColor:[UIColor clearColor]];
	[labelTitle setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setText:priceTitle];
	[viewParent addSubview:labelTitle];
    [labelTitle release];
    // 子窗口大小
    spaceXStart += titleSize.width;
    // 间隔
    spaceXStart += kTrainOrderBottomMiddleHMargin;
    
    
    // 价格符号
    NSString *currencySign = @"¥";
    CGSize signSize = [currencySign sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    UILabel *labelCurrencySign = [[UILabel alloc] init];
    [labelCurrencySign setFrame:CGRectMake(spaceXStart, parentFrame.size.height*0.34, signSize.width, signSize.height)];
    [labelCurrencySign setBackgroundColor:[UIColor clearColor]];
	[labelCurrencySign setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    [labelCurrencySign setTextColor:[UIColor whiteColor]];
    [labelCurrencySign setTextAlignment:NSTextAlignmentCenter];
    [labelCurrencySign setText:currencySign];
	[viewParent addSubview:labelCurrencySign];
    [labelCurrencySign release];
    
    // 子窗口大小
    spaceXStart += signSize.width;
    // 间隔
    spaceXStart += kTrainOrderBottomMiddleHMargin;
    
    // 价格
    if (STRINGHASVALUE(seat.price))
    {
        NSString *orderPrice = [NSString stringWithFormat:@"%.1f", [seat.price floatValue] * passagerCount];
        
        NSString *orderPriceText = [orderPrice stringByReplacingOccurrencesOfString:@".0"withString:@""];
        
        CGSize priceSize = [orderPrice sizeWithFont:[UIFont fontWithName:@"Helvetica" size:22.0f]];
        UILabel *labelPrice = [[UILabel alloc] init];
        [labelPrice setFrame:CGRectMake(spaceXStart, (parentFrame.size.height-priceSize.height)/2, parentFrame.size.width*0.3, priceSize.height)];
        [labelPrice setBackgroundColor:[UIColor clearColor]];
        [labelPrice setFont:[UIFont fontWithName:@"Helvetica" size:22.0f]];
        [labelPrice setTextColor:[UIColor whiteColor]];
        [labelPrice setTextAlignment:NSTextAlignmentLeft];
        [labelPrice setText:orderPriceText];
        [labelPrice setTag:kTrainOrderBottomOrderPriceLabelTag];
        [viewParent addSubview:labelPrice];
        [labelPrice release];
    }
    
    // 支付按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:nil forState:UIControlStateNormal];
    [nextButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [nextButton setImage:nil forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    nextButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 50);
    [viewParent addSubview:nextButton];
    nextButton.exclusiveTouch = YES;
    
    //    // 支付label
    //    NSString *payText = @"去支付";
    //    CGSize textSize = [payText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18.0f]];
    //    UILabel *labelPay = [[UILabel alloc] init];
    //    [labelPay setFrame:CGRectMake(parentFrame.size.width*0.75, (parentFrame.size.height-textSize.height)/2, textSize.width, textSize.height)];
    //    [labelPay setBackgroundColor:[UIColor clearColor]];
    //	[labelPay setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18.0f]];
    //    [labelPay setTextColor:[UIColor whiteColor]];
    //    [labelPay setTextAlignment:NSTextAlignmentCenter];
    //    [labelPay setText:payText];
    //	[viewParent addSubview:labelPay];
    //    [labelPay release];
    //
    //
    //    // 提交事件
    //    UIControl *controlPay = [[UIControl alloc] initWithFrame:CGRectMake(parentFrame.size.width*0.62, 0, parentFrame.size.width*0.45, parentFrame.size.height)];
    //    [controlPay addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [controlPay setBackgroundColor:[UIColor clearColor]];
    //    [viewParent addSubview:controlPay];
    //    [controlPay release];
}


// 创建TableHeader的子界面
- (void)setupTableHeaderSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    
    // 上分隔线
    CGSize topLineSize = CGSizeMake(parentFrame.size.width, kTrainOrderCellSeparateLineHeight);
    UIView *topLine = [viewParent viewWithTag:kTrainOrderTrainHeadTopLineTag];
    if (topLine == nil)
    {
        topLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
        [topLine setBackgroundColor:[UIColor clearColor]];
        [topLine setTag:kTrainOrderTrainHeadTopLineTag];
        [topLine setAlpha:0.7];
        [viewParent addSubview:topLine];
        [topLine release];
    }
    [topLine setFrame:CGRectMake(0, 0, parentFrame.size.width, topLineSize.height)];
    
    // 子界面高宽
    spaceYStart += topLineSize.height;
    
    // ===========================================
    // 出发站信息
    // ===========================================
    CGSize viewTrainDepartSize = CGSizeMake(parentFrame.size.width/3, 0);
    
    UIView *viewTrainDepart = [viewParent viewWithTag:kTrainOrderTrainDepartViewTag];
    if (viewTrainDepart == nil)
    {
        viewTrainDepart = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainDepart setTag:kTrainOrderTrainDepartViewTag];
        // 保存
        [viewParent addSubview:viewTrainDepart];
        [viewTrainDepart release];
    }
    [viewTrainDepart setFrame:CGRectMake(spaceXStart, spaceYStart, viewTrainDepartSize.width, viewTrainDepartSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainDepartSubs:viewTrainDepart inSize:&viewTrainDepartSize];
    [viewTrainDepart setViewY:(parentFrame.size.height - viewTrainDepartSize.height)/2];
    
    // 子界面大小
    spaceXStart += viewTrainDepartSize.width;
    
    
    // ===========================================
    // 到达站信息
    // ===========================================
    CGSize viewTrainArriveSize = CGSizeMake(parentFrame.size.width/3, parentFrame.size.height-topLineSize.height);
    
    UIView *viewTrainArrive = [viewParent viewWithTag:kTrainOrderTrainArriveViewTag];
    if (viewTrainArrive == nil)
    {
        viewTrainArrive = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainArrive setTag:kTrainOrderTrainArriveViewTag];
        // 保存
        [viewParent addSubview:viewTrainArrive];
        [viewTrainArrive release];
    }
    [viewTrainArrive setFrame:CGRectMake(spaceXEnd-viewTrainArriveSize.width, spaceYStart, viewTrainArriveSize.width, viewTrainArriveSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainArriveSubs:viewTrainArrive inSize:&viewTrainDepartSize];
    [viewTrainArrive setViewY:(parentFrame.size.height - viewTrainDepartSize.height)/2];
    
    // 子界面大小
    spaceXEnd -= viewTrainArriveSize.width;
    
    
    // ===========================================
    // 车程信息
    // ===========================================
    CGSize viewTrainDriveSize = CGSizeMake(spaceXEnd-spaceXStart, parentFrame.size.height-topLineSize.height);
    
    UIView *viewTrainDrive = [viewParent viewWithTag:kTrainOrderTrainDriveViewTag];
    if (viewTrainDrive == nil)
    {
        viewTrainDrive = [[UIView alloc] initWithFrame:CGRectZero];
        [viewTrainDrive setTag:kTrainOrderTrainDriveViewTag];
        // 保存
        [viewParent addSubview:viewTrainDrive];
        [viewTrainDrive release];
    }
    [viewTrainDrive setFrame:CGRectMake(spaceXStart, spaceYStart, viewTrainDriveSize.width, viewTrainDriveSize.height)];
    
    // 创建子界面
    [self setupTableHeadTrainDriveSubs:viewTrainDrive];
    
    // 下分隔线
    CGSize bottomLineSize = CGSizeMake(parentFrame.size.width, kTrainOrderCellSeparateLineHeight);
    UIView *bottomLine = [viewParent viewWithTag:kTrainOrderTrainHeadBottomLineTag];
    if (bottomLine == nil)
    {
        bottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
        [bottomLine setBackgroundColor:[UIColor clearColor]];
        [bottomLine setAlpha:0.7];
        [bottomLine setTag:kTrainOrderTrainHeadBottomLineTag];
        
        [viewParent addSubview:bottomLine];
        [bottomLine release];
    }
    [bottomLine setFrame:CGRectMake(0, parentFrame.size.height-bottomLineSize.height, parentFrame.size.width, topLineSize.height)];
}

// 出发站信息
- (void)setupTableHeadTrainDepartSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    
    // ===========================================
    // 出发站
    // ===========================================
    NSString *departName = [[ticket departInfo] name];
    if (STRINGHASVALUE(departName))
    {
        CGSize nameSize = [departName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18.0f]];
        
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainOrderDepartNameLabelTag];
        if (labelName == nil)
        {
            labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelName setBackgroundColor:[UIColor clearColor]];
            [labelName setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18.0f]];
            [labelName setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelName setAdjustsFontSizeToFitWidth:YES];
            [labelName setMinimumFontSize:10.0f];
            [labelName setTextAlignment:UITextAlignmentCenter];
            [labelName setTag:kTrainOrderDepartNameLabelTag];
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
        CGSize timeSize = [departTime sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:30.0f]];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainOrderDepartTimeLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30.0f]];
            [labelTime setTextColor:[UIColor blackColor]];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setTag:kTrainOrderDepartTimeLabelTag];
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
        CGSize dateSize = [_departShowDate sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
        
        UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kTrainOrderDepartStationDateLabelTag];
        if (labelDate == nil)
        {
            labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDate setBackgroundColor:[UIColor clearColor]];
            [labelDate setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
            [labelDate setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelDate setTextAlignment:UITextAlignmentCenter];
            [labelDate setTag:kTrainOrderDepartStationDateLabelTag];
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
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    
    // ===========================================
    // 到达站
    // ===========================================
    NSString *arriveName = [[ticket arriveInfo] name];
    if (STRINGHASVALUE(arriveName))
    {
        CGSize nameSize = [arriveName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18.0f]];
        
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainOrderArriveNameLabelTag];
        if (labelName == nil)
        {
            labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelName setBackgroundColor:[UIColor clearColor]];
            [labelName setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18.0f]];
            [labelName setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelName setAdjustsFontSizeToFitWidth:YES];
            [labelName setMinimumFontSize:10.0f];
            [labelName setTextAlignment:UITextAlignmentCenter];
            [labelName setTag:kTrainOrderArriveNameLabelTag];
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
        CGSize timeSize = [arriveTime sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:30.0f]];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainOrderArriveTimeLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30.0f]];
            [labelTime setTextColor:[UIColor blackColor]];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setTag:kTrainOrderArriveTimeLabelTag];
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
        CGSize dateSize = [arriveShowDate sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
        
        UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kTrainOrderArriveStationDateLabelTag];
        if (labelDate == nil)
        {
            labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDate setBackgroundColor:[UIColor clearColor]];
            [labelDate setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
            [labelDate setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelDate setTextAlignment:UITextAlignmentCenter];
            [labelDate setTag:kTrainOrderArriveStationDateLabelTag];
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
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = parentFrame.size.height;
    
    // 间隔
    spaceYStart += kTrainOrderTrainDriveViewVMargin;
    spaceYEnd -= kTrainOrderTrainDriveViewVMargin;
    
    
    // ===========================================
    // 列车号
    // ===========================================
    NSString *number = [ticket number];
    if (STRINGHASVALUE(number))
    {
        CGSize numberSize = [number sizeWithFont:[UIFont boldSystemFontOfSize:18.0f]];
        
        UILabel *labelNumber = (UILabel *)[viewParent viewWithTag:kTrainOrderTrainNumberLabelTag];
        if (labelNumber == nil)
        {
            labelNumber = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelNumber setBackgroundColor:[UIColor clearColor]];
            [labelNumber setFont:[UIFont boldSystemFontOfSize:18.0f]];
            [labelNumber setTextColor:[UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:1.0]];
            [labelNumber setTextAlignment:UITextAlignmentCenter];
            [labelNumber setTag:kTrainOrderTrainNumberLabelTag];
            // 保存
            [viewParent addSubview:labelNumber];
            [labelNumber release];
        }
        
        [labelNumber setFrame:CGRectMake((parentFrame.size.width-numberSize.width)/2, spaceYStart, numberSize.width, numberSize.height)];
        [labelNumber setText:number];
        
    }
    
    // ===========================================
    // 指示箭头
    // ===========================================
    CGSize directionIconSize = CGSizeMake(kTrainOrderDirectionArrowWidth, kTrainOrderDirectionArrowHeight);
    UIImageView *directionIcon = (UIImageView *)[viewParent viewWithTag:kTrainOrderDirectionArrowIconTag];
    if (directionIcon == nil)
    {
        directionIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [directionIcon setImage:[UIImage noCacheImageNamed:@"ico_traindetailarrow.png"]];
        [directionIcon setTag:kTrainOrderDirectionArrowIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:directionIcon];
        [directionIcon release];
    }
    
    [directionIcon setFrame:CGRectMake((parentFrame.size.width-directionIconSize.width)/2, (parentFrame.size.height-directionIconSize.height)/2, directionIconSize.width, directionIconSize.height)];
    
    
    
    // ===========================================
    // 历时
    // ===========================================
    NSString *durationShow = [ticket durationShow];
    if (STRINGHASVALUE(durationShow))
    {
        
        CGSize durationSize = [durationShow sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12.0f]];
        
        UILabel *labelDuration = (UILabel *)[viewParent viewWithTag:kTrainOrderDurationLabelTag];
        if (labelDuration == nil)
        {
            labelDuration = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDuration setBackgroundColor:[UIColor clearColor]];
            [labelDuration setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12.0f]];
            [labelDuration setTextColor:[UIColor blackColor]];
            [labelDuration setTextAlignment:UITextAlignmentCenter];
            [labelDuration setAdjustsFontSizeToFitWidth:YES];
            [labelDuration setMinimumFontSize:10.0f];
            [labelDuration setTag:kTrainOrderDurationLabelTag];
            // 保存
            [viewParent addSubview:labelDuration];
            [labelDuration release];
        }
        
        [labelDuration setFrame:CGRectMake((parentFrame.size.width-durationSize.width)/2, spaceYEnd-durationSize.height, durationSize.width, durationSize.height)];
        [labelDuration setText:durationShow];
    }
}

// 创建FooterView的子界面
- (void)setupTableViewHeaderSubs:(UIView *)viewParent inSection:(NSInteger)section inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    if (section == 0)
    {
        spaceYStart += kTrainOrderSectionPassagerHeight;
    }
    
    // =======================================================================
    // 设置父窗口尺寸
    // =======================================================================
    pViewSize->height = spaceYStart;
    if(viewParent != nil)
    {
        [viewParent setViewHeight:pViewSize->height];
    }
}

// 创建FooterView的子界面
- (void)setupTableViewFooterSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXEnd -= kTrainOrderFooterHMargin;
    spaceYStart += kTrainOrderFooterVMargin;
    
    // ===========================================
    // 规则链接
    // ===========================================
    // 箭头
    UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
    [imageViewArrow setFrame:CGRectMake(spaceXEnd-kTrainOrderCellArrowIconWidth, spaceYStart+3, kTrainOrderCellArrowIconWidth, kTrainOrderCellArrowIconHeight)];
    [imageViewArrow setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
    imageViewArrow.hidden = YES;
    // 子窗口大小
//    spaceXEnd -= kTrainOrderCellArrowIconWidth;
    // 间隔
//    spaceXEnd -= kTrainOrderFooterMiddleHMargin;
    
    // 添加到父窗口
    [viewParent addSubview:imageViewArrow];
    [imageViewArrow release];
    
    // 文字
    NSString *ruleTip = @"取票退票规则";
    UIFont *ruleFont = [UIFont systemFontOfSize:12.0f];
    CGSize ruleSize = [ruleTip sizeWithFont:ruleFont];
    UILabel *labelRule = (UILabel *)[viewParent viewWithTag:kTrainOrderFooterRuleTipLabelTag];
    if (labelRule == nil)
    {
        labelRule = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelRule setBackgroundColor:[UIColor clearColor]];
        [labelRule setTextColor:RGBACOLOR(29, 94, 226, 1)];
        [labelRule setFont:ruleFont];
        
        [labelRule setTag:kTrainOrderFooterRuleTipLabelTag];
        [viewParent addSubview:labelRule];
        [labelRule release];
    }
    [labelRule setFrame:CGRectMake(spaceXEnd-ruleSize.width, spaceYStart, ruleSize.width, ruleSize.height)];
    [labelRule setText:ruleTip];
    
    // 调整子窗口大小
    spaceXEnd -= ruleSize.width;
    
    // 事件按钮
    UIControl *controlLink = [[UIControl alloc] initWithFrame:CGRectMake(spaceXEnd, 0, parentFrame.size.width-spaceXEnd, parentFrame.size.height)];
    [controlLink addTarget:self action:@selector(goTicketTule) forControlEvents:UIControlEventTouchUpInside];
    [controlLink setBackgroundColor:[UIColor clearColor]];
    
    // 保存
    [viewParent addSubview:controlLink];
    [controlLink release];
    
    //验证码UI
    identifyCodeView = [[TrainIdentifyiCodeView alloc] initWithFrame:CGRectMake(0, imageViewArrow.frame.origin.y+imageViewArrow.frame.size.height+spaceYStart+3, SCREEN_WIDTH, cell_height_normal)];
    [viewParent addSubview:identifyCodeView];
    [identifyCodeView setTitle:@"验证码"];
    identifyCodeView.textField.tag=VERRIFYCODE_FIELD_TAG;
    [identifyCodeView.getIdentifyCodeBtn addTarget:self action:@selector(getIdentifyCode:) forControlEvents:UIControlEventTouchUpInside];
    identifyCodeView.textField.delegate=self;
    [identifyCodeView release];
    identifyCodeView.hidden=YES;
    
    if ([TrainIdenfyCodeModel isIdentifyCodeGetSuccess])
    {
        //验证码可见
        if ([TrainIdenfyCodeModel isNeedIdentifyCode])
        {
            [self setIdentifyCodeViewHidden:NO];
            //刷新验证码
            [self getIdentifyCode:nil];
        }
        else
        {
           //默认不可见
        }
    }
    else
    {
        //预加载失败，重新请求
        [self sendIdentifyCodeRequest];
    }
    
    BOOL isSupportStudentTicket = [self supportStudentTicket];
    // 添加学生票提示
    if (isSupportStudentTicket) {
        CGSize size = CGSizeMake(SCREEN_WIDTH, CGFLOAT_MAX);//LableWight标签宽度，固定的
        CGSize studentTipsSize = [staticStudentTips sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        
        // 学生票规则文字
        NSString *studentRuleTip = @"学生票规则";
        UIFont *studentRuleFont = [UIFont systemFontOfSize:12.0f];
        CGSize studentRuleSize = [studentRuleTip sizeWithFont:studentRuleFont];
        
        UIView *studentTipBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, identifyCodeView.frame.origin.y + identifyCodeView.frame.size.height, studentTipsSize.width, studentTipsSize.height + 2 + studentRuleSize.height)] autorelease];
        studentTipBackgroundView.backgroundColor = [UIColor clearColor];
        studentTipBackgroundView.tag = kTrainOrderFooterStudentTipLabelTag;

        AttributedLabel *studentTipsLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(10, 2,studentTipBackgroundView.frame.size.width-20, studentTipBackgroundView.frame.size.height - studentRuleSize.height) wrapped:YES];
        [studentTipsLabel setBackgroundColor:[UIColor clearColor]];
         // [studentTipsLabel setText:staticStudentTips];
        studentTipsLabel.text = staticStudentTips;
        [studentTipsLabel setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:0 length:5];
        [studentTipsLabel setFont:FONT_13 fromIndex:0 length:5];
        
        [studentTipsLabel setColor:RGBACOLOR(140, 140, 140, 1)fromIndex:5 length:[staticStudentTips length]-5];
        [studentTipsLabel setFont:[UIFont systemFontOfSize:12.0f]fromIndex:5 length:[staticStudentTips length]-5];
        
//        [studentTipsLabel setAdjustsFontSizeToFitWidth:YES];
//        [studentTipsLabel setMinimumFontSize:10.0f];
        
        //[studentTipsLabel setTextAlignment:UITextAlignmentCenter];
        //[studentTipsLabel setTextCenter:YES];
//        studentTipsLabel.numberOfLines = 0;
//        studentTipsLabel.lineBreakMode = NSLineBreakByWordWrapping;//换行方式
        
        [studentTipBackgroundView addSubview:studentTipsLabel];
      
        
        
        UILabel *labelStudentRule = (UILabel *)[viewParent viewWithTag:kTrainOrderFooterStudentRuleTipLabelTag];
        if (labelStudentRule == nil)
        {
            labelStudentRule = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelStudentRule setBackgroundColor:[UIColor clearColor]];
            [labelStudentRule setTextColor:RGBACOLOR(29, 94, 226, 1)];
            [labelStudentRule setFont:ruleFont];
            
            [labelStudentRule setTag:kTrainOrderFooterStudentRuleTipLabelTag];
            [studentTipBackgroundView addSubview:labelStudentRule];
            [labelStudentRule release];
        }
        [labelStudentRule setFrame:CGRectMake(parentFrame.size.width - studentRuleSize.width - kTrainOrderFooterHMargin - 3, studentTipsSize.height + 2, studentRuleSize.width, studentRuleSize.height)];
        [labelStudentRule setText:studentRuleTip];
        
        // 事件按钮
        UIControl *controlLink = [[UIControl alloc] initWithFrame:CGRectMake(parentFrame.size.width - studentRuleSize.width - kTrainOrderFooterVMargin, studentTipsSize.height + 2, studentRuleSize.width, studentRuleSize.height)];
        [controlLink addTarget:self action:@selector(goStudentTicketTule) forControlEvents:UIControlEventTouchUpInside];
        [controlLink setBackgroundColor:[UIColor clearColor]];
        [studentTipBackgroundView addSubview:controlLink];
        [controlLink release];
        
        
        // 保存
        [viewFoot addSubview:studentTipBackgroundView];
        [studentTipsLabel release];
        
        CGRect rect = viewFoot.frame;
        rect.size.height += studentTipsSize.height + 3 + studentRuleSize.height;
        viewFoot.frame = rect;
        
    }
}

#pragma mark - PickerView
- (void)dismissSeatsPickerView {
    [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.seatsPickerView.frame = CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kSeatsPickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void)showSeatsPickerView
{
//    [_insurancePicker selectRow:_insuranceSelectIndex inComponent:0 animated:YES];
//    self.selectedInsuranceString = [_pickerViewDatasourceArray objectAtIndex:_insuranceSelectIndex];
    
    [_seatsPicker selectRow:_selectedIndex inComponent:0 animated:NO];
    [UIView animateWithDuration:0.5f animations:^{
        self.seatsPickerView.frame = CGRectMake(0.0f, SCREEN_HEIGHT - (kSeatsPickerViewHeight + NAVIGATION_BAR_HEIGHT), 320.0f, kSeatsPickerViewHeight + NAVIGATION_BAR_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}

- (void)createPickerView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT, 320.0f, kSeatsPickerViewHeight + NAVIGATION_BAR_HEIGHT)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.seatsPickerView = backgroundView;
    [self.view addSubview:_seatsPickerView];
    [backgroundView release];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    topView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    [topView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 0.5f)]];
    
    // title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:FONT_B18];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setTextColor:RGBACOLOR(52, 52, 52, 1)];
    [titleLabel setText:@"选择坐席"];
    [topView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [topView addSubview:topSplitView];
    [topSplitView release];
    
    // left button
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [leftBtn.titleLabel setFont:FONT_B16];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    [leftBtn release];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [rightBtn.titleLabel setFont:FONT_B16];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    [rightBtn release];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 180.0f)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    self.seatsPicker = pickerView;
    //    [pickerView selectRow:1 inComponent:0 animated:NO];
    //    [pickerView reloadComponent:0];
    
    [_seatsPickerView addSubview:topView];
    [_seatsPickerView addSubview:pickerView];
    
    [topView release];
    [pickerView release];
    
    NSUInteger index = 0;
    for (NSString *seatTicket in _mixedSeatsArray) {
        if ([seatTicket rangeOfString:_seatName].location != NSNotFound) {
            break;
        }
        index++;
    }
    self.selectedIndex = index;
    self.selectedSeatString = [_mixedSeatsArray objectAtIndex:_selectedIndex];
}

- (void)confirmBtnClick {
    //	if ([delegate respondsToSelector:@selector(roomSelectView:didSelectedRowAtIndex:)]) {
    //        [delegate roomSelectView:self didSelectedRowAtIndex:[viewPickerView selectedRowInComponent:0] + minRows - 1];
    //    }
    if ([_selectedSeatString rangeOfString:@"成人票"].location != NSNotFound) {
        self.isStudent = NO;
    }
    else if ([_selectedSeatString rangeOfString:@"学生票"].location != NSNotFound) {
        self.isStudent = YES;
    }
    
    if (_isStudent) {
        [Utils alert:@"学生票暂按成人票价收取，出票成功后，退还差价"];
    }
    
    self.seatName = [NSString stringWithFormat:@"%@", [_selectedSeatString substringWithRange:NSMakeRange(0, [_selectedSeatString length] - 3)]];
    
    
    // 更新一下底部价格
    TrainTickets *currentTicket = [[TrainReq shared] currentRoute];
    for (TrainSeats *iterSeat in currentTicket.arraySeats) {
        if ([iterSeat.name isEqualToString:_seatName]) {
            [[TrainReq shared] setCurrentSeat:iterSeat];
            seat = [[TrainReq shared] currentSeat];
            break;
        }
    }
    
    // 重置价格
    UILabel *labelPrice = (UILabel *)[self.view viewWithTag:kTrainOrderBottomOrderPriceLabelTag];
    if (labelPrice != nil)
    {
        NSString *orderPrice = [NSString stringWithFormat:@"%.1f", [seat.price floatValue] * passagerCount];
        
        [labelPrice setText:[orderPrice stringByReplacingOccurrencesOfString:@".0"withString:@""]];
    }
    
    [passagerList reloadData];
    
    [self dismissSeatsPickerView];
    
    [self adjustTheBottomTip];
}

- (void) cancelBtnClick{
    [self dismissSeatsPickerView];
}

#pragma -
#pragma mark - 验证码
//获取验证码
-(void) getIdentifyCode:(id) sender
{
    if (identifyCodeView.checkCodeIndicatorView.isAnimating)
    {
        return;
    }
    
    [self sendIdentifyCodeRequest];
    
    //begin loading
    [identifyCodeView.checkCodeIndicatorView startAnimating];
}

-(void) sendIdentifyCodeRequest
{
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:Yihua_OTA forKey:@"wrapperId"];
    NSString  *str = [dic JSONString];
    NSString * reqStr = [PublicMethods composeNetSearchUrl:@"mytrain" forService:@"certCode" andParam:str];
    
    if (identifyCodeRequest)
    {
        [identifyCodeRequest cancel];
        SFRelease(identifyCodeRequest);
    }
    
    //初始化数据
    self.utoken=nil;
    identifyCodeView.textField.text=nil;
    
    identifyCodeRequest = [[HttpUtil alloc] init];
    [identifyCodeRequest requestWithURLString:reqStr Content:nil StartLoading:NO EndLoading:NO Delegate:self];
}

//设置验证码可见性
-(void) setIdentifyCodeViewHidden:(BOOL) hidden
{
    //状态不同才设置
    if (hidden==identifyCodeView.hidden)
    {
        return;
    }
    
    @synchronized(identifyCodeView)
    {
        self.utoken=nil;
        identifyCodeView.textField.text=nil;
        
        int urgentTipViewOriginY = identifyCodeView.frame.origin.y;
        if (hidden)
        {
            identifyCodeView.hidden=YES;
        }
        else
        {
            identifyCodeView.hidden=NO;
            urgentTipViewOriginY=identifyCodeView.frame.origin.y+identifyCodeView.frame.size.height;
        }
        
        for(UIView *tipView in passagerList.tableFooterView.subviews){
            if([tipView isKindOfClass:[UrgentTipView class]]){
                CGRect frame = tipView.frame;
                frame.origin.y = urgentTipViewOriginY;
                tipView.frame = frame;
                
                viewFoot.frame=CGRectMake(viewFoot.frame.origin.x, viewFoot.origin.y, viewFoot.frame.size.width, urgentTipViewOriginY+tipView.frame.size.height);
                [passagerList setTableFooterView:viewFoot];
                break;
            }
     
        }
    }
}

//处理验证码数据
-(void) handleIdentifyCodeData:(NSDictionary *) dict
{
    NSData *data=nil;
    if (STRINGHASVALUE([dict safeObjectForKey:@"utoken"]))
    {
        data = [NSData dataWithBase64EncodedString:[dict safeObjectForKey:@"captcha"]];
    }
    else
    {
        //开关处于关闭状态
        [self setIdentifyCodeViewHidden:YES];
        return;
    }
    
    [self setIdentifyCodeViewHidden:NO];
    
    if (data)
    {
        UIImage *newimage = [[UIImage alloc] initWithData:data];
        identifyCodeView.checkCodeImageView.image=newimage;
        [newimage release];
    }
    else
    {
        return;
    }
    
    self.utoken=[dict safeObjectForKey:@"utoken"];
}

#pragma mark - Button
- (void)clickCheckBox:(CheckBoxButton *)sender
{
    // 切换支付宝类型（以后再支持）
    
}


- (void)clickCommitBtn
{
    if ([self checkInfoRight])
    {
        [self.view endEditing:YES];
        [self recordRassengersInfo];    // 先存储一下信息
        
        NSMutableArray *passengers = [NSMutableArray arrayWithCapacity:3];
        
        NSString *ticketType;
        if (_isStudent) {
            ticketType = @"3";
        }
        else {
            ticketType = @"1";
        }
        
        // 纪录票数
        TrainReq *req = [TrainReq shared];
        req.currentTicketNum = passagerCount;
        
        
        TrainDepartStation *departStation = [[req currentRoute] departInfo];
        
        // 提交订单
        for (Passenger *passenger in passengersArray)
        {
            NSString *passengerName = passenger.name;
            passengerName = [[passengerName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" /"]] componentsJoinedByString:@""];
            
            
            // 固定属性重新赋值
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 passengerName, k_name,
                                 phoneNumber, k_mobile,
                                 passenger.certType, k_certType,
                                 [StringEncryption DecryptString:passenger.certNumber], k_certNumber,
                                 ticketType, k_passengerType,
                                 seat.code, k_seatCode,
                                 seat.price, k_price,
                                 [departStation time], k_depart_time,
                                 nil];
            
            [passengers addObject:dic];
        }
        
        TrainCommitOrderAppendData *otherData=[TrainCommitOrderAppendData new];
        if (identifyCodeView.hidden==NO)
        {
            NSString *verifyCode =  [identifyCodeView.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            otherData.captcha=verifyCode;//验证码
            otherData.utoken=self.utoken;//token
        }

        // 发起请求
        [HttpUtil requestURL:[PublicMethods composeNetSearchUrl:@"mytrain" forService:@"submitOrder"] postContent:[TrainReq submitOrderByPassengers:passengers mobilePhone:phoneNumber otherData:otherData] delegate:self];
        
        [otherData release];
        
        if (UMENG) {
            // 提交订单记录车次和座次信息
            [MobClick event:Event_TrainOrder_Confirm label:ticket.number];
        }
        
        UMENG_EVENT(UEvent_Train_FillOrder_Pay)
    }
}

- (void)clickAddressBookBtn:(id)sender
{
    // 点击电话簿按钮
    [self.view endEditing:YES];
    
    // 收回票数选择
//    [ticketNumSelectView dismissInView];
    [self dismissSeatsPickerView];
    
    CustomAB *picker = [[CustomAB alloc] initWithContactStyle:3];
    picker.delegate = self;
    UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:picker];
    
    if (IOSVersion_7) {
        naviCtr.transitioningDelegate = [ModalAnimationContainer shared];
        naviCtr.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:naviCtr animated:YES completion:nil];
    }else{
        [self presentModalViewController:naviCtr animated:YES];
    }
    [picker release];
    [naviCtr release];
    
    UMENG_EVENT(UEvent_Train_FillOrder_AddressBook)
}


- (void)clickCustomerSelBtn
{
    // 点击联系人按钮
    [self.view endEditing:YES];
    
    // 收回票数选择
//    [ticketNumSelectView dismissInView];
    [self dismissSeatsPickerView];
    
    // 刷新乘客列表中选择状态
    [self refreshPassageCheckStatus];
    
    PassengerListVC *list = [[PassengerListVC alloc] initWithTicketCount:passagerCount reqPassengerListOver:reqListOver passengerType:PassengerTypeTrain];
    list.delegate = self;
    [self.navigationController pushViewController:list animated:YES];
    [list release];
    
    if (!reqListOver)
    {
        // 本页如果还没有预加载完列表也取消请求
        [getCustomerListUtil cancel];
    }
    
    UMENG_EVENT(UEvent_Train_FillOrder_PersonSelect)
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 房间数量选择
    NSInteger count = 1;
    
    // 房间入住人提示
    count++;
    
    // 房间入住人
    count = count + passagerCount;
    
    // 选择学生票
//    if (_isStudent) {
//        count++;
//    }
    
    // 联系人手机
    count++;
    
    return count;
    
}


- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell_height_normal;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TableView属性
    NSInteger row = [indexPath row];
    
    if (row == 0)
    {
        // 票数选择
        static NSString *cellIdentifier = @"OrderInfoCell";
        TrainOrderCell *cell = (TrainOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell)
        {
            cell = [[[TrainOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        
        if (_isStudent) {
            [cell setTitle:[NSString stringWithFormat:@"%@学生票", _seatName]];
        }
        else {
            [cell setTitle:[NSString stringWithFormat:@"%@成人票", _seatName]];
        }
        
//        [cell setTitle:_seatName];
        [cell setDetail:[NSString stringWithFormat:@"%d张", passagerCount]];
        [cell setUnitPrice:[NSString stringWithFormat:@"( ¥%@/张)",seat.price]];
        
        return cell;
    }
    // 乘车人标题
    else if (row == 1)
    {
        NSString *reusedIdentifier = @"OrderLinkmanTitleCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
        if(cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:reusedIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        // ===========================================
        // 底分隔线
        // ===========================================
        UIImageView *bottomLine = (UIImageView *)[cell.contentView viewWithTag:kTrainOrderCellPassageBottomLineTag];
        if (bottomLine == nil)
        {
            bottomLine = [[UIImageView alloc] initWithFrame:CGRectZero];
            bottomLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
            [bottomLine setAlpha:0.5];
            [bottomLine setTag:kTrainOrderCellPassageBottomLineTag];
            [cell.contentView addSubview:bottomLine];
            [bottomLine release];
        }
        [bottomLine setFrame:CGRectMake(0, cell_height_normal-1, SCREEN_WIDTH, 1)];
        [bottomLine setHidden:(passagerCount == 0)?YES:NO];
        
        // ===========================================
        // 标题
        // ===========================================
        NSString *passageTitle = @"乘车人";
        CGSize titleSize = [passageTitle sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:17.0f]];
        
        UILabel *labelTitle = (UILabel *)[cell.contentView viewWithTag:kTrainOrderCellPassageTitleLabelTag];
        if (labelTitle == nil)
        {
            labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTitle setBackgroundColor:[UIColor clearColor]];
            [labelTitle setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:17.0f]];
            [labelTitle setTextColor:RGBCOLOR(93, 93, 93, 1)];
            [labelTitle setTag:kTrainOrderCellPassageTitleLabelTag];
            // 保存
            [cell.contentView addSubview:labelTitle];
            [labelTitle release];
        }
        [labelTitle setFrame:CGRectMake(kTrainOrderCellHMargin, (cell_height_normal-titleSize.height)/2, titleSize.width, titleSize.height)];
        [labelTitle setText:passageTitle];
        
        if ([AccountManager instanse].isLogin)
        {
            // ===========================================
            // 竖分隔线
            // ===========================================
            UIImageView *splitView = (UIImageView *)[cell.contentView viewWithTag:kTrainOrderCellPassageSplitViewTag];
            if (splitView == nil)
            {
                splitView = [[UIImageView alloc] initWithFrame:CGRectZero];
                splitView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
                [splitView setTag:kTrainOrderCellPassageSplitViewTag];
                [cell.contentView addSubview:splitView];
                [splitView release];
            }
            [splitView setFrame:CGRectMake(SCREEN_WIDTH - 44, 1, SCREEN_SCALE, cell_height_normal - 4)];
            
            // ===========================================
            // 添加联系人按钮
            // ===========================================
            UIButton *buttonAddPassager = (UIButton *)[cell.contentView viewWithTag:kTrainOrderCellAddPassagerButtonTag];
            if (buttonAddPassager == nil)
            {
                buttonAddPassager = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [buttonAddPassager setImage:[UIImage noCacheImageNamed:@"customer_icon.png"] forState:UIControlStateNormal];
                
                [buttonAddPassager addTarget:self action:@selector(clickCustomerSelBtn) forControlEvents:UIControlEventTouchUpInside];
                [buttonAddPassager setTag:kTrainOrderCellAddPassagerButtonTag];
                // 保存
                [cell.contentView addSubview:buttonAddPassager];
            }
            [buttonAddPassager setFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, cell_height_normal)];
            
        }
        
        
        return cell;
    }
    else if (row == passagerCount + 2)
    {
        // 联系人电话
        static NSString *identifier = @"OrderLinkmanCell";
        HotelOrderLinkmanCell *cell = (HotelOrderLinkmanCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[[HotelOrderLinkmanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        [cell setTitle:@"联系人手机"];
        cell.textField.text = phoneNumber;
        cell.textField.tag=PHONENUM_TEXT_FIELD_TAG;
        cell.textField.keyboardType = UIReturnKeyDone;
        [cell.addressBoomBtn addTarget:self action:@selector(clickAddressBookBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.textField.delegate = self;
        cell.topLine.hidden = NO;
        return cell;
    }
    else
    {
        // 乘客列表
        static NSString *identi = @"identi";
        TrainPassagerCell *cell = (TrainPassagerCell *)[tableView dequeueReusableCellWithIdentifier:identi];
        if (!cell)
        {
            cell = [[[TrainPassagerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi cellHeight:cell_height_normal] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            cell.backgroundView.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"乘客%d", indexPath.row-1];
        
        Passenger *passenger = [passengersArray safeObjectAtIndex:indexPath.row - 2];
        if (passenger)
        {
            // 如果是身份证隐藏后4位
            NSString *certType = [TrainFillOrderVC getCertTypeNameByTypeEnum:passenger.certType];
            NSString *certNum = [StringEncryption DecryptString:passenger.certNumber];
            if ([certType isEqualToString:@"身份证"])
            {
                if ([certNum length] > 4)
                {
                    certNum = [certNum stringByReplaceWithAsteriskFromIndex:[certNum length]-4];
                }
            }
            cell.titleLabel.hidden = YES;
            cell.certLabel.hidden = NO;
            cell.certLabel.textAlignment = UITextAlignmentLeft;
            cell.certLabel.textColor = RGBCOLOR(52, 52, 52, 1);
            cell.certLabel.text = [NSString stringWithFormat:@"%@/%@/%@", passenger.name, certType, certNum];
            
        }
        else
        {
            cell.certLabel.hidden = YES;
            cell.titleLabel.hidden = NO;
        }
        
        if (indexPath.row == passagerCount+1)
        {
            cell.splitView.hidden = YES;
        }
        else
        {
            cell.splitView.hidden = NO;
            cell.splitView.frame = CGRectMake(12, cell_height_normal - 1, SCREEN_WIDTH - 12, 1);
        }
        
        return cell;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGSize viewHeaderSize = CGSizeMake(tableView.frame.size.width, 0);
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewHeaderSize.width, viewHeaderSize.height)];
    [self setupTableViewHeaderSubs:viewFooter inSection:section inSize:&viewHeaderSize];
    
    return [viewFooter autorelease];
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

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 160.0f)] autorelease];
//    footerView.backgroundColor = [UIColor yellowColor];
//    return footerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 160.0f;
//}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 得到要删除的section 和 row
    NSInteger row = [indexPath row];
    
    // 房间数
    if (row == 0)
    {
    }
    // 乘客标题
    else if (row == 1)
    {
    }
    // 手机
    else if (row == passagerCount+2)
    {
    }
    // 乘车人信息
    else
    {
        if (passengersArray && [passengersArray count]>row-2)
        {
            [passengersArray removeObjectAtIndex:row-2];
            
            // 还得显示坑爹的乘车人1
            if ([AccountManager instanse].isLogin && [passengersArray count] > 0) {
                passagerCount--;
            }
            
            [tableView reloadData];
            
            // 重置价格
            UILabel *labelPrice = (UILabel *)[self.view viewWithTag:kTrainOrderBottomOrderPriceLabelTag];
            if (labelPrice != nil)
            {
                NSString *orderPrice = [NSString stringWithFormat:@"%.1f", [seat.price floatValue] * passagerCount];
                
                [labelPrice setText:[orderPrice stringByReplacingOccurrencesOfString:@".0"withString:@""]];
            }
        }
        
        //恢复非编辑状态
        if ([passengersArray count] == 0) {
            [tableView setEditing:NO];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    // 房间数
    if (row == 0)
    {
        return NO;
    }
    // 乘客标题
    else if (row == 1)
    {
        return NO;
    }
    // 手机
    else if (row == passagerCount+2)
    {
        return NO;
    }
    // 乘车人信息
    else
    {
        Passenger *passenger = [passengersArray safeObjectAtIndex:indexPath.row - 2];
        if (passenger)
        {
            return YES;
        }
        
    }
    
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    
    // 房间数
    if (row == 0)
    {
        return UITableViewCellEditingStyleNone;
    }
    // 乘客标题
    else if (row == 1)
    {
        return UITableViewCellEditingStyleNone;
    }
    // 手机
    else if (row == passagerCount+2)
    {
        return UITableViewCellEditingStyleNone;
    }
    // 乘车人信息
    else
    {
        Passenger *passenger = [passengersArray safeObjectAtIndex:indexPath.row - 2];
        if (passenger)
        {
            return UITableViewCellEditingStyleDelete;
        }
    }
    
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    [self.view endEditing:YES];
    
    if (row == 0)
    {
        // 点击选择票数
//        if (!ticketNumSelectView)
//        {
////            ticketNumSelectView = [[CommonSelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 400) title:@"选择票数"];
//            ticketNumSelectView = [[CommonSelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 400) title:@"选择坐席"];
//            ticketNumSelectView.originNumer = 1;
////            NSInteger maxTicketNum = [seat.yupiao intValue];
////            if (maxTicketNum > MAX_TICKET_NUM)
////            {
////                maxTicketNum = MAX_TICKET_NUM;
////            }
////            if (maxTicketNum <= 0) {
////                maxTicketNum = MAX_TICKET_NUM;
////            }
////            ticketNumSelectView.measureWord = @"张";
////            ticketNumSelectView.maxRows = maxTicketNum;
//            ticketNumSelectView.selectedRow = passagerCount - 1;
//            ticketNumSelectView.delegate = self;
//            [self.view addSubview:ticketNumSelectView];
//            [ticketNumSelectView release];
//        }
//        
//        // 如果vouchView存在，隐藏之
//        if (ticketNumSelectView.isShowing)
//        {
//            [ticketNumSelectView dismissInView];
//        }
//        else
//        {
//            [ticketNumSelectView showInView];
//        }
        if (!_seatsPickerView) {
            [self createPickerView];
        }
        
        [self showSeatsPickerView];
    }
    // 乘车人标题
    else if (row == 1)
    {
        
    }
    else if(row == passagerCount + 2)
    {
        // 联系人电话
        
    }
    // 乘车人
    else
    {
//        if (ticketNumSelectView.isShowing)
//        {
//            [ticketNumSelectView dismissInView];
//        }
        [self dismissSeatsPickerView];
        
        // 点击乘客选择
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!delegate.isNonmemberFlow)
        {
            
        }
        else
        {
            // 非会员流程
            AddOrEditPassengerVC *controller = [[AddOrEditPassengerVC alloc] initWithAllPassengers:passengersArray type:PassengerTypeTrain];
            controller.delegate = self;
            Passenger *passenger = [passengersArray safeObjectAtIndex:indexPath.row - 2];
            if (passenger)
            {
                NSDictionary *passengerDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                              passenger.name, NAME_RESP,
                                              passenger.certNumber, IDNUMBER,
                                              [TrainFillOrderVC getCertTypeNameByTypeEnum:passenger.certType], IDTYPENAME, nil];
                
                // 如果本行已经有乘客，变为修改乘客
                [controller setModifyPassenger:passengerDic];
            }
            currentPassagerIndex = indexPath.row - 2;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            
            if (IOSVersion_7) {
                nav.transitioningDelegate = [ModalAnimationContainer shared];
                nav.modalPresentationStyle = UIModalPresentationCustom;
            }
            if (IOSVersion_7) {
                [self presentViewController:nav animated:YES completion:nil];
            }else{
                [self presentModalViewController:nav animated:YES];
            }
            [controller release];
            [nav release];
        }
    }
    
    
    
    [self performSelector:@selector(deSelectedCellAtIndex:) withObject:indexPath afterDelay:0.2];
}


// 取消列表执行项的选中状态
- (void)deSelectedCellAtIndex:(NSIndexPath *)indexPath
{
    [passagerList deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - CustomABDelegate

- (void)getSelectedString:(NSString *)selectedStr
{
	// 填充电话
    self.phoneNumber = [selectedStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [passagerList reloadData];
}


#pragma mark - CommonSelectViewDelegate

- (void)selectView:(CommonSelectView *)roomSelectView didSelectedNumber:(NSInteger)number
{
    // 删除多余的联系人
    if (number < passagerCount)
    {
        if ([passengersArray count] > number)
        {
            [passengersArray removeObjectsInRange:NSMakeRange(number, [passengersArray count] - number)];
            
            NSInteger count = 0;
            for (NSMutableDictionary *dic in [PassengerListVC allPassengers])
            {
                if (count < number)
                {
                    if ([[dic objectForKey:k_checked_key] boolValue])
                    {
                        count ++;
                    }
                }
                else
                {
                    [dic setObject:[NSNumber numberWithBool:NO] forKey:k_checked_key];
                }
            }
        }
    }
    
    // 重置乘客数
    passagerCount = number;
    
    // 重置价格
    UILabel *labelPrice = (UILabel *)[self.view viewWithTag:kTrainOrderBottomOrderPriceLabelTag];
    if (labelPrice != nil)
    {
        NSString *orderPrice = [NSString stringWithFormat:@"%.1f", [seat.price floatValue] * passagerCount];
        
        [labelPrice setText:[orderPrice stringByReplacingOccurrencesOfString:@".0"withString:@""]];
    }
    
    [passagerList reloadData];
    
    UMENG_EVENT(UEvent_Train_FillOrder_Num)
}


#pragma mark - Passenger Delegate
- (void)selectedPassengersArray:(NSArray *)array
{
    [passengersArray removeAllObjects];     // 清空上一组显示情况
    
    passagerCount = 0;
    for (NSDictionary *dict in array)
    {
        if ([[dict safeObjectForKey:k_checked_key] boolValue])
        {
            Passenger *passenger = [[Passenger alloc] init];
            passenger.name = [dict objectForKey:NAME_RESP];
            if ([[dict objectForKey:IDTYPE] safeIntValue] == 0)
            {
                // 身份证的情况
                passenger.certType = CODE_IDENTICARD;
            }
            else if([[dict objectForKey:IDTYPE] safeIntValue] == 3)
            {
                // 港澳通行证的情况
                passenger.certType = CODE_GATEPASS_GANGAO;
            }
            else if([[dict objectForKey:IDTYPE] safeIntValue] == 4)
            {
                // 护照的情况
                passenger.certType = CODE_PASSPORT;
            }
            
            passenger.certNumber = [dict objectForKey:IDNUMBER];
            [passengersArray addObject:passenger];
            [passenger release];
            
            passagerCount++;
        }
    }
    
    //恢复非编辑状态
    if ([passengersArray count] == 0) {
        [passagerList setEditing:NO];
    }
    else {
        [passagerList setEditing:YES];
    }
    
    // 重置价格
    UILabel *labelPrice = (UILabel *)[self.view viewWithTag:kTrainOrderBottomOrderPriceLabelTag];
    if (labelPrice != nil)
    {
        NSString *orderPrice = [NSString stringWithFormat:@"%.1f", [seat.price floatValue] * passagerCount];
        
        [labelPrice setText:[orderPrice stringByReplacingOccurrencesOfString:@".0"withString:@""]];
    }
    
    [passagerList reloadData];
}


- (void)passengerListReqIsOver
{
    reqListOver = YES;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    viewResponder = textField;
    if ([textField isKindOfClass:[CustomTextField class]])
    {
        CustomTextField *linkmanField = (CustomTextField *)textField;
        [linkmanField resetTargetKeyboard];
        linkmanField.numberOfCharacter = 11;
        linkmanField.abcEnabled = NO;
        [linkmanField showNumKeyboard];
    }
    
    // 如果票数选择页面存在，隐藏之
//    if (ticketNumSelectView.isShowing)
//    {
//        [ticketNumSelectView dismissInView];
//    }
    [self dismissSeatsPickerView];
    
    return YES;
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isMemberOfClass:[CustomTextField class]])
    {
        if (textField.tag==PHONENUM_TEXT_FIELD_TAG)
        {
            NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
            self.phoneNumber = tagStr;
            if (phoneNumber.length >= 11) {
                self.phoneNumber = [phoneNumber substringToIndex:11];
                return YES;
            }
        }
    }
    
    return YES;
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util==identifyCodeRequest)
    {
        [identifyCodeView.checkCodeIndicatorView stopAnimating];
        
        [self setIdentifyCodeViewHidden:NO];
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if (util == getCustomerListUtil)
    {
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            return;
        }
        
        // 在本页获取到乘客列表的情况
        NSArray *passergers = [root safeObjectForKey:CUSTOMERS];
        for (NSMutableDictionary *customer in passergers)
        {
            if (STRINGHASVALUE([customer safeObjectForKey:NAME_RESP]))
            {
                [customer safeSetObject:[NSNumber numberWithBool:NO] forKey:k_checked_key];
                
                // 火车票只展示4种类型的证件
                if ([[customer objectForKey:IDTYPEENUM] isEqualToString:IDCARD] ||
                    [[customer objectForKey:IDTYPEENUM] isEqualToString:GANGAO] ||
                    [[customer objectForKey:IDTYPEENUM] isEqualToString:TAIWAN] ||
                    [[customer objectForKey:IDTYPEENUM] isEqualToString:PASSPORT])
                {
                    [[PassengerListVC allPassengers] addObject:customer];
                }
            }
        }
        
        reqListOver = YES;
    }
    else if (util==identifyCodeRequest)
    {
        [identifyCodeView.checkCodeIndicatorView stopAnimating];
        
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        //开关关闭
        if ([[root safeObjectForKey:@"IsError"] boolValue])
        {
            [self setIdentifyCodeViewHidden:YES];
            return;
        }
        
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            [self setIdentifyCodeViewHidden:NO];
            return;
        }
        
        [self handleIdentifyCodeData:root];
    }
    else
    {
        //验证码错误，刷新
        if ([[root safeObjectForKey:@"ErrorCode"] intValue]==116)
        {
            if (identifyCodeView.hidden==NO)
            {
                [Utils alert:[root safeObjectForKey:@"ErrorMessage"]];
                [self getIdentifyCode:nil];
                return;
            }
        }
        
        if ([Utils checkJsonIsError:root])
        {
            return ;
        }
        
        // 获取订单信息
        TrainOrderSuccessVC *controller = [[TrainOrderSuccessVC alloc] initWithOrderInfo:root isStudent:self.isStudent];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


#pragma mark - AddOrEditPassengerDelegate
- (void)didReceiveANewPassenger:(NSDictionary *)dict
{
    // 获取到一个新乘客后，刷新本页页面
    Passenger *passenger = [[[Passenger alloc] init] autorelease];
    passenger.name = [dict objectForKey:NAME_RESP];
    if ([[dict objectForKey:IDTYPE] safeIntValue] == 0)
    {
        // 身份证的情况
        passenger.certType = CODE_IDENTICARD;
    }
    else if([[dict objectForKey:IDTYPE] safeIntValue] == 3)
    {
        // 港澳通行证的情况
        passenger.certType = CODE_GATEPASS_GANGAO;
    }
    else if([[dict objectForKey:IDTYPE] safeIntValue] == 4)
    {
        // 护照的情况
        passenger.certType = CODE_PASSPORT;
    }
    
    passenger.certNumber = [dict objectForKey:IDNUMBER];
    
    if ([passengersArray count] > currentPassagerIndex)
    {
        Passenger *oldPassenger = [passengersArray objectAtIndex:currentPassagerIndex];
        if (oldPassenger) {
            // 有则替换
            [passengersArray replaceObjectAtIndex:currentPassagerIndex withObject:passenger];
            [passagerList reloadData];
            return;
        }
    }
    
    // 无则增加
    [passengersArray addObject:passenger];
    
    //恢复非编辑状态
    if ([passengersArray count] == 0) {
        [passagerList setEditing:NO];
    }
    else {
        [passagerList setEditing:YES];
    }
    
    [passagerList reloadData];
}

- (void)didReceiveAEditPassenger:(NSDictionary *)passenger
{
    // 获取到一个新乘客后，刷新本页页面
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:passenger];
    [dic setObject:[NSNumber numberWithBool:YES] forKey:k_checked_key];     // 自动勾选
    [dic setObject:[NSNumber numberWithBool:YES] forKey:k_new_key];         // 标记为新乘客，不隐藏身份证号
    
    //    NSUInteger passengerIndex = 0;
    //    for (NSMutableDictionary *editPassenger in allPassengers) {
    //        if ([[editPassenger safeObjectForKey:@"Name"] isEqualToString:[passenger safeObjectForKey:@"Name"]]) {
    //            break;
    //        }
    //        passengerIndex++;
    //    }
    
    Passenger *passengerClass = [[[Passenger alloc] init] autorelease];
    passengerClass.name = [passenger objectForKey:NAME_RESP];
    if ([[passenger objectForKey:IDTYPE] safeIntValue] == 0)
    {
        // 身份证的情况
        passengerClass.certType = CODE_IDENTICARD;
    }
    else if([[passenger objectForKey:IDTYPE] safeIntValue] == 3)
    {
        // 港澳通行证的情况
        passengerClass.certType = CODE_GATEPASS_GANGAO;
    }
    else if([[passenger objectForKey:IDTYPE] safeIntValue] == 4)
    {
        // 护照的情况
        passengerClass.certType = CODE_PASSPORT;
    }
    
    passengerClass.certNumber = [passenger objectForKey:IDNUMBER];
    
    if (currentPassagerIndex != [passengersArray count]) {
        [passengersArray replaceObjectAtIndex:currentPassagerIndex withObject:passengerClass];
        
        [passagerList reloadData];
        [passagerList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentPassagerIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

#pragma mark - UIPickerView datasource
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_mixedSeatsArray count];
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 320.0f;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedSeatString = [_mixedSeatsArray safeObjectAtIndex:row];
    self.selectedIndex = row;
//    if (1 == row) {
//        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
//            self.selectedInsuranceCount = 2;
//        }
//        else {
//            self.selectedInsuranceCount = 1;
//        }
//        self.insuranceSelectIndex = 1;
//    }
//    else {
//        self.selectedInsuranceCount = 0;
//        self.insuranceSelectIndex = 0;
//    }
//    
//    if (row < [_pickerViewDatasourceArray count]) {
//        self.selectedInsuranceString = [_pickerViewDatasourceArray objectAtIndex:row];
//    }
    //    self.selectedInsuranceCount = row;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row < [_mixedSeatsArray count]) {
        return [_mixedSeatsArray objectAtIndex:row];
    }
    
    return @"";
}

@end
