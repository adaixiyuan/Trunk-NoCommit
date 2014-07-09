//
//  FlightOrderDetail.m
//  ElongClient
//
//  Created by Janven on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FlightOrderDetail.h"

@implementation TicketInfo
-(id)init{
    if (self = [super init]) {
        self.TicketChannel = @"";
        self.TicketId = @"";
        self.TicketNo = @"";
        self.TicketStatusName = @"";
        self.PnrNo = @"";
        NSArray *array = [[NSArray alloc] init];
        self.AirLineInfos = array;
        [array release];
        TiketPriceInfo *info = [[TiketPriceInfo alloc] init];
        self.TiketFeeInfo = info;
        [info release];
    }
    return self;
}

-(void)dealloc{
    self.TiketFeeInfo = nil;
    self.TicketStatusName = nil;
    self.TicketId = nil;
    self.TicketNo = nil;
    self.TicketStatusName = nil;
    self.PnrNo = nil;
    self.AirLineInfos = nil;
    [super dealloc];
}
@end

@implementation AirLineInfo

-(id)init{

    if (self = [super init]) {
        self.DepartAirCode = @"";
        self.DepartAirPort = @"";
        self.DepartDate = @"";
        self.DepartTerminal = @"";
        self.ArrivalAirCode = @"";
        self.ArrivalAirPort = @"";
        self.ArrivalDate = @"";
        self.ArriveTerminal = @"";
        self.AirCorpCode = @"";
        self.AirCorpName = @"";
        self.FlightNumber = @"";
        self.ChangeRegulate = @"";
        self.ReturnRegulate = @"";
        self.SignRule = @"";
        self.Cabin = @"";
        self.CabinCode = @"";
        self.PlaneType = @"";
    }
    return self;
}

-(void)dealloc{

    self.DepartAirCode = nil;
    self.DepartAirPort = nil;
    self.DepartDate = nil;
    self.DepartTerminal = nil;
    self.ArrivalAirCode = nil;
    self.ArrivalAirPort = nil;
    self.ArrivalDate = nil;
    self.ArriveTerminal = nil;
    self.AirCorpCode = nil;
    self.AirCorpName = nil;
    self.FlightNumber = nil;
    self.ChangeRegulate = nil;
    self.ReturnRegulate = nil;
    self.SignRule = nil;
    self.Cabin = nil;
    self.CabinCode = nil;
    self.PlaneType = nil;
    
    [super dealloc];
}
@end

@implementation TiketPriceInfo

-(id)init{

    if (self = [super init]) {
        self.TicketPrice = @"";
        self.TicketTax = @"";
    }
    return self;
}

-(void)dealloc{
    self.TicketPrice = nil;
    self.TicketTax = nil;
    [super dealloc];
}

@end

@implementation InsuranceInfo

-(id)init{

    if (self = [super init]) {
        NSArray *array = [[NSArray alloc] init];
        self.InsuranceDetail = array;
        [array release];
    }
    return self;
}

-(void)dealloc{
    self.InsurancePrice = nil;
    self.InsuranceDetail = nil;
    [super dealloc];
}
@end

@implementation PriceInfo

-(void)dealloc{
    [super dealloc];
}

@end

@implementation PassengerInfo

-(void)dealloc{
    self.Name = nil;
    self.CertificateNumber = nil;
    self.CertificateType = nil;
    self.Birthday = nil;
    self.PassengerType = nil;
    [super dealloc];
}

@end

@implementation InsuranceDetail

-(void)dealloc{
    self.TravelerName = nil;
    self.CertificateType = nil;
    self.CertificateType = nil;
    self.InsuranceName = nil;
    self.InsuranceSalePrice = nil;
    self.EffectiveTime = nil;
    self.StatusName = nil;
    [super dealloc];
}

@end

@implementation FlightOrderDetail

-(id)init{

    if (self = [super init]) {
        self.OrderCode = @"";
        self.OrderNo = @"";
        self.CreateTime = @"";
        DistributionInfo *info = [[DistributionInfo alloc] init];
        self.DistributionInfo = info;
        [info release];
        
        BookerInfo *b_info = [[BookerInfo alloc] init];
        self.BookerInfo = b_info;
        [b_info release];
        
        PaymentInfo *p_info = [[PaymentInfo alloc] init];
        self.PaymentInfo = p_info;
        [p_info release];
        
        NSArray *array = [[NSArray alloc] init];
        self.PassengerTikets = array;
        [array release];
        
        NSArray *seats_array = [[NSArray alloc] init];
        self.SelectSeats = seats_array;
        [seats_array release];
        
        PriceInfo *price = [[PriceInfo alloc] init];
        self.PriceInfo = price;
        [price release];
    }
    return self;
}

-(void)dealloc{
    
    self.OrderNo = nil;
    self.OrderCode = nil;
    self.CreateTime = nil;
    self.DistributionInfo = nil;
    self.BookerInfo = nil;
    self.PaymentInfo = nil;
    self.PassengerTikets = nil;
    self.SelectSeats = nil;
    self.PriceInfo = nil;
    
    [super dealloc];
}

@end

@implementation DistributionInfo
-(void)dealloc{
    self.DistributionAddress = nil;
    self.DistributionPerson = nil;
    self.DistributionPhone = nil;
    self.DistributionPostcode = nil;
    [super dealloc];
}
@end

@implementation BookerInfo

-(void)dealloc{
    self.CardNo = nil;
    self.ConformationType = nil;
    self.Email = nil;
    self.Mobile = nil;
    self.Name = nil;
    [super dealloc];
}

@end

@implementation PaymentInfo
-(id)init{

    if (self = [super init]) {
        NSArray *array = [[NSArray alloc] init];
        self.PaymentDetails = array;
        [array release];
    }
    return self;
}
-(void)dealloc{
    self.PaymentDetails = nil;
    [super dealloc];
}

@end

@implementation PaymentDetail

-(void)dealloc{
    self.PaymentPrice = nil;
    self.PayOperate = nil;
    self.PayType = nil;
    self.ServicePrice = nil;
    self.StatusName = nil;
    [super dealloc];
}

@end

@implementation PassengerTiketInfo

-(id)init{

    if (self = [super init]) {
        NSArray *array = [[NSArray alloc] init];
        self.Tickets = array;
        [array release];
        
        InsuranceInfo *in_info = [[InsuranceInfo alloc] init];
        self.InsuranceInfo = in_info;
        [in_info release];
        
        PassengerInfo *pa_info = [[PassengerInfo alloc] init];
        self.PassengerInfo = pa_info;
        [pa_info release];
    }
    return self;
}

-(void)dealloc{
    self.Tickets = nil;
    self.PassengerInfo = nil;
    self.InsuranceInfo = nil;
    [super dealloc];
}
@end