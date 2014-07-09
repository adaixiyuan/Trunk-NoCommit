//
//  ElongKeychain.h
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElongCacheProtocol.h"
#import "ElongSingleton.h"
#import "ElongCacheDebugProtocol.h"

@interface ElongKeychain : NSObject<ElongCacheProtocol,ElongCacheDebugProtocol>

@property (nonatomic, retain) NSString * defaultDomain;

AS_SINGLETON( ElongKeychain )

+ (void)setDefaultDomain:(NSString *)domain;

+ (NSString *)readValueForKey:(NSString *)key;
+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;

+ (void)writeValue:(NSString *)value forKey:(NSString *)key;
+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;

+ (void)deleteValueForKey:(NSString *)key;
+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain;

@end
