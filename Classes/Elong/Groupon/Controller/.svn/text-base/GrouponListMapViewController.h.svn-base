//
//  GrouponListMapViewController.h
//  ElongClient
//
//  Created by Dawn on 13-6-21.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PinAnnotation.h"

@class GrouponHomeViewController, PriceAnnotation;
@interface GrouponListMapViewController : UIViewController<MKMapViewDelegate,  HttpUtilDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    int linkType;
	
	NSMutableArray *mapAnnotations;
	
	NSMutableDictionary *mapAnnotationDic;		// 记录团购产品与对应酒店的关系
	
	UILabel *noDataTipLabel;					// 没有数据时提示框
	
	SmallLoadingView *smallLoading;				// 地图模式loading框
	
    HttpUtil *moreHotelUtil;
    HttpUtil *poiSearchUtil;
    MKMapView *mapView;
    UISearchBar *searchBar;                     // 搜索框
    UISearchDisplayController *searchDC;
    HttpUtil *posiUtil;
    UIView *tipBar;
}
@property (nonatomic, readonly) MKMapView *mapView;
@property (nonatomic, assign)   GrouponHomeViewController *hoomVC;


- (void)addMapAnnotations:(NSArray *)annotations;		// 添加酒店
- (void)removeMapAnnotationsInRange:(NSRange)range;		// 删除酒店
- (void)goUserLoacation;								// 前往用户当前位置
- (void)goGrouponHotel;									// 前往酒店所在区域
- (void)searchMoreHotel;								// 查询更多酒店
- (void)resetAnnotations;								// 重设地图上的价格标签

@end
