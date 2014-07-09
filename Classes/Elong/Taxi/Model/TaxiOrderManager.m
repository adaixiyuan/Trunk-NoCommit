//
//  TaxiOrderManager.m
//  ElongClient
//
//  Created by nieyun on 14-2-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiOrderManager.h"
#import "AddressInfo.h"

@implementation TaxiOrderManager

#define TIME_FORMATTER @"yyyy-MM-dd HH:mm"

 + (id) shareInstance
{
    static  TaxiOrderManager  *instance  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TaxiOrderManager  alloc]init];
    });
    return instance;
}

-(void)dealloc{
    SFRelease(_order);
    SFRelease(_taxiOrderId);
    [super dealloc];
}

-(BOOL)checkTheOrderJumpSendingView{

//    if (self.currentType == Taxi_onCall) {
//        return YES;
//    }

    NSDate *current = [NSDate date];
    NSDate *time = [NSDate dateFromString:self.order.useTime withFormat:TIME_FORMATTER];
    
    if ([time timeIntervalSinceDate:current] > 60*30) {
        return NO;
    }else{
        return YES;
    }
}

-(TaxiReserveType)checkTaxiReserveType{

    NSDate *current = [NSDate date];
    NSDate *useTime = [NSDate dateFromString:self.order.useTime withFormat:TIME_FORMATTER];
    if ([useTime timeIntervalSinceDate:current] <= 60*30) {
        return TaxiReserve_inThirtyMins;
    }else if (([useTime timeIntervalSinceDate:current] > 60*30) && ([useTime timeIntervalSinceDate:current] <= 60*60*48)){
        return TaxiReserve_thirtyTo48Hours;
    }else if ([useTime timeIntervalSinceDate:current] > 60*60*48){
        return TaxiReserve_out48Hours;
    }
    return TaxiReserve_TimeError;
}


@end
