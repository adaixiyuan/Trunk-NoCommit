//
//  OrderManagement.h
//  ElongClient
//  订单管理主页
//  Created by bin xing on 11-2-21.
//  Copyright 2011 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElongURL.h"
#import "LzssUncompress.h"
#import "JHotelOrderHistory.h"
#import "OrderHistoryPostManager.h"
#import "Utils.h"
#import "FlightOrderHistory.h"

@interface OrderManagement : DPNav<UITableViewDataSource,UITableViewDelegate> {
	int linktype;
	ElongClientAppDelegate *appDelegate;
    
    //New UI Add
    IBOutlet UITableView *_orderTable;
}

@property (nonatomic, retain) NSMutableArray *localOrderArray;
@property (nonatomic, assign) BOOL isFromOrder;			// 是否是从订单成功页面进入

- (void)clickHotelOrder;
- (void)clickFlightOrder;
- (void)clickGrouponOrder;
- (void)clickInterHotelOrder;
- (void)clickTrainOrder;
- (void)clickTaxiOrder;

@end
