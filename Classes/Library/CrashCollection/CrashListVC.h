//
//  CrashListVC.h
//  ElongClient
//
//  Created by bruce on 14-3-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"

@interface CrashListVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableViewList;              // CrashInfo列表
@property (nonatomic, strong) NSArray *arrayCrashInfo;                 // CrashInfo数组

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end
