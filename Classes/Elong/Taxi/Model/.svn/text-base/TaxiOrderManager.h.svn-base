//
//  TaxiOrderManager.h
//  ElongClient
//
//  Created by nieyun on 14-2-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaxiRoot.h"
#import "EvaluteModel.h"

typedef enum {

    TaxiReserve_inThirtyMins = 10,//30分钟以内
    TaxiReserve_thirtyTo48Hours,//30分钟到48小时
    TaxiReserve_out48Hours,        //48小时以后
    TaxiReserve_TimeError = 100,//时间错误
    
}TaxiReserveType;

@class TaxiOrder;
@interface TaxiOrderManager : NSObject

+ (id) shareInstance;
/*
 *打车业务
 */
@property  (nonatomic,retain)  NSString  *taxiOrderId;
@property  (nonatomic,retain)  TaxiOrder *order;//OrderID为空，不适合加价叫车
@property  (nonatomic,assign)  TaxiType currentType;
-(BOOL)checkTheOrderJumpSendingView;
-(TaxiReserveType)checkTaxiReserveType;

/*
 *租车业务
 */
@property (nonatomic,assign) RentCarType rentCarType;

@end
