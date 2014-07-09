//
//  TrainSearchDetailVC.h
//  ElongClient
//
//  Created by bruce on 13-11-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "TrainTickets.h"
#import "TrainSeats.h"

@protocol TrainDetailDelegate <NSObject>

- (void)seatSelectBack:(TrainSeats *)trainSeat andTrainTickets:(TrainTickets *)trainTickets;
- (void)detailViewDidShow;
- (void)detailViewDidDismiss;

@end

@interface TrainSearchDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource, HttpUtilDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *buttonMask;                   // 遮罩层控制
@property (nonatomic, strong) UIButton *buttonClose;                   // 关闭按钮
@property (nonatomic, strong) UIView *viewContent;                      // 内容视图
@property (nonatomic, strong) UITableView *tableViewDetail;             // 列车详情
@property (nonatomic, strong) UIView *midwayHeader;                    // 列车详情

@property (nonatomic, strong) id <TrainDetailDelegate> delegate;        // 代理
@property (nonatomic, strong) TrainTickets *trainTickets;               // 列车数据
@property (nonatomic, strong) NSArray *arrayMidwayStation;              // 中途车站
@property (nonatomic, strong) NSString *wrapperId;                      // ota代理商
@property (nonatomic, strong) NSNumber *listStatus;                     // 列车列表状态
@property (nonatomic, strong) NSNumber *bookStatus;                     // 预定状态
@property (nonatomic, assign) BOOL isMidwayExpand;                      // 中途车站是否展开
@property (nonatomic, assign) BOOL isSleeperSeat;                       // 是否是卧铺

- (id)initWithTitle:(NSString *)title;

// 在父窗口中显示
- (void)show;

// 消失
- (void)dismiss;

@end
