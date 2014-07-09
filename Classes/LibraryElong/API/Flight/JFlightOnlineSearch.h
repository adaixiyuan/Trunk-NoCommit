//
//  JFlightSearch.h
//  ElongClient
//
//  Created by dengfang on 11-1-25.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFlightOnlineSearch : NSObject {
	NSMutableDictionary *searchDictionary;
}

- (void)buildPostData:(BOOL)clearFlightsearch;
- (id)getObject:(NSString *)key;
- (void)setDate:(NSString *)date;
- (void)setVNum:(NSString *)VNum;
- (void)setvOrg:(NSString *)vOrg;
- (void)setvDst:(NSString *)vDst;

- (NSString *)requesStringwithVNum:(BOOL)iscompress;
- (NSString *)requesStringwithvOrgandvDst:(BOOL)iscompress;
@end
