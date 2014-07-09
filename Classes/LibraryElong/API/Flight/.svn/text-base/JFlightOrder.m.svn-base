//
//  JFlightOrder.m
//  ElongClient
//
//  Created by dengfang on 11-3-3.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "JFlightOrder.h"
#import "FlightDataDefine.h"

#import "PostHeader.h"
#import "AccountManager.h"
#import "StringEncryption.h"
#import "PostHeader.h"
#import "DefineCommon.h"
#import "Coupon.h"
#import "ElongInsurance.h"

@implementation JFlightOrder

- (void)dealloc {
    [mDictionary release];
    
    [super dealloc];
}


- (void)buildPostData:(BOOL)clearFlightOrder {
	if (clearFlightOrder) {
		[mDictionary safeSetObject:[PostHeader header] forKey:Resq_Header];
		[mDictionary safeSetObject:[PublicMethods getUserElongCardNO] forKey:KEY_CARD_NO];
		[mDictionary safeSetObject:@"" forKey:KEY_MEMO];		
		[mDictionary safeSetObject:[NSNumber numberWithDouble:0] forKey:KEY_TOTAL_PRICE];
		[mDictionary safeSetObject:@"" forKey:KEY_ISSUE_CITY_NAME];
		[mDictionary safeSetObject:@"" forKey:KEY_CONTACTOR_NAME];
		[mDictionary safeSetObject:@"" forKey:KEY_CONTACT_MOBILE];
		[mDictionary safeSetObject:[NSNull null] forKey:KEY_DELIVERY_INFO];
		[mDictionary safeSetObject:[NSNull null] forKey:KEY_CREDIT_CARD];
		[mDictionary safeSetObject:[NSNull null] forKey:KEY_FLIGHT_CLASS_LIST];
		[mDictionary safeSetObject:[NSNull null] forKey:KEY_PASSENGER_LIST];
		[mDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:@"PayMethod"];
        [mDictionary safeSetObject:[[Coupon activedcoupons] safeObjectAtIndex:0] forKey:@"UsableCoupon"];         // 用户可用coupon数
	}
}


- (id)init {
    self = [super init];
    if (self) {
		mDictionary = [[NSMutableDictionary alloc] init];
		[self buildPostData:YES];
	}
	return self;
}

- (id)getObject:(NSString *)key {
	return [mDictionary safeObjectForKey:key];
}


-(void) setPayMethod{
    [mDictionary safeSetObject:[NSNumber numberWithInt:1] forKey:@"PayMethod"];
}

// 现金账户
- (void)setCashAmount:(CGFloat)cashNum
{
    [mDictionary safeSetObject:[NSString stringWithFormat:@"%.2f", cashNum] forKey:CASHAMOUNT];
}

- (NSNumber *)getCashAmount
{
    return [mDictionary safeObjectForKey:CASHAMOUNT];
}

-(void) setPaymentOrder{
    [mDictionary safeSetObject:[PublicMethods getUserElongCardNO] forKey:KEY_CARD_NO];
	[mDictionary safeSetObject:@"" forKey:KEY_MEMO];
	[self setTotalPrice];
	
	[mDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY] forKey:KEY_ISSUE_CITY_NAME];
    NSMutableDictionary *dict = (NSMutableDictionary *)[[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] safeObjectAtIndex:0];
    NSString *contactName = [dict safeObjectForKey:KEY_NAME];
    [mDictionary safeSetObject:contactName forKey:KEY_CONTACTOR_NAME];
	//[mDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_CONTACT_NAME] forKey:KEY_CONTACTOR_NAME];
	[mDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_CONTACT_TEL] forKey:KEY_CONTACT_MOBILE];
	[self setDeliveryInfo];
    [self setPayMethod];
	[self setFlightClassList];
	[self setPassengerList];
    [self setInsuranceList];
}

- (void)setOrderDictionary:(NSDictionary *)cardDict {
	[mDictionary safeSetObject:[PublicMethods getUserElongCardNO] forKey:KEY_CARD_NO];
	[mDictionary safeSetObject:@"" forKey:KEY_MEMO];
	[self setTotalPrice];
	
	[mDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_DEPART_CITY] forKey:KEY_ISSUE_CITY_NAME];
    //第一名乘机人信息作为联系人姓名
    NSMutableDictionary *dict = (NSMutableDictionary *)[[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] safeObjectAtIndex:0];
    NSString *contactName = [dict safeObjectForKey:KEY_NAME];
    [mDictionary safeSetObject:contactName forKey:KEY_CONTACTOR_NAME];
	//[mDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_CONTACT_NAME] forKey:KEY_CONTACTOR_NAME];
	[mDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_CONTACT_TEL] forKey:KEY_CONTACT_MOBILE];
	[self setDeliveryInfo];
	[self setCreditCard:cardDict];
	[self setFlightClassList];
	[self setPassengerList];
    [self setInsuranceList];
    [self setInvoiceInfo];
}

// 发票信息
- (void)setInvoiceInfo
{
    NSString *invoiceTitle = [[FlightData getFDictionary] safeObjectForKey:KEY_INVOICETITLE];
    if (STRINGHASVALUE(invoiceTitle))
    {
        NSMutableDictionary *dicInvoiceInfo = [[NSMutableDictionary alloc] init];
        [dicInvoiceInfo safeSetObject:invoiceTitle forKey:@"Title"];
        
        [mDictionary safeSetObject:dicInvoiceInfo forKey:KEY_INVOICEINFO];
        [dicInvoiceInfo release];
    }
}

- (void)setTotalPrice { //double
	[self buildPostData:NO];
    
//	double price = 0;
//    NSInteger insuranceCount = 1;
//	if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
//		Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
//		price = ([[flight1 getPrice] intValue] +[[flight1 getOilTax] doubleValue] +[[flight1 getAirTax] intValue]);
//		
//	} else {
//		Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
//		Flight *flight2 = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
//		price = ([[flight1 getPrice] intValue] +[[flight1 getOilTax] doubleValue] +[[flight1 getAirTax] intValue])
//				+([[flight2 getPrice] intValue] +[[flight2 getOilTax] doubleValue] +[[flight2 getAirTax] intValue]);
//        insuranceCount = 2;
//	}
//	int pCount = [[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count];
    
    int insuranceCount = 1;
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

    double price = 0;
    if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
        Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
//            price = ([[flight1 getPrice] intValue] +[[flight1 getOilTax] doubleValue] +[[flight1 getAirTax] intValue]);

        price = ([[flight1 getAdultPrice] floatValue] + [[flight1 getAdultOilTax] floatValue] + [[flight1 getAdultAirTax] floatValue]) * adultCount + ([[flight1 getChildPrice] floatValue] + [[flight1 getChildOilTax] floatValue] + [[flight1 getChildAirTax] floatValue]) * childCount;

    } else {
        insuranceCount = 2;
        Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
        Flight *flight2 = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
//            price = ([[flight1 getPrice] intValue] +[[flight1 getOilTax] doubleValue] +[[flight1 getAirTax] intValue])
//            +([[flight2 getPrice] intValue] +[[flight2 getOilTax] doubleValue] +[[flight2 getAirTax] intValue]);
        price = ([[flight1 getAdultPrice] floatValue] + [[flight1 getAdultOilTax] floatValue] + [[flight1 getAdultAirTax] floatValue]) * adultCount + ([[flight1 getChildPrice] floatValue] + [[flight1 getChildOilTax] floatValue] + [[flight1 getChildAirTax] floatValue]) * childCount;
        price += ([[flight2 getAdultPrice] floatValue] + [[flight2 getAdultOilTax] floatValue] + [[flight2 getAdultAirTax] floatValue]) * adultCount + ([[flight2 getChildPrice] floatValue] + [[flight2 getChildOilTax] floatValue] + [[flight2 getChildAirTax] floatValue]) * childCount;
    }
//        int pCount = [[[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST] count];

//        float totalPrice = price * pCount + [[[ElongInsurance shareInstance] getSalePrice] doubleValue] * [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * insuranceCount;
    float totalPrice = price + [[[ElongInsurance shareInstance] getSalePrice] doubleValue] * [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * insuranceCount;
    
    
    
    [mDictionary safeSetObject:[NSNumber numberWithDouble:totalPrice] forKey:KEY_TOTAL_PRICE];
    // Add insurance price.
//	[mDictionary safeSetObject:[NSNumber numberWithDouble:price *pCount] forKey:KEY_TOTAL_PRICE];
//    [mDictionary safeSetObject:[NSNumber numberWithDouble:price * pCount + [[[ElongInsurance shareInstance] getSalePrice] doubleValue] * [[[ElongInsurance shareInstance] getInsuranceCount] integerValue] * insuranceCount] forKey:KEY_TOTAL_PRICE];
}

- (void)setDeliveryInfo {
	[self buildPostData:NO];
	NSMutableDictionary *diDictionary = [[[NSMutableDictionary alloc] init] autorelease];
	[diDictionary safeSetObject:[NSNumber numberWithInt:[[[FlightData getFDictionary] safeObjectForKey:KEY_TICKET_GET_TYPE] intValue]] forKey:KEY_TICKET_GET_TYPE];
	switch ([[[FlightData getFDictionary] safeObjectForKey:KEY_TICKET_GET_TYPE] intValue]) {
		case DEFINE_POST_TYPE_NOT_NEED: {
//			"DeliveryInfo":{"TicketGetType":0,"Memo":"","Address":null,"SelfGetAddressID":0,"SelfGetAddress":null,"SelfGetTime":"\/Date(-62135596800000+0800)\/"},"
			[diDictionary safeSetObject:@"" forKey:KEY_MEMO];
			[diDictionary safeSetObject:[NSNull null] forKey:KEY_ADDRESS];
			[diDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_SELF_GET_ADDRESS_ID];
			[diDictionary safeSetObject:[NSNull null] forKey:@"SelfGetAddress"];
			Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
			[diDictionary safeSetObject:[flight getTimeOfLastIssued] forKey:KEY_SELF_GET_TIME];
		}
			break;
		case DEFINE_POST_TYPE_POST: {
			[diDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_TICKET_GET_TYPE_MEMO] forKey:KEY_MEMO];
			NSMutableDictionary *diADictionary = [[[NSMutableDictionary alloc] init] autorelease];
			[diADictionary safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_ID];
			[diADictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ADDRESS_CONTENT] forKey:KEY_ADDRESS_CONTENT];
			[diADictionary safeSetObject:DEFAULTPOSTCODEVALUE forKey:KEY_POSTCODE];
			[diADictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
			[diADictionary safeSetObject:@"" forKey:KEY_PHONE_NO];
			[diDictionary safeSetObject:diADictionary forKey:KEY_ADDRESS];
		}
			break;
		case DEFINE_POST_TYPE_SELF_GET: {
//			"DeliveryInfo":{"TicketGetType":2,"Memo":"","Address":null,"SelfGetAddressID":0,"SelfGetAddress":"方法","SelfGetTime":"\/Date(1300815660000+0800)\/"},"
			[diDictionary safeSetObject:@"" forKey:KEY_MEMO];
			[diDictionary safeSetObject:[NSNull null] forKey:KEY_ADDRESS]; 
			[diDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_ADDRESS_NAME] forKey:@"SelfGetAddress"];
			[diDictionary safeSetObject:[[FlightData getFDictionary] safeObjectForKey:KEY_SELF_GET_ADDRESS_ID] forKey:KEY_SELF_GET_ADDRESS_ID];
			Flight *flight = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
			[diDictionary safeSetObject:[flight getTimeOfLastIssued] forKey:KEY_SELF_GET_TIME];
		}
			break;
	}
	[mDictionary safeSetObject:diDictionary forKey:KEY_DELIVERY_INFO];
}

- (void)setCreditCard:(NSDictionary *)data
{
    if (data != nil)
    {
        [self buildPostData:NO];
        NSMutableDictionary *creditCardContents=[[NSMutableDictionary alloc] init];
        [creditCardContents safeSetObject:[PublicMethods getUserElongCardNO] forKey:@"ElongCardNo"];
        [creditCardContents safeSetObject:[data safeObjectForKey:@"CreditCardType"]  forKey:@"CreditCardType"];
        [creditCardContents safeSetObject:[data safeObjectForKey:@"CreditCardNumber"]  forKey:@"CreditCardNumber"];
        [creditCardContents safeSetObject:[data safeObjectForKey:@"HolderName"] forKey:@"HolderName"];
        [creditCardContents safeSetObject:[data safeObjectForKey:@"VerifyCode"]  forKey:@"VerifyCode"];
        [creditCardContents safeSetObject:[data safeObjectForKey:@"CertificateType"]  forKey:@"CertificateType"];
        [creditCardContents safeSetObject:[data safeObjectForKey:@"CertificateNumber"] forKey:@"CertificateNumber"];
        //	[creditCardContents safeSetObject:[StringEncryption DecryptString:[data safeObjectForKey:@"CertificateNumber"]] forKey:@"CertificateNumber"];
        [creditCardContents safeSetObject:[data safeObjectForKey:@"ExpireYear"]  forKey:@"ExpireYear"];
        [creditCardContents safeSetObject:[data safeObjectForKey:@"ExpireMonth"]  forKey:@"ExpireMonth"];
        [mDictionary safeSetObject:creditCardContents forKey:KEY_CREDIT_CARD];
        [creditCardContents release];
    }
	
}

- (void)setFlightClassList {
	[self buildPostData:NO];
	NSMutableArray *flightArray = [[NSMutableArray alloc] init];
	
    // 去程设置
	Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
	NSMutableDictionary *flightDict1 = [[NSMutableDictionary alloc] init];
	
	[flightDict1 safeSetObject:[flight1 getIsEticket] forKey:KEY_IS_ETICKET];
	[flightDict1 safeSetObject:flight1.originalPrice forKey:KEY_SALEPRICE];         
    [flightDict1 safeSetObject:[flight1 getTimeOfLastIssued] forKey:KEY_TIME_OF_LAST_ISSUES];
    [flightDict1 safeSetObject:[flight1 getIssueCityId] forKey:KEY_ISSUE_CITY_ID];
    [flightDict1 safeSetObject:[flight1 getPromotionID] forKey:KEY_FAREITEM_ID];
    [flightDict1 safeSetObject:[flight1 getDiscount] forKey:KEY_DISCOUNT];
    [flightDict1 safeSetObject:[NSNumber numberWithInt:flight1.stopNumber] forKey:KEY_STOPS];
    [flightDict1 safeSetObject:[NSNumber numberWithBool:flight1.isTransited] forKey:KEY_ISTRANSITED];
    [flightDict1 safeSetObject:flight1.currentCoupon forKey:COUPON];
	[flightDict1 safeSetObject:@"" forKey:KEY_RESTRICTION];
    
    CGFloat tax = [[flight1 getOilTax] doubleValue] + [[flight1 getAirTax] intValue]/1.0;
    [flightDict1 safeSetObject:[NSNumber numberWithDouble:tax] forKey:KEY_TAX];
    
    NSInteger legislationPrice = [flight1.originalPrice intValue] - [[flight1 getPrice] intValue];
    [flightDict1 safeSetObject:[NSNumber numberWithInt:legislationPrice] forKey:LEGISLATION_PRICE];
    
    NSMutableArray *airSegment = [NSMutableArray arrayWithCapacity:2];
    NSMutableDictionary *goDic = [NSMutableDictionary dictionaryWithCapacity:2];
    [goDic safeSetObject:[flight1 getFlightNumber] forKey:KEY_FLIGHT_NUMBER];
    [goDic safeSetObject:[flight1 getClassTag] forKey:KEY_FLIGHTCLASS];
    [goDic safeSetObject:[flight1 getAirCorpCode] forKey:KEY_AIR_CORP_CODE];
    [goDic safeSetObject:[flight1 getDepartTime] forKey:KEY_DEPART_TIME];
    [goDic safeSetObject:[flight1 getArriveTime] forKey:KEY_ARRIVE_TIME];
    [goDic safeSetObject:[flight1 getDepartAirportCode] forKey:KEY_DEPART_AIRPORT_CODE];
	[goDic safeSetObject:[flight1 getArriveAirportCode] forKey:KEY_ARRIVE_AIRPORT_CODE];
    [goDic safeSetObject:[flight1 getPlaneType] forKey:KEY_PLANE_TYPE];
    [goDic safeSetObject:[flight1 getKilometers] forKey:KEY_KILOMETERS];
    if (ARRAYHASVALUE(flight1.stopInfos)) {
        [goDic safeSetObject:flight1.stopInfos forKey:KEY_STOPINFOS];
    }
    
    [airSegment addObject:goDic];
    
    if(flight1.isTransited) {
        NSMutableDictionary *goDic_t = [NSMutableDictionary dictionaryWithCapacity:2];
        [goDic_t safeSetObject:flight1.tFlightNum forKey:KEY_FLIGHT_NUMBER];
        [goDic_t safeSetObject:[flight1 getClassTag] forKey:KEY_FLIGHTCLASS];
        [goDic_t safeSetObject:flight1.tAirCorpCode forKey:KEY_AIR_CORP_CODE];
        [goDic_t safeSetObject:flight1.tDepartTime forKey:KEY_DEPART_TIME];
        [goDic_t safeSetObject:flight1.tArrivalTime forKey:KEY_ARRIVE_TIME];
        [goDic_t safeSetObject:flight1.tDepartAirPortCode forKey:KEY_DEPART_AIRPORT_CODE];
        [goDic_t safeSetObject:flight1.tArrivalAirPortCode forKey:KEY_ARRIVE_AIRPORT_CODE];
        [goDic_t safeSetObject:flight1.tAirFlightType forKey:KEY_PLANE_TYPE];
        [goDic_t safeSetObject:[flight1 getKilometers] forKey:KEY_KILOMETERS];
        [airSegment addObject:goDic_t];
    }
    
    // 去程shopping 产品
    NSString *shoppingOrderParams = flight1.shoppingOrderParams;
    NSNumber *ticketChannel = flight1.ticketChannel;
    if (shoppingOrderParams &&
        ticketChannel)
    {
        [flightDict1 safeSetObject:shoppingOrderParams forKey:KEY_SHOPPINGORDERPARAMS];
        [flightDict1 safeSetObject:ticketChannel forKey:KEY_TICKETCHANNEL];
    }
    
    [flightDict1 safeSetObject:airSegment forKey:KEY_AIRSEGMENTS];
    
    // 	仓位价格信息
    NSDictionary *salePricesDetail = [flight1 sitePricesDetail];
    if (salePricesDetail != nil)
    {
        [flightDict1 safeSetObject:salePricesDetail forKey:KEY_SALEPRICEDETAIL];
    }
    
    // 是否共享产品
    NSNumber *isSharedProduct = [flight1 isSharedProduct];
    if (isSharedProduct != nil)
    {
        [flightDict1 safeSetObject:isSharedProduct forKey:KEY_ISSHAREDPRODUCT];
    }
    
    // 是否1小时飞人
    NSNumber *isOneHourObj = [flight1 isOneHour];
    if (isOneHourObj != nil)
    {
        [flightDict1 safeSetObject:isOneHourObj forKey:KEY_ISONEHOUR];
    }
    
    // Add 2014/02/21.
    [flightDict1 safeSetObject:@{@"AdultOilTax":[flight1 getAdultOilTax], @"AdultAirTax":[flight1 getAdultAirTax], @"ChildOilTax":[flight1 getChildOilTax], @"ChildAirTax":[flight1 getChildAirTax]} forKey:KEY_FLIGHT_TAXS];
    [flightDict1 safeSetObject:@{@"AdultPrice":[flight1 getAdultPrice], @"ChildPrice":[flight1 getChildPrice]} forKey:KEY_SALE_PRICES];
    // End
    
	[flightArray addObject:flightDict1];
	[flightDict1 release];
    
    // ==================================================================================================
	
	if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_ROUND_TRIP) {
        // 返程设置
		Flight *flight2 = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
		NSMutableDictionary *flightDict2 = [[NSMutableDictionary alloc] init];
		[flightDict2 safeSetObject:[flight2 getIsEticket] forKey:KEY_IS_ETICKET];
        [flightDict2 safeSetObject:flight2.originalPrice forKey:KEY_SALEPRICE];
        [flightDict2 safeSetObject:[flight2 getTimeOfLastIssued] forKey:KEY_TIME_OF_LAST_ISSUES];
        [flightDict2 safeSetObject:[flight1 getIssueCityId] forKey:KEY_ISSUE_CITY_ID];
        [flightDict2 safeSetObject:[flight2 getPromotionID] forKey:KEY_FAREITEM_ID];
        [flightDict2 safeSetObject:[flight2 getDiscount] forKey:KEY_DISCOUNT];
        [flightDict2 safeSetObject:[NSNumber numberWithInt:flight2.stopNumber] forKey:KEY_STOPS];
        [flightDict2 safeSetObject:[NSNumber numberWithBool:flight2.isTransited] forKey:KEY_ISTRANSITED];
        [flightDict2 safeSetObject:flight2.currentCoupon forKey:COUPON];
        [flightDict2 safeSetObject:@"" forKey:KEY_RESTRICTION];
        
        CGFloat tax = [[flight2 getOilTax] doubleValue] + [[flight2 getAirTax] intValue]/1.0;
        [flightDict2 safeSetObject:[NSNumber numberWithDouble:tax] forKey:KEY_TAX];
        
        NSInteger legislationPrice = [flight2.originalPrice intValue] - [[flight2 getPrice] intValue];
        [flightDict2 safeSetObject:[NSNumber numberWithInt:legislationPrice] forKey:LEGISLATION_PRICE];
        
        NSMutableArray *rAirSegment = [NSMutableArray arrayWithCapacity:2];
        NSMutableDictionary *goDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [goDic safeSetObject:[flight2 getFlightNumber] forKey:KEY_FLIGHT_NUMBER];
        [goDic safeSetObject:[flight2 getClassTag] forKey:KEY_FLIGHTCLASS];
        [goDic safeSetObject:[flight2 getAirCorpCode] forKey:KEY_AIR_CORP_CODE];
        [goDic safeSetObject:[flight2 getDepartTime] forKey:KEY_DEPART_TIME];
        [goDic safeSetObject:[flight2 getArriveTime] forKey:KEY_ARRIVE_TIME];
        [goDic safeSetObject:[flight2 getDepartAirportCode] forKey:KEY_DEPART_AIRPORT_CODE];
        [goDic safeSetObject:[flight2 getArriveAirportCode] forKey:KEY_ARRIVE_AIRPORT_CODE];
        [goDic safeSetObject:[flight2 getPlaneType] forKey:KEY_PLANE_TYPE];
        [goDic safeSetObject:[flight2 getKilometers] forKey:KEY_KILOMETERS];
        if (ARRAYHASVALUE(flight2.stopInfos)) {
            [goDic safeSetObject:flight2.stopInfos forKey:KEY_STOPINFOS];
        }
        
        [rAirSegment addObject:goDic];
        
        if(flight2.isTransited) {
            NSMutableDictionary *goDic_t = [NSMutableDictionary dictionaryWithCapacity:2];
            [goDic_t safeSetObject:flight2.tFlightNum forKey:KEY_FLIGHT_NUMBER];
            [goDic_t safeSetObject:[flight2 getClassTag] forKey:KEY_FLIGHTCLASS];
            [goDic_t safeSetObject:flight2.tAirCorpCode forKey:KEY_AIR_CORP_CODE];
            [goDic_t safeSetObject:flight2.tDepartTime forKey:KEY_DEPART_TIME];
            [goDic_t safeSetObject:flight2.tArrivalTime forKey:KEY_ARRIVE_TIME];
            [goDic_t safeSetObject:flight2.tDepartAirPortCode forKey:KEY_DEPART_AIRPORT_CODE];
            [goDic_t safeSetObject:flight2.tArrivalAirPortCode forKey:KEY_ARRIVE_AIRPORT_CODE];
            [goDic_t safeSetObject:flight2.tAirFlightType forKey:KEY_PLANE_TYPE];
            [goDic_t safeSetObject:[flight2 getKilometers] forKey:KEY_KILOMETERS];
            [rAirSegment addObject:goDic_t];
        }
        
        // 返程shopping 产品
        NSString *shoppingOrderParams_r = flight2.shoppingOrderParams;
        NSNumber *ticketChannel_r = flight2.ticketChannel;
        if (shoppingOrderParams_r &&
            ticketChannel_r)
        {
            [flightDict2 safeSetObject:shoppingOrderParams_r forKey:KEY_SHOPPINGORDERPARAMS];
            [flightDict2 safeSetObject:ticketChannel_r forKey:KEY_TICKETCHANNEL];
        }
        [flightDict2 safeSetObject:rAirSegment forKey:KEY_AIRSEGMENTS];
        
        // 	仓位价格信息
        NSDictionary *salePricesDetail = [flight2 sitePricesDetail];
        if (salePricesDetail != nil)
        {
            [flightDict2 safeSetObject:salePricesDetail forKey:KEY_SALEPRICEDETAIL];
        }
        
        // 是否共享产品
        NSNumber *isSharedProduct = [flight2 isSharedProduct];
        if (isSharedProduct != nil)
        {
            [flightDict2 safeSetObject:isSharedProduct forKey:KEY_ISSHAREDPRODUCT];
        }
        
        // Add 2014/02/21.
        [flightDict2 safeSetObject:@{@"AdultOilTax":[flight2 getAdultOilTax], @"AdultAirTax":[flight2 getAdultAirTax], @"ChildOilTax":[flight2 getChildOilTax], @"ChildAirTax":[flight2 getChildAirTax]} forKey:KEY_FLIGHT_TAXS];
        [flightDict2 safeSetObject:@{@"AdultPrice":[flight2 getAdultPrice], @"ChildPrice":[flight2 getChildPrice]} forKey:KEY_SALE_PRICES];
        // End
        
        
        [flightArray addObject:flightDict2];
        [flightDict2 release];
	}
    
	[mDictionary safeSetObject:flightArray forKey:KEY_FLIGHT_CLASS_LIST];
	[flightArray release];
}

- (void)setPassengerList {
	[self buildPostData:NO];
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (NSMutableDictionary *tmp in [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST]) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict safeSetObject:[tmp safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
		[dict safeSetObject:[tmp safeObjectForKey:KEY_CERTIFICATE_TYPE] forKey:KEY_CERTIFICATE_TYPE];
		[dict safeSetObject:[StringEncryption EncryptString:[tmp safeObjectForKey:KEY_CERTIFICATE_NUMBER]] forKey:KEY_CERTIFICATE_NUMBER];

        [dict safeSetObject:[tmp safeObjectForKey:KEY_PASSENGER_TYPE] forKey:KEY_PASSENGER_TYPE];
        
        NSArray *insurances = [[FlightData getFDictionary] safeObjectForKey:KEY_INSURANCE_ORDERS];
        NSString *birthDay = @"";
        
        
        // 保险和儿童必须传出生日期
        if (ARRAYHASVALUE(insurances))
        {
            birthDay = [tmp safeObjectForKey:KEY_BIRTHDAY];
        }
        else if ([[dict safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 1) {
            birthDay = [tmp safeObjectForKey:KEY_BIRTHDAY];
        }
        
        [dict safeSetObject:birthDay forKey:KEY_BIRTHDAY];
        
		[array addObject:dict];
		[dict release];
	}
	[mDictionary safeSetObject:array forKey:KEY_PASSENGER_LIST];
	[array release];
}

- (void)setInsuranceList {
    NSArray *insurances = [[FlightData getFDictionary] safeObjectForKey:KEY_INSURANCE_ORDERS];
    
    if (ARRAYHASVALUE(insurances))
    {
        [self buildPostData:NO];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *tmp in insurances) {
            NSMutableDictionary *insuranceInfoDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
            
            // Holder.
            NSMutableDictionary *holderDict = [[NSMutableDictionary alloc] init];
            [holderDict safeSetObject:[[tmp safeObjectForKey:KEY_INSURANCE_HOLDER] safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
            [holderDict safeSetObject:@"" forKey:KEY_INSURANCE_NAMEEN];
            [holderDict safeSetObject:[[tmp safeObjectForKey:KEY_INSURANCE_HOLDER] safeObjectForKey:KEY_INSURANCE_BIRTHDAY] forKey:KEY_INSURANCE_BIRTHDAY];
            [holderDict safeSetObject:[[tmp safeObjectForKey:KEY_INSURANCE_HOLDER] safeObjectForKey:KEY_INSURANCE_SEX] forKey:KEY_INSURANCE_SEX];
            [holderDict safeSetObject:[[tmp safeObjectForKey:KEY_INSURANCE_HOLDER] safeObjectForKey:KEY_CERTIFICATE_TYPE] forKey:KEY_CERTIFICATE_TYPE];
            [holderDict safeSetObject:[StringEncryption EncryptString:[[tmp safeObjectForKey:KEY_INSURANCE_HOLDER] safeObjectForKey:KEY_CERTIFICATE_NUMBER]] forKey:KEY_CERTIFICATE_NUMBER];
            [holderDict safeSetObject:@"1" forKey:@"Sex"];
            [holderDict safeSetObject:[[tmp safeObjectForKey:KEY_INSURANCE_HOLDER] safeObjectForKey:KEY_PASSENGER_TYPE] forKey:KEY_PASSENGER_TYPE];
            [insuranceInfoDictionary safeSetObject:holderDict forKey:KEY_INSURANCE_HOLDER];
            [holderDict release];
            
            // Product.
            NSMutableDictionary *productDict = [[NSMutableDictionary alloc] init];
            [productDict safeSetObject:[[tmp safeObjectForKey:KEY_INSURANCE_PRODUCT] safeObjectForKey:KEY_INSURANCE_PRODUCTID] forKey:KEY_INSURANCE_PRODUCTID];
            [productDict safeSetObject:[[tmp safeObjectForKey:KEY_INSURANCE_PRODUCT] safeObjectForKey:KEY_INSURANCE_SALEPRICE] forKey:KEY_INSURANCE_SALEPRICE];
            [productDict safeSetObject:[[tmp safeObjectForKey:KEY_INSURANCE_PRODUCT] safeObjectForKey:KEY_INSURANCE_BASEPRICE] forKey:KEY_INSURANCE_BASEPRICE];
            [insuranceInfoDictionary safeSetObject:productDict forKey:KEY_INSURANCE_PRODUCT];
            [productDict release];
            
            [insuranceInfoDictionary safeSetObject:[tmp safeObjectForKey:KEY_INSURANCE_NUMBER] forKey:KEY_INSURANCE_NUMBER];
            [insuranceInfoDictionary safeSetObject:[tmp safeObjectForKey:KEY_INSURANCE_EFFECTIVETIME] forKey:KEY_INSURANCE_EFFECTIVETIME];
            
            [array addObject:insuranceInfoDictionary];
        }
        
        [mDictionary safeSetObject:array forKey:KEY_INSURANCE_ORDERS];
        [array release];
    }
    else {
        [mDictionary setValue:nil forKey:KEY_INSURANCE_ORDERS];
    }
}

- (NSString *)requesString:(BOOL)iscompress {
    if ([[ServiceConfig share] monkeySwitch]) {
        return nil;
    }
    
	[mDictionary safeSetObject:[PublicMethods getUserElongCardNO] forKey:KEY_CARD_NO];
    NSLog(@"flightOrder:%@", mDictionary);
	return [NSString stringWithFormat:@"action=GenerateFlightOrderV2&version=1.2&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[mDictionary JSONRepresentationWithURLEncoding]];
}

@end


