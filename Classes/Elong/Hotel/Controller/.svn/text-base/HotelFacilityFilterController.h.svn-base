//
//  HotelFacilityFilterController.h
//  ElongClient
//
//  Created by Dawn on 14-3-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelFacilityFilterDelegate;

@interface HotelFacilityFilterController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSArray                         *facilityArray;
@property (nonatomic, assign) id<HotelFacilityFilterDelegate >  delegate;
@property (nonatomic, retain)  NSMutableArray                *selectedIndexs;
@end


@protocol HotelFacilityFilterDelegate <NSObject>

@optional
- (void)hotelFacilityFilterController:(HotelFacilityFilterController *)facilityFilter didSelectIndexs:(NSArray *)indexs;
@end
