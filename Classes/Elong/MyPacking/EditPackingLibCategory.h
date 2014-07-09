//
//  EditPackingLibCategory.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-31.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "EditPackingItem.h"
@interface EditPackingLibCategory : DPNav<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ModifyDelegate>{

    UITableView *_tableView;
    NSMutableArray *_dataSource;
    BOOL edited;
}

@property (nonatomic,retain)  NSMutableArray *dataSource;

@end
