//
//  DebugNetStatisticsViewController.h
//  ElongClient
//
//  Created by Janven on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugNetStatisticsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    UITableView *_tableView;
}

@property (nonatomic,retain) NSMutableArray *dataSource;

@end
