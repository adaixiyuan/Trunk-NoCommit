//
//  GrouponSearchFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SearchFilterController.h"
#import "HotelStarFilterController.h"
#import "HotelPriceFilterController.h"
#import "GrouponPriceFilterController.h"
#import "GrouponDistrictViewController.h"
#import "GrouponSubwayDetailViewController.h"
#import "GrouponAirportDetailViewController.h"
#import "GrouponBrandFilterViewController.h"
#import "GrouponTypeFilterViewController.h"

@interface GrouponSearchFilterController : SearchFilterController <HotelPriceFilterDelegate, GrouponPriceFilterDelegate, HotelStarFilterDelegate, GrouponDistrictViewControllerDelegate, GrouponSubwayDetailViewControllerDelegate, GrouponAirportDetailViewControllerDelegate, UINavigationControllerDelegate,GrouponBrandFilterDelegate,GrouponTypeFilterDelegate>
{
    BOOL isBrandDataLoadingOk;
    BOOL isTypeDataLoadingOk;
}

@property (nonatomic, assign) NSUInteger minPrice;
@property (nonatomic, assign) NSUInteger maxPrice;
@property (nonatomic, assign) NSUInteger starLevel;

@property (nonatomic, retain) NSDictionary *location;
@property (nonatomic, retain) HttpUtil *httpUtil;
@property (nonatomic, retain) HttpUtil *brandhttpUtil;
@property (nonatomic, retain) NSMutableArray *brandData;
@property (nonatomic, retain) NSDictionary *selectedBrand;

@property (nonatomic, retain) NSMutableArray *typeData;
@property (nonatomic, retain) NSDictionary *selectedType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isShowLocation:(BOOL) isShowLocation;
@end
