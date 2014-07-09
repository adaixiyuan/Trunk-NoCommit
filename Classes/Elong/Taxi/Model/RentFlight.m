//
//  RentFlight.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentFlight.h"

@implementation RentFlight

-(id)init{

    if (self = [super init]) {
        self.flight = @"";
        self.src = @"";
        self.dest = @"";
        self.arriveTime = @"";
        self.departTime = @"";
        self.srcterm = @"";
        self.destterm = @"";
        self.planetype = @"";
        self.flytime = @"";
        self.meal = @"";
        self.distance = @"";
        self.srcName = @"";
        self.destName = @"";
        self.srcCity = @"";
        self.destCity = @"";
        self.airlineName = @"";
        self.airlineSimpleName = @"";
        self.srcLat = @"";
        self.srcLng = @"";
        self.destLat = @"";
        self.destLng = @"";
        self.destCityCode = @"";
        self.srcCityCode = @"";
    }
    return self;
}

-(void)dealloc{
    self.flight = nil;
    self.src = nil;
    self.dest = nil;
    self.arriveTime = nil;
    self.departTime = nil;
    self.srcterm = nil;
    self.destterm = nil;
    self.planetype = nil;
    self.flytime = nil;
    self.meal = nil;
    self.distance = nil;
    self.srcName = nil;
    self.destName = nil;
    self.srcCity = nil;
    self.destCity = nil;
    self.airlineName = nil;
    self.airlineSimpleName = nil;
    self.srcLat = nil;
    self.srcLng = nil;
    self.destLat = nil;
    self.destLng = nil;
    self.destCityCode = nil;
    self.srcCityCode = nil;
    [super dealloc];
}

@end
