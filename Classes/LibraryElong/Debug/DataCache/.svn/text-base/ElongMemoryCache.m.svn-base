//
//  ElongMemoryCache.m
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

#import "ElongMemoryCache.h"

#pragma mark -
#pragma mark Default mac count

#undef	DEFAULT_MAX_COUNT
#define DEFAULT_MAX_COUNT	(48)

#pragma mark -

@interface ElongMemoryCache(){
	BOOL					_clearWhenMemoryLow;
	NSUInteger				_maxCacheCount;
	NSUInteger				_cachedCount;
	NSMutableArray *		_cacheKeys;
	NSMutableDictionary *	_cacheObjs;
}
@end

#pragma mark -

@implementation ElongMemoryCache

@synthesize clearWhenMemoryLow = _clearWhenMemoryLow;
@synthesize maxCacheCount = _maxCacheCount;
@synthesize cachedCount = _cachedCount;
@synthesize cacheKeys = _cacheKeys;
@synthesize cacheObjs = _cacheObjs;

DEF_SINGLETON( ElongMemoryCache );

- (id)init{
	self = [super init];
	if ( self ){
		_clearWhenMemoryLow = YES;
		_maxCacheCount = DEFAULT_MAX_COUNT;
		_cachedCount = 0;
		
		_cacheKeys = [[NSMutableArray alloc] init];
		_cacheObjs = [[NSMutableDictionary alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
	}
    
	return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	
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
    
	while ( _cachedCount >= _maxCacheCount ){
		NSString * tempKey = [_cacheKeys objectAtIndex:0];
        
		[_cacheObjs removeObjectForKey:tempKey];
		[_cacheKeys removeObjectAtIndex:0];
        
		_cachedCount -= 1;
	}
    
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
#pragma mark Notification

- (void)handleNotification:(NSNotification *)notification{
    if ( _clearWhenMemoryLow ){
        [self removeAllObjects];
    }
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
