//
//  FlightFilterAirlineViewController.h
//  ElongClient
//
//  Created by chenggong on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightCheckboxCell.h"

@protocol FlightFilterAirlineDelegate;

@interface FlightFilterAirlineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, FlightCheckboxCellDelegate>

@property (nonatomic, retain) NSMutableArray *airlineArray;
@property (nonatomic, retain) NSMutableDictionary *airlineTabDictionary;
@property (nonatomic, retain) UITableView *airlineTableView;
@property (nonatomic, assign) id<FlightFilterAirlineDelegate> delegate;

- (void)setAirlineIndex:(NSUInteger)index;

@end

@protocol FlightFilterAirlineDelegate <NSObject>

- (void)flightFilterAirlineViewCtrontroller:(FlightFilterAirlineViewController *)controller didSelectIndex:(NSUInteger)index;

@end
