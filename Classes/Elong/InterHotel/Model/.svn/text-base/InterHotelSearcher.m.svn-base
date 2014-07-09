//
//  InterHotelSearcher.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelSearcher.h"
#import "PostHeader.h"

#define kInterHotelSearchCityIdKey              @"DestinationId"
#define kInterHotelSearchCheckInDateKey         @"ArrivalDate"
#define kInterHotelSearchCheckOutDateKey        @"DepartureDate"
#define kInterHotelSearchMinStarLevelKey        @"MinStarRating"
#define kInterHotelSearchMaxStarLevelKey        @"MaxStarRating"
#define kInterHotelSearchRadiusKey              @"SearchRadius"
#define kInterHotelSearchLatitudeKey            @"Latitude"
#define kInterHotelSearchLongitudeKey           @"Longitude"
#define kInterHotelSearchRoomTypeListKey        @"RoomGroup"
#define kInterHotelSearchPageIndexKey           @"PageIndex"
#define kInterHotelSearchCountHotelPerPageKey   @"PageSize"
#define kInterHotelSearchMinPriceKey            @"MinRate"
#define kInterHotelSearchMaxPriceKey            @"MaxRate"
#define kInterHotelSearchAmenitiesKey           @"Amenities"
#define kInterHotelSearchKeywordKey             @"PropertyName"
#define kInterHotelSearchSortTypeKey            @"Sort"
#define kInterHotelSearchHotelIdListKey         @"HotelIdList"

#define START_PAGE_INDEX        1   // 初始时是页面index1

static InterHotelSearcher *request = nil;

@interface InterHotelSearcher ()

@end

@implementation InterHotelSearcher

+ (id)shared
{
    @synchronized(request) {
		if (!request) {
			request = [[InterHotelSearcher alloc] init];
		}
	}
	
	return request;
}

- (void)dealloc
{
    [_cityNameEn release];
    [_cityId release];
    [_countryId release];
    [_state release];
    [_checkInDate release];
    [_checkOutDate release];
    [_roomTypeList release];
    [_amenities release];
    [_keywords release];
    [_hotelIdList release];
    [_hotelList release];
    [_location release];
    [_cityDescription release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        self.cityId = @"68678448-0bc9-4df9-beed-c7ac46d82cee";
        self.minPrice = 0;
        self.maxPrice = NSUIntegerMax;
        self.minStarLevel = 0;
        self.maxStarLevel = 0;
        self.currentPage = START_PAGE_INDEX;
        self.hotelCountPerPage = HOTEL_PAGESIZE;
        _isInterHotelProgress = NO;
        
        NSMutableDictionary *roomType = [NSMutableDictionary dictionary];
        [roomType setValue:[NSNumber numberWithInt:2] forKey:@"NumberOfAdults"];
        [roomType setValue:[NSNumber numberWithInt:0] forKey:@"NumberOfChildren"];
        [roomType setValue:[NSNull null] forKey:@"ChildAges"];
        
        NSArray *roomTypeList = [NSArray arrayWithObject:roomType];
        self.roomTypeList = roomTypeList;
    }
    
    return self;
}

- (void)removeCoordinate
{
    _latitude = 0.0f;
    _longitude = 0.0f;
    _radius = 0.0f;
    self.coordinate = FALSE;
}

- (void)setCoordinateWithLatitude:(float)latitude withLongitude:(float)longitude withRadius:(float)radius withName:(NSString *)name
{
    _latitude = latitude;
    _longitude = longitude;
    _radius = radius;
    
    [name retain];
    [_name release];
    _name = name;
    
    self.coordinate = TRUE;
}

- (void)reset
{
    self.minPrice = 0;
    self.maxPrice = NSUIntegerMax;
    self.minStarLevel = 0;
    self.maxStarLevel = 0;
    _radius = 0;
    _latitude = 0.0f;
    _longitude = 0.0f;
    [_name release];
    _name = nil;
    self.currentPage = START_PAGE_INDEX;
    self.hotelCountPerPage = HOTEL_PAGESIZE;
    self.keywords = nil;
    self.amenities = nil;
    self.hotelIdList = nil;
    self.sortType = SortTypeOfInterHotelPopular;
    self.location = nil;
    
    NSMutableDictionary *roomType = [NSMutableDictionary dictionary];
    [roomType setValue:[NSNumber numberWithInt:2] forKey:@"NumberOfAdults"];
    [roomType setValue:[NSNumber numberWithInt:0] forKey:@"NumberOfChildren"];
    [roomType setValue:[NSNull null] forKey:@"ChildAges"];
    
    NSArray *roomTypeList = [NSArray arrayWithObject:roomType];
    self.roomTypeList = roomTypeList;
    
    [self removeCoordinate];
}

- (void)nextPage
{
    ++_currentPage;
}

- (void)prePage
{
    if (_currentPage > 1) {
        --_currentPage;
    }
}

- (NSString *)request
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content safeSetObject:[PostHeader header] forKey:@"Header"];
	[content safeSetObject:_cityId forKey:kInterHotelSearchCityIdKey];
	[content safeSetObject:_checkInDate forKey:kInterHotelSearchCheckInDateKey];
    [content safeSetObject:_checkOutDate forKey:kInterHotelSearchCheckOutDateKey];
	[content safeSetObject:[NSNumber numberWithFloat:_minStarLevel] forKey:kInterHotelSearchMinStarLevelKey];
    [content safeSetObject:[NSNumber numberWithFloat:_maxStarLevel] forKey:kInterHotelSearchMaxStarLevelKey];
    if (self.coordinate) {
        [content safeSetObject:_name forKey:@"LandMarkCnName"];
        [content safeSetObject:[NSNumber numberWithDouble:_radius] forKey:kInterHotelSearchRadiusKey];
        [content safeSetObject:[NSNumber numberWithDouble:_latitude] forKey:kInterHotelSearchLatitudeKey];
        [content safeSetObject:[NSNumber numberWithDouble:_longitude] forKey:kInterHotelSearchLongitudeKey];
    }
    [content safeSetObject:_roomTypeList forKey:kInterHotelSearchRoomTypeListKey];
	[content safeSetObject:[NSNumber numberWithInt:_currentPage] forKey:kInterHotelSearchPageIndexKey];
    [content safeSetObject:[NSNumber numberWithInt:_hotelCountPerPage] forKey:kInterHotelSearchCountHotelPerPageKey];
	[content safeSetObject:[NSNumber numberWithInt:_minPrice / 0.9] forKey:kInterHotelSearchMinPriceKey];
    [content safeSetObject:[NSNumber numberWithInt:_maxPrice / 0.9] forKey:kInterHotelSearchMaxPriceKey];
    [content safeSetObject:_amenities forKey:kInterHotelSearchAmenitiesKey];
	[content safeSetObject:_keywords forKey:kInterHotelSearchKeywordKey];
    [content safeSetObject:[NSNumber numberWithInt:_sortType] forKey:kInterHotelSearchSortTypeKey];
	[content safeSetObject:_hotelIdList forKey:kInterHotelSearchHotelIdListKey];
    NSLog(@"req==%@", content);
	
	return [NSString stringWithFormat:@"action=GetGlobalHotelList&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}

@end
