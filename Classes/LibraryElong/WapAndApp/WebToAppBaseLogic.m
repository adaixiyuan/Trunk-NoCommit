//
//  WebToAppBase.m
//  ElongClient
//  webview to app 基类
//  Created by garin on 14-4-25.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "WebToAppBaseLogic.h"

@implementation WebToAppBaseLogic

-(void) dealloc
{
    [dictData release];
    
    [super dealloc];
}

static NSString *regexStr=@"(^|&)app=\\w+&?";

//处理数据（url）是入口
//queryString:url传递的参数
-(BOOL) convertQueryStringToDictionary:(NSString *) queryString
{
    if (!STRINGHASVALUE(queryString))
    {
        return NO;
    }
    
    if (![WebAppUtil isMatchRegex:queryString regexStr:regexStr])
    {
        return NO;
    }

    if (dictData)
    {
        [dictData release];
        dictData = nil;
    }
    
    dictData=[[WebAppUtil parseQueryString:queryString] retain];
    
    return YES;
}



#pragma mark -- 虚方法

//是否可以处理(子类实现)
-(BOOL) isCouldhanle
{
    return NO;
}

//处理数据(子类实现)
-(void) hanldeData
{
    
}

//完成后的回掉
-(void) invokeComplicatedDelegate
{
    if ([_delegate respondsToSelector:@selector(webToAppLogicIsComplicated:)])
    {
        [_delegate webToAppLogicIsComplicated:self];
    }
}
@end
