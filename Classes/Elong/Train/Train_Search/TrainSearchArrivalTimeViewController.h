//
//  TrainSearchArrivalTimeViewController.h
//  ElongClient
//
//  Created by chenggong on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "CheckboxCell.h"

@protocol TrainSearchArrivalTimeDelegate;

@interface TrainSearchArrivalTimeViewController : DPNav<UITableViewDataSource, UITableViewDelegate, CheckboxCellDelegate>

@property (nonatomic , retain) NSArray *arrivalTimeArray;
@property (nonatomic, assign) id<TrainSearchArrivalTimeDelegate> delegate;
@property (nonatomic, retain) UITableView *arrivalTimeTableView;
@property (nonatomic, retain) NSMutableDictionary *arrivalTimeTabDictionary;

- (void)setArrivalTimeIndex:(NSUInteger)index;

@end

@protocol TrainSearchArrivalTimeDelegate <NSObject>

- (void)trainSearchArrivalTimeViewCtrontroller:(TrainSearchArrivalTimeViewController *)controller didSelectIndex:(NSUInteger)index;

@end
