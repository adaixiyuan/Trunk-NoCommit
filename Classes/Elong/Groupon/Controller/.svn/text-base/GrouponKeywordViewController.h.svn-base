//
//  GrouponKeywordViewController.h
//  ElongClient
//
//  Created by Dawn on 13-6-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBarView.h"
@protocol GrouponKeywordViewControllerDelegate;
@interface GrouponKeywordViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>{
@private
    SearchBarView *searchBar;
    UITableView *searchList;
    BOOL suggestHasUpdated;
    BOOL searchBarIsShow;
    id delegate;
}
@property (nonatomic,readonly) UISearchBar *searchBar;
@property (nonatomic,copy) NSString *searchcontent;
@property (nonatomic,assign) UIViewController *viewController;
@property (nonatomic,assign) id<GrouponKeywordViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *searchCity;
@property (nonatomic,assign) BOOL withNavHidden;
@property (nonatomic,readonly) UITableView *searchList;
@property (nonatomic,readonly) BOOL searchBarIsShow;
@property (nonatomic,copy) NSString *m_key;

- (id) initWithSearchCity:(NSString *)city contentsController:(UIViewController *)vc;
- (void)cancelSearchCondition;
@end

@protocol GrouponKeywordViewControllerDelegate <NSObject>
@optional
- (void) grouponKeywordVC:(GrouponKeywordViewController *)grouponKeywordVC didGetKeyword:(NSString *)keyword hitType:(int)hitType;
- (void) grouponKeywordVC:(GrouponKeywordViewController *)grouponKeywordVC cancelWithContent:(NSString *)content;
- (void) grouponKeywordVCDidBeginEdit:(GrouponKeywordViewController *)grouponKeywordVC;

@end