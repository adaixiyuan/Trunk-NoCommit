//
//  RateList.h
//  ElongClient
//
//  Created by Jian.zhao on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "RateModel.h"

@protocol RateListDelegate <NSObject>

-(void)getTheSelectedRateModel:(RateModel *)model;

@end


@interface RateList : DPNav<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>{
    
    NSArray *_dataSource;               //全部数据源
    NSMutableArray *_sectionArray;//section title
    
    NSMutableArray *_searchResults;//搜索结果
    NSMutableArray *_historyArray;  //历史
    NSMutableArray *_commonArray; //常用
    
    RateModel *_historyModel;
    id<RateListDelegate>_delegate;
    
}
@property (nonatomic,assign) id<RateListDelegate>delegate;
@property (nonatomic,retain) RateModel *historyModel;
@property (nonatomic,retain) NSArray *dataSource;
@property (nonatomic,retain) NSMutableArray *sectionArray;
@property (nonatomic,retain)  NSMutableArray *searchResults;
@property (nonatomic,retain)  NSMutableArray *historyArray;
@property (nonatomic,retain) NSMutableArray *commonArray;

@property (nonatomic, retain) UITableView *defaultTableView;
@property (nonatomic,retain) UISearchDisplayController *displayController;

@end
