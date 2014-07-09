//
//  ScenicDetail.h
//  ElongClient
//  景点详情Model类
//  Created by Jian.Zhao on 14-5-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@class SceneryList;
@interface ScenicDetail : BaseModel

@property (nonatomic,copy) NSString *sceneryId;//景点ID
@property (nonatomic,copy) NSString *sceneryName;//景点名称
@property (nonatomic,copy) NSString *sceneryAddress;//景点地址
@property (nonatomic,copy) NSString *supplierId;//供应商ID

@property (nonatomic,copy) NSString *cityId;//城市ID
@property (nonatomic,copy) NSString *intro;//景点简介
@property (nonatomic,copy) NSString *buyNotie;//购票需知
@property (nonatomic,copy) NSString *payMode;//支付类型
@property (nonatomic,copy) NSString *payModeName;//中文支付类型
@property (nonatomic,copy) NSString *lon;//经度
@property (nonatomic,copy) NSString *lat;//纬度
@property (nonatomic,copy) NSString *amountAdvice;//最低价
@property (nonatomic,retain) NSArray *ahead;//提前预定的列表
@property (nonatomic,retain) NSArray *policyList;//价格列表(应该是价格类型吧)
@property (nonatomic,retain) NSArray *notice;//购票需知列表
@property (nonatomic,retain) NSArray *imageList;//图片列表
@property (nonatomic,retain) NSArray *extInfoOfImageList;//图片列表扩展信息
@property (nonatomic,retain) NSArray *nearbySceneryList;//附近景点列表
@property (nonatomic,retain) NSArray *sameThemeSceneryList;//同主题景点列表

+(NSString *)getScenicDetailRequestByGivenListModel:(SceneryList *)model;

+(NSArray *)convertThePricePolicy:(NSArray *)policyList;
+(NSArray *)convertTheNearByPoints:(NSArray *)nearBylist;


@end

//附近及同主题的简单景点信息
@interface SimpleScenic : BaseModel

@property(nonatomic,copy) NSString *sceneryId;
@property(nonatomic,copy) NSString *sceneryName;
@property(nonatomic,copy) NSString *imgPath;

@end

//价格策略
@interface ScenicPrice : BaseModel
@property (nonatomic,copy) NSString *policyId;//价格策略id
@property (nonatomic,copy) NSString *policyName;//价格策略名称
@property (nonatomic,copy) NSString *remark;//门票说明
@property (nonatomic,copy) NSString *price;//门市价格
@property (nonatomic,copy) NSString *elongPrice;//艺龙价格
@property (nonatomic,copy) NSString *pMode;//支付方式
@property (nonatomic,copy) NSString *pModeName;//中文支付方式
@property (nonatomic,copy) NSString *gMode;//取票方式
@property (nonatomic,copy) NSString *gModeName;//中文取票方式
@property (nonatomic,copy) NSString *minT;//最小票数
@property (nonatomic,copy) NSString *maxT;//最大票数
@property (nonatomic,copy) NSString *realName;//是否实名制
@property (nonatomic,copy) NSString *ticketId;//门票类型Id
@property (nonatomic,copy) NSString *ticketName;//门票类型名称
@property (nonatomic,copy) NSString *bDate;//开始时间
@property (nonatomic,copy) NSString *eDate;//结束时间
@property (nonatomic,copy) NSString *poenDateType;//价格策略有效期类型
@property (nonatomic,copy) NSString *openDateValue;//价格策略具体有效期
@property (nonatomic,copy) NSString *closeDate;//价格策略里面的屏蔽节假日
@end