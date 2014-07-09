//
//  JFlightTerminal.h
//  ElongClient
//
//  Created by dengfang on 11-2-21.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JFlightTerminal : NSObject {
	NSMutableDictionary *mDictionary;
}

- (void)buildPostData:(BOOL)clearFlightRestriction;
- (id)getObject:(NSString *)key;
- (void)setAirPortCode:(NSString *)str isClearData:(BOOL)isClearData;
- (void)setFlightNumber:(NSString *)str isClearData:(BOOL)isClearData;
- (NSString *)requesString:(BOOL)iscompress;
@end
