//
//  PositioningManager.m
//  ElongClient
//
//  Created by bin xing on 11-2-10.
//  Copyright 2011 DP. All rights reserved.
//

#import "PositioningManager.h"
#import "FastPositioning.h"

static PositioningManager *posManager = nil;
static CLLocationCoordinate2D myCoordinate;
static BOOL isGpsing;
static BOOL isPositing;


@interface PositioningManager ()

@property (nonatomic, copy) NSString *pCurrentCity;
@property (nonatomic, copy) NSString *markName;
@property (nonatomic,copy) NSString *positionCity;//地理定位到的城市，不做任何处理!

@end


@implementation PositioningManager
@synthesize markName;
@synthesize pCurrentCity;
@synthesize positionCity;

- (void)dealloc {
    SFRelease(_delegate);
    self.positionCity = nil;
	self.pCurrentCity = nil;
    self.markName = nil;
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		isGpsing = YES;
		isPositing = NO;
        self.positionCurrentCity = @"";
        self.isNotFindCityName=YES;
	}
	
	return self;
}


+ (id)shared {
	@synchronized(posManager) {
		if (!posManager) {
			posManager = [[PositioningManager alloc] init];
		}
	}
	
	return posManager;
}


-(BOOL)isGpsing{
	return isGpsing;
}


-(void)setGpsing:(BOOL)isStart{
	isGpsing=isStart;
}


-(CLLocationCoordinate2D)myCoordinate{
	return myCoordinate;
}


-(void)setMyCoordinate:(CLLocationCoordinate2D) coordinate
{
	myCoordinate = coordinate;
}

- (void) setAddressName:(NSString *)address
{
    self.markName = address;
}

- (NSString *) getAddressName
{
    return markName;
}

- (void)setCurrentCity:(NSString *)city {
    BOOL found = NO;
	if ([city hasSuffix:@"市"] ||
        [city hasSuffix:@"县"] ||
        [city hasSuffix:@"村"]) {
		// 中文去掉“市”、“县”等标志
		city = [city substringToIndex:[city length]-1];
        found = YES;
	}
    //香港，澳门
    else if([city hasPrefix:@"香港"])
    {
        city=@"香港";
        found = YES;
    }
    else if([city hasPrefix:@"澳门"]||[city hasPrefix:@"澳門"])
    {
        city=@"澳门";
        found = YES;
    }
	else {
		// 英文到本地城市列表搜索对应
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"hotelcity" ofType:@"plist"];
		NSDictionary *localCityDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
		
		for (NSArray *array in [localCityDic allValues]) {
			for (NSArray *cityElements in array) {
				if (NSOrderedSame == [[cityElements safeObjectAtIndex:1] compare:city options:NSCaseInsensitiveSearch]) {
					city = [cityElements safeObjectAtIndex:0];
					found = YES;
					break;
				}
			}
		}
		
		[localCityDic release];
	}
	
    if (found) {
        if ([[FastPositioning shared] abroad])
        {
            // 如果在国外的话，一律把默认城市名改为北京
            self.pCurrentCity = @"北京";
        }
        else
        {
            self.pCurrentCity = city;
            
        }
        self.isNotFindCityName=NO;
    }
    else
    {
        self.isNotFindCityName=YES;
    }
}

-(NSString *)currentCity{
	isPositing = YES;
	if (pCurrentCity==nil || [pCurrentCity length]==0) {
		isPositing = NO;
		self.pCurrentCity = @"北京";
	}
	
	return pCurrentCity;
}

-(NSString *)positionCurrentCity{

    return self.positionCity;
}
-(void)setPositionCurrentCity:(NSString *)city{
    self.positionCity = city;
}

-(BOOL)getPostingBool{
	return isPositing;
}

// 从地址名获取位置信息
- (void)getPositionFromAddress:(NSString *)addressName
{
//    NSString *addressName = @"南苑机场";
    
    NSMutableDictionary *locationInfo = [[NSMutableDictionary alloc]init];
    
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:addressName completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if ([placemarks count] > 0 && error == nil)
         {
             CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];

             // 经纬度
             NSString *stringLonlat = [NSString stringWithFormat:@"%f,%f",firstPlacemark.location.coordinate.latitude,firstPlacemark.location.coordinate.longitude];
             [locationInfo safeSetObject:stringLonlat forKey:@"latlonInfo"];
             
             NSString *cityName = @"";
             
             if (!firstPlacemark.locality)
             {
                 cityName = firstPlacemark.administrativeArea;
             }else
             {
                 cityName = firstPlacemark.locality;
             }
             
             if (locationInfo != nil && firstPlacemark != nil)
             {
                 if (STRINGHASVALUE(cityName))
                 {
                     if ([cityName hasSuffix:@"市"] ||
                         [cityName hasSuffix:@"县"] ||
                         [cityName hasSuffix:@"村"]) {
                         // 中文去掉“市”、“县”等标志
                         cityName = [cityName substringToIndex:[cityName length]-1];
                     }
                     //香港，澳门
                     else if([cityName hasPrefix:@"香港"])
                     {
                         cityName=@"香港";
                     }
                     else if([cityName hasPrefix:@"澳门"]||[cityName hasPrefix:@"澳門"])
                     {
                         cityName=@"澳门";
                     }
                     
                     // 保存
                     [locationInfo safeSetObject:cityName forKey:@"cityName"];
                     
                     // 代理回调
                     if((_delegate != nil) && ([_delegate respondsToSelector:@selector(getPositionInfoBack:)] == YES))
                     {
                         [_delegate getPositionInfoBack:locationInfo];
                     }
                 }
             }
             
             NSLog(@"locationInfo neibu is%@",[locationInfo description]);
         }
         else if ([placemarks count] == 0 && error == nil) {
             NSLog(@"Found no placemarks.");
         }
         else if (error != nil) {
             NSLog(@"An error occurred = %@", error); }
     }];
}

@end
