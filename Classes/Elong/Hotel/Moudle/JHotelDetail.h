//
//  JHotelDetail.h
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "PostHeader.h"
@interface JHotelDetail : NSObject {
	NSMutableDictionary *contents;
}
-(id)getObject:(NSString *)key;
-(void)clearBuildData;
-(void)setHotelId:(NSString *)hotelId;
-(void)setIsUnsigned:(BOOL) isUnsigned;
-(void)setCheckDateByElongDate:(NSString *)checkindate checkoutdate:(NSString *)checkoutdate;
-(void)setCheckDate:(NSString *)checkindate checkoutdate:(NSString *)checkoutdate;
-(NSString *)requesString:(BOOL)iscompress;
-(void)setSevenDay:(BOOL)_index;
- (NSString *) getCheckInDate;
- (NSString *) getCheckOutDate;
@end
