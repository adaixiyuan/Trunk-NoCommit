//
//  AirlineInfoModel.h
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface AirlineInfoModel : BaseModel
@property (nonatomic,retain)  NSString  *DepartAirPort;
@property (nonatomic,retain)  NSString  *ArrivalAirPort;
@property (nonatomic,retain)  NSString  *DepartDate;
@property (nonatomic,retain)  NSString  *ArrivalDate;
@property (nonatomic,retain)  NSString  *DepartTerminal;
@property (nonatomic,retain)  NSString  *ArriveTerminal;
@property (nonatomic,retain)  NSString  *FlightNumber;
@property (nonatomic,retain)  NSString  *AirCorpCode;
@property (nonatomic,retain)  NSString  *AirCorpName;
@property (nonatomic,retain)  NSString  *ChangeRegulate;
@property (nonatomic,retain)  NSString  *ReturnRegulate;
@property (nonatomic,retain)  NSString  *SignRule;
@property (nonatomic,retain)  NSString  *Cabin;
@property (nonatomic,retain)  NSString  *CabinCode;
@property (nonatomic,retain)  NSString  *PlaneType;
@property (nonatomic,retain)  NSString  *DepartAirCode;
@property (nonatomic,retain)  NSString  *ArrivalAirCode;

@end
