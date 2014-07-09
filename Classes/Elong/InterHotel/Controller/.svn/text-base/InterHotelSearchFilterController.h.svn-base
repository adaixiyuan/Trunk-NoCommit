//
//  InterHotelSearchFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SearchFilterController.h"
#import "InterHotelPriceStarFilterController.h"
#import "InterHotelLocationFilterController.h"
#import "InterHotelLocationDataFilterDelegate.h"

typedef enum
{
    InterHotelSearchFilterPrice = 1024,
    InterHotelSearchFilterStar,
    InterHotelSearchFilterLocation,
    InterHotelSearchFilterOther
}InterHotelSearchFilterType;

@interface InterHotelSearchFilterController : SearchFilterController <InterHotelPriceStarFilterDelegate, InterHotelLocationFilterDelegate, InterHotelLocationDataFilterDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) NSUInteger minPrice; // 最低价格
@property (nonatomic, assign) NSUInteger maxPrice; // 最高价格

@property (nonatomic, assign) NSUInteger starLevel;// 星级

@property (nonatomic, retain) NSDictionary *locationInfo; // 地标信息

@property (nonatomic, retain) NSString *keyword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil minPrice:(NSUInteger) minPrice_ maxPrice:(NSUInteger) maxPrice_ starLevel:(NSUInteger) starLevel_ locationInfo:(NSDictionary *)locationInfo_ keyword:(NSString *)keyword_;

@end
