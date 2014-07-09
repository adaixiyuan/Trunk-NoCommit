//
//  ElongSingleton.h
//  ElongFramework
//
//  Created by Dawn on 14-2-22.
//  Copyright (c) 2014年 Dawn. All rights reserved.
//

#if __has_feature(objc_instancetype)

    #undef	AS_SINGLETON
    #define AS_SINGLETON

    #undef	AS_SINGLETON
    #define AS_SINGLETON( ... ) \
        - (instancetype)sharedInstance; \
        + (instancetype)sharedInstance;

    #undef	DEF_SINGLETON
    #define DEF_SINGLETON \
        - (instancetype)sharedInstance \
        { \
            return [[self class] sharedInstance]; \
        } \
        + (instancetype)sharedInstance \
        { \
            static dispatch_once_t once; \
            static id __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; [[ElongSingleton singletonSet] addObject:__singleton__];} ); \
            return __singleton__; \
        }

    #undef	DEF_SINGLETON
    #define DEF_SINGLETON( ... ) \
        - (instancetype)sharedInstance \
        { \
            return [[self class] sharedInstance]; \
        } \
        + (instancetype)sharedInstance \
        { \
            static dispatch_once_t once; \
            static id __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; [[ElongSingleton singletonSet] addObject:__singleton__];} ); \
            return __singleton__; \
        }

#else	// #if __has_feature(objc_instancetype)

    #undef	AS_SINGLETON
    #define AS_SINGLETON( __class ) \
    - (__class *)sharedInstance; \
    + (__class *)sharedInstance;

    #undef	DEF_SINGLETON
    #define DEF_SINGLETON( __class ) \
    - (__class *)sharedInstance \
    { \
        return [__class sharedInstance]; \
    } \
    + (__class *)sharedInstance \
    { \
        static dispatch_once_t once; \
        static __class * __singleton__; \
        dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; [[ElongSingleton singletonSet] addObject:__singleton__];} ); \
        return __singleton__; \
    }

#endif	// #if __has_feature(objc_instancetype)

#import <Foundation/Foundation.h>
#import "ElongCacheDebugProtocol.h"

@interface ElongSingleton : NSObject<ElongCacheDebugProtocol>
+ (NSMutableArray *) singletonSet;
AS_SINGLETON( ElongSingleton )
@end

