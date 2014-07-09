//
//  HotelInfo.h
//  ElongClient
//
//  Created by guorendong on 14-4-21.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseModel.h"

@interface XGHoldingTimeOption:XGBaseModel<NSCoding>

@property(nonatomic,strong)NSNumber *ArriveTimeEarly;//
@property(nonatomic,strong)NSNumber *ArriveTimeLate;//
@property(nonatomic,strong)NSNumber *IsDefault;//
@property(nonatomic,strong)NSNumber *NeedVouch;//
@property(nonatomic,strong)NSArray *ShowTime;//

@end

@interface XGRoomStyle:XGBaseModel<NSCoding>
- (NSString *) roomTypeTips:(NSInteger)guestType;
- (NSString *) roomTypeTips;
-(NSString *)getRoomTypeByAdditionInfoList;
-(NSString *)getRoomTypeFormerTextByAdditionInfoList;

//通过AdditionInfoList 获取的信息
@property(nonatomic,strong)NSString *breakfast;
@property(nonatomic,strong)NSString *bed;
@property(nonatomic,strong)NSString *network;
@property(nonatomic,strong)NSString *area;
@property(nonatomic,strong)NSString *floor;
@property(nonatomic,strong)NSString *other;
@property(nonatomic,strong)NSString *personnum;
@property(nonatomic,strong)NSString *roomtype;

@property(nonatomic,strong)NSString *PicUrl;//如：高级大床房
@property(nonatomic,strong)NSString *RoomTypeId;//如 无早
@property(nonatomic,strong)NSString *RoomTypeName;//如 无早
@property(nonatomic,strong)NSNumber *FinalPrice;//抢单价格
@property(nonatomic,strong)NSArray *AdditionInfoList;//房型附加信息清单
@property(nonatomic,strong)NSArray *HoldingTimeOptions;//房间保留时间选项
@property(nonatomic,strong)NSMutableArray *HoldingTimeOptionsEntity;//房间保留时间选项
@property(nonatomic,strong)NSArray *PrepayRules;//预付规则
@property(nonatomic,strong)NSMutableArray *PrepayRulesEntity;//
@property(nonatomic,strong)NSArray *HotelCoupon;//
@property(nonatomic,strong)NSMutableArray *HotelCouponEntity;//
@property(nonatomic,strong)NSArray *VouchAdded;//担保规则（附加） 关心无罚金取消时间，罚金金额，冻结金额，
@property(nonatomic,strong)NSDictionary *VouchSet;//担保规则
@property(nonatomic,strong)NSNumber *Auto;//
@property(nonatomic,strong)NSNumber *AveragePrice;//
@property(nonatomic,strong)NSNumber *CancelType;//
@property(nonatomic,strong)NSNumber *CustomerLevel;//
@property(nonatomic,strong)NSNumber *ExchangeRate;//汇率
@property(nonatomic,strong)NSNumber *FirstDayPrice;//最终价格
@property(nonatomic,strong)NSNumber *GuestType;//
@property(nonatomic,strong)NSNumber *InvoiceMode;//
@property(nonatomic,strong)NSNumber *IsAvailable;//
@property(nonatomic,strong)NSNumber *IsCustomerNameEn;//
@property(nonatomic,strong)NSNumber *IsLastMinutesRoom;//
@property(nonatomic,strong)NSNumber *IsPhoneOnly;//
@property(nonatomic,strong)NSNumber *IsTimeLimit;//
@property(nonatomic,strong)NSNumber *LongCuiOriginalPrice;//
@property(nonatomic,strong)NSNumber *MinCheckinRooms;//
@property(nonatomic,strong)NSNumber *MinRoomStocks;//
@property(nonatomic,strong)NSNumber *OriginalPrice;//
@property(nonatomic,strong)NSNumber *PayType;//支付类型 0到店支付，1预付
@property(nonatomic,strong)NSNumber *RatePlanId;//
@property(nonatomic,strong)NSNumber *SHotelID__;//没有最后__但是被定义了，所以只能
@property(nonatomic,strong)NSNumber *TotalPrice;//
@property(nonatomic,strong)NSString *Remark;//
@property(nonatomic,strong)NSString *CancelDesc;//
@property(nonatomic,strong)NSString *Currency;//
@property(nonatomic,strong)NSString *Description;//
@property(nonatomic,strong)NSString *GiftDescription;//
@end

@interface XGHotelInfo : XGBaseModel<NSCoding>
@property(nonatomic,strong)NSString *HotelId;
@property(nonatomic,strong)NSString *HotelName;//酒店
@property(nonatomic,strong)NSString *PicUrl;//
@property(nonatomic,strong)NSString *Phone;//
@property(nonatomic,strong)NSString *HotelPhone;//

@property(nonatomic,strong)NSString *Address;//地址
@property(nonatomic,strong)NSString *AreaName;//
@property(nonatomic,strong)NSString *CityName;//
@property(nonatomic,strong)NSString *BookingRuleDesc;//
@property(nonatomic,strong)id BusinessAreaId;//
@property(nonatomic,strong)NSNumber *CAInvoiceLimitRule;//
@property(nonatomic,strong)NSString *FeatureInfo;//
@property(nonatomic,strong)NSString *GeneralAmenities;//
@property(nonatomic,strong)NSString *ExtendDespField;//
@property(nonatomic,strong)NSNumber *ExtendByteField;//
@property(nonatomic,strong)NSNumber *Distantce;//
@property(nonatomic,strong)NSNumber *BadCommentCount;//
@property(nonatomic,strong)NSNumber *GoodCommentCount;//
@property(nonatomic,strong)NSNumber *HotelCategory;//
@property(nonatomic,strong)NSNumber *HotelSpecialType;//
@property(nonatomic,strong)NSNumber *TotalCommentCount;//

@property(nonatomic,strong)NSString *HelpfulTips;//
@property(nonatomic,strong)NSString *TrafficAndAroundInformations;//

@property(nonatomic,strong)NSNumber *Star;//星级
@property(nonatomic,strong)NSNumber *FinalPrice;//最终价格
@property(nonatomic,strong)NSNumber *NewStarCode;//星级(含准星级>=100)
@property(nonatomic,strong)NSNumber *Rating;//评分
@property(nonatomic,strong)NSNumber *Longitude;//经度
@property(nonatomic,strong)NSNumber *Latitude;//纬度
@property(nonatomic,strong)NSNumber *HotelFacilityCode;//酒店设施code(1：免费wifi 2: 收费wifi 3：预留 4：预留 5：免费停车场 6：收费停车场 7：免费接机服务 8：收费接机服务 9：室内游泳池 10：室外游泳池 11：健身房 12：商务中心 13：会议室 14:酒店餐厅 15：宽带上网)

@property(nonatomic,strong)NSNumber *BusinessResponseId;//商家响应Id
@property(nonatomic,strong)NSNumber *Distance;//jule

@property(nonatomic,strong)NSMutableArray *Rooms;//roomStyle的字典列表列表
@property(nonatomic,strong)NSMutableArray *RoomsEntity;//roomStyle列表

@property(nonatomic,strong,readonly)XGRoomStyle *room;//roomStyle列表

@property(nonatomic,strong)NSString *Remark;//标注
@property(nonatomic,strong)NSString *RequestId;//不是借口返回，是我们一一对应的数据

@end

@interface XGRequestHotels : XGBaseModel
ModelErrorPropertys

@property(nonatomic,strong)NSString *hotelId;

@property(nonatomic,strong)NSNumber *timestamp;

@property(nonatomic,strong)NSMutableArray *hotelList;//roomStyle列表

@end