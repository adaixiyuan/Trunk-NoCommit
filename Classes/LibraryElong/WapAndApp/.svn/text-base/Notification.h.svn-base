//
//  Notification.h
//  ElongClient
//
//  Created by WangHaibin on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPNav.h"
#import "LoadingView.h"
#import "AppConfigRequest.h"

@interface Notification : DPNav<UIWebViewDelegate> {
	UIWebView *myWebView;
    NSString *nofistring;
	SmallLoadingView *smallLoading;
    HttpUtil *notificationRequest;
}

- (void) reloadWebView:(NSString *)urlStr;
-(void)shareWinXinWithContent:(NSDictionary *)content;
+(void)setWXInfoDict:(NSDictionary *)dic;
+(NSDictionary *)h5WXInfoDict;
+(Notification *)getCurrentNotiObj;
-(void)updateUIWithFrame:(CGRect)aFrame;

@end
