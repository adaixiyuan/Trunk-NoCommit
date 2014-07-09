//
//  AddPackingList.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"

@interface AddPackingList : DPNav<UITableViewDataSource,UITableViewDelegate>{

    UITableView *_tableView;
    NSMutableArray *_alwaysDataSource;
}

@property (nonatomic,retain)     NSMutableArray *alwaysDataSource;

@end
