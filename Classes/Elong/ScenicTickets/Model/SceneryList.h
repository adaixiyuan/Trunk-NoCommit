//
//  SceneryList.h
//  ElongClient
//
//  Created by nieyun on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"
#import "HotModel.h"

typedef enum
{
  SCENIC_OFFLINE = -1,
  SCENIC_NOBOOK = 0,
  SCENIC_BOOK = 1
}SCENICBOOKFLAG;
@interface SceneryList : BaseModel
@property  (nonatomic,retain)NSString  *sceneryName;//景点名称
@property  (nonatomic,retain)NSNumber  * sceneryId;//景点Id
@property  (nonatomic,retain)NSString  *    scenerySummary;//景点简介(是否是“名胜古迹”一类)
@property  (nonatomic,retain)NSString  *imgPath;//图片地址
@property  (nonatomic,retain)NSString  *    gradeId;//等级ID
@property  (nonatomic,retain)NSString  *gradeName;//等级名称
@property  (nonatomic,retain)ThemeList  *themeList;//景点主题列表
@property  (nonatomic,retain)NSNumber  *lon;//经度
@property  (nonatomic,retain)NSNumber  *lat;//纬度
@property  (nonatomic,retain)NSNumber  *bookFlag;//可预订情况-1：暂时下线0：不可预订1：可预订
@property  (nonatomic,retain)NSNumber  *score;//评分
@property  (nonatomic,retain)NSString  *elongPrice;//艺龙价
@property  (nonatomic,retain)NSString  *price;//门市价

@end
