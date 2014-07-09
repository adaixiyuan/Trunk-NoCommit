//
//  NSNull+Utility.m
//  ElongClient
//
//  Created by bruce on 13-9-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "NSNull+Utility.h"
#import <objc/runtime.h>

@implementation NSNull (Utility)

#if NULLSAFE_ENABLED

// 要将一条消息转发给另外一个对象，必须修改该消息的签名，即将该消息伪装成另外一个对象的消息
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    @synchronized([self class])
    {
        // 寻找方法签名
        NSMethodSignature *signature = [super methodSignatureForSelector:selector];
        if (!signature)
        {
            // 查找支持当前签名的类对象 
            static NSMutableSet *classList = nil;
            static NSMutableDictionary *signatureCache = nil;
            if (signatureCache == nil)
            {
                classList = [[NSMutableSet alloc] init];
                signatureCache = [[NSMutableDictionary alloc] init];
                
                // 获取子类
                int numClasses = objc_getClassList(NULL, 0);  // 获取所有子类个数
                Class *classes = (Class *)malloc(sizeof(Class) * numClasses);
                numClasses = objc_getClassList(classes, numClasses);
                
                // 建立对象列表为后续检验做准备
                NSMutableSet *excluded = [NSMutableSet set];
                for (int i = 0; i < numClasses; i++)
                {
                    // 循环检验class的父类
                    BOOL isNSObject = NO;
                    Class class = classes[i];
                    Class superClass = class_getSuperclass(class);
                    while (superClass)
                    {
                        if (superClass == [NSObject class])
                        {
                            isNSObject = YES;
                            break;
                        }
                        Class next = class_getSuperclass(superClass);
                        if (next) [excluded addObject:superClass];
                        superClass = next;
                    }
                    
                    // 只添加父类是NSObject的类
                    if (isNSObject)
                    {
                        [classList addObject:class];
                    }
                }
                
                // 去除检验过程中添加的中间类对象
                for (Class class in excluded)
                {
                    [classList removeObject:class];
                }
                
                // 释放类列表占用的空间
                free(classes);
            }
            
            // 校验支持当前方法实现的类
            NSString *selectorString = NSStringFromSelector(selector);
            signature = [signatureCache objectForKey:selectorString];
            if (!signature)
            {
                // 寻找方法的实现
                for (Class class in classList)
                {
                    if ([class instancesRespondToSelector:selector])
                    {
                        // 从类中请求实例方法签名
                        signature = [class instanceMethodSignatureForSelector:selector];
                        break;
                    }
                }
                
                // 为下次操作做缓存
                [signatureCache setObject:signature ?: [NSNull null] forKey:selectorString];
            }
            else if ([signature isKindOfClass:[NSNull class]])
            {
                signature = nil;
            }
        }
        return signature;
    }
}

// 当一个对象确定无法处理消息时，才会调用此方法
- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:nil];
}

#endif

@end
