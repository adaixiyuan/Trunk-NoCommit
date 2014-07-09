//
//  HotelOrderListRequest.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HotelOrderListRequestDelegate;
@interface HotelOrderListRequest : NSObject<HttpUtilDelegate>{
    //各种请求
    HttpUtil *_refreshListUtil;
    HttpUtil *_moreListUtil;
    HttpUtil *_filterListUtil;
    HttpUtil *_reviewDetailUtil;
    
    HttpUtil *_goHotelUtil;
    HttpUtil *_urgeConfirmUtil;
    HttpUtil *_recommendHotelUtil;
    
}

@property(nonatomic,assign) id<HotelOrderListRequestDelegate> delegate;

-(id)initWithDelegate:(id<HotelOrderListRequestDelegate>)aDelegate;     //初始化请求
-(void)startRequestWithMoreOrderList;       //获取更多订单请求
-(void)startRequestWithRefreshOrderList;        //获取刷新订单列表请求
-(void)startRequestWithFilterOrderList;     //筛选订单列表请求
-(void)startRequestWithReviewDetailOrder:(NSDictionary *)anOrder;       //查看订单详情
-(void)startRequestWithGoHotel:(NSDictionary *)anOrder;     //带我去酒店
-(void)startRequestWithUrgeConfirmOrder:(NSDictionary *)anOrder;    //加速确认订单
-(void)startRequestWithRecommendBooking:(NSDictionary *)hotel;    //搜索推荐的酒店
- (void)startRequestWithPhoneHotelList;//请求客服页面的订单列表
@end


@protocol HotelOrderListRequestDelegate <NSObject>

@optional
-(void)executeMoreOrdersResult:(NSDictionary *)result;   //执行获取订单列表
-(void)executeMoreOrdersResultFailed:(NSDictionary *)result;        //执行获取订单列表失败
-(void)executeRefreshOrderResult:(NSDictionary *)result;   //执行获取刷新订单
-(void)executeFilterOrderResult:(NSDictionary *)result;   //执行获取筛选订单
-(void)executeReviewDetailOrderResult:(NSDictionary *)result;   //执行获取详情订单
-(void)executeGoHotelResult:(NSDictionary *)result;   //执行带我去酒店
-(void)executeUrgeConfirmResult:(NSDictionary *)result; //执行催确认状态
-(void)executeRecommendBookingResult:(NSDictionary *)result;  //执行推荐酒店查询

@end