//
//  FStatusSearchVC.h
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "CustomSegmented.h"
#import "SelectCity.h"
#import "ELCalendarViewController.h"
#import "FStatusDetail.h"

typedef enum FStatusParamType : NSUInteger
{
    eFStatusTypeNumber = 0,
    eFStatusTypeCity,
} FStatusParamType;

typedef enum citySelectType : NSUInteger
{
    eFSDepartCity = 1,
    eFSArriveCity,
} FlightStatusSelectType;

@interface FStatusSearchVC : DPNav <UITableViewDelegate, UITableViewDataSource, CustomSegmentedDelegate,SelectCityDelegate,HttpUtilDelegate, UITextFieldDelegate, ElCalendarViewSelectDelegate, FStatusDetailDelgt>


@property (nonatomic, strong) UITableView *tableViewParam;                  // 列查查询参数
@property (nonatomic, strong) UIView *viewResponder;
@property (nonatomic, strong) NSString *departCity;                         // 出发城市
@property (nonatomic, strong) NSString *arriveCity;                         // 到达城市
@property (nonatomic, strong) NSString *departDate;                         // 出发日期
@property (nonatomic, strong) NSString *departMonth;                        // 出发日期月
@property (nonatomic, strong) NSString *departWeek;                         // 出发日期周
@property (nonatomic, strong) NSString *departDay;                          // 出发日期天
@property (nonatomic, strong) NSString *flightNumber;                       // 航班号
@property (nonatomic, strong) FStatusDetail *fStatusDetail;                 // 航班详情
@property (nonatomic, assign) FStatusParamType paramType;                   // 查询参数类型
@property (nonatomic, assign) FlightStatusSelectType citySelectType;        // 城市选择类型

@end
