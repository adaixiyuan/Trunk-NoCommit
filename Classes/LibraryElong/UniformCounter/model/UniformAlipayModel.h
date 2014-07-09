//
//  UniformAlipayModel.h
//  ElongClient
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniformCounterViewController.h"

@class GrouponConfirmViewController,FlightOrderConfirm,ConfirmHotelOrder;
@interface UniformAlipayModel : NSObject
{
    ElongClientAppDelegate *appDelegate;
    GrouponConfirmViewController *grouponConfirmVC;
    FlightOrderConfirm *controller;
    ConfirmHotelOrder *hotelConfirm;
    UniformCounterDataModel *dataModel;
}

+ (id)shared;

// 使用订单流程来进行初始化
- (void)beginForType:(UniformFromType)type;

@end
