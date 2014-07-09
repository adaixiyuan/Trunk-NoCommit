//
//  HotelPayTypeFilterController.h
//  ElongClient
//
//  Created by Dawn on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelPayTypeFilterDelegate;
@interface HotelPayTypeFilterController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSArray                         *payTypeArray;
@property (nonatomic, assign) id<HotelPayTypeFilterDelegate>   delegate;
@property (nonatomic, retain)  NSMutableArray                 *selectedIndexs;
@end


@protocol HotelPayTypeFilterDelegate <NSObject>

@optional
- (void) hotelPayTypeFilterController:(HotelPayTypeFilterController *)payTypeFilter didSelectIndexs:(NSArray *)indexs;
@end

