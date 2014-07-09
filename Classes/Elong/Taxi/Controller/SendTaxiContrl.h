//
//  SendTaxiContrl.h
//  ElongClient
//  派单页面
//  Created by nieyun on 14-2-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//


typedef enum
{
    Direction_request,
    Lat_request
    
}SendTaxiReqType;


#import "DPNav.h"
#import "TaxiPublicDefine.h"
#import "TaxiDetaileModel.h"
#import "HttpUtil.h"
#import "AddressInfo.h"
#import "ElongBaseViewController.h"
#import "CircleView.h"
#import "TaxiTryAgainCtrl.h"
#import "HotelMap.h"
#define  TESTSTATE1  6
#define  TESTSTATE2  0
#define  DefautTaxiNum  10
#define  DefautMaxNum   110

//连续计时
@protocol  ContinueCountTimeDelegate <NSObject>

-(void)continueCountTimeRest:(NSTimeInterval)restInterval pushedNum:(int)pushed;

@end


@interface SendTaxiContrl : ElongBaseViewController <HttpUtilDelegate,CircleViewDelegate>
{
    SendTaxiReqType    type;
    TaxiDetaileModel  *dModel;
    HttpUtil  *sendTaxiRequest;
    CircleView  *circle;
    
    UILabel  *taxiNumLabel;
    UILabel *shortNumLabel;

    //
    TaxiOrder *_againOrder;
    NSString *_orderID;//下单成功后的订单ID
    NSString *_pollingTime;//轮训时间，用于查询订单的状态

    UILabel  *countDownLabel;
    //倒计时
    int countDown;
    int randomSum;
    
    BOOL circle_Reset;
}
@property (nonatomic,assign) id<ContinueCountTimeDelegate>delegate;
@property (nonatomic,copy)   NSString *orderID;
@property (nonatomic,copy)   NSString *pollingTime;
@property (nonatomic,retain) TaxiOrder *againOrder;
@property (nonatomic,assign) float timeflow;
-(void)doTheAction;

-(void)setDefaultValueOfRestInterval:(NSTimeInterval)rest andPushedNum:(int)nums andReset:(BOOL)reset;

@end
