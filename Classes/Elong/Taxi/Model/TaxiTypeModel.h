//
//  TaxiTypeModel.h
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface TaxiTypeModel : BaseModel

@property  (nonatomic,retain)  NSString  *serviceSupportor;//服务提供商
@property  (nonatomic,retain)  NSString  *carTypeCode;//车辆类型ID
@property  (nonatomic,retain)  NSString  *carTypeName;//车辆类型名称
@property  (nonatomic,retain)  NSString  *carTypeBrand;//车辆名称
@property  (nonatomic,retain)  NSString  *personNum;//准载人数
@property  (nonatomic,retain)  NSString  *carPic;//车辆图片
@property  (nonatomic,retain)  NSNumber  *feePerKm;//每公里费用  mark
@property  (nonatomic,retain)  NSNumber  *feePerHour;//每小时费用   mark
@property  (nonatomic,retain)  NSString  *minFee;//最小起租费用
@property  (nonatomic,retain)  NSNumber *fee;//固定价格产品固定费用
@property  (nonatomic,retain)  NSString  *timeLength;//定价产品免费时长
@property  (nonatomic,retain)  NSString  *distance;//固定价格产品包含里程
@end
