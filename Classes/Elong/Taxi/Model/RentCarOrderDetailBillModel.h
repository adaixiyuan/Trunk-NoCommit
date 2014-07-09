//
//  RentCarOrderDetailBillModel.h
//  ElongClient
//
//  Created by licheng on 14-3-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface RentCarOrderDetailBillModel : BaseModel
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *gOrderId;
@property(nonatomic,copy)NSString *useTime;
@property(nonatomic,copy)NSString *timeLength;
@property(nonatomic,copy)NSString *kiloLength;
@property(nonatomic,copy)NSString *totalPrice;
@property(nonatomic,copy)NSArray *billDetail;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;

@end
