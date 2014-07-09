//
//  ScenicOrderListVC.h
//  ElongClient
//
//  Created by bruce on 14-5-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"

@interface ScenicOrderListVC : ElongBaseViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableViewList;            // 订单List
@property (nonatomic, strong) UIView *viewBottom;                    // 底部区域

//
@property (nonatomic, strong) NSArray *scenicOrdersArray;            // 订单列表数据

@end
