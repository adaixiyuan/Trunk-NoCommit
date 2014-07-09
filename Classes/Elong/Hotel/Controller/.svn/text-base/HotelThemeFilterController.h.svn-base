//
//  HotelThemeFilterController.h
//  ElongClient
//
//  Created by Dawn on 14-3-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotelThemeFilterDelegate;

@interface HotelThemeFilterController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, retain) NSArray                         *themeArray;
@property (nonatomic, assign) id<HotelThemeFilterDelegate>   delegate;
@property (nonatomic, retain)  NSMutableArray                *selectedIndexs;
@end


@protocol HotelThemeFilterDelegate <NSObject>

@optional
- (void)hotelThemeFilterController:(HotelThemeFilterController *)facilityFilter didSelectIndexs:(NSArray *)indexs;
@end
