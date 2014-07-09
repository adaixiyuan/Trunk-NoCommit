//
//  GrouponDistrictViewController.h
//  ElongClient
//
//  Created by Dawn on 13-8-1.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrouponDistrictViewControllerDelegate;

@interface GrouponDistrictViewController : DPNav<UITableViewDataSource,UITableViewDelegate>{
@private
    id delegate;
}

@property (nonatomic, retain) UITableView *distictList;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, copy)   NSString *item;
@property (nonatomic, assign) id<GrouponDistrictViewControllerDelegate> delegate;
@property (nonatomic, assign) NSUInteger type;

- (void) reloadData;

@end

@protocol GrouponDistrictViewControllerDelegate <NSObject>

@optional

- (void) grouponDistrictVC:(GrouponDistrictViewController *)grouponDistrictVC didSelectedAtIndex:(NSInteger)index;

@end