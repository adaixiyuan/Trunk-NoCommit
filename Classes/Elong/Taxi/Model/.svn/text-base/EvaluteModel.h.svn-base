//
//  EvaluteModel.h
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface EvaluteModel : BaseModel

@property  (nonatomic,retain) NSNumber  *estimatedPrice;//预估价格
@property  (nonatomic,retain) NSString  *estimatedDistance;//预估距离
@property  (nonatomic,retain) NSString  *estimatedTime;//预估时间
@property  (nonatomic,retain) NSArray  *estimatedAmountDetail;//预估价费用明细
@property  (nonatomic,retain) NSString  *notice;
@end

/*
 *以下为Request请求的Model封装
 */

@interface EvalueRequestModel : BaseModel

@property (nonatomic,copy) NSString *cityCode;//城市ID
@property (nonatomic,copy) NSString *productType;//服务类型0201 接机 0202 送机
@property (nonatomic,copy) NSString *airPortCode;//机场三字码，接送机必传，接机则传到达机场三字码、送机则传起飞机场三字码
@property (nonatomic,copy) NSString *carTypeCode;//车辆类型ID
@property (nonatomic,copy) NSString *rentTime;//租用时长，时租必填
@property (nonatomic,copy) NSString *fromAddress;//出发地地址
@property (nonatomic,copy) NSString *fromLongitude;//出发地经度坐标
@property (nonatomic,copy) NSString *fromLatitude;//出发地纬度坐标
@property (nonatomic,copy) NSString *toAddress;//目的地地址，时租小于等于2小时，送机必填
@property (nonatomic,copy) NSString *toLongitude;//同toAddress
@property (nonatomic,copy) NSString *toLatitude;//同toAddress
@property (nonatomic,copy) NSString *serviceSupportor;//服务提供商ID
@property (nonatomic,copy) NSString *mapSupporter;//地图服务提供商1-百度 2-高德
@property  (nonatomic,copy) NSString  *flightNum;//航班号
@property  (nonatomic,copy) NSString  *startTime;//使用时间

@end

//EvalueRequestModel
@interface OrderRequestModel : BaseModel

@property  (nonatomic,copy) NSString  *passengerName;//乘客姓名
@property  (nonatomic,copy) NSString  *passengerPhone;//乘客电话
@property  (nonatomic,copy) NSString  *passengerNum;//乘客人数
@property  (nonatomic,copy) NSString  *needReceipt;//是否需要发票
@property  (nonatomic,copy) NSString  *receiptTitle;//发票抬头，needReceipt=1必填
@property  (nonatomic,copy) NSString  *receiptContent;//发票内容，needReceipt=1必填
@property  (nonatomic,copy) NSString  *receiptAddress;//发票邮寄地址，needReceipt=1必填
@property  (nonatomic,copy) NSString  *receiptPostCode;//发票邮政编码，needReceipt=1必填
@property  (nonatomic,copy) NSString  *receiptPerson;//发票接收人姓名，needReceipt=1必填
@property  (nonatomic,copy) NSString  *receiptPhone;//	发票接收人电话，needReceipt=1必填
@property   (nonatomic,copy) NSString *receiptType;//发票类型 needReceipt=1必填

@property  (nonatomic,copy) NSString  *note;//	客户留言
@property  (nonatomic,copy) NSString  *isAsap;//	是否随叫随到
@property  (nonatomic,copy) NSNumber  *orderAmount;//订单金额
@property  (nonatomic,copy) NSString  *orderAmountDetail;//订单费用明细，需要将预估价格的json串回传至后台进行记录
@property  (nonatomic,copy) NSString  *mapSupporter;//	地图服务提供商1-百度 2-高德
@property  (nonatomic,copy) NSString  *uid;//	会员号/设备号
@property  (nonatomic,copy) NSString  *carTypeName;
@property  (nonatomic,copy) NSString  *carTypeBrand;
@property  (nonatomic,copy) NSNumber  *estimatedAmount;
@property  (nonatomic,copy) NSString  *carTypeId;
@end