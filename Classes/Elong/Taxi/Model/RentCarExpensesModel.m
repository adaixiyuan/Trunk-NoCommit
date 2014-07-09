//
//  RentCarExpensesModel.m
//  ElongClient
//
//  Created by licheng on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "RentCarExpensesModel.h"

@implementation RentCarExpensesModel

-(void)dealloc{
    setFree(_title);
    setFree(_content);
    [super dealloc];
}

@end
