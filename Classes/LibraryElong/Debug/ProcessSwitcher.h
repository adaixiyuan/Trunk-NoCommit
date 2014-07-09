//
//  ProcessSwitcher.h
//  ElongClient
//
//  Created by 赵 海波 on 13-1-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessSwitcher : NSObject

@property (nonatomic) BOOL allowNonmember;				// 是否开放非用户流程
@property (nonatomic) BOOL allowAlipayForFlight;		// 是否允许机票支付宝支付
@property (nonatomic) BOOL allowAlipayForGroupon;		// 是否允许团购支付宝支付
@property (nonatomic) BOOL hotelPassOn;                 // 酒店passbook功能开关
@property (nonatomic) BOOL grouponPassOn;               // 团购passbook功能开关
@property (nonatomic) BOOL hotelHtml5On;                // 酒店h5开关
@property (nonatomic) BOOL grouponHtml5On;              // 团购h5开关
@property (nonatomic) BOOL flightHtml5On;               // 机票h5开关
@property (nonatomic, readonly) BOOL dataOutTime;       // 数据是否过期
@property (nonatomic, retain) NSDate *getDate;          // 获取数据的时间
@property (nonatomic) BOOL allowIFlyMSC;                // 是否启用语音搜索
@property (nonatomic) BOOL allowHttps;                  // 是否启用HTTPS加密
@property (nonatomic) BOOL showC2CInHotelSearch;        //
@property (nonatomic) BOOL showC2COrder;                // 

+ (ProcessSwitcher *)shared;

@end
