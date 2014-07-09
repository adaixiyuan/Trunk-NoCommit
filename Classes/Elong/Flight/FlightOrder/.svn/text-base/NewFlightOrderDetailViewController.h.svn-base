//
//  NewFlightOrderDetailViewController.h
//  ElongClient
//  机票订单详情重构页面
//  Created by Janven on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "FlightOrderDetail.h"
#import "FlightOrderDetailCell.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "BaseBottomBar.h"
#import "FOrderSeatInfo.h"

@interface NewFlightOrderDetailViewController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,OrderDetailCellDelegate,EKEventEditViewDelegate,UINavigationControllerDelegate,BaseBottomBarDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSString *orderStatus;//订单状态
    BaseBottomBar *bottomBar;
    
    //增加保存到相册
    UIImageView *m_imgview;
    UIImage *captureimage;
    
    NSString *netType;//网络请求
    NSString *payType;//用户选择的支付方式
    
    BOOL jumpToSafari;
    
    BOOL _isAllowRefundlc;  //yes 可以在线退票 by lc
    BOOL _passengerCount; //乘车人数;
    
}
@property (nonatomic,retain) FlightOrderDetail *orderDetail;
@property (nonatomic,retain) NSArray *passengersTickets;
@property (nonatomic,assign) int flyType;   //0是单程，1是往返
@property (nonatomic,retain) HttpUtil *getSeatInfoUtil;
@property (nonatomic,assign) BOOL isSeatInfoLoad;
@property (nonatomic,retain) NSString *seatInfoResultDesc;  // 选座信息请求结果状态描述
@property (nonatomic,assign) BOOL seatCanSelect;            // 是否可以选座
@property (nonatomic,retain) FOrderSeatInfo *fOrderSeatInfo;
@property (nonatomic, strong) NSArray *arrayPassengerSeatInfo;                  // 乘客选座信息

@property(nonatomic,assign)int needHidenrow;  //要隐藏的第几个cell退票
@property(nonatomic,assign)int needHidentag; //当前cell的第几个退票

@end
