//
//  RentOrderModel.h
//  ElongClient
//
//  Created by licheng on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface RentOrderModel : BaseModel

@property(nonatomic,copy)NSString * canContinuePay;
@property(nonatomic,copy)NSString * carTypeName;
@property(nonatomic,copy)NSString * cityName;
@property(nonatomic,copy)NSString * flightNum;
@property(nonatomic,copy)NSString * fromAddress;
@property(nonatomic,copy)NSString * orderId;
@property(nonatomic,copy)NSString * orderStatus;
@property(nonatomic,copy)NSString * orderStatusDesc;
@property(nonatomic,copy)NSString * orderTime;
@property(nonatomic,copy)NSString * productTypeName;
@property(nonatomic,copy)NSString * serviceSupportor;
@property(nonatomic,copy)NSString * toAddress;
@property(nonatomic,copy)NSString * useTime;

@end
