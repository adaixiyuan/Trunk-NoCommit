//
//  JFlightOrder.h
//  ElongClient
//
//  Created by dengfang on 11-3-3.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFlightOrder : NSObject {
	NSMutableDictionary *mDictionary;
	
//	//-----
//	NSMutableDictionary *deliveryInfoDictionary;
//	NSMutableDictionary *addressDictionary;
//	//-----
//	NSMutableDictionary *creditCardDictionary;
//	NSMutableDictionary *creditCardTypeDictionary;
//	//-----
//	NSMutableArray *flightClassListArray;
//	NSMutableDictionary *flightClassListDictionary;
//	//-----
//	NSMutableArray *passengerListArray;
//	NSMutableDictionary *passengerListDictionary;
}

- (void)buildPostData:(BOOL)clearFlightOrder;
- (id)getObject:(NSString *)key;
- (void)setOrderDictionary:(NSDictionary *)cardDict;
- (void)setTotalPrice;
- (void)setDeliveryInfo;
- (void)setCreditCard:(NSDictionary *)data;
- (void)setFlightClassList;
- (void)setPassengerList;
- (NSString *)requesString:(BOOL)iscompress;
-(void) setPayMethod;
-(void) setPaymentOrder;
// 现金账户
- (void)setCashAmount:(CGFloat)cashNum;
- (NSNumber *)getCashAmount;
////------------DeliveryInfo
//- (void)setDITicketGetType:(NSNumber *)data isClearData:(BOOL)isClearData; //int
//- (void)setDIMemo:(NSString *)data isClearData:(BOOL)isClearData;
//- (void)setDIAddress:(NSDictionary *)data isClearData:(BOOL)isClearData;
//- (void)setDIAId:(NSNumber *)data isClearData:(BOOL)isClearData; //int
//- (void)setDIAAddressContent:(NSString *)data isClearData:(BOOL)isClearData;
//- (void)setDIAPostcode:(NSString *)data isClearData:(BOOL)isClearData;
//- (void)setDIAName:(NSString *)data isClearData:(BOOL)isClearData;
//- (void)setDIAPhoneNo:(NSString *)data isClearData:(BOOL)isClearData;
////------------CreditCard
@end
