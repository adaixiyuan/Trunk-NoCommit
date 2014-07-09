//
//  HttpsDetection.m
//  ElongClient
//
//  Created by Dawn on 14-3-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HttpsDetection.h"
@interface HttpsDetection(){
@private

}
@property (nonatomic,retain) NSArray *dotNetHttps;
@property (nonatomic,retain) NSArray *javaHttps;
@end

static HttpsDetection *httpsDetection;
@implementation HttpsDetection

- (void) dealloc{
    self.dotNetHttps = nil;
    self.javaHttps = nil;
    [super dealloc];
}

- (id) init{
    if (self = [super init]) {
        self.dotNetHttps = nil;
        self.javaHttps = nil;
    }
    return self;
}

- (void) reset{
    if ([ProcessSwitcher shared].allowHttps) {
        self.dotNetHttps = [NSArray arrayWithObjects:
                            @"Account.aspx?action=Login",
                            @"Account.aspx?action=Regist",
                            @"Account.aspx?action=EditProfile",
                            @"GiftCard.aspx?action=VerifyCashAccountPwd",
                            @"GiftCard.aspx?action=SetCashAccountPwd",
                            @"MyElong.aspx?action=AddCreditCard",
                            @"MyElong.aspx?action=ModifyCreditCard",
                            @"MyElong.aspx?action=GetCreditCardHistory",
                            @"Hotel.aspx?action=GeneratHotelOrder",
                            @"GlobalHotel.aspx?action=GlobalHotelCreateOrder",
                            @"Groupon.aspx?action=CreateOrder",
                            @"Flight.aspx?action=GenerateFlightOrder",nil];
        
        self.javaHttps = [NSArray arrayWithObjects:
                          @"user/login",
                          @"user/regist",
                          @"user/editProfile",
                          @"myelong/creditCard",
                          @"myelong/creditCardHistory",
                          @"hotel/generateHotelOrder",
                          @"globalHotel/createOrder",
                          @"tuan/createOrder", nil];
    }else{
        self.dotNetHttps = nil;
        self.javaHttps = nil;
    }
    
    if (![[ServiceConfig share] httpsSwitch]) {
        self.dotNetHttps = nil;
        self.javaHttps = nil;
    }
}

+ (HttpsDetection *) sharedInstance{
    if (!httpsDetection) {
        httpsDetection = [[HttpsDetection alloc] init];
    }
    
    [httpsDetection reset];
    
    return httpsDetection;
}

- (NSString *) dotNetHttpsDetectionWithUrl:(NSString *)furl content:(NSString *)content{
    NSString *url = [NSString stringWithFormat:@"%@",furl];
    if ([url rangeOfString:DEFAULT_SERVER].length != DEFAULT_SERVER.length) {
        // 测试环境不做处理
        return [NSString stringWithFormat:@"%@",url];
    }
    NSString *detection = @"";
    if (content) {
        detection = [NSString stringWithFormat:@"%@?%@",url,content];
    }else{
        detection = [NSString stringWithFormat:@"%@",url];
    }
    
    for (NSString *action in self.dotNetHttps) {
        NSRange range = [detection rangeOfString:action options:NSCaseInsensitiveSearch];
        if (range.length == action.length) {
            // 切换HTTPS Server
            url = [url stringByReplacingOccurrencesOfString:DEFAULT_SERVER withString:DEFAULT_HTTPS_SERVER];
            
            if ([url rangeOfString:@"https"].length == @"https".length) {
                return url;
            }else{
                return [url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            }
        }
    }
    return [NSString stringWithFormat:@"%@",url];
}

- (NSString *) javaHttpsDetectionWithUrl:(NSString *)furl{
    NSString *url = [NSString stringWithFormat:@"%@",furl];
    if ([url rangeOfString:DEFAULT_SERVER].length != DEFAULT_SERVER.length) {
        // 测试环境不做处理
        return [NSString stringWithFormat:@"%@",url];
    }
    for (NSString *action in self.javaHttps) {
        NSRange range = [url rangeOfString:action options:NSCaseInsensitiveSearch];
        if (range.length == action.length) {
            // 切换HTTPS Server
            url = [url stringByReplacingOccurrencesOfString:DEFAULT_SERVER withString:DEFAULT_HTTPS_SERVER];
            
            if ([url rangeOfString:@"https"].length == @"https".length) {
                return url;
            }else{
                return [url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            }
        }
    }
    return [NSString stringWithFormat:@"%@",url];
}

- (BOOL) isHttpsRequestUrl:(NSString *)url{
    NSRange range = [url rangeOfString:@"https" options:NSCaseInsensitiveSearch];
    if (range.length == @"https".length && range.location == 0) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL) isHttpsRequest:(NSURLRequest *)request{
    NSRange range = [[request.URL absoluteString] rangeOfString:@"https" options:NSCaseInsensitiveSearch];
    if (range.length == @"https".length && range.location == 0) {
        return YES;
    }else{
        return NO;
    }
}
@end
