//
//  UniformDepositModel.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UniformDepositModel.h"
#import "HotelPostManager.h"
#import "FlightOrderConfirm.h"
#import "GrouponConfirmViewController.h"
#import "ConfirmHotelOrder.h"
#import "FlightOrderConfirm.h"


static UniformDepositModel *model = nil;

@implementation UniformDepositModel

+ (id)shared
{
    @synchronized(model)
    {
        if (!model)
        {
            model = [[UniformDepositModel alloc] init];
        }
    }
    
    return model;
}


- (void)beginForType:(UniformFromType)type
{
    switch (type) {
        case UniformFromTypeHotel:
        {
            // 进入支付宝使用储蓄卡支付酒店
            [self dealNativeHotel];
        }
            break;
        case UniformFromTypeGroupon:
        {
            // 支付宝客户端团购支付
            [self dealGroupon];
        }
            break;
        case UniformFromTypeFlight:
        {
            // 支付宝客户端团购支付
            [self dealFlight];
        }
            break;
            
        default:
            break;
    }
}


- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}


#pragma mark - Model Methods

- (void)dealNativeHotel
{
    // 设置酒店下单支付宝参数
    [[HotelPostManager hotelorder] setAlipayInfo:@"alipay:return" withCancelURL:@"alipay:back" withName:@"hotel" withBody:@"pay"];
    [[HotelPostManager hotelorder] setVouch:VouchSetTypeAlipayWap vouchMoney:[[HotelPostManager hotelorder] getTotalPrice] vouchData:nil];
    
    // 设置支付类型
    hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
    hotelconfirmorder.payType = VouchSetTypeAlipayWap;
    [hotelconfirmorder nextState];
}


- (void)dealGroupon
{
    grouponConfirmVC = [[GrouponConfirmViewController alloc] initWithCardInfo:nil];
    grouponConfirmVC.payType = GrouponOrderPayTypeAlipay;
    [grouponConfirmVC nextState];
}


- (void)dealFlight
{
    controller = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:nil];
    [controller nextState:UniformPaymentTypeDepositCard];
}

@end
