//
//  ElongHttpRequestCache.h
//  ElongClient
//
//  Created by Dawn on 14-2-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ElongSingleton.h"
#import "ElongCacheProtocol.h"
#import "ElongCacheDebugProtocol.h"

@interface ElongHttpRequestCache : NSObject<ElongCacheProtocol,ElongCacheDebugProtocol>

@property (nonatomic, assign) BOOL					clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger			maxCacheCount;
@property (nonatomic, assign) NSUInteger			cachedCount;
@property (atomic, retain) NSMutableArray *			cacheKeys;
@property (atomic, retain) NSMutableDictionary *	cacheObjs;

AS_SINGLETON(ElongHttpRequestCache);

@end