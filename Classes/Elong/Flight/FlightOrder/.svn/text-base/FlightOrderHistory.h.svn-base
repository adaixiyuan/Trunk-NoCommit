//
//  FlightOrderHistory.h
//  ElongClient
//  机票订单列表页面
//  Created by WangHaibin on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightOrderHistoryDetail.h"
#import "DPNav.h"
#import "FlightOrderCellViewController.h"
#import "Utils.h"
#import "JGetFlightOrder.h"
#import "ElongURL.h"
#import "OrderHistoryPostManager.h"
#import "FlightOrderHistoryDetailDelegate.h"
typedef enum
{
    SINGLETRIP,
    DOUBLETROIP
}FLIGHTTYPE;


@interface FlightOrderHistory : DPNav <UITableViewDelegate,UITableViewDataSource,CustomSegmentedDelegate,FlightOrderHistoryDetailDelegate> {
	UITableView *listTableView;
	NSMutableArray *TflightOrderArray;
	NSMutableArray *SflightOrderArray;
	NSMutableArray *TicketsOrderArray;
	
	NSMutableArray *m_dataSource;
	NSMutableArray *originOrders;
	
	int orderStatus;
    
    int  orderCount;
	
	UIView *m_allBlogView;
	UIView *m_usedBlogView;
	UIView *m_activeBlogView;
	UIView *m_cancelBlogView;
	
	int postType;
	int m_time;
	
	NSInteger ordersTotal;				// 订单总数
	int currentSelectedRow;
    
    BOOL isShowTopLine;
    int currentFirstRow;
    
    NSMutableArray  *modelAr;
    int  flyType;
}

@property (nonatomic,retain) NSMutableArray *m_dataSource;
@property (nonatomic,retain) UIButton *morebutton;
@property (nonatomic,retain) NSIndexPath *selectedIndexPath;

- (id)initWithLocalOrders:(NSArray *)orders;
- (id)initWithDatas:(NSDictionary *)orderDic;

- (void)addHeadView;

@end
