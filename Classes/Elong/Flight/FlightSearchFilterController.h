//
//  FlightSearchFilterController.h
//  ElongClient
//
//  Created by chenggong on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SearchFilterController.h"
#import "FlightFilterAirlineViewController.h"
#import "FlightFilterDepartureAirportViewController.h"
#import "FlightFilterArrivalAirportViewController.h"

#define kFilterAirline            1000
#define kFilterDepartureAirport   (kFilterAirline * 10)
#define kFilterArrivalAirport     (kFilterAirline * 100)

typedef enum {
    FilterAirline,             // 航空公司过滤
    FilterDepartureAirport,    // 起飞机场过滤
    FilterArrivalAirport,      // 到达机场过滤
    FilterTypeCount
}FilterTypes;

@interface FlightSearchFilterController : SearchFilterController<FlightFilterAirlineDelegate,
                                                                 FlightFilterDepartureAirportDelegate,
                                                                 FlightFilterArrivalAirportDelegate>

- (id)initWithAirlineArray:(NSMutableArray*)airlineArray departureAirportArray:(NSMutableArray*)departureAirportArray arrivalAirportArray:(NSMutableArray*)arrivalAirportArray;

- (void)reset;

@end
