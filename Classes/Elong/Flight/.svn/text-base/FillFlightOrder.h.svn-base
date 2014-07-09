//
//  FillFlightOrder.h
//  ElongClient
//  填写订单
//  Created by dengfang on 11-1-24.
//  Copyright 2011 shoujimobile. All rights reserved.
//
//  修改为直接跳入统一收银台，而不是订单确认页 by 赵海波 on 14-4-8

#import <UIKit/UIKit.h>
#import "CustomSegmentedDelegate.h"
#import "AddFlightCustomerDelegate.h"

#define flight_passenger                     @"flight_passenger"
#define flight_passenger_type                @"flight_passenger_type"
#define flight_passenger_time                @"flight_passenger_time"
#define flight_passenger_adult               @"flight_passenger_adult"
#define flight_passenger_adult_insurance     @"flight_passenger_adult_insurance"
#define flight_passenger_child               @"flight_passenger_child"
#define flight_passenger_child_insurance     @"flight_passenger_child_insurance"

@class EmbedTextField;
@class FlightOrderBottomBar;

@interface FillFlightOrder : ElongBaseViewController <UITextFieldDelegate,UIScrollViewDelegate, CustomSegmentedDelegate, UITableViewDelegate, UITableViewDataSource,  CustomABDelegate, UIGestureRecognizerDelegate, AddFlightCustomerDelegate> {
 
    IBOutlet UILabel *topTip;
	IBOutlet UIScrollView *rootScrollView;//Xib上除了上部提示栏之外的 容器
	//------------------- 1 view
	IBOutlet UIView *selectView;
	//IBOutlet UILabel *selectNumLabel;
	IBOutlet UIImageView *selectArrowImageView;
	IBOutlet UIButton *selectCustomerButton;
//	IBOutlet UITableView *tabView;
	//IBOutlet UILabel *otherCustomerLabel;
    
    IBOutlet UILabel *chengJiRenTip;
    
	NSMutableArray *customerArray;
	NSMutableArray *selectRowArray;
	NSMutableArray *customerAllArray;//dictionary: name, type, number
	
	//------------------- 2 view
	IBOutlet UIView *contactView;
	IBOutlet UITextField *contactNameTextField;

	UIButton *nextButton;
	int m_iState;
	int m_itineraryType;    //行程单取的类型 0 为邮寄，1为机场自取
    int currentPassengerIndex;      // 当前选中的乘客顺序
    NSString *SavePhoneNOString;
    
    BOOL ChecekBoxorNot;
    BOOL isNewAddFlight;        // 是否为添加乘机人状态，default=NO
    
	IBOutlet UIImageView *checkBoxView;//被switch替换！
    
	//add new
	IBOutlet UILabel *travelOrderLabel;//形成单
	IBOutlet UIButton *travelBtn;//形成单Btn
    
    //2013 12 19
    IBOutlet UIView *insAndOrder;//第三view模块
    
    IBOutlet UILabel *insuranceNumslabel;//保险的份数
    IBOutlet UIButton *editInsuranceBtn;//进入保险编辑的按钮
    IBOutlet UIButton *insuranceBtn;//保险说明按钮
    IBOutlet UILabel *insuranceLabel;//保险说明label
    IBOutlet UISwitch *travelOrederSwitch;//是否开启形成单
    IBOutlet UILabel *travelOrderTip;//行程单的tip显示
    
    FlightOrderBottomBar *bar;
    ElongClientAppDelegate *appDelegate;
    HttpUtil *getRoomerUtil;        // 请求乘机人
    
/*
 ***************************************************************************************************
以下的在新版中都没用！(2012 12 23)
 */
    //------------------- 3 view
	IBOutlet UIView *priceView;
	IBOutlet UILabel *priceLabel;
    IBOutlet UIImageView *couponIcon;       // 返现标志
    IBOutlet UILabel *couponLabel;          // 显示消费券金额的提示
    //支付
    IBOutlet UIImageView *paymentImageView;
	IBOutlet UIImageView *creditCardImageView;
	IBOutlet UILabel *creditCardLabel;
	IBOutlet UIButton *creditCardBtn;
	IBOutlet UILabel *paymentLabel;
	IBOutlet UIButton *paymentBtn;
	IBOutlet UIImageView *upLine;
	IBOutlet UIImageView *middelLine;
	IBOutlet UIImageView *bottomLine;
	IBOutlet UILabel *orderTotalNoteLabel;
	IBOutlet UILabel *priceMarkLabel;
    
    UITableView *fillTable;
    UIView *chooseHeaderView;
    UIActivityIndicatorView *loadingView;    // 加载乘机人时的小loading框
    BOOL needTicket;            // 是否需要行程单,default = NO
    BOOL haveSelfGetAddress;    // 是否有机场自取地址，dufault＝YES
    BOOL textFieldActive;       // 文本框是否处于编辑状态,default＝NO
    NSInteger bottomCellNum;    // 底部行程单部分展示的cell数,default＝0
    NSInteger showType;         // 展示的类型，默认展示行程单地址
    NSInteger currentIndex;     // 选中邮寄地址的序号,default = 0
    NSInteger currentAirIndex;  // 选中机场地址的序号,default = 0
    double orderPrice;          // 订单总价
    
    HttpUtil *postAddressUtil;      // 请求邮寄行程单
    HttpUtil *selfGetAddressUtil;   // 请求机场自取地址
    NSMutableArray *postAddressArray;   // 行程单信息数组
    NSMutableArray *selfGetAddressArray;   // 机场自取地址数组
    UILabel *ticketTipLabel;        // 底部提示文字
    
    UIImageView *bottomView;
    UILabel *orderPriceLbl;         // 订单总额
    UILabel *couponLbl;
    UIView *viewResponder;
}

@property (nonatomic, assign) BOOL requestOver;       // 表示是否已经请求过乘机人
@property (nonatomic, copy) NSString *savePhoneNO;
@property (nonatomic, retain) UITableView *tabView;
@property (nonatomic, retain) NSMutableArray *customerArray;
@property (nonatomic, retain) NSMutableArray *selectRowArray;
@property (nonatomic, retain) UILabel *priceLabel;
@property (nonatomic, retain) NSMutableArray *customerAllArray;
@property (nonatomic, assign) BOOL isSkipLogin;				// 跳过登录页
@property (nonatomic, assign) NSInteger couponCount;        // 可使用消费券的金额

@property (nonatomic, assign) BOOL isPriceDetailSelected;
@property (nonatomic, assign) NSInteger costAdultPrice;
@property (nonatomic, assign) NSInteger costAdultOilTaxPrice;
@property (nonatomic, assign) NSInteger costAdultAirTaxPrice;
@property (nonatomic, assign) NSInteger costChildPrice;
@property (nonatomic, assign) NSInteger costChildOilTaxPrice;
@property (nonatomic, assign) NSInteger costChildAirTaxPrice;
@property (nonatomic, assign) NSInteger costInsurancePrice;
@property (nonatomic, retain) UIButton *popupButton;
@property (nonatomic, assign) NSInteger costInsurancePersonCount;
@property (nonatomic, assign) BOOL is51Book;         // 是否51产品
@property (nonatomic, assign) BOOL isOneHour;        // 是否一小时飞人
@property (nonatomic, retain) NSString *saveInvoiceTitle;

//
@property (nonatomic, assign) CGPoint tableViewPreOffset;   //键盘显示前 tableView的offset

- (void)setTabViewHeight;
- (IBAction)selectCustomerButtonPressed;
- (IBAction)nextButtonPressed;
//- (IBAction)textFieldDoneEditing:(id)sender;
//- (IBAction)textFieldDidBegin:(id)sender;
- (IBAction)switchValueChanged;
- (IBAction)clickAddPhoneNumber;

//New 2013 12-19
- (IBAction)travelOrderSwitchMethord:(id)sender;
- (IBAction)insuranceBtnPressed:(id)sender;//进入保险说明界面
- (IBAction)collectInsuranceInfo:(id)sender;//进入保险编辑页面

//支付
//-(IBAction)selectPayment;
//-(IBAction)selectCreditCard;
+(BOOL) getIsPayment;
+(void)setIsPayment:(BOOL)payment;

- (void)clickPostButton;           
- (void)clickSelfGetButton;
- (void)setTotalPrice:(double)total;            // 设置总价
- (void)refreshData;        // 刷新数据

// Add 2014/02/20
@property (nonatomic, retain) NSMutableArray *passengerAdultArray;
@property (nonatomic, retain) NSMutableArray *passengerChildArray;
@property (nonatomic, retain) NSMutableArray *insuranceAdultArray;
@property (nonatomic, retain) NSMutableArray *insuranceChildArray;
// End

@end
