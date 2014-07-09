//
//  EditPackingItem.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"

@class PackingCategory;

@protocol ModifyDelegate <NSObject>

-(void)saveTheModifyCategory:(PackingCategory *)model;

@end

@interface EditPackingItem : DPNav<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{

    PackingCategory *_category;
    UITableView *_tableView;
    
    id<ModifyDelegate>_delegate;
    
    BOOL edited;
}
@property (nonatomic,assign)    id<ModifyDelegate>delegate;

@property (nonatomic,retain)    PackingCategory *category;


@end
