//
//  FlightOrderInfoModel.m
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightOrderInfoModel.h"

@implementation FlightOrderInfoModel
- (void)dealloc
{
    [_OrderNo  release];
    [_OrderCode  release];
    [_CreateTime  release];
    [_IsAllowContinuePay  release];
    [_TravalType  release];
    [_AirLineInfos  release];
    [_TotalPrice  release];
    [super dealloc];
}

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super  setAttributes:dataDic];
    }
@end
