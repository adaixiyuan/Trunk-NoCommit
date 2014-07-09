//
//  GrouponMapView.h
//  ElongClient
//
//  Created by 赵 海波 on 12-3-22.
//  Copyright 2012 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class GrouponHomeViewController, PriceAnnotation;

@interface GrouponMapView : UIView <MKMapViewDelegate,  HttpUtilDelegate> {
@private
	int linkType;
	
	NSMutableArray *mapAnnotations;
	
	NSMutableDictionary *mapAnnotationDic;		// 记录团购产品与对应酒店的关系
	
	UILabel *noDataTipLabel;					// 没有数据时提示框
	
	GrouponHomeViewController *rootCtr;
	
	SmallLoadingView *smallLoading;				// 地图模式loading框
	
    HttpUtil *moreHotelUtil;
}

@property (nonatomic, retain) MKMapView *mapView;

- (id)initWithFrame:(CGRect)frame Root:(GrouponHomeViewController *)root;

- (void)addMapAnnotations:(NSArray *)annotations;		// 添加酒店
- (void)removeMapAnnotationsInRange:(NSRange)range;		// 删除酒店
- (void)goUserLoacation;								// 前往用户当前位置
- (void)goGrouponHotel;									// 前往酒店所在区域
- (void)searchMoreHotel;								// 查询更多酒店
- (void)resetAnnotations;								// 重设地图上的价格标签

@end
