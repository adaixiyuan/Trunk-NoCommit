//
//  PackingCategoryList.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-1-2.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "CategoryListCell.h"
#import "CategoryListBottomBar.h"

@class PackingCategory;
@class PackingModel;
@interface PackingCategoryList : DPNav<UITableViewDataSource,UITableViewDelegate,refreshTheTable,BottomBarDelegate>{

    PackingModel *_packing;
    UITableView *_tableView;
    NSMutableDictionary *isOpen;
    
    //自定义添加的 全部归属自定义Category
     PackingCategory    *_customAdd;
    //从清单库添加的
    NSMutableArray *_lib_Add;//其中包含诸多Categorys 返回本页面需要做合并！
    
    BOOL hide_complete;
    
    BOOL _isFirstIn;
    
}

@property (nonatomic,retain)        NSMutableArray *lib_Add;
@property (nonatomic,assign)    BOOL isFirstIn;


//手动添加Set Get方法
-(void)setPacking:(PackingModel *)packing;
-(PackingModel *)packing;

-(void)setCustomAdd:(PackingCategory *)model;
-(PackingCategory *)customAdd;

-(void)setLib_Add:(NSMutableArray *)lib_Add;
-(NSMutableArray *)lib_Add;

@end
