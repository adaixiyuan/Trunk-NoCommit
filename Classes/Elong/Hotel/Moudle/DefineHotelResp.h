/*
 *  DefineHotelResp.h
 *  ElongClient
 *
 *  Created by bin xing on 11-3-5.
 *  Copyright 2011 DP. All rights reserved.
 *
 */
/* 
 * L Long
 * I Integer
 * B boolean
 * ED Elong Date Format
 * A Array
 * S String
 * D double float
 * HL HotelList 
 * HD HotelDetail
 * HC HotelComment
 * HF_HotelFavorite
 */

#import "DefineCommon.h"

#define RespHF_TotalCount_I							@"TotalCount"
#define RespHF_HotelFavorites_A						@"HotelFavorites"
#define RespHF__HotelName_S								@"HotelName"
#define RespHF__HotelId_S								@"HotelId"
#define RespHF__Star_I									@"Star"
#define RespHF__Rating_D								@"Rating"
#define RespHF__PhoneNumber_S							@"PhoneNumber"
#define RespHF__Address_S								@"Address"


#define RespHC_HotelId_S							@"HotelId"
#define RespHC_TotalCount_I							@"TotalCount"
#define RespHC_GoodCount_I							@"GoodCount"
#define RespHC_BadCount_I							@"BadCount"
#define RespHC_Comments_A							@"Comments"
#define RespHC__Id_L									@"Id"
#define RespHC__HotelId_S								@"HotelId"
#define RespHC__UserName_S								@"UserName"
#define RespHC__Content_S								@"Content"
#define RespHC__CommentDateTime_ED						@"CommentDateTime"
#define RespHC__RecommendType_I							@"RecommendType"


#define RespHL_HotelCount_I							@"HotelCount"
#define	RespHL_HotelList_A							@"HotelList"
#define RespHL_PSGHotels                                @"PSGHotels"
#define RespHL__HotelId_S								@"HotelId"
#define RespHL__HotelName_S								@"HotelName"
#define RespHL__StarCode_I								@"StarCode"
#define RespHL__Latitude_D								@"Latitude"
#define RespHL__Longitude_D								@"Longitude"
#define RespHL__Address_S								@"Address"
#define RespHL__Distance_D								@"Distance"
#define RespHL__PicUrl_S								@"PicUrl"
#define RespHL__RecommendRooms_A						@"RecommendRooms"
#define RespHL__BadCommentCount_I						@"BadCommentCount"
#define RespHL__GoodCommentCount_I						@"GoodCommentCount"
#define RespHL__TotalCommentCount_I						@"TotalCommentCount"
#define RespHL__LowestPrice_D							@"LowestPrice"
#define RespHL__Rating_D								@"Rating"
#define RespHL__DistrictName							@"DistrictName"
#define RespHL__BusinessAreaName                        @"BusinessAreaName"
#define RespHL_Currency								@"Currency"
#define RespHL_HotelSpecialType                         @"HotelSpecialType"
#define RespHL_LastMinutesDesp                         @"LastMinutesDesp"

#define RespHD_HotelName_S							@"HotelName"
#define RespHD_HotelId_S							@"HotelId"
#define RespHD_Star_I								@"Star"
#define RespHD_PicUrl_S								@"PicUrl"
#define RespHD_PicUrls_S							@"PicUrls"
#define RespHD_SmallPicUrls							@"SmallPicUrls"
#define RespHD_GoodCommentCount_I					@"GoodCommentCount"
#define RespHD_BadCommentCount_I					@"BadCommentCount"
#define RespHD_TotalCommentCount_I					@"TotalCommentCount"
#define RespHD_Rating_D								@"Rating"
#define RespHD_Phone_S								@"Phone"
#define RespHD_Longitude_D							@"Longitude"
#define RespHD_Latitude_D							@"Latitude"
#define RespHD_Address_S							@"Address"
#define RespHD_AreaName_S							@"AreaName"
#define RespHD_FeatureInfo_S						@"FeatureInfo"
#define RespHD_GeneralAmenities_S					@"GeneralAmenities"
#define RespHD_BookingRuleDesc_S					@"BookingRuleDesc"
#define RespHD_TrafficAndAroundInformations_S		@"TrafficAndAroundInformations"
#define RespHD_Rooms_A								@"Rooms"
#define RespHD_IsCustomerNameEn						@"IsCustomerNameEn" 
#define RespHD__RoomTypeId_S							@"RoomTypeId"
#define RespHD__RoomTypeName_S							@"RoomTypeName"
#define RespHD__FirstDayPrice_D							@"FirstDayPrice"
#define RespHD__AveragePrice_D							@"AveragePrice"
#define RespHD__TotalPrice_D							@"TotalPrice"
#define RespHD__IsAvailable_B							@"IsAvailable"
#define RespHD__HotelCoupon_DI							@"HotelCoupon"
#define RespHD___PromotionId_I								@"PromotionId"
#define RespHD___PromotionType_I							@"PromotionType"
#define RespHD___TrueUpperlimit							@"TrueUpperlimit"
#define RespHD___Upperlimit_I								@"Upperlimit"
#define RespHD__Description_S							@"Description"
#define RespHD__PicUrl_S								@"PicUrl"
#define RespHD__RatePlanId_L							@"RatePlanId"
#define RespHD__VouchSet_DI								@"VouchSet"
#define RespHD___IsArriveTimeVouch_B						@"IsArriveTimeVouch"
#define RespHD___IsRoomCountVouch_B							@"IsRoomCountVouch"
#define RespHD___IsWeekEffective_A							@"IsWeekEffective"
#define RespHD___DateType_I									@"DateType"
#define RespHD___ArriveEndTime_ED							@"ArriveEndTime"
#define RespHD___ArriveStartTime_ED							@"ArriveStartTime"
#define RespHD___StartDate_S								@"StartDate"
#define RespHD___EndDate_S									@"EndDate"
#define RespHD___RoomCount_I								@"RoomCount"
#define RespHD___VouchMoneyType_I							@"VouchMoneyType"
#define RespHD___Descrition_S								@"Descrition"

#define CURRENCY_RMB								@"RMB"
#define CURRENCY_RMBMARK							@"¥"
#define CURRENCY_HKD								@"HKD"
#define CURRENCY_HKDMARK							@"HK$"
#define CURRENCY_MOP								@"MOP"
#define CURRENCY_MOPMARK							@"MOP"

#define LOCATIONTYPEID_HOTEL		@"LocationTypeID"
#define TAGID_HOTEL					@"TagID"
#define TYPEID_HOTEL				@"TypeID"

// 选定的房型
#define ExSelectRoomType            @"SelectRoomType"