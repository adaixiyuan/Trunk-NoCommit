//
//  WeixinOuthor.m
//  ElongClient
//
//  Created by Dawn on 14-4-29.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "WeixinOuthor.h"
#import "WeixinRequest.h"


#define m_type_weixinisbinding  141
#define m_type_weixinopenid     143

@interface WeixinOuthor(){
    int m_type;
}
@property (nonatomic,copy) NSString *openid;
@property (nonatomic,copy) NSDictionary *weixinInfo;
@end

@implementation WeixinOuthor

- (void) dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.delegate = nil;
    self.openid = nil;
    self.weixinInfo = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void) outhor{
    if ([[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_WEIXIN_OPENID]) {
        [self receiveWeixinOpenId:[[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_WEIXIN_OPENID]];
    }else{
        // 唤起微信进行授权
        SendAuthReq *req = [[[SendAuthReq alloc] init] autorelease];
        req.scope = @"snsapi_userinfo";
        req.state = @"weixin";
        [WXApi sendReq:req];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinOauth:) name:NOTI_WEIXIN_OAUTHSUCCESS object:nil];
    }
    

}

- (void) weixinOauth:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSString *code = [notification.userInfo objectForKey:@"code"];
    
    [self weixinOauthWithCode:code];
}


- (void) weixinOauthWithCode:(NSString *)code{
    m_type = m_type_weixinopenid;
    HttpUtil *weixinOpenIDUtil = [HttpUtil shared];
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WEIXIN_ID,WEIXIN_KEY,code];
    [weixinOpenIDUtil connectWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
}

- (void)receiveWeixinOpenId:(NSString *)openid{
    
    WeixinRequest *request = [[WeixinRequest alloc] init];
    request.openID = openid;
    NSString *url = [PublicMethods composeNetSearchUrl:@"user"
                                            forService:@"isBinding"
                                              andParam:[request requestForIsBinding]];
    [request release];
    HttpUtil *weixinIsBindingUtil = [HttpUtil shared];
    m_type = m_type_weixinisbinding;
    [weixinIsBindingUtil requestWithURLString:url Content:nil StartLoading:YES EndLoading:YES Delegate:self];
}

- (void)weixinHaveBindingWithToken:(NSDictionary *)token{
    [[ElongUserDefaults sharedInstance] setObject:self.openid forKey:USERDEFAULT_WEIXIN_OPENID];
    if ([self.delegate respondsToSelector:@selector(weixinOuthor:didGetToken:)]) {
        [self.delegate weixinOuthor:self didGetToken:token];
    }
}

- (void) weixinHavenotBinding{
    // 移除openid
    [[ElongUserDefaults sharedInstance] removeObjectForKey:USERDEFAULT_WEIXIN_OPENID];
    
    if (self.weixinInfo) {
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        WeixinLogin *weixinLogin = [[WeixinLogin alloc] initWithUserInfo:self.weixinInfo];
        weixinLogin.delegate = self;
        [delegate.navigationController pushViewController:weixinLogin animated:YES];
        [weixinLogin release];
    }else{
        // 唤起微信进行授权
        SendAuthReq *req = [[[SendAuthReq alloc] init] autorelease];
        req.scope = @"snsapi_userinfo";
        req.state = @"weixin";
        [WXApi sendReq:req];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinOauth:) name:NOTI_WEIXIN_OAUTHSUCCESS object:nil];
    }
}


#pragma mark -
#pragma mark WeixinLoginDelegate
- (void) weixinLogin:(WeixinLogin *)login didLoginWithLoginNo:(NSString *)loginNo password:(NSString *)password token:(NSDictionary *)token{
    // 登陆
    [[ElongUserDefaults sharedInstance] setObject:self.openid forKey:USERDEFAULT_WEIXIN_OPENID];
    if ([self.delegate respondsToSelector:@selector(weixinOuthor:didGetToken:)]) {
        [self.delegate weixinOuthor:self didGetToken:token];
    }
}


#pragma mark -
#pragma mark HttpUtilDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
    if (m_type == m_type_weixinopenid) {
        NSString *receiveString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary *infoDict = [receiveString JSONValue];
        NSString *openid = [infoDict objectForKey:@"openid"];
        
        self.openid = openid;
        self.weixinInfo = infoDict;
        
        [self receiveWeixinOpenId:openid];
        return;
    }
    if (m_type == m_type_weixinisbinding) {
        NSDictionary *infoDict = [PublicMethods unCompressData:responseData];
        if ([Utils checkJsonIsError:infoDict]) {
			return ;
		}
        BOOL isbinding = [[infoDict objectForKey:@"IsBind"] boolValue];
        if (isbinding) {
            [self weixinHaveBindingWithToken:infoDict];
        }else{
            [self weixinHavenotBinding];
        }
        return;
    }
}

@end
