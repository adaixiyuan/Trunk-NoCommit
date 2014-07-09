//
//  FlightData.m
//  ElongClient
//
//  Created by dengfang on 11-2-11.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "FlightData.h"
#import "FlightDataDefine.h"

static NSMutableArray *flightsArrayGo;
static NSMutableArray *flightsArrayReturn;
static NSMutableDictionary *flightDictionary;
static NSInteger currentIndex;

@implementation FlightData

+ (NSInteger)getCurrentIndex {
    return currentIndex;
}

+ (void)setCurrentIndex:(NSInteger)index {
    currentIndex = index;
}

+ (NSMutableArray *)getFArrayGo {
	if (flightsArrayGo == nil || [flightsArrayGo retainCount] <= 0) {
		flightsArrayGo = [[NSMutableArray alloc] init];
	}
	return flightsArrayGo;
}

+ (NSMutableArray *)getFArrayReturn {
	if (flightsArrayReturn == nil || [flightsArrayReturn retainCount] <= 0) {
		flightsArrayReturn = [[NSMutableArray alloc] init];
	}
	return flightsArrayReturn;
}

+ (NSMutableDictionary *)getFDictionary {
	if (!flightDictionary) {
		flightDictionary = [[NSMutableDictionary alloc] init];
		[flightDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_SELECT_FLIGHT_TYPE];
		[flightDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_CURRENT_FLIGHT_TYPE];
		[flightDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1];
		[flightDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2];
//		[flightDictionary safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_SELECT_CLASS_TYPE];
		[flightDictionary safeSetObject:@"" forKey:KEY_TERMINAL_1];
		[flightDictionary safeSetObject:@"" forKey:KEY_TERMINAL_2];
		[flightDictionary safeSetObject:@"" forKey:KEY_RETURN_REGULATE_1];
        [flightDictionary safeSetObject:@"" forKey:KEY_RETURN_REGULATE_t];
		
		[flightDictionary safeSetObject:@"" forKey:KEY_DEPART_DATE];
		[flightDictionary safeSetObject:@"" forKey:KEY_RETURN_DATE];
		[flightDictionary safeSetObject:@"" forKey:KEY_DEPART_CITY];
		[flightDictionary safeSetObject:@"" forKey:KEY_ARRIVE_CITY];
		[flightDictionary safeSetObject:@"" forKey:KEY_CONTACT_NAME];
		[flightDictionary safeSetObject:@"" forKey:KEY_CONTACT_TEL];
		[flightDictionary safeSetObject:@"" forKey:KEY_PLANE_PIC_URL];
		[flightDictionary safeSetObject:@"" forKey:KEY_PLANE_PIC_NAME];
		[flightDictionary safeSetObject:@"" forKey:KEY_PLANE_PIC_INFO];
		[flightDictionary safeSetObject:@"" forKey:KEY_ADDRESS_CONTENT];
		[flightDictionary safeSetObject:@"" forKey:KEY_NAME];
		[flightDictionary safeSetObject:@"邮寄行程单" forKey:KEY_TICKET_GET_TYPE_MEMO];
		[flightDictionary safeSetObject:[NSNumber numberWithLongLong:0] forKey:KEY_ORDER_NO];
		[flightDictionary safeSetObject:[NSNumber numberWithInt:DEFINE_POST_TYPE_NOT_NEED] forKey:KEY_TICKET_GET_TYPE];
		[flightDictionary safeSetObject:@"" forKey:KEY_ADDRESS_NAME];
        //
        [flightDictionary safeSetObject:[NSNumber numberWithBool:NO] forKey:KEY_IS51BOOK];
        [flightDictionary safeSetObject:[NSNumber numberWithBool:NO] forKey:KEY_ISONEHOUR];
        [flightDictionary safeSetObject:@"" forKey:KEY_INVOICETITLE];
		
		//KEY_PASSENGER_LIST
		NSMutableArray *array = [[NSMutableArray alloc] init];
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict safeSetObject:@"" forKey:KEY_NAME];
		[dict safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_CERTIFICATE_TYPE];
		[dict safeSetObject:@"" forKey:KEY_CERTIFICATE_NUMBER];
		[array addObject:dict];
		[flightDictionary safeSetObject:array forKey:KEY_PASSENGER_LIST];
		[array release];
		[dict release];

        // KEY_INSURANCE_ORDERS
        NSMutableArray *insuranceOrderArray = [[NSMutableArray alloc] init];
        NSMutableDictionary *insuranceInfoDictionary = [[NSMutableDictionary alloc] init];
        // Insurance holder.
		dict = [[NSMutableDictionary alloc] init];
		[dict safeSetObject:@"" forKey:KEY_INSURANCE_NAME];
        [dict safeSetObject:@"" forKey:KEY_INSURANCE_NAMEEN];
		[dict safeSetObject:[NSNumber numberWithInt:0] forKey:KEY_CERTIFICATE_TYPE];
		[dict safeSetObject:@"" forKey:KEY_CERTIFICATE_NUMBER];
        [dict safeSetObject:@"0" forKey:KEY_INSURANCE_SEX];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:-18];
        NSDate *eighteenYearDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dateFormatter stringFromDate:eighteenYearDate];
        [dateFormatter release];
        NSString *datestring=[TimeUtils makeJsonDateWithDisplayNSStringFormatter:date formatter:@"yyyy-MM-dd"];
        [dict safeSetObject:datestring forKey:KEY_INSURANCE_BIRTHDAY];
        [dict safeSetObject:@"0" forKey:KEY_PASSENGER_TYPE];
		[insuranceInfoDictionary safeSetObject:dict forKey:KEY_INSURANCE_HOLDER];
        [dict release];
        // Insurance product.
        NSMutableDictionary *productDict = [[NSMutableDictionary alloc] init];
        [productDict safeSetObject:@"0" forKey:KEY_INSURANCE_NAME];
        [productDict safeSetObject:@"0.0" forKey:KEY_INSURANCE_BASEPRICE];
        [productDict safeSetObject:@"0.0" forKey:KEY_INSURANCE_SALEPRICE];
        [insuranceInfoDictionary safeSetObject:productDict forKey:KEY_INSURANCE_PRODUCT];
        [productDict release];
        // Insurance number.
        [insuranceInfoDictionary safeSetObject:@"0" forKey:KEY_INSURANCE_NUMBER];
        // Insurance EffectiveTime.
        [insuranceInfoDictionary safeSetObject:datestring forKey:KEY_INSURANCE_EFFECTIVETIME];
        
        [insuranceOrderArray addObject:insuranceInfoDictionary];
		[flightDictionary safeSetObject:insuranceOrderArray forKey:KEY_INSURANCE_ORDERS];
        [insuranceInfoDictionary release];
		[insuranceOrderArray release];
        [gregorian release];
        [comps release];
	}
	return flightDictionary;
}
@end