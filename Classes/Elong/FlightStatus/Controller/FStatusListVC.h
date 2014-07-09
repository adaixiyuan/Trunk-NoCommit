//
//  FStatusListVC.h
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "FStatusList.h"
#import "FlightSearchFilterController.h"
#import "FStatusDetail.h"

@interface FStatusListVC : DPNav <UITableViewDelegate, UITableViewDataSource, SearchFilterDelegate, FStatusDetailDelgt>



@property (nonatomic, strong) UITableView *tableViewList;            // 航班信息列表
@property (nonatomic, strong) UIView *viewBottom;                    // 底部区域
@property (nonatomic, strong) UINavigationController *filterNav;     // 筛选视图

@property (nonatomic, strong) FStatusList *fStatusListCur;           // 当前列表数据
@property (nonatomic, strong) NSArray *arrayFlightInfos;             // 航班数据
@property (nonatomic, assign) BOOL isTimeAscending;                  // 时间排序是否升序
@property (nonatomic, strong) NSDictionary *filterInfo;              // 筛选信息
@property (nonatomic, strong) FStatusDetail *fStatusDetail;          // 航班详情
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end
