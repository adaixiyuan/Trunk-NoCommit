//
//  ElongKeychain.m
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

#import "ElongKeychain.h"

#pragma mark -
#pragma mark Default domain

#undef	DEFAULT_DOMAIN
#define DEFAULT_DOMAIN	@"default."

#pragma mark -

@interface ElongKeychain(){
	NSString *	_defaultDomain;
}

- (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;
- (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;

@end

#pragma mark -

@implementation ElongKeychain
@synthesize defaultDomain = _defaultDomain;

DEF_SINGLETON(ElongKeychain)

- (id)init{
	self = [super init];
	if (self){
		self.defaultDomain = DEFAULT_DOMAIN;
	}
	return self;
}

- (void)dealloc{
	self.defaultDomain = nil;
	[super dealloc];
}

+ (void)setDefaultDomain:(NSString *)domain{
	[[ElongKeychain sharedInstance] setDefaultDomain:domain];
}

+ (NSString *)readValueForKey:(NSString *)key{
	return [[ElongKeychain sharedInstance] readValueForKey:key andDomain:nil];
}

+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain{
	return [[ElongKeychain sharedInstance] readValueForKey:key andDomain:domain];
}

- (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain{
	if ( nil == key )
		return nil;
    
	if ( nil == domain ){
		domain = self.defaultDomain;
		if ( nil == domain ){
			domain = DEFAULT_DOMAIN;
		}
	}
	
	domain = [domain stringByAppendingString:[self appIdentifier]];
    
	NSArray * keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil] autorelease];
	NSArray * objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, key, domain, nil] autorelease];
	
	NSMutableDictionary * query = [[[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
	NSMutableDictionary * attributeQuery = [query mutableCopy];
	[attributeQuery setObject: (id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
	
	NSDictionary * attributeResult = NULL;
	OSStatus status = SecItemCopyMatching( (CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult );
	
	[attributeResult release];
	[attributeQuery release];
	
	if ( noErr != status )
		return nil;
	
	NSMutableDictionary * passwordQuery = [query mutableCopy];
	[passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
	NSData * resultData = nil;
	status = SecItemCopyMatching( (CFDictionaryRef)passwordQuery, (CFTypeRef *)&resultData );
    
	[resultData autorelease];
	[passwordQuery release];
	
	if ( noErr != status )
		return nil;
	
	if ( nil == resultData )
		return nil;
	
	NSString * password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
	return [password autorelease];
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key{
	[[ElongKeychain sharedInstance] writeValue:value forKey:key andDomain:nil];
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain{
	[[ElongKeychain sharedInstance] writeValue:value forKey:key andDomain:domain];
}

- (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain{
	if ( nil == key )
		return;
	
	if ( nil == value ){
		value = @"";
	}
    
	if ( nil == domain ){
		domain = self.defaultDomain;
		if ( nil == domain ){
			domain = DEFAULT_DOMAIN;
		}
	}
	
	domain = [domain stringByAppendingString:[self appIdentifier]];
    
	OSStatus status = 0;
	
	NSString * password = [[ElongKeychain sharedInstance] objectForKey:key];
	if ( password ){
		if ( [password isEqualToString:value] )
			return;
        
		NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, nil] autorelease];
		NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, domain, domain, key, nil] autorelease];
		
		NSDictionary * query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
		status = SecItemUpdate( (CFDictionaryRef)query, (CFDictionaryRef)[NSDictionary dictionaryWithObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(NSString *)kSecValueData] );
	}
	else{
		NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, kSecValueData, nil] autorelease];
		NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, domain, domain, key, [value dataUsingEncoding:NSUTF8StringEncoding], nil] autorelease];
		
		NSDictionary * query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
		status = SecItemAdd( (CFDictionaryRef)query, NULL);
	}
}

+ (void)deleteValueForKey:(NSString *)key{
	[[ElongKeychain sharedInstance] deleteValueForKey:key andDomain:nil];
}

+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain
{
	[[ElongKeychain sharedInstance] deleteValueForKey:key andDomain:domain];
}

- (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain{
	if ( nil == key )
		return;

	if ( nil == domain ){
		domain = self.defaultDomain;
		if ( nil == domain ){
			domain = DEFAULT_DOMAIN;
		}
	}
	
	domain = [domain stringByAppendingString:[self appIdentifier]];
    
	NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil] autorelease];
	NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, key, domain, kCFBooleanTrue, nil] autorelease];
	
	NSDictionary * query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
	SecItemDelete( (CFDictionaryRef)query );
}

#pragma mark -
#pragma mark ElongCacheProtocol

- (BOOL)hasObjectForKey:(id)key{
	id obj = [self readValueForKey:key andDomain:nil];
	return obj ? YES : NO;
}

- (id)objectForKey:(id)key{
	return [self readValueForKey:key andDomain:nil];
}

- (void)setObject:(id)object forKey:(id)key{
//    if ([self hasObjectForKey:key]) {
//        [self removeObjectForKey:key];
//    }
	[self writeValue:object forKey:key andDomain:nil];
}

- (void)removeObjectForKey:(id)key{
	[self deleteValueForKey:key andDomain:nil];
}

- (void)removeAllObjects{
	// TODO:
}

- (id)objectForKeyedSubscript:(id)key{
	if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
		return nil;
    
	return [self readValueForKey:key andDomain:nil];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key{
	if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
		return;
	
	if ( nil == obj ){
		[self deleteValueForKey:key andDomain:nil];
	}
	else{
		[self writeValue:obj forKey:key andDomain:nil];
	}
}

#pragma mark -
#pragma mark AppIdentifier

- (NSString *)appIdentifier{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	static NSString * __identifier = nil;
	if ( nil == __identifier )
	{
		__identifier = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] retain];
	}
	return __identifier;
#else	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
	return @"";
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

#pragma mark -
#pragma mark ElongCacheDebugProtocol

- (NSString *) dataLogs{
    NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:kSecClassGenericPassword,kSecClass,
                           kSecMatchLimitAll,kSecMatchLimit,
                           kCFBooleanTrue,kSecReturnAttributes,nil];
    CFTypeRef result = nil;
    SecItemCopyMatching((CFDictionaryRef)query, &result);

    NSArray *keychainArray = (NSArray *)result;
    NSMutableArray *tkeychainArray = [NSMutableArray array];
    for (NSDictionary *dict in keychainArray) {
        NSMutableDictionary *tdict = [NSMutableDictionary dictionary];
        [tdict setObject:[dict objectForKey:@"acct"] forKey:@"acct"];
        [tdict setObject:[dict objectForKey:@"agrp"] forKey:@"agrp"];
        [tdict setObject:[dict objectForKey:@"labl"] forKey:@"labl"];
        [tdict setObject:[dict objectForKey:@"pdmn"] forKey:@"pdmn"];
        [tdict setObject:[dict objectForKey:@"svce"] forKey:@"svce"];
        [tdict setObject:[dict objectForKey:@"sync"] forKey:@"sync"];
        [tdict setObject:[dict objectForKey:@"tomb"] forKey:@"tomb"];
        [tkeychainArray addObject:tdict];
    }
    
    NSString *string =[tkeychainArray JSONStringWithOptions:JKSerializeOptionPretty error:NULL];
    return string;
}

- (NSArray *) allKeys{
    NSDictionary* query = [NSDictionary dictionaryWithObjectsAndKeys:kSecClassGenericPassword,kSecClass,
                           kSecMatchLimitAll,kSecMatchLimit,
                           kCFBooleanTrue,kSecReturnAttributes,kCFBooleanTrue,kSecReturnData,nil];
    CFTypeRef result = nil;
    SecItemCopyMatching((CFDictionaryRef)query, &result);
    
    NSArray *keychainArray = (NSArray *)result;
    NSMutableArray *tkeychainArray = [NSMutableArray array];
    for (NSDictionary *dict in keychainArray) {
        NSString * password = [[NSString alloc] initWithData:[dict objectForKey:@"v_Data"] encoding:NSUTF8StringEncoding];
        if ([dict objectForKey:@"acct"] && ![[dict objectForKey:@"acct"] isEqualToString:@""]) {
            [tkeychainArray addObject:[dict objectForKey:@"acct"]];
        }else if([dict objectForKey:@"gena"] && ![[dict objectForKey:@"gena"] isEqualToString:@""]){
            [tkeychainArray addObject:[dict objectForKey:@"gena"]];
        }
        NSLog(@"%@",password);
        [password autorelease];
    }
    return tkeychainArray;
}

- (NSArray *) allObjects{
    NSMutableArray *valueArray = [NSMutableArray array];
    NSArray *keyArray = [self allKeys];
    for (NSString *key in keyArray) {
        [valueArray addObject:[self objectForKey:key]];
    }
    return valueArray;
}


@end