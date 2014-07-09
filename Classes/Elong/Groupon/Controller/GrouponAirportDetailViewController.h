//
//  GrouponAirportDetailViewController.h
//  ElongClient
//
//  Created by Dawn on 13-8-2.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrouponAirportDetailViewControllerDelegate;

@interface GrouponAirportDetailViewController : DPNav<UITableViewDataSource,UITableViewDelegate>{
@private
    id delegate;
}

@property (nonatomic, retain) UITableView *airportList;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, copy)   NSString *item;
@property (nonatomic, copy)   NSString *backTitle;
@property (nonatomic, assign) id<GrouponAirportDetailViewControllerDelegate> delegate;

- (void) reloadData;
@end

@protocol GrouponAirportDetailViewControllerDelegate <NSObject>

@optional
- (void) grouponAirportDetailVC:(GrouponAirportDetailViewController *)grouponAirportDetailVC didSelectedAtIndex:(NSInteger)index;

@end