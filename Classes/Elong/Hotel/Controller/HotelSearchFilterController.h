//
//  HotelSearchFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import <CoreLocation/CoreLocation.h>
#import "HotelPriceFilterController.h"
#import "HotelStarFilterController.h"
#import "HotelBrandFilterController.h"
#import "HotelSearchConditionViewCtrontroller.h"
#import "HotelOtherFilterController.h"
#import "JHotelKeywordFilter.h"
#import "FilterViewController.h"
#import "HotelFacilityFilterController.h"
#import "HotelThemeFilterController.h"
#import "HotelRoomerFilterController.h"
#import "HotelPayTypeFilterController.h"
#import "HotelPromotionTypeFilterController.h"

@interface HotelSearchFilterController : FilterViewController <HotelSearchConditionDelegate, HotelStarFilterDelegate, HotelBrandFilterDelegate, HotelPayTypeFilterDelegate,HotelPromotionTypeFilterDelegate, UINavigationControllerDelegate,HotelFacilityFilterDelegate,HotelThemeFilterDelegate,HotelRoomerFilterDelegate,HotelSearchConditionDelegate> {
@private
    HttpUtil *locationUtil;
    HttpUtil *themeUtil;
}

@property (nonatomic, assign) BOOL isLM;                            // 是否为特价酒店筛选条件
@property (nonatomic, retain) NSString *location;                   // 所在区域
@property (nonatomic, retain) CLLocation *locationCoor;             // 所在区域的经纬度
@property (nonatomic, retain) NSMutableArray *brandIndexs;          // 品牌
@property (nonatomic, retain) NSMutableArray *facilityIndexs;       // 设施
@property (nonatomic, retain) NSMutableArray *themeIndexs;          // 主题
@property (nonatomic, retain) NSMutableArray *payTypeIndexs;        // 支付方式
@property (nonatomic, retain) NSMutableArray *promotionTypeIndexs;  // 促销方式
@property (nonatomic, assign) NSInteger numberOfRoom;               // 入住人数
@property (nonatomic, retain) JHotelKeywordFilter *locationInfo;    // 地理位置信息

+ (BOOL) filterLightWithLM:(BOOL)isLM;
- (id) initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style isLM:(BOOL)lm;
@end
