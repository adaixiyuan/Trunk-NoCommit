//
//  HotelRoomerFilterController.h
//  ElongClient
//
//  Created by Dawn on 14-3-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelRoomerFilterDelegate;

@interface HotelRoomerFilterController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) id<HotelRoomerFilterDelegate>   delegate;
@property (nonatomic, assign) NSInteger number;
@end



@protocol HotelRoomerFilterDelegate <NSObject>

@optional
- (void)hotelRoomerFilterController:(HotelRoomerFilterController *)facilityFilter didSelectNumber:(NSInteger)number;
@end
