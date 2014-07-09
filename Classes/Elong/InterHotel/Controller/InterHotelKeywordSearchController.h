//
//  InterHotelKeywordSearchController.h
//  ElongClient
//
//  Created by 赵岩 on 13-7-9.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterHotelKeywordSearchDelegate;

@interface InterHotelKeywordSearchController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, assign) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) IBOutlet UITableView *tableView;

@property (nonatomic, assign) id<InterHotelKeywordSearchDelegate> delegate;

@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *keyword;

@property (nonatomic, retain) NSArray *historyList;
@property (nonatomic, retain) NSArray *keywordList;

@end

@protocol InterHotelKeywordSearchDelegate <NSObject>

- (void)interHotelKeywordSearchController:(InterHotelKeywordSearchController *)controller searchWithKeyword:(NSString *)keyword;

- (void)interHotelKeywordSearchControllerDidCanceled:(InterHotelKeywordSearchController *)controller;

@end
