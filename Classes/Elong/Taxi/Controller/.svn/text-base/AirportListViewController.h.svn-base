//
//  AirportListViewController.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "RentCity.h"

@protocol SelectCustomAirportDelegate <NSObject>

-(void)getTheSelectedCustomAirport:(CustomAirportTerminal *)model;

@end

@interface AirportListViewController : ElongBaseViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray *_sectionArray;//Title
    NSMutableArray *_searchResults;//搜索结果
    NSMutableArray *_historyArray;  //历史
    
    id<SelectCustomAirportDelegate>_delegate;
}
@property (nonatomic,assign)    id<SelectCustomAirportDelegate>delegate;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,retain) NSMutableArray *sectionArray;
@property (nonatomic,retain)  NSMutableArray *searchResults;
@property (nonatomic,retain)  NSMutableArray *historyArray;

@property (nonatomic, retain) UITableView *defaultTableView;
@property (nonatomic,retain) UISearchDisplayController *displayController;
@end
