//
//  HotelMapModel.h
//  ElongClient
//
//  Created by bin xing on 11-2-7.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HotelDefine.h"
#import <QuartzCore/QuartzCore.h>

@class PinAnnotation, HotelSearchResultManager;
@interface HotelMapMode : UIViewController<MKMapViewDelegate, MKReverseGeocoderDelegate,UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate> {
	NSMutableArray *mapAnnotations;
	NSDictionary *hotelDetail;
	int linktype;
	
	PinAnnotation *pinAnnotation;				// 目的地注解
	
	SmallLoadingView *smallLoading;				// 地图模式loading框
	
	NSInteger searchRadius;						// 搜索半径
	NSInteger geoTime;							// default:5
	NSInteger hotelCount;						// 总共请求过的酒店数量
	
	BOOL canLocationSearch;						// 是否允许进行定位搜索
	BOOL selfIsDealloc;							// 判断自己是否已被释放
	
	NSTimer *geoTimer;							// 获取地理位置信息计时
	
	MKReverseGeocoder *searchGeocoder;
	
	UILabel *noDataTipLabel;					// 没有数据时提示框
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDC;
    NSMutableArray *posiArray;
    NSString *savedSearchTerm;
//    UIActivityIndicatorView *loadingView;
}

@property (nonatomic,retain) MKMapView *mapView;
@property (nonatomic,assign) HotelSearchResultManager *rootController; 
@property (nonatomic,assign) BOOL isResearch;	// 是否在本页面搜索过，关系是否刷新列表页面的数据
@property (nonatomic,assign) BOOL requestBlock;	// 请求锁，防止更多和长按同时执行或者多次点击更多
@property (nonatomic,retain) NSMutableArray *posiArray;
@property (nonatomic,retain) NSString *savedSearchTerm;
@property (nonatomic,readonly) UISearchDisplayController *searchDC;
@property (nonatomic,retain) HttpUtil *moreHotelUtil;				// 请求更多酒店
@property (nonatomic,retain) HttpUtil *locationUtil;				// 请求新的位置
@property (nonatomic,retain) HttpUtil *posiUtil;                     // 地标搜索
@property (nonatomic,retain) HttpUtil *defaultUtil;                  // 默认搜索
@property (nonatomic,assign) NSInteger hotelCount;
@property (nonatomic,retain) NSString *cityName;

- (void)searchMoreHotel;						// 查询更多酒店
- (void)selectPin;								// 显示搜索位置的气泡
- (void)addmark;								// 重设价格显示标签
- (void)reloadMap;								// 刷新地图元素
- (void)moveCurrentPin;							// 移除当前的大头针
- (void)removeMapAnnotationsInRange:(NSRange)range;		// 删除酒店
- (void)stopAllMapReq;							// 停止所有网络数据请求
- (void) centerMap;                             // 校正点的定位区域
- (void) setKeyword;
@end