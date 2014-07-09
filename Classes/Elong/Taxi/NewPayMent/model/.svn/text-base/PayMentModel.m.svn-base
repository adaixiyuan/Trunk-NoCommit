//
//  GetPayProdsResp.m
//  ElongClient
//
//  Created by nieyun on 14-4-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PayMentModel.h"

@implementation GetPayProdsResp
- (void) dealloc
{
    [super dealloc];
    [_ErrorMessage  release];
    [_ErrorCode  release];
    [_paymentTags  release];
}

- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    NSMutableArray  *modelAr = [NSMutableArray  array];
    
    for (NSDictionary  *dic in [dataDic  safeObjectForKey:@"paymentTags"])
    {
        PaymentTag  *tagModel = [[PaymentTag alloc]initWithDataDic:dic];
        [modelAr  addObject:tagModel];
        [tagModel  release];
    }
    self.paymentTags = (NSArray *) modelAr;
}
@end


@implementation PaymentTag
- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    NSMutableArray  *modelAr = [NSMutableArray  array];
    
    for (NSDictionary  *dic in [dataDic  safeObjectForKey:@"paymentTypes"])
    {
        PaymentType  *paymentTypeModel = [[PaymentType  alloc]initWithDataDic:dic];
        [modelAr  addObject:paymentTypeModel];
        [paymentTypeModel  release];
    }
    self.paymentTypes = (NSArray *) modelAr;
}
- (void)dealloc
{
    [super dealloc];
    [_tagNameCN  release];
    [_tagNameEN  release];
    [_paymentTypes release];
}

@end

@implementation PaymentProduct

- (void)dealloc
{
    [super dealloc];
    [_tagId  release];
    [_typeId release];
    [_productId  release];
    [_productCode  release];
    [_productSubCode  release];
    [_bankCode  release];
    [_bankId  release];
    [_categoryId  release];
    [_productNameCN  release];
    [_productNameEN  release];
    [_productShortNameCN  release];
    [_productShortNameEN  release];
    [_paymentNotesEN  release];
    [_needCVV2  release];
    [_needCardholders  release];
    [_needCardholdersPhone  release];
    [_needCertificateNo  release];
    [_enable  release];
    [_needexpiredate  release];
    [_outCard  release];
    [_needPaymentPassword  release];
    [_supportCA  release];
    [_supportCoupon  release];
    [_supportPoint release];
    [_sendType  release];
    [_sendEncodingType  release];
    [_sendSkipType  release];
    [_pageDisplayType  release];
    [_pauseEndTime  release];
    [_pauseStartTime  release];
    [_promptInfoCN  release];
    [_promptInfoEN  release];
}

@end

@implementation PaymentType


- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    NSMutableArray  *modelAr = [NSMutableArray  array];
    
    for (NSDictionary  *dic in [dataDic  safeObjectForKey:@"paymentProducts"])
    {
        PaymentProduct *productModel = [[PaymentProduct  alloc]initWithDataDic:dic];
        [modelAr  addObject:productModel];
        [productModel  release];
    }
    self.paymentProducts = (NSArray *) modelAr;
}
- (void)dealloc
{
    [super dealloc];
    [_typeNameCN  release];
    [_typeNameEN  release];
    [_typeNoteCN  release];
    [_typeNoteEN  release];
}

@end