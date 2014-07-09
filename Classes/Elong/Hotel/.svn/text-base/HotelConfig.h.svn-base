//
//  Hotel.h
//  ElongClient
//  定义一些酒店宏、常量和枚举
//
//  Created by 赵 海波 on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//
#define IMG_TYPE_ALL        @"所有"
#define IMG_TYPE_GUESTROOM  @"客房"
#define IMG_TYPE_EXTERIOR   @"外观"
#define IMG_TYPE_RECEPTION  @"前台"
#define IMG_TYPE_OTHER      @"设施"

#define HOTEL_NEARBY_RADIUS 5000                            // 国内酒店周边搜索半径

#define HOTEL_SEARCH_KEYWORD @"HOTEL_SEARCH_KEYWORD"        // 国内酒店搜索关键词

// 酒店图片分类
typedef enum
{
    HotelImageTypeAll        = 0,   // 全部（基本不可能出现这个类型）
    HotelImageTypeRestaurant = 1,   // 餐厅
    HotelImageTypeRecreation = 2,   // 休闲
    HotelImageTypeMeeting    = 3,   // 会议室
    HotelImageTypeExterior   = 5,   // 酒店外观
    HotelImageTypeReception  = 6,   // 大堂接待台
    HotelImageTypeGuestRoom  = 8,   // 客房
    HotelImageTypeBackground = 9,   // 背景图
    HotelImageTypeOther      = 10   // 其它
}HotelImageType;

// 酒店担保或预付种类
typedef enum
{
    VouchSetTypeNormal         = 0, // 不担保
    VouchSetTypeCreditCard     = 1, // 信用卡担保或预付
    VouchSetTypeAlipayWap      = 2, // 支付宝Wap预付
    VouchSetTypeWeiXinPayByApp = 5, // 微信预付
    VouchSetTypeAlipayApp      = 7  // 支付宝担保或预付
}VouchSetType;

// 酒店关键词搜索种类
typedef enum {
    HotelKeywordTypeNormal                   = 9,   // 酒店名或未知
    HotelKeywordTypeBusiness                 = 3,   // 商圈
    HotelKeywordTypeDistrict                 = 6,   // 行政区
    HotelKeywordTypeBrand                    = 5,   // 品牌
    HotelKeywordTypeAirportAndRailwayStation = 1,   // 机场火车站
    HotelKeywordTypeSubwayStation            = 2,   // 地铁站
    HotelKeywordTypePOI                      = 99   // POI
}HotelKeywordType;

// 酒店筛选支付方式
typedef enum {
    HotelFilterPayTypePrepay,       // 预付酒店
    HotelFilterPayTypeNoGuarantee   // 免担保
}HotelFilterPayType;

// 酒店筛选促销方式
typedef enum {
    HotelFilterPromotionTypeVIP,    // 龙萃
    HotelFilterPromotionTypeCash,   // 可返现
    HotelFilterPromotionTypeLimit   // 限时抢
}HotelFilterPromotionType;


// 酒店筛选返回数据
#define HOTELFILTER_MUTIPLECONDITION @"MutipleCondition"
#define HOTELFILTER_BRANDS           @"Brands"
#define HOTELFILTER_AREANAME         @"AreaName"
#define HOTELFILTER_STARS            @"Stars"
#define HOTELFILTER_FACILITIES       @"Facilities"
#define HOTELFILTER_APARTMENT        @"Apartment"
#define HOTELFILTER_THEMES           @"Themes"
#define HOTELFILTER_NUMBER           @"Number"
