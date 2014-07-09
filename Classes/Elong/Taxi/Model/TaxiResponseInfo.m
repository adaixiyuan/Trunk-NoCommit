//
//  TaxiResponseInfo.m
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiResponseInfo.h"

@implementation TaxiResponseInfo

- (void)dealloc
{
    [_driverName release];
    [_driverPhone release];
    [_driverPhotoUrl  release];
    [_dirverLatitude  release];
    [_dirverLongitude release];
    [_taxiCompany  release];
    [_taxiNo  release];
    [_responseTime  release];
    [super dealloc];
}

@end
