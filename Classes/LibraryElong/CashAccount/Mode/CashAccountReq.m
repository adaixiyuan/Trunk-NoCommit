//
//  CashAccountReq.m
//  ElongClient
//  现金账户请求
//
//  Created by 赵 海波 on 13-7-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CashAccountReq.h"
#import "PostHeader.h"
#import "CashAccountConfig.h"
#import "AccountManager.h"
#import "StringEncryption.h"

static CashAccountReq *request = nil;

@implementation CashAccountReq

- (void)dealloc {
    [super dealloc];
}

+ (id)shared
{
    @synchronized(request)
    {
		if (!request)
        {
			request = [[CashAccountReq alloc] init];
		}
	}
	
	return request;
}


+ (NSString *)getCashAmountByBizType:(BizType)type
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	[content setValue:[[AccountManager instanse] cardNo] forKey:MEMBER_CARD_NO];
	[content setValue:[NSNumber numberWithInt:type] forKey:BIZ_TYPE];
	
	return [NSString stringWithFormat:@"action=GetCashAmountByBizType&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)getRechargeVCode
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	[content setValue:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
	
	return [NSString stringWithFormat:@"action=GetRechargeVCode&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)verifyRechargeCheckCodeWithCode:(NSString *)code
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	[content setValue:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
    [content setValue:code forKey:CODE];
	
	return [NSString stringWithFormat:@"action=VerifyRechargeCheckCode&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)newGiftCardRecharge:(NSString *)cardNO GiftCardPwd:(NSString *)password GraphCode:(NSString *)checkCode
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	[content setValue:[StringEncryption EncryptString:cardNO] forKey:GIFT_CARD_NO];
    [content setValue:[StringEncryption EncryptString:password] forKey:GIFT_CARD_PWD];
    [content setValue:checkCode forKey:GRAPH_CODE];
    [content setValue:[[AccountManager instanse] cardNo] forKey:MEMBER_CARD_NO];
	
    NSLog(@"NewGiftCardRecharge:%@", content);
	return [NSString stringWithFormat:@"action=NewGiftCardRecharge&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)verifyCashAccountPwdWithPwd:(NSString *)password
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
    [content setValue:[StringEncryption EncryptString:password] forKey:PWD];
    [content setValue:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
	
	return [NSString stringWithFormat:@"action=VerifyCashAccountPwd&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)getIncomeRecord
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	[content setValue:[[AccountManager instanse] cardNo] forKey:@"CardNo"];
    [content setValue:@"256" forKey:@"PageSize"];
    [content setValue:@"0" forKey:@"PageIndex"];
    [content setValue:[NSNull null] forKey:@"Pwd"];
	
	return [NSString stringWithFormat:@"action=GetIncomeRecord&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


+ (NSString *)sendCheckCodeSmsWithMobileNo:(NSString *)mobile
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	[content setValue:mobile forKey:MOBILE_NO];
    [content setValue:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
	
	return [NSString stringWithFormat:@"action=SendCheckCodeSms&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}

+ (NSString *)verifySmsCheckCodeWithMobileNo:(NSString *)mobile Code:(NSString *)code
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
	[content setValue:mobile forKey:MOBILE_NO];
    [content setValue:code forKey:CODE];
    [content setValue:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
	
	return [NSString stringWithFormat:@"action=VerifySmsCheckCode&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}

+ (NSString *)setCashAccountPwdWithPwd:(NSString *)password NewPwd:(NSString *)newPassword SetType:(int)type
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
    [content setValue:[NSString stringWithFormat:@"%d", type] forKey:SETTYPE];
    [content setValue:[StringEncryption EncryptString:password] forKey:PWD];
    [content setValue:[[AccountManager instanse] cardNo] forKey:CARD_NUMBER];
    
	return [NSString stringWithFormat:@"action=SetCashAccountPwd&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}

+ (NSString *)getCashAmountUsageDetailReq
{
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    [content setValue:[PostHeader header] forKey:Resq_Header];
    [content setValue:[[AccountManager instanse] cardNo] forKey:MEMBER_CARD_NO];
	
	return [NSString stringWithFormat:@"action=GetCashAmountUsageDetail&version=1.2&compress=true&req=%@",
			[content JSONRepresentationWithURLEncoding]];
}


- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}


@end
