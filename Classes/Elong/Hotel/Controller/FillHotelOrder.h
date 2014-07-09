//
//  HotelFillOrder.h
//  ElongClient
//
//  Created by bin xing on 11-1-5.
//  Copyright 2011 DP. All rights reserved.
//
//  修改客史没有信用卡时，先请求银行列表，再进入选择信用卡页面 by 赵海波 on 14-3-18

#import <UIKit/UIKit.h>
#import "HotelDefine.h"
#import "VouchFilterView.h"
#import "RoomSelectView.h"
#import "SelectRoomer.h"
#import "SpecialFilterView.h"
#import "PaymentTypeTable.h"
#import "XGSearchFilter.h"
typedef enum {
    HotelVouchTypeCreditcard = 0,   // 信用卡
    HotelVouchTypeAlipay        // 支付宝
}HotelVouchType; // 担保方式


//进入订单填写页 是从c2c 进来的  还是从其他进来的  默认是从 其他进来的
typedef enum{
    Except_C2C_Booking,  // 除了c2c 的所有付款方式
    C2C_Booking   //c2c 预付
} BookingType;


@class ArriveTime, EmbedTextField, ConfirmHotelOrder, PaymentTypeTable;
@interface FillHotelOrder : DPNav <UITextFieldDelegate, UIAlertViewDelegate, CustomABDelegate,FilterDelegate,UITableViewDataSource,UITableViewDelegate,RoomSelectViewDelegate, PaymentTypeTableDelegate> {
    PaymentTypeTable *payTable;
	NSInteger roomcount;
	
    NSMutableArray *vouchConditions;            // 担保条件
    NSDictionary *roomTypeDic;
    NSMutableArray *invoiceAddresses;
	
	int m_netstate;
    CGFloat vouchMoney;
	VouchFilterView *vouchView;
    SpecialFilterView *specialView;
    FilterView *invoiceSelect;
    HotelVouchType hotelVouchType;
	
	int minCheckinRooms;
	int currentTimeIndex;
    BOOL ReceiveMemoryWarning;
    BOOL needVouch;                 // 是否需要担保
    BOOL requestOver;               // 联系人数据是否已经加载
    BOOL needInvoice;               // 选择发票,default = NO
    BOOL addressEnabled;            // 邮寄地址是否已经加载
    BOOL canUseCA;                  // 标记ca是否可用
    
    HttpUtil *sevenDaysUtil;
    HttpUtil *addressUtil;
    HttpUtil *bedTipsUtil;         //notesToHotel获取http
    

    int totalValue;                 //用户总的消费券
    int daysofonperson;             //每个月住N晚可以用的消费券
    int activecouponvalue;
    int cellCount;                  // cell的行数
    
    UITableView *orderInfoList;     // 订单信息列表
    UILabel *checkInAndOutLbl;
    UILabel *hotelNameLbl;          // 酒店名
    UILabel *roomTypeLbl;           // 房型
    UILabel *orderPriceLbl;         // 订单总额
    UILabel *couponLbl;
    UILabel *invoiceTipLabel;       // 发票信息提示
    RoomSelectView *roomSelectView; // 房间数量选择控件
    UIButton *customerSelBtn;       // 常用联系人选择
    UITextField *currentTextField;  // 当前正在编辑的文本框
    NSMutableArray *nameArray;      // 入住人姓名
    HttpUtil *getRoomerUtil;        // 预加载联系人请求
    UIImageView *dashView;
    
    ConfirmHotelOrder *hotelconfirmorder;
    ButtonView *invoiceView;        // 发票选择
    UIImageView *bottomView;
    
    UILabel *nomemberTipsLbl;
    
    UILabel *localPricelbl;        //本地货币label
    int invoiceMode;               //开发票方式（开发票方式（0表示没维护,1表示艺龙开发票,2表示酒店开发票）
    
    UIView *mark;
    UIView *ruleView;
    UIButton *cancelRuleBtn;
}

@property (nonatomic, assign) BOOL cheapest;
@property (nonatomic, assign) BOOL isSkipLogin;				// 跳过登录页
@property (nonatomic,copy) NSString *vouchTips;
@property (nonatomic,copy) NSString *linkman;
@property (nonatomic, assign) BOOL couponEnabled;
@property (nonatomic,assign) BOOL requestOver;

@property (nonatomic,assign) BookingType currentBookingType;  //c2c进入或非c2c进入  默认是非C2C
@property(nonatomic,strong)XGSearchFilter *filter;//查询条件
@property(nonatomic,assign)BOOL isUserXinYongCard_C2C;  //是信用卡承担

- (void)booking;
- (NSString*)validateUserInputData;
- (void)rigistersevendayssuccess;

@end
