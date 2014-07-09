 //
//  JHotelSearch.m
//  ElongClient
//
//  Created by bin xing on 11-1-10.
//  Copyright 2011 DP. All rights reserved.
//

#import "JHotelSearch.h"
#import "DefineHotelReq.h"
#import "AccountManager.h"
#import "HotelConditionRequest.h"

@interface JHotelSearch()

@end

@implementation JHotelSearch

- (void)dealloc {
	[contents release];
	self.brandArray = nil;
    self.starArray = nil;
	[super dealloc];
}

- (void) setBrandAndStar:(NSDictionary *)root{
    // 传递品牌
    if (OBJECTISNULL([root objectForKey:@"HotelBrandList"])) {
        self.brandArray = nil;
    }else{
        NSArray *brandList = [root safeObjectForKey:@"HotelBrandList"];
        if (brandList && brandList.count) {
            
            NSMutableArray *brandArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dict in brandList) {
                NSMutableDictionary *brandDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"BrandId"],@"BrandID",[dict objectForKey:@"BrandName"],@"BrandName", nil];
                [brandArray addObject:brandDict];
            }
            self.brandArray = [NSArray arrayWithArray:brandArray];
        }else{
            // 读取默认
            HotelConditionRequest *searchReq = [HotelConditionRequest shared];
            if (searchReq.isAllDataLoaded) {
                // 品牌
                NSMutableArray *brandArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dict in searchReq.brandArray) {
                    NSMutableDictionary *brandDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dict objectForKey:@"DataID"],@"BrandID",[dict objectForKey:@"DataName"],@"BrandName", nil];
                    [brandArray addObject:brandDict];
                }
                self.brandArray = [NSArray arrayWithArray:brandArray];
            }else{
                self.brandArray = nil;
            }
        }
    }
    
    if (OBJECTISNULL([root objectForKey:@"StarCodeList"])) {
        self.starArray = nil;
    }else{
        // 传递星级
        if ([root safeObjectForKey:@"StarCodeList"]) {
            NSMutableArray *starArray = [NSMutableArray arrayWithArray:[root safeObjectForKey:@"StarCodeList"]];
            if (starArray && starArray.count) {
                for (int i = 0; i < starArray.count;i++) {
                    if ([[starArray objectAtIndex:i] intValue] == 12) {
                        [starArray replaceObjectAtIndex:i withObject:NUMBER(2)];
                        break;
                    }
                }
                NSArray *newStarArray = [starArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [obj2 compare:obj1];
                }];
                
                
                NSMutableArray *tStarArray = [NSMutableArray arrayWithCapacity:0];
                for (NSNumber * starNum in newStarArray) {
                    switch ([starNum intValue]) {
                        case 5:
                            [tStarArray addObject:STAR_LIMITED_FIVE];
                            break;
                        case 4:
                            [tStarArray addObject:STAR_LIMITED_FOUR];
                            break;
                        case 3:
                            [tStarArray addObject:STAR_LIMITED_THREE];
                            break;
                        case 2:
                            [tStarArray addObject:STAR_LIMITED_OTHER];
                            break;
                        default:
                            break;
                    }
                }
                [tStarArray insertObject:STAR_LIMITED_NONE atIndex:0];
                self.starArray = [NSArray arrayWithArray:tStarArray];
            }else{
                self.starArray = [NSArray arrayWithObjects:
                                  STAR_LIMITED_NONE,
                                  STAR_LIMITED_FIVE,
                                  STAR_LIMITED_FOUR,
                                  STAR_LIMITED_THREE,
                                  STAR_LIMITED_OTHER, nil];
            }
        }
    }
}

- (NSMutableDictionary *) getContent{
    return contents;
}

- (void) copyFromJHotelSearch:(JHotelSearch *)jhotelSearch{
    [contents removeAllObjects];
    [contents release];
    contents = [[NSMutableDictionary alloc] initWithDictionary:[jhotelSearch getContent] copyItems:YES];
}

-(void)buildPostData:(BOOL)clearhotelsearch{
	
	if (clearhotelsearch) {
		[contents setValue:[PostHeader header]				forKey:Resq_Header];
		[contents setValue:EmptyString						forKey:ReqHS_CityName_S];
		[contents setValue:EmptyString						forKey:ReqHS_HotelName_S];
        [contents setValue:EmptyString                      forKey:ReqHS_IntelligentSearchText];        // by dawn
		[contents setValue:@"0"                             forKey:ReqHS_HotelBrandID];
		[contents setValue:NegativeOne						forKey:ReqHS_HighestPrice_I];
		[contents setValue:NegativeOne						forKey:ReqHS_LowestPrice_I];
		[contents setValue:JSON_NULL						forKey:ReqHS_AreaName_S];
		[contents setValue:Zero							    forKey:ReqHS_Radius_D];
		[contents setValue:JSON_NULL						forKey:ReqHS_CheckInDate_ED];
		[contents setValue:JSON_NULL						forKey:ReqHS_CheckOutDate_ED];
		[contents setValue:@"-1"                            forKey:ReqHS_StarCode_I];
		[contents setValue:Zero							    forKey:ReqHS_OrderBy_I];
		[contents setValue:JSON_NO							forKey:ReqHS_IsPositioning_B];
        [contents safeSetObject:JSON_NO                     forKey:SEARCH_TYPE];
		[contents setValue:Zero                             forKey:ReqHS_Longitude_B];
		[contents setValue:Zero                             forKey:ReqHS_Latitude_B];
		[contents setValue:Zero                             forKey:ReqHS_Filter];
        [contents setValue:JSON_NO                      forKey:ReqHS_IsApartment];
        [contents setValue:Zero                             forKey:ReqHS_MemberLevel];
        [contents setValue:Zero                             forKey:ReqHS_PriceLevel];
		[contents setValue:[NSNumber numberWithInt:MAX_PAGESIZE_HOTEL] forKey:ReqHS_PageSize_I];
		[contents setValue:Zero                             forKey:ReqHS_PageIndex_I];
		[contents setValue:[NSNumber numberWithBool:YES]	forKey:ReqHS_SEARCHGPS];
        [contents removeObjectForKey:ReqHS_MutilpleFilter];
        [contents removeObjectForKey:ReqHS_FacilitiesFilter];
        [contents removeObjectForKey:ReqHS_ThemesFilter];
        [contents removeObjectForKey:ReqHS_NumbersOfRoom];
        priceLevel = 0;
        
		ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.isNonmemberFlow) {
			[contents setValue:NUMBER(0) forKey:Resq_CardNo];
		}
		else {
            BOOL islogin = [[AccountManager instanse] isLogin];
            if (islogin)
                [contents setValue:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
		}
        
        // 新的周边搜索逻辑
        [contents setValue:Zero forKey:ReqHS_SearchType];
        //港澳酒店返回人民币
        [contents setValue:@"RMB" forKey:@"Currency"];
	}
}

-(id)init{
    self = [super init];
    if (self) {
		contents=[[NSMutableDictionary alloc] init];
		[self clearBuildData];
	}
	return self;
}

-(id)getObject:(NSString *)key{
	return [contents safeObjectForKey:key];
}

-(void)clearBuildData{
	[self buildPostData:YES];
}

- (void)setSearchGPS:(NSNumber *)animated {
	[contents setValue:animated forKey:ReqHS_SEARCHGPS];
}

-(void)setCityName:(NSString *)cityName{
    if (cityName) {
        [contents setValue:cityName forKey:ReqHS_CityName_S];
    }
}

- (NSString *) cityName{
    return [contents safeObjectForKey:ReqHS_CityName_S];
}

- (void)setAreaName:(NSString *)areaName {
	if (!areaName || [areaName isEqualToString:@""]) {
		[contents setValue:JSON_NULL forKey:ReqHS_AreaName_S];
	}
	else {
		[contents setValue:areaName forKey:ReqHS_AreaName_S];
	}
}

- (NSString *) getAreaName{
    if ([contents objectForKey:ReqHS_AreaName_S]!=[NSNull null]) {
        return [contents safeObjectForKey:ReqHS_AreaName_S];
    }else{
        return nil;
    }
}

-(NSString *)getHotelName{
    return [contents safeObjectForKey:ReqHS_IntelligentSearchText];
}

-(void)setHotelName:(NSString *)hotelName{
    [contents setValue:hotelName forKey:ReqHS_IntelligentSearchText];
}

- (NSArray *)getBrandIDs
{
    NSString *brandsStr = [NSString stringWithFormat:@"%@",[contents safeObjectForKey:ReqHS_HotelBrandID]];
    NSArray *brands = [brandsStr componentsSeparatedByString:@","];
    return brands;
}

- (void)setBrandIDs:(NSString *)brandIDs {
    NSLog(@"品牌ID:%@",brandIDs);
    
	[contents setValue:brandIDs forKey:ReqHS_HotelBrandID];
}

- (NSString *)getMutipleFilter
{
    return [contents safeObjectForKey:ReqHS_MutilpleFilter];
}

- (void)setMutipleFilter:(NSString *)filterStr
{
    if (STRINGHASVALUE(filterStr))
    {
        int mFilter=[filterStr intValue];
        
        mFilter=mFilter|1024;   //10000000000  第10位:返回未签约酒店
        
        filterStr=[NSString stringWithFormat:@"%d",mFilter];
    }
    
	[contents setValue:filterStr forKey:ReqHS_MutilpleFilter];
}
- (void)setXGMutipleFilter:(NSString *)filterStr
{
//    if (STRINGHASVALUE(filterStr))
//    {
//        int mFilter=[filterStr intValue];
//        
//        mFilter=mFilter|1024;   //10000000000  第10位:返回未签约酒店
//        
//        filterStr=[NSString stringWithFormat:@"%d",mFilter];
//    }
    
	[contents setValue:filterStr forKey:ReqHS_MutilpleFilter];
}

- (NSArray *) getFacilitiesFilter{
    if ([contents safeObjectForKey:ReqHS_FacilitiesFilter]) {
        NSString *facilitiesStr = [NSString stringWithFormat:@"%@",[contents safeObjectForKey:ReqHS_FacilitiesFilter]];
        NSArray *facilities = [facilitiesStr componentsSeparatedByString:@","];
        return facilities;
    }
    return nil;
}

- (void) setFacilitiesFilter:(NSString *)filter{
    if (filter == nil) {
        [contents removeObjectForKey:ReqHS_FacilitiesFilter];
    }else{
        [contents safeSetObject:filter forKey:ReqHS_FacilitiesFilter];
    }
}

- (NSArray *) getThemesFilter{
    if ([contents safeObjectForKey:ReqHS_ThemesFilter]) {
        NSString *themesStr = [NSString stringWithFormat:@"%@",[contents safeObjectForKey:ReqHS_ThemesFilter]];
        NSArray *themes = [themesStr componentsSeparatedByString:@","];
        return themes;
    }
    return nil;
}

- (void) setThemesFilter:(NSString *)filter{
    if (filter == nil) {
        [contents removeObjectForKey:ReqHS_ThemesFilter];
    }else{
        [contents safeSetObject:filter forKey:ReqHS_ThemesFilter];
    }
}

- (NSInteger) getNumbersOfRoom{
    return [[contents objectForKey:ReqHS_NumbersOfRoom] intValue];
}

- (void) setNumbersOfRoom:(NSInteger)num{
    if (num == 0) {
        [contents removeObjectForKey:ReqHS_NumbersOfRoom];
    }else{
        [contents safeSetObject:[NSNumber numberWithInt:num] forKey:ReqHS_NumbersOfRoom];
    }
}

- (NSArray *)getStarCodeIndexs{
    NSDictionary *stardict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:0], [NSNumber numberWithInt:-1],
                              [NSNumber numberWithInt:1], [NSNumber numberWithInt:5],
                              [NSNumber numberWithInt:2], [NSNumber numberWithInt:4],
                              [NSNumber numberWithInt:3], [NSNumber numberWithInt:3],
                              [NSNumber numberWithInt:4], [NSNumber numberWithInt:12],
                              nil];
    
    NSArray *starCodeIDs = [[contents safeObjectForKey:ReqHS_StarCode_I] componentsSeparatedByString:@","];
    NSMutableArray *starCodeIndexs = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < starCodeIDs.count; i++) {
        NSInteger starCode = [[starCodeIDs objectAtIndex:i] intValue];
        if (starCode == 0) {
            starCode = -1;
        }
        if (starCode == -1 || starCode == 5 || starCode == 4 ||starCode == 3 || starCode == 12) {
            [starCodeIndexs addObject:[stardict safeObjectForKey:[NSNumber numberWithInt:starCode]]];
        }
        
    }
    
    return starCodeIndexs;
}

- (NSArray *)getStarCodes{
    NSDictionary *stardict = [NSDictionary dictionaryWithObjectsAndKeys:
                              STAR_LIMITED_NONE, [NSNumber numberWithInt:-1],
                              STAR_LIMITED_FIVE, [NSNumber numberWithInt:5],
                              STAR_LIMITED_FOUR, [NSNumber numberWithInt:4],
                              STAR_LIMITED_THREE, [NSNumber numberWithInt:3],
                              STAR_LIMITED_OTHER, [NSNumber numberWithInt:12],
                              nil];
    
    NSArray *starCodeIDs = [[contents safeObjectForKey:ReqHS_StarCode_I] componentsSeparatedByString:@","];
    NSMutableArray *starCodeIndexs = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < starCodeIDs.count; i++) {
        NSInteger starCode = [[starCodeIDs objectAtIndex:i] intValue];
        if (starCode == 0) {
            starCode = -1;
        }
        if (starCode == -1 || starCode == 5 || starCode == 4 ||starCode == 3 || starCode == 12) {
            [starCodeIndexs addObject:[stardict safeObjectForKey:[NSNumber numberWithInt:starCode]]];
        }
        
    }
    
    return starCodeIndexs;
}

- (NSString *) getStarCodesStr{
    NSString *starCodesStr = [contents safeObjectForKey:ReqHS_StarCode_I];
    NSArray *starIndexs = [starCodesStr componentsSeparatedByString:@","];
    BOOL haveStar = NO;
    if (starIndexs && starIndexs.count) {
        if ([[starIndexs objectAtIndex:0] intValue] != -1 && [[starIndexs objectAtIndex:0] intValue] != 0) {
            haveStar = YES;
        }
    }else{
        haveStar = YES;
    }
    if (haveStar) {
        return starCodesStr;
    }else{
        return @"-1";
    }
}

- (void)setStarCodes:(NSString *)starCodesStr{
    NSLog(@"星级ID:%@",starCodesStr);
    
	NSDictionary *stardict=[[NSDictionary alloc] initWithObjectsAndKeys:
							[NSNumber numberWithInt:-1], STAR_LIMITED_NONE,
							[NSNumber numberWithInt:5], STAR_LIMITED_FIVE,
							[NSNumber numberWithInt:4], STAR_LIMITED_FOUR,
							[NSNumber numberWithInt:3], STAR_LIMITED_THREE,
							[NSNumber numberWithInt:12], STAR_LIMITED_OTHER,
							nil];
    NSArray *starCodes = [starCodesStr componentsSeparatedByString:@","];
    
    
    NSMutableArray *starCodeIDs = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < starCodes.count; i++) {
        [starCodeIDs addObject:[stardict safeObjectForKey:[starCodes objectAtIndex:i]]];
    }
    
	[contents setValue:[starCodeIDs componentsJoinedByString:@","] forKey:ReqHS_StarCode_I];
	
	[stardict release];
	
}

-(void)setOrderBy:(int)orderBy{
	
	[contents setValue:[NSNumber numberWithInt:0] forKey:ReqHS_PageIndex_I];
	[contents setValue:[NSNumber numberWithInt:orderBy] forKey:ReqHS_OrderBy_I];
}


- (NSInteger) getOrderBy{
    return [[contents safeObjectForKey:ReqHS_OrderBy_I] intValue];
}

- (void)setFilter:(NSInteger)num {
	[contents setValue:NUMBER(num) forKey:ReqHS_Filter];
    
}

- (NSNumber *)getFilter {
	return [contents safeObjectForKey:ReqHS_Filter];
}

//公寓
-(void)setIsApartment:(BOOL)isApartment{
    [contents setValue:[NSNumber numberWithBool:isApartment] forKey:ReqHS_IsApartment];
}

-(BOOL)getIsApartment{
    return [[contents safeObjectForKey:ReqHS_IsApartment] boolValue];
}

- (void) setMinPriceLevel:(NSInteger)minLevel{
    NSInteger minPirce = -1;
    minPirce = [PublicMethods getMinPriceByLevel:minLevel];
    [contents setValue:[NSString stringWithFormat:@"%d",minPirce] forKey:ReqHS_LowestPrice_I];
}

- (NSInteger) getMinPriceLevel{
    NSInteger minPrice = [[self getMinPrice] intValue];
    return [PublicMethods getMinPriceLevel:minPrice];
}

- (void) setMaxPriceLevel:(NSInteger)maxLevel{
    NSInteger maxPrice = -1;
    maxPrice = [PublicMethods getMaxPriceByLevel:maxLevel];
    [contents setValue:[NSString stringWithFormat:@"%d",maxPrice] forKey:ReqHS_HighestPrice_I];
}

- (NSInteger) getMaxPriceLevel{
    NSInteger maxPrice = [[self getMaxPrice] intValue];
    return [PublicMethods getMaxPriceLevel:maxPrice];
}


- (void)setMinPrice:(NSString *)min MaxPrice:(NSString *)max {
    [contents setValue:min forKey:ReqHS_LowestPrice_I];
    [contents setValue:max forKey:ReqHS_HighestPrice_I];
}


- (NSString *)getMinPrice {
    return [NSString stringWithFormat:@"%@", [contents safeObjectForKey:ReqHS_LowestPrice_I]];
}


- (NSString *)getMaxPrice {
    return [NSString stringWithFormat:@"%@", [contents safeObjectForKey:ReqHS_HighestPrice_I]];
}

-(void)setCheckDataForNSDate:(NSDate *)checkindate checkoutdate:(NSDate *)checkoutdate
{
    NSDateFormatter * oFormat = [[[NSDateFormatter alloc] init] autorelease];
	[oFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *ci =[oFormat stringFromDate:checkindate];
    NSString *co =[oFormat stringFromDate:checkoutdate];
    [self setCheckData:ci checkoutdate:co];
}
-(void)setCheckData:(NSString *)checkindate checkoutdate:(NSString *)checkoutdate{	
	NSString *checkindatestring = [TimeUtils makeJsonDateWithDisplayNSStringFormatter:checkindate formatter:@"yyyy-MM-dd"];
	[contents setValue:checkindatestring forKey:ReqHS_CheckInDate_ED];
	NSString *checkoutdatestring = [TimeUtils makeJsonDateWithDisplayNSStringFormatter:checkoutdate formatter:@"yyyy-MM-dd"];

	[contents setValue:checkoutdatestring forKey:ReqHS_CheckOutDate_ED];
}

- (NSString *) getCheckinDate{
    NSString *checkinDate = [contents safeObjectForKey:ReqHS_CheckInDate_ED];
    return [TimeUtils displayDateWithJsonDate:checkinDate formatter:@"yyyy-MM-dd"];
    
}

- (NSString *) getCheckoutDate{
    NSString *checkoutDate = [contents safeObjectForKey:ReqHS_CheckOutDate_ED];
    return [TimeUtils displayDateWithJsonDate:checkoutDate formatter:@"yyyy-MM-dd"];
}

-(void)nextPage{
	int pageIndex = [[contents safeObjectForKey:ReqHS_PageIndex_I] intValue];
	pageIndex=pageIndex+1;
	[contents setValue:[NSNumber numberWithInt:pageIndex] forKey:ReqHS_PageIndex_I];
}

- (NSInteger) getPageIndex{
    return [[contents objectForKey:ReqHS_PageIndex_I] intValue];
}

- (NSInteger) getPageSize{
    return [[contents objectForKey:ReqHS_PageSize_I] intValue];
}


- (void)resetPage {
	[contents setValue:Zero forKey:ReqHS_PageIndex_I];
}

- (void)resetPosition {
	[contents setValue:JSON_NO forKey:ReqHS_IsPositioning_B];
    [contents safeSetObject:JSON_NO forKey:SEARCH_TYPE];
    // 新的周边搜索逻辑
    [contents setValue:Zero forKey:ReqHS_SearchType];
}

- (BOOL) getIsPos{
    return [[contents safeObjectForKey:ReqHS_IsPositioning_B] boolValue];
}

- (NSInteger) getSearchType{
    return [[contents objectForKey:ReqHS_SearchType] intValue];
}
-(void)setCurrentPos:(int)radius Longitude:(double)longitude Latitude:(double)latitude{
	[contents setValue:[NSNumber numberWithInt:radius] forKey:ReqHS_Radius_D];
	[contents setValue:[NSNumber numberWithDouble:longitude] forKey:ReqHS_Longitude_B];
	[contents setValue:[NSNumber numberWithDouble:latitude] forKey:ReqHS_Latitude_B];
	[contents setValue:JSON_YES forKey:ReqHS_IsPositioning_B];
    [contents safeSetObject:JSON_YES forKey:SEARCH_TYPE];
	[contents setValue:JSON_NULL forKey:ReqHS_AreaName_S];
    // 新的周边搜索逻辑
    [contents setValue:NUMBER(1) forKey:ReqHS_SearchType];
}

- (NSInteger) getRadius{
    return [[contents objectForKey:ReqHS_Radius_D] intValue];
}


- (void)setCondition:(NSString *)condition Longitude:(NSNumber *)longitude Latitude:(NSNumber *)latitude {
	[contents setValue:condition forKey:ReqHS_AreaName_S];
	[contents setValue:longitude forKey:ReqHS_Longitude_B];
	[contents setValue:latitude forKey:ReqHS_Latitude_B];
}

- (float) getLatitude{
    return [[contents objectForKey:ReqHS_Latitude_B] floatValue];
}

- (float) getLongitude{
    return [[contents objectForKey:ReqHS_Longitude_B] floatValue];
}


- (NSInteger)getCurrentPos {
	return [[contents safeObjectForKey:ReqHS_Radius_D] intValue];
}

- (NSInteger) getMemberLevel{
    return [[contents objectForKey:ReqHS_MemberLevel] intValue];
}

-(NSString *)requesString:(BOOL)iscompress{
    int userLevel = [[[AccountManager instanse] DragonVIP] intValue];
    if (userLevel == 2) {
        // 龙萃会员设置级别
        [contents setValue:NUMBER(2) forKey:ReqHS_MemberLevel];
    }
    else {
        [contents setValue:Zero forKey:ReqHS_MemberLevel];
    }
    
    if ([contents objectForKey:ReqHS_IntelligentSearchText]) {
        NSString *intelligent = [contents objectForKey:@"IntelligentSearchText"];
        if (![intelligent isEqualToString:@""]) {
            //7是否返回满房酒店128
            NSUInteger flags = [[self getMutipleFilter] integerValue];
            if ((flags & 128) == 0) {
                flags += 128;
            }
            [self setMutipleFilter:[NSString stringWithFormat:@"%d", flags]];
        }
    }
    
    if ([[self getFilter] intValue] == 1) {
        NSUInteger flags = [[self getMutipleFilter] integerValue];
        flags = flags & ~128;
        [self setMutipleFilter:[NSString stringWithFormat:@"%d", flags]];
    }
    
    // 加入万豪供应商库存 by dawn
    NSUInteger flags = [[self getMutipleFilter] integerValue];
    if ((flags & 256) == 0) {
        flags += 256;
    }
    [self setMutipleFilter:[NSString stringWithFormat:@"%d", flags]];
    
	NSString *iscomp=[[NSString alloc] initWithFormat:@"%@",iscompress?@"true":@"false"];
    NSLog(@"tonightReq:%@", contents);
	NSString *request=[[[NSString alloc] initWithFormat:@"action=GetHotelList&compress=%@&req=%@",iscomp,[contents JSONRepresentationWithURLEncoding]] autorelease];
	[iscomp release];
	return request;
}

@end
