//
//  AddressInfo.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "AddressInfo.h"
#import "AccountManager.h"
#import "PositioningManager.h"
#import <objc/runtime.h>
#import "TaxiPublicDefine.h"

@implementation AddressInfo

-(id)init{

    if (self = [super init]) {
        self.address = @"";
        self.name = @"";
        self.location = @"";
        self.cityName = @"";
        self.gaoDe_ID = @"";
    }
    return self;
}

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.address = [coder decodeObjectForKey:@"address"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.location = [coder decodeObjectForKey:@"location"];
        self.cityName = [coder decodeObjectForKey:@"cityName"];
        self.gaoDe_ID = [coder decodeObjectForKey:@"gaoDe_ID"];
    }
    return self;
}
- (void) encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.name  forKey:@"name"];
    [coder encodeObject:self.location forKey:@"location"];
    [coder encodeObject:self.cityName forKey:@"cityName"];
    [coder encodeObject:self.gaoDe_ID forKey:@"gaoDe_ID"];
}

-(void)dealloc{
    [_address release];
    [_name release];
    [_location  release];
    [_cityName release];
    [_gaoDe_ID  release];
    [super dealloc];
}
@end

@implementation TaxiOrder

-(id)init{

    if (self = [super init]) {
        self.sguid = @"";
        self.uid = (![AccountManager instanse].cardNo)?[PublicMethods macaddress]:[AccountManager instanse].cardNo;
        self.productType = @"";//0101 即时打车 0102 预约打车
        self.fromAddress = @"";
        self.fromLongitude = @"";//经度
        self.fromLatitude = @"";//纬度
        self.toAddress = @"";
        self.useTime = [TimeUtils displayDateWithNSDate:[NSDate date] formatter:@"yyyy-MM-dd HH:mm"];
        self.passengerName = @"张三";
        self.passengerPhone = @"";
        self.addPrice = @"0";
        self.mapSupplier = @"gaode";//火星坐标切百度成功后置为baidu 不成功还是以gaode传给后台
        self.city = [[PositioningManager shared] currentCity];
        self.orderIp = @"192.168.1.1";
        self.orderId = @"";
    }
    return self;
}

-(void)dealloc{

    [_sguid release];
    [_uid release];
    [_productType release];
    [_fromAddress release];
    [_fromLongitude release];
    [_fromLatitude release];
    [_toAddress release];
    [_useTime release];
    [_passengerName release];
    [_passengerPhone release];
    [_addPrice release];
    [_mapSupplier release];
    [_city release];
    [_orderIp release];
    SFRelease(_orderId);
    [super dealloc];
}

@end