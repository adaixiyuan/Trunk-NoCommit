//
//  InterHotelLocationFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterHotelLocationFilterDelegate;

@interface InterHotelLocationFilterController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSDictionary *selectedLocation;
@property (nonatomic, retain) NSArray *locationItemList;

@property (nonatomic, assign) id<InterHotelLocationFilterDelegate> delegate;

@end

@protocol InterHotelLocationFilterDelegate <NSObject>

- (void)interHotelLocationFilter:(InterHotelLocationFilterController *)filter didSelectLocation:(NSDictionary *)location;

@end
