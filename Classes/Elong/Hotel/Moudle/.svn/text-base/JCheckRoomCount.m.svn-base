//
//  JHotelDetail.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "JCheckRoomCount.h"
#import "DefineHotelResp.h"
#import "DefineHotelReq.h"
#import "HotelDetailController.h"
#import "HotelPostManager.h"
@implementation JCheckRoomCount

-(id)init{
	if(self=[super init]) { 
		contents=[[NSMutableDictionary alloc] init];
	}
	return self;
}
-(void)setSelectRoomcount:(int)index count:(int)count{
	
	NSString *hotelid=[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_HotelId_S] ;
	NSString *checkin=[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckInDate_ED];
	NSString *checkout=[[HotelPostManager hoteldetailer] getObject:ReqHD_CheckOutDate_ED];
	NSDictionary *room = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:index];
    NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:RespHD_Rooms_A] safeObjectAtIndex:[RoomType currentRoomIndex]];
	
	NSString *roomType=[room safeObjectForKey:RespHD__RoomTypeId_S];
	[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
	[contents safeSetObject:hotelid forKey:@"HotelId"];
	[contents safeSetObject:checkin forKey:@"CheckInDate"];
	[contents safeSetObject:checkout forKey:@"CheckOutDate"];
	[contents safeSetObject:[NSNumber numberWithInt:count] forKey:@"RoomCount"];
	[contents safeSetObject:roomType forKey:@"RoomTypeId"];
    [contents safeSetObject:[NSNumber numberWithBool:[RoomType isPrepay]] forKey:@"IsPrePayOrder"];
    [contents safeSetObject:[dic safeObjectForKey:RATEPLANID] forKey:RATEPLANID];
    [contents safeSetObject:[dic safeObjectForKey:@"SHotelID"] forKey:@"SHotelID"];
}


-(NSString *)requesString:(BOOL)iscompress{
	NSString *iscomp=[[[NSString alloc] initWithFormat:@"%@",iscompress?@"true":@"false"] autorelease];
	NSLog(@"request:%@", contents);
	return [NSString stringWithFormat:@"action=CheckRoomAvailable&compress=%@&version=1.2&req=%@",iscomp,[contents JSONRepresentationWithURLEncoding]];
}
@end
