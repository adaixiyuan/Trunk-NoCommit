//
//  HotelStarFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelStarFilterDelegate;

@interface HotelStarFilterController : DPNav <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, retain) NSArray *starArray;
@property (nonatomic, assign) id<HotelStarFilterDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *selectedIndexs;
@end

@protocol HotelStarFilterDelegate <NSObject>

@optional
- (void)hotelStarFilterController:(HotelStarFilterController *)starFilter didSelectIndex:(NSUInteger)index;
- (void)hotelStarFilterController:(HotelStarFilterController *)starFilter didSelectIndexs:(NSArray *)indexs;
@end
