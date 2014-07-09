//
//  TrainSearchDepartureTimeViewController.h
//  ElongClient
//
//  Created by chenggong on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "CheckboxCell.h"

@protocol TrainSearchDepartureTimeDelegate;

@interface TrainSearchDepartureTimeViewController : DPNav<UITableViewDataSource, UITableViewDelegate, CheckboxCellDelegate>

@property (nonatomic, assign) id<TrainSearchDepartureTimeDelegate> delegate;
@property (nonatomic , retain) NSArray *departureTimeArray;
@property (nonatomic, retain) UITableView *departureTimeTableView;
@property (nonatomic, retain) NSMutableDictionary *departureTimeTabDictionary;

- (void)setDepartureTimeIndex:(NSUInteger)index;

@end

@protocol TrainSearchDepartureTimeDelegate <NSObject>

- (void)trainSearchDepartureTimeViewCtrontroller:(TrainSearchDepartureTimeViewController *)controller didSelectIndex:(NSUInteger)index;

@end
