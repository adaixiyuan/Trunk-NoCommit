//
//  HotelOrderWebToAppLogic.h
//  ElongClient
//
//  Created by garin on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "WebToAppBaseLogic.h"
#import "JHotelDetail.h"
#import "HotelPostManager.h"
#import "HttpUtil.h"
#import "HotelDetailController.h"
#import "AccountManager.h"
#import "JCoupon.h"

@interface HotelOrderWebToAppLogic : WebToAppBaseLogic<HttpUtilDelegate>
{
    HttpUtil *hotelDetailRequest;
    HttpUtil *userCouponRequest;
    BOOL fromloginsuccess;
}
@property (nonatomic,copy) NSString *app;
@property (nonatomic,copy) NSString *ref;
@property (nonatomic,copy) NSString *hotelId;
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *rateplanId;
@property (nonatomic,copy) NSDate *checkInDate;
@property (nonatomic,copy) NSDate *checkOutDate;

@end
