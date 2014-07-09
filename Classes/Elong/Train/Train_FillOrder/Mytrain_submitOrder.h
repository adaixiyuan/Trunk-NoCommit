//
//  Mytrain_submitOrder.h
//  ElongClient
//
//  Created by 赵 海波 on 13-11-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mytrain_submitOrder : NSObject

@property (nonatomic, strong) NSString *fromStationName;    // 出发车站名称
@property (nonatomic, strong) NSString *toStationName;      // 到达车站名称
@property (nonatomic, strong) NSString *startDate;          // 出发日期
@property (nonatomic, strong) NSString *trainNumber;        // 车次
@property (nonatomic, strong) NSString *passengers;         // 乘客信息（包含对象Passenger）
@property (nonatomic, strong) NSString *payChannel;         // 支付渠道（暂不支持）
@property (nonatomic, strong) NSString *wrapperld;          // 票的数据来源
@property (nonatomic, strong) NSString *userMobile;         // 用户的手机号
@property (nonatomic, strong) NSString *uid;                // 登陆时传入cardNO，非登陆时传入deviceID

@end


// 乘客信息
@interface Passenger : NSObject

@property (nonatomic, strong) NSString *name;             // 乘客姓名
@property (nonatomic, strong) NSString *mobile;           // 乘客手机号
@property (nonatomic, strong) NSString *certType;         // 证件类型代码
@property (nonatomic, strong) NSString *certNumber;       // 证件号码
@property (nonatomic, strong) NSString *passengerType;    // 乘车类型
@property (nonatomic, strong) NSString *seatCode;         // 座席代码
@property (nonatomic, strong) NSString *price;            // 票价

@end