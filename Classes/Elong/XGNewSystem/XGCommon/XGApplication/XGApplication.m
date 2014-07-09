//
//  XGApplication.m
//  ElongClient
//
//  Created by guorendong on 14-4-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGApplication.h"
@interface XGApplication()

@property(nonatomic,strong)NSMutableDictionary *dic;//存放字典

@end
//单例模式
static XGApplication *app=nil;

@implementation XGApplication

-(void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)notifactionName  object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:notifactionName object:anObject];
}
- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:anObject];
}


-(void)addObserver:(SEL)selector name:(NSString *)notifactionName   object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notifactionName object:anObject];
}

- (void)removeObserver:(NSString *)notifactionName   object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notifactionName object:anObject];
}
-(void)clearAllMemory//等于恢复的初始化
{
    [self.dic removeAllObjects];
    [self removeObserver:nil object:nil];
}

#pragma mark --属性实现
@synthesize dic=_dic;
-(NSMutableDictionary *)dic
{
    if (_dic==nil) {
        _dic=[[NSMutableDictionary alloc] init];
    }
    return _dic;
}

#pragma mark --方法实现

-(void)setObject:(id)value forKey:(NSString *)key
{
    if (value) {
        [self.dic setObject:value forKey:key];
    }
}
-(id)objectForKey:(NSString *)key
{
    return [self.dic objectForKey:key];
}

#pragma mark --单例实现
+(XGApplication *)shareApplication
{
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        app=[[super allocWithZone:NULL] init];
    });
    return app;
}


-(id)init
{
    self=[super init];
    if (self) {
        
    }
    return self;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self shareApplication];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
