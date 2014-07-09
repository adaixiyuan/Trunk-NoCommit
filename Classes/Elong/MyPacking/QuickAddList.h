//
//  QuickAddList.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"

@interface QuickAddList : DPNav<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{

    UITableView *_tableView;
    NSMutableArray *_dataSource;
    //
    UIBarButtonItem *disenableItem;
    UIBarButtonItem *enableItem;
}

@property (nonatomic,retain)   NSMutableArray *dataSource;


@end
