//
//  FastPositioning.m
//  ElongClient
//
//  Created by bin xing on 11-2-10.
//  Copyright 2011 DP. All rights reserved.
//

#import "FastPositioning.h"
#import "ElongURL.h"
#import "PostHeader.h"
#import "Utils.h"
#import "PositioningManager.h"

static FastPositioning *fastPos = nil;
static int distancePosition  = 800;
static int delayTimePosition = 3;

@interface FastPositioning()
@property (nonatomic,retain) CLLocation *originalLocation;

@end

@implementation FastPositioning
@synthesize originalLocation;

@synthesize m_locationManager;
@synthesize autoCancel;
@synthesize reverseGeocoder;
@synthesize geoCoder;
@synthesize addressName;

- (void)dealloc {
	self.m_locationManager	= nil;
	self.reverseGeocoder	= nil;
    self.geoCoder           = nil;
    self.addressName        = nil;
    self.originalLocation   = nil;
    self.specialCity        = nil;
    self.fullAddress        = nil;
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		autoCancel = YES;
		self.m_locationManager = [[[CLLocationManager alloc] init] autorelease];
		
		m_locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		m_locationManager.distanceFilter = distancePosition;
		m_locationManager.delegate = self;
	}
	
	return self;
}



- (void)fastPositioning {
    // 大洋洲 悉尼 喜来登公园酒店 latitude=-33.87176&longitude=151.21008
    // 欧洲 巴黎 泰勒酒店 latitude=48.86945&longitude=2.35906
    // 非洲 约翰内斯堡 米开朗基罗酒店 latitude=-26.10772&longitude=28.05337
    // 北美洲 纽约 梅拉酒店 latitude=40.75656&longitude=-73.98419
    // 南美洲 圣保罗 皇家花园精品酒店 latitude=-23.56502&longitude=-46.65598
    
    /*大洋洲 悉尼 喜来登公园酒店
    float latitude=-33.87176;
    float longitude=151.21008;
    [[PositioningManager shared] setCurrentCity:@"悉尼"];
    [[PositioningManager shared] setMyCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    [[PositioningManager shared] setPCurrentCity:@"悉尼"];
    [[PositioningManager shared] setGpsing:NO];
    _abroad = YES;
    return;
    */
    
    
    /* 欧洲 巴黎 泰勒酒店
     float latitude=48.86945;
     float longitude=2.35906;
     [[PositioningManager shared] setCurrentCity:@"巴黎"];
     [[PositioningManager shared] setMyCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
     [[PositioningManager shared] setPCurrentCity:@"巴黎"];
     [[PositioningManager shared] setGpsing:NO];
     _abroad = YES;
     return;
     */
    
    /* 非洲 约翰内斯堡 米开朗基罗酒店
     float latitude=-26.10772;
     float longitude=28.05337;
     [[PositioningManager shared] setCurrentCity:@"约翰内斯堡"];
     [[PositioningManager shared] setMyCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
     [[PositioningManager shared] setPCurrentCity:@"约翰内斯堡"];
     [[PositioningManager shared] setGpsing:NO];
     _abroad = YES;
     return;
     */
    
    /* 北美洲 纽约 梅拉酒店
     float latitude=40.75656;
     float longitude=-73.98419;
     [[PositioningManager shared] setCurrentCity:@"纽约"];
     [[PositioningManager shared] setMyCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
     [[PositioningManager shared] setPCurrentCity:@"纽约"];
     [[PositioningManager shared] setGpsing:NO];
     _abroad = YES;
     return;
     */
    
    /* 南美洲 圣保罗 皇家花园精品酒店
     float latitude=-23.56502;
     float longitude=-46.65598;
     [[PositioningManager shared] setCurrentCity:@"圣保罗"];
     [[PositioningManager shared] setMyCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
     [[PositioningManager shared] setPCurrentCity:@"圣保罗"];
     [[PositioningManager shared] setGpsing:NO];
     _abroad = YES;

     return;
     */
    
    
    /*乌干达 坎帕拉 
     float latitude = 0.31695;
     float longitude = 32.5822;
     [[PositioningManager shared] setCurrentCity:@"坎帕拉"];
     [[PositioningManager shared] setMyCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
     [[PositioningManager shared] setPCurrentCity:@"坎帕拉"];
     [[PositioningManager shared] setGpsing:NO];
     _abroad = YES;
     return;
     */
    
    
    
    
    if ([CLLocationManager locationServicesEnabled]) {
		[m_locationManager startUpdatingLocation];
	}
	else {
		NSLog(@"Location services not enabled");
	}
}


- (void)requestForLBSInfo {
	NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
							  [PostHeader header], @"Header",
							  [[PositioningManager shared] currentCity], CITYNAME_GROUPON,
							  [NSString stringWithFormat:@"%f", [[PositioningManager shared] myCoordinate].latitude], @"Lat",
							  [NSString stringWithFormat:@"%f", [[PositioningManager shared] myCoordinate].longitude], @"Lng", nil];
	
	NSString *reqStr = [NSString stringWithFormat:@"action=GetHelloElongInfos&compress=true&req=%@",
						[paramDic JSONRepresentationWithURLEncoding]];
	[Utils request:PUSH_SEARCH req:reqStr delegate:self disablePop:YES disableClosePop:YES disableWait:YES];
}


- (void)stopPosition {
	[m_locationManager stopUpdatingLocation];
	
	// 定位结束时，向服务器请求周边信息
	//[self requestForLBSInfo];
}


+ (id)shared {
	@synchronized(fastPos) {
		if (!fastPos) {
			fastPos = [[FastPositioning alloc] init];
		}
	}
	
	return fastPos;
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    if (!newLocation) {
        [self locationManager:manager didFailWithError:(NSError *)NULL];
        return;
    }
    
    if (signbit(newLocation.horizontalAccuracy)) {
		[self locationManager:manager didFailWithError:(NSError *)NULL];
		return;
	}
    // 记录下来最原始的坐标，方便纠偏以后恢复使用
    self.originalLocation = newLocation;
    
    CLLocationCoordinate2D mNewLocation; // 火星坐标
    
    double lon = newLocation.coordinate.longitude;
    double lat = newLocation.coordinate.latitude;
    
    const double a = 6378245.0f;
    const double ee = 0.00669342162296594323;
    
    // 把坐标点范围锁定在国内，排除国外的情况
    if (lon > 72.004 && lon < 137.8347 && lat > 0.8293 && lat < 55.8271) {
        double dLat = transformLat(lon - 105.0, lat - 35.0);
        double dLon = transformLon(lon - 105.0, lat - 35.0);
        double radLat = lat / 180.0 * M_PI;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
        double mgLat = lat + dLat;
        double mgLon = lon + dLon;
        
        mNewLocation = CLLocationCoordinate2DMake(mgLat, mgLon);
    }
    else {
        mNewLocation = [newLocation coordinate];
    }
    
    [[PositioningManager shared] setMyCoordinate:mNewLocation];
	
	[[PositioningManager shared] setGpsing:NO];
	
	if (autoCancel) {
		[self performSelector:@selector(stopPosition) withObject:nil afterDelay:delayTimePosition];
	}
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:mNewLocation.latitude longitude:mNewLocation.longitude]; // 火星坐标
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        [self locationAddressWithLocation:location];
    }else {
        [self startedReverseGeoderWithCoordinate:mNewLocation];
    }
    
    [location autorelease];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
	NSLog(@"定位失败:%@",error);
}


//  IOS 5.0 及以上版本使用此方法
- (void)locationAddressWithLocation:(CLLocation *)locationGps
{
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    self.geoCoder = clGeoCoder;
    [clGeoCoder release];
    
    [self.geoCoder reverseGeocodeLocation:locationGps completionHandler:^(NSArray *placemarks, NSError *error)
     {
         for (CLPlacemark *placeMark in placemarks)
         {
             if ([placeMark.ISOcountryCode isEqualToString:@"CN"]) {
                 _abroad = NO;
             }
             else {
                 _abroad = YES;
             }
             // 如果没有街道信息就显示地址全称，如果有街道信息就显示街道信息
             NSString *markName = nil;
             NSString *singleAddress = @""; //c2c用
             if (!placeMark.locality) {
                 [[PositioningManager shared] setPositionCurrentCity:placeMark.administrativeArea];
                 [[PositioningManager shared] setCurrentCity:placeMark.administrativeArea];
                 [self dealWithSpecialCitys:placeMark.administrativeArea];
                 
                 if (placeMark.thoroughfare) {
                     markName = [NSString stringWithFormat:@"%@%@",placeMark.administrativeArea,placeMark.thoroughfare];
                     singleAddress = placeMark.thoroughfare;
                 }else{
                     markName = [NSString stringWithFormat:@"%@",placeMark.name];
                     singleAddress = placeMark.name;
                 }
             
             }else{
                 [[PositioningManager shared] setPositionCurrentCity:placeMark.locality];
                 [[PositioningManager shared] setCurrentCity:placeMark.locality];
                 [self dealWithSpecialCitys:placeMark.locality];
                 
                 if (placeMark.thoroughfare) {
                    markName = [NSString stringWithFormat:@"%@%@",placeMark.locality,placeMark.thoroughfare];
                    singleAddress = placeMark.thoroughfare;
                 }else{
                    markName = [NSString stringWithFormat:@"%@",placeMark.name];
                    singleAddress = placeMark.name;
                 }
                
             }
             self.addressName = markName;
             self.singaddressName_c2c =singleAddress;
             NSArray *addressLines = [[placeMark addressDictionary] objectForKey:@"FormattedAddressLines"];
             if (addressLines && addressLines.count) {
                 self.fullAddress = [addressLines componentsJoinedByString:@""];
                 self.fullAddress = [self.fullAddress stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                 
             }
             
            [[PositioningManager shared] setAddressName:markName];
         }
     }];
}


// 目前只处理香港、澳门
- (void) dealWithSpecialCitys:(NSString *)cityName{
    self.specialCity = nil;
    NSArray *specialCity = [NSArray arrayWithObjects:@"香港",@"Hong Kong",@"澳门",@"Macau", nil];
    for (int i = 0; i < specialCity.count; i++) {
        NSRange range;
        range = [cityName rangeOfString:[specialCity objectAtIndex:i] options:NSCaseInsensitiveSearch];
        if (range.length) {
            self.specialCity = [specialCity objectAtIndex:i];
            NSLog(@"发现特殊定位城市：%@",self.specialCity);
            
            // 恢复定位修正
            [[PositioningManager shared] setMyCoordinate:self.originalLocation.coordinate];
            return;
        }
    }
    NSLog(@"没有发现特殊定位城市");
}

#pragma mark -
#pragma mark MKReverseGeocoder
// IOS5以下版本用此方法
- (void)startedReverseGeoderWithCoordinate:(CLLocationCoordinate2D)coordinate2D {
    self.reverseGeocoder = [[[MKReverseGeocoder alloc] initWithCoordinate:coordinate2D] autorelease];
    self.reverseGeocoder.delegate = self;
    [self.reverseGeocoder start];
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    // 如果没有街道信息就显示地址全称，如果有街道信息就显示街道信息
    NSString *markName = nil;
	if (!placemark.locality) {
        if ([placemark.countryCode isEqualToString:@"CN"]) {
            _abroad = NO;
        }
        else {
            _abroad = YES;
        }
        [[PositioningManager shared] setPositionCurrentCity:placemark.administrativeArea];
        [[PositioningManager shared] setCurrentCity:placemark.administrativeArea];
        [self dealWithSpecialCitys:placemark.administrativeArea];
        
        markName = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.thoroughfare];
        self.singaddressName_c2c = placemark.thoroughfare;
    }else{
        [[PositioningManager shared] setPositionCurrentCity:placemark.locality];
        [[PositioningManager shared] setCurrentCity:placemark.locality];
        [self dealWithSpecialCitys:placemark.locality];
        
        
        markName = [NSString stringWithFormat:@"%@%@",placemark.locality,placemark.thoroughfare];
        self.singaddressName_c2c = placemark.thoroughfare;
    }
    self.addressName = markName;
    [[PositioningManager shared] setAddressName:markName];
    
    NSArray *addressLines = [[placemark addressDictionary] objectForKey:@"FormattedAddressLines"];
    if (addressLines && addressLines.count) {
        self.fullAddress = [addressLines componentsJoinedByString:@""];
        self.fullAddress = [self.fullAddress stringByReplacingOccurrencesOfString:@"中国" withString:@""];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	NSLog(@"reverseGeocoderError:%@",[error description]);
}

#pragma mark Private Method

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

@end
