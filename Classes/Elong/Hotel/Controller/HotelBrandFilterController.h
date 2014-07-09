//
//  HotelBrandFilterController.h
//  ElongClient
//
//  Created by 赵岩 on 13-5-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmented.h"
#import "CustomSegmentedDelegate.h"

@protocol HotelBrandFilterDelegate;

@interface HotelBrandFilterController : DPNav <UITableViewDataSource, UITableViewDelegate,CustomSegmentedDelegate>{
@private
    CustomSegmented *brandSeg;
}

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, retain) NSMutableArray *selectedIndexs;
@property (nonatomic, retain) NSArray *brandArray;
@property (nonatomic, retain) NSArray *chainArray;
@property (nonatomic, assign) id<HotelBrandFilterDelegate> delegate;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isChain;

- (void) setNeedChain;

@end

@protocol HotelBrandFilterDelegate <NSObject>

@optional
- (void)hotelBrandFilterController:(HotelBrandFilterController *)brandFilter didSelectIndex:(NSUInteger)index;
- (void)hotelBrandFilterController:(HotelBrandFilterController *)brandFilter didSelectIndexs:(NSArray *)indexs isChain:(BOOL) isChain;
@end
