//
//  TrainSearchTypeViewController.h
//  ElongClient
//
//  Created by chenggong on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "CheckboxCell.h"

typedef enum {
    FilterTypeCRH,              // 动车/高铁
    FilterTypeNormal            // 普通列车
}FilterTypeCategory;

@protocol TrainSearchTypeDelegate;

@interface TrainSearchTypeViewController : DPNav<UITableViewDataSource, UITableViewDelegate, CheckboxCellDelegate>

@property (nonatomic, retain) NSArray *typeArray;
@property (nonatomic, assign) id<TrainSearchTypeDelegate> delegate;
@property (nonatomic, retain) UITableView *typeTableView;
@property (nonatomic, retain) NSMutableDictionary *typeTabDictionary;
//@property (nonatomic, assign) BOOL onlyCRH;

- (void)setTypeIndex:(NSUInteger)index;

@end

@protocol TrainSearchTypeDelegate <NSObject>

- (void)trainSearchTypeViewCtrontroller:(TrainSearchTypeViewController *)controller didSelectIndex:(NSUInteger)index;

@end