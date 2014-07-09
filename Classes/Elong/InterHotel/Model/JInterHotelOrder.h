//
//  JInterHotelOrder.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JInterHotelOrder : NSObject

- (void)buildPostData:(BOOL)clearRoomPost;      //是否重置数据
-(id)getObjectForKey:(NSString *)key;   //获取对象

- (NSString *)requestString:(BOOL)iscompress;        //请求Content

-(void)setGuid;     //创建唯一序列号
-(void)setMemberShip;       //创建会见卡号
-(void)setContactPersonWithEmail:(NSString *)email telPhone:(NSString *)telPhone;     //创建联系人信息
-(void)setInvoicesInfoWithTitle:(NSArray *)invoiceTitles;       //创建发票信息
-(void)setOrderTotalPrice:(float)totalPrice withDiscountTotal:(float)discountTotalPrice;        //设置订单总价以及优惠的价钱
-(void)setTravellers:(NSArray *)travellers;     //设置入住人信息
-(void)setOrderHotelId:(NSString *)hotelId hotelName:(NSString *)hotelName address:(NSString *)address;     ////设置酒店产品信息
-(void)setArrivalDate:(NSString *)arrivalDate andDepartDate:(NSString *)departDate;     //设置到店日期和离店日期
-(void)setSepecialNeeds:(NSString *)sepecialNeed;       //设置特殊需求
-(void)setRoomInfo:(NSArray *)roomList;         ////设置房间信息
-(void)setPromotionFlag:(int)promotionFlag; //设置促销标识
-(void)setSupplierType:(NSString *)supplierType;    //设置供应商类型
-(void)setCreditCardData:(NSMutableDictionary *)creditCard;        //设置信用卡信息

-(float)getCashAmount;
-(void)setCashAmount:(float)cashAmount;

//新增 为了Mis系统显示完全
-(void)setCurrencyCode:(NSString *)currencyCode;        //设置货币代码
-(void)setCityEnName:(NSString *)cityEnName andCountryCode:(NSString *)countryCode;     //设置城市名和国家代码
-(void)setAverageBaseRate:(float)baseRate averageRate:(float)rate andSurchargeTotal:(float)surchargeTotal;
-(void)setMaxNightRate:(float)maxNightRate nightlyRateTotal:(float)nightlyRateTotal;
-(void)setRoomANameDesc:(NSString *)roomDesc;       //房型名称
-(void)setRoomAddValues:(NSString *)addValues;  //房型附加信息
-(void)setCancelPolicy:(NSString *)policy cancelType:(BOOL)type;

@end
