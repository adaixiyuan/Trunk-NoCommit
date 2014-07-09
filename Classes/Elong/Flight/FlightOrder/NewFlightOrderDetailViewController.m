//
//  NewFlightOrderDetailViewController.m
//  ElongClient
//
//  Created by Janven on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "NewFlightOrderDetailViewController.h"
#import "FlightOrderDetail.h"
#import "FlightOrderDetailCell.h"
#import "FunctionUtils.h"
#import "ShareTools.h"
#import "FlightOrderSuccess.h"
#import "JGetFlightOrder.h"
#import "OrderHistoryPostManager.h"
#import "AlipayViewController.h"
#import "AlixPay.h"
#import "FlightSeatCustomerListVC.h"
#import "FOrderSeatDetailInfo.h"

#define AlipayActionSheetTag 100
#define AlipayAlertTag 101
#define RefundAlertTag 111

@interface NewFlightOrderDetailViewController ()

@end

@implementation NewFlightOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        orderStatus = @"取消";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAlipayWap:) name:NOTI_ALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
    }
    return self;
}
-(void)dealloc{
    
    if (_getSeatInfoUtil)
    {
        [_getSeatInfoUtil cancel];
        [_getSeatInfoUtil setDelegate:nil];
        SFRelease(_getSeatInfoUtil);
    }
    if (_seatInfoResultDesc)
    {
        SFRelease(_seatInfoResultDesc);
    }
    
    if (_fOrderSeatInfo)
    {
        SFRelease(_fOrderSeatInfo);
    }
    self.passengersTickets = nil;
    self.arrayPassengerSeatInfo = nil;
    [captureimage release];
    [_tableView release];
    self.orderDetail = nil;
    [super dealloc];
}

//Important
#pragma  mark 
#pragma  mark PrepareData

-(void)prepareTheOrderDetailData{
    NSMutableArray *details = [[NSMutableArray alloc] init];
    for (NSDictionary *payDetail_model in self.orderDetail.PaymentInfo.PaymentDetails) {
        PaymentDetail *pay = [[PaymentDetail alloc] init];
        [pay convertObjectFromGievnDictionary:payDetail_model relySelf:YES];
        [details addObject:pay];
        [pay release];
    }
    //
    self.orderDetail.PaymentInfo.PaymentDetails = details;
    [details release];
    
    //获取乘机人和票数的总信息
    NSMutableArray *passAndTickets = [[NSMutableArray alloc] init];
    
    for (NSDictionary  *tickerInfo_dic in self.orderDetail.PassengerTikets) {
        
        NSMutableArray *tickets = [[NSMutableArray alloc] init];
        PassengerTiketInfo *info_passernger = [[PassengerTiketInfo alloc] init];
        [info_passernger convertObjectFromGievnDictionary:tickerInfo_dic relySelf:YES];
        for (NSDictionary *dic in info_passernger.Tickets) {
            TicketInfo *info = [[TicketInfo alloc] init];
            [info convertObjectFromGievnDictionary:dic relySelf:YES];
            //取订单状态 机票的状态是与订单绑定的
            orderStatus = info.TicketStatusName;//
            
            NSMutableArray *airInfos = [[NSMutableArray   alloc] init];
            for (NSDictionary *dic_airInfo in info.AirLineInfos) {
                AirLineInfo *air = [[AirLineInfo alloc] init];
                [air convertObjectFromGievnDictionary:dic_airInfo relySelf:YES];
                [airInfos addObject:air];
                [air release];
            }
            info.AirLineInfos = airInfos;
            [airInfos release];
            [tickets addObject:info];
            [info release];
        }
        info_passernger.Tickets = tickets;
        [tickets release];
        //保险信息
        NSMutableArray *insuranceArray = [[NSMutableArray alloc] init];
        for (NSDictionary *insurance_Dic in info_passernger.InsuranceInfo.InsuranceDetail) {
            InsuranceDetail *detail = [[InsuranceDetail alloc] init];
            [detail convertObjectFromGievnDictionary:insurance_Dic relySelf:YES];
            [insuranceArray addObject:detail];
            [detail release];
        }
        info_passernger.InsuranceInfo.InsuranceDetail = insuranceArray;
        [insuranceArray release];
        [passAndTickets addObject:info_passernger];
        [info_passernger release];
    }
    self.passengersTickets = passAndTickets;
    self.orderDetail.PassengerTikets = passAndTickets;
    [passAndTickets release];

    //再次处理订单状态
    if (self.orderDetail.PaymentInfo.IsAllowContinuePay && [[ProcessSwitcher shared] allowAlipayForFlight]) {
        orderStatus = @"未支付";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self prepareTheOrderDetailData];
    
    //放在整体的数据源之后 by lc  退票按钮显示不,显示 则··选座按钮有 退票说明按钮显示
    _isAllowRefundlc = [self isAlreadyApplyForTiket];
    //乘车人数
    _passengerCount = [self.passengersTickets count];

    NSLog(@"_passengerCount====%d",_passengerCount);
    
    
    float bottomHeight = 0;
    if ([orderStatus isEqualToString:@"已出票"] || [orderStatus isEqualToString:@"已支付"]||[orderStatus isEqualToString:@"未支付"]) {
        bottomHeight = 44;
    }else{
        bottomHeight = 0;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44-20-bottomHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self addBaseBottomBar];
    
    
    // 请求选座信息
    [self getFlightSeatInfo];
}

-(void)addBaseBottomBar{
    
    if(bottomBar){
        [bottomBar removeFromSuperview];
        bottomBar = nil;
    }
    bottomBar = [[BaseBottomBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64-44 , 320, 44)];
    bottomBar.delegate = self;
    
    //添加到日历
    BaseBottomBarItem *againBookBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"添加到日历"
                                                                         titleFont:[UIFont systemFontOfSize:12.0f]
                                                                             image:@"order_calendarfooter.png"
                                                                   highligtedImage:@"order_calendarfooter_H.png"];
    //分享订单
    BaseBottomBarItem *shareOrderBarItem = [[BaseBottomBarItem alloc] initWithTitle:@"分享订单"
                                                                          titleFont:[UIFont systemFontOfSize:12.0f]
                                                                              image:@"hotelOrder_shareOrder_N.png"
                                                                    highligtedImage:@"hotelOrder_shareOrder_H.png"];
    
    // 订单保存
    BaseBottomBarItem *saveOrderBarItem= [[BaseBottomBarItem alloc] initWithTitle:@"保存订单"
                                                                        titleFont:[UIFont systemFontOfSize:12.0f]
                                                                            image:@"orderDetail_SaveOrder_N.png"
                                                                  highligtedImage:@"orderDetail_SaveOrder_H.png"];
    
    
    BaseBottomBarItem *alipayBarItem= [[BaseBottomBarItem alloc] initWithTitle:@"支付宝支付"
                                                                     titleFont:[UIFont systemFontOfSize:12.0f]
                                                                         image:@"ico_alipay_N.png"
                                                               highligtedImage:@"ico_alipay_H.png"];
    
    
    againBookBarItem.autoReverse = YES;
    againBookBarItem.allowRepeat = YES;
    
    shareOrderBarItem.autoReverse = YES;
    shareOrderBarItem.allowRepeat = YES;
    
    saveOrderBarItem.autoReverse = YES;
    saveOrderBarItem.allowRepeat = YES;
    
    alipayBarItem.autoReverse = YES;
    alipayBarItem.allowRepeat = YES;
    
	if([orderStatus isEqualToString:@"已出票"] || [orderStatus isEqualToString:@"已支付"]){
        NSArray *items = [NSArray arrayWithObjects:againBookBarItem,shareOrderBarItem,saveOrderBarItem, nil];
        bottomBar.baseBottomBarItems = items;
        
        [self.view addSubview:bottomBar];
	}else if([orderStatus isEqualToString:@"未支付"] && [ProcessSwitcher shared].allowAlipayForFlight){
        NSArray *items = [NSArray arrayWithObjects:alipayBarItem, nil];
        bottomBar.baseBottomBarItems = items;
        
        [self.view addSubview:bottomBar];
	}
    
    [againBookBarItem release];
    [shareOrderBarItem release];
    [saveOrderBarItem release];
    [alipayBarItem release];
    [bottomBar release];
}

-(void) shareOrderInfo{
    
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
    shareTools.needLoading = NO;
	shareTools.mailImage = [FunctionUtils captureViewOfScrollow:_tableView];
	
	shareTools.weiBoContent = [FunctionUtils getTheShareContentType:ShareContent_WeiBo AndSource:self.orderDetail];
	shareTools.msgContent = [FunctionUtils getTheShareContentType:ShareContent_SMS AndSource:self.orderDetail];
    shareTools.mailContent = [FunctionUtils getTheShareContentType:ShareContent_Mail AndSource:self.orderDetail];
	shareTools.mailTitle = @"使用艺龙旅行客户端预订机票成功！";
	[shareTools  showItems];
}

-(void)takeSnapshot{
    self.view.userInteractionEnabled = NO;
    //存到相册里的图片
    captureimage = [[FunctionUtils captureViewOfScrollow:_tableView] retain];
    //用来做动画的图片
    UIImage *pImageone = [self captureCurrentView] ;
    m_imgview = [[UIImageView alloc] initWithImage:pImageone];
    m_imgview.frame = _tableView.frame;
    [_tableView addSubview:m_imgview];
    [m_imgview release];
    [FunctionUtils animationOfSaveToPhotosAlbum:m_imgview andViewController:self];
}

-(UIImage *)captureCurrentView
{
    CGSize size = self.view.frame.size;
    //为了不
    size.height -= 40 + 45;
    
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
    _tableView.layer.masksToBounds=YES;
	[self.view.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return newImage;
}

// 处理乘客座位数据
- (void)passengerSeatDataProcess
{
    // 添加每名乘客的航线信息
    NSArray *arrayDetailInfo = [_fOrderSeatInfo arrayDetailInfo];
    if (ARRAYHASVALUE(arrayDetailInfo))
    {
        NSUInteger detailInfoCount = [arrayDetailInfo count];
        
        NSMutableArray *arrayPassengerTmp = [[NSMutableArray alloc] init];
        for (NSInteger i=0; i<detailInfoCount; i++)
        {
            FOrderSeatDetailInfo *seatDetailInfo = [arrayDetailInfo objectAtIndex:i];
            if (seatDetailInfo)
            {
                // 航线信息
                FOrderSeatAirLineInfo *airlineInfo = [seatDetailInfo airlineInfo];
                
                // 乘客信息
                NSArray *arrayPassengerPNR = [seatDetailInfo arrayPassengerPNR];
                if (ARRAYHASVALUE(arrayPassengerPNR))
                {
                    for (NSInteger j=0; j<[arrayPassengerPNR count]; j++)
                    {
                        FOrderSeatPassengerPNR *passengerPNR = [arrayPassengerPNR objectAtIndex:j];
                        
                        if (passengerPNR && airlineInfo)
                        {
                            [passengerPNR setAirlineInfo:airlineInfo];
                            
                            // 保存
                            [arrayPassengerTmp addObject:passengerPNR];
                        }
                    }
                }
            }
        }
        
        // 保存
        [self setArrayPassengerSeatInfo:[NSArray arrayWithArray:arrayPassengerTmp]];
        [arrayPassengerTmp release];
    }
}

// 获取座位信息
- (void)getFlightSeatInfo
{
    // 发起请求
    // 组织Json
	NSMutableDictionary *dictionaryJson = [NSMutableDictionary dictionary];
    
    // 请求头
    NSMutableDictionary *headDic = [PostHeader header];
    if (DICTIONARYHASVALUE(headDic))
    {
        [dictionaryJson safeSetObject:headDic forKey:Resq_Header];
    }
    
    // 订单号
    NSString *orderNo = [_orderDetail OrderNo];
    if (STRINGHASVALUE(orderNo))
    {
        [dictionaryJson safeSetObject:orderNo forKey:@"OrderNo"];
    }
    
    // 艺龙卡号
    NSString *cardNo = [[AccountManager instanse] cardNo];
    if (STRINGHASVALUE(cardNo))
    {
        [dictionaryJson safeSetObject:cardNo forKey:@"CardNo"];
    }
    
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods requesString:@"GetFlightOrderSeatInfo" andIsCompress:YES andParam:paramJson];
    
    if (url != nil)
    {
        // Load 状态
        _isSeatInfoLoad = YES;
        [_tableView reloadData];
        
        
        netType = @"getFlightSeatInfo";
        
        HttpUtil *getSeatInfoUtilTmp = [[HttpUtil alloc] init];
        [self setGetSeatInfoUtil:getSeatInfoUtilTmp];
        [getSeatInfoUtilTmp release];
        
        [_getSeatInfoUtil connectWithURLString:FLIGHT_SERACH
                                      Content:url
                                 StartLoading:NO
                                   EndLoading:NO
                                     Delegate:self];
    }
}

#pragma mark
#pragma mark Animation delegate methods

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished {
    [CATransaction begin];
    {
        [CATransaction setDisableActions:YES];
        if(finished) {
            [m_imgview removeFromSuperview];
            UIImageWriteToSavedPhotosAlbum(captureimage,
                                           self,
                                           @selector(imageSavedToPhotosAlbum:
                                                     didFinishSavingWithError:
                                                     contextInfo:),
                                           nil);
        }
    }
    [CATransaction commit];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message;
    NSString *title;
    if (!error)
	{
        title = nil;
        message = NSLocalizedString(@"订单已经保存到相册", @"");
    } else {
        title = NSLocalizedString(@"保存失败，为允许访问相册，请在设置中打开！", @"");
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

#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if([orderStatus isEqualToString:@"已出票"] || [orderStatus isEqualToString:@"已支付"]){
        if(index==0){
            //添加到日历
            [FunctionUtils addScheduleToCalendarOn:self andDataModel:self.orderDetail];
        }else if(index==1){
            //分享订单
            [self shareOrderInfo];
        }else if(index==2){
            //保存订单
            [self takeSnapshot];
        }
	}else if([orderStatus isEqualToString:@"未支付"] && [ProcessSwitcher shared].allowAlipayForFlight){
        if(index==0){
            //支付宝支付
            [self againPayByalipay];
        }
	}
}

-(void)againPayByalipay{
	[FlightOrderSuccess setInstance:nil];
	netType = @"isAllowPay";
	JGetFlightOrder *jgfol=[OrderHistoryPostManager getFlightOrder];
	[jgfol clearBuildData];
	[jgfol setOrderNo:self.orderDetail.OrderNo];
	[Utils request:MYELONG_SEARCH req:[jgfol requesString:YES] delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){

        if (self.flyType == 0) {
            return 1;
        }else{
            return 2;
        }
    }
    else if (section == 2){
        return [self.passengersTickets count];
    }
    else if (section == 3)
    {
        if (ARRAYHASVALUE(_arrayPassengerSeatInfo))
        {
            return [_arrayPassengerSeatInfo count];
        }
        else
        {
            return 1;
        }
        
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0)
    {
        return (STRINGHASVALUE(self.orderDetail.DistributionInfo.DistributionAddress))?230:180;
    }
    else if (indexPath.section == 1)
    {
        return 150;
    }
    else if(indexPath.section==2)
    {  //乘机人
        PassengerTiketInfo *passenerTiket = [self.passengersTickets objectAtIndex:indexPath.row];
        BOOL isrefund = NO;  //允许退票
        for (TicketInfo *info in passenerTiket.Tickets) {
            if (info.isAllowRefund==YES) {
                isrefund  = YES;
                break;
            }
        }
        if (isrefund) {
            return 67;
        }else{
            return 44;
        }
        
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==2) {
        return 22;
    }else if (section ==3){
        return _isAllowRefundlc?50:22;
    }else{
        return 0;
    }
    
    return 0;
}





-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    label.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
    label.font = FONT_15;
    if (section == 2) {
        label.text = @"   乘机人";
    }else if (section == 3){  //比较特别
        label.text = @"   选座情况:";//by lc
        
        if (_isAllowRefundlc) {  //yes表示 允许退机票 有退票按钮显示
            [label release];
            UIView *aview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
            aview.backgroundColor = RGBACOLOR(245, 245, 245, 1.0);
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 320, 22)];
            label.backgroundColor = [UIColor clearColor];
            label.font = FONT_15;
            label.text = @"   选座情况:";
            [aview addSubview:label];
            [label release];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = CGRectMake(200, 5, 100, 22);
            [btn setTitle:@"申请退票说明" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = FONT_12;
            [btn addTarget:self action:@selector(applayrefundTitcket) forControlEvents:UIControlEventTouchUpInside];
            [aview addSubview:btn];
            
            UIImageView *rightArrow = [[UIImageView alloc]init];
            rightArrow.frame = CGRectMake(298, 10, 5, 9);
            rightArrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
            [aview addSubview:rightArrow];
            [rightArrow release];
            
            
            return [aview autorelease];
        }
    }
    return [label autorelease];
}

-(TicketInfo  *)getTheNoDropTicketFromGivenArray:(int)index andSingle:(BOOL)single andGo:(BOOL)go{
    
    TicketInfo *returnInfo = nil;
    if (single) {
        PassengerTiketInfo *p_t_info = [self.orderDetail.PassengerTikets objectAtIndex:index];
        for (TicketInfo *info in p_t_info.Tickets) {
            if (![info.TicketStatusName isEqualToString:@"已废"]) {
                returnInfo = info;
                break;
            }
        }
    }else{
        //往返
        for (PassengerTiketInfo *p_t_info in self.orderDetail.PassengerTikets) {
            if (go) {
                TicketInfo *info = [p_t_info.Tickets objectAtIndex:0];
                if (![info.TicketStatusName isEqualToString:@"已废"]) {
                    returnInfo = info;
                    break;
                }
            }else{
                TicketInfo *info = [p_t_info.Tickets objectAtIndex:1];
                if (![info.TicketStatusName isEqualToString:@"已废"]) {
                    returnInfo = info;
                    break;
                }
            }
        }
    }
    return returnInfo;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        static NSString *CellIdentifier_order = @"OrderRelated";
        FlightOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_order];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FlightOrderDetail" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }

        cell.orderTip.hidden = YES;
        cell.chooseSeatBtn.hidden = _seatCanSelect?NO:YES;
        
        if (_isSeatInfoLoad)
        {
            [cell.activityIndicator startAnimating];
        }
        else
        {
            [cell.activityIndicator stopAnimating];
        }
        
        // 选座状态
        if (STRINGHASVALUE(_seatInfoResultDesc))
        {
            cell.orderTip.hidden = NO;
            
            [cell.orderTip setText:_seatInfoResultDesc];
        }
        
        [cell bindTheDisplayOrder:self.orderDetail];
        return cell;
    }else if (indexPath.section == 1){
        static NSString *CellIdentifier_flight = @"FlightRelated";
        FlightOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_flight];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FlightOrderDetail_flight" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }

        if (self.flyType == 0) {
            PassengerTiketInfo *p = [self.orderDetail.PassengerTikets objectAtIndex:indexPath.row];
            TicketInfo *info = [p.Tickets objectAtIndex:indexPath.row];
            //单程
            if ([self getTheNoDropTicketFromGivenArray:indexPath.row andSingle:YES andGo:nil]) {
                info = [self getTheNoDropTicketFromGivenArray:indexPath.row andSingle:YES andGo:nil];
            }
            [cell bindTheDisplayModelOfTicketsRelated:info andFlyType:@""];
        }else{
            //往返
            PassengerTiketInfo *p = nil;
            if ([self.orderDetail.PassengerTikets count] == 1) {
                p  = [self.orderDetail.PassengerTikets objectAtIndex:0];
            }else{
                p  = [self.orderDetail.PassengerTikets objectAtIndex:indexPath.row];
            }
            TicketInfo *info = [p.Tickets objectAtIndex:indexPath.row];
            
            switch (indexPath.row) {
                case 0:
                    if ([self getTheNoDropTicketFromGivenArray:indexPath.row andSingle:NO andGo:YES]) {
                        info = [self getTheNoDropTicketFromGivenArray:indexPath.row andSingle:NO andGo:YES];
                    }
                    [cell bindTheDisplayModelOfTicketsRelated:info andFlyType:@"去程"];
                    break;
                case 1:
                    if ([self getTheNoDropTicketFromGivenArray:indexPath.row andSingle:NO andGo:NO]) {
                        info = [self getTheNoDropTicketFromGivenArray:indexPath.row andSingle:NO andGo:NO];
                    }
                    [cell bindTheDisplayModelOfTicketsRelated:info andFlyType:@"返程"];
                    break;
                default:
                    break;
            }
        }
        return cell;
    }else if(indexPath.section == 2){  //乘机人 修改 by lc
        static NSString *CellIdentifier_passenger = @"PassengersRelated";
        FlightOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_passenger];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FlightOrderDetail_Passenger" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        cell.delegate = self;
        PassengerTiketInfo *info = [self.passengersTickets objectAtIndex:indexPath.row];
        [cell bindTheDisplayModelOfPassenger:info isBackandForth:self.flyType cellrow:indexPath.row passengerCount:_passengerCount];
        return cell;
    }else{
        static NSString *CellIdentifier_passenger = @"PassengerSeatsRelated";
        FlightOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier_passenger];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FlightOrderDetail_Seat" owner:self options:nil] lastObject];
            cell.topLineImgView.hidden = YES;
            cell.bottomLineImgView.hidden = YES;
            [cell addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, cell.height-1, SCREEN_WIDTH, 1)]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        if (_isSeatInfoLoad)
        {
            [cell.loadingView startAnimating];
        }
        else
        {
            [cell.loadingView stopAnimating];
            
        }
        
        
        // 乘客信息
        FOrderSeatPassengerPNR *passengerPnr = [_arrayPassengerSeatInfo objectAtIndex:indexPath.row];
        if (passengerPnr != nil)
        {
            // 乘客名
            NSString *passengerName = [[passengerPnr passengerInfo] name];
            if (STRINGHASVALUE(passengerName))
            {
                cell.passenger.hidden = NO;
                
                cell.passenger.text = passengerName;
            }
            
            // 航班号
            NSString *flightNumber = [[passengerPnr airlineInfo] flightNumber];
            if (STRINGHASVALUE(flightNumber))
            {
                cell.flight.hidden = NO;
                
                cell.flight.text = flightNumber;
            }
            
            // 起降站
            NSString *departStation = [[passengerPnr airlineInfo] departAirPort];
            NSString *arriveStation = [[passengerPnr airlineInfo] arrivalAirPort];
            if (STRINGHASVALUE(departStation) && STRINGHASVALUE(arriveStation))
            {
                cell.startToEnd.hidden = NO;
                
                cell.startToEnd.text = [NSString stringWithFormat:@"%@-%@",departStation,arriveStation];
            }
            
            // 座位状态
            NSString *seatNumber = [passengerPnr seat];
            if (STRINGHASVALUE(seatNumber))
            {
                cell.seatStatus.hidden = NO;
                
                cell.seatStatus.text = seatNumber;
            }
            else if ([passengerPnr isCanSelect] != nil)
            {
                cell.seatStatus.hidden = NO;
                
                NSNumber *isCanSelect = [passengerPnr isCanSelect];
                if ([isCanSelect boolValue] == YES)
                {
                    cell.seatStatus.text = @"待选座";
                }
                else
                {
                    cell.seatStatus.text = @"不可选座";
                }
            }
        }
        return cell;
    }
}

#pragma mark
#pragma mark -------OnLine Choose Seats

-(void)gotoTheChooseSeatsViewController{

    NSLog(@"---Go to choose Seats");
    
    if (_fOrderSeatInfo != nil)
    {
        FlightSeatCustomerListVC *controller = [[FlightSeatCustomerListVC alloc] init];
        
        [controller setFOrderSeatInfo:_fOrderSeatInfo];
        // 订单号
        NSString *orderNo = [_orderDetail OrderNo];
        if (STRINGHASVALUE(orderNo))
        {
            [controller setOrderNo:orderNo];
        }
        NSString *orderCode = [_orderDetail OrderCode];
        if (STRINGHASVALUE(orderCode))
        {
            [controller setOrderCode:orderCode];
        }
        
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
    
    
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
	NSError *error = nil;
	EKEvent *thisEvent = controller.event;
	switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing.
			break;
		case EKEventEditViewActionSaved:
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			break;
		case EKEventEditViewActionDeleted:
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			break;
		default:
			break;
	}
    if (IOSVersion_7) {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }else{
        [controller dismissModalViewControllerAnimated:YES];
    }
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.navDrawEnabled = NO;
}

#pragma mark -
#pragma mark 选择支付方式
- (void) showPayType{
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"选择支付方式"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"支付宝客户端支付",@"支付宝网页支付",nil];
	
	menu.delegate = self;
    menu.tag  = AlipayActionSheetTag;
	menu.actionSheetStyle=UIBarStyleBlackTranslucent;
	[menu showInView:self.view];
	[menu release];
}

#pragma mark -
#pragma mark Notification
- (void) weixinPaySuccess{
    [self paySuccess];
}

- (void)notiByAlipayWap:(NSNotification *)noti{
    [self paySuccess];
}

- (void) alipayPaySuccess{
    [self paySuccess];
}

-(void) paySuccess{
	orderStatus = @"已支付";
    [self addBaseBottomBar];
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
        askingAlert.tag = AlipayAlertTag;
        [askingAlert release];
        
        jumpToSafari = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//[self.navigationController popViewControllerAnimated:YES];
    if (alertView.tag == AlipayAlertTag) {
        if (0 != buttonIndex){
            // 已支付
            [self paySuccess];
        }else{
            
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag==AlipayActionSheetTag){
        if (buttonIndex == 0){
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
                //客户端存在，打开客户端
                //开始支付
                netType = @"pay";
                payType = @"Client";
                NSString *reqParam = [NSString stringWithFormat:@"action=GetAlipayBefundInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[[FunctionUtils getAlipayRequestDictionaryWithType:payType AndSource:self.orderDetail] JSONRepresentationWithURLEncoding]];
                [Utils orderRequest:FLIGHT_SERACH req:reqParam delegate:self];
            }else{
                [PublicMethods showAlertTitle:nil Message:@"未发现支付宝客户端，请您更换别的支付方式或下载支付宝"];
                return;
            }
        }else if(buttonIndex == 1){
            // 支付宝
            netType = @"pay";
            payType = @"wap";
            NSString *reqParam = [NSString stringWithFormat:@"action=GetAlipayBefundInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[[FunctionUtils getAlipayRequestDictionaryWithType:payType AndSource:self.orderDetail] JSONRepresentationWithURLEncoding]];
            [Utils orderRequest:FLIGHT_SERACH req:reqParam delegate:self];
        }
    }
}
#pragma mark
#pragma mark -------------Alipay Related------------
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {

    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"root==%@",root);
	if ([Utils checkJsonIsError:root])
    {
        // 取消load状态
        _isSeatInfoLoad = NO;
        [_tableView reloadData];
        
        
		return;
	}
    CFShow(root);
    if (util == _getSeatInfoUtil) {
        _isSeatInfoLoad = NO;
        
        
        FOrderSeatInfo *fOrderSeatInfoTmp = [[FOrderSeatInfo alloc] init];
        [fOrderSeatInfoTmp parseSearchResult:root];
        
        NSNumber *isError = [fOrderSeatInfoTmp isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            // 保存
            [self setFOrderSeatInfo:fOrderSeatInfoTmp];
            
            // 判断是否可以选座
            _seatCanSelect = NO;
            NSArray *arraySeatDetailInfo = [fOrderSeatInfoTmp arrayDetailInfo];
            if (ARRAYHASVALUE(arraySeatDetailInfo))
            {
                for (NSInteger i=0; i<[arraySeatDetailInfo count]; i++)
                {
                    FOrderSeatDetailInfo *fSeatDetailInfo = [arraySeatDetailInfo objectAtIndex:i];
                    if (fSeatDetailInfo)
                    {
                        NSNumber *isCanSelect = [fSeatDetailInfo isCanSelect];
                        if (isCanSelect && [isCanSelect boolValue] == YES)
                        {
                            _seatCanSelect = YES;
                        }
                    }
                }
            }
            
            // 处理乘客选座信息
            [self passengerSeatDataProcess];
        }
        else
        {
            _seatInfoResultDesc = @"成功出票后,可在线选座";
            
            _seatCanSelect = NO;
        }
        
        //
        [fOrderSeatInfoTmp release];
        
        [_tableView reloadData];
    }else{
        if([netType isEqualToString:@"isAllowPay"]){
            //做了一下改动
            if(self.orderDetail.PaymentInfo.IsAllowContinuePay){
                [self showPayType];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单已被取消，不能再支付！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
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
        // 选座信息
        else if ([netType isEqualToString:@"refund"]){
            
            NSLog(@"机票退订....");
            if ([[root safeObjectForKey:@"RequirementRecordID"] intValue]>0) {
                NSLog(@"退票成功...");
                NSString *content= @"1 您的退票申请已提交，艺龙将直接为您办理退票，退票完成后短信通知到您预留的联系电话。（凌晨02:00-08:00期间提交，将于上午10:00前处理，可能会增加退票费。紧急情况请联系4009333333转2）\n2 依据航空公司规定，如果行程单已在您手中，请按短信中的地址邮寄我们，以免您的退款被延迟。";
                
                [self afterRefundSuccessChangeData]; //修改数据源
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
                
                
            }else{
                NSString *content = @"办理失败，请稍后再试。";
                if ([root safeObjectForKey:@"ErrorMessage"]!=nil&&STRINGHASVALUE([root safeObjectForKey:@"ErrorMessage"])) {
                    NSLog(@"有错误信息");
                    content = [root safeObjectForKey:@"ErrorMessage"];
                }
                NSLog(@"退票失败.,...");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            }
            
        }
    }
    
	
	
}

#pragma mark -
#pragma mark 申请退票的判断
-(BOOL)isAlreadyApplyForTiket{
    
    BOOL isAllowRefundlc = NO;  //默认不可以申请退票
    
    for (PassengerTiketInfo * passenerTiket in self.passengersTickets) {
        
        for (TicketInfo *info in passenerTiket.Tickets) {
            if (info.isAllowRefund==YES) {
                isAllowRefundlc = YES;
                break;
            }
        }
        
        if (isAllowRefundlc) {
            break;
        }
    }
    return isAllowRefundlc;
}

//申请退票说明 入口
-(void)applayrefundTitcket{
    //btn action
    NSLog(@"查看申请退票说明");
    
    NSString *conetent= @"1 当退票申请提交后，艺龙将直接为您办理退票，退票完成后短信通知到您预留的联系电话。（凌晨02:00-08:00期间提交，将于上午10:00前处理，可能会增加退票费。紧急情况请联系4009333333转2）\n2 依据航空公司规定，如果行程单已在您手中，请按短信中的地址邮寄我们，以免您的退款被延迟。";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:conetent delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


#pragma mark  -
#pragma mark  OrderDetailCellDelegate

//点击申请退票说明的按钮
-(void)orderDetailCellDelegate:(FlightOrderDetailCell *)sender refundgo:(BOOL)refundgo refundback:(BOOL)refundback refund:(BOOL)refund actionBTN:(UIButton *)actionBTN{

    __block typeof(self) viewself = self;

    NSIndexPath *indexPath=[_tableView indexPathForCell:sender];
    int itag = actionBTN.tag;
    int arrayindex=itag-2000;
    PassengerTiketInfo *info = [viewself.passengersTickets objectAtIndex:indexPath.row];
    
    NSString *name=info.PassengerInfo.Name;//乘客姓名;
    
    NSString *identifierType = [Utils getCertificateName:[info.PassengerInfo.CertificateType intValue]];
    //若是身份证，隐藏后四位
    NSString *num = info.PassengerInfo.CertificateNumber;
    
    if ([info.PassengerInfo.CertificateType intValue] ==0 && [info.PassengerInfo.CertificateNumber length] > 4)
    {
        num = [num stringByReplaceWithAsteriskFromIndex:[num length]-4];
    }
    NSString *fullnum = [identifierType stringByAppendingFormat:@"/%@",num];  //证件号
    
    if (arrayindex>([info.Tickets count]-1)) {  //安全判断
        return;
    }
    
    TicketInfo *tiketinfo = [info.Tickets objectAtIndex:arrayindex];
    
    NSArray *airlineInfo=[tiketinfo AirLineInfos];
    AirLineInfo *lineinfo=[airlineInfo safeObjectAtIndex:0];
    
    NSString *DepartAirPort = lineinfo.DepartAirPort;
    NSString *ArrivalAirPort = lineinfo.ArrivalAirPort;
    NSString *DepartDate = lineinfo.DepartDate;
    
//    NSDate *DepartTime = [TimeUtils gmtNSDateToGMT8NSDate:date formatter:@"yyyy-MM-dd HH:mm"];
    
    NSString *DepartTime = [TimeUtils displayDateWithJsonDate:DepartDate formatter:@"yyyy-MM-dd HH:mm"];
    
    
    NSString *fullplace = [NSString stringWithFormat:@"%@-%@",DepartAirPort,ArrivalAirPort];
    
    NSString *content = [NSString stringWithFormat:@"确定为 %@ %@ %@ 申请退票?",name,fullnum,fullplace];
    
//    @"确定为 张三 身份证/4109011988****   北京-上海    申请退票？";
    
    BlockUIAlertView * alter = [[BlockUIAlertView alloc]initWithTitle:@"提示" message:content cancelButtonTitle:@"取消" otherButtonTitles:@"确定" buttonBlock:^(NSInteger index) {
        if (index == 0) {
            NSLog(@"取消");
        }
        else if (index == 1) {
            NSLog(@"确定");
            
            NSLog(@"aaaaaa====");
            NSString *OrderId = viewself.orderDetail.OrderNo;  //订单号
            NSString *OrderCode = viewself.orderDetail.OrderCode;   //订单code
            NSString *CardNo = viewself.orderDetail.BookerInfo.CardNo;  //卡号
            
            NSLog(@"refundgo=%d  refundback==%d  refun==%d  ",refundgo,refundback,refund);
            
            NSArray *ticketsArray=[info Tickets];
            TicketInfo *tiketinfo=[ticketsArray objectAtIndex:arrayindex];
            NSString * ticketId= tiketinfo.TicketId;
            
            NSNumber *ticketIdNumber = [NSNumber numberWithLong:[ticketId longLongValue]];
            
            
            NSArray *arrayTiketsid  = [NSArray arrayWithObjects:ticketIdNumber, nil];
            //test  测试接口
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
            [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
            [mutDict safeSetObject:@"ewiphone" forKey:@"ChannelID"];
            [mutDict safeSetObject:CardNo forKey:@"CardNo"];
            [mutDict safeSetObject:OrderCode forKey:@"OrderId"];  //风险  orderid 与OrderCode 后端给反了注意传参数的时候反着给 by 建波
            [mutDict safeSetObject:OrderId forKey:@"OrderCode"];  //风险
            [mutDict safeSetObject:arrayTiketsid forKey:@"TicketIds"];  //vlue是个数组
            [mutDict safeSetObject:DepartTime forKey:@"DepartTime"];
            NSString *reqParam = [NSString stringWithFormat:@"action=GenerateRefundRequirementOrder&compress=true&req=%@",[mutDict JSONRepresentationWithURLEncoding]];
            NSLog(@"mutdict==%@",[mutDict JSONString]);
            netType= @"refund";
            _needHidenrow = indexPath.row;  //当前cell
            _needHidentag = arrayindex; //当前cell的第几个按钮
            [Utils request:FLIGHT_SERACH req:reqParam delegate:viewself];
            [mutDict release];
            NSLog(@"FLIGHT_SERACH==%@",FLIGHT_SERACH);
            
            
        }
    }];
    [alter show];
    [alter release];
    
}
//当退票成功后 修改数据源
-(void)afterRefundSuccessChangeData{
    
    PassengerTiketInfo *info = [self.passengersTickets objectAtIndex:_needHidenrow];
    TicketInfo *tiketinfo = [info.Tickets objectAtIndex:_needHidentag];
    NSArray *tiketsArray=info.Tickets;
    
    tiketinfo.isAlreadyRefund = YES;  //修改数据源设置已经提交过了
    
    NSIndexPath *indepath = [NSIndexPath indexPathForRow:_needHidenrow inSection:2];
    
    FlightOrderDetailCell *cell = (FlightOrderDetailCell *)[_tableView cellForRowAtIndexPath:indepath];
    
    if ([tiketsArray count]==2) {  //往返的
        
        if (_needHidentag==0) {  //去程
            cell.refundgo.enabled = NO;
            [cell.refundgo setTitle:@"已申请去程退票" forState:UIControlStateNormal];
            cell.refundgo.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            [cell.refundgo setBackgroundImage:nil forState:UIControlStateNormal];
            
        }else if (_needHidentag==1){  //返程
            cell.refundback.enabled = NO;
            [cell.refundback setTitle:@"已申请返程退票" forState:UIControlStateNormal];
            cell.refundback.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            [cell.refundback setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
    }else if ([tiketsArray count]==1){  //单程的
        cell.refund.enabled = NO;
        [cell.refund setTitle:@"已申请退票" forState:UIControlStateNormal];
        cell.refund.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [cell.refund setBackgroundImage:nil forState:UIControlStateNormal];
    }
}



//开始退票
-(void)applayrefundAction{
    
}



@end
