//
//  GrouponCityChooseViewController.h
//  ElongClient
//
//  Created by haibo on 11-11-3.
//  Copyright 2011 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "AIMTableViewIndexBar.h"

@class GrouponHomeViewController;

@interface GrouponCityChooseViewController : DPNav <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, AIMTableViewIndexBarDelegate> {
@private
	UISearchDisplayController *searchDisplayController;
	
	NSDictionary *localCityDic;					// 酒店本地列表
	NSMutableDictionary *cityIndexDic;			// 城市名与对应数据的索引字典
	
	NSMutableArray *allLocalCities;				// 记录团购中的所有城市名
    NSString *lastcity;
    UITableView *citysTable;
    UIImageView *navBar;
    NSInteger initY;
    NSInteger indexBarWidth;                    // 索引条宽度
    UISearchBar *searchBar;
}

@property (nonatomic, assign) GrouponHomeViewController *root;
@property (nonatomic,retain) AIMTableViewIndexBar *indexBar;

//得到热门城市数据
+(NSArray *) getHotArrays;

@end
