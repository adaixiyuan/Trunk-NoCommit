//
//  XGOrderModel.h
//  ElongClient
//
//  Created by guorendong on 14-5-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseModel.h"

@interface XGOrderActionModel : XGBaseModel


@property(nonatomic,strong)NSNumber * ActionId;
@property(nonatomic,strong)NSString * ActionName;
@property(nonatomic,strong)NSNumber * Position;


@end


@interface XGOrderStatusModel : XGBaseModel


@property(nonatomic,strong)NSMutableArray * Actions;
@property(nonatomic,strong)NSMutableArray * ActionsEntity;
@property(nonatomic,strong)NSString * Tip;


@end

@interface XGOrderButton : XGBaseModel

@property(nonatomic,strong)NSString * Desc;
@property(nonatomic,strong)NSNumber * Type;
@end

@interface XGOrderModel : XGBaseModel


+(NSArray *)comvertModelForJsonArray:(NSArray *)array;
@property(nonatomic,strong)XGOrderStatusModel * NewOrderStatus;
@property(nonatomic,strong)NSNumber * CommentFlag;//0
@property(nonatomic,strong)XGOrderButton * RightButton;//0
@property(nonatomic,strong)XGOrderButton * BelowButton;//0
@property(nonatomic,strong)NSString * OrderId;//C2C订单号
@property(nonatomic,strong)NSString * OrderNo;
@property(nonatomic,strong)NSString *Tip;
@property(nonatomic,strong)NSString * CardNo;
@property(nonatomic,strong)NSNumber * ArriveDate;//到点日期
@property(nonatomic,strong)NSString * CityName;
@property(nonatomic,strong)NSString * ClientStatusDesc;
@property(nonatomic,strong)NSString * Contactor;
@property(nonatomic,strong)NSString * Cost;
@property(nonatomic,strong)NSString * CounponAmount;
@property(nonatomic,strong)NSNumber * CreateTime;
@property(nonatomic,strong)NSString * CreatorName;
@property(nonatomic,strong)NSString * Currency;
@property(nonatomic,strong)NSNumber * ReserveTime;  //createtime  预定时间
@property(nonatomic,strong)NSString * GuestName;//李程
@property(nonatomic,strong)NSString * Gutests;
@property(nonatomic,strong)NSString * HotelAddress;

@property(nonatomic,strong)NSString * HotelName;
@property(nonatomic,strong)NSString * HotelPhone;
@property(nonatomic,strong)NSString * LatestChangeTime;
@property(nonatomic,strong)NSNumber * LeaveDate;//离店日期
@property(nonatomic,strong)NSString * PicUrl;
@property(nonatomic,strong)NSString * PromisedTime;
@property(nonatomic,strong)NSString * RatePlanName;
@property(nonatomic,strong)NSString * RoomTypeName;


@property(nonatomic,strong)NSNumber * StateCode;
@property(nonatomic,strong)NSString * StateName;//等待确认
@property(nonatomic,strong)NSString * ThirdPartyPaymentInfo;
@property(nonatomic,strong)NSNumber * TimeEarly;
@property(nonatomic,strong)NSNumber * TimeLate;
@property(nonatomic,strong)NSString * VouchSet;
@property(nonatomic,strong)NSNumber * RelationOrderId;//关联RelationOrderId
//@property(nonatomic,strong)NSString * OrderNo;

@property(nonatomic,strong)NSNumber * Latitude;
@property(nonatomic,strong)NSNumber * Longitude;
@property(nonatomic,strong)NSNumber * PayType;

@property(nonatomic,strong)NSNumber * CanEditContactor;
@property(nonatomic,strong)NSNumber * CanEditGuests;
@property(nonatomic,strong)NSNumber * CancelStatus;
@property(nonatomic,strong)NSNumber * Cancelable;
@property(nonatomic,strong)NSNumber * CardNumber;
@property(nonatomic,strong)NSNumber * GuestCount;
@property(nonatomic,strong)NSNumber * DoubleCredit;
@property(nonatomic,strong)NSNumber * HotelId;
@property(nonatomic,strong)NSNumber * IsCanBeEdited;
@property(nonatomic,strong)NSNumber * IsCanContinuePay;
@property(nonatomic,strong)NSNumber * IsConfirmed;
@property(nonatomic,strong)NSNumber * IsSpecialPrice;
@property(nonatomic,strong)NSNumber * RatePlanId;
@property(nonatomic,strong)NSNumber * Payment;
@property(nonatomic,strong)NSNumber * RoomCount;

@property(nonatomic,strong)NSNumber *WareCount;  //订单详情 房间数量

@property(nonatomic,strong)NSNumber * RoomTypeId;
@property(nonatomic,strong)NSNumber * SumPrice;

@end
