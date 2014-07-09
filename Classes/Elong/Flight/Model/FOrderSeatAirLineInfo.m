//
//  FOrderSeatAirLineInfo.m
//  ElongClient
//
//  Created by bruce on 14-3-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FOrderSeatAirLineInfo.h"

@implementation FOrderSeatAirLineInfo

// 解析结果数据
- (void)parseSearchResult:(NSDictionary *)dictionaryResultJson
{
    _departAirPort = [dictionaryResultJson safeObjectForKey:@"DepartAirPort"];
    
    _arrivalAirPort = [dictionaryResultJson safeObjectForKey:@"ArrivalAirPort"];
    
    _departDate = [dictionaryResultJson safeObjectForKey:@"DepartDate"];
    
    _arrivalDate = [dictionaryResultJson safeObjectForKey:@"ArrivalDate"];
    
    _departTerminal = [dictionaryResultJson safeObjectForKey:@"DepartTerminal"];
    
    _arriveTerminal = [dictionaryResultJson safeObjectForKey:@"ArriveTerminal"];
    
    _flightNumber = [dictionaryResultJson safeObjectForKey:@"FlightNumber"];
    
    _airCorpCode = [dictionaryResultJson safeObjectForKey:@"AirCorpCode"];
    
    _airCorpName = [dictionaryResultJson safeObjectForKey:@"AirCorpName"];
    
    _changeRegulate = [dictionaryResultJson safeObjectForKey:@"ChangeRegulate"];
    
    _returnRegulate = [dictionaryResultJson safeObjectForKey:@"ReturnRegulate"];
    
    _signRule = [dictionaryResultJson safeObjectForKey:@"SignRule"];
    
    _cabin = [dictionaryResultJson safeObjectForKey:@"Cabin"];
    
    _cabinCode = [dictionaryResultJson safeObjectForKey:@"CabinCode"];
    
    _planeType = [dictionaryResultJson safeObjectForKey:@"PlaneType"];
    
    _departAirCode = [dictionaryResultJson safeObjectForKey:@"DepartAirCode"];
    
    _arrivalAirCode = [dictionaryResultJson safeObjectForKey:@"ArrivalAirCode"];
}

@end
