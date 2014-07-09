//
//  JHotelSearch.h
//  ElongClient
//
//  Created by bin xing on 11-1-10.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
#import "Utils.h"
#import "SettingManager.h"

@interface JHotelSearch : NSObject {
	NSMutableDictionary *contents;
    NSUInteger priceLevel;
}
@property (nonatomic,retain) NSArray *brandArray;
@property (nonatomic,retain) NSArray *starArray;
@property (nonatomic,assign) BOOL isChain;

-(id)getObject:(NSString *)key;

-(void)clearBuildData;

- (void)resetPosition;

-(void)setCityName:(NSString *)cityName;

- (NSString *)cityName;

-(void)setAreaName:(NSString *)areaName;

- (NSString *) getAreaName;

-(NSString *)getHotelName;

-(void)setHotelName:(NSString *)hotelName;

- (NSArray *)getStarCodeIndexs;

-(void)setStarCodes:(NSString *)starCodesStr;

- (NSArray *)getStarCodes;

- (NSString *) getStarCodesStr;

-(void)setOrderBy:(int)orderBy;

- (NSInteger) getOrderBy;

- (NSString *)getMutipleFilter;

- (void)setMutipleFilter:(NSString *)filterStr;
- (void)setXGMutipleFilter:(NSString *)filterStr;

- (NSArray *)getBrandIDs;

- (void)setBrandIDs:(NSString *)brandIDs;

-(void)setCheckData:(NSString *)checkindate checkoutdate:(NSString *)checkoutdate;

-(void)setCheckDataForNSDate:(NSDate *)checkindate checkoutdate:(NSDate *)checkoutdate;

- (NSString *)getCheckinDate;

- (NSString *)getCheckoutDate;

- (void)setFilter:(NSInteger)num;

-(void)nextPage;

- (NSInteger) getPageIndex;
    
- (NSInteger) getPageSize;

-(void)resetPage;

- (NSInteger) getRadius;

- (NSInteger) getSearchType;

-(void)setCurrentPos:(int)radius Longitude:(double)longitude Latitude:(double)latitude;

- (void)setCondition:(NSString *)condition Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude;

- (float) getLatitude;
- (float) getLongitude;
- (NSInteger)getCurrentPos;

-(NSString *)requesString:(BOOL)iscompress;

- (NSNumber *)getFilter;

- (void)setSearchGPS:(NSNumber *)animated;

- (void)setMinPrice:(NSString *)min MaxPrice:(NSString *)max;

- (NSString *)getMinPrice;

- (NSString *)getMaxPrice;

- (void) setMinPriceLevel:(NSInteger)minLevel;

- (NSInteger) getMinPriceLevel;

- (void) setMaxPriceLevel:(NSInteger)maxLevel;

- (NSInteger) getMaxPriceLevel;

- (NSMutableDictionary *)getContent;

- (void)copyFromJHotelSearch:(JHotelSearch *)jhotelSearch;

- (BOOL) getIsPos;

- (void) setBrandAndStar:(NSDictionary *)root;

-(void)setIsApartment:(BOOL)isApartment;        //公寓

-(BOOL)getIsApartment;

- (NSArray *) getFacilitiesFilter;

- (void) setFacilitiesFilter:(NSString *)filter;

- (NSArray *) getThemesFilter;

- (void) setThemesFilter:(NSString *)filter;

- (NSInteger) getNumbersOfRoom;

- (void) setNumbersOfRoom:(NSInteger)num;

- (NSInteger) getMemberLevel;
@end
