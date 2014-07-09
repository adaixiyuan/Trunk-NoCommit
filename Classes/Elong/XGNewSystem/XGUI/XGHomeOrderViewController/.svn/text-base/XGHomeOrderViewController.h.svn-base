//
//  XGHomeOrderViewController.h
//  ElongClient
//
//  Created by 李程 on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
@class HotelOrderListRequest;
@class HotelOrderDetailRequest;
@interface XGHomeOrderViewController : XGBaseViewController
{
    HttpUtil *http;
}

@property(nonatomic,strong) NSMutableArray *hotelOrdersArray; //过滤隐藏的订单数据
@property(nonatomic,strong) NSMutableArray *originOrdersArray; //未过滤的订单数据
@property(nonatomic,assign) int orderTotalNumber;//订单总数
@property(nonatomic,assign) int isNonMemberFlow; //是否非会员流程
@property(nonatomic,assign) BOOL isLoadingMore; //加载更多中的标识
@property(nonatomic,assign) int currentRowForExecuteBtnRow;//当前执行的btn所在的行数
@property(nonatomic,strong) HotelOrderListRequest *orderListRequest;
@property(nonatomic,strong) HotelOrderDetailRequest * orderDetailRequest;
@property(nonatomic,strong) UILabel *noDataPromptLabel;           //无数据提示信息
//-(id)initWithHotelOrders:(NSArray *)hotelOrdersArray totalNumber:(int)totalNumber;
-(id)initWithHotelOrders:(NSArray *)hotelOrdersArray originArrayCount:(int)originArrayCount totalNumber:(int)totalNumber;
@end
