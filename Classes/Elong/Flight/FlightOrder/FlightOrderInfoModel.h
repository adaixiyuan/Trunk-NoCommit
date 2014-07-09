//
//  FlightOrderInfoModel.h
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"
#import "AirlineInfoModel.h"

@interface FlightOrderInfoModel : BaseModel
@property  (nonatomic,retain) NSString  *OrderNo;
@property  (nonatomic,retain) NSString  *OrderCode;
@property  (nonatomic,retain) NSString  *CreateTime;
@property  (nonatomic,retain) NSString  *IsAllowContinuePay;
@property  (nonatomic,retain) NSString  *TravalType;
@property  (nonatomic,retain) NSArray  *AirLineInfos;
@property  (nonatomic,retain) NSNumber  *TotalPrice;
@end
