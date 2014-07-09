//
//  HotelPriceStarFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-15.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRangeSlider.h"

@protocol HotelPriceFilterDelegate;

@interface HotelPriceFilterController : DPNav <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL vip;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, retain) NSArray *priceRangeArray;
@property (nonatomic, assign) id<HotelPriceFilterDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) IBOutlet UIButton *vipButton;
@property (nonatomic, assign) IBOutlet UIView *vipContainer;
@property (nonatomic, assign) BOOL showVipContainer;

- (IBAction)vipCheckStateChanged:(id)sender;

@end

@protocol HotelPriceFilterDelegate <NSObject>

- (void)hotelPriceFilterController:(HotelPriceFilterController *)priceFilter didSelectIndex:(NSUInteger)index;

@optional
- (void)hotelPriceFilterController:(HotelPriceFilterController *)priceFilter vipCheckStateChanged:(BOOL)value;

@end
