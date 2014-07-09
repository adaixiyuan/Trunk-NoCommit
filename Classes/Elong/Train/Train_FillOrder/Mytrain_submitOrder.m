//
//  Mytrain_submitOrder.m
//  ElongClient
//  火车票提交订单接口
//
//  Created by 赵 海波 on 13-11-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "Mytrain_submitOrder.h"

@implementation Mytrain_submitOrder

@end

@implementation Passenger

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_certType forKey:@"certType"];
    [aCoder encodeObject:_certNumber forKey:@"certNumber"];
    [aCoder encodeObject:_passengerType forKey:@"passengerType"];
    [aCoder encodeObject:_seatCode forKey:@"seatCode"];
    [aCoder encodeObject:_price forKey:@"price"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.certType = [aDecoder decodeObjectForKey:@"certType"];
        self.certNumber = [aDecoder decodeObjectForKey:@"certNumber"];
        self.passengerType = [aDecoder decodeObjectForKey:@"passengerType"];
        self.seatCode = [aDecoder decodeObjectForKey:@"seatCode"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
    }
    return self;
}

@end
