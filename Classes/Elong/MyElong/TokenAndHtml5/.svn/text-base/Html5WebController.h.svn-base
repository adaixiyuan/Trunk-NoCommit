//
//  Html5WebController.h
//  ElongClient
//  h5相关功能（提现、充值、修改订单等）入口功能
//
//  Created by 赵 海波 on 13-9-5.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPNav.h"

typedef enum {
    CASH_BACK,           //银行卡提现
    HOTEL_MODIFYORDER,      //修改订单
    HOTEL_FEEDBACK      //酒店入住反馈
}H5Type;

@interface Html5WebController : DPNav <UIWebViewDelegate>
{
    UIWebView* myWebView;
	
	SmallLoadingView *smallLoading;				// 地图模式loading框
    
    BOOL modifySuccess;                 // 修改订单是否成功
    H5Type fromType;        //来源
}

- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url;
- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url style:(NavBtnStyle )navStyle;
- (id)initWithTitle:(NSString *)title Html5Link:(NSString *)url FromType:(H5Type)type;

@end
