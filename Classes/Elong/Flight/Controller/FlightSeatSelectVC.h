//
//  FlightSeatSelectVC.h
//  ElongClient
//
//  Created by bruce on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "FlightSeatMap.h"
#import "SeatMapView.h"
#import "CustomSegmented.h"
#import "SeatButton.h"
#import "FOrderSeatPassengerPNR.h"

typedef enum FSeatSelectDeckType : NSUInteger
{
    eFSeatSelectDeckFirst = 0,
    eFSeatSelectDeckSecond,
} FSeatSelectDeckType;

@interface FlightSeatSelectVC : DPNav <SeatMapViewDelegate, CustomSegmentedDelegate, HttpUtilDelegate>

@property (nonatomic, strong) UIView *viewTop;                       // 顶部区域
@property (nonatomic, strong) UIView *viewBottom;                    // 底部区域
@property (nonatomic, strong) UIView *seatContent;                   // 座位内容视图
@property (nonatomic, strong) SeatMapView *viewSeatDeckFirst;        // 第一层
@property (nonatomic, strong) SeatMapView *viewSeatDeckSecond;       // 第二层
@property (nonatomic, strong) SeatButton *selectSeat;                // 选择的座位
@property (nonatomic, strong) FOrderSeatPassengerPNR *passengerPNR;  // 用户信息
@property (nonatomic, strong) FlightSeatMap *flightSeatMap;          // 座位数据
@property (nonatomic, strong) NSString *selectSeatNumber;            // 选定的座位号
@property (nonatomic,strong) HttpUtil *seatSubmitUtil;
// 记录订单号
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderCode;                  // 订单码

@end
