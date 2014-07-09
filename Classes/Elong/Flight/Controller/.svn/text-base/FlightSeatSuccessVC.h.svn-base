//
//  FlightSeatSuccessVC.h
//  ElongClient
//
//  Created by bruce on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "FOrderSelectSeat.h"
#import "FOrderSeatInfo.h"

@interface FlightSeatSuccessVC : DPNav <UITableViewDelegate, UITableViewDataSource, HttpUtilDelegate, UIAlertViewDelegate>


@property (nonatomic, strong) UITableView *tableViewParam;

@property (nonatomic, strong) FOrderSelectSeat *fOrderSelectSeat;
@property (nonatomic, strong) NSString *seatNumber;
// 记录订单号
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderCode;                  // 订单码

@property (nonatomic,retain) HttpUtil *getSeatInfoUtil;

@end
