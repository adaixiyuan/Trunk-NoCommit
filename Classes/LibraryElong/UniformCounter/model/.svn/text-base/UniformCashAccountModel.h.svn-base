//
//  UniformCashAccountModel.h
//  ElongClient
//  统一收银台现金账户处理逻辑
//
//  Created by 赵 海波 on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniformCounterViewController.h"
#import "FlightOrderConfirm.h"

@class GrouponConfirmViewController, UniformCounterDataModel;
@interface UniformCashAccountModel : NSObject
{
    ElongClientAppDelegate *appDelegate;
    
    int netType;        // 网络请求类型
    GrouponConfirmViewController *grouponConfirmVC;
    FlightOrderConfirm *flightConfirmVC;
    UniformCounterDataModel *dataModel;
}

+ (id)shared;

// 使用订单流程，总价，密码来进行处理
- (void)beginForType:(UniformFromType)type TotalPrice:(CGFloat)totalPrice Password:(NSString *)pwd;

@end
