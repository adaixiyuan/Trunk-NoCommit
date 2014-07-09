//
//  ElongUserDefaults.m
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

#import "ElongUserDefaults.h"

@implementation ElongUserDefaults

DEF_SINGLETON( ElongUserDefaults )


#pragma mark -
#pragma mark ElongCacheProtocol

- (BOOL)hasObjectForKey:(id)key{
	id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	return value ? YES : NO;
}

- (id)objectForKey:(NSString *)key{
	if ( nil == key )
		return nil;
	
	id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	return value;
}

- (void)setObject:(id)value forKey:(NSString *)key{
	if ( nil == key || nil == value )
		return;
    
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeObjectForKey:(NSString *)key{
	if ( nil == key )
		return;
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAllObjects{
	[NSUserDefaults resetStandardUserDefaults];
}

- (id)objectForKeyedSubscript:(id)key{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key{
	if ( obj ){
		[self setObject:obj forKey:key];
	}
	else{
		[self removeObjectForKey:key];
	}
}

#pragma mark -
#pragma mark ElongCacheDebugProtocol
- (NSString *)dataLogs{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    [dataDict removeObjectForKey:@"AppleITunesStoreItemKinds"];
    [dataDict removeObjectForKey:@"AppleKeyboards"];
    [dataDict removeObjectForKey:@"AppleKeyboardsExpanded"];
    [dataDict removeObjectForKey:@"AppleLanguages"];
    [dataDict removeObjectForKey:@"AppleLocale"];
    [dataDict removeObjectForKey:@"NSInterfaceStyle"];
    [dataDict removeObjectForKey:@"NSLanguages"];
    [dataDict removeObjectForKey:@"UIDisableLegacyTextView"];
    
    return [dataDict JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
}

- (NSArray *) allKeys{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    [dataDict removeObjectForKey:@"AppleITunesStoreItemKinds"];
    [dataDict removeObjectForKey:@"AppleKeyboards"];
    [dataDict removeObjectForKey:@"AppleKeyboardsExpanded"];
    [dataDict removeObjectForKey:@"AppleLanguages"];
    [dataDict removeObjectForKey:@"AppleLocale"];
    [dataDict removeObjectForKey:@"NSInterfaceStyle"];
    [dataDict removeObjectForKey:@"NSLanguages"];
    [dataDict removeObjectForKey:@"UIDisableLegacyTextView"];
    
    NSArray *keys = [dataDict allKeys];
    NSMutableArray *keyArray = [NSMutableArray array];
    for (NSString *key in keys) {
        if ([key rangeOfString:@"WebKit"].length) {
            continue;
        }
        [keyArray addObject:key];
    }
    return [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 localizedCaseInsensitiveCompare:obj2];
    }];
}

- (NSArray *) allObjects{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    [dataDict removeObjectForKey:@"AppleITunesStoreItemKinds"];
    [dataDict removeObjectForKey:@"AppleKeyboards"];
    [dataDict removeObjectForKey:@"AppleKeyboardsExpanded"];
    [dataDict removeObjectForKey:@"AppleLanguages"];
    [dataDict removeObjectForKey:@"AppleLocale"];
    [dataDict removeObjectForKey:@"NSInterfaceStyle"];
    [dataDict removeObjectForKey:@"NSLanguages"];
    [dataDict removeObjectForKey:@"UIDisableLegacyTextView"];
    
    return [dataDict allValues];
}

@end