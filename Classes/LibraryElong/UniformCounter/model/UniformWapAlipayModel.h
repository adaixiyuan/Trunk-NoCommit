//
//  UniformWapAlipayModel.h
//  ElongClient
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniformCounterViewController.h"


@class FlightOrderConfirm,GrouponConfirmViewController,ConfirmHotelOrder, UniformCounterDataModel;
@interface UniformWapAlipayModel : NSObject
{
    ElongClientAppDelegate *appDelegate;
    ConfirmHotelOrder *hotelconfirmorder;
    GrouponConfirmViewController *grouponConfirmVC;
    FlightOrderConfirm *controller;
    UniformCounterDataModel *dataModel;
    BOOL jumpToSafari;          // 标志是否由app跳入wap页
}

+ (id)shared;

// 使用订单流程来进行初始化
- (void)beginForType:(UniformFromType)type;

@end
