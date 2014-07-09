//
//  FlightOrderHistoryDetail.m
//  ElongClient
//
//  Created by WangHaibin on 3/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlightOrderHistoryDetail.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import "AlipayViewController.h"
#import "ShareTools.h"
#import "ElongClientAppDelegate.h"
#import "FlightOrderSuccess.h"

#define FlightInfoTag 2000
#define  AlipayAlertTag 8081
#define AlipayActionSheetTag 8082
@implementation FlightOrderHistoryDetail
@synthesize orderStatus;

static FlightOrderHistoryDetail *flightOrderDetail = nil;
@synthesize delegate;

+(FlightOrderHistoryDetail *) instance{
	return flightOrderDetail;
}
+(void) setInstance:(FlightOrderHistoryDetail *)inst{
	flightOrderDetail = inst;
}

- (int)labelHeightWithNSString:(UIFont *)font string:(NSString *)string width:(int)width {
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:UILineBreakModeWordWrap];
	return expectedLabelSize.height;
}


- (id)initWithData:(NSDictionary *)dataDic {
	if (self = [super initWithTopImagePath:@"" andTitle:@"订单详情" style:_NavNormalBtnStyle_]) {
        
		sourceDic = [[NSMutableDictionary alloc] initWithDictionary:dataDic];
        passArray = [[NSMutableArray alloc] init];
        offY = 0;
        [self addTopView];      //add TopView
        offY = topView.frame.size.height;
        [self addMiddleView];       //add Middle View
        [self addPassengerView];
        
        rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, offY);
        if([orderStatus isEqualToString:@"已出票"] || [orderStatus isEqualToString:@"未支付"] || [orderStatus isEqualToString:@"已支付"]){
            [self addListFooterView];
            rootScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44);
        }else {
            rootScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAlipayWap:) name:NOTI_ALIPAY_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiByAppActived:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayPaySuccess) name:NOTI_ALIPAY_PAYSUCCESS object:nil];
        
        UMENG_EVENT(UEvent_UserCenter_FlightOrder_DetailEnter)
	}
	
	return self;
}


- (void)addTopView{
	//订单号
	orderNoLabel.text = [NSString stringWithFormat:@"%d",[[sourceDic safeObjectForKey:@"OrderNo"] intValue]];
    //预订日期
	creatDateLabel.text = [TimeUtils displayDateWithJsonDate:[sourceDic safeObjectForKey:@"CreateTime"] formatter:@"yyyy-MM-dd"];
	//总价
    int totalPrice = [[sourceDic safeObjectForKey:@"PayFee"] intValue];
    [totalPriceLabel setText:[NSString stringWithFormat:@"%d",totalPrice]];
    //票价和税费
    int ticketTotalPrice = 0;
    int ticketTotalTax = 0;
    NSArray *tickets = [sourceDic safeObjectForKey:@"Tickets"];
    if(ARRAYHASVALUE(tickets)){
        for(NSDictionary *ticket in tickets){
            int aTicketPrice = [[ticket objectForKey:@"TicketPrice"] intValue];
            ticketTotalPrice+=aTicketPrice;
            
            int aTax  = [[ticket objectForKey:@"TicketTax"] intValue];
            ticketTotalTax +=aTax;
        }
    }
    ticketPriceLabel.text = [NSString stringWithFormat:@"￥%d",ticketTotalPrice];
    ticketTaxLabel.text = [NSString stringWithFormat:@"￥%d",ticketTotalTax];
    //保险费
    NSDictionary *insuranceInfo = [sourceDic safeObjectForKey:@"InsuranceInfo"];
    int insuranceFee = [[insuranceInfo safeObjectForKey:@"InsurancePrice"] intValue];
    insuranceLabel.text = [NSString stringWithFormat:@"￥%d",insuranceFee];
    
    //行程单地址
    ticketGetType = [[sourceDic safeObjectForKey:@"TicketGetType"] intValue];
    ticketGetTypeString = @"";
    switch (ticketGetType) {
        case 1:{
            ticketGetTypeString = @"行程单邮寄地址";
        }
            break;
        case 2: {
            ticketGetTypeString = @"行程单自取地址";
        }
            break;
        case 3:{
            ticketGetTypeString = @"其它情况";
        }
            break;
    }
    //TicketGetType end
    if ([sourceDic safeObjectForKey:@"DeliveryPostcode"] == [NSNull null]) {
        deliverPostCodeString = @"";
    }else {
        deliverPostCodeString = [sourceDic safeObjectForKey:@"DeliveryPostcode"];
    }
    
    if ([sourceDic safeObjectForKey:@"DeliveryPerson"] == [NSNull null]) {
        deliveryPersonString = @"";
    }else {
        deliveryPersonString = [sourceDic safeObjectForKey:@"DeliveryPerson"];
    }
    
    
    if ([sourceDic safeObjectForKey:@"DeliveryAddress"] == [NSNull null]) {
        deliveryAddressString = @"";
    }else {
        deliveryAddressString = [sourceDic safeObjectForKey:@"DeliveryAddress"];
    }
    
    if (ticketGetType == 1) {
        deliverString = [NSString stringWithFormat:@"%@ / %@",deliveryPersonString,deliveryAddressString];
    }else {
        deliverString = [NSString stringWithFormat:@"%@",deliveryAddressString];
    }

    if(ticketGetType==0){
        //无地址
        topView.frame = CGRectMake(0, 0, 320, 160+10);
        postAddressNoteLabel.hidden = YES;
    }else{
        CGSize postAddressSize =   [deliverString sizeWithFont:FONT_14 constrainedToSize:CGSizeMake(290.0, 10000) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect postAddressRect = postAddressLabel.frame;
        postAddressRect.size.height = postAddressSize.height+10;
        postAddressLabel.frame  = postAddressRect;
        topView.frame = CGRectMake(0, 0, 320, floor(postAddressLabel.frame.origin.y+postAddressSize.height+20));
        postAddressNoteLabel.hidden = NO;
    }
    postAddressLabel.text = deliverString;
    topView.clipsToBounds = YES;
    
    [topView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, topView.frame.size.height - SCREEN_SCALE, 320, SCREEN_SCALE)]];
    [topView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)]];
    
    //状态
	orderStatus = @"取消";
	for (NSDictionary *ticket in [sourceDic safeObjectForKey:@"Tickets"]) {
		if(![[ticket safeObjectForKey:@"TicketStateName"] isEqualToString:@"取消"]){
			orderStatus = [ticket safeObjectForKey:@"TicketStateName"];
		}
	}
	
	if([[sourceDic safeObjectForKey:@"IsAllowContinuePay"] boolValue] && [ProcessSwitcher shared].allowAlipayForFlight){
		orderStatus = @"未支付";
	}

}

-(void)addMiddleView{
    NSArray *pnrs = [sourceDic safeObjectForKey:@"PNRs"];
    NSArray *tickets = [sourceDic safeObjectForKey:@"Tickets"];
    NSMutableArray *tmpFlight = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray *tmpFlight1 = [NSMutableArray arrayWithCapacity:1];
    for (int j=0;j<pnrs.count;j++) {
        NSDictionary *pnr = [pnrs objectAtIndex:j];
        NSArray *flights  = [pnr objectForKey:@"Flights"];
        for(int i=0; i<flights.count;i++){
            NSDictionary *flight = [flights objectAtIndex:i];
            NSString *flightNumber = [flight safeObjectForKey:@"FlightNumber"];        //航班号
            if(![tmpFlight1 containsObject:flightNumber]){
                [tmpFlight1 addObject:flightNumber];
            }
        }
    }
    for (int j=0;j<pnrs.count;j++) {
        NSDictionary *pnr = [pnrs objectAtIndex:j];
        NSArray *flights  = [pnr objectForKey:@"Flights"];
        for(int i=0; i<flights.count;i++){
            NSDictionary *flight = [flights objectAtIndex:i];

            NSString *airCorpName = [flight safeObjectForKey:@"AirCorpName"];          //航空公司
            NSString *flightNumber = [flight safeObjectForKey:@"FlightNumber"];        //航班号
            //儿童票，多加了一个判断
            if(![tmpFlight containsObject:flightNumber]){
                [tmpFlight addObject:flightNumber];
            }else{
                continue;
            }
            
            NSString *classTypename = [Utils getClassTypeName:[[flight safeObjectForKey:@"ClassType"] intValue]];      //舱位
            NSString *arriveTime=[TimeUtils displayDateWithJsonDate:[flight safeObjectForKey:@"ArrivalTime"] formatter:@"HH:mm"] ;
            NSString *departDay =[TimeUtils displayDateWithJsonDate:[flight safeObjectForKey:@"DepartTime"] formatter:@"yyyy-MM-dd"] ;
            NSString *departTime = [TimeUtils displayDateWithJsonDate:[flight safeObjectForKey:@"DepartTime"] formatter:@"HH:mm"] ;
            NSString *departAirport = [flight safeObjectForKey:@"DepartAirport"];
            NSString *departTerminal = [flight safeObjectForKey:@"Terminal"];
            NSString *arriveAirport = [flight safeObjectForKey:@"ArriveAirport"];
            NSDictionary *ticketDict = [tickets safeObjectAtIndex:i];
            NSString *ticketState = [ticketDict safeObjectForKey:@"TicketStateName"];
            //特价标识 用不到
//            NSString *discountName = nil;
//            double dd = [[flightS safeObjectForKey:@"Discount"] doubleValue];
//            if (dd == 1) {
//                discountName = @"全价";
//            } else if (dd == 0) {
//                discountName = @"特价";
//            } else {
//                dd *= 10;
//                discountName = [NSString stringWithFormat:@"%.1f折",dd];
//            }
        
            FlightOrderHistoryDetailFlightInfoViewController *flightInfo = [[FlightOrderHistoryDetailFlightInfoViewController alloc] initWithNibName:@"FlightOrderHistoryDetailFlightInfoViewController" bundle:nil];
            flightInfo.view.tag = FlightInfoTag+j;
            flightInfo.delegate = self;
            [flightInfo.view addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 25, 320, SCREEN_SCALE)]];
            [flightInfo.view addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 150-SCREEN_SCALE, 320, SCREEN_SCALE)]];
            flightInfo.view.frame = CGRectMake(0, offY, SCREEN_WIDTH, 150);
            [rootScrollView addSubview:flightInfo.view];
            flightInfo.view.clipsToBounds = YES;
            
            flightInfo.stoplabel.hidden = YES;      //经停显示，暂时隐藏，未有经停航班
            
            //去返程显示
            if(pnrs.count>1 && tmpFlight1.count>1){
                flightInfo.goOrBackBg.hidden =  NO;
                flightInfo.goOrBackTypeLabel.hidden = NO;
                flightInfo.airlinesLabel.frame = CGRectMake(40, 0, 270, 25);
                if(j==0){
                    //去程
                    flightInfo.goOrBackTypeLabel.text= @"去程";
                }else{
                    //返程
                    flightInfo.goOrBackTypeLabel.text= @"返程";
                }
            }else{
                flightInfo.goOrBackBg.hidden =  YES;
                flightInfo.goOrBackTypeLabel.hidden = YES;
                flightInfo.airlinesLabel.frame = CGRectMake(10, 0, 300, 25);
            }
            //航空公司航班号
            flightInfo.airlinesLabel.text = [NSString stringWithFormat:@"%@    %@%@",departDay,airCorpName,flightNumber];
            flightInfo.ticketStateLabel.text = ticketState; //机票状态
            if([@"出票成功" isEqualToString:ticketState]){
                flightInfo.ticketStateLabel.textColor = RGBACOLOR(20, 157, 52, 1);
            }else{
                flightInfo.ticketStateLabel.textColor = [UIColor blackColor];
            }
            flightInfo.arrivalTimeLabel.text = arriveTime;  //到达时间
            flightInfo.departTimeLabel.text = departTime;   //出发时间
            flightInfo.arriveStationLabel.text = arriveAirport; //到达机场
            flightInfo.departStationLabel.text = [NSString stringWithFormat:@"%@%@",departAirport,departTerminal]; //出发机场
            flightInfo.capinLabel.text = classTypename;
            
            offY+=150*(i+1);
        }
    }
}

-(void)addPassengerView{
    NSArray *pnrs = [sourceDic safeObjectForKey:@"PNRs"];
    
    NSMutableArray *newPassengers = [NSMutableArray arrayWithCapacity:1];
    for (int j=0;j<pnrs.count;j++) {
        NSDictionary *pnr = [pnrs objectAtIndex:j];
        NSArray *passengers = [pnr objectForKey:@"Passengers"];
        

//        if(j==0){
            for(int i=0; i <passengers.count;i++){
                NSDictionary *passenger = [passengers objectAtIndex:i];
                
                NSString *name = [passenger objectForKey:@"Name"];
                int type = [[passenger objectForKey:@"CertificateType"] intValue];
                NSString *number = [passenger objectForKey:@"CertificateNumber"];
                
                NSString *certificateType= [Utils getCertificateName:type];
                NSString *decryptStr = [StringEncryption DecryptString:number];
                
                BOOL haveInsurance = NO;
               NSDictionary *insuranceInfo = [sourceDic safeObjectForKey:@"InsuranceInfo"];
                NSArray *details = [insuranceInfo safeObjectForKey:@"InsuranceDetail"];
                for(NSDictionary *insuranceDetail in details){
                    NSString *travelerName = [insuranceDetail safeObjectForKey:@"TravelerName"];
                    int insuranceCount = [[insuranceDetail safeObjectForKey:@"InsuranceCount"] intValue];
                    if([name isEqualToString:travelerName] && insuranceCount>0){
                        haveInsurance = YES;
                        break;
                    }
                }
                //身份证隐藏，后4位
                if (type==0 && [decryptStr length] > 4)
                {
                    decryptStr = [decryptStr stringByReplaceWithAsteriskFromIndex:[decryptStr length]-4];
                }
                NSDictionary *newPassenger = [NSDictionary dictionaryWithObjectsAndKeys:name,@"Name",[NSString stringWithFormat:@"%@ / %@",certificateType,decryptStr],@"CertificateInfo", [NSNumber numberWithBool:haveInsurance],@"HaveInsurance",nil];
                if(![newPassengers containsObject:newPassenger]){
                    [newPassengers addObject:newPassenger];
                }
            }
        }

//    }
    
    if (!detailPassengerViewCtrl) {
        detailPassengerViewCtrl = [[FlightOrderHistroyDetailPassnerInfoViewController alloc] init];
        detailPassengerViewCtrl.view.frame = CGRectMake(0, offY, SCREEN_WIDTH, 40+newPassengers.count*44);
        [rootScrollView addSubview:detailPassengerViewCtrl.view];
        [detailPassengerViewCtrl fillPassengerInfoViewByPassengers:newPassengers];
    }
    
    offY+=40+newPassengers.count*44;
}

-(void)addListFooterView{
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
//	[orderStatusImageView release];
    [sourceDic release];
	[passArray release];
    
    [topView release];
    [ticketPriceLabel release];
    [ticketTaxLabel release];
    [postAddressLabel release];
    [postAddressNoteLabel release];
    [detailPassengerViewCtrl  release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[super dealloc];
}   

- (void) addScheduleToCalendar:(id) sender{
	flightIndex = 0;
	[self performSelector:@selector(addSchedule)];
}

- (void) addSchedule{
	
//	//设置EventStore和Event
//	EKEventStore *eventStore = [[EKEventStore alloc] init];
//	[eventStore autorelease];
    
    if (IOSVersion_6) {
        __block FlightOrderHistoryDetail *controller = self;
    
        if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusNotDetermined){
            EKEventStore *eventStore = [[EKEventStore alloc] init];

            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                
                if (granted)
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
                        appDelegate.navDrawEnabled = YES;
                        
                        NSArray *PNRs = [sourceDic safeObjectForKey:@"PNRs"];
                        
                        if ([PNRs count] <= flightIndex) {
                            return;
                        }
                        NSDictionary *flight = [[[PNRs safeObjectAtIndex:flightIndex] safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
                        
                        EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
                        
                        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                        if (event) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                event.title     = [NSString stringWithFormat:@"%@ %@(%@)",
                                                   [flight safeObjectForKey:@"AirCorpName"],
                                                   [flight safeObjectForKey:@"FlightNumber"],
                                                   [Utils getClassTypeName:[[flight safeObjectForKey:@"ClassType"] intValue]]];
                                event.location  = [NSString stringWithFormat:@"%@->%@",[flight safeObjectForKey:@"DepartAirport"],[flight safeObjectForKey:@"ArriveAirport"]];
                                
                                NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
                                
                                EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:-14400];
                                [alarmsArray addObject:alarm1];
                                
                                event.alarms = alarmsArray;
                                
                                event.startDate = [TimeUtils parseJsonDate:[flight safeObjectForKey:@"DepartTime"]];
                                event.endDate   = [TimeUtils parseJsonDate:[flight safeObjectForKey:@"ArrivalTime"]];
                                event.notes     = [NSString stringWithFormat:@"航空公司：%@\n机       型：%@\n起飞时间：%@\n到达时间：%@\n起飞机场：%@\n到达机场：%@\n机       型：%@\n登       机：%@\n\n退票规定：\n%@\n改签规定：\n%@",
                                                   [flight safeObjectForKey:@"AirCorpName"],
                                                   [flight safeObjectForKey:@"FlightNumber"],
                                                   [TimeUtils displayDateWithJsonDate:[flight safeObjectForKey:@"DepartTime"] formatter:@"MM月dd日 HH:mm"],
                                                   [TimeUtils displayDateWithJsonDate:[flight safeObjectForKey:@"ArrivalTime"] formatter:@"MM月dd日 HH:mm"],
                                                   [flight safeObjectForKey:@"DepartAirport"],
                                                   [flight safeObjectForKey:@"ArriveAirport"],
                                                   [flight safeObjectForKey:@"PlaneType"],
                                                   [flight safeObjectForKey:@"Terminal"],
                                                   [flight safeObjectForKey:@"ReturnRegulate"],
                                                   [flight safeObjectForKey:@"ChangeRegulate"]];
                                
                                addController.eventStore = eventStore;
                                addController.event = event;
                                [eventStore release];
                                [alarmsArray release];
                                addController.editViewDelegate = self;
                                //addController.modalPresentationStyle = UIModalPresentationFormSheet;
                                
                                if (IOSVersion_7) {
                                    addController.transitioningDelegate = [ModalAnimationContainer shared];
                                    addController.modalPresentationStyle = UIModalPresentationCustom;
                                }
                                if (IOSVersion_7) {
                                    [self presentViewController:addController animated:YES completion:nil];
                                }else{
                                    [self presentModalViewController:addController animated:YES];
                                }
                                
                                [addController release];

                            });
                        }
                        else
                        {
                            [addController release];
                        }
                    });

                
                }
                else if (error)
                {
                    self.view.userInteractionEnabled = YES;
                }
                else
                {
                    self.view.userInteractionEnabled = YES;
                }

            }];
            
        }
        else if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusAuthorized){
            EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];

            [controller createEvent:eventStore];
        }
        else if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent] == EKAuthorizationStatusDenied){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未开启日历权限"
                                                            message:@"请在设置中开启"
                                                           delegate:self
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
        }
    }
	else{
        EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];

        [self createEvent:eventStore];
//        [eventStore release];
    }
    
}

#pragma mark - BaseBottomBar Delegate
-(void)selectedBottomBar:(BaseBottomBar *)bar ItemAtIndex:(NSInteger)index{
    if([orderStatus isEqualToString:@"已出票"] || [orderStatus isEqualToString:@"已支付"]){
        if(index==0){
            //添加到日历
            [self addScheduleToCalendar:nil];
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

#pragma mark - FlightOrderHistoryDetailFlightInfoDelegate
-(void)reviewRule:(int)tag{
    NSArray *pnrs = [sourceDic safeObjectForKey:@"PNRs"];
    for (int j=0;j<pnrs.count;j++) {
        NSDictionary *pnr = [pnrs objectAtIndex:j];
        NSArray *flights  = [pnr objectForKey:@"Flights"];
        for(int i=0; i<flights.count;i++){
            NSDictionary *flight = [flights objectAtIndex:i];
            
            if(j==tag-FlightInfoTag){
                NSString *returnRegulate = [flight safeObjectForKey:@"ReturnRegulate"];
                NSString *changeRegulate = [flight safeObjectForKey:@"ChangeRegulate"];
                
                if(returnRegulate.length==0){
                    returnRegulate = @"无信息";
                }
                if(changeRegulate.length==0){
                    changeRegulate = @"无信息";
                }
                
//                FlightOrderHistoryDetailRestrictionViewController *restrictionInfo =[[FlightOrderHistoryDetailRestrictionViewController alloc]init];
//                [restrictionInfo fillContentWithReturnContent:returnRegulate andChangeContent:changeRegulate];
//                [self.navigationController pushViewController:restrictionInfo animated:YES];
//                [restrictionInfo release];
            }
        }
    }
}

#pragma mark -
#pragma mark UIAlertView delegate

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


- (void) createEvent:(EKEventStore *)eventStore{
//    [eventStore retain];
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.navDrawEnabled = YES;
	
	NSArray *PNRs = [sourceDic safeObjectForKey:@"PNRs"];
	
	if ([PNRs count] <= flightIndex) {
		return;
	}
	NSDictionary *flight = [[[PNRs safeObjectAtIndex:flightIndex] safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
    
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    
	event.title     = [NSString stringWithFormat:@"%@ %@(%@)",
					   [flight safeObjectForKey:@"AirCorpName"],
					   [flight safeObjectForKey:@"FlightNumber"],
					   [Utils getClassTypeName:[[flight safeObjectForKey:@"ClassType"] intValue]]];
	event.location  = [NSString stringWithFormat:@"%@->%@",[flight safeObjectForKey:@"DepartAirport"],[flight safeObjectForKey:@"ArriveAirport"]];
	
	NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
	
	//EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:-86400]; // one day
	//EKAlarm *alarm2 = [EKAlarm alarmWithRelativeOffset:-7200]; // two hours
	EKAlarm *alarm1 = [EKAlarm alarmWithRelativeOffset:-14400];
	[alarmsArray addObject:alarm1];
	//[alarmsArray addObject:alarm2];
	
	event.alarms = alarmsArray;
	
	event.startDate = [TimeUtils parseJsonDate:[flight safeObjectForKey:@"DepartTime"]];
	event.endDate   = [TimeUtils parseJsonDate:[flight safeObjectForKey:@"ArrivalTime"]];
	event.notes     = [NSString stringWithFormat:@"航空公司：%@\n机       型：%@\n起飞时间：%@\n到达时间：%@\n起飞机场：%@\n到达机场：%@\n机       型：%@\n登       机：%@\n\n退票规定：\n%@\n改签规定：\n%@",
					   [flight safeObjectForKey:@"AirCorpName"],
					   [flight safeObjectForKey:@"FlightNumber"],
					   [TimeUtils displayDateWithJsonDate:[flight safeObjectForKey:@"DepartTime"] formatter:@"MM月dd日 HH:mm"],
					   [TimeUtils displayDateWithJsonDate:[flight safeObjectForKey:@"ArrivalTime"] formatter:@"MM月dd日 HH:mm"],
					   [flight safeObjectForKey:@"DepartAirport"],
					   [flight safeObjectForKey:@"ArriveAirport"],
					   [flight safeObjectForKey:@"PlaneType"],
					   [flight safeObjectForKey:@"Terminal"],
					   [flight safeObjectForKey:@"ReturnRegulate"],
					   [flight safeObjectForKey:@"ChangeRegulate"]];
	
	addController.eventStore = eventStore;
	addController.event = event;
//	[eventStore release];
	[alarmsArray release];
	addController.editViewDelegate = self;
	//addController.modalPresentationStyle = UIModalPresentationFormSheet;
	
    if (IOSVersion_7) {
        addController.transitioningDelegate = [ModalAnimationContainer shared];
        addController.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:addController animated:YES completion:nil];
    }else{
        [self presentModalViewController:addController animated:YES];
	}
	[addController release];
}

-(void) paySuccess{
	orderStatus = @"已支付";
    [self addListFooterView];
	
	if([delegate respondsToSelector:@selector(paySuccess)]){
		[delegate paySuccess];
	}
}

-(void)againPayByalipay{    
	[FlightOrderSuccess setInstance:nil];
	[FlightOrderHistoryDetail setInstance:nil];
	
	netType = @"isAllowPay";
	JGetFlightOrder *jgfol=[OrderHistoryPostManager getFlightOrder];
	[jgfol clearBuildData];
	[jgfol setOrderNo:[sourceDic safeObjectForKey:@"OrderNo"] ];
	//	[jgfol setOrderNo:[NSNumber numberWithInt:33857784]];
	
	[Utils request:MYELONG_SEARCH req:[jgfol requesString:YES] delegate:self];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag==AlipayActionSheetTag){
        if (buttonIndex == 0){
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
                //客户端存在，打开客户端
                //开始支付
                netType = @"pay";
                payType = @"Client";
                NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
                [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
                [mutDict safeSetObject:[sourceDic safeObjectForKey:@"OrderNo"] forKey:@"OrderId"];
                [mutDict safeSetObject:[sourceDic safeObjectForKey:@"OrderCode"] forKey:@"OrderCode"];
                [mutDict safeSetObject:[sourceDic safeObjectForKey:@"PayFee"] forKey:@"TotalPrice"];
                [mutDict safeSetObject:@"elongIPhone://" forKey:@"ReturnUrl"];
                [mutDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"PayMethod"];
                NSString *guid = [NSString stringWithFormat:@"zsafe-%@",[sourceDic safeObjectForKey:@"OrderNo"]];
                [mutDict safeSetObject:guid forKey:@"Guid"];
                
                NSString *reqParam = [NSString stringWithFormat:@"action=GetAlipayBefundInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
                [Utils orderRequest:FLIGHT_SERACH req:reqParam delegate:self];
                [mutDict release];
            }else{
                [PublicMethods showAlertTitle:nil Message:@"未发现支付宝客户端，请您更换别的支付方式或下载支付宝"];
                return;
            }
        }else if(buttonIndex == 1){
            // 支付宝
            netType = @"pay";
            payType = @"wap";
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
            [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
            [mutDict safeSetObject:[sourceDic safeObjectForKey:@"OrderNo"] forKey:@"OrderId"];
            [mutDict safeSetObject:[sourceDic safeObjectForKey:@"OrderCode"] forKey:@"OrderCode"];
            [mutDict safeSetObject:[sourceDic safeObjectForKey:@"PayFee"] forKey:@"TotalPrice"];
            [mutDict safeSetObject:@"elongIPhone://wappay/" forKey:@"ReturnUrl"];
            [mutDict safeSetObject:[NSNumber numberWithInt:2] forKey:@"PayMethod"];
            NSString *guid = [NSString stringWithFormat:@"zwap-%@",[sourceDic safeObjectForKey:@"OrderNo"]];
            [mutDict safeSetObject:guid forKey:@"Guid"];
            
            NSString *reqParam = [NSString stringWithFormat:@"action=GetAlipayBefundInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",@"true"],[mutDict JSONRepresentationWithURLEncoding]];
            [Utils orderRequest:FLIGHT_SERACH req:reqParam delegate:self];
            [mutDict release];
        }
    }
    
}

#pragma mark -
#pragma mark Http

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSDictionary *root = [PublicMethods unCompressData:responseData];
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    CFShow(root);
	if([netType isEqualToString:@"isAllowPay"]){
		//做了一下改动
		if([[[root safeObjectForKey:@"Order"] safeObjectForKey:@"IsAllowContinuePay"] boolValue]){
            flightOrderDetail = self;   //将当前VC赋值给变量，以供回调使用
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

-(void) shareOrderInfo{
	ShareTools *shareTools = [ShareTools shared];
	shareTools.contentViewController = self;
	shareTools.contentView = nil;
	shareTools.hotelImage = nil;
	shareTools.imageUrl = nil;
	shareTools.mailView = nil;
    shareTools.needLoading = NO;
	shareTools.mailImage = [self screenshotOnCurrentView];
    [self captureCurrentView];
	
	
	shareTools.weiBoContent = [self weiboContent];	
	shareTools.msgContent = [self smsContent];
	shareTools.mailTitle = @"使用艺龙旅行客户端预订机票成功！";
	shareTools.mailContent = [self mailContent];
	
	[shareTools  showItems];	
}

-(UIImage *) screenshotOnCurrentView{
	return  [self performSelector:@selector(captureView)];
}
-(NSString *) smsContent{
	NSString *message  = nil;
	if([[sourceDic safeObjectForKey:@"PNRs"] count] == 1){
		//单程
		NSDictionary *pnrDict = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:0];
		NSDictionary *flightDict = [[pnrDict safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
//		NSDictionary *ticketsDict = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:0];
		NSString *orderNo = [sourceDic safeObjectForKey:@"OrderNo"];
		NSString *airCorpName = [flightDict safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber = [flightDict safeObjectForKey:@"FlightNumber"];
		NSString *departAirPort = [flightDict safeObjectForKey:@"DepartAirport"];
		NSString *arriveAirport = [flightDict safeObjectForKey:@"ArriveAirport"];
		NSString *departTime_str = [TimeUtils displayDateWithJsonDate:[flightDict safeObjectForKey:@"DepartTime"] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str = [TimeUtils displayDateWithJsonDate:[flightDict safeObjectForKey:@"ArrivalTime"] formatter:@"MM月dd日 HH:mm"];

		message = [NSString stringWithFormat:@"我用艺龙旅行客户端成功预订了一张%@至%@的机票，订单号：%@，%@ %@，起飞时间：%@，降落时间：%@。",departAirPort,arriveAirport,
				   orderNo,airCorpName,flightNumber,departTime_str,arriveTime_str];
		
	}else {
		//往返
		NSDictionary *pnrDict_1 = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:0];
		NSDictionary *pnrDict_2 = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:1];
		NSDictionary *flightDict_1 = [[pnrDict_1 safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
//		NSDictionary *ticketsDict_1 = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:0];
		NSDictionary *flightDict_2 = [[pnrDict_2 safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
//		NSDictionary *ticketsDict_2 = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:1];
		NSString *orderNo = [sourceDic safeObjectForKey:@"OrderNo"];
		NSString *airCorpName_1 = [flightDict_1 safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber_1 = [flightDict_1 safeObjectForKey:@"FlightNumber"];
		NSString *departAirPort_1 = [flightDict_1 safeObjectForKey:@"DepartAirport"];
		NSString *arriveAirport_1 = [flightDict_1 safeObjectForKey:@"ArriveAirport"];
		
		NSString *airCorpName_2 = [flightDict_2 safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber_2 = [flightDict_2 safeObjectForKey:@"FlightNumber"];
		NSString *departTime_str_1 = [TimeUtils displayDateWithJsonDate:[flightDict_1 safeObjectForKey:@"DepartTime"] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str_1 = [TimeUtils displayDateWithJsonDate:[flightDict_1 safeObjectForKey:@"ArrivalTime"] formatter:@"MM月dd日 HH:mm"];
		NSString *departTime_str_2 = [TimeUtils displayDateWithJsonDate:[flightDict_2 safeObjectForKey:@"DepartTime"] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str_2 = [TimeUtils displayDateWithJsonDate:[flightDict_2 safeObjectForKey:@"ArrivalTime"] formatter:@"MM月dd日 HH:mm"];

		message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了%@至%@的往返机票，订单号：%@，去程：%@ %@，起飞时间：%@，降落时间：%@， 返程：%@ %@，起飞时间：%@，降落时间：%@。",departAirPort_1,arriveAirport_1,
				   orderNo,airCorpName_1,flightNumber_1,departTime_str_1,arriveTime_str_1,airCorpName_2,flightNumber_2,departTime_str_2,arriveTime_str_2];
		
	}
	
	NSString *messageBody = [NSString stringWithFormat:@"%@客服电话：400-666-1166",message];
	return messageBody;
}

-(NSString *) mailContent{
	NSString *message  = nil;
	if([[sourceDic safeObjectForKey:@"PNRs"] count] == 1){
		//单程
		NSDictionary *pnrDict = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:0];
		NSDictionary *flightDict = [[pnrDict safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
		//		NSDictionary *ticketsDict = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:0];
		NSString *orderNo = [sourceDic safeObjectForKey:@"OrderNo"];
		NSString *airCorpName = [flightDict safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber = [flightDict safeObjectForKey:@"FlightNumber"];
		NSString *departAirPort = [flightDict safeObjectForKey:@"DepartAirport"];
		NSString *arriveAirport = [flightDict safeObjectForKey:@"ArriveAirport"];
		NSString *departTime_str = [TimeUtils displayDateWithJsonDate:[flightDict safeObjectForKey:@"DepartTime"] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str = [TimeUtils displayDateWithJsonDate:[flightDict safeObjectForKey:@"ArrivalTime"] formatter:@"MM月dd日 HH:mm"];
		
		message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了一张%@至%@的机票，既便捷又超值。订单号：%@，%@ %@，起飞时间：%@，降落时间：%@。",departAirPort,arriveAirport,
				   orderNo,airCorpName,flightNumber,departTime_str,arriveTime_str];
		
	}else {
		//往返
		NSDictionary *pnrDict_1 = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:0];
		NSDictionary *pnrDict_2 = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:1];
		NSDictionary *flightDict_1 = [[pnrDict_1 safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
		//		NSDictionary *ticketsDict_1 = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:0];
		NSDictionary *flightDict_2 = [[pnrDict_2 safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
		//		NSDictionary *ticketsDict_2 = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:1];
		NSString *orderNo = [sourceDic safeObjectForKey:@"OrderNo"];
		NSString *airCorpName_1 = [flightDict_1 safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber_1 = [flightDict_1 safeObjectForKey:@"FlightNumber"];
		NSString *departAirPort_1 = [flightDict_1 safeObjectForKey:@"DepartAirport"];
		NSString *arriveAirport_1 = [flightDict_1 safeObjectForKey:@"ArriveAirport"];
		
		NSString *airCorpName_2 = [flightDict_2 safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber_2 = [flightDict_2 safeObjectForKey:@"FlightNumber"];
		NSString *departTime_str_1 = [TimeUtils displayDateWithJsonDate:[flightDict_1 safeObjectForKey:@"DepartTime"] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str_1 = [TimeUtils displayDateWithJsonDate:[flightDict_1 safeObjectForKey:@"ArrivalTime"] formatter:@"MM月dd日 HH:mm"];
		NSString *departTime_str_2 = [TimeUtils displayDateWithJsonDate:[flightDict_2 safeObjectForKey:@"DepartTime"] formatter:@"MM月dd日 HH:mm"];
		NSString *arriveTime_str_2 = [TimeUtils displayDateWithJsonDate:[flightDict_2 safeObjectForKey:@"ArrivalTime"] formatter:@"MM月dd日 HH:mm"];
		
		message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了一张%@至%@的往返机票，既便捷又超值。订单号：%@，去程：%@ %@，起飞时间：%@，降落时间：%@， 返程：%@ %@，起飞时间：%@，降落时间：%@。",departAirPort_1,arriveAirport_1,
				   orderNo,airCorpName_1,flightNumber_1,departTime_str_1,arriveTime_str_1,airCorpName_2,flightNumber_2,departTime_str_2,arriveTime_str_2];
		
	}
	
	NSString *messageBody = [NSString stringWithFormat:@"%@\n客服电话：400-666-1166\n订单详情见附件图片：",message];

	return messageBody;
}

-(NSString *) weiboContent{
	NSString *message  = nil;
	if([[sourceDic safeObjectForKey:@"PNRs"] count] == 1){
		//单程
		NSDictionary *pnrDict = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:0];
		NSDictionary *flightDict = [[pnrDict safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
		NSDictionary *ticketsDict = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:0];
		NSString *airCorpName = [flightDict safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber = [flightDict safeObjectForKey:@"FlightNumber"];
		NSString *departAirPort = [flightDict safeObjectForKey:@"DepartAirport"];
		NSString *arriveAirport = [flightDict safeObjectForKey:@"ArriveAirport"];
		NSString *price_str = [ticketsDict safeObjectForKey:@"TicketPay"];
		message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了一张%@至%@的机票，%@ %@,艺龙价仅售￥%@。",departAirPort,arriveAirport,airCorpName,flightNumber,price_str];
		
	}else {
		//往返
		NSDictionary *pnrDict_1 = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:0];
		NSDictionary *pnrDict_2 = [[sourceDic safeObjectForKey:@"PNRs"] safeObjectAtIndex:1];
		NSDictionary *flightDict_1 = [[pnrDict_1 safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
		NSDictionary *ticketsDict_1 = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:0];
		NSDictionary *flightDict_2 = [[pnrDict_2 safeObjectForKey:@"Flights"] safeObjectAtIndex:0];
		NSDictionary *ticketsDict_2 = [[sourceDic safeObjectForKey:@"Tickets"] safeObjectAtIndex:1];
		NSString *airCorpName_1 = [flightDict_1 safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber_1 = [flightDict_1 safeObjectForKey:@"FlightNumber"];
		NSString *departAirPort_1 = [flightDict_1 safeObjectForKey:@"DepartAirport"];
		NSString *arriveAirport_1 = [flightDict_1 safeObjectForKey:@"ArriveAirport"];
		NSString *price_str_1 = [ticketsDict_1 safeObjectForKey:@"TicketPay"];
		
		NSString *airCorpName_2 = [flightDict_2 safeObjectForKey:@"AirCorpName"];
		NSString *flightNumber_2 = [flightDict_2 safeObjectForKey:@"FlightNumber"];
		NSString *price_str_2 = [ticketsDict_2 safeObjectForKey:@"TicketPay"];
		message = [NSString stringWithFormat:@"我用艺龙无线客户端成功预订了一张%@至%@的往返机票，去程：%@ %@,艺龙价仅售￥%@  返程：%@ %@,艺龙价仅售￥%@。",departAirPort_1,arriveAirport_1,
				   airCorpName_1,flightNumber_1,price_str_1,airCorpName_2,flightNumber_2,price_str_2];
		
	}
	NSString *content  = [NSString stringWithFormat:@"%@客服电话：400-666-1166（分享自 @艺龙无线）",message];
	return content;
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
	NSArray *PNRs = [sourceDic safeObjectForKey:@"PNRs"];
	if ([PNRs count]==1) {
        if (IOSVersion_7) {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }else{
            [controller dismissModalViewControllerAnimated:YES];
        }
	}else {
		if (EKEventEditViewActionSaved == action) {
            if (IOSVersion_7) {
                [controller dismissViewControllerAnimated:YES completion:nil];
            }else{
                [controller dismissModalViewControllerAnimated:YES];
            }
		}else {
            if (IOSVersion_7) {
                [controller dismissViewControllerAnimated:YES completion:nil];
            }else{
                [controller dismissModalViewControllerAnimated:YES];
            }
		}
	}
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.navDrawEnabled = NO;
	
//	if (EKEventEditViewActionSaved == action) {
//		flightIndex++;
//		[self performSelector:@selector(addSchedule)];
//	}
}

-(void)oneFingerTaps
{
    [photoview removeFromSuperview];
}

-(UIImage *)captureView
{
    CGSize size = rootScrollView.contentSize;
    if (size.height < SCREEN_HEIGHT) {
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
    rootScrollView.layer.masksToBounds=NO;
	[rootScrollView.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return newImage;
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
    rootScrollView.layer.masksToBounds=YES;
	[self.view.layer renderInContext:ctx];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return newImage;
}
- (void)donothing{}

- (void) takeSnapshot
{
    self.view.userInteractionEnabled = NO;
    //存到相册里的图片
    captureimage = [[self captureView] retain];
    //用来做动画的图片
    UIImage *pImageone = [self captureCurrentView] ;
    m_imgview = [[UIImageView alloc] initWithImage:pImageone];
    m_imgview.frame = rootScrollView.frame;
    [rootScrollView addSubview:m_imgview];
    [m_imgview release];
    [self moveview];
}
- (void)moveview {
    [m_imgview.layer removeAnimationForKey:@"marioJump"];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.5f;
    scaleAnimation.toValue = [NSNumber numberWithFloat:.001];
    
    CABasicAnimation *slideDownx = [CABasicAnimation animationWithKeyPath:@"position.x"];
    slideDownx.toValue = [NSNumber numberWithFloat: 280];
    slideDownx.duration = 0.5f;
    slideDownx.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  
    
    CABasicAnimation *slideDowny = [CABasicAnimation animationWithKeyPath:@"position.y"];
    slideDowny.toValue = [NSNumber numberWithFloat: MAINCONTENTHEIGHT-30 + rootScrollView.contentOffset.y];
    slideDowny.duration = 0.5f;
    slideDowny.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithObjects:scaleAnimation, slideDownx,slideDowny, nil];
    group.duration = 0.5f;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.autoreverses = NO;
    group.delegate = self;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    
    [m_imgview.layer addAnimation:group forKey:@"marioJump"];
}

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
        title = NSLocalizedString(@"保存失败", @"");  
        message = @"为允许访问相册，请在设置中打开！"; 
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

@end
