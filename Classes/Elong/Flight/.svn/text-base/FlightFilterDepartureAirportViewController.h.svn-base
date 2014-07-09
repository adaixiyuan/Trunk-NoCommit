//
//  FlightFilterDepartureAirportViewController.h
//  ElongClient
//
//  Created by chenggong on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightCheckboxCell.h"

@protocol FlightFilterDepartureAirportDelegate;

@interface FlightFilterDepartureAirportViewController : UIViewController<UITableViewDataSource,
                                                        UITableViewDelegate,
                                                        FlightCheckboxCellDelegate>

@property (nonatomic , retain) NSMutableArray *departureAirportArray;
@property (nonatomic, retain) NSMutableDictionary *departureAirportTabDictionary;
@property (nonatomic, retain) UITableView *departureAirportTableView;
@property (nonatomic, assign) id<FlightFilterDepartureAirportDelegate> delegate;

- (void)setDepartureAirportIndex:(NSUInteger)index;

@end

@protocol FlightFilterDepartureAirportDelegate <NSObject>

- (void)flightFilterDepartureAirportViewCtrontroller:(FlightFilterDepartureAirportViewController *)controller didSelectIndex:(NSUInteger)index;

@end
