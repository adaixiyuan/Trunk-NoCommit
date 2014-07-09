//
//  HtmlStandbyViewController.h
//  ElongClient
//  html紧急情况预备页
//
//  Created by 赵 海波 on 13-1-14.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HtmlStandbyViewController : DPNav <UIWebViewDelegate> {
@private
    UIWebView *web;
    
    SmallLoadingView *smallLoading;
    
    UIBarButtonItem *backItem;
    UIBarButtonItem *forwardItem;
}

- (id)initWithHotelOrder;               // 启动h5酒店订单流程
- (id)initWithHotelOrderwithHotelName:(NSString* )hotelname;               // 启动h5酒店订单流程
- (id)initWithFlightOrder;              // 启动h5机票订单流程
- (id)initWithGrouponOrder;             // 启动h5团购订单流程

@end
