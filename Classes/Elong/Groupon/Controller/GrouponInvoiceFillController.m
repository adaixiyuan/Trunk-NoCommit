//
//  GrouponInvoiceFillController.m
//  ElongClient
//  发票填写
//
//  Created by haibo on 11-11-25.
//  Copyright 2011 elong. All rights reserved.
//

#import "GrouponInvoiceFillController.h"
#import "GrouponSharedInfo.h"
#import "AccountManager.h"
#import "EmbedTextField.h"
#import "FlightDataDefine.h"
#import "SelectedAddressView.h"
#import "SelectCard.h"
#import "Utils.h"
#import "GrouponFillOrder.h"
#import "GrouponConfirmViewController.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"
#import "PaymentTypeVC.h"
#import "StringFormat.h"

#define NET_TYPE_BANK_LIST      111
#define NET_TYPE_CREDITCARD     113
#define NET_TYPE_CASHACCOUNT    114
#define NET_TYPE_ZHIFUBAO_PAY   115

@implementation GrouponInvoiceFillController

#pragma mark -
#pragma mark Memory management

- (void)dealloc
{
	[addArray		release];
	[invoiceSelect  release];
    [grouponConfirmVC release];
    [hotelconfirmorder release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Initialization

- (id)initWithAddressInfo:(NSDictionary *)addressInfo
{
	if (self = [super initWithTopImagePath:@"" andTitle:@"发票填写" style:_NavNoTelStyle_]) {
		addArray = [[NSMutableArray alloc] initWithCapacity:2];
        noCardRecord = NO;
        _cashAmountAvailable = YES;
        
        if ([addressInfo count] > 0) {
            for (NSDictionary *dict in [addressInfo safeObjectForKey:KEY_ADDRESSES]) {
                NSMutableDictionary *dDictionary = [[NSMutableDictionary alloc] init];
                [dDictionary safeSetObject:[dict safeObjectForKey:KEY_ADDRESS_CONTENT] forKey:KEY_ADDRESS_CONTENT];
                [dDictionary safeSetObject:[dict safeObjectForKey:KEY_NAME] forKey:KEY_NAME];
                [addArray addObject:dDictionary];
                [dDictionary release];
            }
        }
		
		[self performSelector:@selector(addInvoiceFillView)];
		[self performSelector:@selector(addAddressChoseView)];
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (0 != buttonIndex) {
		[super backhome];
	}
}

- (void)addInvoiceFillView
{
	// 添加上方的发票信息填写栏
	UIImageView *backView = [UIImageView roundCornerViewWithFrame:CGRectMake(6, 10, 308, 140)];
	[self.view addSubview:backView];
	
	titleField = [[EmbedTextField alloc] initWithFrame:CGRectMake(14, 9, 280, 40) Title:@"发票抬头：" TitleFont:FONT_16];
    titleField.returnKeyType = UIReturnKeyDone;
	titleField.textFont		= FONT_16;
	titleField.placeholder	= @"请输入";
	titleField.delegate		= self;
	[backView addSubview:titleField];
	[titleField release];
	
	UIImageView *separator = [UIImageView graySeparatorWithFrame:CGRectMake(9, 18 + titleField.frame.origin.y + titleField.frame.size.height, BOTTOM_BUTTON_WIDTH, 1)];
	[backView addSubview:separator];
	
	typeButton = [UIButton arrowButtonWithTitle:@"会务费"
									     Target:self
									     Action:@selector(popChooseView)
										  Frame:CGRectMake(9, 1 + separator.frame.origin.y + separator.frame.size.height, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)
								    Orientation:ArrowOrientationDown];
	typeButton.titleLabel.font = FONT_16;
	typeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
	[backView addSubview:typeButton];
	
	UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 13 + separator.frame.origin.y + separator.frame.size.height, 80, 22)];
	typeLabel.text				= @"发票类型：";
	typeLabel.font				= FONT_16;
	typeLabel.backgroundColor	= [UIColor clearColor];
	typeLabel.textColor			= [UIColor blackColor];
	typeLabel.textAlignment		= UITextAlignmentLeft;
	[backView addSubview:typeLabel];
	[typeLabel release];
	
	[backView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(9,
																		typeButton.frame.origin.y + typeButton.frame.size.height + 1,
																		BOTTOM_BUTTON_WIDTH,
																		1)]];
}

- (void)addAddressChoseView
{
	// 添加下方的地址选择栏
	address = [[SelectedAddressView alloc] initWithFrame:CGRectMake(10, 128, 300, MAINCONTENTHEIGHT - 136) AddressArray:addArray];
	[address setNextButtonTarget:self action:@selector(nextButtonPressed)];
    [address setTextField:[titleField textField]];
	[self.view addSubview:address];
	[address release];
}

#pragma mark -
#pragma mark Private Method

- (void)popChooseView
{
	// 推出发票类型
	[titleField resignFirstResponder];
	
	if (!invoiceSelect) {
		// 发票类型选择器
		invoiceSelect = [[FilterView alloc] initWithTitle:@"发票类型"
													Datas:[NSArray arrayWithObjects:@"会务费", @"会议费", @"旅游费", @"差旅费", @"服务费", @"住宿费", nil]];
		invoiceSelect.delegate = self;
		[self.view addSubview:invoiceSelect.view];
	}
	
	[invoiceSelect showInView];
}

- (void)nextButtonPressed
{
	// 点击下一步的操作
    [self.view endEditing:YES];
    
	if (!STRINGHASVALUE(titleField.text)) {
		[PublicMethods showAlertTitle:@"发票抬头为空" Message:@"请输入"];
		return;
	}
	else if ([StringFormat isContainedSpecialChar:titleField.text]) {
		[PublicMethods showAlertTitle:@"发票抬头包含特殊字符或数字" Message:@"请检查"];
		return;
	}
    
	
	if (0 == [address.addressArray count]) {
		[PublicMethods showAlertTitle:@"请新增邮寄地址" Message:nil];
		return;
	}
	// 保存输入信息
	NSArray *addressArray = [[address getSelectedAddress] componentsSeparatedByString:@"/"];
	NSString *receiverStr = [[addressArray safeObjectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *addrStr	  = [[addressArray safeObjectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                titleField.text, INVOICETITLE_GROUPON,
                                typeButton.titleLabel.text, TYPE_GROUPON,
                                receiverStr, @"Receiver",
                                addrStr, ADDRESS_GROUPON,
                                DEFAULTPOSTCODEVALUE, @"PostCode", nil];
    
    if (_invoiceType == InvoiceTypeGroupon)
    {
        [self saveGrouponInvoice:dic];
    }
    else if (_invoiceType == InvoiceTypeHotel || _invoiceType == InvoiceTypeHotelZhifubao)
    {
        [self saveHotelInvoice:dic];
    }
}

- (void)saveHotelInvoice:(NSMutableDictionary *)dic
{
    [[HotelPostManager hotelorder] setInvoiceDic:dic];
    
    ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (!delegate.isNonmemberFlow)
    {
		// 会员流程
		[dic safeSetObject:[[AccountManager instanse] phoneNo] forKey:@"Phone"];	// 电话从登录信息取
        
        if (_invoiceType == InvoiceTypeHotelZhifubao) {
            hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
            hotelconfirmorder.isZhifubaoPay = YES;
            [hotelconfirmorder nextState];
        }
        else if (_cashAmountAvailable)
        {
            // 发起现金账户验证请求
            netType = NET_TYPE_CASHACCOUNT;
            [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeGroupon] delegate:self];
        }
        else
        {
            // 现金账户不可用，发起获取信用卡请求
            netType = NET_TYPE_CREDITCARD;
            
            [[MyElongPostManager card] clearBuildData];
            [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
        }
        
	}
	else {
        // 非会员流程
		[dic safeSetObject:[[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE] forKey:@"Phone"];		// 电话从前一页取
		
        if (_invoiceType == InvoiceTypeHotelZhifubao) {
            hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
            hotelconfirmorder.isZhifubaoPay = YES;
            [hotelconfirmorder nextState];
        }
        else {
            // 直接请求银行列表，进入新增信用卡界面
            noCardRecord = YES;
            netType = NET_TYPE_BANK_LIST;
            
            JPostHeader *postheader = [[JPostHeader alloc] init];
            [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
            [postheader release];
        }
	}
}

- (void)saveGrouponInvoice:(NSMutableDictionary *)dic
{
    GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
	gInfo.invoiceInfo		 = dic;
	
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (!delegate.isNonmemberFlow) {
		// 会员流程
		[dic safeSetObject:[[AccountManager instanse] phoneNo] forKey:@"Phone"];	// 电话从登录信息取
		
		if([GrouponFillOrder getIsGrouponPayment]){
            // 支付宝支付直接进入确认页面
			grouponConfirmVC = [[GrouponConfirmViewController alloc] initWithCardInfo:nil];
            [grouponConfirmVC nextState];
		}else {
            // 发起现金账户验证请求
            netType = NET_TYPE_CASHACCOUNT;
            [Utils request:GIFTCARD_SEARCH req:[CashAccountReq getCashAmountByBizType:BizTypeGroupon] delegate:self];
		}
	}
	else { // 非会员流程
		// 记录非会员的邮寄地址
		[dic safeSetObject:[[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_PHONE] forKey:@"Phone"];		// 电话从前一页取
		
		if([GrouponFillOrder getIsGrouponPayment]){
            // 支付宝支付直接进入确认页面
			grouponConfirmVC = [[GrouponConfirmViewController alloc] initWithCardInfo:nil];
            [grouponConfirmVC nextState];
		}else {
            // 直接请求银行列表，进入新增信用卡界面
            noCardRecord = YES;
            netType = NET_TYPE_BANK_LIST;
            
            JPostHeader *postheader = [[JPostHeader alloc] init];
            [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
            [postheader release];
        }
	}
}

#pragma mark -
#pragma mark Selected Delegate

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView
{
	[typeButton setTitle:filterStr forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
	if (invoiceSelect.isShowing) {
		[invoiceSelect dismissInView];
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark -
#pragma mark NetWork Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
	NSDictionary *root = [PublicMethods unCompressData:responseData];
    
	if ([Utils checkJsonIsError:root]) {
		return;
	}
    
    switch (netType) {
        case NET_TYPE_CREDITCARD:{
            [[SelectCard allCards] removeAllObjects];
            NSArray *cards = [root safeObjectForKey:@"CreditCards"];
            if ([cards isKindOfClass:[NSArray class]] && [cards count] > 0) {
                // 已有信用卡纪录时进入信用卡选择页面
                [[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
                
                if (_invoiceType == InvoiceTypeGroupon)
                {
                    SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:GROUPON_STATE];
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                    
                    if (UMENG) {
                        //团购酒店信用卡支付页面
                        [MobClick event:Event_GrouponHotelOrder_CreditCard];
                    }
                }
                else if (_invoiceType == InvoiceTypeHotel)
                {
                    SelectCard *controller = [[SelectCard alloc] init:@"信用卡预付" style:_NavNormalBtnStyle_ nextState:HOTEL_STATE];
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
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
            
            if (_invoiceType == InvoiceTypeGroupon)
            {
                AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeGroupon];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                
                if (UMENG) {
                    //团购酒店信用卡支付页面
                    [MobClick event:Event_GrouponHotelOrder_CreditCard];
                }
            }
            else if (_invoiceType == InvoiceTypeHotel)
            {
                [[SelectCard allCards] removeAllObjects];
                
                SelectCard *controller = [[SelectCard alloc] init:@"信用卡预付" style:_NavNormalBtnStyle_ nextState:HOTEL_STATE];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
        }
            break;
        case NET_TYPE_CASHACCOUNT:{
            NSDictionary *root = [PublicMethods unCompressData:responseData];
            
            if ([[root safeObjectForKey:CACHE_ACCOUNT_AVAILABLE] safeBoolValue] &&
                [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue] > 0){
                // 现金账户可用
                CashAccountReq *cashAccount = [CashAccountReq shared];
                cashAccount.needPassword = [[root safeObjectForKey:EXIST_PAYMENT_PASSWORD] safeBoolValue];
                cashAccount.cashAccountRemain = [[root safeObjectForKey:REMAININGAMOUNT] safeDoubleValue];
                
                // 如果现金账户有效，则进入支付方式选择页
                PaymentTypeVC *controller = nil;
                if (_invoiceType == InvoiceTypeGroupon)
                {
                    controller = [[PaymentTypeVC alloc] initWithType:PaymentTypeGroupon];
                }
                else if (_invoiceType == InvoiceTypeHotel)
                {
                    controller = [[PaymentTypeVC alloc] initWithType:PaymentTypeNativeHotel];
                }
                
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            else{
                // 现金账户不可用，发起获取信用卡请求
                netType = NET_TYPE_CREDITCARD;
                
                [[MyElongPostManager card] clearBuildData];
                [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
            }
        }
            break;
        case NET_TYPE_ZHIFUBAO_PAY:
        {
            // 支付宝成单
            hotelconfirmorder = [[ConfirmHotelOrder alloc] init];
            hotelconfirmorder.isZhifubaoPay = YES;
            [hotelconfirmorder nextState];
        }
            break;
        default:
            break;
    }
}


@end
