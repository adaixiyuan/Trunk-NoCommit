//
//  RentOrderDetailModel.h
//  ElongClient
//
//  Created by licheng on 14-3-18.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

@interface RentOrderDetailModel : BaseModel

@property(nonatomic,copy)NSString *orderId;  //1订单号(向客户展示用)
@property(nonatomic,copy)NSString *gOrderId;  //订单号(向payMent支付用)
@property(nonatomic,copy)NSString *orderStatus;  //订单状态
@property(nonatomic,copy)NSString *orderStatusDesc; //中文订单状态
@property(nonatomic,copy)NSString *merchant; //服务商
@property(nonatomic,copy)NSString *cartype;  //车辆类型（例如：舒适型）
@property(nonatomic,copy)NSString *orderTime;  //下单时间
@property(nonatomic,copy)NSString *fromAddress;  //出发地点
@property(nonatomic,copy)NSString *toAddress;  //目的地
@property(nonatomic,copy)NSString *useTime;  //用车时间
@property(nonatomic,copy)NSString *fromLongitude;  //出发经度
@property(nonatomic,copy)NSString *fromLatitude;  //出发纬度
@property(nonatomic,copy)NSString *toLongitude;   //去经度
@property(nonatomic,copy)NSString *toLatitude;    //去纬度
@property(nonatomic,copy)NSString *mapSupplier;   //地图提供
@property(nonatomic,copy)NSString *flightNumber;  //航班号
@property(nonatomic,copy)NSString *passengerName;  //乘客姓名
@property(nonatomic,copy)NSString *passengerTel;  //乘客电话
@property(nonatomic,copy)NSString *driverName;  //司机姓名
@property(nonatomic,copy)NSString *driverTel;  //司机电话
@property(nonatomic,copy)NSString *driverCarId;  //汽车车牌号
@property(nonatomic,copy)NSString *driverCarBrand;  //车辆品牌
@property(nonatomic,copy)NSString *orderCloseReason;  //订单关闭原因
@property(nonatomic,copy)NSString *stType;  //收退类型
@property(nonatomic,copy)NSString *stAmount;  //收退金额
@property(nonatomic,copy)NSString *isBillVisible;  //是否可以显示账单详情
@property(nonatomic,copy)NSString *canCancel;   ///是否可以取消订单
@property(nonatomic,copy)NSString *canContinuePay;  //是否可以继续支付1 可以 2 不可以
@property(nonatomic,copy)NSString *chargeAmount;   //订单总金额

@property(nonatomic,copy)NSString *receiptContent; //发票信息
@property(nonatomic,copy)NSString *canGetOrderMulct; //能否调用获取罚金接口
//"canCancel": "1",
//"canContinuePay": "1",
//"carLicense": "京B3309",
//"carTypeName": "用车类型名称",
//"driverName": "李四",
//"driverPhone": "13682110011",
//"flightNum": "CA1234",
//"fromAddress": "首都机场",
//"isBillVisible": "1",
//"note": "用户留言",
//"orderId": "orderId1234567",
//"orderStatus": "2",
//"orderTime": "2014-03-10 15:30:00",
//"passengerName": "张三",
//"passengerPhone": "13681234567",
//"preOrderAmount": "300.00",
//"receiptAddress": "发票邮寄地址",
//"receiptContent": "发票内容",
//"receiptPerson": "张三",
//"receiptPhone": "68419944",
//"receiptPostCode": "100011",
//"receiptTitle": "发票抬头",
//"serviceSupportor": "服务提供商",
//"toAddress": "北京西站",
//"useTime": "2014-03-11 12:00:00"

@end
