//
//  OrderHistoryPostManager.m
//  ElongClient
//
//  Created by bin xing on 11-2-21.
//  Copyright 2011 DP. All rights reserved.
//

#import "OrderHistoryPostManager.h"

static JHotelOrderHistory *hotelorderhistory = nil;
static JCancelHotelOrder *cancelhotelorder = nil;
static JGetFlightOrderList *getFlightOrderList = nil;
static JGetFlightOrder *getFlightOrder = nil;
static InterHotelOrderHistoryRequest *interHotelOrderHistoryRequest = nil;
static InterOrderConfirmationLetterRequest *interOrderConfirmationLetterRequest = nil;
static InterOrderDetailRequest *interOrderDetailReqeust = nil;

@implementation OrderHistoryPostManager

+ (JHotelOrderHistory *)hotelorderhistory
{
	
	@synchronized(self) {
		if(!hotelorderhistory) {
			hotelorderhistory = [[JHotelOrderHistory alloc] init];
		}
	}
	return hotelorderhistory;
}

+ (JCancelHotelOrder *)cancelhotelorder
{
	
	@synchronized(self) {
		if(!cancelhotelorder) {
			cancelhotelorder = [[JCancelHotelOrder alloc] init];
		}
	}
	return cancelhotelorder;
}

+ (JGetFlightOrderList *)getFlightOrderList
{
	
	@synchronized(self) {
		if(!getFlightOrderList) {
			getFlightOrderList = [[JGetFlightOrderList alloc] init];
		}
	}
	return getFlightOrderList;
}

+ (JGetFlightOrder *)getFlightOrder
{
	
	@synchronized(self) {
		if(!getFlightOrder) {
			getFlightOrder = [[JGetFlightOrder alloc] init];
		}
	}
	return getFlightOrder;
}

+ (InterHotelOrderHistoryRequest *)getInterHotelOrderHistory
{
    @synchronized(self) {
		if(!interHotelOrderHistoryRequest) {
			interHotelOrderHistoryRequest = [[InterHotelOrderHistoryRequest alloc] init];
		}
	}
	return interHotelOrderHistoryRequest;
}

+ (InterOrderConfirmationLetterRequest *)getInterOrderConfirmationLetterRequest
{
    @synchronized(self) {
		if(!interOrderConfirmationLetterRequest) {
			interOrderConfirmationLetterRequest = [[InterOrderConfirmationLetterRequest alloc] init];
		}
	}
	return interOrderConfirmationLetterRequest;
}

+ (InterOrderDetailRequest *)getInterOrderOrderDetailRequest{
    @synchronized(self){
        if (!interOrderDetailReqeust) {
            interOrderDetailReqeust = [[InterOrderDetailRequest alloc] init];
        }
    }
    return interOrderDetailReqeust;
}
@end
