//
//  JScenicListRequest.m
//  ElongClient
//
//  Created by nieyun on 14-5-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "JScenicListRequest.h"

@implementation JScenicListRequest

- (NSString  *)getListUrl
{
    NSDictionary  *dic = [self  convertDictionaryFromObjet];
    NSString  *jsonString = [dic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"mtools" forService:@"ticket/getSceneryList" andParam:jsonString];
    return url;
}
- (void)dealloc
{
    [_type  release];
    [_page  release];
    [_pageSize  release];
    [_clientIp  release];
    [_cityId  release];
    [_sortType  release];
    [_keyword  release];
    [_searchFields  release];
    [_gradeId  release];
    [_themeId  release];
    [_priceRange  release];
    [_cs  release];
    [_latitude  release];
    [_longitude  release];
    [_provinceId  release];
    [_isCitySearch  release];

    [super dealloc];
}
@end
