//
//  PayMentManager.m
//  ElongClient
//
//  Created by nieyun on 14-4-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PayMentManager.h"
#import "PayMentModel.h"
#import "NewPayMentTable.h"

static NSMutableArray *credictCardList = nil;

@implementation PayMentManager
 + (PayMentManager  *)shareInstance
{
    static  PayMentManager  *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PayMentManager  alloc]init];
    });
    return instance;
}

+(NSMutableArray  *)  allBankList

{

    @synchronized(credictCardList)
    {
		if(!credictCardList)
        {
			credictCardList = [[NSMutableArray alloc] init];

		}
        
    }
    return credictCardList;
}

+ (NSArray *)getBankList:(NSArray *)modelAr
{
    NSMutableArray  *bAr = [NSMutableArray  array];
    if (modelAr.count > 0)
    {
        for ( PaymentTag  *model  in  modelAr)
        {
            
            for  (PaymentType  *typeModel in model.paymentTypes)
            {
                if ([typeModel.tagId  intValue]==   CrediCardType)
                {
                    
                    for (PaymentProduct *product in typeModel.paymentProducts)
                    {
                        NSMutableDictionary  *bankDic = [NSMutableDictionary  dictionary];
                        [bankDic  setObject:product.categoryId forKey:@"Id"];
                        [bankDic setObject:product.productNameCN forKey:@"Name"];
                        [bankDic  setObject:product.needCVV2 forKey:@"Cvv"];
                        [bankDic  setObject:product.needCertificateNo forKey:@"IdentityCard"];
                        [bankDic   setObject:product.productId forKey:@"ProductId"];
                        [bAr  addObject:bankDic];
                    }
                    
                }
            }
        }

    }
    
   
    
    return bAr;
    
}

- (void)dealloc
{
    [_bankList release];
    [super dealloc];
}
@end
