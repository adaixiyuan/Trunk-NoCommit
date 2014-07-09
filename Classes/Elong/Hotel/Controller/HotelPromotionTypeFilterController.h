//
//  HotelPromotionTypeFilterController.h
//  ElongClient
//
//  Created by Dawn on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelPromotionTypeFilterDelegate;
@interface HotelPromotionTypeFilterController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSArray                         *promotionTypeArray;
@property (nonatomic, assign) id<HotelPromotionTypeFilterDelegate>   delegate;
@property (nonatomic, retain)  NSMutableArray                 *selectedIndexs;
@end


@protocol HotelPromotionTypeFilterDelegate <NSObject>

@optional
- (void) hotelPromotionTypeFilterController:(HotelPromotionTypeFilterController *)promotionTypeFilter didSelectIndexs:(NSArray *)indexs;
@end

