//
//  CountlyEventHotelMemberFillinOrderPageNextSetp.h
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventClick.h"

@interface CountlyEventHotelFillinOrderPageNextStep : CountlyEventClick
@property (nonatomic,copy) NSString *vouchType;
@property (nonatomic,copy) NSNumber *payType;
@property (nonatomic,copy) NSString *hotelName;
@property (nonatomic,copy) NSString *hotelId;
@property (nonatomic,copy) NSString *roomName;
@property (nonatomic,copy) NSNumber *roomId;
@property (nonatomic,copy) NSString *bedType;
@property (nonatomic,copy) NSString *webFree;
@property (nonatomic,copy) NSString *breakfast;
@property (nonatomic,copy) NSNumber *roomNum;
@property (nonatomic,copy) NSString *checkIn;
@property (nonatomic,copy) NSString *checkOut;
@property (nonatomic,copy) NSNumber *amount;
@property (nonatomic,copy) NSNumber *invoiceStatus;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *invoiceType;
@property (nonatomic,copy) NSString *invoiceAddress;
@end
