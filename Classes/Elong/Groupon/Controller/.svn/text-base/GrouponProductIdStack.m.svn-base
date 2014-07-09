//
//  GrouponProductIdStack.m
//  ElongClient
//  
//  Created by garin on 14-5-26.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponProductIdStack.h"

//产品id数组，用于共享
static  NSMutableArray *prodIdArr;

@implementation GrouponProductIdStack

+(void) clearProdIdArr
{
    if(prodIdArr)
    {
        [prodIdArr release];
        prodIdArr=nil;
    }
}

+ (NSString *)grouponProdId
{
	@synchronized(prodIdArr)
    {
        if (!prodIdArr)
        {
            prodIdArr=[[NSMutableArray alloc] init];
        }
        
        if (prodIdArr.count>0)
        {
            return [prodIdArr safeObjectAtIndex:prodIdArr.count-1];
        }
        else
            return @"";
	}
}

+(void) popGrouponProdId
{
    @synchronized(prodIdArr)
    {
        if (!prodIdArr)
        {
            return;
        }
        if (prodIdArr&&prodIdArr.count>0)
        {
            [prodIdArr removeObjectAtIndex:prodIdArr.count-1];
        }
	}
}

+(int) getGrouponProdIdCnt
{
    @synchronized(prodIdArr)
    {
        if (!prodIdArr)
        {
            prodIdArr=[[NSMutableArray alloc] init];
        }
        
        return prodIdArr.count;
    }
}

+(void) pushGrouponProdId:(NSString *) productId
{
    @synchronized(prodIdArr)
    {
        if (!prodIdArr)
        {
            prodIdArr=[[NSMutableArray alloc] init];
        }
        if (prodIdArr)
        {
            [prodIdArr addObject:productId];
        }
	}
}

@end
