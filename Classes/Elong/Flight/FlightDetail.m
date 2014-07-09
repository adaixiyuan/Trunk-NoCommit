//
//  FlightDetail.m
//  ElongClient
//
//  Created by dengfang on 11-1-24.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightDetail.h"
#import "PlaneInfo.h"
#import "FillFlightOrder.h"
#import "FlightDataDefine.h"
#import "Utils.h"
#import "FlightSearch.h"
#import "FlightList.h"
#import "FlightSeatClass.h"
#import "FlightMoreRule.h"
#import "FlightDetailCell.h"
#import "CustomPageController.h"
#import "FlightDetailPopView.h"
#import "AttributedLabel.h"

#define FLIGHT_DETAIL_LEBEL_WIDTH 280

@interface FlightDetail ()

@property (nonatomic, copy) NSString *oilTaxStr;
@property (nonatomic, copy) NSString *airTaxStr;

@end

@implementation FlightDetail
@synthesize planeInfoButton;
@synthesize parentvcselectedindex;
@synthesize oilTaxStr;
@synthesize airTaxStr;

#pragma mark -
#pragma mark Private

//处理label 数据多的时候，最后一行加...
-(void)deal:(UILabel*)label string:(NSString*)str labellength:(int)lent labelheight:(int)height
{
	UIFont *font = FONT_12;
	label.lineBreakMode = UILineBreakModeCharacterWrap;
	label.text = str;
	
	CGSize size = [str sizeWithFont:font]; //label 内容的尺寸 ,总str 占的像素
	
	int line = height/size.height; //可以放得下几行 label 高度/每个字符的高度
	
	int index = ((line)*lent+80)/size.height;
	if (index >= [str length]) {
		index = ((line - 1)*lent+80)/size.height;
	}
	
	NSMutableString* labstr = [[[NSMutableString alloc] initWithString:[str substringToIndex:index]] autorelease];
	[labstr appendString:@"..."];
	label.text = labstr;
}

- (void)pushPlaneInfo
{
	// 推出机型介绍页
	PlaneInfo *m_planeInfo = [[PlaneInfo alloc] init];
    if (IOSVersion_7) {
        m_planeInfo.transitioningDelegate = [ModalAnimationContainer shared];
        m_planeInfo.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:m_planeInfo animated:YES completion:nil];
    }else{
        [self presentModalViewController:m_planeInfo animated:YES];
    }
	
	[m_planeInfo release];
}

- (BOOL)isFirstTimeMoreThan2Hours:(NSDate *)firstTime secondTime:(NSDate *)secondTime
{
	double fTime = [firstTime timeIntervalSince1970];
	double sTime = [secondTime timeIntervalSince1970];
	if ((fTime -sTime) /60 >= 2*60) {
		return YES;
	}
	return NO;
}

- (NSDate *)displayNSStringToDate:(NSString *)s
{
	NSTimeZone *dtz=[NSTimeZone timeZoneWithAbbreviation:@"UTC"];
	NSDateFormatter* f = [[NSDateFormatter alloc] init];
	[f setTimeZone:dtz];
	[f setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSDate *d=[f dateFromString:s];
	[f release];
	return d;
}

- (void)noStopInfoTip
{
    // 没有经停信息提示
    [jingtingbackview endLoading];
    UILabel *failedinfolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 34)];
    [jingtingbackview addSubview:failedinfolabel];
    failedinfolabel.backgroundColor = [UIColor clearColor];
    failedinfolabel.font = [UIFont systemFontOfSize:13];
    failedinfolabel.textAlignment = NSTextAlignmentCenter;
    failedinfolabel.text = NOSTOPFLIGHT_TIP;
    [failedinfolabel release];
}

// 进入机票订单填写页
- (void)goFillFlightOrder
{
    // 跳转订单填写页
    FillFlightOrder *controller = [[FillFlightOrder alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark -
#pragma mark Http
- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if([visitType isEqualToString:@"go"]){
        //在验舱成功，但是访问返程列表失败的时候，用于清空记录的数据，防止引起后续的bug
        [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_GO_TRIP] forKey:KEY_CURRENT_FLIGHT_TYPE]; //重置为去程
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == transportUtil) {
        // 经停信息
        [self noStopInfoTip];
    }
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    if (util == transportUtil) {
        // 经停信息
        [stopInfoLabel endLoading];
        
        NSDictionary *StopOver = [root safeObjectForKey:@"StopOver"];
        if (DICTIONARYHASVALUE(StopOver)) {
            NSString *StopAirPortName = [StopOver safeObjectForKey:@"StopAirPortName"];
            if ([StopAirPortName isEqual:[NSNull null]]) {
                [self noStopInfoTip];
                return;
            }
            NSString *ArriveTime = [StopOver safeObjectForKey:@"ArriveTime"];
            NSString *DepartTime = [StopOver safeObjectForKey:@"DepartTime"];
            
            double departtime = 0;
            if (STRINGHASVALUE(DepartTime)) {
                departtime = [[self displayNSStringToDate:[TimeUtils displayDateWithJsonDate:DepartTime formatter:@"yyyy-MM-dd HH:mm"]] timeIntervalSince1970];
            }
            
            double arrivaltime = 0;
            if (STRINGHASVALUE(ArriveTime)) {
                arrivaltime = [[self displayNSStringToDate:[TimeUtils displayDateWithJsonDate:ArriveTime formatter:@"yyyy-MM-dd HH:mm"]] timeIntervalSince1970];
            }
            
            int transportminutes = (departtime - arrivaltime)/(60);
            
            int transporthours = transportminutes/60;
            
            NSString *stopInfoString = [NSString stringWithFormat:@"经停:%@",StopAirPortName];
            if (transporthours)
                stopInfoString = [NSString stringWithFormat:@"%@  %d小时%d分钟", stopInfoString, transporthours, transportminutes-transporthours*60];
            else
                stopInfoString = [NSString stringWithFormat:@"%@  %d分钟", stopInfoString, transportminutes];
            stopInfoLabel.text = stopInfoString;
            
            stopInfos = [[NSArray alloc] initWithObjects:StopOver, nil];
        }
        else {
            [self noStopInfoTip];
        }
        
		return;
    }
    
    if (util == couponUtil) {
        // 获取消费券
        [[Coupon activedcoupons] removeAllObjects];
        [[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
        
        [self goFillFlightOrder];
        
        return;
    }
    
	if (m_iState == 0) {//返航航班
		if ([[root safeObjectForKey:@"FlightList"] isEqual:[NSNull null]]) {
			NSArray *array = [[NSArray alloc] init];
			[root setValue:array forKey:@"FlightList"];
			[array release];
		}
        
        // 根据数量判断
        NSNumber *totalCountObj = [root safeObjectForKey:@"TotalCount"];
        if (totalCountObj != nil && [totalCountObj integerValue] > 0)
        {
//            NSDate *currentDate = [TimeUtils resetNSDate:[NSDate date] formatter:@"yyyy-MM-dd HH:mm"];
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
                
//                if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
//                    if (![self isFirstTimeMoreThan2Hours:[TimeUtils parseJsonDate:[subDic safeObjectForKey:KEY_DEPART_TIME]] secondTime:currentDate]) {
//                        continue;
//                    }
//                } else {
//                    if (![self isFirstTimeMoreThan2Hours:[TimeUtils parseJsonDate:[subDic safeObjectForKey:KEY_DEPART_TIME]] secondTime:goArriveTime]) {
//                        continue;
//                    }
//                }
                
                double oilTax = [[subDic safeObjectForKey:KEY_OIL_TAX] doubleValue];    // 燃油费
                int airTax = [[subDic safeObjectForKey:KEY_AIR_TAX] intValue];          // 税费
                
                Flight *flight = [[Flight alloc] init];
                flight.stopNumber = [[dict safeObjectForKey:@"StopNumber"] intValue];
                flight.isTransited = [[dict safeObjectForKey:@"IsTransited"] boolValue];
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
                flight.defaultCoupon = [subDic safeObjectForKey:KEY_DEFAULT_COUPON];    // 列表返现值
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
                
                //[flight setSiteseatArray:[subDic safeObjectForKey:KEY_SITES]];
                
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
                
                if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
                    [[FlightData getFArrayGo] addObject:flight];
                } else {
                    [[FlightData getFArrayReturn] addObject:flight];
                }
                [flight release];
            }
            
            FlightList *controller = [[FlightList alloc] initWithTopImagePath:@"" andTitle:@"返程航班" style:_NavNormalBtnStyle_];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
        else if (_isSelect51Book)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"往返产品均须为代理产品，您可以重选去程或者分开下单"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:nil];
			[alert show];
			[alert release];
        }
        
		
	}  else if(m_iState == 3){
		if([[root safeObjectForKey:@"IsCanBooking"] intValue]){
			
			BOOL islogin = [[AccountManager instanse] isLogin];
			//ElongClientAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
			
			if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) { //1=往返
				if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) { //0-去程
					[[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_RETURN_TRIP] forKey:KEY_CURRENT_FLIGHT_TYPE]; //设置去程为返程
					m_iState = 0;
					
					JFlightSearch *jFlightSearch = [FlightPostManager flightSearcher];
					[jFlightSearch setDepartCityName:[[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY] isClearData:YES];
					[jFlightSearch setArrivalCityName:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY] isClearData:NO];
					[jFlightSearch setDepartDate:[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_DATE] isClearData:NO];
					[jFlightSearch setClassType:[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_CLASS_TYPE] isClearData:NO];
                    
                    // 根据去程的产品类型来分开处理
                    [jFlightSearch setIsSearch51Book:[NSNumber numberWithBool:_isSelect51Book] isClearData:NO];
                    // 设置产品类型为51
                    if (_isSelect51Book)
                    {
                        [jFlightSearch setProductType:[NSNumber numberWithInt:4] isClearData:NO];
                    }
                    else
                    {
                        [jFlightSearch setProductType:[NSNumber numberWithInt:0] isClearData:NO];
                    }
                    
					[Utils request:FLIGHT_SERACH req:[jFlightSearch requesString:YES] delegate:self];
					
				} else { //1=返程
					if (islogin) {
                        [self goFillFlightOrder];
					} else {
						LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_FillFlightOrder_];
						[self.navigationController pushViewController:login animated:YES];
						[login release];
					}
				}
			} else {
				
				if (islogin) {
                    if ([[Coupon activedcoupons] count] == 0) {
                        // 预加载失败时，重新请求coupon
                        JCoupon *coupon = [MyElongPostManager coupon];
                        [[MyElongPostManager coupon] clearBuildData];
                        
                        if (couponUtil) {
                            [couponUtil cancel];
                            SFRelease(couponUtil);
                        }
                        couponUtil = [[HttpUtil alloc] init];
                        [couponUtil connectWithURLString:MYELONG_SEARCH Content:[coupon requesActivedCounponString:YES] Delegate:self];
                    }
                    else {
                        // 已经获取到coupon，直接进入填写订单页面
                        [self goFillFlightOrder];
                    }
				} else {
					LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_FillFlightOrder_];
					[self.navigationController pushViewController:login animated:YES];
					[login release];
				}
			}
		}else {
            [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithInt:DEFINE_GO_TRIP] forKey:KEY_CURRENT_FLIGHT_TYPE]; //重置为去程
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"对不起，您选择的航班刚刚被订完，不用着急，请选择其它航班" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
        
	}
	else {//机型介绍
		gotPlaneIntro = YES;
		
		[[FlightData getFDictionary] safeSetObject:[root safeObjectForKey:KEY_PLANE_PIC_URL] forKey:KEY_PLANE_PIC_URL];
		[[FlightData getFDictionary] safeSetObject:[root safeObjectForKey:KEY_PLANE_PIC_NAME] forKey:KEY_PLANE_PIC_NAME];
		[[FlightData getFDictionary] safeSetObject:[root safeObjectForKey:KEY_PLANE_PIC_INFO] forKey:KEY_PLANE_PIC_INFO];
		
		[self pushPlaneInfo];
	}
}

#pragma mark -
#pragma mark IBAction

- (IBAction)planeInfoButtonPressed
{
#if	FLIGHT_NOT_NETWORKED
	planeInfoButton.enabled = NO;
	[m_planeInfo showSelectTable:self];
#else
	if (!gotPlaneIntro) {
		m_iState = 1;
		if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
			int aIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
			Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:aIndex];
			JFlightPlaneTypeInfo *jFlightPlaneTypeInfo = [FlightPostManager flightPlaneTypeInfo];
			[jFlightPlaneTypeInfo setTypeCode:[flight getPlaneType] isClearData:NO];
			[Utils request:FLIGHT_SERACH req:[jFlightPlaneTypeInfo requesString:YES] delegate:self];
		} else {
			int aIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
			Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:aIndex];
			JFlightPlaneTypeInfo *jFlightPlaneTypeInfo = [FlightPostManager flightPlaneTypeInfo];
			[jFlightPlaneTypeInfo setTypeCode:[flight getPlaneType] isClearData:NO];
			[Utils request:FLIGHT_SERACH req:[jFlightPlaneTypeInfo requesString:YES] delegate:self];
		}
	}
	else {
		[self pushPlaneInfo];
	}
    
#endif
}

- (void)clickOrderButtonAtIndex:(NSInteger)index
{
    UMENG_EVENT(UEvent_Flight_Detail_Booking)
    
    // 选中是否51产品
    NSDictionary *spaceDic = [siteArray safeObjectAtIndex:index];   // 舱位信息
    NSNumber *ticketChannel = [spaceDic safeObjectForKey:@"TicketChannel"];
    if (ticketChannel != nil && [ticketChannel integerValue] == 4)
    {
        _isSelect51Book = YES;
    }
    else
    {
        _isSelect51Book = NO;
    }
    // 保存产品类型
    [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithBool:_isSelect51Book] forKey:KEY_IS51BOOK];
    
    // 保存是否为1小时飞人
    [[FlightData getFDictionary] safeSetObject:[NSNumber numberWithBool:_isOneHour] forKey:KEY_ISONEHOUR];
    
    
	//重新设置选中的舱位的价格，去程和返程的都设置
    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
        visitType = @"go";
        int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
        if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
            Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
			NSDictionary *currentType = [siteArray safeObjectAtIndex:index];
            [flight setPrice:[[currentType safeObjectForKey:KEY_PRICE] intValue]];
			[flight setPromotionID:[[currentType safeObjectForKey:@"PromotionId"] intValue]];
			[flight setClassTag:[currentType safeObjectForKey:KEY_CLASS_TAG]];
			[flight setTypeName:[currentType safeObjectForKey:KEY_TYPE_NAME]];
			[flight setDiscount:[[currentType safeObjectForKey:KEY_DISCOUNT] doubleValue]];
            flight.originalPrice = [NSString stringWithFormat:@"%@", [currentType safeObjectForKey:ORIGINAL_PRICE]];
            flight.shoppingOrderParams = [currentType safeObjectForKey:KEY_SHOPPINGORDERPARAMS];
            flight.ticketChannel = [currentType safeObjectForKey:KEY_TICKETCHANNEL];
            // 仓位价格明细
            NSDictionary *sitePriceDetail = [currentType safeObjectForKey:@"SiteItemPricesDetail"];
            if (sitePriceDetail != nil)
            {
                [flight setSitePricesDetail:sitePriceDetail];
            }
            
            // 是否是共享产品
            NSNumber *isSharedProduct = [currentType safeObjectForKey:@"IsSharedProduct"];
            if (isSharedProduct != nil)
            {
                [flight setIsSharedProduct:isSharedProduct];
            }
            
            NSDictionary *siteItemPrices = [currentType safeObjectForKey:@"SiteItemPrices"];
            if ([siteItemPrices count] > 0) {
                [flight setAdultPrice:[[siteItemPrices safeObjectForKey:@"AdultPrice"] doubleValue]];
                [flight setChildPrice:[[siteItemPrices safeObjectForKey:@"ChildPrice"] doubleValue]];
            }
            
            flight.currentCoupon = nil;
            // 取出返现金额
            NSDictionary *couponDic = [currentType safeObjectForKey:COUPON];
            if (DICTIONARYHASVALUE(couponDic)) {
                NSNumber *couponCount = [couponDic safeObjectForKey:AMOUNT];
                if ([couponCount isKindOfClass:[NSNumber class]]) {
                    flight.currentCoupon = couponCount;
                }
            }
			
            // 存储预定仓位的退改签规则
			NSDictionary *ruleDic = [[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_REGULATE_1] safeObjectAtIndex:index];
			flight.returnRule = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_RETURN_REGULATE]];
			flight.changeRule = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_CHANGE_REGULATE]];
            flight.signRule = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_CHANGE_SIGNRULE]];

            if (flight.isTransited) {
                // 如果是中转设置中转第二段退改签规则
                NSDictionary *tRuleDic = [[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_REGULATE_t] safeObjectAtIndex:index];
                flight.tReturnRule = [tRuleDic safeObjectForKey:KEY_RETURN_REGULATE];
                flight.tChangeRule = [tRuleDic safeObjectForKey:KEY_CHANGE_REGULATE];
            }
            
            if (flight.stopNumber > 0) {
                // 如果是经停，纪录经停时间
                flight.stopDescription = [NSString stringWithFormat:@"%@（%@）", [airportlabel.text substringFromIndex:3], timelabel.text];
                flight.stopInfos = stopInfos;
            }
			
			//*************验舱*******
			m_iState = 3;
			[flight buildPostData:YES];
			[flight.vertifyFlightClassDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY] forKey:@"DepartCityName"];
			[flight.vertifyFlightClassDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY] forKey:@"ArrivalCityName"];
			[flight.vertifyFlightClassDict safeSetObject:[TimeUtils makeJsonDateWithDisplayNSStringFormatter:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_DATE] formatter:@"yyyy-MM-dd"] forKey:@"DepartDate"];
			[flight.vertifyFlightClassDict safeSetObject:[flight getIsPromotion] forKey:@"IsPromotion"];
			[flight.vertifyFlightClassDict safeSetObject:[flight getIssueCityId] forKey:@"IssueCityId"];
			
			//NSArray *passengerArray = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
			[flight.vertifyFlightClassDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"PassengerCount"];
			
			NSMutableDictionary *classDict  = [[NSMutableDictionary alloc] init];
			[classDict safeSetObject:[flight getFlightNumber] forKey:@"FlightNumber"];
			[classDict safeSetObject:[flight getDepartAirportCode] forKey:@"DepartAirportCode"];
			[classDict safeSetObject:[flight getArriveAirportCode] forKey:@"ArriveAirportCode"];
			[classDict safeSetObject:[flight getDepartTime] forKey:@"DepartTime"];
			[classDict safeSetObject:[flight getAirCorpCode] forKey:@"AirCorpCode"];
			[classDict safeSetObject:[flight getClassTag] forKey:@"ClassTag"];
			[classDict safeSetObject:[flight getIsEticket] forKey:@"IsETicket"];
			[flight.vertifyFlightClassDict safeSetObject:[NSArray arrayWithObject:classDict] forKey:@"FlightClassList"];
			[classDict release];
			
			[Utils request:FLIGHT_SERACH req:[flight requesString:YES] delegate:self];
        }
        
    } else {
        visitType = @"back";
        int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
        if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil) {
            Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
            NSDictionary *currentType = [siteArray safeObjectAtIndex:index];
            [flight setPrice:[[currentType safeObjectForKey:KEY_PRICE] intValue]];
			[flight setPromotionID:[[currentType safeObjectForKey:@"PromotionId"] intValue]];
			[flight setClassTag:[currentType safeObjectForKey:KEY_CLASS_TAG]];
			[flight setTypeName:[currentType safeObjectForKey:KEY_TYPE_NAME]];
			[flight setDiscount:[[currentType safeObjectForKey:KEY_DISCOUNT] doubleValue]];
            flight.originalPrice = [NSString stringWithFormat:@"%@", [currentType safeObjectForKey:ORIGINAL_PRICE]];
            flight.shoppingOrderParams = [currentType safeObjectForKey:KEY_SHOPPINGORDERPARAMS];
            flight.ticketChannel = [currentType safeObjectForKey:KEY_TICKETCHANNEL];
            
            // 仓位价格明细
            NSDictionary *sitePriceDetail = [currentType safeObjectForKey:@"SiteItemPricesDetail"];
            if (sitePriceDetail != nil)
            {
                [flight setSitePricesDetail:sitePriceDetail];
            }
            
            // 是否是共享产品
            NSNumber *isSharedProduct = [currentType safeObjectForKey:@"IsSharedProduct"];
            if (isSharedProduct != nil)
            {
                [flight setIsSharedProduct:isSharedProduct];
            }
            
            NSDictionary *siteItemPrices = [currentType safeObjectForKey:@"SiteItemPrices"];
            if ([siteItemPrices count] > 0) {
                [flight setAdultPrice:[[siteItemPrices safeObjectForKey:@"AdultPrice"] doubleValue]];
                [flight setChildPrice:[[siteItemPrices safeObjectForKey:@"ChildPrice"] doubleValue]];
            }
            
            flight.currentCoupon = nil;
            // 取出返现金额
            NSDictionary *couponDic = [currentType safeObjectForKey:COUPON];
            if (DICTIONARYHASVALUE(couponDic)) {
                NSNumber *couponCount = [couponDic safeObjectForKey:AMOUNT];
                if ([couponCount isKindOfClass:[NSNumber class]]) {
                    flight.currentCoupon = couponCount;
                }
            }
			
			NSDictionary *ruleDic = [[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_REGULATE_1] safeObjectAtIndex:index];
			flight.returnRule = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_RETURN_REGULATE]];
			flight.changeRule = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_CHANGE_REGULATE]];
            flight.signRule = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_CHANGE_SIGNRULE]];
            
            if (flight.isTransited) {
                NSDictionary *tRuleDic = [[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_REGULATE_t] safeObjectAtIndex:index];
                flight.tReturnRule = [tRuleDic safeObjectForKey:KEY_RETURN_REGULATE];
                flight.tChangeRule = [tRuleDic safeObjectForKey:KEY_CHANGE_REGULATE];
            }
			
            if (flight.stopNumber > 0) {
                // 如果是经停，纪录经停时间
                flight.stopDescription = [NSString stringWithFormat:@"%@（%@）", [airportlabel.text substringFromIndex:3], timelabel.text];
                flight.stopInfos = stopInfos;
            }
            
			//*************验舱*******
			m_iState = 3;
			[flight buildPostData:YES];
			[flight.vertifyFlightClassDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY] forKey:@"DepartCityName"];
			[flight.vertifyFlightClassDict safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY] forKey:@"ArrivalCityName"];
			[flight.vertifyFlightClassDict safeSetObject:[TimeUtils makeJsonDateWithDisplayNSStringFormatter:[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_DATE] formatter:@"yyyy-MM-dd"] forKey:@"DepartDate"];
			[flight.vertifyFlightClassDict safeSetObject:[flight getIsPromotion] forKey:@"IsPromotion"];
			[flight.vertifyFlightClassDict safeSetObject:[flight getIssueCityId] forKey:@"IssueCityId"];
			
			[flight.vertifyFlightClassDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"PassengerCount"];
			
			NSMutableDictionary *classDict  = [[NSMutableDictionary alloc] init];
			[classDict safeSetObject:[flight getFlightNumber] forKey:@"FlightNumber"];
			[classDict safeSetObject:[flight getDepartAirportCode] forKey:@"DepartAirportCode"];
			[classDict safeSetObject:[flight getArriveAirportCode] forKey:@"ArriveAirportCode"];
			[classDict safeSetObject:[flight getDepartTime] forKey:@"DepartTime"];
			[classDict safeSetObject:[flight getAirCorpCode] forKey:@"AirCorpCode"];
			[classDict safeSetObject:[flight getClassTag] forKey:@"ClassTag"];
			[classDict safeSetObject:[flight getIsEticket] forKey:@"IsETicket"];
			[flight.vertifyFlightClassDict safeSetObject:[NSArray arrayWithObject:classDict] forKey:@"FlightClassList"];
			[classDict release];
			
			[Utils request:FLIGHT_SERACH req:[flight requesString:YES] delegate:self];
        }
    }
}


- (void)clickRuleButtonAtIndex:(NSInteger)index
{
    NSDictionary *spaceDic = [siteArray safeObjectAtIndex:index];   // 舱位信息
    
    // 舱位描述
    NSString *hTitle = [spaceDic safeObjectForKey:@"Highlight"];
    NSString *sTitle = [spaceDic safeObjectForKey:KEY_TYPE_NAME];
    BOOL isLegis = [[spaceDic safeObjectForKey:IS_LEGISLATION_PRICE] safeBoolValue];
    
    // 价格
    NSString *priceStr = [NSString stringWithFormat:@"¥%d", [[spaceDic safeObjectForKey:@"Price"] intValue]];
    
    // 退改签规则
    NSString *returnStr = nil;
    NSString *changeStr = nil;
    NSString *signStr = nil;
    NSArray *array = [[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_REGULATE_1];
    
    if ([array isKindOfClass:[NSArray class]] && index < [array count])
    {
        NSDictionary *ruleDic = [[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_REGULATE_1] safeObjectAtIndex:index];
        
        //退票规则
        returnStr = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_RETURN_REGULATE]];
        //改签规则
        changeStr = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_CHANGE_REGULATE]];
        // 签转规则
        signStr = [NSString stringWithFormat:@"%@", [ruleDic safeObjectForKey:KEY_CHANGE_SIGNRULE]];
    }
    
    BOOL orderEnable = YES;
    // 剩余票数`
    NSNumber *ticketCount = [spaceDic safeObjectForKey:@"TicketCount"];
    if (ticketCount != nil)
    {
        if ([ticketCount integerValue] > 0)
        {
            orderEnable = YES;
        }
        else    // 已售完仓位
        {
            orderEnable = NO;
        }
    }
    
    // 选中是否51产品
    BOOL isSelect51 = NO;
    NSNumber *ticketChannel = [spaceDic safeObjectForKey:@"TicketChannel"];
    if (ticketChannel != nil && [ticketChannel integerValue] == 4)
    {
        isSelect51 = YES;
    }
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    FlightDetailPopView *popView = [[FlightDetailPopView alloc] initWithHighLightTitle:hTitle
                                                                            spaceTitle:sTitle
                                                                    isLegislationPirce:isLegis
                                                                           ticketPrice:priceStr
                                                                                airTax:airTaxStr
                                                                                oilTax:oilTaxStr
                                                                      returnRegulation:returnStr
                                                                      changeRegulation:changeStr
                                                                              signRule:signStr
                                                                           orderEnable:orderEnable
                                                                              is51Book:isSelect51];
    popView.root = self;
    popView.rowNum = index;
    [appDelegate.window addSubview:popView];
    [popView release];
    
    UMENG_EVENT(UEvent_Flight_Detail_Rule)
}


// 更多规则按钮（或中转航班上半程的更多规则按钮）
-(void)moreChangeDetail:(UIButton*)sender
{
    if (!flightrule) {
        flightrule = [[FlightMoreRule alloc] init];
        [self.view addSubview:flightrule.view];
    }
    
	NSDictionary *ruleDic = [[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_REGULATE_1] safeObjectAtIndex:[sender tag]];
	[flightrule setReturnInfo:[ruleDic safeObjectForKey:KEY_RETURN_REGULATE] changeInfo:[ruleDic safeObjectForKey:KEY_CHANGE_REGULATE]];
	
	planeInfoButton.enabled = NO;
	[flightrule showSelectTable:self];
}

// 中转航班下半程的更多规则按钮
- (void)tMoreChangeDetail:(UIButton*)sender
{
    if (!flightrule) {
        flightrule = [[FlightMoreRule alloc] init];
        [self.view addSubview:flightrule.view];
    }
    
	NSDictionary *ruleDic = [[[FlightData getFDictionary] safeObjectForKey:KEY_RETURN_REGULATE_t] safeObjectAtIndex:[sender tag]];
	[flightrule setReturnInfo:[ruleDic safeObjectForKey:KEY_RETURN_REGULATE] changeInfo:[ruleDic safeObjectForKey:KEY_CHANGE_REGULATE]];
	
	planeInfoButton.enabled = NO;
	[flightrule showSelectTable:self];
}

- (void)back
{
	[super back];
	
	if (flightrule.isShow) {
		[flightrule dpViewLeftBtnPressed];
	}
	
    //	[flightrule performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
}

- (void)setTransUIForFight:(Flight *)flight
{
    // 暂时不支持中转机票
    //    transInfoView.hidden = NO;
    //    transAirportLabel.text = [NSString stringWithFormat:@"中转:%@", flight.tDepartAirPort];
    //
    //    NSString *stayTime = [PublicMethods getNormalTimeWithSeconds:[[TimeUtils parseJsonDate:flight.tDepartTime] timeIntervalSinceDate:[TimeUtils parseJsonDate:[flight getArriveTime]]] Format:@"DDHHmm"];
    //    transTimeLabel.text = [NSString stringWithFormat:@"停留%@", stayTime];
    //
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSDateComponents *arriveComponents = [calendar components:(NSDayCalendarUnit) fromDate:[TimeUtils parseJsonDate:[flight getArriveTime]]];
    //    NSDateComponents *departComponents = [calendar components:(NSDayCalendarUnit) fromDate:[TimeUtils parseJsonDate:flight.tDepartTime]];
    //    NSString *timePrefix = @"";
    //    if ([arriveComponents day] < [departComponents day] - 1) {
    //        // 中转出发日期大于中转到达多天的情况
    //        timePrefix = [TimeUtils displayDateWithJsonDate:flight.tDepartTime formatter:@"yyyy-MM-dd"];
    //    }
    //    else if ([arriveComponents day] == [departComponents day] - 1) {
    //        // 出发日期是下一天的情况
    //        timePrefix = @"次日";
    //    }
    //
    //    transDepartTimeLabel.text = [NSString stringWithFormat:@"%@  %@", timePrefix, [TimeUtils displayDateWithJsonDate:flight.tDepartTime formatter:@"HH:mm"]];
    //
    //    // 调整原有控件位置
    //    departcityLabel.frame = CGRectOffset(departcityLabel.frame, 0, -8);
    //    departTimeLabel.frame = CGRectMake(22,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               33, 63, 22);
    //    departTimehourLabel.frame = CGRectOffset(departTimehourLabel.frame, 0, 9);
    //    gateLabel.frame = CGRectMake(22, 78, 125, 19);
    //
    //    arrivecityLabel.frame = CGRectOffset(arrivecityLabel.frame, 0, -8);
    //    arrivalTimeLabel.frame = CGRectMake(236, 33, 63, 22);
    //    arriveTimehourLabel.frame = CGRectOffset(arriveTimehourLabel.frame, 0, 9);
    //    arrivegateLabel.frame = CGRectOffset(arrivegateLabel.frame, 0, 8);
    //
    //    departTitleLabel.frame = CGRectOffset(departTitleLabel.frame, 0, -8);
    //    arriveTitleLabel.frame = CGRectOffset(arriveTitleLabel.frame, 0, -8);
}

- (void)requestStopInfo
{
    // 请求经停信息, 并调整相关页面显示
    [stopInfoLabel startLoadingByStyle:UIActivityIndicatorViewStyleGray];
    detaiTable.frame = CGRectMake(0, 123, SCREEN_WIDTH, MAINCONTENTHEIGHT - 123);
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    
    NSArray *flightDataArray = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP ? [FlightData getFArrayGo] : [FlightData getFArrayReturn];
    Flight *flighttemp =  [flightDataArray safeObjectAtIndex:parentvcselectedindex];
    [FlightData setCurrentIndex:parentvcselectedindex];
    [dict safeSetObject:[flighttemp getDepartAirportCode] forKey:@"DeparturePortCode"];
    [dict safeSetObject:[flighttemp getDepartTime] forKey:@"DepartureTime"];
    [dict safeSetObject:[flighttemp getArriveAirportCode] forKey:@"DestinationPortCode"];
    [dict safeSetObject:[flighttemp getFlightNumber] forKey:@"FlightNumber"];
    
    JPostHeader *postheader=[[JPostHeader alloc] init];
    transportUtil = [[HttpUtil alloc] init];
    [transportUtil connectWithURLString:FLIGHT_SERACH
                                Content:[postheader requesString:YES action:@"GetStopInfos" params:dict]
                           StartLoading:NO
                             EndLoading:NO
                               Delegate:self];
    
    [dict release];
    [postheader release];
}

//初始化舱位数据
- (void)intData:(Flight *)flight
{
    
	NSString *departCity;
	NSString *arrivalCity;
    //出发航班
	if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
		// 去程
		departCity  = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY];
		arrivalCity = [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY];
		
		// 航站楼
		NSString *gateStr = [[FlightData getFDictionary] safeObjectForKey:KEY_TERMINAL_1];
		
        if (![gateStr isEqual:[NSNull null]])
        {
			gateLabel.text = gateStr;
		}
        else
        {
            gateLabel.text = @"";
        }
        
		NSString *arriveGateStr = [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_TERMINAL_1];
		if (![arriveGateStr isEqual:[NSNull null]])
        {
			arrivegateLabel.text = arriveGateStr;
		}
        else
        {
            arrivegateLabel.text = @"";
        }
	}
    //到达航班
	else {
		// 返程
		departCity  = [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_CITY];
		arrivalCity = [[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY];
		
		// 航站楼
		NSString *gateStr = [[FlightData getFDictionary] safeObjectForKey:KEY_TERMINAL_2];
		if (![gateStr isEqual:[NSNull null]]) {
			gateLabel.text = gateStr;
		}
        else
        {
            gateLabel.text = @"";
        }
        
		NSString *arriveGateStr = [[FlightData getFDictionary] safeObjectForKey:KEY_ARRIVE_TERMINAL_2];
		if (![arriveGateStr isEqual:[NSNull null]]) {
			arrivegateLabel.text = arriveGateStr;
		}
        else
        {
            arrivegateLabel.text = @"";
        }
	}
	
	//上部的出发和到达城市的位置和数据设定
	if ([departCity length]== 2) {
		NSString* first = [departCity substringToIndex:1];
		NSString* second = [departCity substringFromIndex:1];
		departcityLabel.text = [NSString stringWithFormat:@"%@   %@",first,second];
	}
	else {
		departcityLabel.text = departCity;
	}
	
	if ([arrivalCity length] == 2) {
		NSString* first = [arrivalCity substringToIndex:1];
		NSString* second = [arrivalCity substringFromIndex:1];
		arrivecityLabel.text = [NSString stringWithFormat:@"%@   %@",first,second];
	}
	else {
		arrivecityLabel.text = arrivalCity;
	}
    
    if (flight.isTransited) {
        // 中转航班改变布局
        [self setTransUIForFight:flight];
    }
	
	//飞机舱位的全部数据
	siteArray = [flight getSiteseatArray];
    self.airTaxStr = [NSString stringWithFormat:@"¥%d", [[flight getAirTax] intValue]];
    self.oilTaxStr = [NSString stringWithFormat:@"¥%d", [[flight getOilTax] intValue]];
    
	NSString* departtime = [TimeUtils displayDateWithJsonDate:[flight getDepartTime] formatter:@"yyyy年MM月dd日 HH:mm"];
    
	NSString* arrivetime = [TimeUtils displayDateWithJsonDate:flight.isTransited ? flight.tArrivalTime : [flight getArriveTime] formatter:@"yyyy-MM-dd HH:mm"];
	
	departTimeLabel.text = [departtime substringToIndex:11];
    
	arrivalTimeLabel.text=[arrivetime substringToIndex:10];
	
	departTimehourLabel.text =[departtime substringFromIndex:11];
	
	arriveTimehourLabel.text = [arrivetime substringFromIndex:11];
	
	planeTypeLabel.text = [NSString stringWithFormat:@"机型：%@", [flight getPlaneType]];
    
}

#pragma mark -
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[FlightData getFDictionary] safeSetObject:[NSNull null] forKey:KEY_PLANE_PIC];   // 清空上次的机型图片
	self.view.clipsToBounds = YES;
	gotPlaneIntro = NO;
    visitType = @"go";//初始化访问航班类型为去程
    
    m_srollDataArray = [[NSMutableArray alloc] init];
	
	//data
	if ([[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_TYPE] intValue] == DEFINE_GO_TRIP) {
		int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue];
		if ([[FlightData getFArrayGo] count] > 0 && [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex] != nil) {
			Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:arrayIndex];
			[self intData:flight];
		}
		
	} else {
		int arrayIndex = [[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue];
		if ([[FlightData getFArrayReturn] count] > 0 && [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex] != nil) {
			Flight *flight = [[FlightData getFArrayReturn] safeObjectAtIndex:arrayIndex];
			[self intData:flight];
		}
	}
    
    // 是否是一小时飞人航班
    if (_isOneHour)
    {
        viewOneHourHint.hidden = NO;
        bottomLine.hidden = NO;
        [detaiTable setViewY:detaiTable.frame.origin.y+33];
        [detaiTable setViewHeight:detaiTable.frame.size.height-33];
        
        // 添加1小时飞人提示
        NSString *oneHourTip = @"为了保证顺利登机，请务必在起飞前50分钟内完成预订。";
        
        UIFont *tipFont = [UIFont fontWithName:@"STHeitiJ-Light" size:12.0f];
        CGSize tipSize = [oneHourTip sizeWithFont:tipFont];
        
        // 创建Label
        AttributedLabel *labelOneHourTip = [[AttributedLabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-tipSize.width)/2, 12, tipSize.width, tipSize.height) wrapped:NO];
        [labelOneHourTip setText:oneHourTip];
        [labelOneHourTip setBackgroundColor:[UIColor clearColor]];
        [labelOneHourTip setTextColor:RGBACOLOR(39, 39, 39, 1)];
        [labelOneHourTip setFont:tipFont fromIndex:0 length:[oneHourTip length]];
        [labelOneHourTip setColor:RGBACOLOR(248, 132, 31, 1) fromIndex:13 length:8];
        
        // 保存
        [viewOneHourHint addSubview:labelOneHourTip];
        [labelOneHourTip release];
    }
    else
    {
        viewOneHourHint.hidden = YES;
        bottomLine.hidden = YES;
    }
	
    [self screenFit];
}

- (void)screenFit
{
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    if (transportUtil)
    {
        [transportUtil cancel];
        SFRelease(transportUtil);
    }
    
    if (couponUtil)
    {
        [couponUtil cancel];
        SFRelease(couponUtil);
    }
    
    [m_srollDataArray release];
	[flightrule release];
	[airlinesIconImageView release];
	[airlinesLabel release];
	[departTimeLabel release];
	[arrivalTimeLabel release];
	[gateLabel release];
	[planeTypeLabel release];
	[planeInfoButton release];
    [dashLine release];
	[transInfoView release];
    [transAirportLabel release];
    [transTimeLabel release];
    [transDepartTimeLabel release];
    [departTitleLabel release];
    [arriveTitleLabel release];
    [stopInfos release];
    
    self.oilTaxStr = nil;
    self.airTaxStr = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark UITableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [siteArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    FlightDetailCell *cell = (FlightDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [FlightDetailCell cellFromNib];
        cell.root = self;
    }
    
    cell.rowNum = indexPath.row;
    NSDictionary *spaceDic = [siteArray safeObjectAtIndex:indexPath.row];   // 舱位信息
    
    // 舱位描述
    [cell setHighlightSpaceTitle:[spaceDic safeObjectForKey:@"Highlight"]];
    [cell setSpaceTitle:[spaceDic safeObjectForKey:KEY_TYPE_NAME]];
    
    // 价格和返现\立减
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%d", [[spaceDic safeObjectForKey:@"Price"] intValue]];
    NSDictionary *couponDic = [spaceDic safeObjectForKey:COUPON];
    if (DICTIONARYHASVALUE(couponDic)) {
        NSNumber *couponNum = [couponDic safeObjectForKey:AMOUNT];
        [cell setCouponValue:[NSString stringWithFormat:@"%@", couponNum]];
    }
    else {
        cell.couponIcon.hidden = YES;
        cell.couponLabel.text = @"";
    }
    
    if ([[spaceDic safeObjectForKey:IS_LEGISLATION_PRICE] safeBoolValue])
    {
        // 机票立减布局
        NSInteger originPrice = [[spaceDic safeObjectForKey:ORIGINAL_PRICE] safeDoubleValue];
        
        [cell setDiscountModel:YES WithOriginPrice:[NSString stringWithFormat:@"%d", originPrice]];
    }
    else
    {
        // 机票非立减布局
        [cell setDiscountModel:NO WithOriginPrice:nil];
    }
    
    // 51产品
    NSNumber *ticketChannel = [spaceDic safeObjectForKey:@"TicketChannel"];
    if (ticketChannel != nil && [ticketChannel integerValue] == 4)
    {
        cell.netPromotionIcon.hidden = NO;
    }
    else
    {
        cell.netPromotionIcon.hidden = YES;
    }
    
    // 票量情况
    NSString* ticket = [spaceDic safeObjectForKey:KEY_REMAINTICKETSTATE];
    if ([ticket isEqualToString:@"A"] || [ticket integerValue] >= 6)
    {
        cell.remainTicketStateLabel.text = @"";
    }
    else if ([ticket isEqualToString:@"0"])
    {
        cell.remainTicketStateLabel.text = @"已售完";
    }
    else if ([ticket integerValue] < 6)
    {
        cell.remainTicketStateLabel.text = [NSString stringWithFormat:@"仅剩%d张", [ticket integerValue]];
    }
    else
    {
        cell.remainTicketStateLabel.text = @"";
    }
    
    
    
    // 票数
    NSNumber *ticketCount = [spaceDic safeObjectForKey:@"TicketCount"];
    if (ticketCount != nil)
    {
        if ([ticketCount integerValue] > 0)
        {
            cell.backgroundColor = RGBACOLOR(254, 254, 254, 1.0);
            cell.remainTicketStateLabel.text = @"";
            cell.priceLabel.textColor = RGBACOLOR(249, 76, 21, 1.0);
            cell.priceLabel.highlightedTextColor = RGBACOLOR(249, 76, 21, 1.0);
            cell.orderBtn.enabled = YES;
        }
        else    // 已售完航线
        {
            cell.backgroundColor = RGBACOLOR(237, 237, 237, 1.0);
            cell.remainTicketStateLabel.text = @"已售完";
            cell.priceLabel.textColor = [UIColor lightGrayColor];
            cell.priceLabel.highlightedTextColor = [UIColor lightGrayColor];
            cell.orderBtn.enabled = NO;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *spaceDic = [siteArray safeObjectAtIndex:indexPath.row];   // 舱位信息
    
    // 票数
    NSNumber *ticketCount = [spaceDic safeObjectForKey:@"TicketCount"];
    if (ticketCount != nil && [ticketCount integerValue] > 0)
    {
        [self clickOrderButtonAtIndex:indexPath.row];
    }
}


@end
