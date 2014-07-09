//
//  HolelOrderListViewController.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "BaseBottomBar.h"
#import "HotelOrderListSmallCell.h"
#import "HotelOrderListBigCell.h"
#import "HotelOrderListRequest.h"
#import "HotelOrderListCellDelegate.h"
#import "HotelOrderDetailRequest.h"
#import "HotelOrderDetailViewController.h"

@interface HotelOrderListViewController : ElongBaseViewController<BaseBottomBarDelegate,UITableViewDelegate,UITableViewDataSource,HotelOrderListRequestDelegate,UIAlertViewDelegate,HotelOrderListCellDelegate,HotelOrderDetailRequestDelegate>{
    IBOutlet UILabel *_noDataPromptLabel;           //无数据提示信息
    IBOutlet UITableView *_orderListTable;      //订单列表Table
    
    NSMutableArray *_hotelOrdersArray;      //过滤隐藏的订单数据
    NSMutableArray *_originOrdersArray;     //未过滤的订单数据
    int _orderTotalNumber;      //订单总数
    BOOL _isNonMemberFlow;      //是否非会员流程
    int _currentDeletedRow; //记录当前删除的行数
    int _currentSelectedRow;        //记录当前需要访问的行数
    int _currentRowForExecuteBtnRow;       //当前执行的btn所在的行数
    BOOL _isJumpToSafari;       //是否跳到safari
    BOOL _isFromRecommendBookingRequest;    //这个是用于查询推荐酒店时，区别再次预订请求
    BOOL _isLoadingMore;    //加载更多中的标识
    
    AccessTokenRequestType _tokenRequestType;
    HotelOrderListRequest *_orderListRequest;
    HotelOrderDetailRequest *_orderDetailRequest;
}

-(id)initWithHotelOrders:(NSArray *)hotelOrdersArray totalNumber:(int)totalNumber;

@end
