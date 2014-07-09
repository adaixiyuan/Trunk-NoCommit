//
//  JCancelHotelOrder.h
//  ElongClient
//
//  Created by bin xing on 11-2-21.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostHeader.h"
#import "AccountManager.h"

@interface JCancelHotelOrder : NSObject {
	NSMutableDictionary *contents;
}


-(void)clearBuildData;
-(void)setOrderNo:(id)orderNo;
-(NSString *)requesString:(BOOL)iscompress;

@end
