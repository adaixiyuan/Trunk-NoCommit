//
//  JScenicListRequest.h
//  ElongClient
//
//  Created by nieyun on 14-5-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface JScenicListRequest : BaseModel
- (NSString  *)getListUrl;
@property  (nonatomic,retain) NSNumber  *type;//查询类型：0模糊匹配；1精确匹配
@property  (nonatomic,retain) NSNumber  *page;//页数；不传默认为1
@property  (nonatomic,retain) NSNumber  *pageSize;//分页大小；不传默认为10，最大为100
@property  (nonatomic,retain) NSNumber  *clientIp;//客户请求Ip
@property  (nonatomic,retain) NSNumber  *cityId;//城市Id
@property  (nonatomic,retain) NSNumber  *sortType;//排序类型
@property  (nonatomic,retain) NSString  *keyword;//关键词
@property  (nonatomic,retain) NSString  *searchFields;//搜索字段当有keyword时必传入，多个用英文逗号隔开cityName:      城市名称cityId:城市IdsceneryName:景点名称
@property  (nonatomic,retain) NSString *gradeId;//星级Id如A,AA，可传多个，以英文逗号隔开
@property  (nonatomic,retain) NSNumber  *themeId;//主题Id如1,2,3,4,5，可传多个，以英文逗号隔开
@property  (nonatomic,retain) NSString  *priceRange;//价格范围如0,50，表示0到50
@property  (nonatomic,retain) NSNumber  *cs;//坐标系统1.mapbar2.百度；不传默认为1
@property  (nonatomic,retain) NSNumber  *latitude;//纬度
@property  (nonatomic,retain) NSNumber *longitude;//经度
@property  (nonatomic,retain) NSNumber  *radius;//半径
@property  (nonatomic,retain) NSNumber  *provinceId;//省份Id
@property (nonatomic,retain) NSNumber  *isCitySearch; //本次搜索是否按城市搜索1--是；2--否
@end
