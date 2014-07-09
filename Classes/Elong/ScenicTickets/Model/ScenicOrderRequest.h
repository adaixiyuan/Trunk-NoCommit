//
//  ScenicOrderRequest.h
//  ElongClient
//  订单填写Model 
//  Created by jian.zhao on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ScenicOrderRequest : BaseModel

@property(nonatomic,copy) NSString *sceneryId;
@property(nonatomic,copy) NSString *supplierId;
@property(nonatomic,copy) NSString *tName;
@property(nonatomic,copy) NSString *tMobile;
@property(nonatomic,copy) NSString *idCard;
@property(nonatomic,copy) NSString *policyId;
@property(nonatomic,copy) NSString *tickets;
@property(nonatomic,copy) NSString *travelDate;
@property(nonatomic,copy) NSString *orderIP;
@property(nonatomic,copy) NSArray  *otherGuestList; //gName gMobile

@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *elongPrice;
@property(nonatomic,copy) NSString *cityId;

@end


@interface OtherGuest: BaseModel
@property(nonatomic,copy) NSString *gName;
@property(nonatomic,copy) NSString *gMobile;
@end