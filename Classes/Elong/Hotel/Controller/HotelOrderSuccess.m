//
//  HotelOrderSuccess.m
//  ElongClient
//
//  Created by bin xing on 11-1-5.
//  Copyright 2011 DP. All rights reserved.
//
#define VALUE_XOFFSET 3
#define Y_SPACE 16

#import "HotelOrderSuccess.h"
#import "CouponRule.h"
#import "DefineHotelResp.h"
#import "OrderManagement.h"
#import "FXLabel.h"
#import "NHotelOrderReq.h"
#import "ShareTools.h"
#import "GoogleConversionPing.h"
#import "CouponIntroductionController.h"
#import "IMAdTracker.h"
#import <MapKit/MapKit.h>
#import "AttributedLabel.h"
#import "UniformCounterViewController.h"
#import "AlixPay.h"
#import "HotelOrderListViewController.h"
#import "CountlyEventShow.h"
#import "HotelPromotionInfoRequest.h"
//#import "ForecastViewController.h"

#define NETFOR_ALIPAY 0
#define NETFOR_WEIXINPAY 1
#define NETFOR_ORDERLIST 2
#define NETFOR_ALIPAYAPP 3
#define AliapyAlertTag 8701


@interface HotelOrderSuccess()
@property (nonatomic,assign) VouchSetType payType;
@property (nonatomic,copy) NSString *hotelOrder;
@property (nonatomic,assign) NSInteger nettype;
@property (nonatomic,copy) NSString *orderRule;
@property(nonatomic,copy) NSString *cashNoteContent;
@property (nonatomic,copy) NSString *payTips;
//@property (nonatomic, retain) ForecastViewController *forecastVC;
@end

@implementation HotelOrderSuccess
@synthesize payType;
@synthesize localOrderArray;
@synthesize imagefromparentview;
@synthesize hotelOrder;
@synthesize nettype;
@synthesize cashNoteContent;
@synthesize payTips;

- (void)dealloc {
    [[Coupon activedcoupons] removeAllObjects];     // 页面销毁时，清空coupon
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    SFRelease(pass);
    [passUtil cancel];
    SFRelease(passUtil);
    [cashDespUtil cancel];
    SFRelease(cashDespUtil);
    SFRelease(promotionInfoUtil);
    
	self.localOrderArray = nil;
	self.hotelOrder = nil;
    self.orderRule = nil;
    self.payTips = nil;
//    self.forecastVC = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [super dealloc];
}


- (id)init {
    NSString *orderString=[NSString stringWithFormat:@"%li",[[HotelPostManager hotelorder] orderNo]];
    return [self initWithPayType:VouchSetTypeNormal order:orderString];
}

- (id) initWithPayType:(VouchSetType)type order:(NSString *)order{
    if (self = [super initWithTopImagePath:nil andTitle:_string(@"s_hotel_ordersuccess") style:_NavBackShareHomeTelStyle_]) {
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20 - 44);
		[self setShowBackBtn:NO];
        self.payType = type;
        self.hotelOrder = order;
        if ([RoomType isPrepay]) {
            self.payTips = @"支付";
        }else{
            self.payTips = @"担保";
        }
        
        if (self.payType == VouchSetTypeNormal || self.payType == VouchSetTypeCreditCard) {
            [self setShowBackBtn:YES];
            self.cashNoteContent = @"";
            [self requestCashDescription];      //请求返券内容描述
            if ([RoomType isPrepay]) {
                UMENG_EVENT(UEvent_Hotel_OrderSuccess_Prepay)
            }else{
                UMENG_EVENT(UEvent_Hotel_OrderSuccess_Guarantee)
            }
            [self requestPromotionInfo];
        }

        [self makeUpView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAlipayWap:) name:NOTI_ALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPaySuccess) name:NOTI_WEIXIN_PAYSUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
	}
    return self;
}

// 统计用户成单信息
- (void) requestPromotionInfo{
    HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
    promotionInfoRequest.orderId = self.hotelOrder;
    NSString *url = [PublicMethods composeNetSearchUrl:@"hotel" forService:@"saveOrderPromotionInfo"];
    
    if (promotionInfoUtil) {
        [promotionInfoUtil cancel];
        SFRelease(promotionInfoUtil);
    }
    
    promotionInfoUtil = [[HttpUtil alloc] init];
    [promotionInfoUtil requestWithURLString:url Content:[promotionInfoRequest requestString] StartLoading:NO EndLoading:NO Delegate:self];
}


-(void)requestCashDescription{
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonDictionary setObject:@"Iphone" forKey:@"productLine"];
    [jsonDictionary setObject:@"Hotel" forKey:@"channel"];
    [jsonDictionary setObject:@"Finish" forKey:@"page"];
    [jsonDictionary setObject:@"ReturnCashDescription" forKey:@"positionId"];
    NSString *paramJson = [jsonDictionary JSONString];
    NSString *url = [PublicMethods composeNetSearchUrl:@"mtools" forService:@"contentResource" andParam:paramJson];
    
    
    if (cashDespUtil) {
        [cashDespUtil cancel];
        SFRelease(cashDespUtil);
    }
    if (STRINGHASVALUE(url)) {
        cashDespUtil = [[HttpUtil alloc] init];
        [cashDespUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
    }
}

- (void) back{
    [self.navigationController popToViewController:[self.navigationController.viewControllers safeObjectAtIndex:1] animated:YES];
}

- (void) makeUpView{
    NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
    
    if ([RoomType isPrepay]) {
        // 显示预付规则说明
        NSArray *rules = [dic safeObjectForKey:@"PrepayRules"];
        if (ARRAYHASVALUE(rules)) {
            NSString *ruleString = [[rules safeObjectAtIndex:0] safeObjectForKey:@"Description"];
            self.orderRule = ruleString;
        }else{
            self.orderRule = nil;
        }
    }
    else {
        // 该酒店需要信用卡担保
        if([dic safeObjectForKey:@"VouchSet"]||[dic safeObjectForKey:@"VouchSet"] != [NSNull null]){
            if (self.payType == VouchSetTypeCreditCard) {
                self.orderRule = [NSString stringWithFormat:@"%@（担保金在离店后立即进行解冻，1-3天到帐）", [[dic safeObjectForKey:@"VouchSet"] safeObjectForKey:@"Descrition"]];
            }
        }else{
            self.orderRule = nil;
        }
    }
    if (UMENG) {
        // 酒店订单成功页面
        [MobClick event:Event_HotelOrder_Succeed];
    }
    
    //异步发送订单号--新增功能
    double latitude =[[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Latitude_D] doubleValue];
    double longitude =[[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Longitude_D] doubleValue];
    NSString *saveOrderNo = [NSString stringWithFormat:@"%li",[[HotelPostManager hotelorder] orderNo]];
    [PublicMethods saveHotelOrderGpsWithOrderNo:saveOrderNo HotelLat:latitude HotelLon:longitude];
    //--------------
    
    // info list
    infoList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:infoList];
    infoList.delegate = self;
    infoList.dataSource = self;
    [infoList release];
    infoList.backgroundColor = [UIColor clearColor];
    infoList.separatorStyle = UITableViewCellSeparatorStyleNone;
    infoList.tableHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
    
    if (self.payType == VouchSetTypeAlipayWap)
    {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        infoList.tableFooterView = footerView;
        [footerView release];
        
        NSString *btnTitle = nil;
        if ([UniformCounterViewController paymentType] == UniformPaymentTypeAlipayWap)
        {
            btnTitle = [NSString stringWithFormat:@"支付宝%@",self.payTips];
        }
        else
        {
            btnTitle = [NSString stringWithFormat:@"储蓄卡%@",self.payTips];
        }

        UIButton *alipayBtn = [UIButton yellowWhitebuttonWithTitle:btnTitle Target:self Action:@selector(alipay) Frame:CGRectMake(20, 40, SCREEN_WIDTH - 40, 44)];
        [footerView addSubview:alipayBtn];
    }else if(self.payType == VouchSetTypeWeiXinPayByApp){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        infoList.tableFooterView = footerView;
        [footerView release];
        
        UIButton *alipayBtn = [UIButton yellowWhitebuttonWithTitle:[NSString stringWithFormat:@"微信%@",self.payTips] Target:self Action:@selector(weixinpay) Frame:CGRectMake(20, 40, SCREEN_WIDTH - 40, 44)];
        [footerView addSubview:alipayBtn];
    }else if(self.payType == VouchSetTypeAlipayApp){
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        infoList.tableFooterView = footerView;
        [footerView release];
        
        UIButton *alipayBtn = [UIButton yellowWhitebuttonWithTitle:[NSString stringWithFormat:@"支付宝%@",self.payTips] Target:self Action:@selector(alipayApp) Frame:CGRectMake(20, 40, SCREEN_WIDTH - 40, 44)];
        [footerView addSubview:alipayBtn];
    }
    
    // google订单统计
    [GoogleConversionPing pingWithConversionId:@"983846556" label:@"1lpVCLS0lwcQnJ2R1QM" value:[NSString stringWithFormat:@"%d", [[HotelPostManager hotelorder] orderCount]] isRepeatable:YES];
    // imobi订单统计
    [IMAdTracker reportCustomGoal:@"HOTELORDER_SUCCESS"];
}


// 提交订单时设置为loading状态
- (void)setLoadingState
{
    [self setNavTitle:@""];
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    coverView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];;
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (coverView.frame.size.height - 10)/2, coverView.frame.size.width, 50)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.text = @"正在提交订单...";
    loadingLabel.textColor = [UIColor blackColor];
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.font = FONT_20;
    [coverView addSubview:loadingLabel];
    [loadingLabel release];

    [self.view addSubview:coverView];
    [coverView release];
}

#pragma mark -
#pragma mark 支付方式
- (void) alipayApp{
    if ([[ServiceConfig share] monkeySwitch]){
        // 开着monkey时不发生事件
        return;
    }
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
        //客户端存在，打开客户端
        //客户端支付
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
        [mutDict safeSetObject:self.hotelOrder forKey:@"OrderId"];
        [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"MemberId"];
        
        NSString *reqParam = [NSString stringWithFormat:@"action=SendThirdPartyPayment&version=1.2&compress=true&req=%@", [mutDict JSONRepresentationWithURLEncoding]];
        self.nettype = NETFOR_ALIPAYAPP;
        [Utils orderRequest:HOTELSEARCH req:reqParam delegate:self];
        [mutDict release];
    }
    else{
        // 提示用户安装支付宝客户端
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"未发现支付宝客户端，请您更换别的%@方式或下载支付宝客户端！",self.payTips] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)alipay{
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
    [mutDict safeSetObject:self.hotelOrder forKey:@"OrderId"];
    [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"MemberId"];
    
    NSString *reqParam = [NSString stringWithFormat:@"action=SendThirdPartyPayment&version=1.2&compress=true&req=%@", [mutDict JSONRepresentationWithURLEncoding]];
    self.nettype = NETFOR_ALIPAY;
    [Utils orderRequest:HOTELSEARCH req:reqParam delegate:self];
    [mutDict release];
}

- (void)weixinpay{
    if(![WXApi isWXAppInstalled]){
        [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"未发现微信客户端，请您更换别的%@方式或下载微信",self.payTips]];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"您微信客户端版本过低，请您更换别的%@方式或更新微信",self.payTips]];
        return;
    }
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
    [mutDict safeSetObject:self.hotelOrder forKey:@"OrderId"];
    [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"MemberId"];
    
    NSString *reqParam = [NSString stringWithFormat:@"action=SendThirdPartyPayment&version=1.2&compress=true&req=%@", [mutDict JSONRepresentationWithURLEncoding]];
    self.nettype = NETFOR_WEIXINPAY;
    [Utils orderRequest:HOTELSEARCH req:reqParam delegate:self];
    [mutDict release];
}

- (void)paySuccess{
    [[HotelPostManager hotelorder] setOrderNo:self.hotelOrder];
    HotelOrderSuccess *hotelordersuccess = [[HotelOrderSuccess alloc] initWithPayType:VouchSetTypeNormal order:[NSString stringWithFormat:@"%@",self.hotelOrder]];
    [self.navigationController pushViewController:hotelordersuccess animated:YES];
    [hotelordersuccess release];
    
    //countly paymentconfirmedpage
    CountlyEventShow *countlyEventShow = [[CountlyEventShow alloc] init];
    countlyEventShow.page = COUNTLY_PAGE_PAYMENTCONFIRMEDPAGE;
    countlyEventShow.ch = COUNTLY_CH_HOTEL;
    [countlyEventShow sendEventCount:1];
    [countlyEventShow release];
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.payType == VouchSetTypeCreditCard || self.payType == VouchSetTypeNormal) {
        return 14;
    }else{
        return 9;
    }
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return 7;
        }
            break;
        case 1:{
            return 30;
        }
            break;
        case 2:{
            return 30;
        }
            break;
        case 3:{
            return 30;
        }
            break;
        case 4:{
            NSString *hotelName = [[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"];
            CGSize size = CGSizeMake(200, 1000);
            CGSize newSize =  [hotelName sizeWithFont:FONT_15 constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
            if (newSize.height < 30) {
                newSize.height = 30;
            }
            return newSize.height;
        }
            break;
        case 5:{
            if (self.orderRule) {
                CGSize size = CGSizeMake(SCREEN_WIDTH - 40, 10000);
                CGSize newSize = [self.orderRule sizeWithFont:FONT_14 constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
                return newSize.height + 10;
            }
            return 0;       //提示信息
        }
            break;
        case 6:{
            return 7;
        }
            break;
        case 7:
        {
            NSString *currencyStr = [[HotelPostManager hotelorder] getCurrency];
            
            if (![RoomType isPrepay]&&(![currencyStr isEqualToString:CURRENCY_RMB]))
            {
                return 40;
            }
            else
            {
                return 0;
            }
        }
            break;
        case 8:{
            return 40;
        }
            break;
        case 9:
        {
            return 40;
        }
        case 10:{}
        case 11:{}
        case 12:{}
        case 13:{
            return 44;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            NSString *cellIdentifier = @"Cell0";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImgUp.png"]];
                upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 7);
                upSplitView.contentMode=UIViewContentModeScaleToFill;
                [cell addSubview:upSplitView];
                [upSplitView release];
                
                UIImageView *lagImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImg.png"]];
                lagImageView.frame = CGRectMake(SCREEN_WIDTH-80, 0, 63, 44);
                lagImageView.contentMode=UIViewContentModeScaleToFill;
                [cell.contentView addSubview:lagImageView];
                [lagImageView release];
            }
            return cell;
        }
        case 1:{
            NSString *cellIdentifier = @"Cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                // 添加订单信息
                UILabel *successTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 30)];
                if (self.payType == VouchSetTypeCreditCard || self.payType == VouchSetTypeNormal) {
                    successTipLabel.text				= @"预订成功 !";
                }else{
                    successTipLabel.text				= @"已下单 !";
                    if (!coverView) {
                        [self setLoadingState];
                    }
                }
                
                successTipLabel.font				= [UIFont boldSystemFontOfSize:20];
                successTipLabel.textColor           = RGBACOLOR(252, 152, 44, 1);
                successTipLabel.backgroundColor		= [UIColor clearColor];
                [cell addSubview:successTipLabel];
                [successTipLabel release];
                
                UIImageView *lagImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImg.png"]];
                lagImageView.frame = CGRectMake(SCREEN_WIDTH-80, -7, 63, 44);
                lagImageView.contentMode=UIViewContentModeScaleToFill;
                [cell.contentView addSubview:lagImageView];
                [lagImageView release];

                // 请求天气预报
//                if (!_forecastVC) {
//                    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
//                    
//                    NSString *city = [hotelsearcher cityName];
//                    NSString *date = [hotelsearcher getCheckinDate];
//                    NSDate *checkinDate = [NSDate dateFromString:date withFormat:@"yyyy-MM-dd"];
//                    
//                    // 天气预报是否显示
//                    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
//                    int timeOffset = [nowTimeZone secondsFromGMTForDate:checkinDate];
//                    NSDate *newArriveDate = [checkinDate dateByAddingTimeInterval:timeOffset];
//                    
//                    NSDate *nowDate = [NSDate date];
//                    int nowTimeOffset = [nowTimeZone secondsFromGMTForDate:nowDate];
//                    NSDate *newNowDate = [[NSDate date] dateByAddingTimeInterval:nowTimeOffset];
//                    
//                    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//                    unsigned int unitFlags = NSDayCalendarUnit;
//                    NSDateComponents *comps = [gregorian components:unitFlags fromDate:newNowDate toDate:newArriveDate options:0];
//                    int days = [comps day];
//                    [gregorian release];
//                    
//                    if (days == -1) {
//                        checkinDate = nowDate;
//                    }
//                    
//                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//                    [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
//                    NSString *checkinDateString = [dateFormatter stringFromDate:checkinDate];
//                    [dateFormatter release];
//                    
//                    ForecastViewController *tempForecastVC = [[ForecastViewController alloc] init];
//                    tempForecastVC.view.frame = CGRectMake(SCREEN_WIDTH - kForecastViewWidth, 10.0f, kForecastViewWidth, kForecastViewHeight);
//                    self.forecastVC = tempForecastVC;
//                    [tempForecastVC release];
//                    
//                    [self.view addSubview:_forecastVC.view];
//                    
//                    [_forecastVC startRequestWithCity:city withDate:checkinDateString];
//                }
            }
            return cell;
        }
        
        case 2:{
            // 订单号
            
            NSString *cellIdentifier = @"Cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
                titlelabel.font = FONT_14;
                titlelabel.textColor = RGBACOLOR(93, 93, 93, 1);
                titlelabel.backgroundColor=[UIColor clearColor];
                titlelabel.text = @"订 单 号：";
                titlelabel.textAlignment=UITextAlignmentLeft;
            
                
                UILabel *valuelabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 170, 30)];
                valuelabel.font = FONT_14;
                valuelabel.backgroundColor=[UIColor clearColor];
                valuelabel.textColor = RGBACOLOR(52, 52, 52, 1);
                valuelabel.textAlignment=UITextAlignmentLeft;
               
                valuelabel.text = self.hotelOrder;
                
                [cell addSubview:titlelabel];
                [titlelabel release];
                [cell addSubview:valuelabel];
                [valuelabel release];
                
                UIImageView *lagImageView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImg.png"]];
                lagImageView.frame = CGRectMake(SCREEN_WIDTH-80, -7 - 30, 63, 44);
                lagImageView.contentMode=UIViewContentModeScaleToFill;
                [cell.contentView addSubview:lagImageView];
                [lagImageView release];
            }
            return cell;
        }
        case 3:{
            // 消费金额
            NSString *cellIdentifier = @"Cell3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
                titlelabel.font= FONT_14;
                titlelabel.textColor =  RGBACOLOR(93, 93, 93, 1);
                titlelabel.backgroundColor=[UIColor clearColor];
                titlelabel.textAlignment=UITextAlignmentLeft;
                titlelabel.text = @"消费金额：";
                //显示人民币
                NSString *currencyMark = CURRENCY_RMBMARK;
                
                float curTotalPrice=[[HotelPostManager hotelorder] getTotalPrice];
                NSString *priceTips = @"";
                NSDictionary *roomTypeDic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
                
                //汇率
                float exchangeRate = 1;
                if (roomTypeDic) {
                    exchangeRate=[[roomTypeDic safeObjectForKey:@"ExchangeRate"] floatValue];
                }
                //显示人民币
                NSString *totalPrice=[NSString stringWithFormat:@"%.0f",exchangeRate>0?curTotalPrice*exchangeRate:curTotalPrice];
                
                if ([RoomType isPrepay])
                {
                    //现金不算汇率
//                    float cashValue = [[[HotelPostManager hotelorder] getCashAmount] floatValue];
//                    if (cashValue > 0)
//                    {
//                        // 如果使用过CA，价格应为总价减去CA部分的价格
//                        curTotalPrice= exchangeRate>0?curTotalPrice*exchangeRate - cashValue:curTotalPrice - cashValue;
//                    }
                    
                    // 预付显示减去消费券后的金额
                    int couponPrice = 0;
                    NSArray *coupons = [[HotelPostManager hotelorder] getCoupons];
                    if (ARRAYHASVALUE(coupons))
                    {
                        // 取出coupon的值
                        couponPrice = [[[coupons safeObjectAtIndex:0] safeObjectForKey:@"CouponValue"] intValue];
                        curTotalPrice= exchangeRate>0?curTotalPrice*exchangeRate - couponPrice:curTotalPrice-couponPrice;
                    }
                    
                    totalPrice = [NSString stringWithFormat:@"%.0f", curTotalPrice];
                }else{
                    priceTips = @" (到店付款)";
                }
                
                AttributedLabel *valuelabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(100, 5, 170, 30)];
                valuelabel.text					= [NSString stringWithFormat:@"%@%@%@", currencyMark, totalPrice, priceTips];
                valuelabel.backgroundColor		= [UIColor clearColor];
                valuelabel.clipsToBounds		= NO;
                [valuelabel setFont:FONT_B14 fromIndex:0 length:[NSString stringWithFormat:@"%@%@",currencyMark,totalPrice].length];
                [valuelabel setColor:RGBACOLOR(254, 75, 32, 1) fromIndex:0 length:[NSString stringWithFormat:@"%@%@",currencyMark,totalPrice].length];
                [valuelabel setFont:FONT_B14 fromIndex:[NSString stringWithFormat:@"%@%@",currencyMark,totalPrice].length length:priceTips.length];
                [valuelabel setColor:RGBACOLOR(52, 52, 52, 1) fromIndex:[NSString stringWithFormat:@"%@%@",currencyMark,totalPrice].length length:priceTips.length];
                
                [cell addSubview:titlelabel];
                [cell addSubview:valuelabel];
                [titlelabel release];
                [valuelabel release];
            }
            return cell;
        }
        case 4:{
            // 酒店名
            NSString *cellIdentifier = @"Cell4";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
                titlelabel.font = FONT_14;
                titlelabel.textColor = RGBACOLOR(93, 93, 93, 1);
                titlelabel.backgroundColor=[UIColor clearColor];
                titlelabel.text = @"酒店名称：";
                titlelabel.textAlignment=UITextAlignmentLeft;
                
                
                UILabel *valuelabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 200, 30)];
                valuelabel.font = FONT_14;
                valuelabel.backgroundColor=[UIColor clearColor];
                valuelabel.textColor = RGBACOLOR(52, 52, 52, 1);
                valuelabel.textAlignment = UITextAlignmentLeft;
                valuelabel.numberOfLines = 0;
                valuelabel.lineBreakMode = UILineBreakModeCharacterWrap;
                
                
                [cell addSubview:titlelabel];
                [titlelabel release];
                [cell addSubview:valuelabel];
                [valuelabel release];
                
                NSString *hotelName = [[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"];
                CGSize size = CGSizeMake(valuelabel.frame.size.width, 1000);
                CGSize newSize =  [hotelName sizeWithFont:valuelabel.font constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
                if (newSize.height < 30) {
                    newSize.height = 30;
                }
                valuelabel.text = hotelName;
                valuelabel.frame = CGRectMake(valuelabel.frame.origin.x, 0, valuelabel.frame.size.width, newSize.height);
            }
            return cell;
        }
        case 5:{
            NSString *cellIdentifier = @"Cell5";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                CGSize size = CGSizeMake(SCREEN_WIDTH - 40, 10000);
                CGSize newSize = [self.orderRule sizeWithFont:FONT_14 constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
                
                
                UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, newSize.height + 10)];
                titlelabel.font = FONT_14;
                titlelabel.textColor = RGBACOLOR(52, 52, 52, 1);
                titlelabel.backgroundColor = [UIColor clearColor];
                titlelabel.textAlignment = UITextAlignmentLeft;
                titlelabel.numberOfLines = 0;
                titlelabel.lineBreakMode = UILineBreakModeCharacterWrap;
                
                titlelabel.text = self.orderRule;
                
                [cell addSubview:titlelabel];
                [titlelabel release];
            }
            return cell;
        }
        case 6:{
            NSString *cellIdentifier = @"Cell6";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"orderSuccess_envelopImgDown.png"]];
                upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 7);
                upSplitView.contentMode=UIViewContentModeScaleToFill;
                [cell addSubview:upSplitView];
                [upSplitView release];
            }
            return cell;
        }
        case 7:
        {
            NSString *currencyStr = [[HotelPostManager hotelorder] getCurrency];
            NSString *currencyMark = nil;
            if ([currencyStr isEqualToString:CURRENCY_HKD]) {
                currencyMark = CURRENCY_HKDMARK;
            }
            else if ([currencyStr isEqualToString:CURRENCY_RMB]) {
                currencyMark = CURRENCY_RMBMARK;
            }
            else {
                currencyMark = currencyStr;
            }
            
            NSString *cellIdentifier = @"Cell7";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (![RoomType isPrepay]&&(![currencyStr isEqualToString:CURRENCY_RMB]))
                {
                    
                }
                else
                {
                    return cell;
                }
                
                NSString *basicPrice=[NSString stringWithFormat:@"%.0f",[[HotelPostManager hotelorder] getTotalPrice]];
                
                UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 40)];
                titlelabel.font = FONT_12;
                titlelabel.textColor = RGBACOLOR(118, 118, 118, 1);
                titlelabel.backgroundColor=[UIColor clearColor];
                titlelabel.textAlignment=UITextAlignmentLeft;
                titlelabel.numberOfLines = 1;
                titlelabel.text = [NSString stringWithFormat:@"● 到店付款，您到酒店需要支付%@%@", currencyMark, basicPrice];
                [cell addSubview:titlelabel];
                [titlelabel release];
            }
            return cell;
        }
        case 8:{
            NSString *cellIdentifier = @"Cell8";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 40)];
                titlelabel.font = FONT_12;
                titlelabel.textColor = RGBACOLOR(118, 118, 118, 1);
                titlelabel.backgroundColor=[UIColor clearColor];
                titlelabel.textAlignment=UITextAlignmentLeft;
                titlelabel.numberOfLines = 2;
                if (self.payType ==VouchSetTypeCreditCard || self.payType == VouchSetTypeNormal) {
                    titlelabel.text = @"●  通常酒店14:00办理入住，早到可能需等待。";
                }else{
                    titlelabel.text = @"请在30分钟内完成支付，如未及时支付，将取消本次预订。";
                }
                
                
                [cell addSubview:titlelabel];
                [titlelabel release];
            }
            return cell;
        }
        case 9:
        {
            NSString *cellIdentifier = @"Cell9";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 40)];
                titlelabel.font = FONT_12;
                titlelabel.textColor = RGBACOLOR(118, 118, 118, 1);
                titlelabel.backgroundColor=[UIColor clearColor];
                titlelabel.textAlignment=UITextAlignmentLeft;
                titlelabel.numberOfLines = 2;
                if (self.payType == VouchSetTypeCreditCard || self.payType == VouchSetTypeNormal) {
                    titlelabel.text = @"●  如您需要续住，请再次下单以保证您正常获得积分、返现等优惠。";
                }else{
                    titlelabel.text = @"";
                }
                
                
                [cell addSubview:titlelabel];
                [titlelabel release];
                
                UIImageView *splitView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
                splitView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
                [cell.contentView addSubview:splitView0];
                [splitView0 release];
            }
            return cell;
        }
        case 10:{}
        case 11:{}
        case 12:{}
        case 13:{
            NSString *cellIdentifier = @"Cell10";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.clipsToBounds = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                
                cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
                cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
                
              
                
                UIImageView *splitView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
                splitView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
                [cell.contentView addSubview:splitView1];
                [splitView1 release];
                
                UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16, 0, 8, 44)];
                arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
                [cell.contentView addSubview:arrowView];
                [arrowView release];
                arrowView.contentMode = UIViewContentModeCenter;
                
                cell.textLabel.font = FONT_14;
                cell.textLabel.textColor = RGBACOLOR(52, 52, 52, 1);
                cell.textLabel.highlightedTextColor = RGBACOLOR(52, 52, 52, 1);
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.imageView.backgroundColor = [UIColor clearColor];
                
                //显示detail信息
                UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-16-5-100, 44)];
                detailLabel.backgroundColor = [UIColor clearColor];
                detailLabel.tag = 1001;
                detailLabel.textAlignment = NSTextAlignmentRight;
                detailLabel.textColor = RGBACOLOR(254, 75, 32, 1);
                detailLabel.font = FONT_12;
                [cell.contentView addSubview:detailLabel];
                [detailLabel release];
            }
            //重置
            cell.imageView.image = nil;
            UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:1001];
            detailLabel.hidden = YES;
            detailLabel.text = @"";
            
            if (indexPath.row == 13) {
                if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passHotelOn]) {
                    cell.textLabel.text = @"添加到Passbook";
                    cell.imageView.image = [UIImage noCacheImageNamed:@"addToPassBook.png"];
                }else{
                    cell.textLabel.text = @"添加到相册";
                }
            }else if(indexPath.row == 10){
                cell.textLabel.text = @"怎么获取返现";
            }else if(indexPath.row == 11){
                cell.textLabel.text = @"查看订单";
                cell.imageView.image = [UIImage noCacheImageNamed:@"viewOrder.png"];
                if(self.cashNoteContent.length>0){
                    detailLabel.hidden = NO;
                    detailLabel.numberOfLines = 2;
                    detailLabel.text = self.cashNoteContent;
                }
            }else if(indexPath.row == 12){
                cell.textLabel.text = @"带我去酒店";
            }
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 13) {
        // passbook 或者 相册
        [self takePicture];
        UMENG_EVENT(UEvent_Hotel_OrderSuccess_Passbook)
    }else if(indexPath.row == 10){
        // 返现规则
        [self couponIntroduction];
        UMENG_EVENT(UEvent_Hotel_OrderSuccess_BackRule)
    }else if(indexPath.row == 11){
        // 查看订单
        [self goMyOrder];
        UMENG_EVENT(UEvent_Hotel_OrderSuccess_Orders)
    }else if(indexPath.row == 12){
        // 带我去酒店
        [self goHotel];
        UMENG_EVENT(UEvent_Hotel_OrderSuccess_GoHotel)
    }
}


-(UIImage *)captureCurrentView{
    CGSize size = envelopImg.frame.size;
        
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
    self.view.layer.masksToBounds=YES;
	[envelopImg.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return newImage;
}

- (void)saveTopassbook
{
//    NSString *lat = [NSString stringWithFormat:@"%@", [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Latitude_D]];
//	NSString *lon = [NSString stringWithFormat:@"%@", [[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Longitude_D]];
//    NSString *orderID = [NSString stringWithFormat:@"%ld", [[HotelPostManager hotelorder] orderNo]];
//    NSString *cardNum = [[AccountManager instanse] cardNo];
//    NSString *url = [PublicMethods getPassUrlByType:HotelPass orderID:orderID cardNum:cardNum lat:lat lon:lon];
//    
//    if (passUtil) {
//        [passUtil cancel];
//        SFRelease(passUtil);
//    }
//    passUtil = [[HttpUtil alloc] init];
//    [passUtil connectWithURLString:url Content:nil Delegate:self];
    
    
    // 组织Json
	NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    
    
    NSMutableDictionary *hotelDetail = [HotelDetailController hoteldetail];
    JHotelOrder *orderInfo = (JHotelOrder *)[HotelPostManager hotelorder];
    
    //===========
    //PKPASS DIC
    //===========
    NSMutableDictionary *dicPKPass = [[NSMutableDictionary alloc] init];
    
    NSString *orderNoText = [NSString stringWithFormat:@"%ld", [orderInfo orderNo]];;
    [dicPKPass safeSetObject:orderNoText forKey:@"serialNumber"];
    
    NSString *arriveDate =  [TimeUtils displayDateWithJsonDate:[orderInfo getArriveDate] formatter:@"yyyy-MM-dd"];
    if (!STRINGHASVALUE(arriveDate))
    {
        arriveDate = @"2015-05-07T10:30-05:00";
    }
    //
//    arriveDate = @"2015-05-07T10:30-05:00";
    [dicPKPass safeSetObject:arriveDate forKey:@"relevantDate"];
    
    // 经纬度位置
    NSMutableArray *arrayLonLatJson = [[NSMutableArray alloc] init];
    for (int i=0; i<1; i++)
    {
        NSMutableDictionary *dicLonLatJson = [[NSMutableDictionary alloc] init];
        
        [dicLonLatJson setObject:[NSString stringWithFormat:@"%@", [hotelDetail safeObjectForKey:RespHD_Latitude_D]] forKey:@"latitude"];
        [dicLonLatJson setObject:[NSString stringWithFormat:@"%@", [hotelDetail safeObjectForKey:RespHD_Longitude_D]] forKey:@"longitude"];
        
        // 添加
        [arrayLonLatJson addObject:dicLonLatJson];
        [dicLonLatJson release];
    }
    [dicPKPass setObject:arrayLonLatJson forKey:@"locations"];
    [arrayLonLatJson release];
    
    // logo 名
    NSString *hotelName = [hotelDetail safeObjectForKey:RespHD_HotelName_S];
    if (STRINGHASVALUE(hotelName))
    {
        [dicPKPass setObject:hotelName forKey:@"logoText"];
    }
    
    //===========
    //====PKGeneric 结构
    //===========
    NSMutableDictionary *dicPKGeneric = [[NSMutableDictionary alloc] init];
    
    // header信息
    NSMutableArray *arrayHeader = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc] init];
    if (STRINGHASVALUE(orderNoText))
    {
        [dicHeader setObject:@"orderNo" forKey:@"key"];
        [dicHeader setObject:orderNoText forKey:@"value"];
        [dicHeader setObject:@"订单号" forKey:@"label"];
    }
    [arrayHeader addObject:dicHeader];
    [dicHeader release];
    
    // Save
    [dicPKGeneric setObject:arrayHeader forKey:@"headerFields"];
    [arrayHeader release];
    
    //=====primaryField
    NSMutableArray *arrayPrimary = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicPrimary = [[NSMutableDictionary alloc] init];
    
    NSString *orderPriceText = [NSString stringWithFormat:@"%f",[orderInfo getTotalPrice]];
    [dicPrimary setObject:@"price" forKey:@"key"];
    [dicPrimary setObject:orderPriceText forKey:@"value"];
    [dicPrimary setObject:@"CNY" forKey:@"currencyCode"];
    
    [arrayPrimary addObject:dicPrimary];
    [dicPrimary release];
    
    // Save
    [dicPKGeneric setObject:arrayPrimary forKey:@"primaryFields"];
    [arrayPrimary release];
    
    //=====secondaryField
    NSMutableArray *arraySecondary = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicSecondaryField01 = [[NSMutableDictionary alloc] init];
    
    NSMutableString *guestName = [NSMutableString stringWithFormat:@""];
    id value = [orderInfo getGuestNames];        //入住人
    if([value isKindOfClass:[NSString class]]){
        guestName = STRINGHASVALUE(value)?value:@"--";
    }else if([value isKindOfClass:[NSArray class]]){
        int count = 0;
        for (NSString *s in value)
        {
            [guestName appendFormat:@"%@ ",s];
            count++;
            if (count>=4) {
                [guestName appendFormat:@"%@",@"\n"];
                count=0;
            }
        }
    }
    if (STRINGHASVALUE(guestName))
    {
        [dicSecondaryField01 setObject:@"customer" forKey:@"key"];
        [dicSecondaryField01 setObject:guestName forKey:@"value"];
        [dicSecondaryField01 setObject:@"入住人" forKey:@"label"];
    }
    [arraySecondary addObject:dicSecondaryField01];
    [dicSecondaryField01 release];
    
    NSMutableDictionary *dicSecondaryField02 = [[NSMutableDictionary alloc] init];
    
    NSString *roomTypeName = [hotelDetail safeObjectForKey:ExSelectRoomType];
    if (STRINGHASVALUE(roomTypeName))
    {
        [dicSecondaryField02 setObject:@"romeType" forKey:@"key"];
        [dicSecondaryField02 setObject:roomTypeName forKey:@"value"];
        [dicSecondaryField02 setObject:@"房型" forKey:@"label"];
    }
    [arraySecondary addObject:dicSecondaryField02];
    [dicSecondaryField02 release];
    
    // Save
    [dicPKGeneric setObject:arraySecondary forKey:@"secondaryFields"];
    [arraySecondary release];
    
    
    //=====auxiliaryField
    NSMutableArray *arrayAuxiliary = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicAuxiliaryField01 = [[NSMutableDictionary alloc] init];
    if (STRINGHASVALUE(arriveDate))
    {
        [dicAuxiliaryField01 setObject:@"checkIn" forKey:@"key"];
        [dicAuxiliaryField01 setObject:arriveDate forKey:@"value"];
        [dicAuxiliaryField01 setObject:@"入住日期" forKey:@"label"];
    }
    [arrayAuxiliary addObject:dicAuxiliaryField01];
    [dicAuxiliaryField01 release];
    
    NSMutableDictionary *dicAuxiliaryField02 = [[NSMutableDictionary alloc] init];
    NSString *departDate = [TimeUtils displayDateWithJsonDate:[orderInfo getLeaveDate] formatter:@"yyyy-MM-dd"];
    if (STRINGHASVALUE(departDate))
    {
        [dicAuxiliaryField02 setObject:@"checkOut" forKey:@"key"];
        [dicAuxiliaryField02 setObject:departDate forKey:@"value"];
        [dicAuxiliaryField02 setObject:@"离店日期" forKey:@"label"];
    }
    [arrayAuxiliary addObject:dicAuxiliaryField02];
    [dicAuxiliaryField02 release];
    
    NSMutableDictionary *dicAuxiliaryField03 = [[NSMutableDictionary alloc] init];
    
    // 计算时间间隔
    if (STRINGHASVALUE(arriveDate) && STRINGHASVALUE(departDate))
    {
        NSDate *arriveDateObj = [NSDate dateFromString:arriveDate withFormat:@"yyyy-MM-dd"];
        NSDate *departDateObj = [NSDate dateFromString:departDate withFormat:@"yyyy-MM-dd"];
        NSInteger dayCount = [departDateObj timeIntervalSinceDate:arriveDateObj]/(24*60*60);
        
        [dicAuxiliaryField03 setObject:@"days" forKey:@"key"];
        [dicAuxiliaryField03 setObject:[NSString stringWithFormat:@"%d",dayCount] forKey:@"value"];
        [dicAuxiliaryField03 setObject:@"入住天数" forKey:@"label"];
    }
    [arrayAuxiliary addObject:dicAuxiliaryField03];
    [dicAuxiliaryField03 release];
    
    // Save
    [dicPKGeneric setObject:arrayAuxiliary forKey:@"auxiliaryFields"];
    [arrayAuxiliary release];
    
    
    //=====backField
    NSMutableArray *arrayBack = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicBackField01 = [[NSMutableDictionary alloc] init];
    if (STRINGHASVALUE(roomTypeName))
    {
        [dicBackField01 setObject:@"romeInfo" forKey:@"key"];
        [dicBackField01 setObject:roomTypeName forKey:@"value"];
        [dicBackField01 setObject:@"房间信息" forKey:@"label"];
    }
    [arrayBack addObject:dicBackField01];
    [dicBackField01 release];
    
    NSMutableDictionary *dicBackField02 = [[NSMutableDictionary alloc] init];
    
    NSString *hotelAddress = STRINGHASVALUE([hotelDetail safeObjectForKey:RespHD_Address_S])?[hotelDetail safeObjectForKey:RespHD_Address_S]:@"--";
    if (STRINGHASVALUE(hotelAddress))
    {
        [dicBackField02 setObject:@"hotelInfo" forKey:@"key"];
        [dicBackField02 setObject:hotelAddress forKey:@"value"];
        [dicBackField02 setObject:@"酒店地址" forKey:@"label"];
    }
    [arrayBack addObject:dicBackField02];
    [dicBackField02 release];
    
    NSMutableDictionary *dicBackField03 = [[NSMutableDictionary alloc] init];
    
    NSString *telephone = @"400-666-1166";
    if (STRINGHASVALUE(telephone))
    {
        [dicBackField03 setObject:@"telInfo" forKey:@"key"];
        [dicBackField03 setObject:telephone forKey:@"value"];
        [dicBackField03 setObject:@"艺龙客服电话" forKey:@"label"];
    }
    [arrayBack addObject:dicBackField03];
    [dicBackField03 release];
    
    // Save
    [dicPKGeneric setObject:arrayBack forKey:@"backFields"];
    [arrayBack release];
    
    // 保存generic
    [dicPKPass safeSetObject:dicPKGeneric forKey:@"generic"];
    [dicPKGeneric release];
    
    // 保存PKPass
    [dicJson safeSetObject:dicPKPass forKey:@"PKPass"];
    [dicPKPass release];
    
    // 请求参数
    NSString *paramJson = [dicJson JSONString];
    [dicJson release];
    
    NSString *passContent = [NSString stringWithFormat:@"req=%@",paramJson];
    
    if (passUtil) {
        [passUtil cancel];
        SFRelease(passUtil);
    }
    passUtil = [[HttpUtil alloc] init];
    [passUtil connectWithURLString:PASSBOOKURL Content:passContent Delegate:self];

}

- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
    
    PKPassLibrary *passLibrary = [[[PKPassLibrary alloc] init] autorelease];
    if ([passLibrary containsPass:pass]) {
        [PublicMethods showAlertTitle:@"添加成功！" Message:nil];
    }
}

-(void)takePicture {

    if (IOSVersion_6 && [[AccountManager instanse] isLogin] && [PublicMethods passHotelOn]) {
		// passbook
        [self saveTopassbook];
		
        return;
	}
	else {
        self.view.userInteractionEnabled = NO;
		UIImageWriteToSavedPhotosAlbum(imagefromparentview,
									   self,
									   @selector(imageSavedToPhotosAlbum:
												 didFinishSavingWithError:
												 contextInfo:),
									   nil);
	}
}

- (void)moveview {
    [m_imgview.layer removeAnimationForKey:@"marioJump"];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = .5;
    scaleAnimation.toValue = [NSNumber numberWithFloat:.1];
    
    
    CABasicAnimation *slideDownx = [CABasicAnimation animationWithKeyPath:@"position.x"];
    slideDownx.toValue = [NSNumber numberWithFloat:160];
    slideDownx.duration = .5f;
    slideDownx.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];    
    
    CABasicAnimation *slideDowny= [CABasicAnimation animationWithKeyPath:@"position.y"];
    slideDowny.toValue = [NSNumber numberWithFloat: self.view.center.y];
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
        UIImageWriteToSavedPhotosAlbum(imagefromparentview,
                                       self, 
                                       @selector(imageSavedToPhotosAlbum: 
                                                 didFinishSavingWithError: 
                                                 contextInfo:), 
                                       nil);  	
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
    NSString *message;  
    NSString *title;
    if (!error) 
	{  
        title = nil;  
        message = NSLocalizedString(@"订单信息已经保存到相册", @"");  
    } else {  
        title = NSLocalizedString(@"订单信息保存失败", @"");
        message = @"为允许访问相册，请在设置中打开！";  
	}  
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title  
                                                    message:message  
                                                   delegate:nil  
                                          cancelButtonTitle:NSLocalizedString(@"知道了", @"")  
                                          otherButtonTitles:nil];  
    [alert show];  
    [alert release]; 
    
    
    if (!error) {
        [Utils clearHotelData];
        
        //[super backhome];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HotelSearch class]]) {
                HotelSearch *searchCtr = (HotelSearch *)controller;
                [self.navigationController popToViewController:searchCtr animated:YES];
                [Utils clearHotelData];
                
                break;
            }
        }
    }
    self.view.userInteractionEnabled = YES;
}

- (void)goHotel {
	double lat = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Latitude_D] doubleValue];
	double lon = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Longitude_D] doubleValue];
    
	if (lat != 0 || lon != 0) {
        [PublicMethods openMapListToDestination:CLLocationCoordinate2DMake(lat, lon) title:[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"]];
    }
	else {
		// 酒店没有坐标时用酒店地址导航
		[PublicMethods pushToMapWithDestName:[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Address_S]];
	}
}

- (void)couponIntroduction{
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
}

- (void)goMyOrder {
	// 非会员订单查询
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (delegate.isNonmemberFlow) {
		NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_HOTEL_ORDERS];
		self.localOrderArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:orderData]];
		NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:2];
		for (NSDictionary *dic in localOrderArray) {
			[idArray addObject:[dic safeObjectForKey:ORDERNO_REQ]];
		}
		
		NHotelOrderReq *orderReq = [NHotelOrderReq shared];
		[orderReq setOrderState:NOrderStateHotel];
        self.nettype = NETFOR_ORDERLIST;
		[Utils request:PUSH_SEARCH req:[orderReq requestOrderStateWithOrders:idArray] delegate:self];		
	}
	else {
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
	}
}

-(void)clickCouponRuleBtn{
	
	CouponRule *couponRule = [[CouponRule alloc] initFromOrderFlow:NO];
	[self.navigationController pushViewController:couponRule animated:YES];
	[couponRule release];
}

-(void)confirm{
	[Utils clearHotelData];
	
	//[super backhome];
	for (UIViewController *controller in self.navigationController.viewControllers) {
		if ([controller isKindOfClass:[HotelSearch class]]) {
			HotelSearch *searchCtr = (HotelSearch *)controller;
			[self.navigationController popToViewController:searchCtr animated:YES];
			[Utils clearHotelData];
			
			break;
		}
	}
}


// 移除显示“正在提交”文字的遮罩层
- (void)removeCoverView
{
    if (coverView)
    {
        [self setNavTitle:_string(@"s_hotel_ordersuccess")];
        [coverView removeFromSuperview];
        coverView = nil;
    }
}

#pragma mark -
#pragma mark Net Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if (util == passUtil) {
        if (!responseData) {
            [PublicMethods showAlertTitle:@"Pass文件生成失败" Message:nil];
            
            return;
        }
        NSError *error;
        
        SFRelease(pass);
        pass = [[PKPass alloc] initWithData:responseData error:&error];
        CFShow(pass);
        PKAddPassesViewController *addPassVC = [[PKAddPassesViewController alloc] initWithPass:pass];
        if (addPassVC) {
            addPassVC.delegate = self;
            [self presentViewController:addPassVC animated:YES completion:^{}];
            [addPassVC release];
        }
        else {
            [PublicMethods showAlertTitle:@"非常抱歉，该订单无法生成Passbook" Message:nil];
        }
    }else if(util==cashDespUtil){
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return ;
        }
        NSLog(@"root=%@",root);
        
        NSString *content = @"";
        NSArray *contentList = [root objectForKey:@"contentList"];
        if(ARRAYHASVALUE(contentList)){
            content = [[contentList safeObjectAtIndex:0] safeObjectForKey:@"content"];
        }
        
        //取得消费券信息
        int couponValue = 0;
        NSArray *couponArray = [[HotelPostManager hotelorder] getCoupons];
        if (![couponArray isEqual:[NSNull null]]) {
            // 使用消费券时给予提示
            couponValue = [[[couponArray safeObjectAtIndex:0]
                            safeObjectForKey:@"CouponValue"]
                           intValue];
        }
        
        //显示
        if (couponValue > 0 && ![RoomType isPrepay] && (self.payType == VouchSetTypeCreditCard|| self.payType == VouchSetTypeNormal)){
            content = [content stringByReplacingOccurrencesOfString:@"{0}" withString:[NSString stringWithFormat:@"¥%d",couponValue]];
            self.cashNoteContent =content;
            
            NSArray *indexPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:11 inSection:0], nil];
            [infoList reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
 
    }else if(promotionInfoUtil == util){
        NSDictionary *root = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return ;
        }
    }
    else {
        if (self.nettype == NETFOR_ORDERLIST) {
            NSDictionary *root = [PublicMethods unCompressData:responseData];
            
            if ([Utils checkJsonIsError:root]) {
                return ;
            }
            
            // 非会员流程重新构造参数
            for (NSDictionary *stateDic in [root safeObjectForKey:ORDERSTATUSINFOS]) {
                for (NSMutableDictionary *savedOrder in localOrderArray) {
                    NSString *orderID_net = [NSString stringWithFormat:@"%@", [stateDic safeObjectForKey:ORDERID_GROUPON]];     // api获取的订单号
                    NSString *orderID_local = [NSString stringWithFormat:@"%@", [savedOrder safeObjectForKey:ORDERNO_REQ]];         // 存在本地的订单号
                    if ([orderID_net isEqualToString:orderID_local]) {
                        NSNumber *ordderState = [stateDic safeObjectForKey:HOTEL_STATE_CODE];
                        if (ordderState) {
                            // 获取酒店订单状态
                            [savedOrder safeSetObject:ordderState forKey:STATE_CODE];
                        }
                        
                        NSString *clientStatusDesc = [stateDic safeObjectForKey:@"HotelOrderClientStatusDesc"];
                        if(STRINGHASVALUE(clientStatusDesc)){
                            [savedOrder safeSetObject:clientStatusDesc forKey:CLIENTSTATUSDESC];
                        }
                        
                        NSString *hotelName = [stateDic safeObjectForKey:HOTEL_STATE_NAME];
                        if (hotelName && STRINGHASVALUE(hotelName)) {
                            // 获取酒店名
                            [savedOrder safeSetObject:hotelName forKey:STATENAME];
                        }
                        
                        NSString *cityName = [stateDic safeObjectForKey:CITYNAME_GROUPON];
                        if (cityName && STRINGHASVALUE(cityName)) {
                            // 获取酒店所在城市
                            [savedOrder safeSetObject:cityName forKey:CITYNAME_GROUPON];
                        }
                        
                        NSString *creatTime = [stateDic safeObjectForKey:HOTEL_ORDER_CREATE_TIME];
                        if (creatTime && STRINGHASVALUE(creatTime)) {
                            // 获取订单创建时间
                            [savedOrder safeSetObject:creatTime forKey:CREATETIME];
                        }
                    }
                }
            }
            
            ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
            HotelOrderListViewController *hotelOrderListViewCtrl = [[HotelOrderListViewController alloc] initWithHotelOrders:localOrderArray totalNumber:localOrderArray.count];
            [delegate.navigationController pushViewController:hotelOrderListViewCtrl animated:YES];
            [hotelOrderListViewCtrl release];
        }else if(self.nettype == NETFOR_ALIPAY){
            NSDictionary *root = [PublicMethods unCompressData:responseData];
            if ([Utils checkJsonIsError:root]) {
                return;
            }
            
            if (self.payType == VouchSetTypeAlipayWap) {
                NSURL *url = [NSURL URLWithString:[root objectForKey:@"PaymentUrl"]];
                
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
                
                    // 动画之后移除
                    [self performSelector:@selector(removeCoverView) withObject:nil afterDelay:0.3];
                }
            }
        }else if(self.nettype == NETFOR_ALIPAYAPP){
            NSDictionary *root = [PublicMethods unCompressData:responseData];
            if ([Utils checkJsonIsError:root]) {
                return;
            }
            NSLog(@"root=%@", root);
            
            if([[root safeObjectForKey:@"IsSuccessful"] boolValue]){
                //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
                NSString *appScheme = @"elongIPhone";
                NSString *orderString = [root safeObjectForKey:@"PaymentUrl"];
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
        }else if(self.nettype == NETFOR_WEIXINPAY){
            NSDictionary *root = [PublicMethods unCompressData:responseData];
            if ([Utils checkJsonIsError:root]) {
                return;
            }
            
            if (self.payType == VouchSetTypeWeiXinPayByApp) {
                NSString *url = [root objectForKey:@"PaymentUrl"];
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
        }
    }
}


- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    [self removeCoverView];
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    [self removeCoverView];
}

#pragma mark - Notification Methods
- (void) weixinPaySuccess{
    [self paySuccess];
}

- (void) alipayPaySuccess{
    [self paySuccess];
}


- (void)notiByAlipayWap:(NSNotification *)noti{
    [self paySuccess];
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
    
    [self removeCoverView];
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == AliapyAlertTag) {
        if (0 != buttonIndex){
            // 已支付
            [self paySuccess];
        }else{
            
        }
    }
}


#pragma mark end

-(void) shareInfo{
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
    shareTools.needLoading = NO;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
	shareTools.mailImage = imagefromparentview;// [self screenshotOnCurrentView];
	
	shareTools.hotelId = [[HotelDetailController hoteldetail] safeObjectForKey:@"HotelId"];
	
	shareTools.weiBoContent = [self weiboContent];	
	shareTools.msgContent = [self smsContent];
	shareTools.mailTitle = @"使用艺龙旅行客户端预订酒店成功！";
	shareTools.mailContent = [self mailContent];
	
	[shareTools  showItems];
    
    UMENG_EVENT(UEvent_Hotel_OrderSuccess_Share)
}

-(UIImage *) screenshotOnCurrentView{
	shareBtn.hidden = YES;
	captureBtn.hidden = YES;
	goMyOrderBtn.hidden = YES;
	goHotelBtn.hidden = YES;
	line_1.hidden = YES;
	line_2.hidden = YES;
	line_3.hidden = YES;
	
	line_4.hidden = YES;
	line_5.hidden = YES;
	selectedView.hidden = YES;
	
	UIImage *screenShot = [scrollview imageByRenderingViewWithSize:scrollview.contentSize];
	
	shareBtn.hidden = NO;
	captureBtn.hidden = NO;
	goMyOrderBtn.hidden = NO;
	goHotelBtn.hidden = NO;
	line_1.hidden = NO;
	line_2.hidden = NO;
	line_3.hidden = NO;
	
	line_4.hidden = NO;
	line_5.hidden = NO;
	selectedView.hidden = NO;
	
	return screenShot;
}

-(NSString *) smsContent{
	JHotelOrder *orderInfo = (JHotelOrder *)[HotelPostManager hotelorder];
	NSString *orderNo = self.hotelOrder;
	NSString *date_str = [NSString stringWithFormat:@"%@至%@",[TimeUtils displayDateWithJsonDate:[orderInfo getArriveDate] formatter:@"MM月dd日"],[TimeUtils displayDateWithJsonDate:[orderInfo getLeaveDate] formatter:@"MM月dd日"]];
	NSString *message = [NSString stringWithFormat:@"我在艺龙旅行客户端成功预订一家酒店，订单号：%@，%@ ,地址：%@ 日期：%@。",orderNo,[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"],
						 [[HotelDetailController hoteldetail] safeObjectForKey:@"Address"],date_str];
	
	
	NSString *messageBody = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
	
	return messageBody;
}

-(NSString *) mailContent{
	JHotelOrder *orderInfo = (JHotelOrder *)[HotelPostManager hotelorder];
	NSString *orderNo = self.hotelOrder;
	NSString *date_str = [NSString stringWithFormat:@"%@至%@",[TimeUtils displayDateWithJsonDate:[orderInfo getArriveDate] formatter:@"MM月dd日"],[TimeUtils displayDateWithJsonDate:[orderInfo getLeaveDate] formatter:@"MM月dd日"]];
	NSString *message = [NSString stringWithFormat:@"我在用艺龙旅行客户端成功预订一家酒店，既便捷又超值。订单号：%@，%@ ,地址：%@ 日期：%@。",orderNo,[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"],
						 [[HotelDetailController hoteldetail] safeObjectForKey:@"Address"],date_str];
	
	NSString *messageBody = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166\n订单详情见附件图片：",message];
	return messageBody;
}

- (NSString *) weiboContent{
	JHotelOrder *orderInfo = (JHotelOrder *)[HotelPostManager hotelorder];
	NSDictionary *dict = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
	NSString *currencyStr = [dict safeObjectForKey:@"Currency"];
	NSString *currencyMark = nil;
	if ([currencyStr isEqualToString:CURRENCY_HKD]) {
		currencyMark = CURRENCY_HKDMARK;
	}
	else if ([currencyStr isEqualToString:CURRENCY_RMB]) {
		currencyMark = CURRENCY_RMBMARK;
	}
	else {
		currencyMark = currencyStr;
	}
	NSString *price_str = [NSString stringWithFormat:@"%@%.f",currencyMark,[orderInfo getTotalPrice]];
	
	NSString *message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订一家酒店，既便捷又超值。%@ ,地址：%@，艺龙价仅售%@。",[[HotelDetailController hoteldetail] safeObjectForKey:@"HotelName"],
						 [[HotelDetailController hoteldetail] safeObjectForKey:@"Address"],price_str];
	//		NSString *urlStr = [NSString stringWithFormat:@"http://hotel.elong.com/Beijing_Hotel_Beijing-%@-hotel/",[source safeObjectForKey:@"HotelId"]];
	NSString *content = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
	return content;
}
@end
