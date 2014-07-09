//
//  HotModel.h
//  ElongClient
//
//  Created by nieyun on 14-5-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface HotModel : BaseModel

@end


@interface HotCityList : BaseModel
@property (nonatomic,retain) NSNumber  *cityId;
@property  (nonatomic,retain) NSString  *cityName;

@end

@interface HotSceneryList : BaseModel
@property  (nonatomic,retain) NSNumber *sceneryId;
@property (nonatomic,retain) NSString  *sceneryName;
@end

@interface ThemeList : BaseModel
@property (nonatomic,retain) NSNumber *themeId;
@property (nonatomic,retain) NSString  *themeName;

@end

@interface GradeList : BaseModel
@property (nonatomic,retain)  NSString  *gradeId;
@property (nonatomic,retain)  NSString  *gradeName;

@end

