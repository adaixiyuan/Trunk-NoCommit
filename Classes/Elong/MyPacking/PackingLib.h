//
//  PackingLib.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "PackingLibRightCell.h"

@interface PackingLib : DPNav<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ChooseAllItemDelegate>{

    UITableView *_leftTable;
    UITableView *_rightTable;
    NSMutableArray *_dataSource;
    int selected_Index;
    NSMutableDictionary *allChoose_Dic;
    
    NSString *_itemName;
}

@property (nonatomic,retain)    NSMutableArray *dataSource;
@property (nonatomic,retain)     NSString *itemName;

@end
