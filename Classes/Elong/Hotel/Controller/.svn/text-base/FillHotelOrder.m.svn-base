//
//  HotelFillOrder.m
//  ElongClient
//
//  Created by bin xing on 11-1-5.
//  Copyright 2011 DP. All rights reserved.
//

#import "FillHotelOrder.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import	"HotelVouchTimeRequest.h"
#import "StringFormat.h"
#import "ArriveTime.h"
#import "HotelDetailController.h"
#import "EmbedTextField.h"
#import "HotelOrderCell.h"
#import "HotelOrderLinkmanCell.h"
#import "RoomSelectView.h"
#import "SelectRoomer.h"
#import "CouponIntroductionController.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"
#import "PaymentTypeVC.h"
#import "AccountManager.h"
#import "GrouponInvoiceFillController.h"
#import "FlightDataDefine.h"
#import "HotelOrderInvoiceCell.h"
#import "AddAddress.h"
#import "MBSwitch.h"
#import "UniformCounterViewController.h"
#import "UniformWeiXinModel.h"
#import "UniformWapAlipayModel.h"
#import "HotelRoomBedsRequest.h"
#import "UrgentTipManager.h"
#import "CountlyEventHotelFillinOrderPageNextStep.h"
#import "CountlyEventShow.h"
#import "RoomTypeCell.h"
#import "AttributedLabel.h"
#import "HomeAdWebViewController.h"
#import "HotelPromotionInfoRequest.h"
#import "XGHttpRequest.h"
#import "XGApplication.h"
#import "NSString+URLEncoding.h"
#import "XGApplication+Common.h"
#import "XGHelper.h"
#define SELECTCARD_STATE 2
#define CHECKROOMCOUNT	 3
#define CHECK_CASHACCOUNT 4         // 检测现金账户是否可用
#define NET_TYPE_ADDRESS  5         // 获取邮寄地址
#define NET_TYPE_ADDRESS_ZHIFUBAO  6
#define NET_TYPE_BANKLIST  7
#define TEXT_FIELD_TAG 5011
#define INVOICE_FIELD_TAG 4011
#define COUPON_TIPS_TAG 6001

#define kTickImageTag       5401
#define kPayTypeTableTag    5402

static int MAX_ROOM_COUNT = 10;

@interface FillHotelOrder ()<SelectCard_C2C_Delegate>

@property (nonatomic, assign) NSUInteger selectIndex;
@property (nonatomic, retain) UIButton *nextBtn;
@property (nonatomic, copy) NSString *currencyMark;
@property (nonatomic, retain) UIButton *creditCardButton;
@property (nonatomic,copy) NSString *specialTips;
@property (nonatomic,assign) BOOL bedSelectable;
@property (nonatomic,assign) NSInteger invoiceIndex;
@property (nonatomic,copy) NSString *invoiceType;
@property (nonatomic,copy) NSString *invoiceTitle;
@property (nonatomic,assign) VouchSetType vouchSetType;

@end

@implementation FillHotelOrder

@synthesize nextBtn;
@synthesize vouchTips;
@synthesize isSkipLogin;
@synthesize currencyMark;
@synthesize linkman;
@synthesize requestOver;
@synthesize specialTips;
@synthesize bedSelectable;
@synthesize vouchSetType;

- (void)viewDidUnload
{
    [super viewDidUnload];
	
	self.nextBtn = nil;
}

- (void)dealloc
{
    orderInfoList.delegate=nil;
    orderInfoList.dataSource=nil;
    
    // 预加载联系人请求终止
    if (getRoomerUtil) {
        [getRoomerUtil cancel];
        SFRelease(getRoomerUtil);
    }
    
    // 邮寄地址请求
    if (addressUtil) {
        [addressUtil cancel];
        SFRelease(addressUtil);
    }
    
    if (bedTipsUtil)
    {
        [bedTipsUtil cancel];
        SFRelease(bedTipsUtil);
    }
    
    [hotelconfirmorder release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [vouchConditions release];
    [nameArray release];
    vouchView.delegate=nil;
    [vouchView release];
    specialView.delegate=nil;
    [specialView release];
    invoiceSelect.delegate=nil;
    [invoiceSelect release];
    [invoiceAddresses release];
	
	self.nextBtn = nil;
    self.currencyMark = nil;
    self.vouchTips = nil;
    self.linkman = nil;
    self.specialTips = nil;
    self.invoiceType = nil;
    self.invoiceTitle = nil;
    
    [_creditCardButton release];
    
    [[UrgentTipManager sharedInstance] cancelUrgentTip];
    [super dealloc];
}

#pragma mark -
#pragma mark lifecycle

- (id)init
{
	if (self = [super initWithTopImagePath:nil andTitle:@"填写订单" style:_NavNoTelStyle_]) {
	}
	return self;
}

- (void)initData
{
    [[SelectRoomer allRoomers] removeAllObjects];
    
    self.isSkipLogin = NO;
    currentTimeIndex = 0;
    needVouch = NO;
    requestOver = NO;
    addressEnabled = YES;
    canUseCA = NO;
    self.vouchSetType = VouchSetTypeCreditCard;
    
    self.invoiceType = @"会务费";
    
    /**************** 预加载联系人 **********************/
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!delegate.isNonmemberFlow) {
        // 会员预加载酒店入住人信息
        [self requestForRoomer];
    }
    
    
    /*************** 常用联系人姓名 ********************/
    nameArray = [[NSMutableArray alloc] initWithCapacity:MAX_ROOM_COUNT];
    for (int i = 0; i < MAX_ROOM_COUNT; i++) {
        [nameArray addObject:@""];
    }
    
    /**************** 联系人电话 *************/
    if (delegate.isNonmemberFlow) {
        // 加载历史记录信息
        self.linkman = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE];
    }else {
        // 会员流程
        self.linkman = [[AccountManager instanse] phoneNo];
    }
    
    /*************** 非会员和会员入住人 ************/
    // 超过12小时，清理数据
    NSArray *names = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_CHECKINPEPEOS];
    NSNumber *roomnum = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_ROOMNUM];
    if (roomnum) {
        roomcount = [roomnum intValue];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_CHECKINTIME]) {
        double timerInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_CHECKINTIME] doubleValue];
        if ([[NSDate date] timeIntervalSince1970] - timerInterval > 12 * 60 * 60) {
            names = nil;
            roomcount = 1;
        }
    }
    
    if(names){
        NSInteger count = 0;
        for (NSString *name in names) {
            if(![name isEqualToString:@""]){
                if (count < nameArray.count) {
                    [nameArray replaceObjectAtIndex:count withObject:name];
                }
                count++;
            }
        }
    }
    
    /*************** 获取床型信息，是否大床\双床可选 ****************/
    NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
    
    invoiceMode=1;
    if (dic&&[dic safeObjectForKey:@"InvoiceMode"]&&[dic safeObjectForKey:@"InvoiceMode"]!=[NSNull null])
    {
        invoiceMode=[[dic safeObjectForKey:@"InvoiceMode"] intValue];  //开发票方式（开发票方式（0表示没维护,1表示艺龙开发票,2表示酒店开发票）
        if (invoiceMode!=2) {
            invoiceMode=1;
        }
    }
    
    // 检测coupon是否可用
    self.couponEnabled = NO;
    if (roomcount == 0) {
        roomcount = 1;
        NSInteger coupon = [self getBackPrice];
        if (coupon) {
            self.couponEnabled = YES;
        }
        roomcount = 0;
    }else{
        NSInteger coupon = [self getBackPrice];
        if (coupon) {
            self.couponEnabled = YES;
        }
    }
    
    // 预加载床型信息
    [self requestForBedTips];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFillInfo:) name:ADDRESS_ADD_NOTIFICATION object:nil];
}

// 预加载联系人
- (void)requestForRoomer
{
    JCustomer *customer = [MyElongPostManager customer];
    [customer clearBuildData];
    [customer setCustomerType:3];
    
    getRoomerUtil = [[HttpUtil alloc] init];
    [getRoomerUtil connectWithURLString:MYELONG_SEARCH
                                Content:[customer requesString:NO]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
}

//预加载床型tips
-(void) requestForBedTips
{
    NSString *hotelId_ =  [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S];
    NSString *roomId_ = [[[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]] safeObjectForKey:ROOMTYPEID];
    NSString *shotelId_ =  [[[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]] safeObjectForKey:SHotelID];
    
    NSString *adT = [TimeUtils displayDateWithJsonDate: [[HotelPostManager hoteldetailer] getObject:ReqHD_CheckInDate_ED] formatter:@"yyyy-MM-dd"];
    NSString *ldT = [TimeUtils displayDateWithJsonDate:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckOutDate_ED] formatter:@"yyyy-MM-dd"];

    
    NSMutableDictionary *contents = [NSMutableDictionary dictionary];
    [contents setValue:hotelId_ forKey:@"hotelId"];
    [contents setValue:roomId_ forKey:@"roomId"];
    [contents setValue:shotelId_ forKey:@"sHotelId"];
    [contents setValue:adT forKey:@"checkInDate"];
    [contents setValue:ldT forKey:@"checkOutDate"];
    
    NSString *reqStr = [contents JSONString];
    
    if (bedTipsUtil) {
        [bedTipsUtil cancel];
        SFRelease(bedTipsUtil);
    }
    bedTipsUtil = [[HttpUtil alloc] init];
    [bedTipsUtil requestWithURLString:[PublicMethods composeNetSearchUrl:@"hotel" forService:@"bedTips" andParam:reqStr]
                           Content:nil
                      StartLoading:NO
                        EndLoading:NO
                          Delegate:self];
}
#pragma mark -
#pragma mark 界面加载

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    if (UMENG) {
        // 酒店订单页面
        [MobClick event:Event_HotelOrder];
    }
    
    // countly hotelfillinorderpage
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
    
    // 初始化数据
    [self initData];
    
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT - 44 - 20)] autorelease];
    
//    // logo
//    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 63 - 7, 0, 63, 44)];
//    logoView.image = [UIImage noCacheImageNamed:@"login_elongLogo.png"];
//    [self.view addSubview:logoView];
//    [logoView release];
    
    
    // 首晚最小入住房量（首晚入住至少4间房）
    roomTypeDic = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
    if ([RoomType currentRoomIndex] == 0) {
        self.cheapest = YES;
    }
	minCheckinRooms=[[roomTypeDic safeObjectForKey:@"MinCheckinRooms"] intValue];
    if (minCheckinRooms > roomcount) {
        roomcount = minCheckinRooms;
    }
    
    // 构造基础页面数据
    [self createOrderBaseView];
    
    // 恢复上一次的房间数量
    NSInteger count = 0;
    for (NSString *name in nameArray) {
        if (![name isEqualToString:@""]) {
            count++;
        }
    }
    if (count) {
        if (count >= roomcount) {
            roomcount = count;
            [self roomSelectView:nil didSelectedRowAtIndex:roomcount - 1];
        }
    }
    
    // 设置当前选中房间数量
    roomSelectView.selectedRow = roomcount - 1;
    
    if (IOSVersion_7 || (IOSVersion_4 && !IOSVersion_5)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
}

// 构造基础页面数据
- (void)createOrderBaseView
{
    // 背景纹理
    UIView *orderTextureView = [[UIView alloc] initWithFrame:self.view.bounds];
    //UIImage *bgImage = [UIImage noCacheImageNamed:@"order_texture.png"];
    //orderTextureView.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    [self.view addSubview:orderTextureView];
    [orderTextureView release];
    
    // 容器tableview
    orderInfoList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
    orderInfoList.backgroundColor = [UIColor clearColor];
    orderInfoList.backgroundView = nil;
    orderInfoList.delegate = self;
    orderInfoList.dataSource = self;
    [orderTextureView addSubview:orderInfoList];
    [orderInfoList release];
    orderInfoList.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderInfoList.separatorColor =[UIColor clearColor];
    //orderInfoList.separatorColor = [UIColor colorWithRed:153.0/255.0f green:153.0/255.0f blue:153.0/255.0f alpha:1];
    
    // 底部bar
    [self createBottomView];
    
    // 订单头部信息
    [self createOrderHeaderView];
    
    // 房间数量选择框
    [self createRoomSelectView];
    
    // 担保页面选择框
    [self createVouchView];
    
    // 特殊需求
//    [self createSpecialView];
    
    // 选择常用联系人按钮
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appDelegate.isNonmemberFlow) {
        [self createCustomerSelBtn];
    }
}

// 底部Bar
- (void) createBottomView{
    bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, SCREEN_WIDTH, 50)];
    bottomView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    bottomView.userInteractionEnabled = YES;
    [self.view addSubview:bottomView];
    [bottomView release];
    
    // 订单总价
    orderPriceLbl  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 90, 50)];
    orderPriceLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    orderPriceLbl.textColor = [UIColor whiteColor];
    orderPriceLbl.minimumFontSize = 14.0f;
    orderPriceLbl.adjustsFontSizeToFitWidth = YES;
    orderPriceLbl.textAlignment = UITextAlignmentLeft;
    [bottomView addSubview:orderPriceLbl];
    [orderPriceLbl release];
    orderPriceLbl.text = [self getHotelPrice:NO];
    orderPriceLbl.backgroundColor = [UIColor clearColor];
    
    // 返现提示
    couponLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 120, 50)];
    couponLbl.textColor = [UIColor whiteColor];
    couponLbl.font = FONT_12;
    couponLbl.numberOfLines = 2;
    couponLbl.adjustsFontSizeToFitWidth = YES;
    couponLbl.minimumFontSize = 10;
    [bottomView addSubview:couponLbl];
    [couponLbl release];
    couponLbl.backgroundColor = [UIColor clearColor];
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.isNonmemberFlow) {
        // 非会员不提示返现信息
        couponLbl.hidden = YES;
    }else{
        // 会员提示返现信息
        couponLbl.hidden = NO;
    }
    
    // 下一步按钮
    // 提交按钮
    UIButton *nextButton = nil;
    if ([RoomType isPrepay]) {
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else {
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setTitle:@"提交订单" forState:UIControlStateNormal];
    }
    
    
    self.nextBtn = nextButton;
    [self.nextBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.nextBtn setImage:nil forState:UIControlStateNormal];
    self.nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [self.nextBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 50);
    [bottomView addSubview:self.nextBtn];
    self.nextBtn.exclusiveTouch = YES;
}

// 订单头部信息酒店名、入离店日期和价格等
- (void)createOrderHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    
    // 酒店名
    hotelNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, SCREEN_WIDTH - 40, 20)];
    hotelNameLbl.font = [UIFont boldSystemFontOfSize:18.0f];
    hotelNameLbl.textColor = [UIColor colorWithRed:34.0/255.0f green:34.0/255.0f blue:34.0/255.0f alpha:1];
    hotelNameLbl.backgroundColor = [UIColor clearColor];
    hotelNameLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    hotelNameLbl.numberOfLines = 1;
    hotelNameLbl.adjustsFontSizeToFitWidth = YES;
    hotelNameLbl.minimumFontSize = 12.0f;
    [headerView addSubview:hotelNameLbl];
    [hotelNameLbl release];
    
    // 房型
    roomTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 34, SCREEN_WIDTH - 40, 20)];
    roomTypeLbl.font = [UIFont systemFontOfSize:16.0f];
    roomTypeLbl.textColor = [UIColor colorWithRed:34.0/255.0f green:34.0/255.0f blue:34.0/255.0f alpha:1];
    roomTypeLbl.backgroundColor = [UIColor clearColor];
    roomTypeLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    roomTypeLbl.numberOfLines = 1;
    roomTypeLbl.adjustsFontSizeToFitWidth = YES;
    roomTypeLbl.minimumFontSize = 12.0f;
    [headerView addSubview:roomTypeLbl];
    [roomTypeLbl release];
    
    // 入离日期
    checkInAndOutLbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 55, SCREEN_WIDTH - 40, 20)];
    checkInAndOutLbl.font = [UIFont systemFontOfSize:14.0f];
    checkInAndOutLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    checkInAndOutLbl.backgroundColor = [UIColor clearColor];
    [headerView addSubview:checkInAndOutLbl];
    [checkInAndOutLbl release];
    
    
    
 
    
    // 非会员返现提示
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    nomemberTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 26, SCREEN_WIDTH - 100, 20)];
    nomemberTipsLbl.font = [UIFont systemFontOfSize:11.0f];
    nomemberTipsLbl.textAlignment = UITextAlignmentLeft;
    nomemberTipsLbl.textColor = [UIColor whiteColor];
    nomemberTipsLbl.backgroundColor = [UIColor clearColor];
    nomemberTipsLbl.text = @"非会员不返现";
    [bottomView addSubview:nomemberTipsLbl];
    [nomemberTipsLbl release];
    if(delegate.isNonmemberFlow){
        nomemberTipsLbl.hidden = NO;
        if([RoomType isPrepay]){
            if (![self getRealCoupon]) {
                nomemberTipsLbl.hidden = YES;
            }else{
                nomemberTipsLbl.text = @"非会员不立减";
            }
        }
        if (nomemberTipsLbl.hidden) {
            orderPriceLbl.frame = CGRectMake(20, 0, 90, 50);
        }else{
            orderPriceLbl.frame = CGRectMake(20, 4, 90, 30);
        }
    }else{
        nomemberTipsLbl.hidden = YES;
        orderPriceLbl.frame = CGRectMake(20, 0, 90, 50);
    }
    
    // 重置返现
    [self resetBackPrice];
    
    roomTypeLbl.text = [roomTypeDic safeObjectForKey:ROOMTYPENAME];
    hotelNameLbl.text = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelName_S];

    [self getDateTips];
    
    
    if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_IsCustomerNameEn] boolValue]) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 75, SCREEN_WIDTH - 40, 20)];
        lbl.font = [UIFont systemFontOfSize:12.0f];
        lbl.textColor = RGBACOLOR(52, 52, 52, 1);
        lbl.backgroundColor = [UIColor clearColor];
        lbl.text = @"酒店要求入住人姓名务必英文拼写";
        [headerView addSubview:lbl];
        [lbl release];
        
        if (![RoomType isPrepay])
        {
            localPricelbl = [[UILabel alloc] initWithFrame:CGRectMake(13, 93, SCREEN_WIDTH - 40, 20)];
            localPricelbl.font = [UIFont systemFontOfSize:12.0f];
            localPricelbl.textColor = [UIColor redColor];
            localPricelbl.backgroundColor = [UIColor clearColor];
            localPricelbl.text=[NSString stringWithFormat:@"预订免费，您仅需到酒店支付%@",[self getHotelPrice:YES]];
            [headerView addSubview:localPricelbl];
            [localPricelbl release];
            
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90 + 28);
        }
        else
        {
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90 + 10);
        }
    }else{
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 75 + 8);
    }
    
    orderInfoList.tableHeaderView = headerView;
    [headerView release];
    
    
    // 空白填充
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    orderInfoList.tableFooterView = tableFooterView;
    [tableFooterView release];
    //获取紧急提示
    UITableView *weakOrderInfoTable = orderInfoList;
    UILabel *weakInvoiceTipLabel = invoiceTipLabel;
    [[UrgentTipManager sharedInstance] urgentTipViewofCategory:HotelFillOrderUrgentTip completeHandle:^(UrgentTipView *urgentTipView) {
        UIView *tmpFooterView = weakOrderInfoTable.tableFooterView;
        [tmpFooterView addSubview:urgentTipView];

        //判断发票提示是否存在，根据发票提示设置坐标
        int urgentTipViewOriginY = 6.0;
        if (weakInvoiceTipLabel && !weakInvoiceTipLabel.hidden)
        {
            urgentTipViewOriginY=weakInvoiceTipLabel.frame.origin.y+weakInvoiceTipLabel.frame.size.height;
        }
        
        CGRect frame = urgentTipView.frame;
        frame.origin.y = urgentTipViewOriginY;
        urgentTipView.frame = frame;
        
        //根据提示内容大小，来扩展tableFooterView的高度
        int height = (urgentTipView.origin.y + urgentTipView.frame.size.height > tmpFooterView.frame.size.height)?(urgentTipView.origin.y + urgentTipView.frame.size.height):tmpFooterView.frame.size.height;
        CGRect footerFrame = tmpFooterView.frame;
        footerFrame.size.height = height;
        tmpFooterView.frame = footerFrame;
        
        [weakOrderInfoTable setTableFooterView:tmpFooterView];
    }];
    
    // 预付显示发票提示
    if ([RoomType isPrepay]) {
        invoiceTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, SCREEN_WIDTH - 20 , 40)];
        invoiceTipLabel.numberOfLines      = 2;
        invoiceTipLabel.backgroundColor	= [UIColor clearColor];
        invoiceTipLabel.font = [UIFont systemFontOfSize:13];
        invoiceTipLabel.textColor = RGBACOLOR(57, 57, 57, 1);
        invoiceTipLabel.hidden = YES;
        if (invoiceMode==1)
        {
            invoiceTipLabel.text               = @"● 此发票由艺龙公司开具（普通快递，您离店后寄出，5日送达，逢节假日顺延）";
        }
        else if(invoiceMode==2)
        {
            invoiceTipLabel.text               = @"● 此发票由酒店提供，如有需要请向酒店前台索取";
        }
        else
        {
            invoiceTipLabel.text= @"";
        }
        [tableFooterView addSubview:invoiceTipLabel];
        [invoiceTipLabel release];
    
    }
}



// 房间数量选择框
- (void)createRoomSelectView
{
    if (minCheckinRooms > 1) {
        roomSelectView = [[RoomSelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180 + 44) title:[NSString stringWithFormat:@"酒店要求最少%d间起订",minCheckinRooms]];
    }else{
        roomSelectView = [[RoomSelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180 + 44) title:[NSString stringWithFormat:@"选择房间数量"]];
    }
    
    roomSelectView.minRows = minCheckinRooms;
    roomSelectView.selectedRow = roomcount - 1;
    roomSelectView.guaranteeNum = [self roomCountVouch];
    roomSelectView.delegate = self;
    [self.view addSubview:roomSelectView];
    [roomSelectView release];
}

// 特殊需求
-(BOOL)createSpecialView:(NSArray *) specialArray
{
    if (!ARRAYHASVALUE(specialArray)) {
        return NO;
    }
    
    specialView = [[SpecialFilterView alloc] initWithTitle:@"大双床要求" Datas:specialArray];
    specialView.delegate = self;
    [self.view addSubview:specialView.view];
    //specialView.currentRow = -1;
    specialView.view.hidden=YES;
    
    return YES;
}

// 担保页面选择框
- (void)createVouchView
{
    NSArray *vouchArray = [roomTypeDic safeObjectForKey:HOLDING_TIME_OPTIONS];
    vouchConditions = [[NSMutableArray alloc] initWithArray:[self getVouchConditionFromDatas:vouchArray]];
    
    if ([vouchArray count] <= 1) {
        // 如果只有一个担保条件时，取消点击
        
        if ([vouchArray count] == 0) {
            // 服务器没有取到担保条件的错误情况
            self.vouchTips = @"－－";
        }
        else {
            if ([[[vouchArray safeObjectAtIndex:0] safeObjectForKey:NEEDVOUCH] boolValue]) {
                // 需要担保时，显示担保金额
                needVouch = YES;
                
                self.vouchTips = [NSString stringWithFormat:@"该酒店需信用卡担保，金额：%@",[self getOriginVouchMoney]];
            }
            else {
                // 不需要担保时，只显示担保时间
                self.vouchTips = [[vouchConditions safeObjectAtIndex:0] safeObjectForKey:SHOWTIME];
                needVouch = NO;
            }
        }
    }
    else {
        if (!vouchView) {
            vouchView = [[VouchFilterView alloc] initWithTitle:@"房间保留时间" Datas:vouchConditions];
            vouchView.delegate = self;
            [self.view addSubview:vouchView.view];
            vouchView.view.hidden = YES;
        }
        
        if (_selectIndex == 0) {
            int i = 0;
            
            for (NSDictionary *info in vouchArray) {
                if ([[info objectForKey:@"IsDefault"] boolValue] == TRUE) {
                    break;
                }
                ++i;
            }
            
            if (i >= vouchArray.count) {
                i = 0;
            }
            
            _selectIndex = i;
        }
        
        currentTimeIndex = _selectIndex;
        vouchView.currentRow = _selectIndex;
        // 多个时间段时，默认显示第一个时间段
        NSDictionary *dic = [vouchConditions safeObjectAtIndex:_selectIndex];
        NSString *vouchStr = nil;
        if ([[dic safeObjectForKey:NEEDVOUCH] boolValue]) {
            vouchStr = [NSString stringWithFormat:@"%@(需担保)", [dic safeObjectForKey:SHOWTIME]];
            needVouch = YES;
        }
        else {
            vouchStr = [dic safeObjectForKey:SHOWTIME];
            needVouch = NO;
        }
        
        self.vouchTips = vouchStr;
        vouchView.moneyValue = [self getOriginVouchMoney];
    }
}

// 联系人选择按钮
- (void)createCustomerSelBtn
{
    customerSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customerSelBtn setImage:[UIImage noCacheImageNamed:@"customer_icon.png"] forState:UIControlStateNormal];
    [customerSelBtn addTarget:self action:@selector(customerSelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    dashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 0.55, 43)];
    dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
    [customerSelBtn addSubview:dashView];
    [dashView release];
    
    [orderInfoList addSubview:customerSelBtn];
    
    [self resetCustomerSelBtn];
}



- (void)resetCustomerSelBtn
{
    if(!customerSelBtn)
        return;
    NSInteger headerHeight = orderInfoList.tableHeaderView.frame.size.height;
    
    float rowHeight = 44;
    
    NSInteger rowMoveHeight = ([self tableView:nil numberOfRowsInSection:0] - roomcount - 1) * rowHeight;
    if (self.bedSelectable) {
        rowMoveHeight = ([self tableView:nil numberOfRowsInSection:0] - roomcount - 1 - 1) * rowHeight;
    }
    headerHeight += [self tableView:orderInfoList heightForHeaderInSection:0];
    customerSelBtn.frame = CGRectMake(SCREEN_WIDTH - 44, headerHeight + rowMoveHeight, 44, roomcount * rowHeight);
    dashView.frame = CGRectMake(0, 2, 0.55, roomcount * rowHeight - 4);
}

#pragma mark -
#pragma mark Private Method

// 返回担保房量
- (NSInteger) roomCountVouch
{
    if(![roomTypeDic safeObjectForKey:@"VouchSet"]||[roomTypeDic safeObjectForKey:@"VouchSet"] ==[NSNull null])
        return 0;
    
    NSMutableDictionary *vouchSet=[roomTypeDic safeObjectForKey:@"VouchSet"];
    bool isArriveEndTimeVouch=[[vouchSet safeObjectForKey:@"IsArriveTimeVouch"] boolValue];
    bool isRoomCountVouch=[[vouchSet safeObjectForKey:@"IsRoomCountVouch"] boolValue];
    if([vouchSet safeObjectForKey:@"RoomCount"]&&[vouchSet safeObjectForKey:@"RoomCount"]!=[NSNull null])
    {
        return [[vouchSet safeObjectForKey:@"RoomCount"] intValue];
    }
    //无条件担保
    if(!isArriveEndTimeVouch&&!isRoomCountVouch){
        return 1;
    }
    return 0;
}

- (BOOL) arriveTimeVouch{
    if(![roomTypeDic safeObjectForKey:@"VouchSet"]||[roomTypeDic safeObjectForKey:@"VouchSet"] ==[NSNull null])
        return NO;
    
    NSMutableDictionary *vouchSet=[roomTypeDic safeObjectForKey:@"VouchSet"];
    bool isArriveEndTimeVouch=[[vouchSet safeObjectForKey:@"IsArriveTimeVouch"] boolValue];
    bool isRoomCountVouch=[[vouchSet safeObjectForKey:@"IsRoomCountVouch"] boolValue];
    
    // 强制担保
    if (!isArriveEndTimeVouch && !isRoomCountVouch) {
        return YES;
    }
    
    return isArriveEndTimeVouch;
}

// 获取担保金额
- (NSString *)getOriginVouchMoney
{
    // 返回初始担保金额
    // 取出担保金额
    NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
    if (![[dic safeObjectForKey:@"VouchSet"] isEqual:[NSNull null]]) {
        int vouchType = [[[dic safeObjectForKey:@"VouchSet"] safeObjectForKey:@"VouchMoneyType"] intValue];
        NSString *currencyStr = [dic safeObjectForKey:@"Currency"];
        
        if ([currencyStr isEqualToString:CURRENCY_HKD]) {
            self.currencyMark = CURRENCY_HKDMARK;
        }
        else if ([currencyStr isEqualToString:CURRENCY_RMB]) {
            self.currencyMark = CURRENCY_RMBMARK;
        }
        else {
            self.currencyMark = currencyStr;
        }
        
        if (vouchType == 1) {
            vouchMoney = [[dic safeObjectForKey:@"FirstDayPrice"] doubleValue] * roomcount;
        }else {
            vouchMoney = [[dic safeObjectForKey:@"TotalPrice"] doubleValue] * roomcount;
        }
        
        //汇率
        float exchangeRate=[[roomTypeDic safeObjectForKey:@"ExchangeRate"] floatValue];
        //更改bug，担保都是人民币
        return [NSString stringWithFormat:@"%@%.f",CURRENCY_RMBMARK,exchangeRate>0?vouchMoney*exchangeRate:vouchMoney];
    }
    
    return nil;
}

// 获取总价格
- (NSString *) getHotelPrice:(BOOL) isLocalPrice
{
    NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
    
    float totalPrice = [[dic safeObjectForKey:@"TotalPrice"] doubleValue] * roomcount;
    NSString *currencyStr = [dic safeObjectForKey:@"Currency"];
    
    if ([currencyStr isEqualToString:CURRENCY_HKD]) {
        self.currencyMark = CURRENCY_HKDMARK;
    }
    else if ([currencyStr isEqualToString:CURRENCY_RMB]) {
        self.currencyMark = CURRENCY_RMBMARK;
    }
    else {
        self.currencyMark = currencyStr;
    }
    if ([RoomType isPrepay] && self.couponEnabled) {
        totalPrice = totalPrice - [self getBackPrice];
    }
    
    //本地货币
    if (isLocalPrice)
    {
        return [NSString stringWithFormat:@"%@%.f",self.currencyMark,totalPrice];
    }
    //人民币
    else
    {
        //汇率
        float exchangeRate=[[roomTypeDic safeObjectForKey:@"ExchangeRate"] floatValue];
        //更改bug，担保都是人民币
        return [NSString stringWithFormat:@"%@%.f",CURRENCY_RMBMARK,exchangeRate>0?totalPrice*exchangeRate:totalPrice];
    }
}

// 计算返现和立减
- (NSInteger) getBackPrice
{
    // 计算消费券
    NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
    if ([room safeObjectForKey:@"HotelCoupon"] != [NSNull null] && [[AccountManager instanse] isLogin]) {
        [[HotelPostManager hotelorder] setBookingDate];
        NSDate *ad=[TimeUtils parseJsonDate:[[HotelPostManager hotelorder] getArriveDate]];
        NSDate *ld=[TimeUtils parseJsonDate:[[HotelPostManager hotelorder] getLeaveDate]];
        int days=([ld timeIntervalSince1970]-[ad timeIntervalSince1970])/(24*60*60);
        NSArray *coupons = [Coupon activedcoupons];
        if (ARRAYHASVALUE(coupons)) {
            totalValue = [[coupons safeObjectAtIndex:0] intValue];
        }
        
        daysofonperson = [[[room safeObjectForKey:@"HotelCoupon"] safeObjectForKey:@"TrueUpperlimit"] intValue]*days;
        activecouponvalue = daysofonperson * roomcount;
        
        if (activecouponvalue > totalValue) {
            activecouponvalue = totalValue;
        }
        
        return activecouponvalue;
    }
    return 0;
}

- (NSInteger) getRealCoupon{
    // 计算消费券
    NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
    if ([room safeObjectForKey:@"HotelCoupon"] != [NSNull null]) {
        
        return [[[room safeObjectForKey:@"HotelCoupon"] safeObjectForKey:@"TrueUpperlimit"] intValue];
        
    }
    return 0;
}

// 检测所有的入住人
- (BOOL)checkCurrentInputNames
{
	NSInteger count = 0;
    for (int i = 0;i < roomcount && i < nameArray.count; i++) {
        if (STRINGHASVALUE([nameArray safeObjectAtIndex:i])) {
            NSString *name = [nameArray safeObjectAtIndex:i];
            if ([name sensitiveWord])
            {
                [PublicMethods showAlertTitle:[NSString stringWithFormat:@"入住人包含非法姓名“%@”", name] Message:nil];
                return NO;
            }
            
            count++;
        }
    }
    if (count < roomcount) {
        [PublicMethods showAlertTitle:@"请输入所有入住人姓名" Message:nil];
        return NO;
    }
    return YES;
}

- (NSString*)validateUserInputData
{
    // 联系人手机号是否正确
    if (!MOBILEPHONEISRIGHT(self.linkman)) {
        return _string(@"s_phonenum_iserror");
    }
    for (int i = 0;i < roomcount && i < nameArray.count;i++){
        NSString *name = [nameArray safeObjectAtIndex:i];
        if (!STRINGHASVALUE(name)) {
            continue;
        }
        if (name.length < 2) {
            return @"请填写实际入住客人的姓名，确保顺利入住";
        }
        else {
            if ([[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_IsCustomerNameEn] boolValue]) {
                if (![StringFormat isOnlyContainedEnglishName:name]) {
                    return @"请正确填写英文姓名或拼音";
                }
            }
            else {
                if (![StringFormat isNameFormat:name]) {
                    return @"联系人名称中包含非法字符";
                }
            }
        }
    }
    
    // 发票
    if (needInvoice) {
        // 点击下一步的操作
        [self.view endEditing:YES];
        
        if (!STRINGHASVALUE(self.invoiceTitle)) {
            return @"发票抬头为空";
        }
        else if ([StringFormat isContainedSpecialChar:self.invoiceTitle]) {
            return @"发票抬头包含特殊字符或数字";
        }
        
        
        if (0 == [invoiceAddresses count]) {
            return @"请新增邮寄地址";
        }
    }
    return nil;
}


// 使用coupon时，构造一个coupon数值
- (void)addCoupons
{
    NSMutableArray *useccoupon=[[NSMutableArray alloc] init];
    
    // 手动构造一个coupon
    NSDictionary *coupon = [NSDictionary dictionaryWithObjectsAndKeys:
                            NUMBER(0), @"CouponId",
                            NUMBER(0), @"CouponTypeId",
                            @"0", @"CouponCode",
                            NUMBER(1), @"Status",
                            [TimeUtils makeJsonDateWithUTCDate:[NSDate date]], @"EffectiveDateFrom",
                            [TimeUtils makeJsonDateWithUTCDate:[NSDate date]], @"EffectiveDateTo",
                            NUMBER(0), @"CardNo",
                            NUMBER(activecouponvalue), @"CouponValue",nil];
    [useccoupon addObject:coupon];
    
    [[HotelPostManager hotelorder] setCoupons:useccoupon];
    [useccoupon release];
}


- (void)booking
{
    NSDictionary *vouchTimeDic = [[roomTypeDic safeObjectForKey:HOLDING_TIME_OPTIONS] safeObjectAtIndex:currentTimeIndex];
    [[HotelPostManager hotelorder] clearBuildData];
    
    NSMutableArray *tnameArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0;i < roomcount && i < nameArray.count;i++) {
        NSString *name = [nameArray safeObjectAtIndex:i];
        if (STRINGHASVALUE(name)) {
            [tnameArray addObject:name];
        }
    }
    [[HotelPostManager hotelorder] setBookingInfo:[RoomType currentRoomIndex] roomcount:roomcount guestnames:tnameArray];
    [[HotelPostManager hotelorder] setBookingDate];
    [[HotelPostManager hotelorder] setConnectorInfo:self.linkman];
    
    // 特殊需求
    if (self.specialTips) {
        [[HotelPostManager hotelorder] setNotesToHotel:self.specialTips];
    }
    
    // 发票信息
    if (needInvoice) {
        NSDictionary *invoiceDict = [invoiceAddresses objectAtIndex:self.invoiceIndex];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    self.invoiceTitle, INVOICETITLE_GROUPON,
                                    self.invoiceType, TYPE_GROUPON,
                                    [invoiceDict objectForKey:KEY_NAME], @"Receiver",
                                    [invoiceDict objectForKey:KEY_ADDRESS_CONTENT], ADDRESS_GROUPON,
                                    DEFAULTPOSTCODEVALUE, @"PostCode", nil];
        
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!delegate.isNonmemberFlow){
            // 会员流程
            [dic safeSetObject:[[AccountManager instanse] phoneNo] forKey:@"Phone"];	// 电话从登录信息取
        }
        else {
            // 非会员流程
            [dic safeSetObject:[[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE] forKey:@"Phone"];		// 电话从前
        }
        
        [[HotelPostManager hotelorder] setInvoiceDic:dic];
    }
    
    
    [[HotelPostManager hotelorder] setArriveTimeEarly:[vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeEarly_ED]
                                                 Late:[vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeLate_ED]];
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.isNonmemberFlow) {
        
        [[HotelPostManager hotelorder] setBaseInfo:[RoomType currentRoomIndex]];
        
        if ([RoomType isPrepay])
        {
            if (self.vouchSetType == VouchSetTypeCreditCard) {
                // 不选发票直接进入信用卡填写页面
                [[SelectCard allCards] removeAllObjects];
                
                [self requestBankList];
            }else{
                [self goOrderConfirm];
            }
        }
        else if ([self isVouch])
        {
            if (self.vouchSetType == VouchSetTypeCreditCard) {
                // 需要担保或者走预付流程
                [[SelectCard allCards] removeAllObjects];
                
                [self requestBankList];
            }else{
                [self goOrderConfirm];
            }
        }
        else {
            self.vouchSetType = VouchSetTypeNormal;
            [self goOrderConfirm];
        }
    }
    else {
        // 会员流程 (默认使用消费券)
        [[HotelPostManager hotelorder] setBaseInfo:[RoomType currentRoomIndex] useCoupon:YES];	// 登录后使用消费券
        
        if ([self isVouch]) {
            // 信用卡担保
            if (self.couponEnabled) {
                // 默认使用消费券
                [self addCoupons];
            }
            
            if (self.vouchSetType == VouchSetTypeCreditCard) {
                m_netstate=SELECTCARD_STATE;
                [[MyElongPostManager card] clearBuildData];
                [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:NO] delegate:self];
            }else{
                [self goOrderConfirm];
            }
        }
        else if ([RoomType isPrepay])
        {
            
            if (self.couponEnabled)
            {
                // 预付立减的情况，不可使用CA账户，直接进入信用卡选择页
                [self addCoupons];
                
                if (self.vouchSetType == VouchSetTypeCreditCard) {
                    m_netstate=SELECTCARD_STATE;
                    [[MyElongPostManager card] clearBuildData];
                    [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:NO] delegate:self];
                }else{
                    [self goOrderConfirm];
                }
            }
            else{
                if (self.vouchSetType == VouchSetTypeCreditCard) {
                    // 信用卡预付且不用消费券时，发起现金账户验证请求
                    m_netstate = CHECK_CASHACCOUNT;
                    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeDomesticPrepayHotel] delegate:self];
                }else{
                    //by lc
                    if (self.currentBookingType==C2C_Booking) {  //c2c 非信用卡承担
                        BOOL enbaleUse = [self judgeUnCard_C2CEnableUse];  //非信用卡前判断
                        if(enbaleUse){
                            [self c2cAssumeAction];
                        }
                    }else{  //除了c2c  原有逻辑
                        // 直接进入确认页面
                        [self goOrderConfirm];
                        
                    }

                }
            }
        }
        else {
            self.vouchSetType = VouchSetTypeNormal;
            
            if (self.couponEnabled) {  // 默认使用消费券
                // 手动构造一个coupon
                [self addCoupons];
                
                [self goOrderConfirm];
            }
            else {
                [self goOrderConfirm];
            }
        }
    }
    
    switch (self.vouchSetType) {
        case VouchSetTypeCreditCard:{
            // countly 信用卡支付点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_CREDITCARD;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
        }
            break;
        case VouchSetTypeWeiXinPayByApp:{
            // countly 微信支付支付点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_WECHAT;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
        }
            break;
        case VouchSetTypeAlipayApp:{
            // countly 支付宝客户端支付点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_ALIPAYCLIENT;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
        }
            break;
        case VouchSetTypeAlipayWap:{
            // countly 支付宝网页支付点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_ALIPAYWEB;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
        }
            break;
        default:
            break;
    }
}

// 担保检测
-(BOOL)isVouch
{
	if ([roomTypeDic safeObjectForKey:RespHD__VouchSet_DI]==[NSNull null]) {
		return NO;
	}else {
		NSDictionary *vouchSet = [roomTypeDic safeObjectForKey:RespHD__VouchSet_DI];
		BOOL isArriveTimeVouch = [[vouchSet safeObjectForKey:RespHD___IsArriveTimeVouch_B] boolValue];
		BOOL isRoomCountVouch = [[vouchSet safeObjectForKey:RespHD___IsRoomCountVouch_B] boolValue];
		int dataType = [[vouchSet safeObjectForKey:RespHD___DateType_I] intValue];
		switch (dataType) {
			case 0://无
			{
				
			}
				break;
			case 1://预定日
			{
				
			}
				break;
			case 2://住店期间
			{
				if (isArriveTimeVouch) {
					if (needVouch) {
						return YES;
					}
				}
				
				if (isRoomCountVouch) {
					int currentRoomCount = [[HotelPostManager hotelorder] getRoomCount];
					int limitRoomCount=[[vouchSet safeObjectForKey:RespHD___RoomCount_I] intValue];
					if (currentRoomCount>=limitRoomCount) {
						return YES;
					}
				}
				
				if (!isArriveTimeVouch&&!isRoomCountVouch) {
					return YES;
				}
			}
				break;
			case 3://入住日
			{
				if (isArriveTimeVouch) {
					if (needVouch) {
						return YES;
					}
				}
				
				if (isRoomCountVouch) {
					int currentRoomCount = [[HotelPostManager hotelorder] getRoomCount];
					int limitRoomCount=[[vouchSet safeObjectForKey:RespHD___RoomCount_I] intValue];
					if (currentRoomCount>=limitRoomCount || needVouch) {
						return YES;
					}
				}
				
				if (!isArriveTimeVouch&&!isRoomCountVouch) {
					return YES;
				}
			}
				break;
		}
	}
	return NO;
}


//fixed by lc
- (void)goOrderConfirm
{
    NSString *tips = nil;
    float price = 0.0f;
    if ([RoomType isPrepay]) {
        tips = @"支付";
        price = [[HotelPostManager hotelorder] getTotalPrice];
    }else{
        tips = @"担保";
        price = vouchMoney;
    }
    NSString *hotelName = [NSString stringWithFormat:@"%@",[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelName_S]];
    switch (self.vouchSetType) {
        case VouchSetTypeNormal:
            
            break;
        case VouchSetTypeCreditCard:
            break;
        case VouchSetTypeAlipayWap:{
            // 支付宝wap
            [[HotelPostManager hotelorder] setAlipayInfo:@"alipay:return" withCancelURL:@"alipay:back" withName:hotelName withBody:@"pay"];
            [[HotelPostManager hotelorder] setVouch:VouchSetTypeAlipayWap vouchMoney:price];
        }
            break;
        case VouchSetTypeAlipayApp:{
            // 支付宝app
            if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
                [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"未发现支付宝客户端，请您更换别的%@方式或下载支付宝",tips]];
                return;
            }
            [[HotelPostManager hotelorder] setAlipayInfo:@"alipay:return" withCancelURL:@"alipay:back" withName:hotelName withBody:@"pay"];
            [[HotelPostManager hotelorder] setVouch:VouchSetTypeAlipayApp vouchMoney:price];
        }
            break;
        case VouchSetTypeWeiXinPayByApp:{
            // 微信
            if(![WXApi isWXAppInstalled]){
                [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"未发现微信客户端，请您更换别的%@方式或下载微信",tips]];
                return;
            }
            if (![WXApi isWXAppSupportApi]) {
                [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"您微信客户端版本过低，请您更换别的%@方式或更新微信",tips]];
                return;
            }
            [[HotelPostManager hotelorder] setAlipayInfo:@"weixin:return" withCancelURL:@"weixin:back" withName:hotelName withBody:@"hotel"];
            [[HotelPostManager hotelorder] setVouch:VouchSetTypeWeiXinPayByApp vouchMoney:price];
        }
            break;
        default:
            break;
    }
	hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
    hotelconfirmorder.isC2CSuccess = self.currentBookingType==C2C_Booking?YES:NO;
    hotelconfirmorder.payType = self.vouchSetType;
    [hotelconfirmorder nextState];
}

- (NSDate *)displayNSStringToDate:(NSString *)s
{
	NSTimeZone *tz=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:tz];
	[f setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *d=[f dateFromString:s];
	[f release];
	return d;
}

- (void)back
{
    
    // countly 后退点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACK;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    
    // 记录用户填写信息，方便下次恢复
    [self recordRoomsInfo];
    
	[[SelectRoomer allRoomers] removeAllObjects];
	if (isSkipLogin) {
        HotelDetailController *HoteldetailVC = nil;
        HomeAdWebViewController *homeAdWebViewController = nil;//(广告页过来)
        for (UIViewController* vc in self.navigationController.viewControllers)
        {
            if ([vc isKindOfClass: [HotelDetailController class]])
            {
                HoteldetailVC = (HotelDetailController*)vc;
            }
            if ([vc isKindOfClass: [HomeAdWebViewController class]])
            {
                homeAdWebViewController = (HomeAdWebViewController*)vc;
            }
        }
        if (HoteldetailVC)
            [self.navigationController popToViewController:HoteldetailVC animated:YES];
        else
        {
            if (homeAdWebViewController)
            {
                [self.navigationController popToViewController:homeAdWebViewController animated:YES];
            }
            else
            {
                [super back];
            }
        }
	}
	else {
		[super back];
	}
}

- (void)backhome
{
    // countly store
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACKHOME;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    // 记录用户填写信息方便下次进入恢复
    [self recordRoomsInfo];
    
    [super backhome];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (0 != buttonIndex) {
		[super backhome];
	}
}

- (void)rigistersevendayssuccess
{
    [self booking];
}

- (NSMutableArray *)getVouchConditionFromDatas:(NSArray *)datas
{
    // 是否到店时间担保
    BOOL arriveTimeVouch = [self arriveTimeVouch];
	if ([datas isKindOfClass:[NSArray class]] &&
		[datas count] > 0) {
		NSMutableArray *timeRangeArray = [NSMutableArray arrayWithCapacity:2];
		for (NSDictionary *dic in datas)
        {
			NSString *timeRange = [dic safeObjectForKey:SHOWTIME];
            NSInteger index = [datas indexOfObject:dic];
            if (index == 0 || index == [datas count] - 1) {
                // 第一个和最后一个日期加"之前"
                timeRange = [timeRange stringByAppendingFormat:@"之前"];
            }
            else {
                // 中间的日期改为时间段
                NSString *preTimeRange = [[datas safeObjectAtIndex:index - 1] safeObjectForKey:SHOWTIME];
                timeRange = [NSString stringWithFormat:@"%@－%@", preTimeRange, timeRange];
            }
            
            BOOL itemVouch = [[dic safeObjectForKey:NEEDVOUCH] boolValue];
            
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      timeRange, SHOWTIME,[NSNumber numberWithBool:itemVouch & arriveTimeVouch], NEEDVOUCH, [dic objectForKey:@"IsDefault"], @"IsDefault", nil];
            [timeRangeArray addObject:paramDic];
		}
		
		return timeRangeArray;
	}
	else {
		return nil;
	}
}

// 记录用户填写的相关信息：手机号、预定房间数量、所填写的房间入住人等
- (void) recordRoomsInfo
{
    // 记录手机号和房间数
    [[NSUserDefaults standardUserDefaults] setObject:nameArray forKey:NONMEMBER_CHECKINPEPEOS];
    [[NSUserDefaults standardUserDefaults] setInteger:roomcount forKey:NONMEMBER_ROOMNUM];
    [[NSUserDefaults standardUserDefaults] setObject:self.linkman forKey:NONMEMBER_PHONE];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:NONMEMBER_CHECKINTIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// 400电话
- (void) calltel400
{
    [super calltel400];
    
    if (vouchView) {
        [vouchView dismissInView];
    }
    if (currentTextField) {
        [currentTextField resignFirstResponder];
        currentTextField = nil;
    }
}

// 重置返现
- (void) resetBackPrice
{
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    // 重置返现
    if (![RoomType isPrepay]) {
        if (!delegate.isNonmemberFlow) {
            // 非预付流程生成担保相关的界面
            NSInteger coupon = [self getBackPrice];
            if(coupon){
                couponLbl.hidden = NO;
                couponLbl.text = [NSString stringWithFormat:@"返¥%d",coupon];
                
            }else{
                couponLbl.hidden = YES;
                couponLbl.text = @"";//@"您的消费券余额为0，无法获取返现";
            }
        }
        
    }else{
        if (!delegate.isNonmemberFlow) {
            NSInteger coupon = [self getBackPrice];
            if(coupon){
                couponLbl.hidden = YES;
                couponLbl.text = [NSString stringWithFormat:@"立减¥%d",coupon];
               
            }else{
                couponLbl.hidden = YES;
                couponLbl.text = @"";//@"您的消费券余额为0，无法获取返现";
            }
        }
        
    }
    
    NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
    if ([room safeObjectForKey:@"HotelCoupon"] == [NSNull null]){
        nomemberTipsLbl.hidden = YES;
    }
//    if ([RoomType isPrepay]) {
//        self.couponLabel.text = [NSString stringWithFormat:@"使用消费券立减%d元", [self getBackPrice]];
//    }else{
//        self.couponLabel.text = [NSString stringWithFormat:@"使用消费券返现%d元", [self getBackPrice]];
//    }
    
    [orderInfoList reloadData];
}


// 预付流程进入统一收银台，参数：CA是否可用
- (void)prepayToUniformCounterByUseCA:(BOOL)useCA
{
    switch (payTable.selectedPayType)
    {
        case UniformPaymentTypeCreditCard:
        {
            // 选择信用卡的情况
            SelectCard *controller = [[SelectCard alloc] init:@"信用卡预付" style:_NavNormalBtnStyle_ nextState:HOTEL_STATE canUseCA:useCA];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        case UniformPaymentTypeWeixin:
        {
            // 使用微信支付订单
            [[UniformWeiXinModel shared] beginForType:UniformFromTypeHotel];
        }
            break;
        case UniformPaymentTypeAlipayWap:
        {
            // 使用支付宝wap支付订单
            [[UniformWapAlipayModel shared] beginForType:UniformFromTypeHotel];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark Actions

- (void) customerSelBtnClick:(id)sender
{
    // 会员流程
    if (!requestOver) {
        // 没有获取到入住人时停止本页请求
        [getRoomerUtil cancel];
    }
    // 收回键盘
    [currentTextField resignFirstResponder];
    
    // 收回担保页
    if (vouchView) {
        [vouchView dismissInView];
    }
    
    // 收回房间选择
    [roomSelectView dismissInView];
    
    SelectRoomer *controller = [[SelectRoomer alloc] initWithRequested:requestOver roomCount:roomcount];
    controller.delegate =(id<RoomerDelegate>) self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller release];
    
    if (IOSVersion_7) {
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        [self presentModalViewController:nav animated:YES];
    }
    [nav release];
    
    UMENG_EVENT(UEvent_Hotel_FillOrder_RoomerSelect)
}

// 调用通讯录填充联系人
- (void) addressBookBtnClick:(id)sender
{
    // 收回键盘
    [currentTextField resignFirstResponder];
    
    // 收回担保页
    if (vouchView) {
        [vouchView dismissInView];
    }
    
    // 收回房间选择
    [roomSelectView dismissInView];
    
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
    
    UMENG_EVENT(UEvent_Hotel_FillOrder_AddressBook)
    
    // countly 联系人手机点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_CONTACTS;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

- (NSString *) getWeekWithDate:(NSDate *)date
{
    // 周几和星期几获得
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                        fromDate:date];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    switch (weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
        default:
            return @"";
            break;
    }
}

// 设置入离店日期的显示
- (NSString *)getDateTips{
    [[HotelPostManager hotelorder] setBookingDate];
    NSDate *ad=[TimeUtils parseJsonDate:[[HotelPostManager hotelorder] getArriveDate]];
    NSDate *ld=[TimeUtils parseJsonDate:[[HotelPostManager hotelorder] getLeaveDate]];
    int days=([ld timeIntervalSince1970]-[ad timeIntervalSince1970])/(24*60*60);
    
    NSString *adT = [TimeUtils displayDateWithJsonDate:[[HotelPostManager hotelorder] getArriveDate] formatter:@"M月d日"];
    NSString *ldT = [TimeUtils displayDateWithJsonDate:[[HotelPostManager hotelorder] getLeaveDate] formatter:@"M月d日"];
    
    adT = [NSString stringWithFormat:@"%@",adT];
    
    ldT = [NSString stringWithFormat:@"%@",ldT];
    
    checkInAndOutLbl.text = [NSString stringWithFormat:@"入:%@  离:%@  %d晚", adT, ldT, days];
    
    return nil;
}



// 点击“下一步”按钮提交订单  fixed by lc
- (void)nextBtnClick:(id)sender
{
    
    [self nextClickAction];
    
}
//by lc
#pragma mark - 点击“下一步”按钮提交订单执行的具体方法
-(void)nextClickAction{
    // 收回所有的选择控件
    if (vouchView) {
        [vouchView dismissInView];
    }
    if (currentTextField) {
        [currentTextField resignFirstResponder];
        currentTextField = nil;
    }
    
    
    // 检测输入信息是否有误
    if (![self checkCurrentInputNames]) {
        return;
    }
    
    // 检测输入信息格式是否正确
    NSString *msg = [self validateUserInputData];
    if (msg)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        // 检测是否满房
        m_netstate = CHECKROOMCOUNT;
        JCheckRoomCount *jrc = [HotelPostManager checkRoomCount];
        [jrc setSelectRoomcount:[RoomType currentRoomIndex] count:roomcount];
        
        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        [[Profile shared] start:@"国内酒店下单"];
        if (appDelegate.isNonmemberFlow) {
            // 非会员只验满房
            [Utils request:HOTELSEARCH req:[jrc requesString:NO] delegate:self];
        }
        else {
            // 会员还需请求卡号
            [Utils request:HOTELSEARCH req:[jrc requesString:NO] delegate:self];
        }
        
        // 记录房间数和联系人
        [self recordRoomsInfo];
    }
    
    if (UMENG) {
        switch (self.vouchSetType) {
            case VouchSetTypeNormal:{
                
            }
                break;
            case VouchSetTypeCreditCard:{
                if ([RoomType isPrepay]) {
                    UMENG_EVENT(UEvent_Hotel_FillOrder_PrepayCreditCard)
                }else if([self isVouch]){
                    // 信用卡担保
                    UMENG_EVENT(UEvent_Hotel_FillOrder_GuaranteeCreditCard)
                }
            }
                break;
            case VouchSetTypeAlipayWap:{
                if ([RoomType isPrepay]) {
                    // 支付宝wap
                    UMENG_EVENT(UEvent_Hotel_FillOrder_PrepayAlipayWap)
                }else if([self isVouch]){
                    // 支付宝wap
                    UMENG_EVENT(UEvent_Hotel_FillOrder_GuaranteeAlipayWap)
                }
                
            }
                break;
            case VouchSetTypeAlipayApp:{
                if ([RoomType isPrepay]) {
                    // 支付宝app
                    UMENG_EVENT(UEvent_Hotel_FillOrder_PrepayAlipayApp)
                }else if([self isVouch]){
                    // 支付宝app
                    UMENG_EVENT(UEvent_Hotel_FillOrder_GuaranteeAlipayApp)
                }
                
            }
                break;
            case VouchSetTypeWeiXinPayByApp:{
                if ([RoomType isPrepay]) {
                    // 微信
                    UMENG_EVENT(UEvent_Hotel_FillOrder_PrepayWeixin)
                }else if([self isVouch]){
                    // 微信
                    UMENG_EVENT(UEvent_Hotel_FillOrder_GuaranteeWeixin)
                }
                
            }
                break;
            default:
                break;
        }
    }
    // countly nextstep
    CountlyEventHotelFillinOrderPageNextStep *countlyNextStep = [[CountlyEventHotelFillinOrderPageNextStep alloc] init];
    if ([RoomType isPrepay]) {
        // 支付宝app
        countlyNextStep.vouchType = @"预付";
    }else if([self isVouch]){
        countlyNextStep.vouchType = @"担保";
    }else{
        countlyNextStep.vouchType = @"非担保";
    }
    countlyNextStep.payType = NUMBER(self.vouchSetType);
    countlyNextStep.hotelName = [NSString stringWithFormat:@"%@",[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelName_S]];
    countlyNextStep.hotelId = [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S];
    NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
    NSInteger roomId = [[room safeObjectForKey:ROOMTYPEID] intValue];
    countlyNextStep.roomId = NUMBER(roomId);
    NSString *roomName = [room safeObjectForKey:ROOMTYPENAME];
    countlyNextStep.roomName = roomName;
    
    NSArray *hotelFacilities = [room safeObjectForKey:ADDITONINFOLIST_HOTEL];
    
    NSString *const KEY		= @"Key";
    NSString *const CONTENT	= @"Content";
    NSString *const roomKeys[8] = {
        @"breakfast",
        @"bed",
        @"network",
        @"area",
        @"floor",
        @"other",
        @"personnum",
        @"roomtype"
    };
    
    // 房型设施
    for (NSDictionary *dic in hotelFacilities) {
        
        if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[0]]) {
            // 早餐说明
            countlyNextStep.breakfast = [dic safeObjectForKey:CONTENT];
        }
        else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[2]]) {
            // 宽带说明
            countlyNextStep.webFree = [dic safeObjectForKey:CONTENT];
        }else if ([[dic safeObjectForKey:KEY] isEqualToString:roomKeys[1]]) {
            // 床型说明
            countlyNextStep.bedType = [dic safeObjectForKey:CONTENT];
        }
    }
    if (needInvoice) {
        countlyNextStep.invoiceStatus = NUMBER(1);
        NSDictionary *invoiceDict = [invoiceAddresses objectAtIndex:self.invoiceIndex];
        countlyNextStep.title =  self.invoiceTitle;
        countlyNextStep.invoiceType = self.invoiceType;
        countlyNextStep.invoiceAddress = [invoiceDict objectForKey:KEY_ADDRESS_CONTENT];
    }else{
        countlyNextStep.invoiceStatus = NUMBER(2);
    }
    countlyNextStep.roomNum = NUMBER(roomcount);
    countlyNextStep.amount = [NSNumber numberWithInt:totalValue];
    countlyNextStep.checkIn = [TimeUtils displayDateWithJsonDate: [[HotelPostManager hoteldetailer] getObject:ReqHD_CheckInDate_ED] formatter:@"yyyy-MM-dd"];
    countlyNextStep.checkOut = [TimeUtils displayDateWithJsonDate:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckOutDate_ED] formatter:@"yyyy-MM-dd"];
    [countlyNextStep sendEventCount:1];
    [countlyNextStep release];
    
    // 成单统计
    HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
    promotionInfoRequest.roomType = [NSString stringWithFormat:@"%d_%@",roomId,roomName];
    promotionInfoRequest.checkinDate = [[HotelPostManager hoteldetailer] getObject:ReqHD_CheckInDate_ED];
    promotionInfoRequest.checkoutDate = [[HotelPostManager hoteldetailer] getObject:ReqHD_CheckOutDate_ED];
    
    // 今日特价
    if ([[room safeObjectForKey:@"IsLastMinutesRoom"] boolValue]) {
        promotionInfoRequest.promotionType = OrderPromotionLM;
    }
    // 手机专享
    if ([[room safeObjectForKey:@"IsPhoneOnly"] boolValue]) {
        promotionInfoRequest.promotionType = OrderPromotionPhone;
    }
    
    // 限时抢
    if ([[room safeObjectForKey:@"IsTimeLimit"] boolValue]) {
        promotionInfoRequest.promotionType = OrderPromotionLimit;
    }
    
    // 支付方式
    if ([RoomType isPrepay]){
        promotionInfoRequest.payType = OrderPayPrepay;
    }else{
        promotionInfoRequest.payType = OrderPayCash;
    }
    
}

#pragma mark - 
#pragma mark c2c 承担网络请求  by lc   非信用卡
-(void)c2cAssumeAction{
    
    NSLog(@"提交......");
    //提交判断
    NSString *personName = [nameArray safeObjectAtIndex:0];   //联系人
    
    NSString *errContent = @"";  //初始化 默认为@""
    
    if (!STRINGHASVALUE(personName)) {   //入住人姓名
        errContent = @"请输入所有入住人姓名";
    }else if (!MOBILEPHONEISRIGHT(self.linkman)){   //手机
        errContent = @"请正确输入手机号,手机号为1开头的11位数字";
    }
    
    if (STRINGHASVALUE(errContent)) {
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:errContent delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        
        return;
    }
    
    
    XGHttpRequest *r =[[XGHttpRequest alloc] init];

    NSDictionary *roomDict = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
    
    
    NSString *hotelid=[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelId"];
    
    NSString *reqid =  self.filter.reqId;  // 请求id
    
    NSString *hotelName = [[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"];
    
    NSString *RoomTypeId = [roomDict safeObjectForKey:@"RoomTypeId"];
    
    NSString *roomName = [roomDict safeObjectForKey:@"RoomTypeName"];
    
    //businessId  没有
    NSString *businessId = [roomDict safeObjectForKey:@"SHotelID"];
    
    
    NSString *cardNo = [[AccountManager instanse]cardNo];  //卡号
    
    
    NSString *mobileNo = self.linkman;   //电话
    
    NSDictionary *vouchTimeDic = [[roomTypeDic safeObjectForKey:HOLDING_TIME_OPTIONS] safeObjectAtIndex:currentTimeIndex];
//    [[HotelPostManager hotelorder] clearBuildData];
//    [[HotelPostManager hotelorder] setArriveTimeEarly:[vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeEarly_ED]
//                                                 Late:[vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeLate_ED]];
    
    NSString *persistBegin;  // = @"2014-05-05 14:00:00";
    
    persistBegin = [vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeEarly_ED];
    
    NSString *persistEnd ;//= @"2014-05-05 18:00:00";
    
    persistEnd = [vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeLate_ED];
    
    NSString *finalPrice = [roomDict safeObjectForKey:@"FinalPrice"];
    
    NSString *totalPrice = [roomDict safeObjectForKey:@"TotalPrice"];
    
    NSString *ratePlanId = [roomDict safeObjectForKey:@"RatePlanId"];  //rp
    NSNumber *PayType = [roomDict safeObjectForKey:@"PayType"];   //支付类型
    
    NSNumber *autoNum=  [roomDict safeObjectForKey:@"Auto"];  // 自动还是手动
    
    NSNumber *response_id = [roomDict safeObjectForKey:@"ResponseId"];   //  新添加     XX
    
    NSNumber *real_Response_Id  =response_id?response_id:@0;
    
    NSNumber *numberRoomCount = [NSNumber numberWithInt:roomcount];
    
    NSDictionary *dict =@{
                          @"hotelId":hotelid,
                          @"requestId":reqid,
                          @"hotelName":hotelName,
                          @"roomId":RoomTypeId,
                          @"roomName":roomName,
                          @"roomNum":numberRoomCount,
                          @"businessId":businessId,
                          @"cardNo":cardNo,
                          @"mobileNo":mobileNo,
                          @"personName":personName,
                          @"persistBegin":persistBegin,
                          @"persistEnd":persistEnd,
                          @"finalPrice":finalPrice,
                          @"totalPrice":totalPrice,
                          @"ratePlanId":ratePlanId,
                          @"PayType":PayType,
                          @"checkInDate":[self.filter getCheckinString],
                          @"checkOutDate":[self.filter getCheckoutString],
                          @"auto":autoNum,
                          @"ResponseId":real_Response_Id,
                          @"cityName":self.filter.cityName};
    
    NSLog(@"请求参数 ....dict==%@",dict);
    
    NSString *reqbody=[dict JSONString];
    
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    
    //    NSString *mainIP=@"http://192.168.33.77:8080/openplatform/";
    //    NSString *url = [NSString stringWithFormat:@"%@%@/%@?req=%@",mainIP,@"hotel",@"submitOrder",body];
    
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"submitOrder"];//XGC2C_GetURL(@"hotel", @"submitOrder");
    
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    
    __unsafe_unretained typeof(self) viewself  = self ;
    
    [r evalNotReloadfForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){

        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        //return;
        NSDictionary *dict =returnValue;
        
        NSString *OrderId = [dict safeObjectForKey:@"OrderId"];
        
        if ([[dict safeObjectForKey:@"IsError"] boolValue]==NO&&STRINGHASVALUE(OrderId)) {  //承担成功
            
            [[NSUserDefaults  standardUserDefaults]setObject:OrderId forKey:C2CSUCCESSORDERID];
            [[NSUserDefaults  standardUserDefaults] synchronize];
            [viewself goOrderConfirm];  //非信用卡承担
            
        }else{   //承担失败
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"下单失败请重新尝试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alter show];
        }
        
        NSLog(@"请求结果dict=======aa==%@",dict);
        
    }];

}
//by lc c2c

-(BOOL)judgeUnCard_C2CEnableUse{
    
    BOOL enableUse = YES;  //默认是可用的
    
    NSString *tips = nil;
    if ([RoomType isPrepay]) {
        tips = @"支付";
    }else{
        tips = @"担保";
    }
    
    switch (self.vouchSetType) {
        case VouchSetTypeAlipayApp:{
            // 支付宝app
            if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
                [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"未发现支付宝客户端，请您更换别的%@方式或下载支付宝",tips]];
                return NO;
            }
        }
            break;
        case VouchSetTypeWeiXinPayByApp:{
            // 微信
            if(![WXApi isWXAppInstalled]){
                [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"未发现微信客户端，请您更换别的%@方式或下载微信",tips]];
                return NO;
            }
            if (![WXApi isWXAppSupportApi]) {
                [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"您微信客户端版本过低，请您更换别的%@方式或更新微信",tips]];
                return NO;
            }
        }
            break;
        default:
            break;
    }
    
    return enableUse;
}

#pragma mark -

- (void)couponIntroduction:(id)sender
{
    CouponIntroductionController *controller = [[[CouponIntroductionController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:@"1.返现是什么？" forKey:@"Title"];
    [dic safeSetObject:@"“返现”是艺龙回馈客户的一种优惠促销方式。您在艺龙预订酒店或机票，成功消费后艺龙会将当次消费款中一定比例的金额返还到您的艺龙账户。" forKey:@"Text"];
    [array addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:@"2.返现有什么用？" forKey:@"Title"];
    [dic safeSetObject:@"●提现到自己的银行卡\n●累计超过50元，可用于手机充值\n●使用艺龙app用返现金额直接购买预付酒店" forKey:@"Text"];
    [array addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:@"3.什么时候把返现给我？" forKey:@"Title"];
    [dic safeSetObject:@"您消费后（离开酒店或乘坐飞机后）3个工作日内预计将返现金额打入您预订时的艺龙账户" forKey:@"Text"];
    [array addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:@"4.如何查询返现是否到达我的艺龙账户？" forKey:@"Title"];
    [dic safeSetObject:@"返现到账后，您会收到短信提醒，或者用电脑登录艺龙官网，进入”我的账户“页面，在您的艺龙“现金账户”中查询您的返现详情" forKey:@"Text"];
    [array addObject:dic];
    
    dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:@"5.特别提醒：" forKey:@"Title"];
    [dic safeSetObject:@"●用户登录下单才能获得返现\n●购买标有“返”字标识的酒店房型或机票才能获得相应数额的返现 返回到您的艺龙账户的现金，请在有效期内使用，否则将作废。\n●赠送给您的“消费券”，可以用于返现。例如：您拥有1000消费券，预订“返现50元”的酒店房型，将消耗50消费券，入住酒店后可获得50元的现金到您的艺龙账户（1消费券在艺龙消费后就变成1现金哦）" forKey:@"Text"];
    [array addObject:dic];
    
    controller.introductionList = array;
    [self.navigationController pushViewController:controller animated:YES];
    
    UMENG_EVENT(UEvent_Hotel_FillOrder_BackRule)
    
    // countly 怎么获取返现点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_HOWTOGETCASHBACK;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

- (void)useCouponOrNot:(id)sender{
    self.couponEnabled = !self.couponEnabled;
    
    if (!self.couponEnabled) {
        if (![RoomType isPrepay]) {
            couponLbl.hidden = YES;
        }
        
    }
    else {
        if (![RoomType isPrepay]) {
            couponLbl.hidden = NO;
        }
        UMENG_EVENT(UEvent_Hotel_FillOrder_CancelCoupon)
    }
    
    // 重置价格
    orderPriceLbl.text = [self getHotelPrice:NO];
    
    if (localPricelbl)
    {
        localPricelbl.text=[NSString stringWithFormat:@"预订免费，您仅需到酒店支付%@",[self getHotelPrice:YES]];
    }
    
    [orderInfoList reloadData];
    
    
    // countly 使用消费卷点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_USECOUPON;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
}

- (void)invoiceSwitchBtnClick:(id)sender{
    // countly 发票点击事件
    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
    countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_INVOICE;
    [countlyEventClick sendEventCount:1];
    [countlyEventClick release];
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (invoiceAddresses == nil) {
        invoiceAddresses = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (islogin && invoiceAddresses.count == 0) {
        // 已经登录并且尚未请求到地址信息
        addressEnabled = NO;
        JGetAddress *jads=[MyElongPostManager getAddress];
        [jads clearBuildData];
        
        if (addressUtil) {
            [addressUtil cancel];
            SFRelease(addressUtil);
        }
        
        addressUtil = [[HttpUtil alloc] init];
        [addressUtil connectWithURLString:MYELONG_SEARCH Content:[jads requesString:YES] StartLoading:NO EndLoading:NO  Delegate:self];
    }else{
        addressEnabled = YES;
    }
    needInvoice = !needInvoice;
    [orderInfoList reloadData];
    
    // 根据是否选择发票，调整控件位置
    int urgentTipOriginY = 6.0;
    if (needInvoice)
    {
        invoiceTipLabel.hidden = NO;
        urgentTipOriginY = invoiceTipLabel.frame.origin.y + invoiceTipLabel.frame.size.height;
        UMENG_EVENT(UEvent_Hotel_FillOrder_NeedInvoice)
    }
    else
    {
        invoiceTipLabel.hidden = YES;
        urgentTipOriginY = 6.0;
    }
    
    //重新设置UrgentTipView坐标
    UITableView *weakOrderInfoTable = orderInfoList;
    for(UIView *tipView in orderInfoList.tableFooterView.subviews){
        if([tipView isKindOfClass:[UrgentTipView class]]){
            CGRect frame = tipView.frame;
            frame.origin.y = urgentTipOriginY;
            tipView.frame = frame;
            
            UIView *tmpFooterView = weakOrderInfoTable.tableFooterView;
            int height = (tipView.origin.y + tipView.frame.size.height > tmpFooterView.frame.size.height)?(tipView.origin.y + tipView.frame.size.height):tmpFooterView.frame.size.height;
            CGRect footerFrame = tmpFooterView.frame;
            footerFrame.size.height = height;
            tmpFooterView.frame = footerFrame;
            [weakOrderInfoTable setTableFooterView:tmpFooterView];
            break;
        }
        
    }
}

- (void)showAddAddressView{
	AddAddress *controller = [[AddAddress alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


// 请求银行列表
- (void)requestBankList
{
	m_netstate = NET_TYPE_BANKLIST;
	JPostHeader *postheader = [[JPostHeader alloc] init];
	[Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
    [postheader release];
}


// 进入信用卡选择页
- (void)goSelectCard
{
    NSString *nextTitle = [RoomType isPrepay] ? @"信用卡预付" : @"酒店担保";
    SelectCard *controller = [[SelectCard alloc] init:nextTitle style:_NavNormalBtnStyle_ nextState:1 canUseCA:canUseCA];
    // 使用Coupon
    
    if (self.currentBookingType == C2C_Booking) {
        controller.isC2C_order = YES;
        controller.delegate = self;
    }
    
    controller.useCoupon = self.couponEnabled;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    if (UMENG) {
        // 酒店订单担保页面
        [MobClick event:Event_HotelOrder_CreditCard];
    }
    
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_CREDITPAYPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
    
}

//SelectCard_C2C_Delegate
#pragma mark -- SelectCard_C2C_Delegate  信用卡代理 c2c by lc
-(void)excuteSelectCard_C2C:(SelectCard *)sender{
    
    NSLog(@"提交......");
    //提交判断
    NSString *personName = [nameArray safeObjectAtIndex:0];   //联系人
    
    NSString *errContent = @"";  //初始化 默认为@""
    
    if (!STRINGHASVALUE(personName)) {   //入住人姓名
        errContent = @"请输入所有入住人姓名";
    }else if (!MOBILEPHONEISRIGHT(self.linkman)){   //手机
        errContent = @"请正确输入手机号,手机号为1开头的11位数字";
    }
    
    if (STRINGHASVALUE(errContent)) {
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:errContent delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        
        return;
    }
    
    
    XGHttpRequest *r =[[XGHttpRequest alloc] init];
    
    
    NSDictionary *roomDict = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
    
    
    NSString *hotelid=[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelId"];
    
    NSString *reqid =  self.filter.reqId;  // 请求id
    
    NSString *hotelName = [[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"];
    
    NSString *RoomTypeId = [roomDict safeObjectForKey:@"RoomTypeId"];
    
    NSString *roomName = [roomDict safeObjectForKey:@"RoomTypeName"];
    
    //businessId  没有
    NSString *businessId = [roomDict safeObjectForKey:@"SHotelID"];
    
    
    NSString *cardNo = [[AccountManager instanse]cardNo];  //卡号
    
    
    NSString *mobileNo = self.linkman;   //电话
    
    NSDictionary *vouchTimeDic = [[roomTypeDic safeObjectForKey:HOLDING_TIME_OPTIONS] safeObjectAtIndex:currentTimeIndex];
//    [[HotelPostManager hotelorder] clearBuildData];
//    [[HotelPostManager hotelorder] setArriveTimeEarly:[vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeEarly_ED]
//                                                 Late:[vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeLate_ED]];
    
    NSString *persistBegin;  // = @"2014-05-05 14:00:00";
    
    persistBegin = [vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeEarly_ED];
    
    NSString *persistEnd ;//= @"2014-05-05 18:00:00";
    
    persistEnd = [vouchTimeDic safeObjectForKey:ReqHO_ArriveTimeLate_ED];
    
    NSString *finalPrice = [roomDict safeObjectForKey:@"FinalPrice"];
    
    NSString *totalPrice = [roomDict safeObjectForKey:@"TotalPrice"];
    
    NSString *ratePlanId = [roomDict safeObjectForKey:@"RatePlanId"];  //rp
    NSNumber *PayType = [roomDict safeObjectForKey:@"PayType"];   //支付类型
    
    NSNumber *autoNum=  [roomDict safeObjectForKey:@"Auto"];  // 自动还是手动
    
    NSNumber *response_id = [roomDict safeObjectForKey:@"ResponseId"];   //  新添加     XX
    
    NSNumber *real_Response_Id  =response_id?response_id:@0;
    
    NSNumber *numberRoomCount = [NSNumber numberWithInt:roomcount];
    
    NSDictionary *dict =@{
                          @"hotelId":hotelid,
                          @"requestId":reqid,
                          @"hotelName":hotelName,
                          @"roomId":RoomTypeId,
                          @"roomName":roomName,
                          @"roomNum":numberRoomCount,
                          @"businessId":businessId,
                          @"cardNo":cardNo,
                          @"mobileNo":mobileNo,
                          @"personName":personName,
                          @"persistBegin":persistBegin,
                          @"persistEnd":persistEnd,
                          @"finalPrice":finalPrice,
                          @"totalPrice":totalPrice,
                          @"ratePlanId":ratePlanId,
                          @"PayType":PayType,
                          @"checkInDate":[self.filter getCheckinString],
                          @"checkOutDate":[self.filter getCheckoutString],
                          @"auto":autoNum,
                          @"ResponseId":real_Response_Id,
                          @"cityName":self.filter.cityName
                          };
    
    NSLog(@"请求参数 ....dict==%@",dict);
    
    NSString *reqbody=[dict JSONString];
    
    NSString *body = [StringEncryption EncryptString:reqbody byKey:NEW_KEY];
    body =[body URLEncodedString];
    
    //    NSString *mainIP=@"http://192.168.33.77:8080/openplatform/";
    //    NSString *url = [NSString stringWithFormat:@"%@%@/%@?req=%@",mainIP,@"hotel",@"submitOrder",body];
    
    NSString *mainIP = [[XGApplication shareApplication] getUrlString:@"hotel" methodName:@"submitOrder"];//XGC2C_GetURL(@"hotel", @"submitOrder");
    
    NSString *url = [NSString stringWithFormat:@"%@?req=%@",mainIP,body];
    
    // 组装url
    NSLog(@"请求url=====%@",url);
    
    [r evalNotReloadfForURL:url postBodyForString:nil RequestFinished:^(XGHttpRequest *request,XGRequestResultType type,id returnValue){
        
        if (type == XGRequestCancel) {
            return;
        }
        if (type ==XGRequestFaild) {
            return;
        }
        //等真实接口出来，我们调用
        if ([Utils checkJsonIsError:returnValue])
        {
            return;
        }
        //return;
        NSDictionary *dict =returnValue;
        NSLog(@"请求结果dict=======aa==%@",dict);
        NSString *OrderId = [dict safeObjectForKey:@"OrderId"];
        
        [[NSUserDefaults  standardUserDefaults]setObject:OrderId forKey:C2CSUCCESSORDERID];  //存储订单号码
        [[NSUserDefaults  standardUserDefaults] synchronize];
        if ([[dict safeObjectForKey:@"IsError"] boolValue]==NO&&STRINGHASVALUE(OrderId)) {  //承担成功
            
            [sender nextClickAction];
        }else{   //承担失败
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"下单失败请重新尝试" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alter show];
        }
        
        
        
    }];
}

#pragma mark -
#pragma mark RoomSelectViewDelegate
- (void) roomSelectView:(RoomSelectView *)roomSelectView_ didSelectedRowAtIndex:(NSInteger)index
{
    UMENG_EVENT(UEvent_Hotel_FillOrder_RoomNum)
    
    // 重置房间数量
    roomcount = index + 1;
    
    // 删除多余的联系人
    NSMutableArray *roomArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *name in nameArray) {
        if (![name isEqualToString:@""]) {
            [roomArray addObject:name];
        }
    }
    
    for (int i = 0; i < nameArray.count; i++) {
        if (i < roomArray.count && i < roomcount) {
            [nameArray replaceObjectAtIndex:i withObject:[roomArray safeObjectAtIndex:i]];
        }else{
            [nameArray replaceObjectAtIndex:i withObject:@""];
        }
    }
    
    // 重置价格
    orderPriceLbl.text = [self getHotelPrice:NO];
    
    if (localPricelbl)
    {
        localPricelbl.text=[NSString stringWithFormat:@"预订免费，您仅需到酒店支付%@",[self getHotelPrice:YES]];
    }
    
    // 重置返现
    [self resetBackPrice];
    
    // 重置担保信息
    if ([vouchConditions count] <= 1) {
        
        if ([vouchConditions count] == 0) {
            // 服务器没有取到担保条件的错误情况
            self.vouchTips = @"－－";
        }else {
            if (needVouch) {
                self.vouchTips = [NSString stringWithFormat:@"该酒店需信用卡担保，金额：%@",[self getOriginVouchMoney]];
                if (self.nextBtn) {
                    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
                }
            }else{
                // 不需要担保时，只显示担保时间
                self.vouchTips = [[vouchConditions safeObjectAtIndex:_selectIndex] safeObjectForKey:SHOWTIME];
                if (self.nextBtn) {
                    [self.nextBtn setTitle:@"提交订单" forState:UIControlStateNormal];
                }
            }
        }
    }
    else {
        if (!vouchView) {
            vouchView = [[VouchFilterView alloc] initWithTitle:@"房间保留时间" Datas:vouchConditions];
            vouchView.delegate = self;
            [self.view addSubview:vouchView.view];
            vouchView.view.hidden = YES;
        }
        
        NSDictionary *dic = [vouchConditions safeObjectAtIndex:currentTimeIndex];
        NSString *vouchStr = nil;
        if ([[dic safeObjectForKey:NEEDVOUCH] boolValue]) {
            vouchStr = [NSString stringWithFormat:@"%@(需担保)", [dic safeObjectForKey:SHOWTIME]];
            if (self.nextBtn) {
                [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            }
        }
        else {
            vouchStr = [dic safeObjectForKey:SHOWTIME];
            if (self.nextBtn) {
                [self.nextBtn setTitle:@"提交订单" forState:UIControlStateNormal];
            }
        }
        
        self.vouchTips = vouchStr;
        vouchView.moneyValue = [self getOriginVouchMoney];
    }
    
    if(roomcount >= roomSelectView.guaranteeNum && roomSelectView.guaranteeNum){
        if (self.nextBtn) {
            [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
    }
    
    if ([RoomType isPrepay])
    {
        if (self.nextBtn)
        {
            if (payTable.selectedPayType == UniformPaymentTypeCreditCard)
            {
                [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            }
            else
            {
                [self.nextBtn setTitle:@"提交订单" forState:UIControlStateNormal];
            }
        }
    }
    
    // 重置重用联系人按钮位置
    [self resetCustomerSelBtn];
    
    [orderInfoList reloadData];
    
}

#pragma mark -
#pragma mark FilterDelegate

- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView{
    if (filterView == vouchView) {
        _selectIndex = index;
        currentTimeIndex = index;
        
        NSDictionary *dic = [vouchConditions safeObjectAtIndex:currentTimeIndex];
        NSString *vouchStr = nil;
        if ([[dic safeObjectForKey:NEEDVOUCH] boolValue]) {
            vouchStr = [NSString stringWithFormat:@"%@(需担保)", [dic safeObjectForKey:SHOWTIME]];
            needVouch = YES;
            
            if (self.nextBtn) {
                [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            }
        }
        else {
            vouchStr = [dic safeObjectForKey:SHOWTIME];
            needVouch = NO;
            
            if(roomcount >= roomSelectView.guaranteeNum && roomSelectView.guaranteeNum){
                if (self.nextBtn) {
                    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
                }
            }else{
                if (self.nextBtn) {
                    [self.nextBtn setTitle:@"提交订单" forState:UIControlStateNormal];
                }
            }
            
        }
        
        self.vouchTips = vouchStr;
        
        [orderInfoList reloadData];
    }else if(filterView == specialView){
        
    }else if(filterView == invoiceSelect){
        
    }
}

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView{
    if (filterView == specialView) {
        self.specialTips = filterStr;
        [orderInfoList reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[orderInfoList numberOfRowsInSection:0]-1 inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
    }else if(filterView == invoiceSelect){
        self.invoiceType = filterStr;
        [orderInfoList reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -
#pragma mark SelectRoomerDelegate
- (void) selectRoomer:(SelectRoomer *)selectRoomer didSelectedArray:(NSArray *)array
{
    if (array && array.count) {
        requestOver = YES;
    }
    
    BOOL isRemoved = NO;
    for (NSDictionary *dict in array) {
        if ([[dict safeObjectForKey:@"Checked"] boolValue]) {
            if (!isRemoved) {
                while ([nameArray containsObject:@""]) {
                    for (int i = 0; i < nameArray.count; i++) {
                        if ([[nameArray safeObjectAtIndex:i] isEqualToString:@""]) {
                            [nameArray removeObjectAtIndex:i];
                        }
                    }
                }
                
                isRemoved = YES;
            }
            [nameArray addObject:[dict safeObjectForKey:@"Name"]];
        }
    }
    
    // 如果超过房间数量就移除之前的数据
    if (nameArray.count > roomcount) {
        NSRange range;
        range.location = 0;
        range.length = nameArray.count - roomcount;
        [nameArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    }
    
    
    // 填充
    while (nameArray.count < MAX_ROOM_COUNT) {
        [nameArray addObject:@""];
    }
    
    [orderInfoList reloadData];
    
    UMENG_EVENT(UEvent_Hotel_FillOrder_RoomerSelectAction)
}


#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (currentTextField.isFirstResponder) {
        [currentTextField resignFirstResponder];
        currentTextField = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([RoomType isPrepay] || [self vouchTips]) {
        if (scrollView == orderInfoList){
            CGFloat sectionHeaderHeight = [self tableView:orderInfoList heightForHeaderInSection:1];
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0){
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y,0, 0, 0);
            } else if (scrollView.contentOffset.y>=sectionHeaderHeight){
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        // 房间数量选择
        NSInteger count = 1;
        
        // 非预付时会有房间保留时间
        if (![RoomType isPrepay]) {
            count++;
        }
        
        // 房间入住人
        count = count + roomcount;
        
        // 联系人手机
        count++;
        
        // 特殊要求(大床，双床可选择)
        if (bedSelectable) {
            count++;
        }
        return count;
    }
    else if (section == 1)
    {
        return 1;
    }
    else{
        if ([RoomType isPrepay]&&invoiceMode==1)
        {
            if (needInvoice) {
                return 4 + (invoiceAddresses.count?invoiceAddresses.count + 1:0);
            }else{
                return 1;
            }
        }else{
            return 0;
        }
    }
}


- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (([RoomType isPrepay]||[self isVouch]) && !delegate.isNonmemberFlow) {
            return 225 + 6;
        }else{
            return 0;
        }
    }
    return 44;
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        float height = 0.0f;
        if (self.cheapest) {
            height += 30;
        }
        
        return height;
    }else if(section == 1){
        float height = 0.0f;
        
        NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
        NSInteger guestType = [[room objectForKey:@"GuestType"] intValue];
        // 增加内宾提示
        if (2 == guestType) {
            height += 30;
        }
        
        NSInteger coupon = [self getBackPrice];
        // 移到section 0中
//        if (self.cheapest) {
//            height += 30;
//        }
        if (coupon) {
            height += 40;
        }
        if (daysofonperson * roomcount > totalValue) {
            height += 30;
        }
        if (height < 1.0f) {
            height = 20;
        }
        return height;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self tableView:tableView heightForHeaderInSection:section])];
    //sectionView.backgroundColor = [UIColor redColor];
    if (section == 0) {
        NSInteger posY = 6;
        // 最优惠房间
        if (self.cheapest) {
            NSString *leftText = @"● 恭喜，您找到的是该酒店";
            NSString *centerText = @"最优惠";
            NSString *rightText = @"的客房。别错过！";
            CGSize size;
            NSUInteger posX = 12;
            UILabel *left = [[[UILabel alloc] init] autorelease];
            size = [leftText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1024, 20) lineBreakMode:NSLineBreakByWordWrapping];
            left.frame = CGRectMake(posX, posY, size.width, size.height);
            left.text = leftText;
            left.backgroundColor = [UIColor clearColor];
            left.font = [UIFont systemFontOfSize:13];
            left.textColor = RGBACOLOR(57, 57, 57, 1);
            [sectionView addSubview:left];
            posX += size.width;
            
            UILabel *center = [[[UILabel alloc] init] autorelease];
            size = [centerText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1024, 20) lineBreakMode:NSLineBreakByWordWrapping];
            center.frame = CGRectMake(posX, posY, size.width, size.height);
            center.text = centerText;
            center.backgroundColor = [UIColor clearColor];
            center.textColor = RGBACOLOR(252, 152, 44, 1);
            center.font = [UIFont systemFontOfSize:13];
            [sectionView addSubview:center];
            posX += size.width;
            
            UILabel *right = [[[UILabel alloc] init] autorelease];
            size = [rightText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1024, 20) lineBreakMode:NSLineBreakByWordWrapping];
            right.frame = CGRectMake(posX, posY, size.width, size.height);
            right.text = rightText;
            right.backgroundColor = [UIColor clearColor];
            right.textColor = RGBACOLOR(57, 57, 57, 1);
            right.font = [UIFont systemFontOfSize:13];
            [sectionView addSubview:right];
            //            posY = 24;
            posY += size.height;
        }
    }else if(section == 1){
        NSInteger posY = 6;
        
        NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
        NSInteger guestType = [[room objectForKey:@"GuestType"] intValue];
        // 增加内宾提示
        if (2 == guestType) {
            NSString *tip = @"您预订的房为内宾价格, 须持大陆身份证才能入住";
            CGSize size = [tip sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1024, 20) lineBreakMode:NSLineBreakByWordWrapping];
            AttributedLabel *roomTypeTipLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(12, posY, size.width, size.height)];
            roomTypeTipLabel.text = tip;
            roomTypeTipLabel.backgroundColor = [UIColor clearColor];

            [roomTypeTipLabel setColor:RGBACOLOR(57, 57, 57, 1) fromIndex:0 length:6];
            [roomTypeTipLabel setColor:RGBACOLOR(252, 152, 44, 1) fromIndex:6 length:2];
            [roomTypeTipLabel setColor:RGBACOLOR(57, 57, 57, 1) fromIndex:8 length:16];
            [roomTypeTipLabel setFont:FONT_13 fromIndex:0 length:roomTypeTipLabel.text.length];
            [sectionView addSubview:roomTypeTipLabel];
            [roomTypeTipLabel release];
            posY += 24;
        }
        
//        // 最优惠房间
//        if (self.cheapest) {
//            NSString *leftText = @"● 恭喜，您找到的是该酒店";
//            NSString *centerText = @"最优惠";
//            NSString *rightText = @"的客房。别错过！";
//            CGSize size;
//            NSUInteger posX = 12;
//            UILabel *left = [[[UILabel alloc] init] autorelease];
//            size = [leftText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1024, 20) lineBreakMode:NSLineBreakByWordWrapping];
//            left.frame = CGRectMake(posX, posY, size.width, size.height);
//            left.text = leftText;
//            left.backgroundColor = [UIColor clearColor];
//            left.font = [UIFont systemFontOfSize:13];
//            left.textColor = RGBACOLOR(57, 57, 57, 1);
//            [sectionView addSubview:left];
//            posX += size.width;
//            
//            UILabel *center = [[[UILabel alloc] init] autorelease];
//            size = [centerText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1024, 20) lineBreakMode:NSLineBreakByWordWrapping];
//            center.frame = CGRectMake(posX, posY, size.width, size.height);
//            center.text = centerText;
//            center.backgroundColor = [UIColor clearColor];
//            center.textColor = RGBACOLOR(252, 152, 44, 1);
//            center.font = [UIFont systemFontOfSize:13];
//            [sectionView addSubview:center];
//            posX += size.width;
//            
//            UILabel *right = [[[UILabel alloc] init] autorelease];
//            size = [rightText sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(1024, 20) lineBreakMode:NSLineBreakByWordWrapping];
//            right.frame = CGRectMake(posX, posY, size.width, size.height);
//            right.text = rightText;
//            right.backgroundColor = [UIColor clearColor];
//            right.textColor = RGBACOLOR(57, 57, 57, 1);
//            right.font = [UIFont systemFontOfSize:13];
//            [sectionView addSubview:right];
////            posY = 24;
//            posY += size.height;
//        }
        
        NSInteger coupon = [self getBackPrice];
        
        if(coupon != 0){
            UIButton *checkButton = [[[UIButton alloc] initWithFrame:CGRectMake(7, posY, 192, 32)] autorelease];
            [checkButton setImage:[UIImage noCacheImageNamed:@"btn_checkbox.png"] forState:UIControlStateNormal];
            [checkButton setImage:[UIImage noCacheImageNamed:@"btn_checkbox_checked.png"] forState:UIControlStateSelected];
            [checkButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 160)];
            [checkButton addTarget:self action:@selector(useCouponOrNot:) forControlEvents:UIControlEventTouchUpInside];
            checkButton.selected = self.couponEnabled;
            checkButton.adjustsImageWhenDisabled = NO;
            checkButton.adjustsImageWhenHighlighted = NO;
            [sectionView addSubview:checkButton];
            
            UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40, posY + 8, 220, 16)] autorelease];
            textLabel.font = [UIFont systemFontOfSize:13];
            textLabel.textColor = RGBACOLOR(57, 57, 57, 1);
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.tag = COUPON_TIPS_TAG;
            [sectionView addSubview:textLabel];
            
            if (![RoomType isPrepay]) {
                // 返现
                textLabel.text = [NSString stringWithFormat:@"使用消费券返现%d元", coupon];
                UIButton *couponButton = [[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 112, posY, 112, 32)] autorelease];
                
                [couponButton setImage:[UIImage noCacheImageNamed:@"ico_rightarrow.png"] forState:UIControlStateNormal];
                [couponButton setImageEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
                couponButton.titleLabel.font = [UIFont systemFontOfSize:13];
                [couponButton setTitleColor:RGBACOLOR(153, 153, 153, 1) forState:UIControlStateNormal];
                [couponButton setTitleColor:RGBACOLOR(100, 100, 100, 1) forState:UIControlStateHighlighted];
                [couponButton setTitle:@"怎么获取返现" forState:UIControlStateNormal];
                [couponButton addTarget:self action:@selector(couponIntroduction:) forControlEvents:UIControlEventTouchUpInside];
                [sectionView addSubview:couponButton];
            }else{
                // 预付立减
                textLabel.text = [NSString stringWithFormat:@"使用消费券立减%d元", coupon];
            }
            
            
            posY += 32;
            
            UILabel *tipsLbl = [[[UILabel alloc] initWithFrame:CGRectMake(40, posY, SCREEN_WIDTH - 50, 16)] autorelease];
            tipsLbl.font = [UIFont systemFontOfSize:13];
            tipsLbl.textColor = RGBACOLOR(30, 30, 30, 1);
            tipsLbl.backgroundColor = [UIColor clearColor];
            [sectionView addSubview:tipsLbl];
            tipsLbl.adjustsFontSizeToFitWidth = YES;
            tipsLbl.minimumFontSize = 10.0f;
            if (daysofonperson * roomcount > totalValue) {
                if(![RoomType isPrepay]){
                    tipsLbl.text = [NSString stringWithFormat:@"由于您账户中消费券不足，只能获得%d元返现",coupon];
                }else{
                    tipsLbl.text = [NSString stringWithFormat:@"由于您账户中消费券不足，只能获得%d元立减优惠",coupon];
                }
            }else{
                tipsLbl.text = @"";
            }
        }else{
            // coupon不可用
            self.couponEnabled = NO;
            
            NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
            
            ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            if (delegate.isNonmemberFlow || [room safeObjectForKey:@"HotelCoupon"] == [NSNull null]) {
                // 1、非会员不提示返现信息
                // 2、预付酒店不提示返现信息
                // 3、无返现
                
            }else{
                // 会员提示返现信息
                UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(22, posY + 8, 220, 16)] autorelease];
                textLabel.font = [UIFont systemFontOfSize:13];
                textLabel.textColor = RGBACOLOR(57, 57, 57, 1);
                [sectionView addSubview:textLabel];
                textLabel.backgroundColor = [UIColor clearColor];
                if ([RoomType isPrepay]){
                    textLabel.text = @"您消费券余额为0，无法获得立减优惠";
                }
                else{
                    textLabel.text = @"您消费券余额为0，无法获得返现";
                    
                    UIButton *couponButton = [[[UIButton alloc] initWithFrame:CGRectMake(200, posY, 120, 32)] autorelease];
                    [couponButton setImage:[UIImage noCacheImageNamed:@"ico_rightarrow.png"] forState:UIControlStateNormal];
                    [couponButton setImageEdgeInsets:UIEdgeInsetsMake(0, 108, 0, 0)];
                    couponButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                    [couponButton setTitleColor:[UIColor colorWithRed:0.06 green:0.55 blue:0.79 alpha:1.0] forState:UIControlStateNormal];
                    [couponButton setTitleColor:[UIColor colorWithRed:0.00 green:0.35 blue:0.59 alpha:1.0] forState:UIControlStateHighlighted];
                    [couponButton setTitle:@"怎么获取返现" forState:UIControlStateNormal];
                    [couponButton addTarget:self action:@selector(couponIntroduction:) forControlEvents:UIControlEventTouchUpInside];
                    [sectionView addSubview:couponButton];
                }
                
                posY += 36;
                posY += 6;
                
            }
            
        }
    }
    return [sectionView autorelease];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSInteger count = 1;
        
        if (![RoomType isPrepay]) {
            count++;
        }
        
        count = count + roomcount;
        
        if (indexPath.row < count) {
            static NSString *cellIdentifier0 = @"OrderInfoCell";
            HotelOrderCell *cell = (HotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
            if (!cell) {
                cell = [[[HotelOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == 0) {
                cell.cellType = -1;
            }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] -1){
                cell.cellType = 1;
            }else{
                cell.cellType = 0;
            }
            
            ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [cell setArrowHidden:NO];
            cell.textField.hidden = YES;
            cell.textField.text = @"";
            cell.textField.placeholder = @"姓名";
            [cell setCustomerHidden:YES];
            if (indexPath.row == 0)
            {
                [cell setTitle:@"房间数量"];
                if (roomcount >= roomSelectView.guaranteeNum && roomSelectView.guaranteeNum) {
                    [cell setDetail:[NSString stringWithFormat:@"%d间[担保]",roomcount]];
                }else{
                    [cell setDetail:[NSString stringWithFormat:@"%d间",roomcount]];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }
            else if (indexPath.row == 1)
            {
                // 房间保留时间
                if (![RoomType isPrepay]) {
                    // 非预付流程生成担保相关的界面
                    if (vouchConditions && vouchConditions.count <= 1) {
                        //✽
                        [cell setTitle:[NSString stringWithFormat:@"●%@",self.vouchTips]];
                        [cell setArrowHidden:YES];
                        [cell setDetail:@""];
                    }else{
                        [cell setTitle:@"房间保留时间"];
                        [cell setArrowHidden:NO];
                        [cell setDetail:self.vouchTips];
                        cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    }
                    
                    
                }else{
                    [cell setTitle:[NSString stringWithFormat:@"房间%d入住人",indexPath.row]];
                    [cell setDetail:@""];
                    cell.textField.hidden = NO;
                    cell.textField.tag = indexPath.row + TEXT_FIELD_TAG;
                    cell.textField.returnKeyType = UIReturnKeyNext;
                    cell.textField.delegate = self;
                    [cell setArrowHidden:YES];
                    
                    if (delegate.isNonmemberFlow){
                        [cell setCustomerHidden:YES];
                    }else{
                        [cell setCustomerHidden:NO];
                        if (indexPath.row == count - 1) {
                            // 特殊要求(大床，双床可选择)
                            if (bedSelectable) {
                                [cell disWholeSplitLine];
                            }
                        }
                    }
                    
                    cell.textField.text = @"";
                    
                    // 设置联系人
                    if (![[nameArray safeObjectAtIndex:indexPath.row - 1] isEqualToString:@""]) {
                        cell.textField.text = [nameArray safeObjectAtIndex:indexPath.row - 1];
                    }
                    
                    cell.textField.placeholder = @"姓名";
                    
                    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 2) {
                        [cell disWholeSplitLine];
                    }
                }
            }
            else
            {
                NSInteger rowIndex = 0;
                if (![RoomType isPrepay]) {
                    rowIndex = indexPath.row - 1;
                }else{
                    rowIndex = indexPath.row;
                }
                [cell setTitle:[NSString stringWithFormat:@"房间%d入住人",rowIndex]];
                [cell setDetail:@""];
                cell.textField.hidden = NO;
                cell.textField.tag = indexPath.row + TEXT_FIELD_TAG;
                cell.textField.returnKeyType = UIReturnKeyNext;
                cell.textField.delegate = self;
                [cell setArrowHidden:YES];
                
                if (delegate.isNonmemberFlow){
                    [cell setCustomerHidden:YES];
                }else{
                    [cell setCustomerHidden:NO];
                    if (indexPath.row == count - 1) {
                        // 特殊要求(大床，双床可选择)
                        if (bedSelectable) {
                            [cell disWholeSplitLine];
                        }
                    }
                }
                
                cell.textField.text = @"";
                
                
                // 设置联系人
                if (![[nameArray safeObjectAtIndex:rowIndex - 1] isEqualToString:@""]) {
                    cell.textField.text = [nameArray safeObjectAtIndex:rowIndex - 1];
                }
                
                cell.textField.placeholder = @"姓名";
                
                if (indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 2) {
                    [cell disWholeSplitLine];
                }
                
            }
            return cell;
        }
        else if (indexPath.row == count)
        {
            static NSString *cellIdentifier = @"OrderLinkmanCell";
            HotelOrderLinkmanCell *cell = (HotelOrderLinkmanCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[HotelOrderLinkmanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            [cell setTitle:@"联系人手机"];
            cell.textField.text = self.linkman;
            cell.textField.keyboardType = CustomTextFieldKeyboardTypeNumber;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.tag = indexPath.row + TEXT_FIELD_TAG;
            [cell.addressBoomBtn addTarget:self action:@selector(addressBookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.textField.delegate = self;
            
            return cell;
        }
        else if(indexPath.row == count+1){
            // 特殊要求
            static NSString *cellIdentifier = @"OrderSpecialCell";
            HotelOrderCell *cell = (HotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[HotelOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            
            if (indexPath.row == 0) {
                cell.cellType = -1;
            }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] -1){
                cell.cellType = 1;
            }else{
                cell.cellType = 0;
            }
            
            [cell setArrowHidden:NO];
            cell.textField.hidden = YES;
            [cell setCustomerHidden:YES];
            [cell setTitle:@"大双床要求"];
            [cell setDetail:(self.specialTips?self.specialTips:@"无")];
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        static NSString *identifier = @"paymentCell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.clipsToBounds = YES;
            NSArray *payTypes = [NSArray arrayWithObjects:[NSNumber numberWithInt:UniformPaymentTypeCreditCard], [NSNumber numberWithInt:UniformPaymentTypeWeixin], [NSNumber numberWithInt:UniformPaymentTypeAlipay], [NSNumber numberWithInt:UniformPaymentTypeAlipayWap], nil];
            if ([RoomType isPrepay]) {
                payTable = [[PaymentTypeTable alloc] initWithPaymentTypes:payTypes paySection:UniformPaymentSection];
            }else if([self isVouch]){
                payTable = [[PaymentTypeTable alloc] initWithPaymentTypes:payTypes paySection:UniformGuaranteeSection];
            }else{
                payTable = [[PaymentTypeTable alloc] initWithPaymentTypes:payTypes paySection:UniformPaymentSection];
            }
            [cell.contentView addSubview:payTable];
            payTable.tag = kPayTypeTableTag;
            payTable.backgroundColor = [UIColor clearColor];
            payTable.backgroundView = nil;
            payTable.root = self;
            payTable.frame = CGRectOffset(payTable.frame, 0, -22);
            if ([RoomType isPrepay]) {
                [payTable.ruleBtn setTitle:@"预付规则" forState:UIControlStateNormal];
            }else{
                [payTable.ruleBtn setTitle:@"担保规则" forState:UIControlStateNormal];
            }
            payTable.ruleBtn.hidden = NO;
        }
        payTable = (PaymentTypeTable *)[cell.contentView viewWithTag:kPayTypeTableTag];
        if ([RoomType isPrepay]) {
            payTable.paySection = UniformPaymentSection;
        }else if([self isVouch]){
            payTable.paySection = UniformGuaranteeSection;
        }
        
        
        
        return cell;
    }
    else if(indexPath.section == 2){
        
        if (indexPath.row == 0 || indexPath.row == 1|| indexPath.row == 2 || indexPath.row == 3 || indexPath.row == [self tableView:orderInfoList numberOfRowsInSection:2] - 1) {
            static NSString *cellIdentifier = @"InvoiceCell";
            HotelOrderCell *cell = (HotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[HotelOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                
                
                if (IOSVersion_6){
                    MBSwitch *invoiceSwitchBtn = [[MBSwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, (44-30) / 2, 50, 30)];
                    invoiceSwitchBtn.on = NO;
                    invoiceSwitchBtn.tag = 1011;
                    
                    invoiceSwitchBtn.on = needInvoice;
                    [cell addSubview:invoiceSwitchBtn];
                    [invoiceSwitchBtn release];
                    invoiceSwitchBtn.hidden = YES;
                    [invoiceSwitchBtn addTarget:self action:@selector(invoiceSwitchBtnClick:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:invoiceSwitchBtn];
                }
                else{
                    // IOS4系统使用系统自带的控件
                    UISwitch *invoiceSwitchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(211, (44-28) / 2, 70, 33)];
                    invoiceSwitchBtn.on = NO;
                    invoiceSwitchBtn.tag = 1011;
                    invoiceSwitchBtn.on = needInvoice;
                    [cell addSubview:invoiceSwitchBtn];
                    [invoiceSwitchBtn release];
                    invoiceSwitchBtn.hidden = YES;
                    [invoiceSwitchBtn addTarget:self action:@selector(invoiceSwitchBtnClick:) forControlEvents:UIControlEventValueChanged];
                    [cell.contentView addSubview:invoiceSwitchBtn];
                }
                

                
                
                UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityView.frame = CGRectMake(SCREEN_WIDTH - 30, 12, 20, 20);
                activityView.tag = 1012;
                [cell addSubview:activityView];
                [activityView release];
                activityView.hidden = YES;
                
            }
            if (indexPath.row == 0) {
                cell.cellType = -1;
            }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] -1){
                cell.cellType = 1;
            }else{
                cell.cellType = 0;
            }
            
            [cell setArrowHidden:YES];
            cell.textField.hidden = YES;
            [cell setCustomerHidden:YES];
            [cell setTitle:@""];
            [cell setDetail:@""];
            
            if (IOSVersion_5) {
                
            }
            UIView *invoiceSwitchBtn = (UIView *)[cell viewWithTag:1011];
            UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[cell viewWithTag:1012];
            invoiceSwitchBtn.hidden = YES;
            activityView.hidden = YES;
            if (indexPath.row == 0) {
                if (IOSVersion_5) {
                    ((MBSwitch *)invoiceSwitchBtn).on = needInvoice;
                }else{
                    ((UISwitch *)invoiceSwitchBtn).on = needInvoice;
                }
                
                invoiceSwitchBtn.hidden = NO;
                [cell setTitle:@"需要发票"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (needInvoice) {
                    if (addressEnabled) {
                        [activityView stopAnimating];
                        activityView.hidden = YES;
                        invoiceSwitchBtn.hidden = NO;
                    }else{
                        [activityView startAnimating];
                        activityView.hidden = NO;
                        invoiceSwitchBtn.hidden = YES;
                    }
                }else{
                    [activityView stopAnimating];
                    activityView.hidden = YES;
                    invoiceSwitchBtn.hidden = NO;
                }
                
            }else if(indexPath.row == 1){
                [cell setTitle:@"抬头"];
                cell.textField.hidden = NO;
                cell.textField.placeholder = @"输入发票抬头";
                cell.textField.delegate = self;
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.tag = INVOICE_FIELD_TAG + indexPath.row;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textField.frame = CGRectMake(100 + 12 - 60, 0, 170 + 80 , 44);
                if (self.invoiceTitle) {
                    cell.textField.text = self.invoiceTitle;
                }
            }else if(indexPath.row == 2){
                [cell setTitle:@"选择发票类型"];
                [cell setArrowHidden:NO];
                [cell setDetail:self.invoiceType];
            }else if(indexPath.row == [self tableView:orderInfoList numberOfRowsInSection:2] - 1){
                [cell setTitle:@"新增邮寄地址"];
                [cell setArrowHidden:NO];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            }else if(indexPath.row == 3){
                [cell setTitle:@"选择邮寄地址"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                [cell setTitle:[NSString stringWithFormat:@"地址%d",indexPath.row - 4]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }else{
            static NSString *cellIdentifier = @"InvoiceAddressCell";
            HotelOrderInvoiceCell *cell = (HotelOrderInvoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[HotelOrderInvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSDictionary *addressDict = [invoiceAddresses objectAtIndex:indexPath.row - 4];
            cell.detailLabel.text = [NSString stringWithFormat:@"%@ / %@",[addressDict objectForKey:KEY_NAME],[addressDict objectForKey:KEY_ADDRESS_CONTENT]];
            if (indexPath.row - 4 == self.invoiceIndex) {
                cell.checked = YES;
            }else{
                cell.checked = NO;
            }
            return cell;
        }
        return nil;
    }
    
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 刷新
            [roomSelectView showInView];
            
            // 如果vouchView存在，隐藏之
            if (vouchView) {
                [vouchView dismissInView];
            }
            if (currentTextField) {
                [currentTextField resignFirstResponder];
                currentTextField = nil;
            }
            if (specialView) {
                [specialView dismissInView];
            }
            if (invoiceSelect) {
                [invoiceSelect dismissInView];
            }
            
            // countly 房间数量点击事件
            CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
            countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
            countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_ROOMNUMBER;
            [countlyEventClick sendEventCount:1];
            [countlyEventClick release];
        }else if(indexPath.row == 1){
            if (![RoomType isPrepay]){
                if (vouchConditions) {
                    vouchView.view.hidden = NO;
                    [vouchView showInView];
                    
                    // 隐藏roomSelectView
                    [roomSelectView dismissInView];
                    
                    if (currentTextField) {
                        [currentTextField resignFirstResponder];
                        currentTextField = nil;
                    }
                    if (specialView) {
                        [specialView dismissInView];
                    }
                    if (invoiceSelect) {
                        [invoiceSelect dismissInView];
                    }
                    
                    // countly 房间保留时间点击事件
                    CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                    countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
                    countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_TIMERESERVE;
                    [countlyEventClick sendEventCount:1];
                    [countlyEventClick release];
                }
                else {
                    [PublicMethods showAlertTitle:@"未能获取担保时间，请稍候再试" Message:nil];
                }
            }
        }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:0] - 1){
            if (self.bedSelectable) {
                if (vouchView) {
                    [vouchView dismissInView];
                }
                
                if (roomSelectView) {
                    [roomSelectView dismissInView];
                }
                
                if (currentTextField) {
                    [currentTextField resignFirstResponder];
                    currentTextField = nil;
                }
                if (invoiceSelect) {
                    [invoiceSelect dismissInView];
                }
                specialView.view.hidden = NO;
                [specialView showInView];
                
                // countly 特殊要求点击事件
                CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
                countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
                countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_SPECIALNEEDS;
                [countlyEventClick sendEventCount:1];
                [countlyEventClick release];
            }
        }
    }else if(indexPath.section == 2){
        NSInteger rowCount = [self tableView:orderInfoList numberOfRowsInSection:2];
        if (rowCount == 1) {
            return;
        }
        if (indexPath.row == rowCount - 1) {
            
            // 新增邮寄地址
            if (currentTextField) {
                [currentTextField resignFirstResponder];
                currentTextField = nil;
            }
            
            [self showAddAddressView];
            
        }else if (indexPath.row - 4 >= 0) {
            self.invoiceIndex = indexPath.row - 4;
            NSMutableArray *indexArray = [NSMutableArray array];
            for (int i = 4; i < rowCount; i++) {
                [indexArray addObject:[NSIndexPath indexPathForRow:i inSection:2]];
            }
            [orderInfoList reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
        }else if (indexPath.row == 2){
            if (!invoiceSelect) {
                // 发票类型选择器
                invoiceSelect = [[FilterView alloc] initWithTitle:@"发票类型"
                                                            Datas:[NSArray arrayWithObjects:@"会务费", @"会议费", @"旅游费", @"差旅费", @"服务费", @"住宿费", nil]];
                invoiceSelect.delegate = self;
                [self.view addSubview:invoiceSelect.view];
            }
            
            if (vouchView) {
                [vouchView dismissInView];
            }
            if (currentTextField) {
                [currentTextField resignFirstResponder];
                currentTextField = nil;
            }
            if (specialView) {
                [specialView dismissInView];
            }
            if (roomSelectView) {
                [roomSelectView dismissInView];
            }
            [invoiceSelect showInView];
        }
    }
}

#pragma mark -
#pragma mark AddAddressNotification

- (void)getFillInfo:(NSNotification *)noti {
	// 接收新加入的地址信息
	NSDictionary *dDictionary = (NSDictionary *)[noti object];
    
    NSDictionary *addressDict = [NSDictionary dictionaryWithObjectsAndKeys:[dDictionary safeObjectForKey:KEY_NAME],KEY_NAME,[dDictionary safeObjectForKey:KEY_ADDRESS_CONTENT],KEY_ADDRESS_CONTENT, nil];
	
	[invoiceAddresses addObject:addressDict];
    self.invoiceIndex = invoiceAddresses.count - 1;
    [orderInfoList reloadData];
}

#pragma mark -
#pragma mark CustomABDelegate
- (void)getSelectedString:(NSString *)selectedStr
{
	// 填充电话
    self.linkman = [selectedStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [orderInfoList reloadData];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    NSInteger index = 0;
    if (textField.returnKeyType == UIReturnKeyNext) {
        index = textField.tag - TEXT_FIELD_TAG;
        if (index < [self tableView:orderInfoList numberOfRowsInSection:0]-1) {
            HotelOrderCell *orderCell = (HotelOrderCell *)[orderInfoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index + 1 inSection:0]];
            [orderCell.textField becomeFirstResponder];
        }else if(index == [self tableView:orderInfoList numberOfRowsInSection:0]-1){
            HotelOrderLinkmanCell *orderLinkCell = (HotelOrderLinkmanCell *)[orderInfoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [orderLinkCell.textField becomeFirstResponder];
        }
        return NO;
    }else if(textField.returnKeyType == UIReturnKeyDone){
        currentTextField = nil;
        return YES;
    }
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[CustomTextField class]]){
        CustomTextField *linkmanField = (CustomTextField *)textField;
        [linkmanField resetTargetKeyboard];
        linkmanField.numberOfCharacter = 11;
        linkmanField.abcEnabled = NO;
        [linkmanField showNumKeyboard];
        
        
        currentTextField = textField;
        // 如果vouchView存在，隐藏之
        if (vouchView)
        {
            [vouchView dismissInView];
        }
        // 隐藏roomSelectView
        [roomSelectView dismissInView];
        
        // 隐藏发票抬头选择
        if (invoiceSelect) {
            [invoiceSelect dismissInView];
        }
        
        if (textField.tag - INVOICE_FIELD_TAG > 100) {
            // 调整orderinfolist的大小
            NSInteger scrollIndex = textField.tag - TEXT_FIELD_TAG - 1;
            if (scrollIndex >= 0) {
                [orderInfoList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:0]
                                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            
        }else{
            NSInteger scrollIndex = textField.tag - INVOICE_FIELD_TAG - 1;
            if (scrollIndex >= 0) {
                [orderInfoList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:2]
                                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
        
    }else{
        currentTextField = textField;
        // 如果vouchView存在，隐藏之
        if (vouchView) {
            [vouchView dismissInView];
        }
        // 隐藏roomSelectView
        [roomSelectView dismissInView];
        
        // 隐藏发票抬头选择
        if (invoiceSelect) {
            [invoiceSelect dismissInView];
        }
        
        if (textField.tag - INVOICE_FIELD_TAG > 100) {
            NSInteger scrollIndex = textField.tag - TEXT_FIELD_TAG - 1;
            if (scrollIndex >= 0) {
                [orderInfoList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:0]
                                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }else{
            NSInteger scrollIndex = textField.tag - INVOICE_FIELD_TAG - 1;
            if (scrollIndex >= 0) {
                [orderInfoList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:scrollIndex inSection:2]
                                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag - INVOICE_FIELD_TAG > 100) {
        if ([textField isKindOfClass:[CustomTextField class]]){
            // 联系人
            NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
            self.linkman = tagStr;
            if (self.linkman.length >=11) {
                self.linkman = [self.linkman substringToIndex:11];
                return YES;
            }
        }else{
            // 房间入住人
            NSInteger index;
            if (![RoomType isPrepay]){
                index = textField.tag - TEXT_FIELD_TAG - 1 - 1;
            }else{
                index = textField.tag - TEXT_FIELD_TAG - 1;
            }
            NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSLog(@"---%@",tagStr);
            [nameArray replaceObjectAtIndex:index withObject:tagStr];
        }
    }else{
        // 发票抬头
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.invoiceTitle = tagStr;
    }
    return YES;
}

- (void) textFieldDidChange:(NSNotification *)notification{
    if(self.navigationController.topViewController != self){
        return;
    }
    
    UITextField *textField = (UITextField *)notification.object;
    
    if (textField.tag - INVOICE_FIELD_TAG > 100) {
        if ([textField isKindOfClass:[CustomTextField class]]){
            
        }else{
            // 房间入住人
            NSInteger index;
            if (![RoomType isPrepay]){
                index = textField.tag - TEXT_FIELD_TAG - 1 - 1;
            }else{
                index = textField.tag - TEXT_FIELD_TAG - 1;
            }
            [nameArray replaceObjectAtIndex:index withObject:textField.text];
        }
    }else{
        // 发票抬头
        self.invoiceTitle = textField.text;
    }
}

- (void)go2loginview
{
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:FillHotelOrder_login];
    [delegate.navigationController pushViewController:login animated:YES];
    [login release];
}


#pragma mark -
#pragma mark ButtonView Delegate

- (void)ButtonViewIsPressed:(ButtonView *)button
{
    [super ButtonViewIsPressed:button];
    
	UIImageView *tickImg = (UIImageView *)[button viewWithTag:kTickImageTag];
	tickImg.highlighted = button.isSelected;
	needInvoice = button.isSelected;
    
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData{
    // 联系人预加载
    if (util == getRoomerUtil) {
        NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *root = [string JSONValue];
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return ;
        }
        NSArray *customers = [root safeObjectForKey:@"Customers"];
        
        for (NSDictionary *customer in customers) {
            if ([customer safeObjectForKey:@"Name"]!=[NSNull null]) {
                NSString *name = [customer safeObjectForKey:@"Name"];
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:name,@"Name",[NSNumber numberWithBool:NO],@"Checked", nil];
                [[SelectRoomer allRoomers] addObject:dict];
            }
        }
        
        requestOver = YES;
        
        // 联系人加载成功之后，如果发现用户上次没有保存联系人信息，加载用户联系人组中第一位
        BOOL exist = NO;
        if (nameArray) {
            for (NSString *roomer in nameArray) {
                if(![roomer isEqualToString:@""]){
                    exist = YES;
                }
            }
        }
        if (!exist && customers.count) {
            NSDictionary *customer = [customers objectAtIndex:0];
            if ([customer safeObjectForKey:@"Name"] != [NSNull null]) {
                NSString *name = [customer safeObjectForKey:@"Name"];
                [nameArray replaceObjectAtIndex:0 withObject:name];
                [orderInfoList reloadData];
            }
        }
    }else if(util == addressUtil){
        // 请求邮寄地址
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        for (NSDictionary *dict in [root safeObjectForKey:KEY_ADDRESSES]) {
            NSMutableDictionary *dDictionary = [[NSMutableDictionary alloc] init];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_CONTENT] forKey:KEY_ADDRESS_CONTENT];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
            [invoiceAddresses addObject:dDictionary];
            [dDictionary release];
        }
        addressEnabled = YES;
        [orderInfoList reloadData];
    }
    //特殊提示
    else if(util == bedTipsUtil)
    {
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        
        NSLog(@"%@",root);
        
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return ;
        }

        //有特殊提示创建下
        if ([self createSpecialView:[root safeObjectForKey:@"tips"]])
        {
            self.bedSelectable = YES;
            [orderInfoList reloadData];
        }
    }
    else{
        switch (m_netstate) {
            case SELECTCARD_STATE:{
                NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
                NSDictionary *root = [string JSONValue];
                if ([Utils checkJsonIsError:root]) {
                    return ;
                }
                
                [[SelectCard allCards] removeAllObjects];
                if ([root safeObjectForKey:@"CreditCards"]!=[NSNull null]) {
                    [[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
                }
                if ([[SelectCard allCards] count] <= 0)
                {
                    // 当没有客史信用卡列表时，请求银行列表
                    [self requestBankList];
                }
                else
                {
                    [self goSelectCard];
                }
            }
                break;
            case CHECKROOMCOUNT:{
                NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
                NSDictionary *root = [string JSONValue];
                if ([Utils checkJsonIsError:root]) {
                    return ;
                }
                BOOL followBooking = [[root safeObjectForKey:@"IsAvailable"] boolValue];
                if (followBooking) {
                    [self booking];
                }else {
                    [Utils alert:@"该房型满房，请选择其它房型入住！"];
                }
            }
                break;
            case CHECK_CASHACCOUNT:{
                canUseCA = NO;                 // 是否可使用CA支付
                
                NSDictionary *root = [PublicMethods unCompressData:responseData];
                if ([[root safeObjectForKey:CACHE_ACCOUNT_AVAILABLE] safeBoolValue] &&
                    [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue] > 0)
                {
                    // CA可用的情况
                    CashAccountReq *cashAccount = [CashAccountReq shared];
                    cashAccount.needPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
                    cashAccount.cashAccountRemain = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
                    
                    // 根据选择情况，清空或增加coupon
                    if (self.couponEnabled){
                        [self addCoupons];
                    }
                    else{
                        [[HotelPostManager hotelorder] setClearCoupons];
                    }
                    
                    canUseCA = YES;
                }
                
                m_netstate=SELECTCARD_STATE;
                [[MyElongPostManager card] clearBuildData];
                [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:NO] delegate:self];
            }
                break;
            case NET_TYPE_BANKLIST:
            {
                NSDictionary *root = [PublicMethods unCompressData:responseData];
                if ([Utils checkJsonIsError:root])
                {
                    return;
                }
                [[SelectCard cardTypes] removeAllObjects];
                [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
                [[CacheManage manager] setBankListData:responseData];
                
                // 进入新增信用卡页面
                [self goSelectCard];
            }
                break;
        }
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == getRoomerUtil) {
        requestOver = NO;
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if (util == getRoomerUtil) {
        requestOver = NO;
    }
}

#pragma mark - PaymentTypeTableDelegate

- (void) paymentTypeRuleAction:(PaymentTypeTable *)paymentType{
    
    NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
    NSString *rule = @"";
    if ([RoomType isPrepay]) {
        NSArray *rules = [dic safeObjectForKey:@"PrepayRules"];
        if (ARRAYHASVALUE(rules)) {
            NSString *ruleString = [[rules safeObjectAtIndex:0] safeObjectForKey:@"Description"];
            rule = ruleString;
        }
        
        UMENG_EVENT(UEvent_Hotel_FillOrder_PrepayRule)
    }else{
        if ([dic objectForKey:@"VouchSet"] != [NSNull null]) {
            rule = [[dic safeObjectForKey:@"VouchSet"] safeObjectForKey:@"Descrition"];
        }
        UMENG_EVENT(UEvent_Hotel_FillOrder_GuaranteeRule)
    }
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 100, 10000);
    CGSize newSize = [rule sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    
    ruleView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, (newSize.height < 60)?60 + 40:(newSize.height + 40))];
    ruleView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    ruleView.backgroundColor = [UIColor whiteColor];

    UILabel *ruleTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ruleView.frame.size.width, 30)];
    ruleTitleLbl.font = [UIFont boldSystemFontOfSize:16.0f];
    ruleTitleLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    ruleTitleLbl.textAlignment = UITextAlignmentCenter;
    ruleTitleLbl.backgroundColor = [UIColor clearColor];
    [ruleView addSubview:ruleTitleLbl];
    [ruleTitleLbl release];
    
    UILabel *ruleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, ruleView.frame.size.width - 20, newSize.height)];
    ruleLbl.font = [UIFont systemFontOfSize:14.0f];
    ruleLbl.textColor = RGBACOLOR(98, 98, 98, 1);
    ruleLbl.numberOfLines = 0;
    ruleLbl.backgroundColor = [UIColor clearColor];
    ruleLbl.lineBreakMode = UILineBreakModeCharacterWrap;
    [ruleView addSubview:ruleLbl];
    [ruleLbl release];
    ruleLbl.text = rule;
    
    if ([RoomType isPrepay]) {
        // 预付规则
        ruleTitleLbl.text = @"预付规则";
        
        // countly 预付规则点击事件
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_PREPAYRULE;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }else{
        // 担保规则
        ruleTitleLbl.text = @"担保规则";
        
        // countly 担保规则点击事件
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_HOTELFILLINORDERPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_VOUCHRULE;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }
    
    mark = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    mark.backgroundColor = RGBACOLOR(0, 0, 0, 0.8);
    
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:mark];
    [mark release];
    mark.alpha = 0.0f;
    
    [delegate.window addSubview:ruleView];
    [ruleView release];
    ruleView.alpha = 0.0f;
    
    
    UITapGestureRecognizer *gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeRule)] autorelease];
    [mark addGestureRecognizer:gesture];
    
    // 右上角取消按钮
    cancelRuleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelRuleBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
    [cancelRuleBtn addTarget:self action:@selector(closeRule) forControlEvents:UIControlEventTouchUpInside];
    cancelRuleBtn.frame = CGRectMake(ruleView.frame.origin.x + ruleView.frame.size.width - 28, ruleView.frame.origin.y - 28, 57, 57);
    [delegate.window addSubview:cancelRuleBtn];
    cancelRuleBtn.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^{
        mark.alpha = 1.0f;
        ruleView.alpha = 1.0f;
        cancelRuleBtn.alpha = 1.0f;
    }];
    
    
}

- (void) closeRule{
    [UIView animateWithDuration:0.3 animations:^{
        mark.alpha = 0.0f;
        ruleView.alpha = 0.0f;
        cancelRuleBtn.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [mark removeFromSuperview];
        mark = nil;
        [ruleView removeFromSuperview];
        ruleView = nil;
        [cancelRuleBtn removeFromSuperview];
        cancelRuleBtn = nil;
    }];
}

- (void)selectPayment:(UniformPaymentType)type
{
    if ([RoomType isPrepay]) {
        if (type == UniformPaymentTypeCreditCard)
        {
            [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
        else
        {
            [nextBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        }
    }else if([self isVouch]){
        if (type == UniformPaymentTypeCreditCard)
        {
            [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
        else
        {
            [nextBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        }
    }
    
    switch (type) {
        case UniformPaymentTypeCreditCard:{
            // 信用卡支付
            self.vouchSetType = VouchSetTypeCreditCard;
        }
            break;
        case UniformPaymentTypeDepositCard:{
            // 储蓄卡支付
            self.vouchSetType = VouchSetTypeAlipayWap;
        }
            break;
        case UniformPaymentTypeWeixin:{
            // 微信支付
            self.vouchSetType = VouchSetTypeWeiXinPayByApp;
        }
            break;
        case UniformPaymentTypeAlipay:{
            // 支付宝客户端支付
            self.vouchSetType = VouchSetTypeAlipayApp;
        }
            break;
        case UniformPaymentTypeAlipayWap:{
            // 支付宝网页支付
            self.vouchSetType = VouchSetTypeAlipayWap;
        }
            break;
        default:
            break;
    }
}

@end