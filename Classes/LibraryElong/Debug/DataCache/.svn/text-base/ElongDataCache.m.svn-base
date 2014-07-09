//
//  ElongDataCache.m
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

#import "ElongDataCache.h"

@implementation ElongDataCache

@synthesize cachedCount = _cachedCount;
@synthesize cacheKeys = _cacheKeys;
@synthesize cacheObjs = _cacheObjs;

DEF_SINGLETON( ElongDataCache );

- (id)init{
	self = [super init];
	if ( self ){
		_cachedCount = 0;
		
		_cacheKeys = [[NSMutableArray alloc] init];
		_cacheObjs = [[NSMutableDictionary alloc] init];
	}
    
	return self;
}

- (void)dealloc{
	
	[_cacheObjs removeAllObjects];
    [_cacheObjs release];
	
	[_cacheKeys removeAllObjects];
	[_cacheKeys release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark ElongCacheProtocol

- (BOOL)hasObjectForKey:(id)key{
	return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key{
	return [_cacheObjs objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key{
	if ( nil == key )
		return;
	
	if ( nil == object )
		return;
	
	_cachedCount += 1;
    
	[_cacheKeys addObject:key];
	[_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key{
	if ( [_cacheObjs objectForKey:key] ){
		[_cacheKeys removeObjectIdenticalTo:key];
		[_cacheObjs removeObjectForKey:key];
        
		_cachedCount -= 1;
	}
}

- (void)removeAllObjects{
	[_cacheKeys removeAllObjects];
	[_cacheObjs removeAllObjects];
	
	_cachedCount = 0;
}

- (id)objectForKeyedSubscript:(id)key{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key{
	[self setObject:obj forKey:key];
}

#pragma mark -
#pragma mark ElongCacheDebugProtocol
- (NSString *)dataLogs{
    return [_cacheObjs JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
}

- (NSArray *) allKeys{
    return [_cacheObjs allKeys];
}

- (NSArray *) allObjects{
    return [_cacheObjs allValues];
}

@end
