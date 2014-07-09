//
//  TrainSearchListVC.h
//  ElongClient
//
//  Created by bruce on 13-11-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "TrainList.h"
#import "TrainSearchFilterController.h"
#import "TrainSearchDetailVC.h"
#import "ELCalendarViewController.h"
#import "RefreshControl.h"
#import "TrainIdenfyCodeModel.h"

@interface TrainSearchListVC : DPNav <UITableViewDelegate, UITableViewDataSource, HttpUtilDelegate, SearchFilterDelegate,TrainDetailDelegate, ElCalendarViewSelectDelegate>

@property (nonatomic, strong) UITableView *tableViewList;            // 列车信息列表
@property (nonatomic, strong) UIView *viewTop;                       // 顶部区域
@property (nonatomic, strong) UIView *viewBottom;                    // 底部区域
@property (nonatomic, strong) RefreshControl *refreshControl;        // 下拉刷新
@property (nonatomic, strong) TrainSearchDetailVC *trainDetailVC;    // 详情视图
@property (nonatomic, strong) NSString *departDate;                  // 搜索日期
@property (nonatomic, strong) NSString *departDateTmp;               // 搜索日期缓存
@property (nonatomic, strong) NSString *showDate;                    // 显示日期
@property (nonatomic, strong) NSString *departCity;                  // 出发日期
@property (nonatomic, strong) NSString *arriveCity;                  // 到达日期
@property (nonatomic, strong) TrainList *trainListCur;               // 当前列表数据
@property (nonatomic, strong) NSArray *arrayTickets;                 // 列车数据
@property (nonatomic, strong) NSDictionary *filterInfo;              // 筛选信息
@property (nonatomic, strong) NSDateFormatter *oFormat;              // 时间显示格式
@property (nonatomic, strong) NSDateFormatter *mFormat;              // 时间显示格式,加小时和分钟
@property (nonatomic, strong) NSDateFormatter *filterFormat;         // 时间筛选格式
@property (nonatomic, strong) NSString *formatDuration;              // 格式化列车历时
@property (nonatomic, assign) BOOL hasTicketFilte;                   // 有票筛选
//
@property (nonatomic, assign) BOOL isPullRefresh;                    // 是否下拉刷新
@property (nonatomic, assign) BOOL isPriceAscending;                 // 价格排序是否升序
@property (nonatomic, assign) BOOL isTimeAscending;                  // 时间排序是否升序
@property (nonatomic, assign) BOOL isPriceReset;                     // 价格排序重置
@property (nonatomic, assign) BOOL isTimeReset;                      // 时间排序重置
@property (nonatomic, assign) BOOL isNetLoading;                     // 是否正在网络加载
@property (nonatomic, assign) BOOL isDetailViewShow;                 // 详情视图是否展示
@property (nonatomic, strong) UINavigationController *filterNav;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, strong) HttpUtil *getListUtil;
@property (nonatomic, strong) TrainIdenfyCodeModel *trainIdenfyCodeTool; //验证码数据

// 筛选数据
- (void)filteDataStart;

@end
