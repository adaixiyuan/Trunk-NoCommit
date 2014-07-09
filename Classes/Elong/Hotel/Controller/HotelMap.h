//
//  RoomMap.h
//  ElongClient
//
//  Created by bin xing on 11-1-6.
//  Copyright 2011 DP. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HotelDefine.h"
#import "ScalableView.h"

typedef enum{
    AutoNavi,
    GoogleMap,
    EmptyMapData
}HotelMapDataFrom;

typedef enum {
    Driving,
    Walking
}HotelMapTravelMode;

#define MAPROUTECOLOR [UIColor colorWithRed:68.0f/255.0f green:184.0f/255.0f blue:34.0/255.0f alpha:0.8]
#define TIPSLBL 1010
#define STEPTVHEIGHT 240
@protocol HotelMapDelegate;
@interface HotelMap : MKMapView <CLLocationManagerDelegate, MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,ScalableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate> {
    UIViewController *parentvc;
@private
    CLLocationCoordinate2D ccld;               
    CLLocationCoordinate2D currentld;
    
    HttpUtil *directionUtil;                    // 导航搜索
    HttpUtil *poiUtil;
    
    HotelMapDataFrom mapDataFrom;
    NSArray *routes_driving;
    NSArray *routes_walking;
    NSArray *steps_driving;
    NSArray *steps_walking;
    
    UIView *navTipsView;
    UITableView *stepsTableView;
    UIView *stepsContentView;
    
    PriceAnnotation *hotelAnnotation;
    PriceAnnotation *currentAnnotation;
    
    NSString *start_address;                    // 导航开始点地址
    NSString *end_address;                      // 导航终止点地址
    CLLocationCoordinate2D start_location;      // 导航开始节点坐标
    CLLocationCoordinate2D end_location;        // 导航终止节点坐标

    
    HotelMapTravelMode travelMode;
    ScalableView *navScalableView;              // 导航
    ScalableView *poiScalableView;              // 酒店、餐馆
    
    NSMutableDictionary *poiDict;
    NSInteger poiIndex;
    NSMutableArray *poiAnnotations;

}



@property (nonatomic,assign) BOOL showAround;               // 是否显示周边搜索
@property (nonatomic,assign)   NSString *hotelTitle;        // 地图大头针提示title
@property (nonatomic,assign)   NSString *hotelSubtitle;     // 地图大头针提示subtitle
@property (nonatomic,copy)     NSString *hotelPhone;        // 酒店电话
@property (nonatomic,assign) BOOL international;            // 是否为国际酒店地图
@property (nonatomic,assign) BOOL groupon;                  // 是否为团购酒店地图
@property (nonatomic,assign) id<HotelMapDelegate> hotelMapDelegate;

// 地图初始化函数
- (id) initWithFrame:(CGRect)frame latitude:(double) lat longitude:(double)lng;
- (id) initWithFrame:(CGRect)frame latitude:(double) lat longitude:(double)lng detailEnabled:(BOOL)detailEnabled;
@end

@protocol HotelMapDelegate <NSObject>

- (void) hotelMapShowDetail:(HotelMap *)hotelMap position:(CLLocationCoordinate2D)coordinate2D hotelName:(NSString *)hotelName;

@end
