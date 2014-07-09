//
//  TaxiSupply.m
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiSupply.h"

@implementation TaxiSupply
- (void)dealloc
{
    [_partnerKfTel  release];
    [_partnerName release];
    [_partnerOrderId release];
    [super dealloc];
}
@end
