//
//  CallTaxiVC.h
//  ElongClient
//  叫车首页
//  Created by Jian.Zhao on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "TaxiRoot.h"
#import "ChooseDepartVC.h"
#import "AirportListVC.h"
#import "AddressInfo.h"
#import "ConfirmPhoneVC.h"
#import "AttributedLabel.h"
#import "SendTaxiContrl.h"

//继承类必须是 ElongBaseViewController，如果是DPNAV的话 .m里面的setget方法会在ViewDidLoad后执行！
@interface CallTaxiVC : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,
UITextFieldDelegate,SelectAddressDelegate,SelectedAirportDelegate,UIActionSheetDelegate,ContinueCountTimeDelegate>{

    CustomTextField *text;
    UIActionSheet *sheet;
    AttributedLabel *totalTaxiNum;//周围出租车辆数
    UITableView *_tableView;
    UIButton *sendBtn;
        
    NSString *_confirmDate;
    TaxiType taxiType;
    HttpUtil *http_util;
    HttpUtil *addressUti;
    //默认赋值
    NSString *_startPoint;//起点
    NSString *_endPoint;//终点
    //
    AddressInfo *_startAddress;
    AddressInfo *_endAddress;
    TaxiOrder *order;
    BOOL serviceEnable;
    //连续计时
    NSTimeInterval stay_interval;//派单中返回此页面停留时间
    NSTimeInterval rest_interval;//剩余计时 秒数
    NSString *_cacheOrder;//用来对比的订单(缓存的订单号)
    NSString *_cacheOrderType;//用来区分订单类型(缓存的订单类型)
    NSString *_cacheStart;//缓存起点
    NSString *_cacheEnd;//缓存终点
    int pushedTaxi;
    NSTimer *currentTimer;
}

@property(nonatomic,retain) NSString *confirmDate;
@property (nonatomic,copy)  NSString *startPoint;
@property (nonatomic,copy)  NSString *endPoint;
@property (nonatomic,copy) NSString *cacheStart;
@property (nonatomic,copy) NSString *cacheEnd;
@property (nonatomic,copy) NSString *cacheOrder;
@property (nonatomic,copy) NSString *cacheOrderType;
@property (nonatomic,assign) BOOL absolutelyNew;


@property (nonatomic,retain)  AddressInfo *startAddress;
@property (nonatomic,retain)  AddressInfo *endAddress;

-(void)setTaxiType:(int)type;
-(int)taxiType;

@end
