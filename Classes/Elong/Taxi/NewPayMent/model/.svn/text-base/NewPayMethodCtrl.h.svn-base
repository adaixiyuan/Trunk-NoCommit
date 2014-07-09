//
//  NewPayMethodCtrl.h
//  ElongClient
//
//  Created by nieyun on 14-4-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    NewUniformPaymentTypeNone = -1,            // 没有选择任何支付类型
    NewUniformPaymentTypeCreditCard = 0,       // 信用卡支付
    NewUniformPaymentTypeDepositCard = 1,      // 储蓄卡支付
    NewUniformPaymentTypeWeixin = 2,           // 微信支付
    NewUniformPaymentTypeAlipay = 3,           // 支付宝客户端支付
    NewUniformPaymentTypeAlipayWap = 4         // 支付宝网页支付
}   NewUniformPaymentType;




typedef enum
{
    RENT_TYPE = 1011
} CHANEL_TYPE;
@interface NewPayMethodCtrl : UIViewController <HttpUtilDelegate>
{
       HttpUtil  *typeUtil;
       NSDictionary  *tDic;;
}
@property  (nonatomic,retain) NSArray  *modelAr;
- (void) goChannel:(NSInteger ) bizType  andDic:(NSDictionary  *) topDic;

+ (NewUniformPaymentType) checkAllModel:(NSIndexPath *) indexPath  andModelAr:(NSArray *)modelAr;
+ (NSArray *)getBankList:(NSArray *)modelAr;
+(NSMutableArray  *)credictCardList;

@end
