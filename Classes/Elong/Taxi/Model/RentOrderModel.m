//
//  RentOrderModel.m
//  ElongClient
//
//  Created by licheng on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentOrderModel.h"

@implementation RentOrderModel


-(void)dealloc{
    
    setFree(_canContinuePay);
    setFree(_carTypeName);
    setFree(_cityName);
    setFree(_flightNum);
    setFree(_fromAddress);
    setFree(_orderId);
    setFree(_orderStatus);
    setFree(_orderTime);
    setFree(_productTypeName);
    setFree(_serviceSupportor);
    setFree(_toAddress);
    setFree(_useTime);
    setFree(_orderStatusDesc);
    
    [super dealloc];
}


@end
