//
//  XGApplication.h
//  ElongClient
//
//  Created by guorendong on 14-4-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
//单例模式
//ARC
@interface XGApplication : NSObject

+(XGApplication *)shareApplication;

-(void)setObject:(id)value forKey:(NSString *)key;

-(id)objectForKey:(NSString *)key;
//增加监听
-(void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notifactionName   object:(id)anObject;
//删除监听
- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject;

-(void)addObserver:(SEL)selector name:(NSString *)notifactionName   object:(id)anObject;

- (void)removeObserver:(NSString *)notifactionName   object:(id)anObject;

-(void)clearAllMemory;//等于恢复的初始化

@end
