//
//  RentCarOrderDetailBillModel.m
//  ElongClient
//
//  Created by licheng on 14-3-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentCarOrderDetailBillModel.h"
#import "RentCarBillModel.h"
@implementation RentCarOrderDetailBillModel


- (void) setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    NSMutableArray *arr = [[NSMutableArray  alloc]init];
    for (NSDictionary *dict in self.billDetail) {
        //NSLog(@"执行了么...");
        RentCarBillModel  *supply = [[RentCarBillModel  alloc]initWithDataDic:dict];
        [arr addObject:supply];
        [supply release];
    }

    self.billDetail = arr;
    [arr release];
    
}

-(void)dealloc{
    setFree(_startTime);
    setFree(_endTime);
    setFree(_orderId);
    setFree(_gOrderId);
    setFree(_useTime);
    setFree(_timeLength);
    setFree(_kiloLength);
    setFree(_totalPrice);
    setFree(_billDetail);
    
    [super dealloc];
}
@end
