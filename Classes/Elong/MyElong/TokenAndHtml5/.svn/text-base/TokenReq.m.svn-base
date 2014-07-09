//
//  TokenReq.m
//  ElongClient
//
//  Created by 赵 海波 on 13-9-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TokenReq.h"
#import "PostHeader.h"
#import "TokenConfig.h"
#import "Utils.h"
#import "ElongURL.h"

#define TOKEN_LEFT_TIME     1800            // token预留有效时间

static TokenReq *request = nil;

@interface TokenReq ()

@property (nonatomic, copy) NSString *accessToken;      // 访问html5的token
@property (nonatomic, copy) NSString *refreshToken;     // 用于刷新access的token
@property (nonatomic, assign) NSInteger accessTokenOutTime;     // accessToken过期时间
@property (nonatomic, assign) NSInteger refreshTokenOutTime;    // refreshToken过期时间

@end

@implementation TokenReq

@synthesize accessToken;
@synthesize refreshToken;
@synthesize accessTokenOutTime;
@synthesize refreshTokenOutTime;

- (void)dealloc
{
    [tokenUtil cancel];
    SFRelease(tokenUtil);
    
    self.accessToken = nil;
    self.refreshToken = nil;
    
    [super dealloc];
}


+ (id)shared
{
    @synchronized(request)
    {
		if (!request)
        {
			request = [[TokenReq alloc] init];
		}
	}
	
	return request;
}


+ (NSString *)getTokenWithAuthorId:(NSString *)authorID
                         AuthorPwd:(NSString *)authorPwd
                        AuthorType:(NSInteger)authorType
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
    [content setValue:authorID forKey:AUTHOR_ID];
    [content setValue:authorPwd forKey:AUTHOR_PWD];
    [content setValue:authorType forKey:AUTHOR_TYPE];
	
	return [NSString stringWithFormat:@"action=GetToken&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)refreshTokenWithRefreshToken:(NSString *)token
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
    [content setValue:token forKey:REFRESH_TOKEN];
	
	return [NSString stringWithFormat:@"action=RefreshToken&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)getAppConfigWithAppKey:(NSString *)appKey
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setObject:[PostHeader header] forKey:Resq_Header];
    [content setObject:appKey forKey:APP_KEY];
	
     return [NSString stringWithFormat:@"action=GetAppConfig&version=1.2&compress=true&req=%@",
             [content JSONRepresentationWithURLEncoding]];
}


- (id)init
{
    if (self = [super init])
    {
        showloadingView = NO;
    }
    return self;
}


- (NSString *)accessToken
{
    NSDictionary *accessTokenDic = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    if (DICTIONARYHASVALUE(accessTokenDic)){
        self.accessTokenOutTime = [[NSUserDefaults standardUserDefaults] objectForKey:EXPIRES_TIME];
        // 不检测过期时间
        if (self.accessTokenOutTime <= 0) {
            self.accessToken = [[accessTokenDic allKeys] objectAtIndex:0];
            return accessToken;
        }
        
        NSDate *accessTokenOutDate =  [[accessTokenDic allValues] safeObjectAtIndex:0];
        // 如果存在accessToken，校验它的时效性
        if ([[NSDate date] timeIntervalSinceDate:accessTokenOutDate] <= accessTokenOutTime){
            // 有accesstoken且未超时,用这个token,其它情况一律都返回nil
            self.accessToken = [[accessTokenDic allKeys] objectAtIndex:0];
            return accessToken;
        }
    }
    
    return nil;
}


- (NSString *)refreshToken
{
    NSDictionary *refreshTokenDic = [[NSUserDefaults standardUserDefaults] objectForKey:REFRESH_TOKEN];
    if (DICTIONARYHASVALUE(refreshTokenDic))
    {
        NSDate *refreshTokenOutDate =  [[refreshTokenDic allValues] safeObjectAtIndex:0];
        self.refreshTokenOutTime = [[NSUserDefaults standardUserDefaults] objectForKey:REEXPIRES_TIME];
        // 如果存在refreshToken，校验它的时效性
        if ([[NSDate date] timeIntervalSinceDate:refreshTokenOutDate] <= self.refreshTokenOutTime)
        {
            // 有refrshtoken且未超时,用这个token,其它情况一律都返回nil
            self.refreshToken = [[refreshTokenDic allKeys] objectAtIndex:0];
            return refreshToken;
        }
    }
    
    return @"";
}


- (NSString *)getCashAccountHtml5LinkFromString:(NSString *)url
{
    if (STRINGHASVALUE(url))
    {
        url = [url stringByReplacingOccurrencesOfString:@"{0}" withString:@"1"];
        url = [self replaceCommonParameterFromString:url];
    }
    
    return url;
}


- (NSString *)getOrderHtml5LinkFromString:(NSString *)url OrderNumber:(NSString *)order
{
    if (STRINGHASVALUE(url))
    {
        url = [url stringByReplacingOccurrencesOfString:@"{0}" withString:order];
        url = [self replaceCommonParameterFromString:url];
    }
    
    return url;
}


- (NSString *)replaceCommonParameterFromString:(NSString *)url
{
    if (url)
    {
        url = [url stringByReplacingOccurrencesOfString:@"{1}" withString:[self accessToken]];
        url = [url stringByReplacingOccurrencesOfString:@"{2}" withString:[self refreshToken]];
        url = [url stringByReplacingOccurrencesOfString:@"{3}" withString:[[AccountManager instanse] cardNo]];
        url = [url stringByReplacingOccurrencesOfString:@"{4}" withString:CHANNELID];
        url = [url stringByReplacingOccurrencesOfString:@"{5}" withString:@"1"];
        url = [url stringByReplacingOccurrencesOfString:@"{6}" withString:[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] safeObjectForKey:@"CFBundleVersion"]]];
        url = [url stringByReplacingOccurrencesOfString:@"{7}" withString:@"1"];
    }
    
    return url;
}

- (void) setToken:(NSDictionary *)tokenInfo{
    if ([tokenInfo safeObjectForKey:ACCESS_TOKEN]) {
        self.accessToken = [tokenInfo safeObjectForKey:ACCESS_TOKEN];
    }else{
        self.accessToken = @"";
    }
    if ([tokenInfo safeObjectForKey:EXPIRES_TIME]) {
        self.accessTokenOutTime = [tokenInfo safeObjectForKey:EXPIRES_TIME];
    }else{
        self.accessTokenOutTime = 0;
    }
    if ([tokenInfo safeObjectForKey:REFRESH_TOKEN]) {
        self.refreshToken = [tokenInfo safeObjectForKey:REFRESH_TOKEN];
    }else{
        self.refreshToken = @"";
    }
    if ([tokenInfo safeObjectForKey:REEXPIRES_TIME]) {
        self.refreshTokenOutTime = [tokenInfo safeObjectForKey:REEXPIRES_TIME];
    }else{
        self.refreshTokenOutTime = 0;
    }
    
    NSLog(@"accessToken=%@ \n refreshToken=%@", accessToken, refreshToken);
    
    // 记录一下获取token的时间
    NSDictionary *accessTokenDic = [NSDictionary dictionaryWithObject:[NSDate date] forKey:accessToken];
    NSDictionary *refreshTokenDic = [NSDictionary dictionaryWithObject:[NSDate date] forKey:refreshToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:accessTokenDic forKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:refreshTokenDic forKey:REFRESH_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:refreshTokenOutTime forKey:REEXPIRES_TIME];
    [[NSUserDefaults standardUserDefaults] setObject:accessTokenOutTime forKey:EXPIRES_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)requestTokenWithLoading:(BOOL)needLoading
{
    showloadingView = needLoading;
    
    if (STRINGHASVALUE([self accessToken]))
    {
        // 存在accessToken，不做任何操作
        return;
    }
    
    // 取refreshToken
    if (STRINGHASVALUE([self refreshToken]))
    {
        if (refreshTokenUtil)
        {
            [refreshTokenUtil cancel];
            SFRelease(refreshTokenUtil);
        }
        // 如果refreshToken存在，就用它刷新accessToken
        refreshTokenUtil = [[HttpUtil alloc] init];
        [refreshTokenUtil connectWithURLString:AUTHORIZE_SEARCH
                                       Content:[TokenReq refreshTokenWithRefreshToken:refreshToken]
                                  StartLoading:needLoading
                                    EndLoading:needLoading
                                      Delegate:self];
        return;
    }
    else
    {
        // 没有refreshToken或者refreshToken过期的情况，重新请求refreshToken和accessToken
        if (tokenUtil) {
            [tokenUtil cancel];
            SFRelease(tokenUtil);
        }
        tokenUtil = [[HttpUtil alloc] init];
        [tokenUtil connectWithURLString:AUTHORIZE_SEARCH
                                Content:[TokenReq getTokenWithAuthorId:[[AccountManager instanse] cardNo]
                                                             AuthorPwd:[[AccountManager instanse] password]
                                                            AuthorType:0]
                           StartLoading:needLoading
                             EndLoading:needLoading
                               Delegate:self];
    }
}


- (void)clearAllToken
{
    self.accessToken = nil;
    self.refreshToken = nil;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:REFRESH_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    if (showloadingView)
    {
        // 有弹框的情况下
        if ([Utils checkJsonIsError:root])
        {
            return ;
        }
        
        // 获取token成功，发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_GET_TOKEN object:nil];
    }
    else
    {
        // 没有弹框的情况下，不提示错误
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            return ;
        }
    }
    
    // 设置token
    [self setToken:root];
}


- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    // 单例类被取消后没有影响，不做操作
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    // 请求失败没有影响，不做操作
}

@end
