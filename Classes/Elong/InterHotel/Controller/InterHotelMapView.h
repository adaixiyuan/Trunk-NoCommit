//
//  InterHotelMapVC.h
//  ElongClient
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PinAnnotation.h"
#import "RoundCornerView.h"

@class InterHotelListResultVC;
@interface InterHotelMapView : UIView<MKMapViewDelegate>{
@private
    MKMapView *mapView;
    PinAnnotation *pinAnnotation;       // 地图中的大头针标注
    UIView *tipBar;                     // 长按手势提示
    HttpUtil *moreHotelReq;             // 请求更多酒店
    HttpUtil *poiHotelReq;              // 周边搜索
    BOOL isRequstMore;                  // 判断是否正在请求更多酒店
    NSInteger lastHotelId;              // 纪录最后一次请求的最后一个酒店id，用以判断翻页(国际酒店数量不准)
    SmallLoadingView *smallLoading;
    UILabel *noDataTipLabel;
}
@property (nonatomic, assign) InterHotelListResultVC *rootController;
- (void) goUserLocation;                // 定位到自己所在位置
- (void)selectPin;                      // 选中酒店所在位置，或者用户主动设定位置
- (void) refreshMap;                    // 重新加载数据
- (void) searchMoreHotel;               // 加载更多酒店
- (void) addMoreData;                   // 对外公开，有更多数据时调用刷新
@end
