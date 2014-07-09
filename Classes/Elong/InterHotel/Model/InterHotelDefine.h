//
//  InterHotelDefine.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#ifndef ElongClient_InterHotelDefine_h
#define ElongClient_InterHotelDefine_h

#define Req_InterHotelId @"HotelId"     //酒店ID
#define Req_ArriveDate @"ArrivalDate"       //到店日期
#define Req_DepartureDate @"DepartureDate"      //离店日期
#define Req_RoomGroup @"RoomGroup"      //入住人信息
#define Req_PromotionTag @"PromotionTag"    //促销标识，用来区分10倍积分

#define InterHotel_Name          @"HotelName"
#define InterHotel_Rating        @"HotelRating"
#define InterHotel_UserRating    @"MedianUserRating"
#define InterHotel_Address       @"HotelAddress"
#define InterHotel_LowRate       @"LowRate"
#define InterHotel_PromoRate      @"PromoRate"
#define InterHotel_ListImgUrl    @"ThumbNailUrl"
#define InterHotel_HotelId       @"HotelId"
#define InterHotel_Location      @"Location"
#define InterHotel_CountryCode @"CountryCode"
#define InterHotel_CityEnName @"CityEnName"

#define InterHotel_HotelProperty @"HotelProperty"
#define InterHotel_PromoDescription @"PromoDescription"
#define Cnname_CityList_InterHotel  @"n"       // 国际城市列表中文名称
#define Ename_CityList_InterHotel   @"e"       // 国际城市列表英文名称
#define Description_CityList_InterHotel   @"s"       // 国际城市描述
#define DESTINATION_CITYLIST_INTERHOTEL   @"d"       // 国际酒店列表城市编码
#define DaoDaoPixelPicUrl        @"DaoDaoPixelPicUrl"   // 到到网请求地址

//Order Info
#define Req_ClientOrderId  @"ClientOrderId"      //唯一序列号
#define Req_MemberShip @"MemberShip"        //会员卡号
#define Req_CreditCardInfo @"CreditCardInfo"        //信用卡信息
#define Req_ContactPerson @"ContactPerson"      //联系人信息
#define Req_Email @"Email"      //邮件
#define Req_MobileTelephone @"MobileTelephone"      //手机号
#define Req_ContactPersonName @"ContactPersonName"      //联系人名字
#define Req_InvoiceTitle @"InvoiceTitle"        //发票抬头
#define Req_Invoices @"Invoices"        //发票
#define Req_InterHotelProducts @"InterHotelProducts"        //产品信息
#define Req_OrderTotalPrice @"Total"        //订单总价
#define Req_CouponDiscount @"CouponDiscount"        //优惠价格
#define Req_TravellerName @"TravellerName"      //入住人名字
#define Req_Travellers @"Travellers"        //入住人集合
#define Req_HotelID @"HotelID"      //酒店Id
#define Req_HotelName @"HotelName"      //酒店名
#define Req_HotelAddress @"Address"      //酒店地址
#define Req_CheckInDate @"CheckInDate"      //入住日期
#define Req_CheckOutDate @"CheckOutDate"        //离店日期
#define Req_SpecialNeeds @"SpecialNeeds"        //特殊需求
#define Req_InterHotelRoomTypes @"InterHotelRoomTypes"  //酒店房间信息
#define Req_PromotionTag @"PromotionTag"        //促销标识
#define Req_RoomSupplierType @"RoomSupplierType"        //供应商类型
#define Req_HotelCity @"HotelCity"      //城市名
#define Req_HotelCountry @"HotelCountry"        //城市代码
#define Req_CurrencyCode @"CurrencyCode"        //货币代码
#define Req_AverageBaseRate @"AverageBaseRate"      //房间单价原价
#define Req_AverageRate @"AverageRate"      //房间促销单价
#define Req_SurchargeTotal @"SurchargeTotal"    //总税费
#define Req_MaxNightlyRate @"MaxNightlyRate"        //今夜放假最大价
#define Req_NightlyRateTotal @"NightlyRateTotal"        //Mis中用于价格计算的房间总价
#define Req_RoomANameDesc @"RoomANameDesc"      //用于Mis系统中，房型信息的提示显示
#define Req_AddValues @"AddValues"      //房型介绍，用于Mis系统显示
#define Req_Cancelpolicy @"Cancelpolicy"        //取消政策内容
#define Req_IsCanCancel @"IsCanCancel"      //能否取消标识

#endif
