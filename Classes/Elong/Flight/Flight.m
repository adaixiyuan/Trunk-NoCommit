//
//  Flight.m
//  ElongClient
//
//  Created by dengfang on 11-2-11.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "Flight.h"
#import "PostHeader.h"

@implementation Flight

@synthesize returnRule;
@synthesize changeRule;
@synthesize tReturnRule;
@synthesize tChangeRule;
@synthesize stopNumber;
@synthesize isTransited;
@synthesize transInfo;
@synthesize vertifyFlightClassDict;
@synthesize tAirCorp;
@synthesize tAirCorpCode;
@synthesize tDepartAirPort;
@synthesize tArrivalAirPort;
@synthesize tFlightNum;
@synthesize tAirFlightType;
@synthesize tDepartTime;
@synthesize tArrivalTime;
@synthesize stopInfos;
@synthesize tDepartAirPortCode;
@synthesize tArrivalAirPortCode;
@synthesize tKilometers;
@synthesize stopDescription;
@synthesize defaultCoupon;
@synthesize currentCoupon;

#pragma mark -
#pragma mark Public
- (void)setDepartTime:(NSString *)data {
    if(data){
        [departTime setString:data];
    }else{
        [departTime setString:@"0"];
    }
}
- (NSMutableString *)getDepartTime {
	return departTime;
}

- (void)setArriveTime:(NSString *)data {
    if(data){
        [arriveTime setString:data];
    }else{
        [arriveTime setString:@"0"];
    }
}
- (NSMutableString *)getArriveTime {
	return arriveTime;
}

- (void)setAirCorpCode:(NSString *)data {
    if(data){
        [airCorpCode setString:data];
    }else{
        [airCorpCode setString:@"0"];
    }
}
- (NSMutableString *)getAirCorpCode {
	return airCorpCode;
}

- (void)setDepartAirportCode:(NSString *)data {
	if(!(data==departAirportCode)){
		[departAirportCode release];
		departAirportCode = [[NSMutableString alloc] initWithString:data];
	}
}
- (NSMutableString *)getDepartAirportCode {
	return departAirportCode;
}

- (void)setArriveAirportCode:(NSString *)data {
	if(!(data == arriveAirportCode)){
		[arriveAirportCode release];
		arriveAirportCode = [[NSMutableString alloc] initWithString:data];
	}
}
- (NSMutableString *)getArriveAirportCode {
	return arriveAirportCode;
}

- (void)setTypeName:(NSString *)data {
    if(data){
        [typeName setString:data];
    }else{
        [typeName setString:@"0"];
    }
}
- (NSMutableString *)getTypeName {
	return typeName;
}

- (void)setDepartAirport:(NSString *)data {
    if(data){
        [departAirport setString:data];
    }else{
        [departAirport setString:@"0"];
    }
}
- (NSMutableString *)getDepartAirport {
	return departAirport;
}

- (void)setArriveAirport:(NSString *)data {
    if(data){
        [arriveAirport setString:data];
    }else{
        [arriveAirport setString:@"0"];
    }
}
- (NSMutableString *)getArriveAirport {
	return arriveAirport;
}

- (void)setAirCorpName:(NSString *)data {
    if(data){
        [airCorpName setString:data];
    }else{
        [airCorpName setString:@"0"];
    }
}
- (NSMutableString *)getAirCorpName {
	return airCorpName;
}

- (void)setFlightNumber:(NSString *)data {
    if(data){
        [flightNumber setString:data];
    }else{
        [flightNumber setString:@"0"];
    }
}
- (NSMutableString *)getFlightNumber {
	return flightNumber;
}

- (void)setPlaneType:(NSString *)data {
    if(data){
        [planeType setString:data];
    }else{
        [planeType setString:@"0"];
    }
}
- (NSMutableString *)getPlaneType {
	return planeType;
}

- (void)setClassTag:(NSString *)data {
    if(data){
        [classTag setString:data];
    }else{
        [classTag setString:@"0"];
    }
}
- (NSMutableString *)getClassTag {
	return classTag;
}

- (void)setTimeOfLastIssued:(NSString *)data {
    if(data){
        [timeOfLastIssued setString:data];
    }else{
        [timeOfLastIssued setString:@"0"];
    }
}
- (NSMutableString *)getTimeOfLastIssued {
	return timeOfLastIssued;
}

- (void)setTicketnum:(NSString*)data{
    if(data){
        [ticktenum setString:data];
    }else{
        [ticktenum setString:@"0"];
    }
}
- (NSMutableString *)getTicketnum{
	return ticktenum;
}

    
- (void)setPrice:(int)data {
	if(!(data == [price intValue])){
		[price release];
		price = [[NSNumber alloc] initWithInt:data];
	}
}
- (NSNumber *)getPrice {
	return price;
}

- (void)setClassType:(int)data {
	if (!(data == [classType intValue])) {
		[classType release];
		
		classType = [[NSNumber alloc] initWithInt:data];
	}
}
- (NSNumber *)getClassType {
	return classType;
}

- (void)setOilTax:(double)data {
	oilTax = [[NSNumber alloc] initWithDouble:data];
}
- (NSNumber *)getOilTax {
	return oilTax;
}

- (void)setAirTax:(int)data {
	airTax = [[NSNumber alloc] initWithInt:data];
}
- (NSNumber *)getAirTax {
	return airTax;
}

// Add 2014/02/12
- (void)setAdultAirTax:(double)adAirTax {
    adultAirTax = [[NSNumber alloc] initWithDouble:adAirTax];
}

- (NSNumber *)getAdultAirTax {
    return adultAirTax;
}

- (void)setAdultOilTax:(double)adOilTax {
    adultOilTax = [[NSNumber alloc] initWithDouble:adOilTax];
}

- (NSNumber *)getAdultOilTax {
    return adultOilTax;
}

- (void)setChildAirTax:(double)chAirTax {
    childAirTax = [[NSNumber alloc] initWithDouble:chAirTax];
}

- (NSNumber *)getChildAirTax {
    return childAirTax;
}

- (void)setChildOilTax:(double)chOilTax {
    childOilTax = [[NSNumber alloc] initWithDouble:chOilTax];
}

- (NSNumber *)getChildOilTax {
    return childOilTax;
}

- (void)setAdultPrice:(double)adPrice {
    adultPrice = [[NSNumber alloc] initWithDouble:adPrice];
}

- (NSNumber *)getAdultPrice {
    return adultPrice;
}

- (void)setChildPrice:(double)chPrice {
    childPrice = [[NSNumber alloc] initWithDouble:chPrice];
}

- (NSNumber *)getChildPrice {
    return childPrice;
}
// End

- (void)setDiscount:(double)data {
	//if(!(data==[discount doubleValue])){
		[discount release];
		discount = [[NSNumber alloc] initWithDouble:data];
//	}
}

- (NSNumber *)getDiscount {
	return discount;
}

- (void)setIsEticket:(BOOL)data {
	isEticket = [[NSNumber alloc] initWithBool:data];
}
- (NSNumber *)getIsEticket {
	return isEticket;
}

- (void)setPromotionID:(int)data {
	promotionID = [[NSNumber alloc] initWithInt:data];
}
- (NSNumber *)getPromotionID {
	return promotionID;
}

- (void)setSiteseatArray:(NSMutableArray *)data{
	[siteseatArray release];
	siteseatArray = nil;
	siteseatArray = [[NSMutableArray alloc] initWithArray:data];
//	siteseatArray = [NSMutableArray arrayWithArray:data];
}
- (NSMutableArray *)getSiteseatArray{
	return siteseatArray;
	
}

- (void)setKilometers:(int)data {
	kilometers = [[NSNumber alloc] initWithInt:data];
}
- (NSNumber *)getKilometers {
	return kilometers;
}

- (void)setIsPromotion:(BOOL)data {
	isPromotion = [[NSNumber alloc] initWithBool:data];
}
- (NSNumber *)getIsPromotion {
	return isPromotion;
}

- (void)setStops:(BOOL)data {
	stops = [[NSNumber alloc] initWithBool:data];
}
- (NSNumber *)getStops {
	return stops;
}

- (void)setIssueCityId:(int)data {
	issueCityId = [[NSNumber alloc] initWithInt:data];
}

- (NSNumber *)getIssueCityId {
	return issueCityId;
}

#pragma mark -
#pragma mark Init
- (id)init {
	if (self = [super init]) {
        stopNumber = 0;
        currentCoupon = [NSNumber numberWithInt:0];
        isTransited = NO;
        
		departTime = [[NSMutableString alloc] initWithString:@"0"];
		arriveTime = [[NSMutableString alloc] initWithString:@"0"];
		departAirport = [[NSMutableString alloc] initWithString:@"0"];
		arriveAirport = [[NSMutableString alloc] initWithString:@"0"];
		airCorpName = [[NSMutableString alloc] initWithString:@"0"];
		flightNumber = [[NSMutableString alloc] initWithString:@"0"];
		planeType = [[NSMutableString alloc] initWithString:@"0"];
		classType = [[NSNumber alloc] initWithInt:0];
//		oilTax = [[NSNumber alloc] initWithDouble:0];
		airTax = [[NSNumber alloc] initWithInt:0];
        
//		price = [[NSNumber alloc] initWithInt:0];
//		discount = [[NSNumber alloc] initWithDouble:0.0];
		
//		classType = [NSNumber numberWithInt:0];
//		oilTax = [NSNumber numberWithDouble:0];
//		airTax = [NSNumber numberWithInt:0];
//		price = [NSNumber numberWithInt:0];
//		discount = [NSNumber numberWithDouble:0.0];
		
		typeName = [[NSMutableString alloc] initWithString:@"0"];
		timeOfLastIssued = [[NSMutableString alloc] initWithString:@"0"];
		ticktenum = [[NSMutableString alloc] initWithString:@"0"];
		
		airCorpCode = [[NSMutableString alloc] initWithString:@"0"];
		departAirportCode = [[NSMutableString alloc] initWithString:@"0"];
		arriveAirportCode = [[NSMutableString alloc] initWithString:@"0"];
		classTag = [[NSMutableString alloc] initWithString:@"0"];
		promotionID = [[NSNumber alloc] initWithInt:0];
		kilometers = [[NSNumber alloc] initWithInt:0];
		isPromotion = [[NSNumber alloc] initWithBool:NO];
		stops = [[NSNumber alloc] initWithBool:NO];
		isEticket = [[NSNumber alloc] initWithBool:NO];
//		issueCityId = [[NSNumber alloc] initWithInt:100];
		issueCityId = [NSNumber numberWithInt:100];

		vertifyFlightClassDict = [[NSMutableDictionary alloc] init];
		[self buildPostData:YES];
	}
	return self;
}

- (void)buildPostData:(BOOL)clearFlightClass{
	[vertifyFlightClassDict safeSetObject:[PostHeader header] forKey:@"Header"];
	[vertifyFlightClassDict safeSetObject:@"" forKey:@"DepartCityName"];
	[vertifyFlightClassDict safeSetObject:@"" forKey:@"ArrivalCityName"];
	[vertifyFlightClassDict safeSetObject:[NSNull null] forKey:@"DepartDate"];
	[vertifyFlightClassDict safeSetObject:[NSNumber numberWithBool:FALSE] forKey:@"IsPromotion"];
	[vertifyFlightClassDict safeSetObject:[NSNumber numberWithInt:0] forKey:@"IssueCityId"];
	[vertifyFlightClassDict safeSetObject:[NSNumber numberWithInt:0] forKey:@"PassengerCount"];
	[vertifyFlightClassDict safeSetObject:[NSNull null] forKey:@"FlightClassList"];
}

- (NSString *)requesString:(BOOL)iscompress{
	return [NSString stringWithFormat:@"action=VertifyFlightClass&compress=%@&req=%@",[NSString stringWithFormat:@"%@",iscompress?@"true":@"false"],[vertifyFlightClassDict JSONRepresentationWithURLEncoding]];
}

#pragma mark -
#pragma mark Release
- (void)dealloc {
	[vertifyFlightClassDict release];
    
    SFRelease(_isOneHour);
	
	self.returnRule = nil;
	self.changeRule = nil;
    self.signRule = nil;
    self.tReturnRule = nil;
	self.tChangeRule = nil;
    self.transInfo = nil;
    self.tAirCorp = nil;
    self.tDepartAirPort = nil;
    self.tArrivalAirPort = nil;
    self.tFlightNum = nil;
    self.tAirFlightType = nil;
    self.tDepartTime = nil;
    self.tArrivalTime = nil;
    self.stopInfos = nil;
    self.tAirCorpCode = nil;
    self.tDepartAirPortCode = nil;
    self.tArrivalAirPortCode = nil;
    self.tKilometers = nil;
    self.stopDescription = nil;
    self.defaultCoupon = nil;
    self.currentCoupon = nil;
	
	[departTime release];
	[arriveTime release];
	[departAirport release];
	[arriveAirport release];
	[airCorpName release];
	[flightNumber release];
	[planeType release];
	[classType release];
	[oilTax release];
	[airTax release];
	[price release];
	[discount release];
	[isEticket release];
	[typeName release];
	[timeOfLastIssued release];
	
	[ticktenum release];
	[siteseatArray release];
	[airCorpCode release];
	[departAirportCode release];
	[arriveAirportCode release];
	[classTag release];
	[promotionID release];
	[kilometers release];
	[isPromotion release];
	[stops release];
	[issueCityId release];
    [_originalPrice release];
    
    // Add 2014/02/12
    [adultAirTax release];
    [adultOilTax release];
    [childAirTax release];
    [childOilTax release];
    // End
	
	[super dealloc];
}
@end
