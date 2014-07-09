//
//  GrouponSubwayViewController.h
//  ElongClient
//
//  Created by Dawn on 13-8-1.
//  Copyright (c) 2013年 elong. All rights reserved.
// 

#import <UIKit/UIKit.h>

@protocol GrouponSubwayViewControllerDelegate;

@interface GrouponSubwayViewController : DPNav<UITableViewDataSource,UITableViewDelegate>{
@private
    id delegate;
}

@property (nonatomic, retain) UITableView *subwayList;
@property (nonatomic, retain) NSArray *stations;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, copy)   NSString *item;
@property (nonatomic, assign) id<GrouponSubwayViewControllerDelegate> delegate;

- (void) reloadData;

@end

@protocol GrouponSubwayViewControllerDelegate <NSObject>

@optional
- (void) grouponSubwayVC:(GrouponSubwayViewController *)grouponSubwayVC didSelectedAtIndex:(NSInteger)index;

@end
