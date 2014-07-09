//
//  GListRequest.m
//  ElongClient
//
//  Created by haibo on 11-10-20.
//  Copyright 2011 elong. All rights reserved.
//

#import "GListRequest.h"
#import "AccountManager.h"
#import "PostHeader.h"


static GListRequest *request = nil;
static int pageNum = 0;
static int MAX_TIME_INTERVER = 3600;

NSString *const orderStrings[6] = {
    @"默认排序",
    @"距离最近",
	@"价格从低到高",
	@"价格从高到低",
	@"销量从低到高",
	@"销量从高到低",
};

@implementation GListRequest

@synthesize cityName;
@synthesize grouponCitys;
@synthesize grouponNum;
@synthesize ImageSizeType;
@synthesize aioCondition;
@synthesize keyword;
@synthesize hitType;

- (void)dealloc
{
	self.grouponCitys = nil;
	self.cityName	  = nil;
    self.aioCondition = nil;
    self.hitType      = nil;
	
	[contents release];
	[request  release];
	[reqDate  release];
    [_location release];
    [_brand release];
    [_typpee release];
	
	[super dealloc];
}

- (id)init
{
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithCapacity:2];
        [contents safeSetObject:[PostHeader header] forKey:Resq_Header];
        [self clearData];
		
		NSMutableArray *array	= [[NSMutableArray alloc] initWithCapacity:2];
		self.grouponCitys		= array;
		[array release];
	}
	
	return self;
}

- (void)clearData
{
    [contents safeSetObject:NUMBER(1) forKey:PAGE_INDEX];
    [contents safeSetObject:NUMBER(MAX_PAGESIZE_GROUPON) forKey:PAGE_SIZE_];
    [contents safeSetObject:[NSNull null] forKey:CITYNAME_GROUPON];
    [contents safeSetObject:[NSNumber numberWithUnsignedInt:0] forKey:MINPRICE_REQ];
    [contents safeSetObject:[NSNumber numberWithUnsignedInt:NSUIntegerMax] forKey:MAXPRICE_REQ];
    [contents safeSetObject:NUMBER(-1) forKey:STARCODE_REQ];
    [contents safeSetObject:[NSNull null] forKey:DISTINCTID_REQ];
    [contents safeSetObject:[NSNull null] forKey:BIZSECTIONID_REQ];
    [contents safeSetObject:NUMBER(0) forKey:SORTTYPE_REQ];
    [contents safeSetObject:[NSNumber numberWithBool:NO] forKey:ISNEEDADDINFO_REQ];
    [contents safeSetObject:NUMBER(0) forKey:IMAGE_SIZE_TYPE];
    [contents removeObjectForKey:@"LocationName"];
    [contents removeObjectForKey:@"Latitude"];
    [contents removeObjectForKey:@"Longitude"];
    [contents removeObjectForKey:@"BrandId"];
    [contents removeObjectForKey:@"ExtendedCategoryIds"];
    self.location = nil;
    self.brand=nil;
    self.typpee=nil;
}

- (void)setGrouponCitys:(NSMutableArray *)citys
{
	if (citys != grouponCitys) {
		[grouponCitys release];
		grouponCitys = [citys retain];
		
		[reqDate release];
		reqDate = [[NSDate date] retain];
	}
}

#pragma mark -
#pragma mark PublicMethods
+ (id)shared
{
	@synchronized(self) {
		if (!request) {
			request = [[GListRequest alloc] init];
		}
	}
	
	return request;
}

- (NSString *)grouponCityRequestCompress:(BOOL)animated
{
	[self clearData];
	
	return [NSString stringWithFormat:@"action=SearchCityList&compress=%@&req=%@",
			[NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],
			[contents JSONRepresentationWithURLEncoding]];
}

- (NSString *)grouponListCompress:(BOOL)animated
{
	if (STRINGHASVALUE(cityName)) {
		[contents safeSetObject:cityName forKey:CITYNAME_GROUPON];
        //加入cityid,过滤多店的hoteldetail
//        [contents safeSetObject:[self getCityIDWithCity:cityName] forKey:CITYID_GROUPON];
		[contents safeSetObject:NUMBER(ImageSizeType) forKey:IMAGE_SIZE_TYPE];
		[self setNeedAdition:YES];
	}
    
    if ([contents safeObjectForKey:@"Latitude"]!=[NSNull null] && [contents safeObjectForKey:@"Latitude"]) {
        // 周边搜索默认排序为距离
        if ([[self getOrderType] intValue] == 0) {
            [contents safeSetObject:@"7" forKey:SORTTYPE_REQ];
        }
        // 默认搜索距离5km
        [contents safeSetObject:[NSNumber numberWithInt:5000] forKey:@"Scope"];
    }

	return [NSString stringWithFormat:@"action=GetCurrentGrouponList&compress=%@&req=%@",
			[NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],
			[contents JSONRepresentationWithURLEncoding]];
}

- (NSString *)grouponKeywordSearchCompress:(BOOL)animated
{
    NSDictionary *postDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [PostHeader header], Resq_Header,
                             [PublicMethods getCityIDWithCity:self.cityName] , @"CityID",
                             NUMBER(MAX_ONEPAGE_GROUPON),@"PageSize",
                             NUMBER(MAX_ONEPAGE_GROUPON),@"ProductPageSize",
                             self.hitType,@"HitType",
                             self.keyword , @"KeyWords",[NSNumber numberWithBool:YES],@"IsShowProducts", nil];
    NSLog(@"%@", [postDic JSONRepresentation]);
    
    NSString *requestStr = [NSString stringWithFormat:@"action=SearchKeyWordsInfo&compress=%@&req=%@",[NSString stringWithFormat:@"%@",animated ? @"true" : @"false"],[postDic JSONRepresentationWithURLEncoding]];
    return requestStr;
}


- (BOOL)isNeedRequestForCityList
{
	if ([grouponCitys count] > 0) {
		// 数据超时
		return [reqDate timeIntervalSinceDate:[NSDate date]] < -MAX_TIME_INTERVER;
	}
	else {
		// 第一次请求
		return YES;
	}
}

- (void)nextPage
{
	pageNum ++;
	[contents safeSetObject:NUMBER(pageNum) forKey:PAGE_INDEX];
}

- (void)restoreGrouponListReqest
{
	pageNum = 1;
	[contents safeSetObject:NUMBER(pageNum) forKey:PAGE_INDEX];
	[contents safeSetObject:NUMBER(MAX_PAGESIZE_GROUPON) forKey:PAGE_SIZE_];
    
}

- (void)orderByType:(NSString *)type
{
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"0", orderStrings[0],
						 @"0", orderStrings[1],
						 @"1", orderStrings[2],
						 @"2", orderStrings[3],
						 @"3", orderStrings[4],
						 @"4", orderStrings[5],
                         nil];
	
	NSString *sortType;
	if (![[dic allKeys] containsObject:type]) {
		sortType = @"0";
	}
	else {
		sortType = [dic safeObjectForKey:type];
	}

	[contents safeSetObject:sortType forKey:SORTTYPE_REQ];
}

- (NSString *)getOrderType
{
	return [contents safeObjectForKey:SORTTYPE_REQ];
}

- (void)setLocationName:(NSString *)name
{
    [contents setValue:name forKey:LOCATION_NAME];
}

- (void)setDistrictID:(NSString *)disID
{
	if (0 == [disID intValue]) {
		[contents safeSetObject:[NSNull null] forKey:DISTINCTID_REQ];
	}
	else {
		[contents safeSetObject:disID forKey:DISTINCTID_REQ];
	}
}

- (void)setBizsectionID:(NSString *)bizID
{
	if (0 == [bizID intValue]) {
		[contents safeSetObject:[NSNull null] forKey:BIZSECTIONID_REQ];
	}
	else {
		[contents safeSetObject:bizID forKey:BIZSECTIONID_REQ];
	}
}

- (NSUInteger)getStarLevel
{
    NSInteger level = [[contents safeObjectForKey:STARCODE_REQ] integerValue];
    switch (level) {
        case -1:
            return 0;
            break;
        case 5:
            return 1;
            break;
        case 4:
            return 2;
            break;
        case 3:
            return 3;
            break;
        case 2:
            return 4;
            break;
            
        default:
            return 0;
            break;
    }
}

- (void)setStarLevel:(NSUInteger)level
{
    switch (level) {
        case 0:
            [contents safeSetObject:[NSNumber numberWithInt:-1] forKey:STARCODE_REQ];
            break;
        case 1:
            [contents safeSetObject:[NSNumber numberWithInt:5] forKey:STARCODE_REQ];
            break;
        case 2:
            [contents safeSetObject:[NSNumber numberWithInt:4] forKey:STARCODE_REQ];
            break;
        case 3:
            [contents safeSetObject:[NSNumber numberWithInt:3] forKey:STARCODE_REQ];
            break;
        case 4:
            [contents safeSetObject:[NSNumber numberWithInt:2] forKey:STARCODE_REQ];
            break;
            
        default:
            break;
    }
}

- (NSUInteger)getMinPrice
{
    return [[contents safeObjectForKey:MINPRICE_REQ] unsignedIntegerValue];
}

- (void)setMinPrice:(NSUInteger)minPrice
{
    [contents safeSetObject:[NSNumber numberWithUnsignedInt:minPrice] forKey:MINPRICE_REQ];
}

- (NSUInteger)getMaxPrice
{
    return [[contents safeObjectForKey:MAXPRICE_REQ] unsignedIntegerValue];
}

- (void)setMaxPrice:(NSUInteger)maxPrice
{
    [contents safeSetObject:[NSNumber numberWithUnsignedInt:maxPrice] forKey:MAXPRICE_REQ];
}

- (void)setBrandId
{
    if (self.brand)
    {
        int brandId_ = [[self.brand safeObjectForKey:@"BrandId"] intValue];
        
        if (brandId_>0)
        {
           [contents safeSetObject:[NSNumber numberWithInt:brandId_] forKey:@"BrandId"];
        }
        else
        {
            [contents removeObjectForKey:@"BrandId"];
        }
    }
    else
    {
        [contents removeObjectForKey:@"BrandId"];
    }
}

- (void)setTypeId
{
    if (self.typpee)
    {
        int typeId_ = [[self.typpee safeObjectForKey:@"CategoryId"] intValue];
        
        if (typeId_>0)
        {
            NSArray *extendedCategoryIds=[NSArray arrayWithObjects:[NSNumber numberWithInt:typeId_], nil];
            [contents safeSetObject:extendedCategoryIds forKey:@"ExtendedCategoryIds"];
        }
        else
        {
            [contents removeObjectForKey:@"ExtendedCategoryIds"];
        }
    }
    else
    {
        [contents removeObjectForKey:@"ExtendedCategoryIds"];
    }
}

- (void)setLatitude:(double)latitude
{
    if (latitude == 0) {
        [contents safeSetObject:[NSNull null] forKey:@"Latitude"];
    }else{
        [contents safeSetObject:[NSNumber numberWithDouble:latitude] forKey:@"Latitude"];
    }
}

- (BOOL)isPosition
{
    if ([contents safeObjectForKey:@"Latitude"]==[NSNull null]) {
        return NO;
    }else{
        return YES;
    }
}

- (void)setLongitude:(double)longitude
{
    if (longitude == 0) {
        [contents safeSetObject:[NSNull null] forKey:@"Longitude"];
    }else{
        [contents safeSetObject:[NSNumber numberWithDouble:longitude] forKey:@"Longitude"];
    }
}

- (void)setNeedAdition:(BOOL)animated
{
	[contents safeSetObject:[NSNumber numberWithBool:animated] forKey:ISNEEDADDINFO_REQ];
}

@end
