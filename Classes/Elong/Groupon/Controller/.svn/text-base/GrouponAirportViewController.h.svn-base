//
//  GrouponAirportViewController.h
//  ElongClient
//
//  Created by Dawn on 13-8-2.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GrouponAirportViewControllerDelegate;

@interface GrouponAirportViewController : DPNav<UITableViewDelegate,UITableViewDataSource>{
@private
    id delegate;
}

@property (nonatomic, retain) UITableView *airportList;
@property (nonatomic, retain) NSArray *airports;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, copy)   NSString *item;
@property (nonatomic, assign) id<GrouponAirportViewControllerDelegate> delegate;

@end

@protocol GrouponAirportViewControllerDelegate <NSObject>

@optional

- (void)grouponAirportVC:(GrouponAirportViewController *)grouponAirportVC didSelectedAtIndex:(NSInteger)index;

@end
