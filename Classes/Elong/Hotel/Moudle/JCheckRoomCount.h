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
@interface JCheckRoomCount : NSObject {
	NSMutableDictionary *contents;
}
-(void)setSelectRoomcount:(int)index count:(int)count;
-(NSString *)requesString:(BOOL)iscompress;
@end
