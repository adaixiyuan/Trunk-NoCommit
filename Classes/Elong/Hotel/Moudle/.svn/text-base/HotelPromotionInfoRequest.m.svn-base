//
//  HotelPromotionInfoRequest.m
//  ElongClient
//
//  Created by Dawn on 14-5-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelPromotionInfoRequest.h"

@implementation HotelPromotionInfoRequest

DEF_SINGLETON(HotelPromotionInfoRequest)
- (void) dealloc{
    self.checkinDate = nil;
    self.checkoutDate = nil;
    self.cityName = nil;
    self.hotelId = nil;
    self.hotelName = nil;
    self.roomType = nil;
    self.star = nil;
    self.orderId = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        self.promotionType = OrderPromotionNone; // 无促销
    }
    return self;
}



- (NSString *) requestString{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.checkinDate forKey:@"checkinDate"];
    [params safeSetObject:self.checkoutDate forKey:@"checkoutDate"];
    [params safeSetObject:self.cityName forKey:@"cityName"];
    [params safeSetObject:self.hotelId forKey:@"hotelId"];
    [params safeSetObject:self.hotelName forKey:@"hotelName"];
    [params safeSetObject:self.roomType forKey:@"roomType"];
    [params safeSetObject:self.star forKey:@"star"];
    [params safeSetObject:NUMBER(self.orderEntrance) forKey:@"orderEntrance"];
    [params safeSetObject:NUMBER(self.promotionType) forKey:@"promotionType"];
    [params safeSetObject:NUMBER(self.payType) forKey:@"payType"];
    [params safeSetObject:self.orderId forKey:@"orderId"];
    [params safeSetObject:[TimeUtils makeJsonDateWithUTCDate:[NSDate date]] forKey:@"createTime"];
    NSString *requestString = [params JSONString];
    
    
    return requestString;
}
@end
