//
//  TokenReq.h
//  ElongClient
//  与token相关的请求
//
//  Created by 赵 海波 on 13-9-3.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TokenReq : UIViewController
{
    @private
    HttpUtil *tokenUtil;                    // 获取所有的token
    HttpUtil *refreshTokenUtil;             // 使用refreshToken刷新accessToken
    
    BOOL showloadingView;                   // 是否弹框
}

+ (id)shared;

// 获取tokon接口，传入卡号、密码、type暂时都传为0
+ (NSString *)getTokenWithAuthorId:(NSString *)authorID
                         AuthorPwd:(NSString *)authorPwd
                        AuthorType:(NSInteger)authorType;

// 用长时效的token刷新短实效的token
+ (NSString *)refreshTokenWithRefreshToken:(NSString *)token;

// 获取跳入H5的url连接
+ (NSString *)getAppConfigWithAppKey:(NSString *)appKey;

- (id)init;
- (NSString *)accessToken;      // 获取accessToken的字符串
- (NSString *)refreshToken;
- (NSString *)getCashAccountHtml5LinkFromString:(NSString *)url;  // 从服务器返回的url替换参数得到实际的h5连接(现金账户有关部分)
- (NSString *)getOrderHtml5LinkFromString:(NSString *)url OrderNumber:(NSString *)order;  // 从服务器返回的url替换参数得到实际的h5连接(订单有关部分)
- (void) setToken:(NSDictionary *)tokenInfo;
- (void)requestTokenWithLoading:(BOOL)needLoading;    // 请求token(是否需要loading框)
- (void)clearAllToken;          // 清空所有token

@end
