//
//  AirportListVC.h
//  ElongClient
//  叫车机场列表
//  Created by Jian.Zhao on 14-2-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"

@protocol SelectedAirportDelegate <NSObject>

-(void)getTheSelectedAirport:(NSString *)airport Location:(NSString *)location;

@end


@interface AirportListVC : ElongBaseViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>{

    NSMutableArray *dataSource;
    
    NSMutableArray *_sectionArray;//Title
    NSMutableArray *_searchResults;//搜索结果
    NSMutableArray *_historyArray;  //历史
    
    HttpUtil *airportHttp;
    
    id<SelectedAirportDelegate>_delegate;
    
    NSString *_selectedAirport;
}
@property (nonatomic,assign)     id<SelectedAirportDelegate>delegate;
@property (nonatomic,copy)     NSString *selectedAirport;


@property (nonatomic,retain) NSMutableArray *sectionArray;
@property (nonatomic,retain)  NSMutableArray *searchResults;
@property (nonatomic,retain)  NSMutableArray *historyArray;

@property (nonatomic, retain) UITableView *defaultTableView;
@property (nonatomic,retain) UISearchDisplayController *displayController;

@end
