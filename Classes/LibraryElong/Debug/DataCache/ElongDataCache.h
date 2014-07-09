//
//  ElongDataCache.h
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElongSingleton.h"
#import "ElongCacheProtocol.h"
#import "ElongCacheDebugProtocol.h"


@interface ElongDataCache : NSObject<ElongCacheProtocol,ElongCacheDebugProtocol>

@property (nonatomic, assign) NSUInteger			cachedCount;
@property (atomic, retain) NSMutableArray *			cacheKeys;
@property (atomic, retain) NSMutableDictionary *	cacheObjs;

AS_SINGLETON( ElongDataCache );

@end