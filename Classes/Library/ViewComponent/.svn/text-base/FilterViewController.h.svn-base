//
//  FilterViewController.h
//  ElongClient
//
//  Created by Dawn on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterSidebarItem.h"

@protocol FilterViewControllerDelegate;
@interface FilterViewController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)  NSMutableArray                *sidebarItems;
@property (nonatomic,assign)  id<FilterViewControllerDelegate >  delegate;
@property (nonatomic,assign)  FilterSidebarItemType             selectedItemType;
@property (nonatomic, retain) NSString                         *cityName;
@property (nonatomic,readonly) UIView *tabContentView;

- (void) removeSidebarItem:(FilterSidebarItemType)itemType;
- (void) addTipsItem:(NSString *)title withTag:(NSInteger)tag;
- (void) addTipsItem:(NSString *)title withTag:(NSInteger)tag animated:(BOOL)animated;
- (void) updateTipsItem:(NSString *)title withTag:(NSUInteger)tag;
- (BOOL) haveSidebarItem:(FilterSidebarItemType)itemType;
- (void) removeTipsItem:(NSUInteger)tag animated:(BOOL)animated;
- (UIButton *)tipsItemWithTag:(NSInteger)tag;
- (void) actionBtnClick:(id)sender;
- (void) resetBtnClick:(id)sender;
- (void) tipsItemBtnClick:(id)sender;
@end


@protocol FilterViewControllerDelegate <NSObject>

@optional
- (void) filterViewController:(FilterViewController *)filterViewController didSelectedArIndex:(NSInteger)index;
- (void) filterViewControllerDidAction:(FilterViewController *)filterViewController withInfo:(NSDictionary *)info;
- (void) filterViewControllerDidReset:(FilterViewController *)filterViewController;
- (void) filterViewControllerDidCancel:(FilterViewController *)filterViewController;
@end