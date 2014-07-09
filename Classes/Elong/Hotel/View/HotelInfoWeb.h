//
//  HotelInfoWeb.h
//  ElongClient
//  用于显示酒店详情信息的页面
//
//  Created by 赵 海波 on 13-7-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    HotelInfoTypeNative,            // 国内酒店
    HotelInfoTypeInterIntro,        // 国际酒店简介
    HotelInfoTypeInterAround,       // 国际酒店周边
    HotelInfoTypeInterService,      // 国际酒店服务
    HotelInfoTypeInterOther,        // 国际酒店其它
    HotelInfoTypeNativeFromGroupon,  //从团购到国内酒店
    HotelInfoTypeNativeFromXGHomeDetail,  //从商品特惠详情到国内酒店;   by lc
}HotelInfoType;

@interface HotelInfoWeb : UIWebView <UIWebViewDelegate> {
//    NSDictionary *hotelDic;
    NSString *contentHtml;
    
    BOOL firstLoadingHtml;              // 是否是第一次loading html
}

@property (nonatomic,retain) NSDictionary *hotelDic;

// 根据详情类型来显示相应的数据
- (void)reloadDataByType:(HotelInfoType)type;

@end
