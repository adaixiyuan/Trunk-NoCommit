//
//  JHotelComments.h
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "PostHeader.h"
#import "HotelPostManager.h"
@interface JHotelComments : NSObject {
	NSMutableDictionary *contents;
}


-(void)clearBuildData;

-(void)nextPage;

-(NSString *)requesString:(BOOL)iscompress;
-(void)setHotelId;
- (void)setCommentsTpye:(int)_tpye;
- (void) setGrouponHotelId:(NSString *)pid;
@end
