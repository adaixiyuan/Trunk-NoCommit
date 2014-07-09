//
//  CashAccountReq.h
//  ElongClient
//
//  Created by 赵 海波 on 13-7-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    BizTypeMyelong = 0,                     // myelong
    BizTypeWithdraw = 1,                    // 提现
    BizTypeMobileCharges = 2,               // 手机充值
    BizTypeDomesticGuaranteeHotel = 1001,   // 国内担保酒店
    BizTypeFilghts = 1002,                  // 机票
    BizTypeInternationalHotel = 1003,       // 国际酒店
    BizTypeDomesticPrepayHotel = 1005,      // 预付酒店
    BizTypeGroupon = 1006                   // 提现
}BizType;       // 业务类型

@interface CashAccountReq : NSObject

@property (nonatomic, assign) BOOL needPassword;            // 现金账户是否需要支付密码
@property (nonatomic, assign) CGFloat cashAccountRemain;    // 现金账户余额

+ (id)shared;
+ (NSString *)getCashAmountByBizType:(BizType)type;         // 请求现金账户余额，是否可用
+ (NSString *)getRechargeVCode;                             // 请求礼品卡充值验证码
+ (NSString *)verifyRechargeCheckCodeWithCode:(NSString *)code;         // 验证礼品卡充值验证码
+ (NSString *)newGiftCardRecharge:(NSString *)cardNO
                      GiftCardPwd:(NSString *)password
                        GraphCode:(NSString *)checkCode;      // 礼品卡充值
+ (NSString *)verifyCashAccountPwdWithPwd:(NSString *)password;         // 验证CA支付密码
+ (NSString *)getIncomeRecord;
+ (NSString *)sendCheckCodeSmsWithMobileNo:(NSString *)mobile;          // 发送短信验证码
+ (NSString *)verifySmsCheckCodeWithMobileNo:(NSString *)mobile Code:(NSString *)code;  // 校验短信验证码
+ (NSString *)setCashAccountPwdWithPwd:(NSString *)password
                                NewPwd:(NSString *)newPassword
                               SetType:(int)type;                // 设置支付密码
+ (NSString *)getCashAmountUsageDetailReq;                       // 获取ca余额详情

@end
