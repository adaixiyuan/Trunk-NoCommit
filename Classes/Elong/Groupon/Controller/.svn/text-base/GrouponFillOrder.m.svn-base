//
//  GrouponFillOrder.m
//  ElongClient
//  团购订单填写
//
//  Created by haibo on 11-11-23.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponFillOrder.h"
#import "GrouponSharedInfo.h"
#import "GrouponTipViewCtroller.h"
#import "GrouponInvoiceFillController.h"
#import "AccountManager.h"
#import "RoundCornerView.h"
#import "OnOffView.h"
#import "SelectCard.h"
#import "FXLabel.h"
#import "EmbedTextField.h"
#import "GrouponConfirmViewController.h"
#import "GrouponOrderInvoiceCell.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"
#import "PaymentTypeVC.h"
#import "UniformCounterViewController.h"
#import "GOrderRequest.h"
#import "UrgentTipManager.h"

#define NET_TYPE_BANK_LIST              111
#define NET_TYPE_ADDRESS                112
#define NET_TYPE_CREDITCARD             113
#define NET_TYPE_CHECK_CASHACCOUNT      115
#define NET_TYPE_COMMITORDER            116
#define INVOICE_FIELD_TAG 4011

#define SCREEN_HEIGHT_CHANGE 210

@interface GrouponFillOrder()
@property (nonatomic,copy) NSString *phoneNum;                  // 手机号
@property (nonatomic,assign) GrouponPayType grouponPayType;     // 支付方式
@property (nonatomic,assign) BOOL cashAccountOpen;              // 是否启用现金账户
@property (nonatomic,assign) BOOL invoiceOpen;                  // 是否启用发票
@property (nonatomic,assign) BOOL invoiceHidden;                // 是否显示发票
@property (nonatomic,assign) BOOL alipayHidden;                 // 是否显示支付宝
@property (nonatomic,assign) BOOL cashAccountHidden;            // 是否显示现金账户

//发票
@property (nonatomic,assign) NSInteger invoiceIndex;
@property (nonatomic,copy) NSString *invoiceType;
@property (nonatomic,copy) NSString *invoiceTitle;
@property (nonatomic,copy) NSString *invoiceTips;
@end

@implementation GrouponFillOrder
@synthesize phoneNum;
@synthesize isSkipLogin;
@synthesize grouponPayType;
@synthesize cashAccountOpen;
@synthesize invoiceHidden;
@synthesize invoiceOpen;
@synthesize alipayHidden;
@synthesize cashAccountHidden;

/* 支付方式 */
static BOOL isGrouponPayment = NO;

+(BOOL) getIsGrouponPayment{
    return isGrouponPayment;
}

+(void)setIsGrouponPayment:(BOOL)grouponPay{
    isGrouponPayment = grouponPay;
}


#pragma mark -
#pragma mark Initialization

- (void) dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [grouponConfirmVC release];
    
    // 邮寄地址请求
    if (addressUtil) {
        [addressUtil cancel];
        SFRelease(addressUtil);
    }
    
    self.invoiceType=nil;
    self.invoiceTitle=nil;
    self.invoiceTips=nil;
    
    [invoiceSelect release];
    [[UrgentTipManager sharedInstance] cancelUrgentTip];
    [super dealloc];
}

- (id)init {
	if (self = [super initWithTopImagePath:nil andTitle:@"填写订单" style:_NavNoTelStyle_]) {
        // 初始化数据
		gInfo			 = [GrouponSharedInfo shared];
		showUnitPrice	 = (int)round([gInfo.salePrice floatValue]);    // 显示卖价
		realUnitPrice	 = [gInfo.salePrice floatValue];                // 真实卖价
		purchaseNum		 = 1;                                           // 数量
		keyboardShowing	 = NO;                                          // 键盘是否显示
        noCardRecord     = NO;                                          // 是否有信用卡记录
		self.isSkipLogin = NO;                                          // 是否跳过登录
        
        self.invoiceType=@"会务费";
        self.invoiceTips=[[gInfo.detailDic safeObjectForKey:@"ProductDetail"] safeObjectForKey:@"HotelInvoiceModeTips"];
        
        // 是否支持艺龙发票
        if ([gInfo.InvoiceMode intValue] == 1) {
            self.invoiceHidden = NO;
        }
        else{
            self.invoiceHidden = YES;
        }
        self.invoiceOpen = NO;
        
//        self.invoiceHidden = NO;
        
        // 是否支持支付宝
        ElongClientAppDelegate *appDelegate  = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if([ProcessSwitcher shared].allowAlipayForGroupon && !appDelegate.isNonmemberFlow){
			self.alipayHidden = NO;     // 会员流程才有支付宝支付
		}else{
            self.alipayHidden = YES;
        }
        
        // 是否支持现金账户
        self.cashAccountOpen = NO;
        self.cashAccountHidden = YES;
        
        // 默认支付方式
        self.grouponPayType = GrouponCreditCard;
        [GrouponFillOrder setIsGrouponPayment:NO];
        
        // 手机号
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.phoneNum = delegate.isNonmemberFlow ? [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE] : [[AccountManager instanse] phoneNo];
        
        
        if (UMENG) {
            //团购酒店订单页面
            [MobClick event:Event_GrouponHotelOrder];
        }
		
        // 初始化界面
        [self initView];
        
        if (IOSVersion_7 || (IOSVersion_4 && !IOSVersion_5)) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFillInfo:) name:ADDRESS_ADD_NOTIFICATION object:nil];
	}
	
	return self;
}

#pragma mark -
#pragma mark Private Methods

// 界面初始化
- (void) initView
{
    // order list
    orderList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44) style:UITableViewStylePlain];
    orderList.delegate = self;
    orderList.dataSource = self;
    orderList.backgroundColor = [UIColor clearColor];
    orderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:orderList];
    [orderList release];
    
    //增加footview
    [self addTabelViewFootView];
    
    // bottom bar
    [self addBottomBar];
}

-(void) addTabelViewFootView
{
    UIView *footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80+40)];//40是底部留白
    
    footView.backgroundColor=[UIColor clearColor];
    
    UILabel *faPiaoTips = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, SCREEN_WIDTH - 20, 37)];
    faPiaoTips.backgroundColor	= [UIColor clearColor];
    faPiaoTips.font = [UIFont systemFontOfSize:12];
    faPiaoTips.textColor = RGBACOLOR(57, 57, 57, 1);
    faPiaoTips.lineBreakMode = UILineBreakModeCharacterWrap;
    faPiaoTips.backgroundColor = [UIColor clearColor];
    faPiaoTips.numberOfLines = 0;
    [footView addSubview:faPiaoTips];
    [faPiaoTips release];
    if (STRINGHASVALUE(self.invoiceTips))
    {
        faPiaoTips.text=[NSString stringWithFormat:@"● %@",self.invoiceTips];
    }
    else
    {
        faPiaoTips.text = @"● 本产品发票由预约酒店提供，请消费时向预约酒店索取。";
    }
    
    UILabel *someTips = [[UILabel alloc] initWithFrame:CGRectMake(10, 43, SCREEN_WIDTH - 20, 37)];
    someTips.font = [UIFont systemFontOfSize:12];
    someTips.textColor = RGBACOLOR(57, 57, 57, 1);
    someTips.lineBreakMode = UILineBreakModeCharacterWrap;
    someTips.backgroundColor = [UIColor clearColor];
    someTips.numberOfLines = 0;
    [footView addSubview:someTips];
    [someTips release];
    someTips.text = @"● 购买成功后将把团购券和密码发至您的手机，凭券和密码去酒店消费。";
    
    if(self.invoiceHidden)
    {
        faPiaoTips.hidden=NO;
        faPiaoTips.frame = CGRectMake(10, 12, SCREEN_WIDTH - 20, 37);
        someTips.frame = CGRectMake(10, 43, SCREEN_WIDTH - 20, 37);
    }
    else
    {
        faPiaoTips.hidden=YES;
        someTips.frame = CGRectMake(10, 12, SCREEN_WIDTH - 20, 37);
    }
    
    footView.frame=CGRectMake(footView.frame.origin.x, footView.frame.origin.y, footView.frame.size.width, someTips.frame.origin.y+someTips.frame.size.height+10);
    
    orderList.tableFooterView=footView;
    [footView release];
    
    //获取紧急提示
    UITableView *weakOrderInfoTable = orderList;
    [[UrgentTipManager sharedInstance] urgentTipViewofCategory:GrouponFillOrderUrgentTip completeHandle:^(UrgentTipView *urgentTipView) {
        CGRect frame = urgentTipView.frame;
        frame.origin.y = weakOrderInfoTable.tableFooterView.height;
        urgentTipView.frame = frame;
        
        UIView *tmpFooterView = weakOrderInfoTable.tableFooterView;
        [tmpFooterView addSubview:urgentTipView];
        
        CGRect footerFrame = tmpFooterView.frame;
        footerFrame.size.height = urgentTipView.origin.y + urgentTipView.frame.size.height;
        tmpFooterView.frame = footerFrame;
        [weakOrderInfoTable setTableFooterView:tmpFooterView];
    }];
}

- (void)addBottomBar {
    // 加入底部工具条
	UIImageView *bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, SCREEN_WIDTH, 44)];
	bottomBar.backgroundColor = RGBACOLOR(62, 62, 62, 1);
    [self.view addSubview:bottomBar];
    [bottomBar release];
    bottomBar.userInteractionEnabled = YES;
    
    // 现价
    salePriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 190 ,44)];
    salePriceLbl.font = [UIFont boldSystemFontOfSize:22.0f];
    salePriceLbl.backgroundColor = [UIColor clearColor];
    salePriceLbl.adjustsFontSizeToFitWidth = YES;
    salePriceLbl.textAlignment = NSTextAlignmentLeft;
    salePriceLbl.minimumFontSize = 14.0f;
    salePriceLbl.textColor = [UIColor whiteColor];
    [bottomBar addSubview:salePriceLbl];
    [salePriceLbl release];
    salePriceLbl.text = [NSString stringWithFormat:@"总额：¥%.f",realUnitPrice * purchaseNum];
    
    // 购买按钮
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_normal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage stretchableImageWithPath:@"btn_default2_press.png"] forState:UIControlStateHighlighted];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    nextButton.exclusiveTouch = YES;
	nextButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 44);
	[bottomBar addSubview:nextButton];
}


// 返回
- (void)back {
	if (isSkipLogin) {
		NSArray *navCtrls = self.navigationController.viewControllers;
		[self.navigationController popToViewController:[navCtrls safeObjectAtIndex:[navCtrls count] - 3] animated:YES];
	}
	else {
		[super back];
	}
}

// home
- (void)backhome {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:ORDER_FILL_ALERT
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}

//
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (0 != buttonIndex) {
		[super backhome];
	}
}

- (void)closeKeyboard:(id)sender {
	// 关闭键盘
	[sender resignFirstResponder];
}


- (BOOL)inputDataIsRight {
	// 检测输入值是否附和要求
	if (!STRINGHASVALUE(self.phoneNum)) {
		[PublicMethods showAlertTitle:@"手机号码为空" Message:@"请输入"];
		return NO;
	}
	else {
		if (!MOBILEPHONEISRIGHT(self.phoneNum)) {
			[PublicMethods showAlertTitle:_string(@"s_phonenum_iserror") Message:nil];
			return NO;
		}
	}
	return YES;
}


- (void)nextButtonClick:(id)sender {
	[self.view endEditing:YES];
	// 点击确认按钮
	if (![self inputDataIsRight])
    {
		return;
	}
    
    // 发票
    if (self.invoiceOpen)
    {
        // 点击下一步的操作
        [self.view endEditing:YES];
        
        if (!STRINGHASVALUE(self.invoiceTitle)) {
            [PublicMethods showAlertTitle:nil Message:@"发票抬头为空"];
            return;
        }
        else if ([StringFormat isContainedSpecialChar:self.invoiceTitle])
        {
            [PublicMethods showAlertTitle:nil Message:@"发票抬头包含特殊字符或数字"];
            return;
        }
        
        if (0 == [invoiceAddresses count])
        {
            [PublicMethods showAlertTitle:nil Message:@"请新增邮寄地址"];
            return;
        }
        
        NSString *phoneNo=nil;
        ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if (!delegate.isNonmemberFlow)
        {
            phoneNo=[[AccountManager instanse] phoneNo];
        }
        else
        {
            phoneNo=[[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE];
        }
        
        if (!STRINGHASVALUE(phoneNo))
        {
            //never go here
            phoneNo=@"13439760221";
        }
        
        // 发票信息存入
        NSDictionary *invoiceDict = [invoiceAddresses objectAtIndex:self.invoiceIndex];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    self.invoiceTitle, invoiceTitle_API,
                                    self.invoiceType, type_API,
                                    [invoiceDict objectForKey:KEY_NAME], receiver_API,
                                    [invoiceDict objectForKey:KEY_ADDRESS_CONTENT], address_API,
                                    DEFAULTPOSTCODEVALUE, postCode_API,
                                    phoneNo, phone_API,nil];
        gInfo.invoiceInfo = dic;
    }
    else
    {
        gInfo.invoiceInfo=nil;
    }
    
	// 存入输入信息
	gInfo.showTotalPrice = [NSNumber numberWithInteger:showUnitPrice * purchaseNum];
	gInfo.realTotalPrice = [NSNumber numberWithFloat:realUnitPrice * purchaseNum];
	gInfo.purchaseNum	 = [NSNumber numberWithInteger:purchaseNum];
	gInfo.isInvoice		 = [NSNumber numberWithBool:self.invoiceOpen];
	gInfo.mobile		 = self.phoneNum;
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    //会员进入统一收银台
	if (!delegate.isNonmemberFlow)
    {
        GOrderRequest *orderReq = [GOrderRequest shared];
        [orderReq reGatherData];
        NSDictionary *reqContent = [orderReq getContent];
        [[Profile shared] start:@"团购下单"];
        
        UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
        NSLog(@"%@", dataModel.currentOrderReq);
        // 先成单,后支付
        if ([dataModel.currentOrderReq isEqualToDictionary:reqContent])
        {
            // 已经成过单，直接验证CA进入收银台页面，不再重复成单
            dataModel.delegate = self;
            [dataModel refreshDataWithOrderID:dataModel.orderID tradeToken:dataModel.tradeToken bizType:GROUPON_BIZTYPE];
        }
        else
        {
            // 没有成过单，需要提交订单
            netType = NET_TYPE_COMMITORDER;
            [dataModel.currentOrderReq removeAllObjects];
            [dataModel.currentOrderReq addEntriesFromDictionary:reqContent];
            
            [HttpUtil requestURL:[HttpUtil javaAPIPostReqInDomain:API_DOMAIN_tuan atFunction:API_FUNCTION_createOrderFirst]
                     postContent:[orderReq getGrouponOrderReq]
                        delegate:self];
        }
	}
	else
    {
		// 非注册用户流程
		// 记录非注册用户的电话、邮箱
		[[NSUserDefaults standardUserDefaults] setObject:self.phoneNum forKey:NONMEMBER_PHONE];
        
        // 非会员直接进入信用卡填写页面
        noCardRecord = YES;
        netType = NET_TYPE_BANK_LIST;
        
        JPostHeader *postheader = [[JPostHeader alloc] init];
        [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
        [postheader release];
	}
}


#pragma mark -
#pragma mark NetWork Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    
    //发票常用地址
    if(util == addressUtil)
    {
        // 请求邮寄地址
        if ([Utils checkJsonIsErrorNoAlert:root])
        {
            return;
        }
        
        for (NSDictionary *dict in [root safeObjectForKey:KEY_ADDRESSES]) {
            NSMutableDictionary *dDictionary = [[NSMutableDictionary alloc] init];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_CONTENT] forKey:KEY_ADDRESS_CONTENT];
            [dDictionary safeSetObject:[dict safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
            [invoiceAddresses addObject:dDictionary];
            [dDictionary release];
        }

        [orderList reloadData];
        return;
    }
    else
    {
        if ([Utils checkJsonIsError:root])
        {
            //提交订单失败，清除请求记录
            if(netType == NET_TYPE_COMMITORDER)
            {
                UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
                [dataModel.currentOrderReq removeAllObjects];
            }
            return;
        }
        
        switch (netType) {
            case NET_TYPE_ADDRESS:{
                // 进入发票填写页面
                GrouponInvoiceFillController *controller = [[GrouponInvoiceFillController alloc] initWithAddressInfo:root];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
                break;
            case NET_TYPE_CREDITCARD:{
                
                [[SelectCard allCards] removeAllObjects];
                NSArray *cards = [root safeObjectForKey:@"CreditCards"];
                if ([cards isKindOfClass:[NSArray class]] && [cards count] > 0){
                    // 已有信用卡纪录时进入信用卡选择页面
                    [[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
                    
                    SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:GROUPON_STATE];
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                    
                    if (UMENG) {
                        //团购酒店信用卡支付页面
                        [MobClick event:Event_GrouponHotelOrder_CreditCard];
                    }
                }
                else {
                    // 没有信用卡时请求银行列表界面
                    noCardRecord = YES;
                    netType = NET_TYPE_BANK_LIST;
                    
                    JPostHeader *postheader = [[JPostHeader alloc] init];
                    [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
                    [postheader release];
                }
            }
                break;
            case NET_TYPE_BANK_LIST:{
                // 没有信用卡时进入信用卡填写界面
                noCardRecord = NO;
                
                [[SelectCard cardTypes] removeAllObjects];
                [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
                
                AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeGroupon];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                
                if (UMENG) {
                    //团购酒店信用卡支付页面
                    [MobClick event:Event_GrouponHotelOrder_CreditCard];
                }
            }
                break;
            case NET_TYPE_CHECK_CASHACCOUNT:
            {
                BOOL canUseCA = NO;                 // 是否可使用CA支付
                
                if ([[root safeObjectForKey:CACHE_ACCOUNT_AVAILABLE] safeBoolValue] &&
                    [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue] > 0)
                {
                    // CA可用的情况
                    CashAccountReq *cashAccount = [CashAccountReq shared];
                    cashAccount.needPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
                    cashAccount.cashAccountRemain = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
                    
                    canUseCA = YES;
                }
                
                // 统一收银台相关参数构造
                CGFloat payMoney = [gInfo.isInvoice boolValue] ? [gInfo.showTotalPrice intValue] + (int)round([gInfo.expressFee floatValue]) : [gInfo.showTotalPrice intValue];
                
                // 分三行显示酒店名称、价格和有效期
                NSString *grouponName = [NSString stringWithFormat:@"%@", gInfo.prodName];
                
                NSString *priceStr;
                if ([gInfo.isInvoice boolValue])
                {
                    priceStr = [NSString stringWithFormat:@"¥%dx%d + ¥%.2f 快递费",
                                (int)round([gInfo.salePrice floatValue]),
                                [gInfo.purchaseNum intValue],
                                [gInfo.expressFee floatValue]];
                }
                else
                {
                    priceStr = [NSString stringWithFormat:@"¥%d x %d份",
                                (int)round([gInfo.salePrice floatValue]),
                                [gInfo.purchaseNum intValue]];
                }
                
                NSString *inDateStr = gInfo.inDateDescription;
                
                NSArray *titles = [NSArray arrayWithObjects:grouponName, priceStr, inDateStr, nil];
                
                // 进入统一收银台
                UniformCounterViewController *control = [[UniformCounterViewController alloc] initWithTitles:titles orderTotal:payMoney cashAccountAvailable:canUseCA UniformFromType:UniformFromTypeGroupon];
                [self.navigationController pushViewController:control animated:YES];
                [control release];
                
//                // 统一收银台相关参数构造
//                CGFloat payMoney = [gInfo.isInvoice boolValue] ? [gInfo.showTotalPrice intValue] + (int)round([gInfo.expressFee floatValue]) : [gInfo.showTotalPrice intValue];
//                
//                // 分两行显示酒店名称和价格构造
//                NSString *grouponName = [NSString stringWithFormat:@"%@", gInfo.prodName];
//                
//                NSString *priceStr;
//                if ([gInfo.isInvoice boolValue])
//                {
//                    priceStr = [NSString stringWithFormat:@"¥%dx%d + ¥%.2f 快递费",
//                                (int)round([gInfo.salePrice floatValue]),
//                                [gInfo.purchaseNum intValue],
//                                [gInfo.expressFee floatValue]];
//                }
//                else
//                {
//                    priceStr = [NSString stringWithFormat:@"¥%d x %d份",
//                                (int)round([gInfo.salePrice floatValue]),
//                                [gInfo.purchaseNum intValue]];
//                }
//                
//                NSArray *titles = [NSArray arrayWithObjects:grouponName, priceStr, nil];
//                
//                // 选择支付方式
//                NSArray *payments = [NSArray arrayWithObjects:[NSNumber numberWithInt:UniformPaymentTypeCreditCard], [NSNumber numberWithInt:UniformPaymentTypeDepositCard], [NSNumber numberWithInt:UniformPaymentTypeWeixin], [NSNumber numberWithInt:UniformPaymentTypeAlipay], [NSNumber numberWithInt:UniformPaymentTypeAlipayWap], nil];
//                
//                // 进入统一收银台
//                UniformCounterViewController *control = [[UniformCounterViewController alloc] initWithTitles:titles orderTotal:payMoney cashAccountAvailable:canUseCA paymentTypes:payments UniformFromType:UniformFromTypeGroupon];
//                [self.navigationController pushViewController:control animated:YES];
//                [control release];
            }
                break;
            case NET_TYPE_COMMITORDER:
            {
                NSLog(@"root=%@", root);
                
                UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
                [dataModel.orderInfo addEntriesFromDictionary:root];
                dataModel.orderID = [NSString stringWithFormat:@"%@", [root safeObjectForKey:OrderID_API]];
                dataModel.tradeToken = [root safeObjectForKey:tradeToken_API];
                
                netType = NET_TYPE_CHECK_CASHACCOUNT;
                [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeGroupon] delegate:self];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.invoiceOpen) {
        return 3;
    }
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2)
    {
        if (self.invoiceOpen)
        {
            return 3 + (invoiceAddresses.count?invoiceAddresses.count + 1:0);
        }
        else
        {
            return 1;
        }
    }
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"OrderInfCell";
        GrouponOrderInfoCell *cell = (GrouponOrderInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[GrouponOrderInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell setPrice:realUnitPrice num:purchaseNum];
        [cell setHotelName:gInfo.prodName];
        cell.phoneField.delegate	= self;
        cell.phoneField.text		= self.phoneNum;
        cell.phoneField.placeholder	= @"用于接受团购券信息";
        cell.phoneField.font = [UIFont systemFontOfSize:14.0f];
        cell.phoneField.numberOfCharacter = 11;
        
        return cell;
    }
    else if(indexPath.section==1)
    {
        // 发票
        static NSString *cellIdentifier = @"OrderInvoiceCell";
        GrouponOrderInvoiceCell *cell = (GrouponOrderInvoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[GrouponOrderInvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        //艺龙开发票
        [cell setPaPiaoState:self.invoiceHidden==NO];
        
        return cell;
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row == 0 || indexPath.row == 1|| indexPath.row == 2 || indexPath.row == [self tableView:orderList numberOfRowsInSection:2] - 1) {
            static NSString *cellIdentifier = @"InvoiceCell";
            HotelOrderCell *cell = (HotelOrderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[HotelOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }

            if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] -1)
            {
                cell.cellType = 1;
            }
            else
            {
                cell.cellType = 0;
            }
            
            [cell setArrowHidden:YES];
            cell.textField.hidden = YES;
            [cell setCustomerHidden:YES];
            [cell setTitle:@""];
            [cell setDetail:@""];
            
            if(indexPath.row == 0)
            {
                [cell setTitle:@"抬头"];
                cell.textField.hidden = NO;
                cell.textField.placeholder = @"输入发票抬头";
                cell.textField.delegate = self;
                cell.textField.returnKeyType = UIReturnKeyDone;
                cell.textField.tag = INVOICE_FIELD_TAG;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (self.invoiceTitle) {
                    cell.textField.text = self.invoiceTitle;
                }
            }else if(indexPath.row == 1){
                [cell setTitle:@"选择发票类型"];
                [cell setArrowHidden:NO];
                [cell setDetail:self.invoiceType];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row == [self tableView:orderList numberOfRowsInSection:2] - 1){
                [cell setTitle:@"新增邮寄地址"];
                [cell setArrowHidden:NO];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row ==2){
                [cell setTitle:@"选择邮寄地址"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                [cell setTitle:[NSString stringWithFormat:@"地址%d",indexPath.row - 4]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }else{
            static NSString *cellIdentifier = @"InvoiceAddressCell";
            HotelOrderInvoiceCell *cell = (HotelOrderInvoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[HotelOrderInvoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                cell.backgroundColor = [UIColor whiteColor];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            NSDictionary *addressDict = [invoiceAddresses safeObjectAtIndex:indexPath.row - 3];
            cell.detailLabel.text = [NSString stringWithFormat:@"%@ / %@",[addressDict objectForKey:KEY_NAME],[addressDict objectForKey:KEY_ADDRESS_CONTENT]];
            if (indexPath.row - 3 == self.invoiceIndex) {
                cell.checked = YES;
            }else{
                cell.checked = NO;
            }
            return cell;
        }
    }
    else
    {
        // 支付方式
        static NSString *cellIdentifier = @"OrderPayCell";
        GrouponOrderPayCell *cell = (GrouponOrderPayCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[GrouponOrderPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.clipsToBounds = YES;
        }
        cell.cashaccountHidden = self.cashAccountHidden;
        cell.cashaccountChecked = self.cashAccountOpen;
        cell.alipayHidden = self.alipayHidden;
        if (self.grouponPayType == GrouponAlipay) {
            cell.alipayChecked = YES;
        }else{
            cell.creditCardChecked = YES;
        }
        return cell;
    }
    return nil;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [scrollView endEditing:NO];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
    {
        CGSize size = CGSizeMake(300, 1000);
        CGSize newSize = [gInfo.prodName sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:size lineBreakMode:UILineBreakModeCharacterWrap];
        
        if (newSize.height < 30) {
            newSize.height = 30;
        }
        
        return newSize.height+24+45*4;
    }
    //发票开关
    else if(indexPath.section == 1)
    {
        if(self.invoiceHidden)
        {
            return 0;
        }
        return 45;
//        if (self.alipayHidden && self.cashAccountHidden) {
//            [nextButton setTitle:@"信用卡支付" forState:UIControlStateNormal];
//            return 0;
//        }else if(self.alipayHidden || self.cashAccountHidden){
//            return 120;
//        }else{
//            return 160;
//        }
    }
    //发票填写
    else if(indexPath.section==2)
    {
        return 45;
    }
    else
    {
        return 40;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    return [sectionView autorelease];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        NSInteger rowCount = [self tableView:orderList numberOfRowsInSection:2];
        if (rowCount == 1) {
            return;
        }
        if (indexPath.row == rowCount - 1) {
            
            [currentTextField resignFirstResponder];
            
            // 新增邮寄地址
            [self showAddAddressView];
            
        }
        else if (indexPath.row - 3 >= 0)
        {
            [currentTextField resignFirstResponder];
            
            self.invoiceIndex = indexPath.row - 3;
            NSMutableArray *indexArray = [NSMutableArray array];
            for (int i = 3; i < rowCount; i++) {
                [indexArray addObject:[NSIndexPath indexPathForRow:i inSection:2]];
            }
            [orderList reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
        }
        else if (indexPath.row == 1)
        {
            [currentTextField resignFirstResponder];
            
            if (!invoiceSelect) {
                // 发票类型选择器
                invoiceSelect = [[FilterView alloc] initWithTitle:@"发票类型"
                                                            Datas:[NSArray arrayWithObjects:@"会务费", @"会议费", @"旅游费", @"差旅费", @"服务费", @"住宿费", nil]];
                invoiceSelect.delegate = self;
                [self.view addSubview:invoiceSelect.view];
            }
            
            [invoiceSelect showInView];
        }
    }
}

- (void)showAddAddressView{
    AddAddress *controller = [[AddAddress alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];

    UMENG_EVENT(UEvent_Groupon_FillOrder_AddressBook)
}

#pragma mark -
#pragma mark AddAddressNotification

- (void)getFillInfo:(NSNotification *)noti {
	// 接收新加入的地址信息
	NSDictionary *dDictionary = (NSDictionary *)[noti object];
    
    NSDictionary *addressDict = [NSDictionary dictionaryWithObjectsAndKeys:[dDictionary safeObjectForKey:KEY_NAME],KEY_NAME,[dDictionary safeObjectForKey:KEY_ADDRESS_CONTENT],KEY_ADDRESS_CONTENT, nil];
	
	[invoiceAddresses addObject:addressDict];
    self.invoiceIndex = invoiceAddresses.count - 1;
    [orderList reloadData];
}

#pragma mark -
#pragma mark GrouponOrderInfoCellDelegate
- (void) orderInfoCell:(GrouponOrderInfoCell *)cell grouponNumChanged:(NSInteger)num{
    // 购买数量
	purchaseNum = num;
    salePriceLbl.text = [NSString stringWithFormat:@"总额：¥%.f",realUnitPrice * purchaseNum];
    
    UMENG_EVENT(UEvent_Groupon_FillOrder_Num)
}

- (void) orderInfoCellAddPhone:(GrouponOrderInfoCell *)cell{
	// 从通讯录添加联系人
	CustomAB *picker = [[CustomAB alloc] initWithContactStyle:3]; //kABPersonPhoneProperty;
	picker.delegate = self;
	UINavigationController *naviCtr = [[UINavigationController alloc] initWithRootViewController:picker];
	
    if (IOSVersion_7) {
        naviCtr.transitioningDelegate = [ModalAnimationContainer shared];
        naviCtr.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:naviCtr animated:YES completion:nil];
    }else{
        [self presentModalViewController:naviCtr animated:YES];
    }
    [picker release];
	[naviCtr release];
}

#pragma mark -
#pragma mark GrouponOrderPayCellDelegate
- (void) orderPayCell:(GrouponOrderPayCell *)cell cashAccount:(BOOL)cash{
    self.cashAccountOpen = cash;
    if (self.cashAccountOpen) {
        self.alipayHidden = YES;
        self.grouponPayType = GrouponCreditCard;
    }else{
        // 是否支持支付宝
        ElongClientAppDelegate *appDelegate  = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
        if([ProcessSwitcher shared].allowAlipayForGroupon && !appDelegate.isNonmemberFlow){
            // 会员流程才有支付宝支付
			self.alipayHidden = NO;
		}else{
            self.alipayHidden = YES;
        }
    }
    [orderList reloadData];
}

- (void) orderPayCell:(GrouponOrderPayCell *)cell selectPayType:(GrouponPayType)payType{
    self.grouponPayType = payType;
    if (payType == GrouponCreditCard) {
        [GrouponFillOrder setIsGrouponPayment:NO];
        if (self.invoiceOpen) {
            [nextButton setTitle:@"填写发票" forState:UIControlStateNormal];
        }else{
            if (self.alipayHidden && self.cashAccountHidden) {
                [nextButton setTitle:@"信用卡支付" forState:UIControlStateNormal];
            }else{
                [nextButton setTitle:@"支付" forState:UIControlStateNormal];
            }
        }
    }else{
        [GrouponFillOrder setIsGrouponPayment:YES];
        if (self.invoiceOpen) {
            [nextButton setTitle:@"填写发票" forState:UIControlStateNormal];
        }else{
            [nextButton setTitle:@"提交订单" forState:UIControlStateNormal];
        }
    }
    
    UMENG_EVENT(UEvent_Groupon_FillOrder_Pay)
    
    [orderList reloadData];
}

#pragma mark -
#pragma mark GrouponOrderInvoiceCellDelegate
- (void) orderInvoiceCell:(GrouponOrderInvoiceCell *)cell invoiceChoised:(BOOL)choised{
    self.invoiceOpen = choised;
    if (self.invoiceOpen)
    {
        if (invoiceAddresses==nil)
        {
            //取发票信息
            invoiceAddresses = [[NSMutableArray alloc] initWithCapacity:0];
            
            JGetAddress *jads=[MyElongPostManager getAddress];
            [jads clearBuildData];
            
            if (addressUtil) {
                [addressUtil cancel];
                SFRelease(addressUtil);
            }
            
            addressUtil = [[HttpUtil alloc] init];
            [addressUtil connectWithURLString:MYELONG_SEARCH Content:[jads requesString:YES] StartLoading:NO EndLoading:NO  Delegate:self];
        }
        
        UMENG_EVENT(UEvent_Groupon_FillOrder_NeedInvoice)
    }
    
    [orderList reloadData];
}

#pragma mark -
#pragma mark CustomABDelegate

- (void)getSelectedString:(NSString *)selectedStr {
	self.phoneNum = [selectedStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    GrouponOrderPhoneCell *phoneCell = (GrouponOrderPhoneCell *)[orderList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    phoneCell.phoneField.text = self.phoneNum;
    if (keyboardShowing) {
        // 继续维持编辑状态
        [phoneCell.phoneField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.15];
    }
}

#pragma mark -
#pragma mark FilterView

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView{
    if(filterView == invoiceSelect){
        self.invoiceType = filterStr;
        [orderList reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -
#pragma mark UITextField Delegate

- (void) textFieldDidChange:(NSNotification *)notification{
    if(self.navigationController.topViewController != self){
        return;
    }
    
    UITextField *textField = (UITextField *)notification.object;
    
    if (textField.tag ==INVOICE_FIELD_TAG)
    {
        // 发票抬头
        self.invoiceTitle = textField.text;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
    
    if (SCREEN_4_INCH)
    {
        if (textField.tag==INVOICE_FIELD_TAG)
        {
            [orderList setContentOffset:CGPointMake(0, 150) animated:YES];
        }
        else
        {
            [orderList setContentOffset:CGPointMake(0, 100) animated:YES];
        }
    }
    else
    {
        if (textField.tag==INVOICE_FIELD_TAG)
        {
            [orderList setContentOffset:CGPointMake(0, 170) animated:YES];
        }
        else
        {
            [orderList setContentOffset:CGPointMake(0, 100) animated:YES];
        }
    }

}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
        CustomTextField *phoneField = (CustomTextField *)textField;
        phoneField.numberOfCharacter = 11;
        phoneField.abcEnabled = NO;
        [phoneField showNumKeyboard];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag ==INVOICE_FIELD_TAG)
    {
        // 发票抬头
        NSString *invoiceTitleStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.invoiceTitle = invoiceTitleStr;
    }
    else
    {
//        textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (range.location >= 11) {
            textField.text = [textField.text substringToIndex:11];
            self.phoneNum = textField.text;
            return NO;
        }
        NSString *tagStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.phoneNum = tagStr;
    }
	return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL) textFieldShouldClear:(UITextField *)textField{
    self.phoneNum = @"";
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	keyboardShowing = NO;
	[textField resignFirstResponder];
	
    currentTextField=nil;
    
	return YES;
}

#pragma mark - UniformCounter DateModel delegate
- (void)uniformCounterDataDidRefresh
{
    UniformCounterDataModel *dataModel = [UniformCounterDataModel shared];
    NSArray *titles = [NSArray arrayWithArray:dataModel.titlesArray];
    // 进入统一收银台
    UniformCounterViewController *control = [[UniformCounterViewController alloc] initWithTitles:titles orderTotal:dataModel.orderTotalMoney cashAccountAvailable:dataModel.canUseCA UniformFromType:UniformFromTypeGroupon];
    [self.navigationController pushViewController:control animated:YES];
    [control release];
}

@end
