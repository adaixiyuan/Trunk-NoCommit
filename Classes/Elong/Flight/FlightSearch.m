//
//  FlightSearch.m
//  ElongClient
//
//  Created by dengfang on 11-1-12.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightSearch.h"
#import "FlightList.h"
#import "Utils.h"
#import "FlightDataDefine.h"
#import "SelectCity.h"
#import "SettingManager.h"
#import <QuartzCore/QuartzCore.h>
#import "CalendarHelper.h"

//#import "FlightOrderSuccess.h"

@interface FlightSearch ()

@property (nonatomic, copy) NSString *begincity;
@property (nonatomic, copy) NSString *endcity;
@property (nonatomic, copy) NSString *departcitystring;
@property (nonatomic, copy) NSString *arrivalcitystriing;
@property (nonatomic, copy) NSString *classlabelstring;
@property (nonatomic, retain) NSDate *departdate;
@property (nonatomic, retain) NSDate *arrivaldata;

@end


@implementation FlightSearch

@synthesize begincity;
@synthesize endcity;
@synthesize classLabel;
@synthesize m_iClassType;
@synthesize m_iFlightSearchFrom;
@synthesize departCityLabel;
@synthesize arrivalCityLabel;
@synthesize departcitystring;
@synthesize arrivalcitystriing;
@synthesize classlabelstring;
@synthesize departdate;
@synthesize arrivaldata;

#pragma mark -
typedef enum {
	TripTypeSingle = 0,
	TripTypeRound = 1
} TripType;

#pragma mark -
#pragma mark private
- (void)showBackDateView:(BOOL)isShow {
	//有返回日期
	if (isShow) {
		[backTimeView setHidden:NO];
		dapartDateTitle.frame = CGRectMake(76, 8, 58, 27);
		[departView setFrame:CGRectMake(departView.frame.origin.x, departView.frame.origin.y,
                                        179, departView.frame.size.height)];
		[rightArrow setFrame:CGRectMake(158, rightArrow.frame.origin.y,
										rightArrow.frame.size.width, rightArrow.frame.size.height)];
		[departDateDayLabel setFrame:CGRectMake(68 + 9, departDateDayLabel.frame.origin.y,
												departDateDayLabel.frame.size.width, departDateDayLabel.frame.size.height)];
		[departDateMonLabel setFrame:CGRectMake(121 + 9, departDateMonLabel.frame.origin.y,
												departDateMonLabel.frame.size.width, departDateMonLabel.frame.size.height)];
		[departDateWeekLabel setFrame:CGRectMake(121 + 9, departDateWeekLabel.frame.origin.y,
                                                 departDateWeekLabel.frame.size.width, departDateWeekLabel.frame.size.height)];
		[departDateButton setFrame:CGRectMake(0, departDateButton.frame.origin.y,
                                              180, departDateButton.frame.size.height)];
        //		[classView setFrame:CGRectMake(classView.frame.origin.x, 261,
        //									   classView.frame.size.width, classView.frame.size.height)];
        //		[searchButton setFrame:CGRectMake(searchButton.frame.origin.x, 314,
		//
		//searchButton.frame.size.width, searchButton.frame.size.height)];
	} else //无返回日期
	{
		[backTimeView setHidden:YES];
		dapartDateTitle.frame = CGRectMake(130, 8, 58, 27);
		[departView setFrame:CGRectMake(departView.frame.origin.x, departView.frame.origin.y,
										320, departView.frame.size.height)];
		[rightArrow setFrame:CGRectMake(300, rightArrow.frame.origin.y,
										rightArrow.frame.size.width, rightArrow.frame.size.height)];
		[departDateDayLabel setFrame:CGRectMake(131, departDateDayLabel.frame.origin.y,
												departDateDayLabel.frame.size.width, departDateDayLabel.frame.size.height)];
		[departDateMonLabel setFrame:CGRectMake(184, departDateMonLabel.frame.origin.y,
												departDateMonLabel.frame.size.width, departDateMonLabel.frame.size.height)];
		[departDateWeekLabel setFrame:CGRectMake(184, departDateWeekLabel.frame.origin.y,
                                                 departDateWeekLabel.frame.size.width, departDateWeekLabel.frame.size.height)];
        
		[departDateButton setFrame:CGRectMake(0,  departDateButton.frame.origin.y,
                                              320, departDateButton.frame.size.height)];
		//[departView setFrame:CGRectMake(departView.frame.origin.x, departView.frame.origin.y,
        //												 departView.frame.size.width, 45)];
        //		[classView setFrame:CGRectMake(classView.frame.origin.x, 261 -45,
        //									   classView.frame.size.width, classView.frame.size.height)];
        //		[searchButton setFrame:CGRectMake(searchButton.frame.origin.x, 314 -45,
        //										  searchButton.frame.size.width, searchButton.frame.size.height)];
	}
}


//1time >= 2time two hours
- (BOOL)isFirstTimeMoreThan2Hours:(NSDate *)firstTime secondTime:(NSDate *)secondTime {
	double fTime = [firstTime timeIntervalSince1970];
	double sTime = [secondTime timeIntervalSince1970];
	if ((fTime -sTime) /60 >= 2*60) {
		return YES;
	}
	return NO;
}

- (NSString *)getDetailDayNotice:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    NSArray *currentDateArray = [currentDate componentsSeparatedByString:@"-"];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"-"];
    
    if ([[currentDateArray safeObjectAtIndex:0] integerValue] == [[dateArray safeObjectAtIndex:0] integerValue] &&
        [[currentDateArray safeObjectAtIndex:1] integerValue] == [[dateArray safeObjectAtIndex:1] integerValue] &&
        [[dateArray safeObjectAtIndex:2] integerValue] - [[currentDateArray safeObjectAtIndex:2] integerValue] == 1) {
        return @"明天";
    }
    else if ([[currentDateArray safeObjectAtIndex:0] integerValue] == [[dateArray safeObjectAtIndex:0] integerValue] &&
             [[currentDateArray safeObjectAtIndex:1] integerValue] == [[dateArray safeObjectAtIndex:1] integerValue] &&
             [[dateArray safeObjectAtIndex:2] integerValue] - [[currentDateArray safeObjectAtIndex:2] integerValue] == 2) {
        return @"后天";
    }
    else if ([[dateArray safeObjectAtIndex:0] integerValue] - [[currentDateArray safeObjectAtIndex:0] integerValue]  == 1 && [[dateArray safeObjectAtIndex:1] integerValue] == 1 && [[dateArray safeObjectAtIndex:2] integerValue] == 1) {
        return @"后天";
    }
    
    return @"";
}

- (void)addLineToView
{
    UIView *topLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMinY(cityView.frame), 320.0f, SCREEN_SCALE)];
    topLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    [self.view addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, CGRectGetMinY(cityView.frame), 320.0f, SCREEN_SCALE)]];
    [topLineView release];
    
    UIView *firstLineView = [[UIImageView alloc] initWithFrame:CGRectMake(66.0f, ceil(CGRectGetMinY(cityView.frame) + CGRectGetHeight(cityView.frame))- 1 - SCREEN_SCALE, 320.0f, SCREEN_SCALE)];
    firstLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    [self.view addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(66.0f, ceil(CGRectGetMinY(cityView.frame) + CGRectGetHeight(cityView.frame))- 1 - SCREEN_SCALE, 320.0f, SCREEN_SCALE)]];
    [firstLineView release];
    
    UIView *secondLineView = [[UIImageView alloc] initWithFrame:CGRectMake(66.0f, ceil(CGRectGetMinY(departView.frame) + CGRectGetHeight(departView.frame)) - SCREEN_SCALE, 320.0f, SCREEN_SCALE)];
    secondLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    [self.view addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(66.0f, ceil(CGRectGetMinY(departView.frame) + CGRectGetHeight(departView.frame)) - SCREEN_SCALE, 320.0f, SCREEN_SCALE)]];
    [secondLineView release];
    
    UIView *bottomLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, ceil(CGRectGetMinY(classView.frame) + CGRectGetHeight(classView.frame)), 320.0f, SCREEN_SCALE)];
    bottomLineView.backgroundColor = [UIColor colorWithRed:188.0f / 255 green:188.0f / 255 blue:188.0f / 255 alpha:1.0f];
    
    [self.view addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0.0f, ceil(CGRectGetMinY(classView.frame) + CGRectGetHeight(classView.frame)), 320.0f, SCREEN_SCALE)]];
    [bottomLineView release];
}

// 城市交换事件
- (void)exchangeCityPressed:(id)sender
{
    //    CABasicAnimation *fromLeftToRightAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    //    fromLeftToRightAnimation.fromValue = [NSValue valueWithCGPoint:departCityLabel.layer.position];
    //    fromLeftToRightAnimation.toValue = [NSValue valueWithCGPoint:arrivalCityLabel.layer.position];;
    //    fromLeftToRightAnimation.duration = 5.0f;
    //    [departCityButton.layer addAnimation:fromLeftToRightAnimation forKey:nil];
    NSString *cityTmp = departcitystring;
    departcitystring = arrivalcitystriing;
    arrivalcitystriing = cityTmp;
    
    CGRect tempRect = departCityLabel.frame;
    [UIView animateWithDuration:0.5f
                     animations:^(void){
                         departCityLabel.frame = arrivalCityLabel.frame;
                         arrivalCityLabel.frame = tempRect;
                     }
                     completion:^(BOOL finished) {
                         CGRect rect = departCityLabel.frame;
                         departCityLabel.frame = arrivalCityLabel.frame;
                         arrivalCityLabel.frame = rect;
                         
                         NSString *cityTmp = departCityLabel.text;
                         departCityLabel.text = arrivalCityLabel.text;
                         arrivalCityLabel.text = cityTmp;
                     }];
    
    // 交换城市
    //    NSString *cityTmp = departCityLabel.text;
    //    departCityLabel.text = arrivalCityLabel.text;
    //    arrivalCityLabel.text = cityTmp;
    
    UMENG_EVENT(UEvent_Flight_Search_SwitchCity)
}


- (void)notiApplicationDidBecomeActive:(NSNotification *)noti
{
    /*
     * 用户切回前台时，如果是起飞日期小于当前日期的情况，需要更新日期；
     */
    
    NSString *nowDescription = [PublicMethods descriptionFromDate:[NSDate date]];   // 当前日期的描述，只会是“今天”
    NSString *lastDescription = [PublicMethods descriptionFromDate:departdate];  // 上次关闭时的日期描述，有可能是比今天早或者比今天晚
    NSLog(@"%@===%@", [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]], [departdate descriptionWithLocale:[NSLocale currentLocale]]);
    
    if ([nowDescription isEqualToString:lastDescription] )
    {
        // 如果当前的日期和上次关闭时都是今天的情况，不做处理
        return;
    }
    
    // 其它情况都要刷新日期
    if ([departdate earlierDate:[NSDate date]] == departdate)
    {
        [self combinationDepartDateWithDate:[NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]]];
        [self combinationBackDateWithDate:[NSDate dateWithTimeInterval:2*86400 sinceDate:[NSDate date]]];
    }
}

#pragma mark -
#pragma mark Http

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"flightList:%@", root);
    
    if (couponUtil == util) {
        [Utils checkJsonIsErrorNoAlert:root];
        [[Coupon activedcoupons] removeAllObjects];
        
        if ([root safeObjectForKey:@"UsableValue"] != nil)
        {
            [[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
        }
        
        return;
    }
    
	if ([Utils checkJsonIsError:root]) {
		if (m_iFlightSearchFrom == FlightSearchFromList)
        {
			for (UIViewController *controller in self.navigationController.viewControllers)
            {
				if ([controller isKindOfClass:[FlightList class]])
                {
                    JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
                    NSString *departDate = [jFlightSearch getDepartDate];
                    if (STRINGHASVALUE(departDate))
                    {
                        if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_RETURN_TRIP)
                        {
                            [[FlightData getFDictionary] safeSetObject:departDate forKey:KEY_RETURN_DATE];
                        } else {
                            [[FlightData getFDictionary] safeSetObject:departDate forKey:KEY_DEPART_DATE];
                        }
                    }
					break;
				}
			}
		}
		return;
	}
    
	if ([[root safeObjectForKey:@"FlightSelections"] isEqual:[NSNull null]]) {
		NSArray *array = [[NSArray alloc] init];
		[root setValue:array forKey:@"FlightSelections"];
		[array release];
	}
	
//	NSDate *currentDate = [TimeUtils resetNSDate:[NSDate date] formatter:@"yyyy-MM-dd HH:mm"];
	NSDate *goArriveTime = nil;
	if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_RETURN_TRIP) {
		Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
		goArriveTime = [TimeUtils parseJsonDate:[flight getArriveTime]];
	}
	
	if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
		[[FlightData getFArrayGo] removeAllObjects];
	} else {
		[[FlightData getFArrayReturn] removeAllObjects];
	}
	
	for (NSDictionary *dict in [root safeObjectForKey:@"FlightSelections"]) {
        NSDictionary *subDic = [[dict safeObjectForKey:@"Segments"] safeObjectAtIndex:0];    // 取第一个时间判断是否超时
        
//		if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
//            // 机票不显示离起飞时间2小时内的飞人航班
//			if (![self isFirstTimeMoreThan2Hours:[TimeUtils parseJsonDate:[subDic safeObjectForKey:KEY_DEPART_TIME]] secondTime:currentDate]) {
//				continue;
//			}
//		} else {
//			if (![self isFirstTimeMoreThan2Hours:[TimeUtils parseJsonDate:[subDic safeObjectForKey:KEY_DEPART_TIME]] secondTime:goArriveTime]) {
//				continue;
//			}
//		}
		Flight *flight = [[Flight alloc] init];
        flight.stopNumber = [[dict safeObjectForKey:@"StopNumber"] intValue];
        flight.isTransited = [[dict safeObjectForKey:@"IsTransited"] boolValue];
        // 是否一小时飞人
        [flight setIsOneHour:[dict safeObjectForKey:@"IsOneHour"]];
        
        double oilTax = [[subDic safeObjectForKey:KEY_OIL_TAX] doubleValue];    // 燃油费
        int airTax = [[subDic safeObjectForKey:KEY_AIR_TAX] intValue];          // 税费
        
        if (flight.isTransited) {
            // 如果是中转航班，纪录中转信息
            flight.transInfo = @"中转";
            
            NSDictionary *tSubDic = [[dict safeObjectForKey:@"Segments"] safeObjectAtIndex:1];
            flight.tAirCorp = [tSubDic safeObjectForKey:KEY_AIR_CORP_NAME];
            flight.tAirFlightType = [tSubDic safeObjectForKey:KEY_PLANE_TYPE];
            flight.tArrivalAirPort = [tSubDic safeObjectForKey:KEY_ARRIVE_AIRPORT];
            flight.tDepartAirPort = [tSubDic safeObjectForKey:KEY_DEPART_AIRPORT];
            flight.tArrivalTime = [tSubDic safeObjectForKey:KEY_ARRIVE_TIME];
            flight.tDepartTime = [tSubDic safeObjectForKey:KEY_DEPART_TIME];
            flight.tFlightNum = [tSubDic safeObjectForKey:KEY_FLIGHT_NUMBER];
            flight.tAirCorpCode = [tSubDic safeObjectForKey:KEY_AIR_CORP_CODE];
            flight.tDepartAirPortCode = [tSubDic safeObjectForKey:KEY_DEPART_AIRPORT_CODE];
            flight.tArrivalAirPortCode = [tSubDic safeObjectForKey:KEY_ARRIVE_AIRPORT_CODE];
            flight.tKilometers = [tSubDic safeObjectForKey:KEY_KILOMETERS];
            
            oilTax += [[tSubDic safeObjectForKey:KEY_OIL_TAX] doubleValue];
            airTax += [[tSubDic safeObjectForKey:KEY_AIR_TAX] intValue];
        }
        
		[flight setDepartTime:[subDic safeObjectForKey:KEY_DEPART_TIME]];
		[flight setArriveTime:[subDic safeObjectForKey:KEY_ARRIVE_TIME]];
		[flight setAirCorpCode:[subDic safeObjectForKey:KEY_AIR_CORP_CODE]];
		[flight setDepartAirportCode:[subDic safeObjectForKey:KEY_DEPART_AIRPORT_CODE]];
		[flight setArriveAirportCode:[subDic safeObjectForKey:KEY_ARRIVE_AIRPORT_CODE]];
		[flight setDepartAirport:[subDic safeObjectForKey:KEY_DEPART_AIRPORT]];
		[flight setArriveAirport:[subDic safeObjectForKey:KEY_ARRIVE_AIRPORT]];
		[flight setAirCorpName:[subDic safeObjectForKey:KEY_AIR_CORP_NAME]];
		[flight setFlightNumber:[subDic safeObjectForKey:KEY_FLIGHT_NUMBER]];
		[flight setPlaneType:[subDic safeObjectForKey:KEY_PLANE_TYPE]];
		[flight setOilTax:oilTax];
		[flight setAirTax:airTax];
		[flight setIsEticket:[[subDic safeObjectForKey:KEY_IS_ETICKET] boolValue]];
		[flight setKilometers:[[subDic safeObjectForKey:KEY_KILOMETERS] intValue]];
		[flight setStops:[[subDic safeObjectForKey:KEY_STOPS] boolValue]];
        flight.defaultCoupon = [subDic safeObjectForKey:KEY_DEFAULT_COUPON];
        flight.isContainLegislation = [[subDic safeObjectForKey:IS_CONTAIN_LEGISLATION] safeBoolValue];
		
		double minPrice = MAXFLOAT;
		int minArrayIndex = 0;
		int tmpCount = 0;
		for (NSDictionary *site in [subDic safeObjectForKey:KEY_SITES]) {
			double p = [[site safeObjectForKey:KEY_PRICE] doubleValue];
			if (minPrice > p) {
				minPrice = p;
				minArrayIndex = tmpCount;
			}
			tmpCount++;
		}
		
		//设置最便宜的舱位的信息
		NSDictionary *site = [[subDic safeObjectForKey:KEY_SITES] safeObjectAtIndex:minArrayIndex];
		[flight setClassType:[[site safeObjectForKey:KEY_CLASS_TYPE] intValue]];
		[flight setPrice:[[site safeObjectForKey:KEY_PRICE] intValue]];
		[flight setTicketnum:[site safeObjectForKey:KEY_REMAINTICKETSTATE]];
		[flight setDiscount:[[site safeObjectForKey:KEY_DISCOUNT] doubleValue]];
		[flight setPromotionID:[[site safeObjectForKey:KEY_PROMOTION_ID] intValue]];
		[flight setClassTag:[site safeObjectForKey:KEY_CLASS_TAG]];
		[flight setIsPromotion:[[site safeObjectForKey:KEY_IS_PROMOTION] boolValue]];
		[flight setTypeName:[site safeObjectForKey:KEY_TYPE_NAME]];
		[flight setTimeOfLastIssued:[site safeObjectForKey:KEY_TIME_OF_LAST_ISSUES]];
		[flight setIssueCityId:[[site safeObjectForKey:KEY_ISSUE_CITY_ID] intValue]];
        flight.isLegislationPirce = [[site safeObjectForKey:IS_LEGISLATION_PRICE] safeBoolValue];
        flight.originalPrice = [NSString stringWithFormat:@"%@", [site safeObjectForKey:ORIGINAL_PRICE]];
        
        // 剩余票量
        BOOL hasTicket = NO;
        for (NSDictionary *siteItem in [subDic safeObjectForKey:KEY_SITES])
        {
            NSNumber *ticketCount = [siteItem safeObjectForKey:KEY_TICKETCOUNT];
            if (ticketCount != nil && [ticketCount integerValue] > 0)
            {
                hasTicket = YES;
                break;
            }
		}
        // 保存票量信息
        [flight setTicketCount:[NSNumber numberWithBool:hasTicket]];
		
        
        
		if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP)
        {
			[[FlightData getFArrayGo] addObject:flight];
		} else {
			[[FlightData getFArrayReturn] addObject:flight];
		}
		[flight release];
	}
    
	if (m_iFlightSearchFrom == FlightSearchFromSelf || m_iFlightSearchFrom == FlightSearchFromDetail) {
		NSString *listNameStr = [[NSString alloc] initWithString:(m_iType == DEFINE_SINGLE_TRIP ? @"航班列表":([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP ? @"去程航班":@"返程航班"))];
		FlightList *controller = [[FlightList alloc] initWithTitle:listNameStr displayTransFlight:m_iType == DEFINE_ROUND_TRIP ? NO : YES];
		[self.navigationController pushViewController:controller animated:YES];
        [[Profile shared] end:@"机票搜索"];
		[controller release];
		[listNameStr release];
		
		m_iFlightSearchFrom = FlightSearchFromList;
		
	} else if (m_iFlightSearchFrom == FlightSearchFromList)
    {
		FlightList *fl = (FlightList *)[self.navigationController topViewController];
		[fl loadListData];
        
        // 高亮选择的低价日历项
        [fl setCheapCalendarSelectedItem];
        [[Profile shared] end:@"机票搜索"];
	}
}

#pragma mark -
#pragma mark IBAction
- (IBAction)departCityButtonPressed {
	[selectTable dismissInView];
	
	SelectCity *selectCity = [[SelectCity alloc] init:@"出发城市" style:_NavOnlyBackBtnStyle_ citylable:departCityLabel cityType:SelectCityTypeFlight isSave:NO];
	[self.navigationController pushViewController:selectCity animated:YES];
	[selectCity release];
    
    UMENG_EVENT(UEvent_Flight_Search_DepartureCityChoice)
}

- (IBAction)arrivalCityButtonPressed {
	[selectTable dismissInView];
	
	SelectCity *selectCity = [[SelectCity alloc] init:@"到达城市" style:_NavOnlyBackBtnStyle_ citylable:arrivalCityLabel cityType:SelectCityTypeFlight isSave:NO];
	[self.navigationController pushViewController:selectCity animated:YES];
	[selectCity release];
    
    UMENG_EVENT(UEvent_Flight_Search_ArrivalCityChoice)
}

- (IBAction)departDateButtonPressed {
    [selectTable dismissInView];
    
    //	DPCalendar *calendar = [[DPCalendar alloc] init:@"出发日期" btnname:@"当前月" navLeftBtnStyle:_NavLeftBtnImageStyle_ label:departDateLabel todaylabel:dTodayLabel];
    //	[self.navigationController pushViewController:calendar animated:YES];
    //	[calendar release];
    ELCalendarViewController *vc=[[ELCalendarViewController alloc] initWithCheckIn:self.departdate checkOut:self.arrivaldata type:FlightCalendarGo];
    self.departureCalendarVC = vc;
    vc.delegate = self;
   	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
    
    UMENG_EVENT(UEvent_Flight_Search_DepartureDateChoice)
}

- (IBAction)returnDateButtonPressed {
    [selectTable dismissInView];
    
    //	DPCalendar *calendar = [[DPCalendar alloc] init:@"返回日期" btnname:@"当前月" navLeftBtnStyle:_NavLeftBtnImageStyle_ label:returnDateLabel todaylabel:rTodayLabel];
    //	[self.navigationController pushViewController:calendar animated:YES];
    //	[calendar release];
    ELCalendarViewController *vc=[[ELCalendarViewController alloc] initWithCheckIn:self.departdate checkOut:self.arrivaldata type:FlightCalendarBack];
    vc.delegate = self;
    self.arrivalCalendarVC = vc;
   	[self.navigationController pushViewController:vc animated:YES];
	[vc release];
    
    UMENG_EVENT(UEvent_Flight_Search_BackDateChoice)
}

- (IBAction)classButtonPressed {
	if (!selectTable.view.superview) {
		if (!selectTable) {
            //			selectTable = [[FilterView alloc] initWithTitle:@"选择舱位"
            //													  Datas:[NSArray arrayWithObjects:@"不限舱位", @"经济舱", @"商务舱", @"头等舱", nil]];
            selectTable = [[FilterView alloc] initWithTitle:@"选择舱位"
													  Datas:[NSArray arrayWithObjects:@"经济舱", @"商务舱/头等舱", nil]];
			selectTable.delegate = self;
		}
		[self.view addSubview:selectTable.view];
	}
	
	[selectTable showInView];
    
    UMENG_EVENT(UEvent_Flight_Search_SpaceChoice)
}

// 时区检测，判断用户所在位置是否为东八区
- (void) checkLocalTimeZone{
    
    BOOL result = NO;
    
    if([[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Chongqing"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Harbin"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Hong_Kong"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Macau"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Shanghai"].location == 0 ||
       [[[NSTimeZone localTimeZone] name] rangeOfString:@"Asia/Taipei"].location == 0){
        result = YES;
    }
    if (!result) {
        [PublicMethods showAlertTitle:nil Message:@"目前您系统的时区为非东八区，为了确保您预订日期准确，建议您修改系统时区"];
    }
}

- (void)searchButtonPressed {
    //    FlightOrderSuccess *controller = [[FlightOrderSuccess alloc] init];
    //    [controller setCouldPay:YES];
    //    controller.havePNR = NO;
    //    [self.navigationController pushViewController:controller animated:YES];
    //    [[Profile shared] end:@"机票下单"];
    //    [controller release];
    //    return;
    
    // 检测当前时区
    [self checkLocalTimeZone];
    
    
    [self preloadCouponInfo];
    
    //把搜索城市存入本地    
    [[ElongUserDefaults sharedInstance] setObject:departcitystring forKey:USERDEFAULT_FLIGHT_DEPARTCITYNAME];
    [[ElongUserDefaults sharedInstance] setObject:arrivalcitystriing forKey:USERDEFAULT_FLIGHT_ARRIVALCITYNAME];
    
	m_iFlightSearchFrom = FlightSearchFromSelf;
    
	if ([arrivalCityLabel.text isEqualToString:@""]) {
		[Utils alert:@"请选择到达城市"];
		return;
	}
	if (m_iType == DEFINE_ROUND_TRIP) {
		double dDate = [[TimeUtils displayNSStringToGMT8NSDate:departDateLabel.text] timeIntervalSince1970];
		double rDate = [[TimeUtils displayNSStringToGMT8NSDate:returnDateLabel.text] timeIntervalSince1970];
		if (rDate < dDate) {
			[Utils alert:@"返回日期不能早于出发日期"];
			return;
		}
	}
	if ([departCityLabel.text isEqualToString:arrivalCityLabel.text]) {
		[Utils alert:@"出发城市和到达城市不能为同一个城市"];
		return;
	}
	
	self.begincity = departcitystring;
	self.endcity = arrivalcitystriing;
	
	[[FlightData getFDictionary] removeAllObjects];
	[[FlightData getFArrayGo] removeAllObjects];
	[[FlightData getFArrayReturn] removeAllObjects];
	[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_GO_TRIP] forKey:KEY_CURRENT_FLIGHT_TYPE];
	[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:m_iType] forKey:KEY_SELECT_FLIGHT_TYPE];
	[[FlightData getFDictionary] safeSetObject:begincity forKey:KEY_DEPART_CITY];
	[[FlightData getFDictionary] safeSetObject:endcity forKey:KEY_ARRIVE_CITY];
	[[FlightData getFDictionary] safeSetObject:departDateLabel.text forKey:KEY_DEPART_DATE];
	[[FlightData getFDictionary] safeSetObject:(m_iType == DEFINE_SINGLE_TRIP ? @"0" : returnDateLabel.text) forKey:KEY_RETURN_DATE];
	[[FlightData getFDictionary] safeSetObject:m_iClassType forKey:KEY_SELECT_CLASS_TYPE];
	
	[self fightSearch];
    
    UMENG_EVENT(UEvent_Flight_Search_Search)
}


// 预加载消费券
- (void)preloadCouponInfo {
    BOOL islogin = [[AccountManager instanse] isLogin];
    if (islogin) {
        JCoupon *coupon = [MyElongPostManager coupon];
        [[MyElongPostManager coupon] clearBuildData];
        if (couponUtil) {
            [couponUtil cancel];
            SFRelease(couponUtil);
        }
        
        couponUtil = [[HttpUtil alloc] init];
        [couponUtil connectWithURLString:MYELONG_SEARCH
                                 Content:[coupon requesActivedCounponString:YES]
                            StartLoading:NO
                              EndLoading:NO
                                Delegate:self];
    }
}


- (void)fightSearch {
	JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
	[jFlightSearch setDepartCityName:begincity isClearData:YES];
	[jFlightSearch setArrivalCityName:endcity isClearData:NO];
	[jFlightSearch setDepartDate:departDateLabel.text isClearData:NO];
	[jFlightSearch setClassType:m_iClassType isClearData:NO];
    [jFlightSearch setIsSearch51Book:[NSNumber numberWithBool:YES] isClearData:NO];
    [jFlightSearch setProductType:[NSNumber numberWithInt:0] isClearData:NO];
    // 是否搜索1小时飞人
    if (m_iType == DEFINE_SINGLE_TRIP)
    {
        [jFlightSearch setIsSearchOneHour:[NSNumber numberWithBool:YES] isClearData:NO];
    }
    else
    {
        [jFlightSearch setIsSearchOneHour:[NSNumber numberWithBool:NO] isClearData:NO];
    }
    
    [[Profile shared] start:@"机票搜索"];
	[Utils request:FLIGHT_SERACH req:[jFlightSearch requesString:YES] delegate:self];
}


- (void)returnFightSearch {
	JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
	[jFlightSearch setDepartCityName:endcity isClearData:YES];
	[jFlightSearch setArrivalCityName:begincity isClearData:NO];
	[jFlightSearch setDepartDate:returnDateLabel.text isClearData:NO];
	[jFlightSearch setClassType:m_iClassType isClearData:NO];
    [jFlightSearch setProductType:[NSNumber numberWithInt:0] isClearData:NO];
    [[Profile shared] start:@"机票搜索"];
	[Utils request:FLIGHT_SERACH req:[jFlightSearch requesString:YES] delegate:self];
}

#pragma mark -


- (void)back {
    [Utils clearFlightData];
	//[PublicMethods closeSesameInView:self.navigationController.view];
    [super back];
}


#pragma mark -
#pragma mark Date Methods

- (NSArray *) switchMonth:(NSArray *)dateCompents{
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *item in dateCompents) {
        if ([item isEqualToString:@"一月"]) {
            [newArray addObject:@"1月"];
        }else if([item isEqualToString:@"二月"]) {
            [newArray addObject:@"2月"];
        }else if([item isEqualToString:@"三月"]) {
            [newArray addObject:@"3月"];
        }else if([item isEqualToString:@"四月"]) {
            [newArray addObject:@"4月"];
        }else if([item isEqualToString:@"五月"]) {
            [newArray addObject:@"5月"];
        }else if([item isEqualToString:@"六月"]) {
            [newArray addObject:@"6月"];
        }else if([item isEqualToString:@"七月"]) {
            [newArray addObject:@"7月"];
        }else if([item isEqualToString:@"八月"]) {
            [newArray addObject:@"8月"];
        }else if([item isEqualToString:@"九月"]) {
            [newArray addObject:@"9月"];
        }else if([item isEqualToString:@"十月"]) {
            [newArray addObject:@"10月"];
        }else if([item isEqualToString:@"十一月"]) {
            [newArray addObject:@"11月"];
        }else if([item isEqualToString:@"十二月"]) {
            [newArray addObject:@"12月"];
        }else{
            [newArray addObject:item];
        }
    }
    return newArray;
}

- (void)combinationDepartDateWithDate:(NSDate *)date {
	// 组合出发日期
    //	NSArray *dateCompents = [[format stringFromDate:date] componentsSeparatedByString:@","];
    //
    //	departDateWeekLabel.text	= [dateCompents safeObjectAtIndex:0];
    //	departDateMonLabel.text		= [dateCompents safeObjectAtIndex:1];
    //
    //	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
    //	if ([dayStr intValue] < 10) {
    //		dayStr = [NSString stringWithFormat:@"0%@",dayStr];
    //	}
    //	departDateDayLabel.text = dayStr;
    
    self.departdate = date;
    
    NSString *stringDate = [[oFormat stringFromDate:date] description];
    NSString *formattedString = [[stringDate componentsSeparatedByString:@" "] safeObjectAtIndex:0];
    NSLog(@"%@", formattedString);
    
    departDateLabel.text = formattedString;
    
    NSArray *dateCompents = [[oFormat stringFromDate:date] componentsSeparatedByString:@"-"];
	
	departDateWeekLabel.text	= [self getDetailDayNotice:[oFormat stringFromDate:date]];
    
	NSArray *flightDateCompents = [self switchMonth:[[format stringFromDate:date] componentsSeparatedByString:@","]];
    NSArray *nowDateCompents = [self switchMonth:[[format stringFromDate:[NSDate date]] componentsSeparatedByString:@","]];
    if ([[flightDateCompents safeObjectAtIndex:1] isEqual:[nowDateCompents safeObjectAtIndex:1]]) {
        // 月份相等的情况
        if (([[flightDateCompents safeObjectAtIndex:2] isEqual:[nowDateCompents safeObjectAtIndex:2]])) {
            // 日期相等
            departDateWeekLabel.text = @"今天";
        }
        else if (([[flightDateCompents safeObjectAtIndex:2] intValue] == [[nowDateCompents safeObjectAtIndex:2] intValue] + 1)) {
            departDateWeekLabel.text = @"明天";
        }
        else {
            departDateWeekLabel.text = [flightDateCompents safeObjectAtIndex:0];
        }
    }
    else {
        // 月份不相等
        departDateWeekLabel.text	= [flightDateCompents safeObjectAtIndex:0];
    }
    
	departDateMonLabel.text		= [NSString stringWithFormat:@"%d月", [[dateCompents safeObjectAtIndex:1] integerValue]];
	
	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
	if ([dayStr intValue] < 10) {
		dayStr = [NSString stringWithFormat:@"%@",dayStr];
	}
	departDateDayLabel.text = dayStr;
}


- (void)combinationBackDateWithDate:(NSDate *)date {
	// 组合返程日期
    //	NSArray *dateCompents = [[format stringFromDate:date] componentsSeparatedByString:@","];
    //
    //	arriveDateWeekLabel.text	= [dateCompents safeObjectAtIndex:0];
    //	arriveDateMonLabel.text		= [dateCompents safeObjectAtIndex:1];
    //
    //	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
    //	if ([dayStr intValue] < 10) {
    //		dayStr = [NSString stringWithFormat:@"0%@",dayStr];
    //	}
    //	arriveDateDayLabel.text = dayStr;
    self.arrivaldata = date;
    
    NSString *stringDate = [[oFormat stringFromDate:date] description];
    NSString *formattedString = [[stringDate componentsSeparatedByString:@" "] safeObjectAtIndex:0];
    //    NSLog(@"%@", formattedString);
    
    returnDateLabel.text = formattedString;
    
    
    NSArray *dateCompents = [[oFormat stringFromDate:date] componentsSeparatedByString:@"-"];
	
	arriveDateWeekLabel.text	= [self getDetailDayNotice:[oFormat stringFromDate:date]];
    
    
    NSArray *flightDateCompents = [self switchMonth:[[format stringFromDate:date] componentsSeparatedByString:@","]];
    NSArray *nowDateCompents = [self switchMonth:[[format stringFromDate:[NSDate date]] componentsSeparatedByString:@","]];
    if ([[flightDateCompents safeObjectAtIndex:1] isEqual:[nowDateCompents safeObjectAtIndex:1]]) {
        // 月份相等的情况
        if (([[flightDateCompents safeObjectAtIndex:2] isEqual:[nowDateCompents safeObjectAtIndex:2]])) {
            // 日期相等
            arriveDateWeekLabel.text = @"今天";
        }
        else if (([[flightDateCompents safeObjectAtIndex:2] intValue] == [[nowDateCompents safeObjectAtIndex:2] intValue] + 1)) {
            arriveDateWeekLabel.text = @"明天";
        }
        else {
            arriveDateWeekLabel.text = [flightDateCompents safeObjectAtIndex:0];
        }
    }
    else {
        // 月份不相等
        arriveDateWeekLabel.text	= [flightDateCompents safeObjectAtIndex:0];
    }
    
    
	arriveDateMonLabel.text		= [NSString stringWithFormat:@"%d月", [[dateCompents safeObjectAtIndex:1] integerValue]];
	
	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
	if ([dayStr intValue] < 10) {
		dayStr = [NSString stringWithFormat:@"%@",dayStr];
	}
	arriveDateDayLabel.text = dayStr;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	NSDate *departDate  = [oFormat dateFromString:departDateLabel.text];
	NSDate *returnDate	= [oFormat dateFromString:returnDateLabel.text];
	self.departdate = departDate;
    self.arrivaldata = returnDate;
	if (object == departDateLabel) {
		[self combinationDepartDateWithDate:departDate];
		
		if ([departDate compare:returnDate] == NSOrderedDescending) {
			// 如果出发日期大于等于返回日期，相应改变返回日期
			returnDateLabel.text =[oFormat stringFromDate:departDate];
			[self combinationBackDateWithDate:departDate];
		}
	}
	else if (object == returnDateLabel) {
		[self combinationBackDateWithDate:returnDate];
		
		if ([departDate compare:returnDate] == NSOrderedDescending) {
			// 如果返回日期小于出发日期，相应改变出发日期
			departDateLabel.text = [oFormat stringFromDate:returnDate];
			[self combinationDepartDateWithDate:returnDate];
		}
	}
    if ([keyPath isEqual:@"text"]) {
        if ([object isEqual:departCityLabel]) {
            self.departcitystring = [change safeObjectForKey:@"new"];
        }
        if ([object isEqual:arrivalCityLabel]) {
            self.arrivalcitystriing= [change safeObjectForKey:@"new"];
        }
        if ([object isEqual:classLabel]) {
            self.classlabelstring= [change safeObjectForKey:@"new"];
        }
        
	}
}
//- (void)go2flightonline
//{
//    FlightOnlineViewController * fonline = [[FlightOnlineViewController alloc] init];
//    [self.navigationController pushViewController:fonline animated:YES];
//    [fonline release];
//}

#pragma mark -

- (id)init
{
    if (self = [super initWithTopImagePath:@"" andTitle:@"航班查询" style:_NavNormalBtnStyle_])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiApplicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor colorWithRed:245.0f / 255 green:245.0f / 255 blue:245.0f / 255 alpha:1.0f];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    //    if (IOSVersion_7) {
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //    }
    //    if (SCREEN_4_INCH) {
    //        UIButton *addnewflight = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [addnewflight setBackgroundImage:[UIImage noCacheImageNamed:@"FlightOnlineentrance.png"] forState:UIControlStateNormal];
    //        [addnewflight setBackgroundImage:[UIImage noCacheImageNamed:@"FlightOnlineentranceclick.png"] forState:UIControlStateHighlighted];
    //        addnewflight.frame = CGRectMake(0, 12, 49, 35);
    //        [addnewflight addTarget:self action:@selector(go2flightonline) forControlEvents:UIControlEventTouchUpInside];
    //        UIBarButtonItem * buttonItem = [[UIBarButtonItem alloc] initWithCustomView:addnewflight];
    //        self.navigationItem.rightBarButtonItem = buttonItem;
    //        [buttonItem release];
    //    }
    
    [departCityLabel addObserver:self
                      forKeyPath:@"text"
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                         context:nil];
    [arrivalCityLabel addObserver:self
                       forKeyPath:@"text"
                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                          context:nil];
    //    [classLabel addObserver:self
    //                       forKeyPath:@"text"
    //                          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
    //                          context:nil];
	
	format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"E,MMMM,d"];
	oFormat = [[NSDateFormatter alloc] init];
	[oFormat setDateFormat:@"yyyy-MM-dd"];
	
    if (arrivaldata != nil) {
        [self combinationDepartDateWithDate:[NSDate dateWithTimeInterval:0 sinceDate:departdate]];
        [self combinationBackDateWithDate:[NSDate dateWithTimeInterval:0 sinceDate:arrivaldata]];
    }
    else
    {
        // 初始使用默认日期
        [self combinationDepartDateWithDate:[NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]]];
        [self combinationBackDateWithDate:[NSDate dateWithTimeInterval:2*86400 sinceDate:[NSDate date]]];
    }
	
	queryBtn = [UIButton uniformButtonWithTitle:@"查  询" ImagePath:@"" Target:self Action:@selector(searchButtonPressed) Frame:CGRectMake(13, 291 * COEFFICIENT_Y, 294, 46)];
	[self.view addSubview:queryBtn];
    
    if ([classlabelstring length] == 0) {
        classLabel.text = [Utils getClassTypeName:1];			// 舱位，默认为“不限制”
    }
    else
    {
        classLabel.text = classlabelstring;                     // 舱位，默认为“不限制”
    }
    
	//departCityLabel.text = @"北京";							// 出发城市，默认为"北京"
	
	//设置高亮
    
    UIImage *image = [UIImage imageNamed:@"flight_press.png"];
    departCityButton.exclusiveTouch = YES;
    arrivalCityButton.exclusiveTouch = YES;
    departDateButton.exclusiveTouch = YES;
    returnDateButton.exclusiveTouch = YES;
	[departCityButton setBackgroundImage:image forState:UIControlStateHighlighted];
	[arrivalCityButton setBackgroundImage:image forState:UIControlStateHighlighted];
	[departDateButton setBackgroundImage:image forState:UIControlStateHighlighted];
	[returnDateButton setBackgroundImage:image forState:UIControlStateHighlighted];
	[classButton setBackgroundImage:image forState:UIControlStateHighlighted];
	
	m_iFlightSearchFrom = FlightSearchFromSelf;
	dTodayLabel.hidden = YES;
	rTodayLabel.hidden = YES;
	
	// 添加选择器
	NSArray *titleArray = [NSArray arrayWithObjects:@"单  程", @"往  返", nil];
	
	CustomSegmented *seg = [[CustomSegmented alloc] initCommanSegmentedWithTitles:titleArray
																	  normalIcons:nil
																   highlightIcons:nil];
	seg.delegate		= self;
	seg.selectedIndex	= segmentselectedindex;
	[self.view addSubview:seg];
	[seg release];
	
	//date
	[self showBackDateView:NO];
    
	m_iType = 0;
    
    if ([departcitystring length] != 0) {
        departCityLabel.text = departcitystring;
    }
    else
    {
        if ([[PositioningManager shared] getPostingBool]) {
            departCityLabel.text = [[PositioningManager shared] currentCity];
        }
        else
        {
            NSString *departCitySaved = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_FLIGHT_DEPARTCITYNAME];
            if (STRINGHASVALUE(departCitySaved))
            {
                departCityLabel.text = departCitySaved;
            }
            else
            {
                departCityLabel.text = @"北京";
            }
        }
        self.departcitystring = departCityLabel.text;
    }
	
	//定位出城市
    if ([arrivalcitystriing length] != 0) {
        arrivalCityLabel.text = arrivalcitystriing;
    }
    else
    {
        if ([[PositioningManager shared] getPostingBool]) {
            if ([departCityLabel.text isEqualToString:@"北京"]) {
                arrivalCityLabel.text = @"上海";
            }
            else {
                arrivalCityLabel.text = @"北京";
            }
        }
        //没有定位出城市
        else
        {
            NSString *arriveCitySaved = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_FLIGHT_ARRIVALCITYNAME];
            if (STRINGHASVALUE(arriveCitySaved))
            {
                arrivalCityLabel.text = arriveCitySaved;
            }
            else
            {
                arrivalCityLabel.text = @"上海";
            }
            
        }
        self.arrivalcitystriing = arrivalCityLabel.text;
    }
	
	departDateLabel.text = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+24*60*60) formatter:@"yyyy-MM-dd"];
    departDateLabel.hidden = YES;
    returnDateLabel.hidden = YES;
	returnDateLabel.text = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+2*24*60*60) formatter:@"yyyy-MM-dd"];
    //	[departDateLabel addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    //	[returnDateLabel addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    [self performSelector:@selector(screenFit)];            // 处理不同分辨率
    
    [_buttonExchange addTarget:self action:@selector(exchangeCityPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addLineToView];
}


- (void)screenFit {
    //    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //
    //    CGRect rect = cityView.frame;
    //    rect.origin.y *= COEFFICIENT_Y;
    //    cityView.frame = rect;
    //
    //    rect = departView.frame;
    //    rect.origin.y *= COEFFICIENT_Y;
    //    departView.frame = rect;
    //
    //    rect = backTimeView.frame;
    //    rect.origin.y *= COEFFICIENT_Y;
    //    backTimeView.frame = rect;
    //
    //    rect = classView.frame;
    //    rect.origin.y *= COEFFICIENT_Y;
    //    classView.frame = rect;
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    CGRect rect = cityView.frame;
    
    CGFloat originY = rect.origin.y;
    CGFloat diffY = originY * COEFFICIENT_Y - originY;
    rect.origin.y += diffY;
    cityView.frame = rect;
    
    rect = departView.frame;
    rect.origin.y += diffY;
    //rect.size.height = rect.size.height *COEFFICIENT_Y;
    departView.frame = rect;
    
    rect = backTimeView.frame;
    rect.origin.y += diffY;
    backTimeView.frame = rect;
    
    rect = classView.frame;
    rect.origin.y += diffY;
    classView.frame = rect;
    
    rect = departCityButton.frame;
    //rect.origin.y += diffY;
    departCityButton.frame = rect;
    
    rect = arrivalCityButton.frame;
    //rect.origin.y += diffY;
    arrivalCityButton.frame = rect;
    
    rect = departDateButton.frame;
    //rect.origin.y += diffY;
    departDateButton.frame = rect;
    
    rect = returnDateButton.frame;
    //rect.origin.y += diffY;
    returnDateButton.frame = rect;
    
    //    rect = classButton.frame;
    //    rect.origin.y += diffY;
    //    classButton.frame = rect;
}

#pragma mark -
#pragma mark CustomSegmented Delegate

- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index {
    segmentselectedindex = index;
	switch (index) {
		case 0:{
			[self showBackDateView:NO];
			m_iType = 0;
        }
			break;
		case 1:{
			[self showBackDateView:YES];
			m_iType = 1;
            UMENG_EVENT(UEvent_Flight_Search_RoundTrip)
        }
			break;
	}
}

#pragma mark -

//- (void)viewDidUnload {
//    [super viewDidUnload];
//
//    segmentselectedindex = 0;
//	[departCityLabel removeObserver:self forKeyPath:@"text"];
//    [arrivalCityLabel removeObserver:self forKeyPath:@"text"];
//    [classLabel removeObserver:self forKeyPath:@"text"];
//	[departDateLabel removeObserver:self forKeyPath:@"text"];
//	[returnDateLabel removeObserver:self forKeyPath:@"text"];
//}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
	[departCityLabel removeObserver:self forKeyPath:@"text"];
	[arrivalCityLabel removeObserver:self forKeyPath:@"text"];
    //	[classLabel removeObserver:self forKeyPath:@"text"];
    //	[departDateLabel removeObserver:self forKeyPath:@"text"];
    //	[returnDateLabel removeObserver:self forKeyPath:@"text"];
    
    [couponUtil cancel];
    SFRelease(couponUtil);
    
	self.departcitystring = nil;
	self.arrivalcitystriing = nil;
	self.classlabelstring = nil;
	self.arrivaldata = nil;
	self.departdate = nil;
	self.begincity	= nil;
	self.endcity	= nil;
	
	[cityView release];
	[departView release];
	
	[departCityLabel release];
	[departCityButton release];
	[arrivalCityLabel release];
	[arrivalCityButton release];
	[departDateLabel release];
	[departDateButton release];
	[returnDateLabel release];
	[returnDateButton release];
	[dTodayLabel release];
	[rTodayLabel release];
	[dapartDateTitle release];
	[rightArrow release];
	
	[departDateDayLabel release];
	[arriveDateDayLabel release];
	[departDateMonLabel release];
	[arriveDateMonLabel release];
	[departDateWeekLabel release];
	[arriveDateWeekLabel release];
	
    selectTable.delegate = nil;
	[selectTable release];
	[classLabel release];
	[classButton release];
	[searchButton release];
	[backTimeView release];
	[classView release];
	[format release];
	[oFormat release];
    
    self.buttonExchange = nil;
    
    //    _departureCalendarVC.delegate = nil;
    //    _arrivalCalendarVC.delegate = nil;
    //    self.departureCalendarVC = nil;
    //    self.arrivalCalendarVC = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark delegate
- (void)segmentedClick:(id)sender {
	//[self getDateSeprate];
	int tag = [sender tag];
	switch (tag) {
		case 0:
			[self showBackDateView:NO];
			m_iType = 0;
			break;
		case 1:
			[self showBackDateView:YES];
			m_iType = 1;
			break;
	}
}


#pragma mark -
#pragma mark FilterDelegate

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView {
	classLabel.text = filterStr;
}


- (void)selectedIndex:(NSInteger)index inFilterView:(FilterView *)filterView {
    if(index==0){
        self.m_iClassType = @"1";
    }else{
        self.m_iClassType = @"2,3";
    }
}

#pragma mark -
#pragma mark ElCalendarViewSelectDelegate
-(void) ElcalendarViewSelectDay:(ELCalendarViewController *) elViewController checkinDate:(NSDate *) cinDate checkoutDate:(NSDate *) coutDate
{
    NSDate *departDate  = [oFormat dateFromString:departDateLabel.text];
	NSDate *returnDate	= [oFormat dateFromString:returnDateLabel.text];
    
    
    NSTimeInterval secondsPerDay = 24*60*60;
    ///////////////////////////
    if (elViewController == _departureCalendarVC) {
        [self combinationDepartDateWithDate:cinDate];
        if ([cinDate compare:returnDate] == NSOrderedDescending) {
			// 如果出发日期大于等于返回日期，相应改变返回日期
            //			returnDateLabel.text =[oFormat stringFromDate:departDate];
            if ([[CalendarHelper shared] compareDate:[NSDate date] withCheckOutDate:cinDate] == 0) {
                [self combinationBackDateWithDate:cinDate];
            }
            else {
                [self combinationBackDateWithDate:[cinDate dateByAddingTimeInterval:+secondsPerDay]];
            }
			
            self.departdate = cinDate;
		}
    }
    else if (elViewController == _arrivalCalendarVC) {
        [self combinationBackDateWithDate:cinDate];
        
        if ([departDate compare:cinDate] == NSOrderedDescending) {
			// 如果返回日期小于出发日期，相应改变出发日期
            //			departDateLabel.text = [oFormat stringFromDate:returnDate];
            if ([[CalendarHelper shared] compareDate:[NSDate date] withCheckOutDate:cinDate] == 0) {
//            if ([[NSDate date] isEqualToDate:cinDate]) {
                [self combinationDepartDateWithDate:cinDate];
            }
            else {
                [self combinationDepartDateWithDate:[cinDate dateByAddingTimeInterval:-secondsPerDay]];
            }
			
            self.arrivaldata = cinDate;
		}
    }
    ///////////////////////////
    
    
    
}

@end
