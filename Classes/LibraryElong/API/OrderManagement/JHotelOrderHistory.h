//
//  JHotelOrderHistory.h
//  ElongClient
//
//  Created by bin xing on 11-1-17.
//  Copyright 2011 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "PostHeader.h"
#import "AccountManager.h"

@interface JHotelOrderHistory : NSObject {
	NSMutableDictionary *contents;
	NSInteger pageIndex;
}

-(void)clearBuildData;

-(void)nextPage;
-(void)prePage;     //上一页
- (void)setPageZero;             // 页数归零
-(NSString *)requesString:(BOOL)iscompress;
-(void)setHalfYear;
-(void)setOneYear;
-(void)setPageSize:(int)aPageSize;

@end
