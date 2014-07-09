//
//  FlightOrderDetail.h
//  ElongClient
//
//  Created by Janven on 14-3-20.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "BaseModel.h"

/*
 DistributionInfo
 BookerInfo
 PaymentInfo
        <list>PaymentDetail
 <list>PassengerTiketInfo
        <list>TicketInfo
                    <list>AirLineInfo
                    TiketPriceInfo
        InsuranceInfo
                     <list>InsuranceDetail
        PassengerInfo
 PriceInfo
 <list>AirSeat
 */

#pragma mark 机票订单详情--配送信息
@interface DistributionInfo : BaseModel
@property (nonatomic,assign) int DistributionType;	//配送类型
@property (nonatomic,copy) NSString *DistributionPerson;//邮寄人姓名
@property (nonatomic,copy) NSString *DistributionPhone;//邮寄人电话
@property (nonatomic,copy) NSString *DistributionAddress;//	邮寄地址
@property (nonatomic,copy) NSString *DistributionPostcode;//	邮编
@end
#pragma mark 机票订单详情--联系人信息
@interface BookerInfo : BaseModel
@property (nonatomic,copy) NSString *CardNo;
@property (nonatomic,copy) NSString *ConformationType;
@property (nonatomic,copy) NSString *Email;
@property (nonatomic,copy) NSString *Mobile;
@property (nonatomic,copy) NSString *Name;

@end
#pragma mark 机票订单详情--支付信息
@interface PaymentInfo : BaseModel
@property (nonatomic,assign) BOOL IsAllowContinuePay;//是否允许继续支付
@property (nonatomic,retain) NSArray *PaymentDetails;//支付记录列表
@end
#pragma mark 机票订单详情--支付信息--------支付详情
@interface PaymentDetail : BaseModel
@property (nonatomic,copy) NSString *PayOperate;
@property (nonatomic,copy) NSString *PayType;
@property (nonatomic,copy) NSString *PaymentPrice;
@property (nonatomic,copy) NSString *ServicePrice;
@property (nonatomic,assign)  int Status;
@property (nonatomic,copy) NSString *StatusName;
@end
#pragma mark 机票订单详情--价格信息
@interface PriceInfo : BaseModel
@property (nonatomic,assign) double  OrderPrice;//支付额
@property (nonatomic,assign) double  InsurancePrice;//保险费总额
@property (nonatomic,assign) double  TaxPrice;//税费
@property (nonatomic,assign) double  TicketPrice;//票价
@property (nonatomic,assign) double  ServicePrice;//服务费
@end
#pragma mark 主Model --机票订单详情
@interface FlightOrderDetail : BaseModel
@property (nonatomic,copy) NSString *OrderNo;  //订单号
@property (nonatomic,copy) NSString *OrderCode;//订单code
@property (nonatomic,copy) NSString *CreateTime;//预订时间
@property (nonatomic,retain) DistributionInfo *DistributionInfo;//配送信息
@property (nonatomic,retain) BookerInfo *BookerInfo;//联系人信息
@property (nonatomic,retain) PaymentInfo *PaymentInfo;//支付信息
@property (nonatomic,retain) NSArray *PassengerTikets;//乘客票信息
@property (nonatomic,retain) NSArray *SelectSeats;//选座信息
@property (nonatomic,retain) PriceInfo* PriceInfo;//订单价格信息
@end

#pragma mark /************************* 乘客票信息 ***********************/
#pragma mark 保险信息
#pragma mark  -----------PassengerTikets
#pragma mark  ------------------------------InsuranceInfo

//保险信息
@interface InsuranceInfo : BaseModel
@property (nonatomic,assign) int InsuranceCount;//保险份数
@property (nonatomic,copy) NSString *InsurancePrice;//保险总额
@property (nonatomic,retain) NSArray *InsuranceDetail;//保险详情
@end

#pragma mark 保险信息
#pragma mark  -----------PassengerTikets
#pragma mark  ------------------------------InsuranceInfo
#pragma mark  -----------------------------------------------InsuranceDetail

@interface InsuranceDetail : BaseModel
@property (nonatomic,copy) NSString *TravelerName;//保险人姓名
@property (nonatomic,copy) NSString *CertificateType	;//证件类型
@property (nonatomic,copy) NSString *CertificateNumber;//保险人证件号
@property (nonatomic,assign) int  InsuranceCount;//保险份数
@property (nonatomic,copy) NSString *InsuranceSalePrice;//保险单价
@property (nonatomic,copy) NSString *EffectiveTime;//有效期
@property (nonatomic,copy) NSString *StatusName;//保险状态名称
@property (nonatomic,assign) int  Status;//保险状态
@property (nonatomic,copy) NSString *InsuranceName;//保险名称
@end

#pragma mark 保险信息
#pragma mark  -----------PassengerTikets
#pragma mark  ------------------------------PassengerInfo

@interface PassengerInfo : BaseModel
@property (nonatomic,copy) NSString * Name;//乘客姓名
@property (nonatomic,copy) NSString *CertificateType	;//证件类型
@property (nonatomic,copy) NSString *CertificateNumber;//证件号
@property (nonatomic,copy) NSString *Birthday;//出生日期
@property (nonatomic,copy) NSString *PassengerType;//乘客类型 0或空表示成人 1表示儿童

@end

#pragma mark 乘客票信息
#pragma mark  -----------PassengerTikets
//乘客具体信息
@interface PassengerTiketInfo : BaseModel
@property (nonatomic,retain) NSArray *Tickets;//票集合
@property (nonatomic,retain) InsuranceInfo *InsuranceInfo;//保险信息
@property (nonatomic,retain) PassengerInfo *PassengerInfo;//用户信息
@end


#pragma mark 保险信息
#pragma mark  -----------PassengerTikets
#pragma mark  ------------------------------TicketInfo
#pragma mark -------------------------------------------AirLineInfo

@interface AirLineInfo : BaseModel
@property (nonatomic,copy) NSString * DepartAirPort;//出发机场
@property (nonatomic,copy) NSString * ArrivalAirPort;//到达机场
@property (nonatomic,copy) NSString * DepartDate;//	出发时间
@property (nonatomic,copy) NSString * ArrivalDate;//	到达时间
@property (nonatomic,copy) NSString * DepartTerminal;//出发航站楼
@property (nonatomic,copy) NSString * ArriveTerminal;//到达航站楼
@property (nonatomic,copy) NSString * FlightNumber;//航班号
@property (nonatomic,copy) NSString * AirCorpCode;//航空公司代码
@property (nonatomic,copy) NSString * AirCorpName;//航空公司
@property (nonatomic,copy) NSString * ChangeRegulate;//改签规则
@property (nonatomic,copy) NSString * ReturnRegulate;//退票规则
@property (nonatomic,copy) NSString * SignRule;//签转规定
@property (nonatomic,copy) NSString * Cabin;//舱位
@property (nonatomic,copy) NSString * CabinCode;//舱位代码
@property (nonatomic,copy) NSString * PlaneType;//机型
@property (nonatomic,copy) NSString * DepartAirCode;//出发机场三字码
@property (nonatomic,copy) NSString * ArrivalAirCode;//到达机场三字码
@end

#pragma mark 保险信息
#pragma mark  -----------PassengerTikets
#pragma mark  ------------------------------TicketInfo
#pragma mark -------------------------------------------TiketPriceInfo

@interface TiketPriceInfo : BaseModel
@property (nonatomic,copy) NSString * TicketPrice;
@property (nonatomic,copy) NSString *TicketTax;
@end

#pragma mark 保险信息
#pragma mark  -----------PassengerTikets
#pragma mark  ------------------------------TicketInfo

@interface TicketInfo : BaseModel
@property (nonatomic,retain) NSArray *AirLineInfos;
@property (nonatomic,retain) TiketPriceInfo*TiketFeeInfo;
@property (nonatomic,copy) NSString * TicketStatusName;//票状态描述
@property (nonatomic,copy) NSString * TicketNo;//电子票号
@property (nonatomic,copy) NSString * TicketId;//机票Id
@property (nonatomic,copy) NSString * PnrNo;//pnr码
@property (nonatomic,copy) NSString * TicketChannel;//机票渠道来源
@property (nonatomic,assign) int TicketStatus;//票状态代码
@property (nonatomic,assign) BOOL isAllowRefund;//是否可以在线退票

@property(nonatomic,assign) BOOL isAlreadyRefund;//是已经申请在线退票了  by lc  临时添加的 
@end

#pragma mark /************************* 选座信息 ***********************/
//暂无
#pragma  mark 选座信息
#pragma  mark ----------SelectSeats

