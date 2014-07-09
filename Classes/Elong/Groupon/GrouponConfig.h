//
//  GrouponConfig.h
//  ElongClient
//  定义一些团购的宏、常量和枚举
//
//  Created by 赵 海波 on 14-1-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

typedef enum {
    GrouponOrderPayTypeCreditCard = 0,  // 信用卡支付
    GrouponOrderPayTypeAlipay = 1,      // 支付宝客户端支付
    GrouponOrderPayTypeWeixin = 3       // 微信支付
}GrouponOrderPayType;   // 团购支付类型


typedef enum {
    WeiXinPayMethodJS = 0,       // 微信JS
    WeiXinPayMethodNative = 1,   // 微信native
    WeiXinPayMethodApp = 2,      // 微信APP方式
    WeiXinPayMethodWEB = 3       // 微信WEB扫描
}WeiXinPayMethod;   // 微信支付方式

//预约酒店对话框的tag
#define UIActionSheetTag1  399991
#define UIActionSheetTag2  399992
#define UIActionSheetTag3  399993
#define UIActionSheetTag4  399994
#define UIActionSheetTag5  399995
#define UIActionSheetTag6  399996