//
//  TaxiDetaileModel.m
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiDetaileModel.h"

@implementation TaxiDetaileModel
- (void) setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    
    TaxiSupply  *supply = [[TaxiSupply  alloc]initWithDataDic:[dataDic  safeObjectForKey:@"supplierInfo"]];
    self.supplierInfo = supply;
    [supply release];
    
    TaxiRequestInfo  *requestInfo = [[TaxiRequestInfo  alloc]initWithDataDic:[dataDic  safeObjectForKey:@"requestInfo"]];
    self.requestInfo = requestInfo;
    [requestInfo  release];
    
    TaxiResponseInfo  *response = [[TaxiResponseInfo  alloc]initWithDataDic:[dataDic  safeObjectForKey:@"responseInfo"]];
    self.responseInfo = response;
    [response  release];
}

- (void) dealloc
{
    [_orderId  release];
    [_orderStatus  release];
    [_orderTime  release];
    [_driverNum  release];
    [_supplierInfo  release];
    [_requestInfo  release];
    [_responseInfo  release];
    [_orderStatusDesc release];
    [super dealloc];

}
@end
