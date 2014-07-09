//
//  FlightSeatCustomerListVC.h
//  ElongClient
//
//  Created by bruce on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "FOrderSeatInfo.h"
#import "FOrderSeatPassengerPNR.h"

@interface FlightSeatCustomerListVC : DPNav <UITableViewDelegate, UITableViewDataSource, HttpUtilDelegate>


@property (nonatomic, strong) UITableView *tableViewParam;                  //
@property (nonatomic, strong) FOrderSeatInfo *fOrderSeatInfo;               // 选座信息
@property (nonatomic, strong) NSArray *arrayPassengerInfo;                  // 乘客信息
@property (nonatomic, strong) NSArray *arraySelectInfo;                     // 选中信息
@property (nonatomic, strong) NSDateFormatter *oFormat;                     // 时间显示格式
@property (nonatomic,strong) HttpUtil *getSeatMapUtil;
@property (nonatomic,strong) FOrderSeatPassengerPNR *passengerPnrCur;       // 选中的用户
@property (nonatomic,assign) NSInteger selectIndex;

// 记录订单号
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderCode;                  // 订单码

@end
