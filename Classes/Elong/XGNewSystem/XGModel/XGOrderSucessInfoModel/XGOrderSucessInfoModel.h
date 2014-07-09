//
//  XGOrderSucessInfoModel.h
//  ElongClient
//
//  Created by guorendong on 14-5-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseModel.h"
#import "XGHotelInfo.h"

@interface XGOrderSucessInfoModel : XGBaseModel
@property(nonatomic,strong)NSString *CheckInPersonName;
@property(nonatomic,strong)XGHotelInfo *HotelInfo;
@property(nonatomic,strong)XGRoomStyle *RoomInfo;
@property(nonatomic,strong)NSString *OrderId;
@property(nonatomic,strong)NSString *Phone;
@property(nonatomic,strong)NSNumber *RequestId;
@property(nonatomic,strong)NSNumber *TotalPrice;

@property(nonatomic,strong)NSNumber * CheckInDate;
@property(nonatomic,strong)NSNumber * CheckOutDate;

@property(nonatomic,strong)NSString *Remark;//
@property(nonatomic,strong)NSString * HotelPhone;

@property(nonatomic,strong)NSNumber * Latitude;
@property(nonatomic,strong)NSNumber * Longitude;

@end
