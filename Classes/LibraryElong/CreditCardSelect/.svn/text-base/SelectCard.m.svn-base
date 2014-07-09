//
//  SelectCard.m
//  ElongClient
//
//  Created by dengfang on 11-1-31.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "SelectCard.h"
#import "DefineHotelResp.h"
#import "SelectCardCell.h"
#import "FlightOrderConfirm.h"
#import "ConfirmHotelOrder.h"
#import "FlightDataDefine.h"
#import "GrouponSharedInfo.h"
#import "GrouponConfirmViewController.h"
#import "InterHotelPostManager.h"
#import "InterHotelConfirmCtrl.h"
#import "ElongInsurance.h"
#import "FlightPostManager.h"
#import "CashAccountTable.h"
#import "AttributedLabel.h"
#import "CashAccountReq.h"
#import "UniformCashAccountModel.h"
#import "CashAccountConfig.h"
#import "RentComfirmController.h"
#import  "TaxiFillManager.h"
#import "UIViewExt.h"
#import "UniformCounterDataModel.h"
#import "CountlyEventClick.h"


#define CARD_CELL_HEIGHT_SMALL 44
#define CARD_CELL_HEIGHT_MIDDLE 88
#define CARD_CELL_HEIGHT_BIG 132

#define VIEW_HEIGHT_0		0
#define VIEW_HEIGHT_1		(VIEW_HEIGHT_0 -80)
#define VIEW_DURATION		0.3
#define kSelectImgTag		7998

static NSMutableArray *allCards  = nil;
static NSMutableArray *cardTypes = nil;

@interface SelectCard()
@property (nonatomic,retain) UIView *guaranteeMarkView;
@property (nonatomic,retain) UIView *guaranteeView;
@property (nonatomic,retain) UIButton *guaranteeCloseBtn;
@end

@implementation SelectCard
@synthesize useCoupon;
@synthesize tabView;

#pragma mark -
#pragma mark Public
- (void)setTabViewHeight:(int)tabelmaxcount
{
}

-(int)labelHeightWithNSString:(UIFont *)font frame:(CGRect)frame string:(NSString *)string width:(int)width
{
	
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000) lineBreakMode:UILineBreakModeWordWrap];
	
	
	return expectedLabelSize.height;
	
}

-(id)init:(NSString *)name style:(NavBtnStyle)style nextState:(int)nextState
{
    return [self init:name style:style nextState:nextState canUseCA:NO];
}


-(id)init:(NSString *)name style:(NavBtnStyle)style nextState:(int)nextState canUseCA:(BOOL)useCA
{
    m_nextState	 = nextState;
    ReceiveMemoryWarning = NO;
    currentRow	 = 0;
    preSelectRow = 0;
    defaultCardCount = [[SelectCard allCards] count];
    usedCA = NO;
    caPayEnough = NO;
    canUseCA = useCA;
    needCheckCard = YES;
    exchangeRate = 1.0;
    dataModel = [UniformCounterDataModel shared];
    
	if (self = [super initWithTopImagePath:nil andTitle:name style:style]) {
        preloadOver = NO;
        
        if ([[SelectCard allCards] count] == 0 &&
            (nextState == HOTEL_STATE || nextState == INTERHOTEL_STATE))
        {
            // 如果酒店没有信用卡客史，之前已经请求过银行列表，无需重复请求
            preloadOver = YES;
        }else if(RENTCAR_STATE == nextState)
        {
            NSLog(@"%@",[SelectCard cardTypes]);
        }else{
            // 预加载银行列表
            [self preRequestBankList];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiCashAccountOpen:)
                                                     name:NOTI_CASHACCOUNT_OPEN
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiCashAccountCancel)
                                                     name:NOTI_CASHACCOUNT_PASSCANCEL
                                                   object:nil];
	}
	
	return self;
}


- (void)backhome
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:ORDER_FILL_ALERT
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}

- (void) back{
    
    if (m_nextState == HOTEL_STATE) {
        // 酒店
        // countly 后退点击事件
        CountlyEventClick *countlyEventClick = [[CountlyEventClick alloc] init];
        countlyEventClick.page = COUNTLY_PAGE_CREDITPAYPAGE;
        countlyEventClick.clickSpot = COUNTLY_CLICKSPOT_BACK;
        [countlyEventClick sendEventCount:1];
        [countlyEventClick release];
    }
    
    [super back];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (0 != buttonIndex) {
		[super backhome];
	}
}

- (void)goOrderConfirm
{
    hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
    hotelconfirmorder.isC2CSuccess  = self.isC2C_order;
    hotelconfirmorder.payType = VouchSetTypeCreditCard;
    [hotelconfirmorder nextState];
    // 暂时屏蔽确认页
    //[self.navigationController pushViewController:hotelconfirmorder animated:YES];
}


// 酒店预订流程确认使用某信用卡进行支付
- (void)confirmHotelUseCard:(NSMutableDictionary *)card
{
    [[HotelPostManager hotelorder] setVouch:1 vouchMoney:vouchMoney vouchData:card];
    
    if (useCoupon) {
        [self goOrderConfirm];
    }else {
        [[Coupon activedcoupons] removeAllObjects];
        [[HotelPostManager hotelorder] setClearCoupons];
        [self goOrderConfirm];
    }
    
    needCheckCard = YES;
}


// 国际酒店流程确认使用某信用卡进行支付
- (void)confirmInterHotelUseCard:(NSMutableDictionary *)card
{
    //写入国际提交订单数据第三步，记录信用卡-----------------------
    JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
    [interOrder setCreditCardData:card];
    //---------------------------------------------------------------------------------
    InterHotelConfirmCtrl *interConfirmCtrl = [[InterHotelConfirmCtrl alloc] init];
    [self.navigationController pushViewController:interConfirmCtrl animated:YES];
    [interConfirmCtrl release];
    
    needCheckCard = YES;
}

// 租车流程确认使用信用卡进行支付
- (void) confirmRentCarUseCard:(NSMutableDictionary *) card
{
    rentContrl = [[RentComfirmController  alloc ]init];
    [rentContrl  setCardMessage:card];
    [rentContrl  requestUrl];
    
}


+ (NSMutableArray *)allCards
{
	@synchronized(allCards) {
		if(!allCards) {
			allCards = [[NSMutableArray alloc] init];
		}
	}
	return allCards;
}

+ (NSMutableArray *)cardTypes
{
	@synchronized(cardTypes)
    {
		if(!cardTypes)
        {
			cardTypes = [[NSMutableArray alloc] init];
		}
	}
	return cardTypes;
}

- (void)requestBankList:(BOOL)isAddCard
{
	[self.view endEditing:YES];
	[self textFieldDidEnd:nil];
	
    if (!preloadOver) {
        // 没有获取到入住人时停止本页请求
        [bankUntil cancel];
    }
    
    // 取缓存数据
    NSDictionary *root = [PublicMethods unCompressData:[[CacheManage manager] getBankListData]];
    if (DICTIONARYHASVALUE(root)) {
        [[SelectCard cardTypes] removeAllObjects];
        [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];
        
        // 直接进入信用卡新增(编辑)页面
        if (isAddCard) {
            [self goAddCardController];
        }
        else {
            [self goModifyCardController];
        }
        
        return;
    }
    
	m_netState = isAddCard ? NETCARDTYPE_STATE : NETCARDTYPE_EDIT;
	JPostHeader *postheader = [[JPostHeader alloc] init];
	[Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
	[postheader release];
}

- (void)preRequestBankList
{
    bankUntil = [[HttpUtil alloc] init];
    JPostHeader *postheader = [[[JPostHeader alloc] init] autorelease];
    [bankUntil connectWithURLString:MYELONG_SEARCH
                            Content:[postheader requesString:YES action:@"GetCreditCardType"]
                       StartLoading:NO
                         EndLoading:NO
                           Delegate:self];
}

- (void)goAddCardController
{
    // 进入新增信用卡页面
    AddAndEditCard *controller = [[AddAndEditCard alloc] initFromType:CardTypeByOther tipOverDue:NO];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)goModifyCardController
{
    // 进入修改信用卡页面
    NSMutableDictionary *card = [[SelectCard allCards] safeObjectAtIndex:currentOverDueRow];
    AddAndEditCard *controller = [[AddAndEditCard alloc] initWithCard:card tipOverDue:YES];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


// 现金账户和信用卡混合支付
- (void)payByCashAccountAndCreditCard
{
    NSArray *rooms = [[HotelDetailController hoteldetail] safeObjectForKey:ROOMS];
    if (ARRAYHASVALUE(rooms))
    {
        NSDictionary *room = [rooms safeObjectAtIndex:[RoomType currentRoomIndex]];
        [[HotelPostManager hotelorder] setCurrency:[room safeObjectForKey:CURRENCY]];
        [[HotelPostManager hotelorder] setToPrePay];
        [[HotelPostManager hotelorder] setCashAmount:[[CashAccountReq shared] cashAccountRemain]];
        
        // 由于使用CA会与coupon冲突，此处必须清空coupon
        [[Coupon activedcoupons] removeAllObjects];
        [[HotelPostManager hotelorder] setClearCoupons];
        
        if (UMENG)
        {
            //礼品卡支付
            [MobClick event:Event_CAOrderSubmit];
        }
    }
    else
    {
        [PublicMethods showAlertTitle:@"订单信息有误" Message:nil];
        return;
    }
    
    [self ccHasValid];
}

#pragma mark -
#pragma mark Net Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
	
    if ([Utils checkJsonIsError:root]) {
        
        return ;
    }
    
    if (util == bankUntil) {
        // 新增信用卡
        [[SelectCard cardTypes] removeAllObjects];
        [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
        [[CacheManage manager] setBankListData:responseData];
        
        preloadOver = YES;
    }
    else {
        switch (m_netState) {
            case NETHOTEL_STATE:
            {
                [[Coupon activedcoupons] removeAllObjects];
                [[Coupon activedcoupons] addObject:[root safeObjectForKey:@"UsableValue"]];
                Coupon *coupon = [[Coupon alloc] init];
                [self.navigationController pushViewController:coupon animated:YES];
                [coupon release];
            }
                break;
            case NETFLIGHT_STATE:
            {
                
            }
                break;
            case NETCARDTYPE_STATE:
            {
                // 新增信用卡
                [[SelectCard cardTypes] removeAllObjects];
                [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
                [[CacheManage manager] setBankListData:responseData];
                
                [self goAddCardController];
            }
                break;
            case NETCARDTYPE_EDIT: {
                // 修改信用卡
                [[SelectCard cardTypes] removeAllObjects];
                [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
                [[CacheManage manager] setBankListData:responseData];
                
                [self goModifyCardController];
            }
                break;
            case kNetTypeCheckPassword:
            {
                if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
                {
                    // 校验密码成功
                    [self payByCashAccountAndCreditCard];
                }
                else
                {
                    // 发送验密成功失败
                    [PublicMethods showAlertTitle:@"密码错误" Message:@"请检查"];
                }
            }
                break;
            case CHECKCCVALID_STATE:
            {
                BOOL isValid=[[root safeObjectForKey:@"IsValid"] boolValue];
                BOOL isInBlackList=[[root safeObjectForKey:@"IsInBlackList"] boolValue];
                BOOL HasVerifyCode = [[root safeObjectForKey:@"HasVerifyCode"] boolValue];
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
                SelectCardCell *cell = (SelectCardCell *)[tabView cellForRowAtIndexPath:path];
                if (HasVerifyCode && !STRINGHASVALUE(cell.codeTF.text)) {
                    [Utils alert:@"该信用卡需要验证码，请填写验证码"];
                    return;
                }
                if (!isValid||isInBlackList) {
                    [Utils alert:@"您的信用卡不能使用"];
                    return ;
                }
                
                // 取得信用卡信息
                NSMutableDictionary *cardDate = [[[NSMutableDictionary alloc] initWithDictionary:[[SelectCard allCards] safeObjectAtIndex:currentRow]] autorelease];
                [cardDate safeSetObject:cell.codeTF.text forKey:@"VerifyCode"];
                
                switch (m_nextState) {
                    case FLIGHT_STATE:
                    {
                        m_netState =NETFLIGHT_STATE;
                        flightOrderConfirm = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:cardDate];
                        [flightOrderConfirm nextState:UniformPaymentTypeCreditCard];
                    }
                        break;
                    case GROUPON_STATE:
                    {
                        grouponConfirmVC = [[GrouponConfirmViewController alloc] initWithCardInfo:cardDate];
                        [grouponConfirmVC nextState];
                    }
                        break;
                    case HOTEL_STATE:
                    {
                        [self confirmHotelUseCard:cardDate];
                    }
                        break;
                    case INTERHOTEL_STATE:{
                        //go inter Order confirm
                        [self confirmInterHotelUseCard:cardDate];
                    }
                        break;
                    case RENTCAR_STATE:{
                        // productId
                        NSString  *productId  = @"";
                        for (NSDictionary *dict in [SelectCard cardTypes]) {
                            if (![dict objectForKey:@""]) {
                                if([[dict objectForKey:@"Id"] intValue] == [[[cardDate objectForKey:@"CreditCardType"] objectForKey:@"Id"] intValue])
                                {
                                    productId = [dict objectForKey:@"ProductId"]  ;
                                }
                            }
                        }
                        NSMutableDictionary *newCard = [NSMutableDictionary dictionaryWithDictionary:cardDate];
                        [newCard setObject:productId forKey:@"ProductId"];
                        [self confirmRentCarUseCard:newCard];
                    }
                        break;
                        
                }
            }
                break;
        }
    }
}

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (util == bankUntil) {
        preloadOver = NO;
    }
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if (util == bankUntil) {
        preloadOver = NO;
    }
}

#pragma mark -
#pragma mark IBAction
- (void)addButtonPressed{
    if (m_nextState == RENTCAR_STATE) {
        [self goAddCardController];
    }else{
        [self requestBankList:YES];
    }
    switch (m_netState) {
        case NETHOTEL_STATE:{
            UMENG_EVENT(UEvent_Hotel_CreditCard_Other)
        }
            break;
        default:{
            
        }
            break;
    }
}

-(BOOL)checkInputData
{
	NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
	SelectCardCell *cell = (SelectCardCell *)[tabView cellForRowAtIndexPath:path];
	
	NSMutableDictionary *card = [[[NSMutableDictionary alloc] initWithDictionary:[[SelectCard allCards] safeObjectAtIndex:currentRow]] autorelease];
	NSString *creditcardstring=[StringEncryption DecryptString:[card safeObjectForKey:@"CreditCardNumber"]];
	
	if ([creditcardstring length]>4) {
		NSString *last4string=[creditcardstring substringFromIndex:[creditcardstring length]-4];
		if ([last4string isEqualToString:cell.cardTF.text]) {
			return YES;
		}
	}
	return NO;
}

-(BOOL)checkInputCardCode
{
	NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
	SelectCardCell *cell = (SelectCardCell *)[tabView cellForRowAtIndexPath:path];
    
	if(cell.codeTF.text.length > 0 && ![[NSPredicate predicateWithFormat:@"SELF MATCHES '\\\\d{3}'"] evaluateWithObject:cell.codeTF.text]) {
		return YES;
	}
    
	return NO;
}

- (void)ccHasValid
{
    if (needCheckCard)
    {
        if ([self checkData])
        {
            m_netState = CHECKCCVALID_STATE;
            JPostHeader *postheader=[[JPostHeader alloc] init];
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
            SelectCardCell *cell = (SelectCardCell *)[tabView cellForRowAtIndexPath:path];
            
            NSString *cardNo = [[[SelectCard allCards] safeObjectAtIndex:currentRow] safeObjectForKey:@"CreditCardNumber"];
            [dict safeSetObject:cardNo forKey:@"CreditCardNo"];
            [dict safeSetObject:cell.codeTF.text forKey:@"VerifyCode"];
            
            [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"VerifyCreditCard" params:dict] delegate:self];
            [dict release];
            [postheader release];
        }
    }
    else
    {
        switch (m_nextState)
        {
            case HOTEL_STATE:
            {
                [self confirmHotelUseCard:[[SelectCard allCards] objectAtIndex:0]];
            }
                break;
            case INTERHOTEL_STATE:
            {
                [self confirmInterHotelUseCard:[[SelectCard allCards] objectAtIndex:0]];
            }
                break;
                
            default:
                break;
        }
    }
}


- (BOOL)checkData
{
    if ([[SelectCard allCards] count]<=0) {
		[Utils alert:@"您未选择信用卡"];
		return NO;
	}
	if (![self checkInputData]) {
		[Utils alert:@"信用卡后四位输入错误"];
		return NO;
	}
	if ([self checkInputCardCode]) {
		[Utils alert:@"请正确填写信用卡三位验证码"];
		return NO;
	}
    
    return YES;
}

#pragma mark -- 触发下订单事件
//btn 触发时间
- (void)nextButtonPressed
{
    if (self.isC2C_order) {  //c2c 网络请求
        
        if (addCardCtroller &&
            !tabView.tableFooterView.hidden &&
            needCheckCard)
        {
            // 直接新增信用卡的情况，把消息转给新增信用卡页面处理
            [addCardCtroller clickConfirmButton];
            return;
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(excuteSelectCard_C2C:)]) {
                [self.delegate excuteSelectCard_C2C:self];
            }
        }
        
    }else{  //除了c2c 的网络请求  原有逻辑
        
        [self nextClickAction];
    }
}

// fixed by lc 执行
-(void)nextClickAction{
    [self.view endEditing:YES];
	[self textFieldDidEnd:nil];
    
    if (addCardCtroller &&
        !tabView.tableFooterView.hidden &&
        needCheckCard)
    {
        // 直接新增信用卡的情况，把消息转给新增信用卡页面处理
        [addCardCtroller clickConfirmButton];
        return;
    }
    
    if (canUseCA &&
        !caTable.useCashAccount &&
        [[SelectCard allCards] count] <= 0)
    {
        [PublicMethods showAlertTitle:@"请选择支付方式" Message:nil];
        return;
    }
    
    if (usedCA)
    {
        if (caTable.needCAPassword &&
            caTable.passwordField.text.length == 0)
        {
            [PublicMethods showAlertTitle:@"请输入支付密码" Message:nil];
            return;
        }
        
        if (!caPayEnough && ![self checkData]) {
            return;
        }
        
        if ([[CashAccountReq shared] cashAccountRemain] >= vouchMoney*exchangeRate)
        {
            // 只使用CA的情况，检查CA密码并提交订单
            [[UniformCashAccountModel shared] beginForType:UniformFromTypeHotel TotalPrice:vouchMoney Password:caTable.passwordField.text];
        }
        else
        {
            // CA余额不足，CA混合信用卡支付的情况
            if ([[CashAccountReq shared] needPassword])
            {
                m_netState = kNetTypeCheckPassword;
                
                [Utils request:GIFTCARD_SEARCH req:[CashAccountReq verifyCashAccountPwdWithPwd:caTable.passwordField.text] delegate:self];
            }
            else
            {
                [self payByCashAccountAndCreditCard];
            }
        }
        
        return;
    }
    else
    {
        // 纯纯的只用信用卡支付
        [self ccHasValid];
    }

}


-(void)updateData
{
	
	[tabView reloadData];
}

#pragma mark -
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad{
	[super viewDidLoad];
    
    // 背景
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT);
    
    // tableview
    tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) style:UITableViewStylePlain];
    tabView.backgroundColor = [UIColor clearColor];
    tabView.delegate = self;
    tabView.dataSource = self;
    tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabView];
    tabView.clipsToBounds = YES;
    
	// 添加底栏
	UIImageView *bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 50, 320, 50)];
	bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = RGBACOLOR(62, 62, 62, 1);
	[self.view addSubview:bottomView];
    [bottomView release];
    
    UILabel *orderPriceLbl  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 50)];
    orderPriceLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    orderPriceLbl.textColor = [UIColor whiteColor];
    orderPriceLbl.minimumFontSize = 14.0f;
    orderPriceLbl.adjustsFontSizeToFitWidth = YES;
    orderPriceLbl.textAlignment = UITextAlignmentCenter;
    [bottomView addSubview:orderPriceLbl];
    [orderPriceLbl release];
    orderPriceLbl.backgroundColor = [UIColor clearColor];
    
	// 下一步按钮
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (m_nextState == INTERHOTEL_STATE) {
        [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else  if (m_nextState == RENTCAR_STATE ||
              m_nextState == GROUPON_STATE)
    {
        [nextButton setTitle:@"确认支付" forState:UIControlStateNormal];
    }
    else {
        [nextButton setTitle:@"提交订单" forState:UIControlStateNormal];
    }
    [nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    [nextButton setImage:nil forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    nextButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 50);
	[bottomView addSubview:nextButton];
    
    // 填写信用卡、使用其他信用卡
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    footerView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    tabView.tableFooterView = footerView;
    
    UIButton *addCrediteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addCrediteBtn.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:addCrediteBtn];
    [addCrediteBtn setBackgroundImage:[UIImage noCacheImageNamed:@"cell_bg.png"] forState:UIControlStateHighlighted];
    addCrediteBtn.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
    [addCrediteBtn addTarget:self action:@selector(addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *splitView0 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
    splitView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [addCrediteBtn addSubview:splitView0];
    [splitView0 release];
    
    UIImageView *splitView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    splitView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [addCrediteBtn addSubview:splitView1];
    [splitView1 release];
    
    
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16, 0, 8, 44)];
    arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
    arrowView.contentMode = UIViewContentModeCenter;
    [addCrediteBtn addSubview:arrowView];
    [arrowView release];
    
    UILabel *addCrediteLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
    addCrediteLbl.font = [UIFont systemFontOfSize:14.0f];
    addCrediteLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    addCrediteLbl.backgroundColor = [UIColor clearColor];
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	addCrediteLbl.text = delegate.isNonmemberFlow ? @"填写信用卡信息" : @"使用其他信用卡";
    [addCrediteBtn addSubview:addCrediteLbl];
    [addCrediteLbl release];
    
    
    //header view
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)] autorelease];
    
    
    switch (m_nextState) {
        case FLIGHT_STATE:{
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
            // 订单总额：
            UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
            priceTipsLbl.font = [UIFont systemFontOfSize:14.0f];
            priceTipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            priceTipsLbl.text = @"订单总额：";
            [headerView addSubview:priceTipsLbl];
            [priceTipsLbl release];
            priceTipsLbl.backgroundColor = [UIColor clearColor];
            
            // 价格
            UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 160, 30)];
            priceLbl.font = [UIFont boldSystemFontOfSize:15.0f];
            priceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
            [headerView addSubview:priceLbl];
            [priceLbl release];
            priceLbl.backgroundColor = [UIColor clearColor];
            
            float orderPriceValue = 0.0;
            float price = 0.0;
            // 计算成人和儿童
            NSArray *passengerList = [[FlightData getFDictionary] safeObjectForKey:KEY_PASSENGER_LIST];
            NSInteger adultCount = 0;
            NSInteger childCount = 0;
            for (NSDictionary *passenger in passengerList) {
                if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 0) {
                    adultCount++;
                }
                else if ([[passenger safeObjectForKey:KEY_PASSENGER_TYPE] integerValue] == 1) {
                    childCount++;
                }
            }
            
            if ([[[FlightData getFDictionary] safeObjectForKey:KEY_SELECT_FLIGHT_TYPE] intValue] == DEFINE_SINGLE_TRIP) {
                
                Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
                price = ([[flight1 getAdultPrice] floatValue] + [[flight1 getAdultOilTax] floatValue] + [[flight1 getAdultAirTax] floatValue]) * adultCount + ([[flight1 getChildPrice] floatValue] + [[flight1 getChildOilTax] floatValue] + [[flight1 getChildAirTax] floatValue]) * childCount;
                
                orderPriceValue = price + [[ElongInsurance shareInstance] getInsuranceTotalPrice];
                // 如果是1小时飞人
                NSNumber *isOneHourObj = [[FlightData getFDictionary] safeObjectForKey:KEY_ISONEHOUR];
                if (isOneHourObj != nil && ([isOneHourObj boolValue] == YES))
                {
                    orderPriceValue = price;
                }
                
                priceLbl.text = [[[NSString alloc] initWithFormat:@"¥%.2f", orderPriceValue] autorelease];
                
            } else {
                Flight *flight1 = [[FlightData getFArrayGo] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_1] intValue]];
                Flight *flight2 = [[FlightData getFArrayReturn] safeObjectAtIndex:[[[FlightData getFDictionary] safeObjectForKey:KEY_CURRENT_FLIGHT_ARRAY_INDEX_2] intValue]];
                price = ([[flight1 getAdultPrice] floatValue] + [[flight1 getAdultOilTax] floatValue] + [[flight1 getAdultAirTax] floatValue]) * adultCount + ([[flight1 getChildPrice] floatValue] + [[flight1 getChildOilTax] floatValue] + [[flight1 getChildAirTax] floatValue]) * childCount;
                price += ([[flight2 getAdultPrice] floatValue] + [[flight2 getAdultOilTax] floatValue] + [[flight2 getAdultAirTax] floatValue]) * adultCount + ([[flight2 getChildPrice] floatValue] + [[flight2 getChildOilTax] floatValue] + [[flight2 getChildAirTax] floatValue]) * childCount;
                orderPriceValue = price + [[ElongInsurance shareInstance] getInsuranceTotalPrice];
                
                priceLbl.text = [[[NSString alloc] initWithFormat:@"¥%.2f", orderPriceValue] autorelease];
            }
            
            orderPriceLbl.text = priceLbl.text;
            
            // 现金账户
            float cashAmountValue = [[[FlightPostManager flightOrder] getCashAmount] floatValue];
            if (cashAmountValue > 0)
            {
                float showPrice = orderPriceValue - cashAmountValue;
                
                priceTipsLbl.text = @"还需支付：";
                
                priceLbl.text = [NSString stringWithFormat:@"¥%.2f",showPrice];
                
                orderPriceLbl.text = [NSString stringWithFormat:@"还需支付：¥%.2f",showPrice];
            }
            
        }
            break;
        case GROUPON_STATE:{
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40 + 20);
            // 订单总额：
            UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
            priceTipsLbl.font = [UIFont systemFontOfSize:14.0f];
            priceTipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            priceTipsLbl.text = @"订单总额：";
            [headerView addSubview:priceTipsLbl];
            [priceTipsLbl release];
            priceTipsLbl.backgroundColor = [UIColor clearColor];
            
            // 价格
            UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
            priceLbl.font = [UIFont boldSystemFontOfSize:15.0f];
            priceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
            [headerView addSubview:priceLbl];
            [priceLbl release];
            priceLbl.backgroundColor = [UIColor clearColor];
            
            
            // 价格构成
            UILabel *priceStructureLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH - 30, 20)];
            priceStructureLbl.font = [UIFont systemFontOfSize:14.0f];
            priceStructureLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            [headerView addSubview:priceStructureLbl];
            [priceStructureLbl release];
            priceStructureLbl.backgroundColor = [UIColor clearColor];
            
            
            // 价格赋值
            GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
            if (gInfo.grouponID)
            {
                // 预订流程
                float showPrice = [gInfo.isInvoice boolValue] ? [gInfo.showTotalPrice floatValue] + [gInfo.expressFee floatValue] : [gInfo.showTotalPrice floatValue];
                float groupUserdCashValue=[gInfo.cashAmount floatValue];
                if (groupUserdCashValue>0)
                {
                    showPrice=showPrice-groupUserdCashValue;
                    priceTipsLbl.text=@"还需支付：";
                }
                priceLbl.text = [NSString stringWithFormat:@"¥%.2f", showPrice];
                
                
                // 价格组成赋值
                NSString *priceStr;
                if ([gInfo.isInvoice boolValue]) {
                    if (groupUserdCashValue > 0){
                        priceStr = [NSString stringWithFormat:@"（¥%.2f x %d + ¥%.2f 快递费 - ¥%.2f现金账户）",
                                    [gInfo.salePrice floatValue],
                                    [gInfo.purchaseNum intValue],
                                    [gInfo.expressFee floatValue],
                                    groupUserdCashValue];
                    }
                    else{
                        priceStr = [NSString stringWithFormat:@"（¥%.2f x %d + ¥%.2f 快递费）",
                                    [gInfo.salePrice floatValue],
                                    [gInfo.purchaseNum intValue],
                                    [gInfo.expressFee floatValue]];
                    }
                }
                else {
                    if (groupUserdCashValue > 0){
                        priceStr = [NSString stringWithFormat:@"（¥%.2f x %d - ¥%.2f现金账户）",
                                    [gInfo.salePrice floatValue],
                                    [gInfo.purchaseNum intValue],
                                    groupUserdCashValue];
                    }
                    else{
                        priceStr = [NSString stringWithFormat:@"（¥%.2f x %d）",
                                    [gInfo.salePrice floatValue],
                                    [gInfo.purchaseNum intValue]];
                    }
                }
                
                priceStructureLbl.text = [NSString stringWithFormat:@"价格组成：%@",priceStr];
                
                orderPriceLbl.text = priceLbl.text;
            }
            else
            {
                // 从首页进入myelong
                float showPrice = dataModel.waitingPayMoney;

                if (dataModel.waitingPayMoney < dataModel.orderTotalMoney)
                {
                    priceTipsLbl.text=@"还需支付：";
                }
                priceLbl.text = [NSString stringWithFormat:@"¥%.2f", showPrice];
                
                orderPriceLbl.text = priceLbl.text;
            }
        }
            break;
        case HOTEL_STATE:{
            if (0 == [[SelectCard allCards] count])
            {
                footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 460)];
                addCardCtroller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeHotel];
                addCardCtroller.delegate = self;
                addCardCtroller.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - tabView.tableHeaderView.frame.size.height - 50);
                addCardCtroller.cardList.scrollEnabled = NO;
                [addCardCtroller setConfirmButtonHidden:YES];
                [footView addSubview:addCardCtroller.view];
                tabView.tableFooterView = footView;
            }
            
            NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
            
            if ([RoomType isPrepay]) {
                headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40 + 20);
                // 订单总额：
                UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
                priceTipsLbl.font = [UIFont systemFontOfSize:14.0f];
                priceTipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);
                priceTipsLbl.text = @"订单总额：";
                [headerView addSubview:priceTipsLbl];
                [priceTipsLbl release];
                priceTipsLbl.backgroundColor = [UIColor clearColor];
                
                // 价格
                UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
                priceLbl.font = [UIFont boldSystemFontOfSize:15.0f];
                priceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
                [headerView addSubview:priceLbl];
                [priceLbl release];
                priceLbl.backgroundColor = [UIColor clearColor];
                
                // 价格构成
                UILabel *priceStructureLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH - 30, 20)];
                priceStructureLbl.font = [UIFont systemFontOfSize:14.0f];
                priceStructureLbl.textColor = RGBACOLOR(52, 52, 52, 1);
                [headerView addSubview:priceStructureLbl];
                [priceStructureLbl release];
                priceStructureLbl.backgroundColor = [UIColor clearColor];
                
                
                // 预付规则
                UILabel *rulesLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH - 30, 0)];
                rulesLbl.font = [UIFont systemFontOfSize:12.0f];
                rulesLbl.textColor = RGBACOLOR(93, 93, 93, 1);
                rulesLbl.numberOfLines = 0;
                rulesLbl.lineBreakMode = UILineBreakModeCharacterWrap;
                [headerView addSubview:rulesLbl];
                [rulesLbl release];
                rulesLbl.backgroundColor = [UIColor clearColor];
                
                
                // 预付流程，价格与全额担保一样
                //汇率
                exchangeRate = [[dic safeObjectForKey:@"ExchangeRate"] floatValue];
                vouchMoney = [[HotelPostManager hotelorder] getTotalPrice];
                float temTotalPrice=[[HotelPostManager hotelorder] getTotalPrice];//用于显示的价格
                
                //现金不算汇率
                if ([[[HotelPostManager hotelorder] getCashAmount] floatValue] > 0)
                {
                    // 如果使用过CA，价格应为总价减去CA部分的价格
                    vouchMoney = [[HotelPostManager hotelorder] getTotalPrice] - [[[HotelPostManager hotelorder] getCashAmount] floatValue];
                    temTotalPrice=exchangeRate>0?temTotalPrice*exchangeRate-[[[HotelPostManager hotelorder] getCashAmount] floatValue]:temTotalPrice-[[[HotelPostManager hotelorder] getCashAmount] floatValue];
                    priceTipsLbl.text=@"还需支付：";
                }
                else
                {
                    temTotalPrice=exchangeRate>0?temTotalPrice*exchangeRate:temTotalPrice;
                }
                
                int couponPrice = 0;
                NSArray *coupons = [[HotelPostManager hotelorder] getCoupons];
                if (ARRAYHASVALUE(coupons)) {
                    // 取出coupon的值
                    couponPrice = [[[coupons safeObjectAtIndex:0] safeObjectForKey:@"CouponValue"] intValue];
                }
                //                priceLbl.text = [NSString stringWithFormat:@"¥%.f", vouchMoney - couponPrice];
                
                //更改bug，预付都是人民币,coupon不算汇率
                priceLbl.text = [NSString stringWithFormat:@"%@%.2f", CURRENCY_RMBMARK, temTotalPrice - couponPrice];
                
                if (couponPrice != 0) {
                    // 如果Ω使用消费券立减后，显示价格构成
                    rulesLbl.frame = CGRectMake(15, 60, SCREEN_WIDTH - 30, 0);
                    
                    NSString *priceStr;
                    priceStr = [NSString stringWithFormat:@"  ¥%.2f - ¥%d（消费券立减）",
                                temTotalPrice, couponPrice];
                    priceStructureLbl.text = priceStr;
                }
                
                // 显示预付规则说明
                NSArray *rules = [dic safeObjectForKey:@"PrepayRules"];
                if (ARRAYHASVALUE(rules)) {
                    
                    NSString *ruleString = [[rules safeObjectAtIndex:0] safeObjectForKey:@"Description"];
                    CGSize textSize = [ruleString sizeWithFont:rulesLbl.font constrainedToSize:CGSizeMake(rulesLbl.frame.size.width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                    rulesLbl.text = ruleString;
                    rulesLbl.frame = CGRectMake(rulesLbl.frame.origin.x, rulesLbl.frame.origin.y, rulesLbl.frame.size.width, textSize.height);
                    
                    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, rulesLbl.frame.origin.y + rulesLbl.frame.size.height + 10);
                }else{
                    if (couponPrice != 0) {
                        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, priceStructureLbl.frame.origin.y + priceStructureLbl.frame.size.height + 10);
                    }else{
                        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
                    }
                }
                
                if (canUseCA)
                {
                    caTable = [[CashAccountTable alloc] initNoMoneyDisplayWithTotalPrice:vouchMoney CashSwitch:YES Frame:CGRectMake(0, headerView.frame.size.height, SCREEN_WIDTH, MAINCONTENTHEIGHT - 50) UniformFromType:UniformFromTypeHotel];
                    caTable.scrollEnabled = NO;
                    [headerView addSubview:caTable];
                    [caTable release];
                    
                    CGRect rect = headerView.frame;
                    rect.size.height += 60;
                    headerView.frame = rect;
                    
                    tableHeaderHeight = rect.size.height;
                }
                
                orderPriceLbl.text = priceLbl.text;
            }
            else {
                // 该酒店需要信用卡担保
                UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 30)];
                tipsLbl.font = [UIFont systemFontOfSize:18.0f];
                tipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);
                tipsLbl.text = @"该酒店需要信用卡担保";
                [headerView addSubview:tipsLbl];
                [tipsLbl release];
                tipsLbl.backgroundColor = [UIColor clearColor];
                
                
                // 订单总额：
                UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 100, 20)];
                priceTipsLbl.font = [UIFont systemFontOfSize:14.0f];
                priceTipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);
                priceTipsLbl.text = @"担保金额：";
                [headerView addSubview:priceTipsLbl];
                [priceTipsLbl release];
                priceTipsLbl.backgroundColor = [UIColor clearColor];
                
                // 价格
                UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 100, 20)];
                priceLbl.font = [UIFont boldSystemFontOfSize:15.0f];
                priceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
                [headerView addSubview:priceLbl];
                [priceLbl release];
                priceLbl.backgroundColor = [UIColor clearColor];
                
                // 担保规则
                UILabel *rulesLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH - 30, 0)];
                rulesLbl.font = [UIFont systemFontOfSize:12.0f];
                rulesLbl.textColor = RGBACOLOR(93, 93, 93, 1);
                rulesLbl.numberOfLines = 0;
                rulesLbl.lineBreakMode = UILineBreakModeCharacterWrap;
                [headerView addSubview:rulesLbl];
                [rulesLbl release];
                rulesLbl.backgroundColor = [UIColor clearColor];
                
                // 担保说明
                UIButton *guaranteeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [guaranteeBtn setTitle:@"担保说明" forState:UIControlStateNormal];
                [guaranteeBtn setTitleColor:RGBACOLOR(52, 52, 52, 1) forState:UIControlStateNormal];
                [guaranteeBtn addTarget:self action:@selector(popupGuaranteeTips) forControlEvents:UIControlEventTouchUpInside];
                [headerView addSubview:guaranteeBtn];
                guaranteeBtn.frame = CGRectMake(SCREEN_WIDTH - 101, 20, 90, 40);
                guaranteeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
                [guaranteeBtn setImage:[UIImage noCacheImageNamed:@"ico_rightarrow.png"] forState:UIControlStateNormal];
                guaranteeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -130);
                
                
                
                
                vouchType = [[[dic safeObjectForKey:@"VouchSet"] safeObjectForKey:@"VouchMoneyType"] intValue];
                if (vouchType == 1) {
                    vouchMoney = [[dic safeObjectForKey:@"FirstDayPrice"] doubleValue]*[[HotelPostManager hotelorder] getRoomCount];
                }else {
                    vouchMoney = [[dic safeObjectForKey:@"TotalPrice"] doubleValue]*[[HotelPostManager hotelorder] getRoomCount];
                }
                
                
                //汇率
                exchangeRate=[[dic safeObjectForKey:@"ExchangeRate"] floatValue];
                //更改bug，担保都是人民币
                priceLbl.text			= [NSString stringWithFormat:@"%@%.2f", CURRENCY_RMBMARK, exchangeRate>0?vouchMoney*exchangeRate:vouchMoney];
                
                rulesLbl.text = [NSString stringWithFormat:@"%@（担保金在离店后立即进行解冻，1-3天到帐）", [[dic safeObjectForKey:@"VouchSet"] safeObjectForKey:@"Descrition"]];
                
                CGSize textSize = [rulesLbl.text sizeWithFont:rulesLbl.font constrainedToSize:CGSizeMake(rulesLbl.frame.size.width, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                rulesLbl.frame = CGRectMake(rulesLbl.frame.origin.x, rulesLbl.frame.origin.y, rulesLbl.frame.size.width, textSize.height);
                
                headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, rulesLbl.frame.origin.y + rulesLbl.frame.size.height + 10);
                
                double totalMoney = [[dic safeObjectForKey:@"TotalPrice"] doubleValue]*[[HotelPostManager hotelorder] getRoomCount];
                
                orderPriceLbl.text = [NSString stringWithFormat:@"%@%.2f", CURRENCY_RMBMARK, exchangeRate>0?totalMoney*exchangeRate : totalMoney];
            }
        }
            break;
        case INTERHOTEL_STATE:{
            if (0 == [[SelectCard allCards] count])
            {
                footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 460)];
                addCardCtroller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeHotel];
                addCardCtroller.delegate = self;
                addCardCtroller.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - tabView.tableHeaderView.frame.size.height - 50);
                addCardCtroller.cardList.scrollEnabled = NO;
                [addCardCtroller setConfirmButtonHidden:YES];
                [footView addSubview:addCardCtroller.view];
                tabView.tableFooterView = footView;
            }
            
            headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
            
            // 订单总额：
            UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
            priceTipsLbl.backgroundColor = [UIColor clearColor];
            priceTipsLbl.font = [UIFont systemFontOfSize:14.0f];
            priceTipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            priceTipsLbl.text = @"订单总额：";
            [headerView addSubview:priceTipsLbl];
            [priceTipsLbl release];
            
            // 价格
            UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
            priceLbl.backgroundColor = [UIColor clearColor];
            priceLbl.font = [UIFont boldSystemFontOfSize:15.0f];
            priceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
            [headerView addSubview:priceLbl];
            [priceLbl release];
            
            // 价格构成
            UILabel *priceStructureLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, SCREEN_WIDTH - 30, 20)];
            priceStructureLbl.backgroundColor = [UIColor clearColor];
            priceStructureLbl.font = [UIFont systemFontOfSize:14.0f];
            priceStructureLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            [headerView addSubview:priceStructureLbl];
            [priceStructureLbl release];
            priceStructureLbl.text = @"信用卡全额支付/人民币扣款";
            
            
            // 预付流程，价格与全额担保一样
            JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
            NSDictionary *interProduct = [interOrder getObjectForKey:Req_InterHotelProducts];
            vouchMoney = [[interProduct safeObjectForKey:Req_OrderTotalPrice] floatValue];
            //减去现金账户支付金额
            float cashAmount = [interOrder getCashAmount];
            priceLbl.text = [NSString stringWithFormat:@"¥%.2f", vouchMoney-cashAmount];
            
            orderPriceLbl.text = priceLbl.text;
        }
            break;
        case RENTCAR_STATE:{
            // 订单总额：
            UILabel *priceTipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
            priceTipsLbl.backgroundColor = [UIColor clearColor];
            priceTipsLbl.font = [UIFont systemFontOfSize:14.0f];
            priceTipsLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            priceTipsLbl.text = @"订单金额：";
            [headerView addSubview:priceTipsLbl];
            [priceTipsLbl release];
            
            // 价格
            UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 30)];
            priceLbl.backgroundColor = [UIColor clearColor];
            priceLbl.font = [UIFont boldSystemFontOfSize:15.0f];
            priceLbl.textColor = RGBACOLOR(254, 75, 32, 1);
            [headerView addSubview:priceLbl];
            [priceLbl release];
            
            UILabel  *preLabel=   [[UILabel alloc] initWithFrame:CGRectMake(priceTipsLbl.left, 40, 100, 30)];
            preLabel.backgroundColor = [UIColor clearColor];
            preLabel.font = [UIFont systemFontOfSize:14.0f];
            preLabel.textColor = [UIColor darkGrayColor];
            preLabel.text = @"预付规则：";
            [headerView addSubview:preLabel];
            [preLabel release];
            
            UILabel *prePayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            prePayLabel.backgroundColor = [UIColor clearColor];
            prePayLabel.font = [UIFont  systemFontOfSize:13];
            prePayLabel.textColor = [UIColor darkGrayColor];
            [headerView addSubview:prePayLabel];
            prePayLabel.numberOfLines = 100;
            prePayLabel.text =PRETIP;
            CGSize  size = [prePayLabel.text  sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(200, 10000)];
            prePayLabel.frame = CGRectMake(priceLbl.left, preLabel.top - 8                                                                          ,200 ,size.height+10);
            
            [prePayLabel release];
            
            
            priceLbl.text = [NSString  stringWithFormat:@"¥%d",[[TaxiFillManager  shareInstance].fillRqModel.orderAmount  intValue ]];
            NSLog(@"%@",[TaxiFillManager  shareInstance].fillRqModel.orderAmount);
            
            
        }
            break;
    }
    
    headerView.clipsToBounds = YES;
    tabView.tableHeaderView = headerView;
    
	
    if (ReceiveMemoryWarning) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
        [self tableView:tabView didSelectRowAtIndexPath:path];
        ReceiveMemoryWarning = NO;
    }
}


- (void) popupGuaranteeTips{
    switch (m_netState) {
        case NETHOTEL_STATE:{
            UMENG_EVENT(UEvent_Hotel_CreditCard_GuaranteeRule)
        }
            break;
        default:{
            
        }
            break;
    }
    // markview
    UIWindow *window = ((ElongClientAppDelegate *)[UIApplication sharedApplication].delegate).window;
    self.guaranteeMarkView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    self.guaranteeMarkView.backgroundColor = [UIColor blackColor];
    self.guaranteeMarkView.alpha = 0.0;
    [window addSubview:self.guaranteeMarkView];
    
    // 单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(guaranteeMarkSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.guaranteeMarkView addGestureRecognizer:singleTap];
    [singleTap release];
    
    NSString *tips = @"    担保将通过预授权的方式冻结您信用卡中相应资金，用于向酒店担保您按时入住以及成功付款离店。\r    此金额仅用来担保，所以您在酒店前台需要支付房费。\r    在您按时入住以及成功付款离店后，艺龙将进行审核，审核无误后在3到5个工作日您的被冻结资金就会解冻。";
    CGSize size = CGSizeMake(280 - 20, 1000);
    CGSize newSize = [tips sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
    newSize.height = newSize.height + 30;   // 标题
    
    // 弹出框
    self.guaranteeView = [[[UIView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT - newSize.height + 20)/2, 280, newSize.height + 20)] autorelease];
    self.guaranteeView.backgroundColor = [UIColor whiteColor];
    [window addSubview:self.guaranteeView];
    self.guaranteeView.alpha = 0.0f;
    
    // title
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.guaranteeView.frame.size.width, 30)];
    titleLbl.textAlignment = UITextAlignmentCenter;
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLbl.text = @"酒店要求担保";
    titleLbl.textColor = RGBACOLOR(52, 52, 52, 1);
    [self.guaranteeView addSubview:titleLbl];
    [titleLbl release];
    
    // 担保说明
    UILabel *tipsLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, self.guaranteeView.frame.size.width - 20, self.guaranteeView.frame.size.height - 20 - 30)];
    tipsLbl.font = [UIFont systemFontOfSize:14.0f];
    tipsLbl.backgroundColor = [UIColor clearColor];
    tipsLbl.numberOfLines = 0;
    tipsLbl.textColor = RGBACOLOR(93, 93, 93, 1);
    tipsLbl.lineBreakMode = UILineBreakModeCharacterWrap;
    [self.guaranteeView addSubview:tipsLbl];
    [tipsLbl release];
    tipsLbl.text = tips;
    
    // 关闭按钮
    self.guaranteeCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.guaranteeCloseBtn setImage:[UIImage noCacheImageNamed:@"closeRoundButton.png"] forState:UIControlStateNormal];
    [window addSubview:self.guaranteeCloseBtn];
    self.guaranteeCloseBtn.alpha = 0.0f;
    [self.guaranteeCloseBtn addTarget:self action:@selector(guaranteeMarkSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    self.guaranteeCloseBtn.frame = CGRectMake(self.guaranteeView.frame.size.width + self.guaranteeView.frame.origin.x - 32, self.guaranteeView.frame.origin.y - 28, 60, 60);
    
    // 动画开始整
    [UIView animateWithDuration:0.3 animations:^{
        self.guaranteeMarkView.alpha = 0.8;
        self.guaranteeView.alpha = 1.0f;
        self.guaranteeCloseBtn.alpha = 1.0f;
    }];
}

- (void)guaranteeMarkSingleTap:(UIGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.3 animations:^{
        self.guaranteeMarkView.alpha = 0.0f;
        self.guaranteeView.alpha = 0.0f;
        self.guaranteeCloseBtn.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.guaranteeMarkView removeFromSuperview];
        [self.guaranteeView removeFromSuperview];
        [self.guaranteeCloseBtn removeFromSuperview];
    }];
}

- (void)textFieldDidActive:(id)sender
{
	if (tabView.contentInset.bottom == 0) {
		tabView.contentInset = UIEdgeInsetsMake(0, 0, 261, 0);
        CGRect rect = [tabView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]];
        [tabView scrollRectToVisible:rect animated:YES];
	}
}

- (void)textFieldDidEnd:(id)sender
{
	if ((tabView.contentInset.bottom != 0 && [sender isFirstResponder]) ||
		!sender) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		tabView.contentInset = UIEdgeInsetsZero;
		
		[UIView commitAnimations];
	}
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
        CustomTextField *customField = (CustomTextField *)textField;
        customField.abcEnabled = NO;
        [customField showNumKeyboard];
    }
    
    return YES;
}

- (void)keyboardWillHide:(NSNotification *)noti
{
	[self textFieldDidEnd:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    ReceiveMemoryWarning = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    SFRelease(grouponConfirmVC);
    self.guaranteeCloseBtn = nil;
    self.guaranteeMarkView = nil;
    self.guaranteeView = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [bankUntil cancel];
    SFRelease(bankUntil);
    
    [grouponConfirmVC release];
    [hotelconfirmorder release];
	[tabView release];
    [rentContrl  release];
    [flightOrderConfirm release];
    [addCardCtroller release];
    [footerView release];
    [footView release];
	
    self.guaranteeCloseBtn = nil;
    self.guaranteeMarkView = nil;
    self.guaranteeView = nil;
    
    [super dealloc];
}


#pragma mark - Notification

- (void)notiCashAccountOpen:(NSNotification *)noti
{
    switch (m_netState) {
        case NETHOTEL_STATE:{
            UMENG_EVENT(UEvent_Hotel_CreditCard_UseCA)
        }
            break;
        default:{
            
        }
            break;
    }
    
    usedCA = YES;
    NSDictionary *obj = [noti object];
    
    float totalMoney = [[obj safeObjectForKey:@"totalPrice"] floatValue];
    float caPayMoney = [[obj safeObjectForKey:@"caPayPrice"] floatValue];  //返现是人名币，不减汇率
    
    NSString *moneyStr = nil;
    
    float money = totalMoney*exchangeRate - caPayMoney;
    moneyStr = [NSString stringWithFormat:@"¥%.2f", money];
    
    CGRect rect = tabView.tableHeaderView.frame;
    CashAccountReq *caReq = [CashAccountReq shared];
    rect.size.height = caReq.needPassword ? 250 : 205;
    tabView.tableHeaderView.frame = rect;
    tabView.tableHeaderView = tabView.tableHeaderView;
    
    if (!caHeaderTitleLabel)
    {
        caHeaderTitleLabel = [[AttributedLabel alloc] initWithFrame:CGRectMake(13, tabView.tableHeaderView.bounds.size.height - 17, 300, 20)];
        caHeaderTitleLabel.text = [NSString stringWithFormat:@"还需支付%@", moneyStr];
        caHeaderTitleLabel.backgroundColor = [UIColor clearColor];
        [caHeaderTitleLabel setColor:RGBCOLOR(153, 153, 153, 1) fromIndex:0 length:caHeaderTitleLabel.text.length];
        [caHeaderTitleLabel setColor:RGBCOLOR(249, 76, 21, 1) fromIndex:4 length:moneyStr.length];
        [caHeaderTitleLabel setFont:FONT_13 fromIndex:0 length:caHeaderTitleLabel.text.length];
        [tabView.tableHeaderView addSubview:caHeaderTitleLabel];
        [caHeaderTitleLabel release];
    }
    
    //    tabView.sectionHeaderHeight = 300;
    
    
    // CA打开时，只存在信用卡一种支付方式，如果CA金额足够支付，隐藏信用卡列表
    if (money > 0)
    {
        // CA余额不足，与信用卡混合支付的情况
        caPayEnough = NO;
        caHeaderTitleLabel.hidden = NO;
        tabView.tableFooterView.hidden = NO;
    }
    else
    {
        // CA余额足够，不需要显示信用卡
        caPayEnough = YES;
        caHeaderTitleLabel.hidden = YES;
        tabView.tableFooterView.hidden = YES;
    }
    
    [tabView reloadData];
}


- (void)notiCashAccountCancel
{
    usedCA = NO;
    caPayEnough = NO;
    caHeaderTitleLabel.hidden = YES;
    CGRect rect = tabView.tableHeaderView.frame;
    rect.size.height = tableHeaderHeight;
    tabView.tableHeaderView.frame = rect;
    tabView.tableHeaderView = tabView.tableHeaderView;
    tabView.tableFooterView.hidden = NO;
    
    if (0 == [[SelectCard allCards] count])
    {
        tabView.tableFooterView = footView;
    }
    else
    {
        tabView.tableFooterView = footerView;
    }
    
    [tabView reloadData];
    //
    //    // CA关闭时，恢复初始时的展示
    //    [showTypes removeAllObjects];
    //    [showTypes addObjectsFromArray:payTypeArray];
    //    [self reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    //    self.tableHeaderView.hidden = NO;
}


#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (0 == [[SelectCard allCards] count] ||
        caPayEnough) {
		return 0;
	}
	else {
		return [[SelectCard allCards] count] + 1;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row != [[SelectCard allCards] count]) {
		NSMutableDictionary *card = [[SelectCard allCards] safeObjectAtIndex:currentRow];
		
		if(currentRow == indexPath.row && ![[card safeObjectForKey:IS_VOER_DUE] boolValue]) {
            NSDictionary *dic = [[SelectCard allCards] safeObjectAtIndex:indexPath.row];
            if (DICTIONARYHASVALUE(dic)) {
                NSDictionary *cardDic = [dic safeObjectForKey:@"CreditCardType"];
                if (cardDic) {
                    NSNumber *needCvv = [cardDic safeObjectForKey:@"Cvv"];
                    
                    if (![needCvv isEqual:[NSNull null]] && [needCvv intValue] == 1) {
                        // 需要添cvv
                        return CARD_CELL_HEIGHT_BIG;
                    }
                    else {
                        // 不需要填cvv
                        return CARD_CELL_HEIGHT_MIDDLE;
                    }
                }
                else {
                    // 没有数据或数据异常时不显示
                    return 0;
                }
            }
            else {
                // 没有数据或数据异常时不显示
                return 0;
            }
		}
		else {
			// 过期或未选中的高度
			return CARD_CELL_HEIGHT_SMALL;
		}
	}
	else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row != [[SelectCard allCards] count]) {
		static NSString *SelectCardKey = @"SelectCardKey";
		SelectCardCell *cell = (SelectCardCell *)[tableView dequeueReusableCellWithIdentifier:SelectCardKey];
		if (cell == nil) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectCardCell" owner:self options:nil];
			cell = [nib safeObjectAtIndex:0];
			cell.selectCard = self;
			cell.isSelected = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.clipsToBounds = YES;
		}
		
		NSUInteger row = [indexPath row];
		
		NSMutableDictionary *card = [[SelectCard allCards] safeObjectAtIndex:row];
        
        // 区分需不需要CVV
        if (DICTIONARYHASVALUE(card)) {
            NSDictionary *cardDic = [card safeObjectForKey:@"CreditCardType"];
            if (cardDic) {
                NSNumber *needCvv = [cardDic safeObjectForKey:@"Cvv"];
                
                if (![needCvv isEqual:[NSNull null]] && [needCvv intValue] == 1) {
                    // 需要添cvv
                    cell.headerView.image = [UIImage noCacheImageNamed:@"fillorder_cell_header.png"];
                    cell.footerView.image = [UIImage noCacheImageNamed:@"fillorder_cell_footer.png"];
                    cell.headerView.hidden = NO;
                    cell.footerView.hidden = NO;
                }
                else {
                    // 不需要填cvv
                    cell.headerView.image = [UIImage noCacheImageNamed:@"fillorder_cell.png"];
                    cell.headerView.hidden = NO;
                    cell.footerView.hidden = YES;
                }
            }
        }
        
        cell.cardTF = nil;
        cell.codeTF = nil;
        
		if ([[card safeObjectForKey:IS_VOER_DUE] boolValue]) {
			// 过期信用卡样式
			cell.isSelected = YES;
			cell.selectImgView.image = [UIImage imageNamed:@"card_overDue_small.png"];
			cell.codeLabel.hidden = YES;
			cell.codeTF.hidden = YES;
			cell.backView.hidden = YES;
			cell.rightArrow.hidden = NO;
			cell.isOverDue = YES;
		}
		else {
			// 没过期的信用卡样式
			cell.isOverDue = NO;
			cell.rightArrow.hidden = YES;
			
			if (currentRow == row) {
                cell.isSelected = YES;
                
                CustomTextField *cardTF = [[[CustomTextField alloc] initWithFrame:CGRectMake(213, 0, 86, 44)] autorelease];
                cell.cardTF = cardTF;
                
                CustomTextField *codeTF = [[[CustomTextField alloc] initWithFrame:CGRectMake(225, 44, 74, 44)] autorelease];
                cell.codeTF = codeTF;
                
                cell.cardTF.font = [UIFont systemFontOfSize:15];
                cell.cardTF.textColor = RGBACOLOR(93, 93, 93, 1.0f);
                cell.cardTF.borderStyle = UITextBorderStyleNone;
                cell.cardTF.numberOfCharacter = 4;
                cell.cardTF.placeholder = @"输入后四位";
                cell.cardTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                
                cell.codeTF.font = [UIFont systemFontOfSize:15];
                cell.codeTF.textColor = RGBACOLOR(93, 93, 93, 1.0f);
                cell.codeTF.borderStyle = UITextBorderStyleNone;
                cell.codeTF.numberOfCharacter = 3;
                cell.codeTF.placeholder = @"输入三位";
                cell.codeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                
				cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
				cell.codeLabel.hidden = NO;
				cell.codeTF.hidden = NO;
				cell.backView.hidden = NO;
				
				NSString *verifyCode=[card safeObjectForKey:@"VerifyCode"];
				NSString *creditcardstring=[StringEncryption DecryptString:[card safeObjectForKey:@"CreditCardNumber"]];
				NSString *last4string=[creditcardstring substringFromIndex:[creditcardstring length]-4];
				
				if (row >= defaultCardCount) {  //if (verifyCode!=nil&&[verifyCode length]!=0)
					cell.cardTF.text=last4string;
					cell.codeTF.text=verifyCode;
				}
				else {
					cell.cardTF.text=@"";
					cell.codeTF.text=@"";
				}
			}
			else{
				cell.isSelected = NO;
				cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
				cell.codeLabel.hidden = YES;
				cell.codeTF.hidden = YES;
				cell.backView.hidden = YES;
			}
		}
		
		cell.nameLabel.text = [[[SelectCard allCards] safeObjectAtIndex:row] safeObjectForKey:@"HolderName"];
        
        NSDictionary *dic = [[SelectCard allCards] safeObjectAtIndex:indexPath.row];
        NSString *bankName = @"";
        if (DICTIONARYHASVALUE(dic)) {
            NSDictionary *cardDic = [dic safeObjectForKey:@"CreditCardType"];
            if (cardDic) {
                NSNumber *needCvv = [cardDic safeObjectForKey:@"Cvv"];
                bankName = [cardDic safeObjectForKey:@"Name"];
                if (![needCvv isEqual:[NSNull null]] && [needCvv intValue] == 1) {
                    CGRect rect = cell.backView.frame;
                    rect.size.height = 85;
                    cell.backView.frame = rect;
                    cell.bottomShadow.frame = CGRectMake(0, 74, 320, 11);
                }
                else {
                    CGRect rect = cell.backView.frame;
                    rect.size.height = 44;
                    cell.backView.frame = rect;
                    cell.bottomShadow.frame = CGRectMake(0, 33, 320, 11);
                }
            }
        }
		
		NSString *cardnum=[[[SelectCard allCards] safeObjectAtIndex:row] safeObjectForKey:@"CreditCardNumber"];
		cell.cardNameLabel.text = bankName;
        if ([dataModel.nonCABanksOfCreditCard containsObject:bankName])
        {
            // 如果该银行不支持CA，需要显示提示
            [cell setCATipHidden:NO];
        }
        else
        {
            [cell setCATipHidden:YES];
        }
        
		NSMutableString *realcardnum=[[NSMutableString alloc] init];
		[realcardnum appendString:[StringEncryption DecryptString:cardnum]];
		[realcardnum deleteCharactersInRange:NSMakeRange(realcardnum.length-4, 4)];
		cell.cardNumLabel.text = [[realcardnum stringByReplaceWithAsteriskFromIndex:4] stringWithCreditFromat];
		[realcardnum release];
        
        cell.cardTF.delegate = self;
        cell.codeTF.delegate = self;
        
        if (indexPath.row == 0) {
            cell.topSplitView.hidden = NO;
            cell.bottomSplitView.hidden = NO;
        }else if (indexPath.row == [[SelectCard allCards] count] - 1){
            cell.topSplitView.hidden = YES;
            cell.bottomSplitView.hidden = NO;
        }else{
            cell.topSplitView.hidden = YES;
            cell.bottomSplitView.hidden = NO;
        }
        
        float rowHeight = [self tableView:tabView heightForRowAtIndexPath:indexPath];
        cell.bottomSplitView.frame = CGRectMake(0, rowHeight - 1, SCREEN_WIDTH, 1);
        
		return cell;
	}
	else {
		// 必要的占位栏
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
														reuseIdentifier:nil] autorelease];
		cell.userInteractionEnabled = NO;
        
		return cell;
	}
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[SelectCard allCards] count] > 0) {
        NSMutableDictionary *card = [[SelectCard allCards] safeObjectAtIndex:indexPath.row];
        NSLog(@"cardNO:%@", [StringEncryption DecryptString:[card safeObjectForKey:@"CreditCardNumber"]]);
        if ([[card safeObjectForKey:IS_VOER_DUE] boolValue]) {
            // 信用卡过期进入信用卡修改页面
            currentOverDueRow = indexPath.row;
            [self requestBankList:NO];
            
            switch (m_netState) {
                case NETHOTEL_STATE:{
                    UMENG_EVENT(UEvent_Hotel_CreditCard_Outdate)
                }
                    break;
                default:{
                    
                }
                    break;
            }
        }
        else {
            currentRow = indexPath.row;
            
            if (currentRow != preSelectRow) {
                [self.view endEditing:YES];
                [self textFieldDidEnd:nil];
                
                // 选中不同行时，刷新该行
                SelectCardCell *cell = (SelectCardCell *)[tableView cellForRowAtIndexPath:indexPath];
                cell.isSelected = YES;
                cell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox_checked.png"];
                float rowHeight = [self tableView:tabView heightForRowAtIndexPath:indexPath];
                cell.bottomSplitView.frame = CGRectMake(0, rowHeight - 1, SCREEN_WIDTH, 1);
                cell.innerSplitView0.hidden = NO;
                [tabView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                // 取消上一行的选中状态
                SelectCardCell *lastCell = (SelectCardCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:preSelectRow inSection:0]];
                lastCell.isSelected = NO;
                
                if (!lastCell.isOverDue) {
                    lastCell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
                }
                lastCell.backView.hidden=YES;
                rowHeight = [self tableView:tabView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:preSelectRow inSection:0]];
                lastCell.bottomSplitView.frame = CGRectMake(0, rowHeight - 1, SCREEN_WIDTH, 1);
                lastCell.innerSplitView0.hidden = YES;
            }
            
            preSelectRow = currentRow;
        }
    }
}

#pragma mark -
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self textFieldDidEnd:nil];
	return [textField resignFirstResponder];
}


#pragma mark -
#pragma mark AddAndEditCardDelegate

- (void)getModifiedCard:(NSDictionary *)dic
{
	[[SelectCard allCards] replaceObjectAtIndex:currentOverDueRow withObject:dic];
	currentRow = currentOverDueRow;
	[tabView reloadData];
}

- (BOOL)checkCardNumberExist:(NSString *)cardNO
{
    for (NSDictionary *dic in [SelectCard allCards]) {
        if ([[dic safeObjectForKey:@"CreditCardNumber"] isEqualToString:cardNO]) {
            return YES;
        }
    }
    
    switch (m_netState) {
        case NETHOTEL_STATE:{
            UMENG_EVENT(UEvent_Hotel_CreditCard_SaveNew)
        }
            break;
        default:{
            
        }
            break;
    }
    
    return NO;
}


- (void)addNewCardFinished:(NSMutableDictionary *)card
{
    [[SelectCard allCards] removeAllObjects];
    [[SelectCard allCards] addObject:card];
    
    needCheckCard = NO;
    [self nextButtonPressed];
}


- (void)textFieldBeginEditingAtIndex:(NSInteger)index
{
    if (tabView.contentInset.bottom == 0)
    {
        tabView.contentInset = UIEdgeInsetsMake(0, 0, 201, 0);
    }
    
    [tabView scrollRectToVisible:CGRectMake(0, tabView.tableHeaderView.frame.size.height + 50 + index * 40, tabView.frame.size.width, 100) animated:YES];
}


- (void)textFieldEndEditing
{
    if (tabView.contentInset.bottom != 0)
    {
		tabView.contentInset = UIEdgeInsetsZero;
    }
}

@end
