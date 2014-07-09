//
//  PickupModel.m
//  ElongClient
//
//  Created by licheng on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PickupModel.h"

@implementation PickupModel

-(void)dealloc{
    
    setFree(_carTypeName);
    setFree(_fee);
    setFree(_startingOffers);
    setFree(_additionalCosts);
    setFree(_feeUnit);
    
    [super dealloc];
}

@end
