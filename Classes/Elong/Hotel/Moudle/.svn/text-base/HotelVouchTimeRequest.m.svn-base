//
//  HotelVouchTimeRequest.m
//  ElongClient
//
//  Created by 赵 海波 on 12-6-1.
//  Copyright 2012 elong. All rights reserved.
//

#import "HotelVouchTimeRequest.h"
#import "HotelDetailController.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "PostHeader.h"

static HotelVouchTimeRequest *request = nil;

@implementation HotelVouchTimeRequest

- (void)dealloc {
	[contents release];
	
	[super dealloc];
}


- (id)init {
	if (self = [super init]) {
		contents = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
					[PostHeader header], Resq_Header, nil];
	}
	
	return self;
}


#pragma mark -
#pragma mark PublicMethods

- (void)clearData {
	[contents removeAllObjects];
}


- (void)rebuildData {
	[self clearData];
	
	[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
	[contents safeSetObject:[[HotelDetailController hoteldetail] safeObjectForKey:HOTELID_REQ] forKey:HOTELID_REQ];
	[contents safeSetObject:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckInDate_ED] forKey:ReqHS_CheckInDate_ED];
	[contents safeSetObject:[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckOutDate_ED] forKey:ReqHS_CheckOutDate_ED];
	
	NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
	[contents safeSetObject:[dic safeObjectForKey:ROOMTYPEID] forKey:ROOMTYPEID];
	[contents safeSetObject:[dic safeObjectForKey:RATEPLANID] forKey:RATEPLANID];
	[contents safeSetObject:[dic safeObjectForKey:VOUCHSET] forKey:VOUCHSET];
}


+ (id)shared {
	@synchronized(request) {
		if (!request) {
			request = [[HotelVouchTimeRequest alloc] init];
		}
	}
	
	return request;
}


- (NSString *)requestForVouchTime {
	return [NSString stringWithFormat:@"action=JudgeHotelVouchSet&compress=true&req=%@",
			[contents JSONRepresentationWithURLEncoding]];
}


@end
