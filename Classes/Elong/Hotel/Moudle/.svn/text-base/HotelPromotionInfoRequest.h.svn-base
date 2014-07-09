//
//  HotelPromotionInfoRequest.h
//  ElongClient
//
//  Created by Dawn on 14-5-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    /*
     今日特价列表 1001
     今日特价地图 1002 
     正常酒店列表 1003 
     正常酒店地图 1004 
     PSG推荐    1005 
     广告进入详情 1006 
     广告进入H5再进入详情1007
     再次预定 1008
     收藏 1009
     */
    OrderEntranceLMList = 1001,
    OrderEntranceLMMap = 1002,
    OrderEntranceList = 1003,
    OrderEntranceMap = 1004,
    OrderEntrancePSG = 1005,
    OrderEntranceAd = 1006,
    OrderEntranceAdH5 = 1007,
    OrderEntranceRebooking = 1008,
    OrderEntranceFav = 1009
}OrderEntranceType;

typedef enum {
    /* 
     无促销类型2000
     限时抢购 2001 
     今日特价 2002 
     手机专享 2003 
     龙翠专享 2004
     */
    OrderPromotionNone = 2000,
    OrderPromotionLimit = 2001,
    OrderPromotionLM = 2002,
    OrderPromotionPhone = 2003,
    OrderPromotionVIP = 2004
}OrderPromotionType;

typedef enum {
    //预付：3001；现付：3002
    OrderPayPrepay = 3001,
    OrderPayCash = 3002
}OrderPayType;

@interface HotelPromotionInfoRequest : NSObject
@property (nonatomic,copy) NSString *checkinDate;
@property (nonatomic,copy) NSString *checkoutDate;
@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *hotelId;
@property (nonatomic,copy) NSString *hotelName;
@property (nonatomic,copy) NSString *roomType;
@property (nonatomic,copy) NSString *star;
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,assign) OrderEntranceType orderEntrance;
@property (nonatomic,assign) OrderPromotionType promotionType;
@property (nonatomic,assign) OrderPayType payType;
- (NSString *) requestString;
AS_SINGLETON(HotelPromotionInfoRequest)
@end
