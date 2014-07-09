//
//  TaxiDetaileModel.h
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"
#import "TaxiSupply.h"
#import "TaxiRequestInfo.h"
#import "TaxiResponseInfo.h"

@interface TaxiDetaileModel : BaseModel
@property (nonatomic,retain)NSString  *orderId;
@property (nonatomic,retain)NSString  *orderStatus;
@property (nonatomic,retain)NSString  *orderTime;
@property (nonatomic,retain)NSString  *driverNum;
@property (nonatomic,retain) NSString  *orderStatusDesc;
@property (nonatomic,retain)TaxiSupply  *supplierInfo;
@property (nonatomic,retain)TaxiRequestInfo *requestInfo;
@property (nonatomic,retain)TaxiResponseInfo *responseInfo;
@end
