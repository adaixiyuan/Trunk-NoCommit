//
//  HotelOrderListRequest.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderListRequest.h"
#import "OrderHistoryPostManager.h"
#import "ElongURL.h"
#import "HotelConditionRequest.h"

@implementation HotelOrderListRequest

-(void)dealloc{
    [_moreListUtil cancel];
    [_reviewDetailUtil cancel];
    [_refreshListUtil cancel];
    [_filterListUtil cancel];
    
    [_goHotelUtil cancel];
    [_urgeConfirmUtil cancel];
    [_recommendHotelUtil cancel];
    
    [_moreListUtil release];
    [_reviewDetailUtil release];
    [_refreshListUtil release];
    [_filterListUtil release];
    
    [_goHotelUtil release];
    [_urgeConfirmUtil release];
    [_recommendHotelUtil release];
    [super dealloc];
}

//根据订单信息初始化请求
-(id)initWithDelegate:(id<HotelOrderListRequestDelegate>)aDelegate{
    self = [super init];
    if(self){        
        _moreListUtil = [[HttpUtil alloc] init];
        _refreshListUtil = [[HttpUtil alloc] init];
        _filterListUtil = [[HttpUtil alloc] init];
        _reviewDetailUtil = [[HttpUtil alloc] init];
        
        _goHotelUtil = [[HttpUtil alloc] init];
        _urgeConfirmUtil = [[HttpUtil alloc] init];
        _recommendHotelUtil = [[HttpUtil alloc] init];
        _delegate = aDelegate;
    }
    return self;
}


//发送获取更多订单请求
-(void)startRequestWithMoreOrderList{
    //获取更多请求
    JHotelOrderHistory *orderHotel = [OrderHistoryPostManager hotelorderhistory];
    [orderHotel clearBuildData];
    [orderHotel setHalfYear];
    [orderHotel nextPage];
    
    [_moreListUtil connectWithURLString:MYELONG_SEARCH Content:[orderHotel requesString:YES]  Delegate:self];
}

//获取刷新订单列表请求
-(void)startRequestWithRefreshOrderList{
    JHotelOrderHistory *orderHotel = [OrderHistoryPostManager hotelorderhistory];
    [orderHotel clearBuildData];
    [orderHotel setHalfYear];
    [orderHotel setPageZero];
    
    [_refreshListUtil connectWithURLString:MYELONG_SEARCH Content:[orderHotel requesString:YES] Delegate:self];
}

//筛选订单列表请求
-(void)startRequestWithFilterOrderList{
    
}

//查看订单详情
-(void)startRequestWithReviewDetailOrder:(NSDictionary *)anOrder{
    //会员请求订单详情
    NSInteger orderNum = [[anOrder objectForKey:@"OrderNo"] intValue];
    
    JHotelOrderDetail *hotelOrderDetail = [HotelPostManager hotelorderdetail];
    hotelOrderDetail.orderNo = orderNum;
    hotelOrderDetail.cardNo = [[AccountManager instanse] cardNo];
    
    [_reviewDetailUtil connectWithURLString:MYELONG_SEARCH Content:[hotelOrderDetail requesString:YES] Delegate:self];
}

//带我去酒店
-(void)startRequestWithGoHotel:(NSDictionary *)anOrder{
    NSString *hotelId = [anOrder safeObjectForKey:@"HotelId"];
    NSString *checkInDate = [TimeUtils makeJsonDateWithUTCDate:[NSDate date]];
    NSString *checkOutDate = [TimeUtils makeJsonDateWithUTCDate:[NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]]];
    
    JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
    [hoteldetail clearBuildData];
    [hoteldetail setHotelId:hotelId];
    [hoteldetail setCheckDateByElongDate:checkInDate checkoutdate:checkOutDate];
    
    [_goHotelUtil connectWithURLString:HOTELSEARCH Content:[hoteldetail requesString:YES] Delegate:self];
}

//加速确认订单
-(void)startRequestWithUrgeConfirmOrder:(NSDictionary *)anOrder{
    double orderNO  = [[anOrder safeObjectForKey:@"OrderNo"] doubleValue];
    NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:orderNO],@"OrderNo", nil];
    NSString *reqContent = [reqDictInfo JSONString];
    
    // 发起请求
    NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"urgeConfirmOrder" andParam:reqContent];
    [_urgeConfirmUtil requestWithURLString:url Content:nil Delegate:self];
}

//搜索推荐的酒店
-(void)startRequestWithRecommendBooking:(NSDictionary *)hotel{
    // 国内酒店
    [[HotelConditionRequest shared] setIsFromLastMinute:NO];
//    FastPositioning *position = [FastPositioning shared];
//    position.autoCancel = NO;
//    [position fastPositioning];
    
    JHotelSearch *hotelsearcher = [HotelPostManager hotelsearcher];
    [hotelsearcher clearBuildData];
    [HotelSearch setPositioning:YES];
    [hotelsearcher setMutipleFilter:@"52"];
    
    double longitude = [[hotel safeObjectForKey:@"Longitude"] doubleValue];
    double latitude = [[hotel safeObjectForKey:@"Latitude"] doubleValue];
    [hotelsearcher setCurrentPos:HOTEL_NEARBY_RADIUS
                       Longitude:longitude
                        Latitude:latitude];
    
    
    // 获取入离店日期
    NSString *checkinDate = [TimeUtils displayDateWithNSTimeInterval:[[NSDate date] timeIntervalSince1970] formatter:@"yyyy-MM-dd"];
    NSString *checkoutDate = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+24*60*60) formatter:@"yyyy-MM-dd"];
    [hotelsearcher setCheckData:checkinDate checkoutdate:checkoutDate];
    
    NSString *cityname = [hotel safeObjectForKey:@"CityName"];
    [hotelsearcher setCityName:cityname];
    
    [_recommendHotelUtil connectWithURLString:HOTELSEARCH Content:[hotelsearcher requesString:YES] Delegate:self];
    // 周边搜索国内酒店时区判断
    [self checkLocalTimeZone];
}

// 时区检测，判断用户所在位置是否为东八区
- (void) checkLocalTimeZone{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!appDelegate.timezoneCheckNeeded) {
        return;
    }
    
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
    appDelegate.timezoneCheckNeeded = NO;
}

#pragma mark - HttpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    //判断网络数据的正确性
    if ([Utils checkJsonIsError:root]) {
        if(util==_moreListUtil){
            //处理失败时更多订单数据
            if([_delegate respondsToSelector:@selector(executeMoreOrdersResultFailed:)]){
                [_delegate executeMoreOrdersResultFailed:root];
            }
        }
        return ;
    }
    
    if(util==_moreListUtil){
        //处理更多订单数据
        if([_delegate respondsToSelector:@selector(executeMoreOrdersResult:)]){
            [_delegate executeMoreOrdersResult:root];
        }
    }else if(util==_refreshListUtil){
        //处理刷新订单数据
        if([_delegate respondsToSelector:@selector(executeRefreshOrderResult:)]){
            [_delegate executeRefreshOrderResult:root];
        }
    }else if(util==_reviewDetailUtil){
        //处理进入订单详情数据
        if([_delegate respondsToSelector:@selector(executeReviewDetailOrderResult:)]){
            [_delegate executeReviewDetailOrderResult:root];
        }
    }else if(util == _goHotelUtil){
        //带我去酒店
        if([_delegate respondsToSelector:@selector(executeGoHotelResult:)]){
            [_delegate executeGoHotelResult:root];
        }
    }else if(util == _urgeConfirmUtil){
        //催确认
        if([_delegate respondsToSelector:@selector(executeUrgeConfirmResult:)]){
            [_delegate executeUrgeConfirmResult:root];
        }
    }else if(util == _recommendHotelUtil){
        //推荐预订
        if([_delegate respondsToSelector:@selector(executeRecommendBookingResult:)]){
            [_delegate executeRecommendBookingResult:root];
        }
    }
    
}

- (void)startRequestWithPhoneHotelList//请求客服页面的订单列表
{
    JHotelOrderHistory *orderHotel = [OrderHistoryPostManager hotelorderhistory];
    [orderHotel clearBuildData];
    [orderHotel setHalfYear];
    [orderHotel setPageSize:20];
    [orderHotel  setPageZero];
    
    
    [_refreshListUtil  connectWithURLString:MYELONG_SEARCH Content:[orderHotel requesString:YES] StartLoading:NO EndLoading:NO Delegate:self];
}

@end
