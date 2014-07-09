//
//  HotelOrderDetailViewController.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "BaseBottomBar.h"
#import "HotelOrderDetailRequest.h"
#import "HotelOrderDetailDataSource.h"
#import "HotelOrderDetailCell.h"
#import "HotelOrderListRequest.h"
#import "ForecastViewController.h"

typedef enum {
    FEEDBACK,       //入住反馈获取Token
    MODIFTYORDER    //修改订单获取Token
}AccessTokenRequestType;

@interface HotelOrderDetailViewController : ElongBaseViewController<BaseBottomBarDelegate,UIActionSheetDelegate,HotelOrderDetailRequestDelegate,HotelOrderListRequestDelegate,HotelOrderDetailCellDelegate,UIAlertViewDelegate,PKAddPassesViewControllerDelegate, ForecastDelegate, UIGestureRecognizerDelegate>{
    IBOutlet UITableView *_detailTable;     //详情Table
    NSArray *_detailArray;      //订单详情页要显示数据
    NSDictionary *_currentOrder;        //当前的订单数据
    BOOL _isJumpToSafari;       //是否跳到safari
    PKPass *_pkPass;        //passbook
    NSMutableArray *_currentOrderFlows;
    
    UIButton *_feedbackBtn;     //入住反馈状态
    UIButton *_lookOrderFlowBtn;        //查看订单流程状态
    
    HotelOrderListRequest *_orderListRequest;
    HotelOrderDetailRequest *_orderDetailRequest;
    AccessTokenRequestType _tokenRequestType;
    HotelOrderDetailDataSource *_dataSource;
}

-(id)initWithHotelOrder:(NSDictionary *)order;
@end
