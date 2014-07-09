//
//  CityList.m
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CityList.h"

@implementation CityList
- (void)dealloc
{
    SFRelease(_cityList);
    SFRelease(_cityId);
    SFRelease(_cityName);
    SFRelease(_prefixLetter);
    SFRelease(_enName);
    [super dealloc];
}
@end
