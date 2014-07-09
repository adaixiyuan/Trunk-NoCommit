//
//  EvaluteModel.m
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "EvaluteModel.h"

@implementation EvaluteModel

-(void)dealloc{
    self.estimatedAmountDetail = nil;
    self.estimatedDistance = nil;
    self.estimatedPrice = nil;
    self.estimatedTime = nil;
    self.notice = nil;
    [super dealloc];
}
@end

@implementation EvalueRequestModel

-(void)dealloc{

    self.cityCode = nil;
    self.productType= nil;
    self.airPortCode= nil;
    self.carTypeCode= nil;
    self.rentTime= nil;
    self.fromAddress= nil;
    self.fromLongitude= nil;
    self.fromLatitude= nil;
    self.toAddress= nil;
    self.toLongitude= nil;
    self.toLatitude= nil;
    self.serviceSupportor= nil;
    self.mapSupporter = nil;
    self.startTime = nil;
    self.flightNum = nil;
    
    [super dealloc];
}
@end

@implementation OrderRequestModel

-(void)dealloc{

    self.passengerName = nil;
    self.passengerPhone= nil;
    self.passengerNum= nil;
    self.needReceipt= nil;
    self.receiptTitle= nil;
    self.receiptContent= nil;
    self.receiptAddress= nil;
    self.receiptPostCode= nil;
    self.receiptPerson= nil;
    self.receiptPhone= nil;
    self.receiptType = nil;
    self.note= nil;
    self.isAsap= nil;
    self.orderAmount= nil;
    self.orderAmountDetail= nil;
    self.mapSupporter = nil;
    self.uid = nil;
    self.carTypeName = nil;
    self.carTypeBrand = nil;
    self.carTypeId = nil;
    [super dealloc];
}

@end