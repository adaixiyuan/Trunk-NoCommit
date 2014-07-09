//
//  PositioningManager.h
//  ElongClient
//
//  Created by bin xing on 11-2-10.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@protocol PositioningManagerDelegate <NSObject>

- (void)getPositionInfoBack:(NSDictionary *)dicPosition;

@end


@interface PositioningManager : NSObject {
}
@property (nonatomic, copy) NSString *addressName;
@property (nonatomic) BOOL isNotFindCityName;   //是否没有找到城市名字
@property (nonatomic, strong) id <PositioningManagerDelegate> delegate;        // 代理

+ (id)shared;
-(CLLocationCoordinate2D)myCoordinate;
-(void)setMyCoordinate:(CLLocationCoordinate2D)coordinate;
-(void)setCurrentCity:(NSString *)city;
-(NSString *)currentCity;
-(BOOL)isGpsing;
-(void)setGpsing:(BOOL)isStart;
-(BOOL)getPostingBool;
- (void) setAddressName:(NSString *)address;
- (NSString *) getAddressName;

-(NSString *)positionCurrentCity;
-(void)setPositionCurrentCity:(NSString *)city;
// 从地址名获取位置信息
- (void)getPositionFromAddress:(NSString *)addressName;


@end
