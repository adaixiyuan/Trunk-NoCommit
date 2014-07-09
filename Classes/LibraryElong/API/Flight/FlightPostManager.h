//
//  FlightPostManager.h
//  ElongClient
//
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFlightSearch.h"
#import "JFlightRestriction.h"
#import "JFlightTerminal.h"
#import "JFlightPlaneTypeInfo.h"
#import "JFlightOrder.h"
#import "JFlightOnlineSearch.h"
@interface FlightPostManager : NSObject {
	
}

+ (JFlightOnlineSearch *)flightonlineSearcher;
+ (JFlightSearch *)flightSearcher;
+ (JFlightRestriction *)flightRestriction;
+ (JFlightTerminal *)flightTerminal;
+ (JFlightPlaneTypeInfo *)flightPlaneTypeInfo;
+ (JFlightOrder *)flightOrder;
@end
