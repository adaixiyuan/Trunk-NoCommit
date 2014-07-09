//
//  HotelKeywordViewController.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHotelKeywordFilter.h"

@protocol HotelKeywordViewControllerDelegate;

@interface HotelKeywordViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
@private
    UISearchBar *searchBar;
    BOOL suggestHasUpdated;
    id delegate;
    UITableView *searchList;
    BOOL searchBarIsShow;
    BOOL isInterHotel;          // 标记是否是国际酒店
}

@property (nonatomic,readonly) UISearchBar *searchBar;
@property (nonatomic,assign) UIViewController *viewController;
@property (nonatomic,assign) id<HotelKeywordViewControllerDelegate> delegate;
@property (nonatomic,copy) NSString *searchCity;
@property (nonatomic,assign) BOOL withNavHidden;
@property (nonatomic,readonly) UITableView *searchList;
@property (nonatomic,readonly) BOOL searchBarIsShow;
@property (nonatomic,assign) BOOL iflyIsShow;
@property (nonatomic,assign) BOOL independent;          // 是否独立与酒店逻辑
@property (nonatomic,retain) JHotelKeywordFilter *keywordFilter;
@property (nonatomic,assign) BOOL nearbyIsShow;

- (id) initWithSearchCity:(NSString *)city contentsController:(UIViewController *)vc;
- (void)cancelSearchCondition;

@end

@protocol HotelKeywordViewControllerDelegate <NSObject>

@optional

- (void) hotelKeywordVC:(HotelKeywordViewController *)hotelKeywordVC didGetKeyword:(NSString *)keyword;
- (void) hotelKeywordVC:(HotelKeywordViewController *)hotelKeywordVC cancelWithContent:(NSString *)content;
- (void) hotelKeywordVCDidBeginEdit:(HotelKeywordViewController *)hotelKeywordVC;
- (void) hotelKeywordVCDidBeginListen:(HotelKeywordViewController *)hotelKeywordVC;
- (void) hotelKeywordVCSearchNearby:(HotelKeywordViewController *)hotelKeywordVC;
@end