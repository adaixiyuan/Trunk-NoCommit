//
//  HomeAdWebViewController.h
//  ElongClient
//
//  Created by Dawn on 13-12-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "HotelOrderWebToAppLogic.h"
#import "WebToAppLogicProtocol.h"
#import "GrouponOrderWebToAppLogic.h"
#import "HomeAdNavi.h"

@interface HomeAdWebViewController : DPNav <UIWebViewDelegate,WebToAppLogicProtocol,HomeAdNaviDelegate>{
    UIWebView* myWebView;
	SmallLoadingView *smallLoading;
    int m_netstate;
    HotelOrderWebToAppLogic *hotelOderWebToAppLogic;
    GrouponOrderWebToAppLogic *grouponOrderWebToAppLogic;
    NSString *hotelOrderQueryString;
    NSString *grouponOrderQueryString;
}
@property (nonatomic,assign) BOOL isNavBarShow;
@property (nonatomic,assign) BOOL active;
- (id)initWithTitle:(NSString *)title targetUrl:(NSString *)url style:(NavBtnStyle )navStyle;

@end
