//
//  TaxiFillManager.h
//  ElongClient
//  租车单例类
//  Created by nieyun on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvaluteModel.h"
#import "TaxiPublicDefine.h"
#define PRETIP @"预订此产品，需要您先预付该车型起租费用。用车结束后，会根据您的行程计算出最终账单，在您核对无误后，再收取剩余费用。"
#define STRINGISNULL(str)    (!str ||[str isEqualToString:@""]|| [str isEqual:[NSNull  null]])
@interface TaxiFillManager : NSObject
@property  (nonatomic,retain)  EvalueRequestModel  *evalueRqModel;
@property  (nonatomic,retain)  OrderRequestModel  *fillRqModel;
@property (nonatomic,assign) BOOL hasDestination;
@property (nonatomic,retain) NSString  *orderAmount;
@property (nonatomic,retain) NSString  *orderId;
@property (nonatomic,retain) NSString  *payMentToeken;
@property (nonatomic,retain) NSString  *gorderIdt;
@property (nonatomic,copy) NSString *productType;
@property (nonatomic,copy) NSString *currentCityCode;
@property (nonatomic,copy) NSString *airPortCode;//接机中 到达机场的三字码 
@property (nonatomic,retain) NSMutableArray *customAirports;//自定义化的机场集合
@property (nonatomic,copy) NSString *carUseCity;//用车城市(接机：降落 送机：起飞)
@property (nonatomic,copy) NSString  *productId;
@property (nonatomic,copy) NSString *carTypeName;

+ (TaxiFillManager *)  shareInstance;

- (NSDictionary  *)  changeModelDic;
- (BOOL)checkIsNotNull;
- (void) saveMessage;
- (BOOL)   checkAll;
- (BOOL) checkDateInterval:(NSString  *)useDateStr;
@end
