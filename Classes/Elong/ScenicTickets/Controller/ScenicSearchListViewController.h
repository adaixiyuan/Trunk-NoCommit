//
//  ScenicSearchListViewController.h
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "ScenicListSearch.h"
#define ScenicSearchHomePath  @"/search"

@interface ScenicSearchListViewController : ElongBaseViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,HttpUtilDelegate>
{
    UITableView  *tabView;
    NSString  *searchBarText;
    NSMutableArray   *cityModelAr;
    NSMutableArray   *scenicModelAr;
    HttpUtil *searchUrl;
    UISearchBar *homeSearchBar;
    BOOL isInSearch;
    BOOL isZero;
    int  listIsAll;
    int firstPage;
    NSMutableArray  *historyModelAr;
}
@property (nonatomic,retain) ScenicListSearch  *sModel;
@property (nonatomic,retain)NSArray  *modelAr;
@property  (nonatomic,retain) NSArray *textAr;
@end
