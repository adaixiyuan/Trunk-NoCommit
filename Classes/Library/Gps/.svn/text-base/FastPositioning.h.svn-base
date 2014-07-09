//
//  FastPositioning.h
//  ElongClient
//
//  Created by bin xing on 11-2-10.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PositioningManager.h"

@interface FastPositioning : NSObject<CLLocationManagerDelegate, MKReverseGeocoderDelegate>

@property (nonatomic, retain) CLLocationManager *m_locationManager;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
@property (nonatomic, retain) CLGeocoder *geoCoder;
@property (nonatomic, assign) BOOL autoCancel;						// 自动停止定位
@property (nonatomic, copy) NSString *addressName;
@property (nonatomic, assign, readonly) BOOL abroad;
@property (nonatomic,copy) NSString *specialCity;
@property (nonatomic,copy) NSString *fullAddress;
@property (nonatomic, copy) NSString *singaddressName_c2c;  //c2c中 只要街道名称，不需要省级名称，如果没有街道名称则显示地址全称
+ (id)shared;
- (void)fastPositioning;
- (void)stopPosition;			

@end
