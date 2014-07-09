//
//  Hotel.m
//  ElongClient
//
//  Created by bin xing on 11-1-10.
//  Copyright 2011 DP. All rights reserved.
//

#import "JHotelOrder.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "ElongClientAppDelegate.h"

@implementation JHotelOrder

-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (delegate.isNonmemberFlow) {
			[contents safeSetObject:NUMBER(0) forKey:Resq_CardNo];
		}
		else {
            NSString *cardNO = [[AccountManager instanse] cardNo];
            if (STRINGHASVALUE(cardNO))
            {
                [contents safeSetObject:cardNO forKey:Resq_CardNo];
            }
			else
            {
                [contents safeSetObject:NUMBER(0) forKey:Resq_CardNo];
            }
		}
		
		[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_HotelId_S];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_RoomTypeId_S];
		[contents safeSetObject:Zero forKey:ReqHO_RatePlanID_L];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_ArriveDate_ED];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_LeaveDate_ED];
		
		[contents safeSetObject:JSON_NULL forKey:ReqHO_ArriveTimeEarly_ED];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_ArriveTimeLate_ED];
		
		[contents safeSetObject:Zero forKey:ReqHO_TotalPrice_D];
		[contents safeSetObject:Zero forKey:ReqHO_RoomCount_I];
        [contents safeSetObject:ZERO forKey:CASHAMOUNT];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_GuestNames_A];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_ConnectorMobile_S];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_ConnectorName_S];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_SelectedCoupons_A];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_HotelCoupon_DI];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_NotesToElong_S];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_NotesToHotel_S];
        [contents safeSetObject:JSON_NO forKey:ReqHO_IsNeedInvoice];
        [contents safeSetObject:JSON_NULL forKey:ReqHO_CustomerInvoice];
        [contents safeSetObject:[NSNumber numberWithInt:0] forKey:PAYTYPE];
		
		[contents safeSetObject:Zero forKey:ReqHO_VouchMoney_D];
		[contents safeSetObject:Zero forKey:ReqHO_VouchSetType_I];
		[contents safeSetObject:JSON_NULL forKey:ReqHO_CreditCard_DI];
		[contents safeSetObject:JSON_NULL forKey:@"SupplierCardNo"];
        
        
        [contents safeSetObject:JSON_NULL forKey:@"ReturnUrl"];
		[contents safeSetObject:JSON_NULL forKey:@"Subject"];
        [contents safeSetObject:JSON_NULL forKey:@"Body"];
		[contents safeSetObject:JSON_NULL forKey:@"CancelUrl"];
	}
}


-(int)getSelectedCouponsCount{
	
	if ([contents safeObjectForKey:ReqHO_SelectedCoupons_A]==[NSNull null]||[contents safeObjectForKey:ReqHO_SelectedCoupons_A]==nil) {
		return 0;
	}
	
	return [[contents safeObjectForKey:ReqHO_SelectedCoupons_A] count];
}

-(CGFloat)getTotalPrice{
	return	[[contents safeObjectForKey:ReqHO_TotalPrice_D] floatValue];
}

- (void)setTotalPrice:(double)price {
    [contents safeSetObject:[NSString stringWithFormat:@"%.2f", price] forKey:ReqHO_TotalPrice_D];
}

-(NSString *)getConnectorName{
	return	[contents safeObjectForKey:ReqHO_ConnectorName_S];
}
-(NSString *)getConnectorMobile{
	return	[contents safeObjectForKey:ReqHO_ConnectorMobile_S];
}
-(int)getRoomCount{
	return	[[contents safeObjectForKey:ReqHO_RoomCount_I] intValue];
}
-(NSString *)getArriveDate{

	return	[contents safeObjectForKey:ReqHO_ArriveDate_ED];
}
-(NSString *)getLeaveDate{
	
	return	[contents safeObjectForKey:ReqHO_LeaveDate_ED];
}

-(NSString *)getArriveTimeEarly{
	return [contents safeObjectForKey:ReqHO_ArriveTimeEarly_ED];
}

-(NSString *)getArriveTimeLate{
	return [contents safeObjectForKey:ReqHO_ArriveTimeLate_ED];
}


- (NSString *)getOnlyArriveTime {
	NSString *arriveTimeEarly =[TimeUtils displayDateWithJsonDate:[contents safeObjectForKey:ReqHO_ArriveTimeEarly_ED] formatter:@"HH:mm"];
	NSString *arriveTimeLate = [TimeUtils displayDateWithJsonDate:[contents safeObjectForKey:ReqHO_ArriveTimeLate_ED] formatter:@"HH:mm"];
	return	[NSString stringWithFormat:@"%@ - %@",arriveTimeEarly,arriveTimeLate];
}

-(NSString *)getArriveTime{
	NSString *arriveTimeEarly =[TimeUtils displayNoTimeZoneJsonDate:[contents safeObjectForKey:ReqHO_ArriveTimeEarly_ED] formatter:@"HH:mm"];
	NSString *arriveTimeLate = [TimeUtils displayNoTimeZoneJsonDate:[contents safeObjectForKey:ReqHO_ArriveTimeLate_ED] formatter:@"HH:mm"];
	
	if ([arriveTimeEarly isEqualToString:@"01:00"]) {
		arriveTimeEarly=[NSString stringWithFormat:@"次日1:00"];
	}
	else if ([arriveTimeEarly isEqualToString:@"02:00"]) {
		arriveTimeEarly=[NSString stringWithFormat:@"次日2:00"];
	}
	else if ([arriveTimeEarly isEqualToString:@"03:00"]) {
		arriveTimeEarly=[NSString stringWithFormat:@"次日3:00"];
	}
	else if ([arriveTimeEarly isEqualToString:@"04:00"]) {
		arriveTimeEarly=[NSString stringWithFormat:@"次日4:00"];
	}
	else if ([arriveTimeEarly isEqualToString:@"05:00"]) {
		arriveTimeEarly=[NSString stringWithFormat:@"次日5:00"];
	}
	else if ([arriveTimeEarly isEqualToString:@"06:00"]) {
		arriveTimeEarly=[NSString stringWithFormat:@"次日6:00"];
	}
	
	if ([arriveTimeLate isEqualToString:@"01:00"]) {
		arriveTimeLate=[NSString stringWithFormat:@"次日1:00"];
	}
	else if ([arriveTimeLate isEqualToString:@"02:00"]) {
		arriveTimeLate=[NSString stringWithFormat:@"次日2:00"];
	}
	else if ([arriveTimeLate isEqualToString:@"03:00"]) {
		arriveTimeLate=[NSString stringWithFormat:@"次日3:00"];
	}
	else if ([arriveTimeLate isEqualToString:@"04:00"]) {
		arriveTimeLate=[NSString stringWithFormat:@"次日4:00"];
	}
	else if ([arriveTimeLate isEqualToString:@"05:00"]) {
		arriveTimeLate=[NSString stringWithFormat:@"次日5:00"];
	}
	else if ([arriveTimeLate isEqualToString:@"06:00"]) {
		arriveTimeLate=[NSString stringWithFormat:@"次日6:00"];
	}
	
	return	[NSString stringWithFormat:@"%@ - %@",arriveTimeEarly,arriveTimeLate];
}

-(NSArray *)getGuestNames{
	return	[contents safeObjectForKey:ReqHO_GuestNames_A];
}

-(id)init{
    self = [super init];
    if (self) {
		
		contents=[[NSMutableDictionary alloc] init];

		[self clearBuildData];
	}
	return self;
}
-(void)clearBuildData{
	[self buildPostData:YES];
}
-(void)setCoupons:(NSArray *)coupons {
	if ([contents safeObjectForKey:ReqHO_HotelCoupon_DI]!=[NSNull null]) {
		if (coupons!=nil&&[coupons count]>0) {
			[contents safeSetObject:coupons forKey:ReqHO_SelectedCoupons_A];
			
		}else {
			[contents safeSetObject:Zero forKey:ReqHO_SelectedCoupons_A];
		}
	}
}

-(void)setClearCoupons {
	[contents safeSetObject:JSON_NULL forKey:ReqHO_SelectedCoupons_A];
}

- (NSArray *)getCoupons {
	return [contents safeObjectForKey:ReqHO_SelectedCoupons_A];
}


- (void)setBaseInfo:(int)index {
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:index];
	[contents safeSetObject:[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S] forKey:ReqHO_HotelId_S];
	[contents safeSetObject:[room safeObjectForKey:RespHD__RoomTypeId_S] forKey:ReqHO_RoomTypeId_S];
	[contents safeSetObject:[room safeObjectForKey:RespHD__RatePlanId_L] forKey:ReqHO_RatePlanID_L];
}


- (void)setBaseInfo:(int)index useCoupon:(BOOL)useCoupon {
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:index];
	[contents safeSetObject:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
	[self setBaseInfo:index];
	[contents safeSetObject:[room safeObjectForKey:RespHD__HotelCoupon_DI] forKey:ReqHO_HotelCoupon_DI];	
}


-(void)setBookingInfo:(int)index roomcount:(int)roomcount guestnames:(NSArray *)guestnames{    
    // ========================== 计算间夜数 ==========================
    NSInteger dayCount = [[TimeUtils parseJsonDate:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckOutDate_ED]] timeIntervalSinceDate:[TimeUtils parseJsonDate:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckInDate_ED]]] / 86400;    // 入住天数
    
    _orderCount = roomcount * dayCount;
    // ===============================================================
    
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:index];
	double price = [[room safeObjectForKey:RespHD__TotalPrice_D] doubleValue];
	
	double totalprice = roomcount * price;
	
	[contents safeSetObject:[NSString stringWithFormat:@"%.2f", totalprice] forKey:ReqHO_TotalPrice_D];
	[contents safeSetObject:[NSNumber numberWithInt:roomcount] forKey:ReqHO_RoomCount_I];
	[contents safeSetObject:guestnames forKey:ReqHO_GuestNames_A];
	
	// 拓展字段
	[contents safeSetObject:[room safeObjectForKey:ReqHO_GuestType]  forKey:ReqHO_GuestType];
	[contents safeSetObject:[[HotelDetailController hoteldetail] safeObjectForKey:ReqHO_ExtendByteField] forKey:ReqHO_ExtendByteField];
	[contents safeSetObject:[[HotelDetailController hoteldetail] safeObjectForKey:ReqHO_ExtendDespField] forKey:ReqHO_ExtendDespField];
}

-(void)setConnectorInfo:(NSString *)mobile {
	[contents safeSetObject:mobile forKey:ReqHO_ConnectorMobile_S];
}

-(void)setArriveTimeRange:(NSRange)timeRange{
	int et=timeRange.location;
	int lt=et+timeRange.length;
	
	double checkInDate=[[TimeUtils parseJsonDate:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckInDate_ED]] timeIntervalSince1970];
	double earlytime = checkInDate+et;
	double latetime =  checkInDate+lt;
	
	[contents safeSetObject:[TimeUtils makeJsonDateWithNSTimeInterval:earlytime] forKey:ReqHO_ArriveTimeEarly_ED];
	[contents safeSetObject:[TimeUtils makeJsonDateWithNSTimeInterval:latetime] forKey:ReqHO_ArriveTimeLate_ED];
	
}
-(void)setSupperCardNo:(NSString* )SupplierCardNoString
{
    [contents safeSetObject:SupplierCardNoString forKey:@"SupplierCardNo"];
}

- (void)setArriveTimeEarly:(NSString *)earlyTime Late:(NSString *)lateTime {
	[contents safeSetObject:earlyTime forKey:ReqHO_ArriveTimeEarly_ED];
	[contents safeSetObject:lateTime forKey:ReqHO_ArriveTimeLate_ED];
}


-(void)setBookingDate
{
	[contents safeSetObject:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckInDate_ED] forKey:ReqHO_ArriveDate_ED];
	[contents safeSetObject:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckOutDate_ED] forKey:ReqHO_LeaveDate_ED];
	
}


- (void)setVouch:(VouchSetType)vouchSetType vouchMoney:(CGFloat)vouchMoney
{
    [contents safeSetObject:[NSNumber numberWithInt:vouchSetType] forKey:ReqHO_VouchSetType_I];
	[contents safeSetObject:[NSString stringWithFormat:@"%.2f", vouchMoney] forKey:ReqHO_VouchMoney_D];
}


- (void)setVouch:(VouchSetType)vouchSetType vouchMoney:(CGFloat)vouchMoney vouchData:(NSMutableDictionary *)vouchData
{
	[self setVouch:vouchSetType vouchMoney:vouchMoney];
	
	NSMutableDictionary *creditCardContents=[[NSMutableDictionary alloc] init];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"CreditCardType"]  forKey:ReqHO__CreditCardType_DI];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"CreditCardNumber"]  forKey:ReqHO__CreditCardNumber_S];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"HolderName"] forKey:ReqHO__HolderName_S];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"VerifyCode"]  forKey:ReqHO__VerifyCode_S];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"CertificateType"]  forKey:ReqHO__CertificateType_I];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"CertificateNumber"]  forKey:ReqHO__CertificateNumber_S];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"ExpireYear"]  forKey:ReqHO__ExpireYear_I];
	[creditCardContents safeSetObject:[vouchData safeObjectForKey:@"ExpireMonth"]  forKey:ReqHO__ExpireMonth_I];
	
	NSString *cardNO = [[AccountManager instanse] cardNo];
	if (cardNO) {
		[creditCardContents safeSetObject:cardNO forKey:ReqHO__ElongCardNo_L];
	}
	else {
		// 非会员流程
		[creditCardContents safeSetObject:@"0" forKey:ReqHO__ElongCardNo_L];
	}

    if (vouchSetType == 1) {
        [contents safeSetObject:creditCardContents forKey:ReqHO_CreditCard_DI];
    }

	[creditCardContents release];
}

-(void)setOrderNo:(id)orderno{
	
	[contents safeSetObject:orderno forKey:ReqHO_HotelOrderNo_I];
	
}
-(long)orderNo{
	return [[contents safeObjectForKey:ReqHO_HotelOrderNo_I] longLongValue];
}

-(void)setCurrency:(NSString *)currency {
	[contents safeSetObject:currency forKey:ReqHO_Currency];
}

- (NSString *)getCurrency {
	return [contents safeObjectForKey:ReqHO_Currency];
}

- (void)setToPrePay {
    [contents safeSetObject:[NSNumber numberWithInt:1] forKey:PAYTYPE];
}


- (void)setCashAmount:(CGFloat)cashNum
{
    [contents safeSetObject:[NSString stringWithFormat:@"%.2f", cashNum] forKey:CASHAMOUNT];
}

- (void) setNotesToElong:(NSString *)notes{
    [contents safeSetObject:notes forKey:ReqHO_NotesToElong_S];
}

- (void) setNotesToHotel:(NSString *)notes{
    [contents safeSetObject:notes forKey:ReqHO_NotesToHotel_S];
}

- (NSNumber *)getCashAmount
{
    return [contents safeObjectForKey:CASHAMOUNT];
}

- (void)setAlipayInfo:(NSString *)returnURL withCancelURL:(NSString *)cancelURL withName:(NSString *)name withBody:(NSString *)body
{
    [contents safeSetObject:returnURL forKey:@"ReturnUrl"];
    [contents safeSetObject:name forKey:@"Subject"];
    [contents safeSetObject:body forKey:@"Body"];
    [contents safeSetObject:cancelURL forKey:@"CancelUrl"];
}

- (void)setInvoiceDic:(NSDictionary *)invoiceDic
{
    [contents safeSetObject:JSON_YES forKey:ReqHO_IsNeedInvoice];
    [contents safeSetObject:invoiceDic forKey:ReqHO_CustomerInvoice];
}


- (NSDictionary *)getInvoiceDic
{
    return [contents safeObjectForKey:ReqHO_CustomerInvoice];
}


-(NSString *)requesString:(BOOL)iscompress{
    if ([[ServiceConfig share] monkeySwitch]) {
        // 开着monkey时不能下单
        return nil;
    }
    else {
        NSString *cardNO = [[AccountManager instanse] cardNo];
        if (cardNO) {
            [contents safeSetObject:cardNO forKey:Resq_CardNo];
        }
        else {
            // 非会员预订
            [contents safeSetObject:@"0" forKey:Resq_CardNo];
        }
        [contents safeSetObject:APPTYPE forKey:@"AppType"];

        NSLog(@"%@", contents);
        return [NSString stringWithFormat:@"action=GeneratHotelOrder&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[contents JSONRepresentationWithURLEncoding]];
    }
}

@end
