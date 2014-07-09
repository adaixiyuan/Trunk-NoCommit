//
//  FlightPostManager.m
//  ElongClient
//
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightPostManager.h"

static JFlightSearch *flightSearcher = nil;
static JFlightRestriction *flightRestriction = nil;
static JFlightTerminal *flightTerminal = nil;
static JFlightPlaneTypeInfo *flightPlaneTypeInfo = nil;
static JFlightOrder *flightOrder = nil;
static JFlightOnlineSearch *flightonlineSearcher = nil;
@implementation FlightPostManager

+ (JFlightOnlineSearch *)flightonlineSearcher {
	@synchronized(self) {
		if (!flightSearcher) {
			flightonlineSearcher = [[JFlightOnlineSearch alloc] init];
		}
	}
	return flightonlineSearcher;
}


+ (JFlightSearch *)flightSearcher {
	@synchronized(self) {
		if (!flightSearcher) {
			flightSearcher = [[JFlightSearch alloc] init];
		}
	}
	return flightSearcher;
}

//退改签规定
+ (JFlightRestriction *)flightRestriction {
	@synchronized(self) {
		if (!flightRestriction) {
			flightRestriction = [[JFlightRestriction alloc] init];
		}
	}
	return flightRestriction;
}

//航站楼信息
+ (JFlightTerminal *)flightTerminal {
	@synchronized(self) {
		if (!flightTerminal) {
			flightTerminal = [[JFlightTerminal alloc] init];
		}
	}
	return flightTerminal;
}

//机型介绍
+ (JFlightPlaneTypeInfo *)flightPlaneTypeInfo {
	@synchronized(self) {
		if (!flightPlaneTypeInfo) {
			flightPlaneTypeInfo = [[JFlightPlaneTypeInfo alloc] init];
		}
	}
	return flightPlaneTypeInfo;
}

//订单提交
+ (JFlightOrder *)flightOrder {
	@synchronized(self) {
		if (!flightOrder) {
			flightOrder = [[JFlightOrder alloc] init];
		}
	}
	return flightOrder;
}
@end
