//
//  ElongMemoryCache.h
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElongSingleton.h"
#import "ElongCacheProtocol.h"
#import "ElongCacheDebugProtocol.h"

@interface ElongMemoryCache : NSObject<ElongCacheProtocol,ElongCacheDebugProtocol>

@property (nonatomic, assign) BOOL					clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger			maxCacheCount;
@property (nonatomic, assign) NSUInteger			cachedCount;
@property (atomic, retain) NSMutableArray *			cacheKeys;
@property (atomic, retain) NSMutableDictionary *	cacheObjs;

AS_SINGLETON( ElongMemoryCache );

@end