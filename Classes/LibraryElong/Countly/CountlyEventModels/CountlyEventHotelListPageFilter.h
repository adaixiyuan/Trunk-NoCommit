//
//  CountlyEventHotelListPageFilter.h
//  ElongClient
//
//  Created by Dawn on 14-4-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CountlyEventInfo.h"

@interface CountlyEventHotelListPageFilter : CountlyEventInfo
@property (nonatomic,copy) NSString *keyword;
@property (nonatomic,copy) NSString *checkInDate;
@property (nonatomic,copy) NSString *checkOutDate;
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSNumber *highestPrice;
@property (nonatomic,copy) NSNumber *lowestPrice;
@property (nonatomic,copy) NSString *hotelBrandid;
@property (nonatomic,copy) NSNumber *isApartment;
@property (nonatomic,copy) NSNumber *isPositioning;
@property (nonatomic,copy) NSNumber *latitude;
@property (nonatomic,copy) NSNumber *longitude;
@property (nonatomic,copy) NSNumber *memberLevel;
@property (nonatomic,copy) NSNumber *mutilpleFilter;
@property (nonatomic,copy) NSNumber *orderBy;
@property (nonatomic,copy) NSNumber *pageIndex;
@property (nonatomic,copy) NSNumber *pageSize;
@property (nonatomic,copy) NSNumber *radius;
@property (nonatomic,copy) NSNumber *searchType;
@property (nonatomic,copy) NSString *starCode;
@property (nonatomic,copy) NSString *facilitiesFilter;
@property (nonatomic,copy) NSString *themesFilter;
@property (nonatomic,copy) NSNumber *filter;
@property (nonatomic,copy) NSString *areaName;
@end
