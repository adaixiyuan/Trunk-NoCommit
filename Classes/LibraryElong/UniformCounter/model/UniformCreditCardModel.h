//
//  UniformCreditCardMode.h
//  ElongClient
//  统一收银台信用卡逻辑处理
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//
//  修复团购和机票CA混合信用卡支付时（不需密码），会调用验密接口问题 by 赵海波 on 14-4-4

#import <Foundation/Foundation.h>
#import "UniformCounterViewController.h"

@interface UniformCreditCardModel : NSObject
{
    ElongClientAppDelegate *appDelegate;
}

+ (id)shared;

// 使用订单流程，总价，是否使用CA和CA密码来进行初始化(不使用CA，密码不用传)
- (void)beginForType:(UniformFromType)type
        TotalPrice:(CGFloat)totalPrice
            usedCA:(BOOL)cashAccountAvailable
        CAPassword:(NSString *)pwd;

@end
