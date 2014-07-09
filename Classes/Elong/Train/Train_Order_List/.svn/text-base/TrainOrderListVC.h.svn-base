//
//  TrainOrderListVC.h
//  ElongClient
//  火车票订单列表页
//
//  Created by 赵 海波 on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainOrderListCell.h"
#import "TrainConfig.h"
#import "TrainOrderDetailViewController.h"
#import "BaseBottomBar.h"

@interface TrainOrderListVC : DPNav <UITableViewDataSource, UITableViewDelegate, TrainOrderDetailDelegate,BaseBottomBarDelegate>
{
    int currentType;						// 当前得订单类型
    
    NSString *payType;
	NSString *visitType;
}

@property (nonatomic, assign) NSUInteger currentRowIndex;
@property (nonatomic, retain) UITableView *listTable;                 // 订单列表

- (id)initWithArray:(NSArray *)array;

@end
