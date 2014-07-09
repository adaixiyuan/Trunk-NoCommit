//
//  CityList.h
//  ElongClient
//
//  Created by nieyun on 14-5-5.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface CityList : BaseModel
@property (nonatomic,retain) NSString  *cityList;
@property (nonatomic,retain) NSString  *cityId;
@property (nonatomic,retain) NSString  *cityName;
@property (nonatomic,retain) NSString  *prefixLetter;
@property (nonatomic,retain) NSString  *enName;
@end
