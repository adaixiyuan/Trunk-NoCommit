//
//  TrainIdenfyCodeModel.m
//  ElongClient
//
//  Created by garin on 14-3-31.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TrainIdenfyCodeModel.h"

static NSMutableDictionary *identifyCodeData; //验证码Data

@implementation TrainIdenfyCodeModel

-(void) dealloc
{
    if (identifyCodeRequest)
    {
        [identifyCodeRequest cancel];
        SFRelease(identifyCodeRequest);
    }
    
    [super dealloc];
}

+(void) clearIdentifyCodeData
{
    [identifyCodeData release];
    identifyCodeData = nil;
}

//是否验证码请求已经收到
+(BOOL) isIdentifyCodeGetSuccess
{
    if ([identifyCodeData safeObjectForKey:@"isIdentifyCodeGetSuccess"])
    {
        return [[identifyCodeData safeObjectForKey:@"isIdentifyCodeGetSuccess"] boolValue];
    }
    
    return NO;
}

//是否验证码请求已经收到
+(BOOL) isNeedIdentifyCode
{
    if ([identifyCodeData safeObjectForKey:@"isNeedIdentifyCode"])
    {
        return [[identifyCodeData safeObjectForKey:@"isNeedIdentifyCode"] boolValue];
    }
    
    return NO;
}

//发送验证码请求
-(void) sendIdentifyCodeRequest
{
    if (!identifyCodeData)
    {
        identifyCodeData=[NSMutableDictionary dictionary];
        [identifyCodeData retain];
    }
    
    [identifyCodeData safeSetObject:[NSNumber numberWithBool:NO] forKey:@"isIdentifyCodeGetSuccess"];//验证码请求是否成功
    [identifyCodeData safeSetObject:[NSNumber numberWithBool:NO] forKey:@"isNeedIdentifyCode"];//是否需要验证码
    
    NSMutableDictionary  *dic = [NSMutableDictionary dictionary];
    [dic safeSetObject:Yihua_OTA forKey:@"wrapperId"];
    NSString  *str = [dic JSONString];
    NSString * reqStr = [PublicMethods composeNetSearchUrl:@"mytrain" forService:@"certCode" andParam:str];
    
    if (identifyCodeRequest)
    {
        [identifyCodeRequest cancel];
        SFRelease(identifyCodeRequest);
    }
    
    identifyCodeRequest = [[HttpUtil alloc] init];
    [identifyCodeRequest requestWithURLString:reqStr Content:nil StartLoading:NO EndLoading:NO Delegate:self];
}

#pragma mark - http

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util==identifyCodeRequest)
    {
        [identifyCodeData safeSetObject:[NSNumber numberWithBool:NO] forKey:@"isIdentifyCodeGetSuccess"];
    }
}


- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if (util==identifyCodeRequest)
    {
        [self handleIdentifyCode:root];
        return;
    }
}

//处理验证码请求
-(void) handleIdentifyCode:(NSDictionary *) root
{
    if ([Utils checkJsonIsErrorNoAlert:root])
    {
        [identifyCodeData safeSetObject:[NSNumber numberWithBool:NO] forKey:@"isIdentifyCodeGetSuccess"];
        return;
    }
    
    //开关关闭
    if ([[root safeObjectForKey:@"IsError"] boolValue])
    {
        [identifyCodeData safeSetObject:[NSNumber numberWithBool:NO] forKey:@"isNeedIdentifyCode"];
        [identifyCodeData safeSetObject:[NSNumber numberWithBool:YES] forKey:@"isIdentifyCodeGetSuccess"];
        return;
    }
    //开关关闭
    if (!STRINGHASVALUE([root safeObjectForKey:@"utoken"]))
    {
        [identifyCodeData safeSetObject:[NSNumber numberWithBool:NO] forKey:@"isNeedIdentifyCode"];
        [identifyCodeData safeSetObject:[NSNumber numberWithBool:YES] forKey:@"isIdentifyCodeGetSuccess"];
        return;
    }
    
    [identifyCodeData safeSetObject:[NSNumber numberWithBool:YES] forKey:@"isNeedIdentifyCode"];
    [identifyCodeData safeSetObject:[NSNumber numberWithBool:YES] forKey:@"isIdentifyCodeGetSuccess"];
}

@end
