//
//  fStatusDetailView.h
//  ElongClient
//
//  Created by bruce on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "FStatusDetail.h"
#import "RefreshControl.h"

typedef enum
{
	eFSDetailTypeList = 1,                      // 列表页
	eFSDetailTypeMap,							// 地图页
} FSDetailPageType;

// =============================================================================
// 回调协议
// =============================================================================
@protocol DetailViewDelgt <NSObject>

// 结果回调
- (void)deleteAttention:(NSMutableArray *)arrayAttention;

@end

@interface DetailView : UIView <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate,UIAlertViewDelegate,FStatusDetailDelgt>


@property (nonatomic, strong) UIView *viewTop;
@property (nonatomic, strong) UIView *viewContent;                      // 界面容器
@property (nonatomic, strong) UIView *viewList;                         // 列表页
@property (nonatomic, strong) UIView *viewMap;                          // 地图模式
@property (nonatomic, strong) UIView *viewFail;                         // 加载失败视图
@property (nonatomic, strong) UITableView *tableViewResult;
@property (nonatomic, strong) MKMapView *mKMapView;
@property (nonatomic, strong) RefreshControl *refreshControl;           // 下拉刷新

@property (nonatomic, strong) FStatusDetail *fStatusDetail;             // 航班详情
@property (nonatomic, assign) FSDetailPageType listType;                // 页面类型
@property (nonatomic, assign) CGFloat cellFlightInfoHeight;             // 航班信息界面高度
@property (nonatomic, assign) CGFloat flightAngle;
@property (nonatomic, assign) FSDetailLoadType loadType;                // 加载状态
@property (nonatomic, assign) FSDetailType detailType;                  // 详情类型
@property (nonatomic, assign) BOOL isAdded;                             // 是否已添加关注
@property (nonatomic, strong) NSMutableArray *arrayAttention;			// 我的关注
@property (nonatomic, strong) id <DetailViewDelgt> delegate;
@property (nonatomic, strong) NSString *flightNumber;                   // 航班号
@property (nonatomic, strong) NSString *flightDate;                     // 航班日期
@property (nonatomic, strong) NSString *resultMsg;                      // 数据加载返回状态描述
@property (nonatomic, assign) BOOL isPullRefresh;                       // 是否下拉刷新
@property (nonatomic, strong) NSString *refreshTimeKey;                 // 刷新时间Key
@property (nonatomic, strong) NSDateFormatter *oFormat;                 // 时间显示格式

- (void)setFStatusDetail:(FStatusDetail *)fStatusDetail;
- (void)setDetailType:(FSDetailType)detailType;

- (void)nomalRefresh;
- (void)pullRefresh;

// 清除内存
- (void)clearView;

// 获取关注信息
//+ (NSMutableArray *)arrayAttention;


@end
