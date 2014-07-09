//
//  UniformDepositModel.h
//  ElongClient
//  统一收银台储蓄卡逻辑处理
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniformCounterViewController.h"

@class ConfirmHotelOrder,GrouponConfirmViewController,FlightOrderConfirm;
@interface UniformDepositModel : NSObject
{
    ElongClientAppDelegate *appDelegate;
    ConfirmHotelOrder *hotelconfirmorder;
    GrouponConfirmViewController *grouponConfirmVC;
    FlightOrderConfirm *controller;
}

+ (id)shared;

// 使用订单流程来进行初始化
- (void)beginForType:(UniformFromType)type;

@end
