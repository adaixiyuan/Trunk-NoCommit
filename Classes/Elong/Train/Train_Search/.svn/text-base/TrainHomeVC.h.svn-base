//
//  TrainHomeVC.h
//  ElongClient
//
//  Created by bruce on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "SelectCity.h"
#import "ELCalendarViewController.h"

typedef enum citySelectType : NSUInteger
{
    eTDepartCity = 1,
    eTArriveCity,
} TrainCitySelectType;

@interface TrainHomeVC : DPNav <UITableViewDelegate, UITableViewDataSource,SelectCityDelegate,HttpUtilDelegate, ElCalendarViewSelectDelegate>

@property (nonatomic, strong) UITableView *tableViewParam;                  // 列查查询参数
@property (nonatomic, strong) NSString *departCity;                         // 出发城市
@property (nonatomic, strong) NSString *arriveCity;                         // 到达城市
@property (nonatomic, strong) NSString *departDate;                         // 出发日期
@property (nonatomic, strong) NSString *departMonth;                        // 出发日期月
@property (nonatomic, strong) NSString *departWeek;                         // 出发日期周
@property (nonatomic, strong) NSString *departDay;                          // 出发日期天
@property (nonatomic, strong) NSDate *deDate;                               // 出发日期
@property (nonatomic, assign) BOOL isSelectHighTrain;                       // 是否选择高铁筛选项
@property (nonatomic, assign) BOOL isSelectTicket;                          // 是否选择有票筛选项
@property (nonatomic, assign) TrainCitySelectType citySelectType;           // 城市选择类型
@property (nonatomic, assign) BOOL isViewPushHappen;                        // 是否触发城市列表Push事件

@end
