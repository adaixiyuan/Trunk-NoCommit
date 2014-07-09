//
//  HotModel.m
//  ElongClient
//
//  Created by nieyun on 14-5-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotModel.h"

@implementation HotModel

@end
@implementation HotCityList

- (void)dealloc
{
    [_cityId  release];
    [_cityName release];
    [super dealloc];
}

@end
@implementation HotSceneryList

- (void)dealloc
{
    [_sceneryId release];
    [_sceneryName  release];
    [super dealloc];
}

@end

@implementation ThemeList
- (void)setAttributes:(NSDictionary *)dataDic
{
    [super setAttributes:dataDic];
    self.themeId = [dataDic objectForKey:@"id"];
    self.themeName = [dataDic  objectForKey:@"name"];
}
- (void)dealloc
{
    [_themeId release];
    [_themeName release];
    [super dealloc];
}

@end

@implementation GradeList

- (void)dealloc
{
    [_gradeId release];
    [_gradeName release];
    [super dealloc];
}

@end