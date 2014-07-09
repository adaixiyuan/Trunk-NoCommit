//
//  JHotelDetail.m
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import "JHotelDetail.h"
#import "DefineHotelReq.h"
#import "AccountManager.h"

@implementation JHotelDetail
-(void)buildPostData:(BOOL)clearhotelsearch{
	if (clearhotelsearch) {
		[contents safeSetObject:[PostHeader header] forKey:Resq_Header];
		[contents safeSetObject:EmptyString forKey:ReqHD_HotelId_S];
		[contents safeSetObject:JSON_NULL forKey:ReqHD_CheckInDate_ED];
		[contents safeSetObject:JSON_NULL forKey:ReqHD_CheckOutDate_ED];
        //[contents safeSetObject:[NSNumber numberWithInt:3] forKey:@"ImageSize"];
        [contents safeSetObject:@"true" forKey:@"IncludeMultiSuppliers"];        // 多供应商
		[contents safeSetObject:@"true" forKey:ReqHD_CurrencySupport];
        [contents safeSetObject:@"false" forKey:@"IsBookingSevenDay"];  
        [contents safeSetObject:@"true" forKey:@"IncludePrePay"];               // 预付
        [contents safeSetObject:[NSNumber numberWithInt:0] forKey:@"ImageType"];
        
        [contents safeSetObject:@"true" forKey:@"IncludeJW"];       // 包括万豪酒店
        //默认不是未签约
        [self setIsUnsigned:NO];
        
        /*图片尺寸
         宽度350高度不定jpg=1，
         70x70jpg=2，
         120x120 jpg=3，
         宽度160高度不定jpg=4，
         70x70png=5，
         120x120png=6，
         宽度640高度不定jpg=7，
         220×220png=8，
         230x173jpg=9，
         230x172jpg=10，
         286x233jpg=11，
         宽度698高度不定jpg=12，
         698x308jpg=13，
         306x133jpg=14，
         640x310 jpg=15，
         262x165jpg=16，
         160x110jpg=17)
         */
        [contents safeSetObject:[NSNumber numberWithInt:1] forKey:@"ImageSize"];
        
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.isNonmemberFlow) {
			[contents safeSetObject:NUMBER(0) forKey:Resq_CardNo];
		}
		else {
            BOOL islogin = [[AccountManager instanse] isLogin];
            if (islogin)
                [contents safeSetObject:[[AccountManager instanse] cardNo] forKey:Resq_CardNo];
		}
        
        [contents setObject:[NSNumber numberWithInt:1] forKey:@"RoomHoldingRule"];

	}
}

-(id)init{
    self = [super init];
    if (self) { 
		contents=[[NSMutableDictionary alloc] init];
		[self clearBuildData];
	}
	return self;
}
-(void)clearBuildData{
	[self buildPostData:YES];
}
-(id)getObject:(NSString *)key{
	return	[contents safeObjectForKey:key];
}
-(void)setHotelId:(NSString *)hotelId{
	[contents safeSetObject:hotelId forKey:ReqHD_HotelId_S];
}
-(void)setIsUnsigned:(BOOL) isUnsigned{
	[contents safeSetObject:[NSNumber numberWithInt:isUnsigned] forKey:@"IsUnsigned"];
}
-(void)setCheckDate:(NSString *)checkindate checkoutdate:(NSString *)checkoutdate{
	//NSString *checkindatestring = [NSString stringWithFormat:ELONGDATE,[[Utils NSStringDateToNSDate:checkindate] timeIntervalSince1970]*1000];
	NSString *checkindatestring=[TimeUtils makeJsonDateWithDisplayNSStringFormatter:checkindate formatter:@"yyyy-MM-dd"];
	[contents safeSetObject:checkindatestring forKey:ReqHD_CheckInDate_ED];
	NSString *checkoutdatestring=[TimeUtils makeJsonDateWithDisplayNSStringFormatter:checkoutdate formatter:@"yyyy-MM-dd"];
	//NSString *checkoutdatestring = [NSString stringWithFormat:ELONGDATE,[[Utils NSStringDateToNSDate:checkoutdate] timeIntervalSince1970]*1000];
	[contents safeSetObject:checkoutdatestring forKey:ReqHD_CheckOutDate_ED];	
}
-(void)setCheckDateByElongDate:(NSString *)checkindate checkoutdate:(NSString *)checkoutdate{
	[contents safeSetObject:checkindate forKey:ReqHD_CheckInDate_ED];
	[contents safeSetObject:checkoutdate forKey:ReqHD_CheckOutDate_ED];
}

- (NSString *) getCheckInDate{
    return [contents safeObjectForKey:ReqHD_CheckInDate_ED];
}
- (NSString *) getCheckOutDate{
    return [contents safeObjectForKey:ReqHD_CheckOutDate_ED];
}

-(void)setSevenDay:(BOOL)_index
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:(NSString *)kCFBundleVersionKey];
    BOOL result = [version compare:@"3.6.0"] == NSOrderedDescending||[version compare:@"3.6.0"] == NSOrderedSame;//7天版本控制
    if (result) {
        [contents safeSetObject:@"true" forKey:@"IsBookingSevenDay"];
    }
}

-(NSString *)requesString:(BOOL)iscompress{
    NSLog(@"hotelDetailReq:%@", contents);
	NSString *iscomp=[[NSString alloc] initWithFormat:@"%@",iscompress?@"true":@"false"];
	NSString *request=[[[NSString alloc] initWithFormat:@"action=GetHotelDetail&compress=%@&req=%@",iscomp,[contents JSONRepresentationWithURLEncoding]] autorelease];
	[iscomp release];
	return request;
}

@end
