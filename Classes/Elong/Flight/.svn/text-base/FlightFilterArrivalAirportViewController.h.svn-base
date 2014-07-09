//
//  FlightFilterArrivalAirportViewController.h
//  ElongClient
//
//  Created by chenggong on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightCheckboxCell.h"

@protocol FlightFilterArrivalAirportDelegate;

@interface FlightFilterArrivalAirportViewController : UIViewController<UITableViewDataSource,
                                                                       UITableViewDelegate,
                                                                       FlightCheckboxCellDelegate>

@property (nonatomic , retain) NSMutableArray *arrivalAirportArray;
@property (nonatomic, retain) NSMutableDictionary *arrivalAirportTabDictionary;
@property (nonatomic, retain) UITableView *arrivalAirportTableView;
@property (nonatomic, assign) id<FlightFilterArrivalAirportDelegate> delegate;

- (void)setArrivalAirportIndex:(NSUInteger)index;

@end

@protocol FlightFilterArrivalAirportDelegate <NSObject>

- (void)flightFilterArrivalAirportViewCtrontroller:(FlightFilterArrivalAirportViewController *)controller didSelectIndex:(NSUInteger)index;

@end
