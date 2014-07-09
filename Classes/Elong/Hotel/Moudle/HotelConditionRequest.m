    //
//  HotelConditionRequest.m
//  ElongClient
//
//  Created by haibo on 11-12-30.
//  Copyright 2011 elong. All rights reserved.
//

#import "HotelConditionRequest.h"
#import "AccountManager.h"
#import "DefineHotelResp.h"


static HotelConditionRequest *request = nil;

@implementation HotelConditionRequest

@synthesize trafficSubArray;
@synthesize metroSubArray;
@synthesize commercialArray;
@synthesize districtArray;
@synthesize brandArray;
@synthesize chainArray;
@synthesize metroArray;
@synthesize trafficArray;
@synthesize facilityArray;

- (void)dealloc {
	[contents release]; 
	[request  release];
    [hotelKeywordFilter release];
    [tonightHotelKeywordFilter release];
	
    self.trafficSubArray    = nil;
    self.metroSubArray      = nil;
    self.commercialArray    = nil;
    self.brandArray         = nil;
    self.chainArray         = nil;
    self.districtArray      = nil;
    self.metroArray         = nil;
    self.trafficArray       = nil;
    self.facilityArray      = nil;
    self.themeArray         = nil;
    self.payTypeArray       = nil;
    self.promotionTypeArray = nil;
	
    [super dealloc];
}


+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[HotelConditionRequest alloc] init];
		}
	}
	
	return request;
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					[PostHeader header], Resq_Header, nil];
		
		self.commercialArray	= [NSMutableArray arrayWithCapacity:2];
		self.districtArray		= [NSMutableArray arrayWithCapacity:2];
		self.brandArray			= [NSMutableArray arrayWithCapacity:2];
        self.chainArray         = [NSMutableArray arrayWithCapacity:2];
		self.metroArray			= [NSMutableArray arrayWithCapacity:2];
		self.trafficArray		= [NSMutableArray arrayWithCapacity:2];
        self.facilityArray      = [NSMutableArray arrayWithCapacity:2];
        self.themeArray         = [NSMutableArray arrayWithCapacity:2];
        self.payTypeArray       = [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"预付酒店",@"Name",NUMBER(HotelFilterPayTypePrepay),@"Type", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"免担保酒店",@"Name",NUMBER(HotelFilterPayTypeNoGuarantee),@"Type", nil], nil];
        
        self.promotionTypeArray = [NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"可返现酒店",@"Name",NUMBER(HotelFilterPromotionTypeCash),@"Type", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"限时抢",@"Name",NUMBER(HotelFilterPromotionTypeLimit),@"Type", nil],
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:@"龙萃专享酒店",@"Name",NUMBER(HotelFilterPromotionTypeVIP),@"Type", nil], nil];
        
        _isAllDataLoaded = NO;
	}
	
	return self;
}

- (void)clearDataOnly {
    _isAllDataLoaded = NO;
	self.trafficSubArray	= nil;
	self.metroSubArray		= nil;

	
	[commercialArray	removeAllObjects];
	[brandArray			removeAllObjects];
    [chainArray         removeAllObjects];
	[districtArray		removeAllObjects];
	[metroArray			removeAllObjects];
	[trafficArray		removeAllObjects];
    [facilityArray      removeAllObjects];
}

- (void)clearData {
    _isAllDataLoaded = NO;
	self.trafficSubArray	= nil;
	self.metroSubArray		= nil;
    [hotelKeywordFilter release],hotelKeywordFilter = nil;
    [tonightHotelKeywordFilter release],tonightHotelKeywordFilter = nil;
	
	[commercialArray	removeAllObjects];
	[brandArray			removeAllObjects];
    [chainArray         removeAllObjects];
	[districtArray		removeAllObjects];
	[metroArray			removeAllObjects];
	[trafficArray		removeAllObjects];
    [facilityArray      removeAllObjects];
}

- (void)setSearchCity:(NSString *)city {
    if ([self getSearchCity] == nil || ![[self getSearchCity] isEqualToString:city]) {
        _isAllDataLoaded = NO;
    }
	[contents safeSetObject:city forKey:CITYNAME_GROUPON];
}


- (NSString *)getSearchCity {
	return [contents safeObjectForKey:CITYNAME_GROUPON];
}


- (void)setAllCondition:(NSDictionary *)allDictionary {
	for (NSDictionary *dic in [allDictionary safeObjectForKey:LOCATIONLIST_HOTEL]) {
		if ([[dic safeObjectForKey:TYPEID_HOTEL] isEqualToString:COMMERCIAL_HOTEL]) {
			[commercialArray addObject:dic];
		}
		else if ([[dic safeObjectForKey:TYPEID_HOTEL] isEqualToString:DISTRICT_HOTEL]) {
			[districtArray addObject:dic];
		}
		else if ([[dic safeObjectForKey:TYPEID_HOTEL] isEqualToString:HOTELBRAND_HOTEL]) {
			[brandArray addObject:dic];
		}else if([[dic safeObjectForKey:TYPEID_HOTEL] isEqualToString:CHAINHOTEL_HOTEL]){
            [chainArray addObject:dic];
        }
		else if ([[dic safeObjectForKey:TYPEID_HOTEL] isEqualToString:AIRPORT_RAILWAY]) {
			[trafficArray addObject:dic];
		}
		else if ([[dic safeObjectForKey:TYPEID_HOTEL] isEqualToString:SUBWAY_STATION]) {
			[metroArray addObject:dic];
		}
	}
	
	self.trafficSubArray	= [allDictionary safeObjectForKey:AIRPORT_RAILWAY_TAG_INFOS];
	self.metroSubArray		= [allDictionary safeObjectForKey:SUBWAYSTATION_TAG_INFOS];
    self.facilityArray      = [allDictionary safeObjectForKey:HOTELFACILITYS];
    
    _isAllDataLoaded = YES;
}

- (void) setThemes:(NSDictionary *)themes{
    self.themeArray = [NSMutableArray arrayWithArray:[themes objectForKey:THEMELIST_HOTEL]];
    _isThemeDataLoaded = YES;
}

- (JHotelKeywordFilter *) keywordFilter{
    if (self.isFromLastMinute) {
        if (!tonightHotelKeywordFilter) {
            tonightHotelKeywordFilter = [[JHotelKeywordFilter alloc] init];
        }
        return tonightHotelKeywordFilter;
    }else{
        if (!hotelKeywordFilter) {
            hotelKeywordFilter = [[JHotelKeywordFilter alloc] init];
        }
        return hotelKeywordFilter;
    }
}

- (void) clearKeywordFilter{
    if (self.isFromLastMinute) {
        [tonightHotelKeywordFilter release],tonightHotelKeywordFilter = nil;
    }else{
        [hotelKeywordFilter release],hotelKeywordFilter = nil;
    }
}

- (NSString *)requestForAllCondition {
    _isAllDataLoaded = NO;
	[contents safeSetObject:JSON_NULL forKey:TYPEID_HOTEL];
	[contents safeSetObject:JSON_NULL forKey:TAGID_HOTEL];
	[contents safeSetObject:[NSNumber numberWithBool:YES] forKey:@"IsContainSevenDayBrand"];
    NSLog(@"%@",contents);
	
	return [NSString stringWithFormat:@"action=GetLocationListV2&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}

- (NSString *) requestForThemes{
    _isThemeDataLoaded = NO;
    return [NSString stringWithFormat:@"action=GetHotelThemeList&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}

@end
