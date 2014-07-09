//
//  InterHotelSearcher.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SortTypeOfInterHotelPriceLowToHigh = 3,  // 价格低到高
    SortTypeOfInterHotelStarHighToLow = 4,   // 星级高到低
    SortTypeOfInterHotelDiscount = 9,        // 特惠
    SortTypeOfInterHotelPopular = 0          // 最受欢迎
}SortTypeOfInterHotel;      // 国际酒店排序类型

@interface InterHotelSearcher : NSObject

+ (id)shared;

@property (nonatomic, retain) NSString *cityNameEn;
@property (nonatomic, retain) NSString *cityId;
@property (nonatomic, retain) NSString *countryId;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *checkInDate;
@property (nonatomic, retain) NSString *checkOutDate;
@property (nonatomic, assign) CGFloat minStarLevel;
@property (nonatomic, assign) CGFloat maxStarLevel;
@property (nonatomic, retain, readonly) NSString *name;
@property (nonatomic, assign, readonly) float latitude;
@property (nonatomic, assign, readonly) float longitude;
@property (nonatomic, assign, readonly) float radius;
@property (nonatomic, assign) BOOL isInterHotelProgress;     // 是否处于国际酒店,default = NO
@property (nonatomic, assign) BOOL coordinate;
@property (nonatomic, retain) NSArray *roomTypeList;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger hotelCountPerPage;
@property (nonatomic, assign) NSUInteger minPrice;
@property (nonatomic, assign) NSUInteger maxPrice;
@property (nonatomic, retain) NSString *amenities;
@property (nonatomic, retain) NSString *keywords;
@property (nonatomic, copy) NSString *cityDescription;                  // 城市中文描述（用于历史纪录）
@property (nonatomic, assign) SortTypeOfInterHotel sortType;
@property (nonatomic, retain) NSArray *hotelIdList;

@property (nonatomic, assign) NSUInteger hotelCount;
@property (nonatomic, retain) NSMutableArray *hotelList;

@property (nonatomic, retain) NSDictionary *location;

- (void)removeCoordinate;

- (void)setCoordinateWithLatitude:(float)latitude withLongitude:(float)longitude withRadius:(float)radius withName:(NSString *)name;

- (void)nextPage;
- (void)prePage;

- (void)reset;

- (NSString *)request;

@end
