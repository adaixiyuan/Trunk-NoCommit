//
//  SelectCard.h
//  ElongClient
//
//  Created by dengfang on 11-1-31.
//  Copyright 2011 shoujimobile. All rights reserved.
//
#define FLIGHT_STATE 0          // 机票
#define HOTEL_STATE  1          // 酒店
#define GROUPON_STATE  555      // 团购
#define INTERHOTEL_STATE 888    // 国际酒店
#define RENTCAR_STATE 999       // 租车

#define NETFLIGHT_STATE 0
#define NETHOTEL_STATE 1
#define NETCARDTYPE_STATE 2
#define NETCARDTYPE_EDIT  4
#define CHECKCCVALID_STATE 3

#import <UIKit/UIKit.h>
#import "DPNav.h"
#import "HotelOrderSuccess.h"
#import "StringEncryption.h"
#import "JPostHeader.h"
#import "AddAndEditCard.h"
#import "GrouponConfirmViewController.h"
#import "SelectCardCell.h"
#import "RentComfirmController.h"

@class SelectCard;  //by lc

@protocol SelectCard_C2C_Delegate <NSObject>

-(void)excuteSelectCard_C2C:(SelectCard *)sender;

@end

@class FlightOrderConfirm, AttributedLabel, CashAccountTable;
@interface SelectCard : DPNav <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIAlertViewDelegate, AddAndEditCardDelegate, SelectCardCellDelegate> {
    UITableView *tabView;
	UIView *footerView;             // tablefooterview
    UIView *footView;
	
	int preSelectRow;
	int m_nextState;
	int m_netState;
	int currentRow;
	int currentOverDueRow;
	int heightCount;
	int defaultCardCount;
    NSInteger caCellNum;            // 显示的CA选择部分行数
    NSInteger tableHeaderHeight;    // 顶部高度
    
    HttpUtil *bankUntil;
	
    BOOL needCheckCard;         // 是否需要校验信用卡，default：YES
	BOOL useCoupon;
    BOOL ReceiveMemoryWarning;
    BOOL preloadOver;           // 预加载银行列表是否结束
	BOOL needCAPassword;        // 是否需要CA支付密码,default:NO
    
    CashAccountTable *caTable;
    ConfirmHotelOrder *hotelconfirmorder;
    GrouponConfirmViewController *grouponConfirmVC;
    RentComfirmController   *rentContrl;
	
	int vouchType;			// 酒店担保类型    1、首晚；2、全额
    int hotelTipHeight;     // 酒店信息高度
    float exchangeRate;     // 人民币汇率，default＝1.0
    BOOL caPayEnough;       // 判断现金账户是否足够支付订单，default：NO
	double vouchMoney;		// 酒店担保金额
	
	NSArray *cvvBanks;		// 需要CVV码的银行
    
    FlightOrderConfirm *flightOrderConfirm;
    BOOL canUseCA;          // 是否可使用CA账户,default = NO
    BOOL usedCA;            // 用户是否选择使用CA,default = NO
    
    CustomTextField *passwordField;      // CA密码输入框
    AttributedLabel *caHeaderTitleLabel;      // 使用CA时候的顶部标题栏
    
    AddAndEditCard *addCardCtroller;     // 当酒店流程没有客史信用卡时，直接显示得信用卡添加页面
    UniformCounterDataModel *dataModel;  
}

@property (nonatomic) BOOL useCoupon;
@property (nonatomic,readonly) UITableView *tabView;

@property (nonatomic,assign) BOOL isC2C_order;  //c2c进入或非c2c进入  默认是非C2C  by lc

@property(nonatomic,assign)id<SelectCard_C2C_Delegate> delegate;

+ (NSMutableArray *)allCards;
- (void)setTabViewHeight:(int)tabelmaxcount;
-(id)init:(NSString *)name style:(NavBtnStyle)style nextState:(int)nextState canUseCA:(BOOL)useCA;            // 带CA支付功能的初始化方法
-(id)init:(NSString *)name style:(NavBtnStyle)style nextState:(int)nextState;
+ (NSMutableArray *)cardTypes ;
-(void)updateData;
- (void)textFieldDidActive:(id)sender;
- (void)textFieldDidEnd:(id)sender;
// fixed by lc 执行
-(void)nextClickAction;

@end
