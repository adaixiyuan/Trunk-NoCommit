//
//  HotelOrderWebToAppLogic.m
//  ElongClient
//  酒店订单web to app logic
//  Created by garin on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderWebToAppLogic.h"
#import "HotelPromotionInfoRequest.h"

@implementation HotelOrderWebToAppLogic

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (hotelDetailRequest) {
        [hotelDetailRequest cancel];
        SFRelease(hotelDetailRequest);
    }
    
    if (userCouponRequest) {
        [userCouponRequest cancel];
        SFRelease(userCouponRequest);
    }
    
    self.app = nil;
    self.ref=nil;
    self.hotelId=nil;
    self.roomId=nil;
    self.rateplanId=nil;
    self.checkInDate=nil;
    self.checkOutDate=nil;
    
    [[HotelDetailController hoteldetail] removeAllObjects];
    
    [super dealloc];
}

#pragma mark -- 基类方法重写

//是否可以处理
-(BOOL) isCouldhanle
{
    if (!DICTIONARYHASVALUE(dictData))
    {
        return NO;
    }
    
    self.app = [dictData safeObjectForKey:@"app"];
    if (!STRINGHASVALUE(self.app)) {
        return NO;
    }
    if (![self.app isEqualToString:@"hotelorder"]) {
        return NO;
    }
    self.ref=[dictData safeObjectForKey:@"ref"];
    self.hotelId=[dictData safeObjectForKey:@"hotelid"];
    self.roomId=[dictData safeObjectForKey:@"roomid"];
    self.rateplanId=[dictData safeObjectForKey:@"rateplanid"];
    NSString *checkin=[dictData safeObjectForKey:@"checkindate"];
    NSString *checkout=[dictData safeObjectForKey:@"checkoutdate"];

    
    if (!STRINGHASVALUE(self.hotelId)) {
        return NO;
    }
    
    if (!STRINGHASVALUE(self.roomId)) {
        return NO;
    }
    
    if (!STRINGHASVALUE(self.rateplanId)) {
        return NO;
    }
    
    if (!STRINGHASVALUE(checkin)) {
        return NO;
    }
    
    if (!STRINGHASVALUE(checkout)) {
        return NO;
    }
    
    self.checkInDate=[NSDate dateFromString:checkin withFormat:@"yyyyMMdd"];
    self.checkOutDate=[NSDate dateFromString:checkout withFormat:@"yyyyMMdd"];
    
    if (self.checkInDate==nil||self.checkOutDate==nil) {
        return NO;
    }
    
    return YES;
}

//处理数据，跳转订单填写页
-(void) hanldeData
{
    [self searchHotelDetail];
}

#pragma mark -- 数据请求，处理

//发酒店详情
-(void) searchHotelDetail
{
	JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:self.hotelId];
    [hoteldetail setIsUnsigned:NO];
    [hoteldetail setSevenDay:NO];
    
    NSString *checkindatestring = [TimeUtils makeJsonDateWithUTCDate:self.checkInDate];
    NSString *checkoutdatestring = [TimeUtils makeJsonDateWithUTCDate:self.checkOutDate];
	[hoteldetail setCheckDateByElongDate:checkindatestring checkoutdate:checkoutdatestring];
    
    if (hotelDetailRequest) {
        [hotelDetailRequest cancel];
        SFRelease(hotelDetailRequest);
    }
    
    hotelDetailRequest = [[HttpUtil alloc] init];
    [hotelDetailRequest connectWithURLString:HOTELSEARCH Content:[hoteldetail requesString:YES] StartLoading:NO EndLoading:NO  Delegate:self];
}

//发coupon请求
-(void) getHotelCoupon
{
    JCoupon *coupon = [MyElongPostManager coupon];
    [[MyElongPostManager coupon] clearBuildData];
    
    if (userCouponRequest) {
        [userCouponRequest cancel];
        SFRelease(userCouponRequest);
    }
    
    userCouponRequest = [[HttpUtil alloc] init];
    [userCouponRequest connectWithURLString:MYELONG_SEARCH Content:[coupon requesActivedCounponString:YES] StartLoading:NO EndLoading:NO  Delegate:self];
}

//处理详情数据
-(void) handleDetailData:(NSDictionary *) root
{
    //添加数据
    [[HotelDetailController hoteldetail] removeAllObjects];
    [[HotelDetailController hoteldetail] addEntriesFromDictionary:root];
    
    NSArray *rooms = [[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"];
    
    if (!ARRAYHASVALUE(rooms))
    {
        [self invokeComplicatedDelegate];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *checkinString = [dateFormatter stringFromDate:self.checkInDate];
        NSString *checkoutString = [dateFormatter stringFromDate:self.checkOutDate];
        [dateFormatter release];
        
        [PublicMethods showAlertTitle:nil Message:[NSString stringWithFormat:@"对不起,该酒店在 %@ 至 %@ 期间暂时不能预订。",
                                                   checkinString,checkoutString]];
        return;
    }
    
    int curentRoomIndex = -1;
    NSDictionary *findedRoom = [WebAppUtil getBookingRoom:rooms currentRoomIndex:&curentRoomIndex findRoomId:self.roomId findRatePlanId:self.rateplanId];
    
    if (curentRoomIndex==-1||findedRoom==nil)
    {
        [PublicMethods showAlertTitle:nil Message:@"对不起，该房型不存在，请重试。"];
        [self invokeComplicatedDelegate];
        return;
    }
    
    //设置选中的房型index
    [RoomType setCurrentRoomIndex:curentRoomIndex];
    
	[[HotelDetailController hoteldetail] safeSetObject:[findedRoom safeObjectForKey:@"IsCustomerNameEn"] forKey:@"IsCustomerNameEn"];
    [[HotelDetailController hoteldetail] safeSetObject:[findedRoom safeObjectForKey:@"HotelCoupon"] forKey:@"HotelCoupon"];
    
    // 设置预付参数
    if ([[findedRoom safeObjectForKey:@"PayType"] intValue] == 1)
    {
        [RoomType setIsPrepay:YES];
    }
    else
    {
        [RoomType setIsPrepay:NO];
    }
    
    //登录
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginsuccess) name:ROOMTYPELOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registersuccess) name:ROOMTYPERSGISTER object:nil];
    BOOL islogin = [[AccountManager instanse] isLogin];
	if (islogin)
    {
        if ([[Coupon activedcoupons] count] == 0)
        {
            //重新获取coupon
            [self getHotelCoupon];
        }
        else
        {
            [self goHotelFillOrderPage];
            [self invokeComplicatedDelegate];
        }
        return;
	}
	else
    {
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:_FillHotelOrder_];
        [delegate.navigationController pushViewController:login animated:YES];
        [login release];
        [self invokeComplicatedDelegate];
	}
}

#pragma mark -- 通知消息回掉

-(void)loginsuccess
{
    fromloginsuccess = YES;
}

-(void) registersuccess
{
    [self getHotelCoupon];
}

#pragma mark -- http delegate

-(void) httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if (util == hotelDetailRequest)
    {
        if ([Utils checkJsonIsError:root])
        {
            [self invokeComplicatedDelegate];
            return ;
        }
        
        NSString *checkindatestring = [TimeUtils makeJsonDateWithUTCDate:self.checkInDate];
        NSString *checkoutdatestring = [TimeUtils makeJsonDateWithUTCDate:self.checkOutDate];
        
        HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
        promotionInfoRequest.orderEntrance = OrderEntranceAdH5;
        promotionInfoRequest.checkinDate = checkindatestring;
        promotionInfoRequest.checkoutDate = checkoutdatestring;
        promotionInfoRequest.hotelId = [root safeObjectForKey:@"HotelId"];
        promotionInfoRequest.hotelName = [root safeObjectForKey:@"HotelName"];
        promotionInfoRequest.cityName = [root safeObjectForKey:@"CityName"];
        promotionInfoRequest.star = [root safeObjectForKey:@"NewStarCode"];
        
        [self handleDetailData:root];
    }
    else if (util==userCouponRequest)
    {
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            //请求coupon失败，默认为0，去下单
            [[Coupon activedcoupons] removeAllObjects];
            [self goHotelFillOrderPage];
        }
        else
        {
            [[Coupon activedcoupons] removeAllObjects];
            [[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
            [self goHotelFillOrderPage];
        }
        [self invokeComplicatedDelegate];
    }
}

-(void) httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == hotelDetailRequest)
    {
        [self invokeComplicatedDelegate];
        [PublicMethods showAlertTitle:nil Message:@"网络有些小问题，请重试！"];
        return;
    }
    //请求coupon失败，默认为0，去下单
    else if (util==userCouponRequest)
    {
        [[Coupon activedcoupons] removeAllObjects];
        [self goHotelFillOrderPage];
        [self invokeComplicatedDelegate];
    }
}

//进入酒店订单页
- (void) goHotelFillOrderPage
{
    // 进入酒店订单填写页面
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    FillHotelOrder *fillhotelOrder = [[FillHotelOrder alloc] init];
    
    fillhotelOrder.isSkipLogin = fromloginsuccess;
    [delegate.navigationController pushViewController:fillhotelOrder animated:YES];
    [fillhotelOrder release];
}

@end
