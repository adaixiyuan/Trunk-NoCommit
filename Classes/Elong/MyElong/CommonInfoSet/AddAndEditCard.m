//
//  AddAndEditCard.m
//  ElongClient
//
//  Created by WangHaibin on 2/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddAndEditCard.h"
#import "ElongClientAppDelegate.h"
#import "Utils.h"
#import "SelectCard.h"
#import "StringFormat.h"
#import "SelectTable.h"
#import "StringEncryption.h"
#import "CardDate.h"
#import "Utils.h"
#import "JAddCard.h"
#import "Card.h"
#import "FlightOrderConfirm.h"
#import "EmbedTextField.h"
#import "GrouponConfirmViewController.h"
#import "UniformCounterDataModel.h"
#import "InterHotelSearcher.h"
#import "CashAccountReq.h"
#import "MyElongCenter.h"
#import "PaymentTypeVC.h"

#define VIEW_HEIGHT_0           0
#define VIEW_HEIGHT_1           (VIEW_HEIGHT_0 -215)
#define VIEW_DURATION           0.2

#define BANK_CHOOSE_TIP         @"请选择银行"
#define DATE_CHOOSE_TIP         @"请选择有效期时间"
#define CARD_FIELD_TAG          1000
#define CVV_FIELD_TAG           1001
#define CARDHOLDER_FIELD_TAG    1002
#define IDNUM_FIELD_TAG         1003


@interface AddAndEditCard()
@property (nonatomic,copy) NSString *bankName;
@property (nonatomic,copy) NSString *cardNum;
@property (nonatomic,copy) NSString *validityDate;
@property (nonatomic,copy) NSString *cvv;
@property (nonatomic,copy) NSString *cardholder;
@property (nonatomic,copy) NSString *idType;
@property (nonatomic,copy) NSString *idNum;
@property (nonatomic,assign) BOOL needCVV;
@property (nonatomic,assign) BOOL needCardType;
@property (nonatomic,assign) BOOL editable;
@end

@implementation AddAndEditCard
@synthesize delegate;
@synthesize cardList;

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    ReceiveMemoryWarning = YES;
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
	SFRelease(selectTableCertificate);
	SFRelease(selectTableBank);
	SFRelease(bankNames);
    SFRelease(bankIds);
}

- (void)dealloc {
	self.delegate = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[modifiedCard release];
	[bankNames release];
	[cardDate release];
	[selectTableCertificate release];
	[selectTableBank release];
    [grouponConfirmVC release];
    [flightOrderConfirmVC  release];
    [jMoidfyCard release];
    
    self.bankName = nil;
    self.cardNum = nil;
    self.validityDate = nil;
    self.cvv = nil;
    self.cardholder = nil;
    self.idType = nil;
    self.idNum = nil;
    [super dealloc];
}


- (void)checkNeedCVVWithBank:(NSString *)bank
{
    // 检测银行是否需要cvv
	if (STRINGHASVALUE(bank)) {
        if (ARRAYHASVALUE(cards)) {
            if (STRINGHASVALUE(dataModel.orderID))
            {
                // 新统一收银台逻辑
                for (NSDictionary *dic in cards)
                {
                    if (DICTIONARYHASVALUE(dic))
                    {
                        NSString *bankName = [dic safeObjectForKey:productNameCN_API];
                        if ([bankName isEqual:bank]) {
                            NSNumber *needCvv = [dic safeObjectForKey:needCVV2_API];
                            if (![needCvv isEqual:[NSNull null]] && [needCvv intValue] == 1) {
                                // 需要填CVV的情况
                                self.needCVV = YES;
                                return;
                            }
                        }
                    }
                }
            }
            else
            {
                for (NSDictionary *dic in cards) {
                    NSString *bankName = [dic safeObjectForKey:@"Name"];
                    if ([bankName isEqual:bank]) {
                        NSNumber *needCvv = [dic safeObjectForKey:@"Cvv"];
                        if (![needCvv isEqual:[NSNull null]] && [needCvv intValue] == 1) {
                            // 需要填CVV的情况
                            self.needCVV = YES;
                            return;
                        }
                    }
                }
            }
        }
		
        self.needCVV = NO;
	}
}


- (void)checkNeedCertificateWithBank:(NSString *)bank
{
    // 检测是否需要证件号码、证件类型
	if (STRINGHASVALUE(bank)) {
        if (ARRAYHASVALUE(cards)) {
            if (STRINGHASVALUE(dataModel.orderID))
            {
                // 新统一收银台逻辑
                if (STRINGHASVALUE(bank))
                {
                    if (ARRAYHASVALUE(cards))
                    {
                        for (NSDictionary *dic in cards)
                        {
                            if (DICTIONARYHASVALUE(dic))
                            {
                                NSString *bankName = [dic safeObjectForKey:productNameCN_API];
                                if ([bankName isEqual:bank])
                                {
                                    NSNumber *needCer = [dic safeObjectForKey:needCertificateNo_API];
                                    if (![needCer isEqual:[NSNull null]] && [needCer intValue] == 1)
                                    {
                                        self.needCardType = YES;
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                if (STRINGHASVALUE(bank)) {
                    if (ARRAYHASVALUE(cards)) {
                        for (NSDictionary *dic in cards) {
                            NSString *bankName = [dic safeObjectForKey:@"Name"];
                            if ([bankName isEqual:bank]) {
                                NSNumber *needCer = [dic safeObjectForKey:@"IdentityCard"];
                                if (![needCer isEqual:[NSNull null]] && [needCer intValue] == 1) {
                                    self.needCardType = YES;
                                    return;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        self.needCardType = NO;
	}
}


- (id)initFromType:(CardTypeBy)type tipOverDue:(BOOL)animated {
	isAlertForDate = animated;
	
    switch (type) {
        case CardTypeByMyElongAdding: {
            self = [super initWithTopImagePath:nil andTitle:@"新增信用卡" style:_NavOnlyBackBtnStyle_];
            [self isAddorEdit:YES];
            isFromMyElong = YES;
            self.needCardType = YES;
        }
            break;
        case CardTypeByMyElongEditting: {
            self = [super initWithTopImagePath:nil andTitle:@"编辑常用信用卡" style:_NavOnlyBackBtnStyle_];
            [self isAddorEdit:NO];
            isFromMyElong = YES;
        }
            break;
        case CardTypeByOther: {
            ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
            NSString *title = appDelegate.isNonmemberFlow ? @"填写信用卡信息" : @"新增信用卡";
            self = [super initWithTopImagePath:nil andTitle:title style:_NavOnlyBackBtnStyle_];
            [self isAddorEdit:YES];
            isFromMyElong = NO;
            
            self.needCardType = YES;
        }
            
            break;
            
        default:
            break;
    }
    
    orderType = OrderTypeNone;
    
    [self checkNeedCVVWithBank:self.bankName];     //CVV不一定全部显示
    [self checkNeedCertificateWithBank:self.bankName];
	
    return  self;
}

- (id)initWithCard:(NSDictionary *)dic tipOverDue:(BOOL)animated {
	if (self = [super initWithTopImagePath:nil andTitle:@"编辑常用信用卡" style:_NavOnlyBackBtnStyle_]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDown:) name:NOTI_CUSTOMKEYBOARD_DONE object:nil];
        
		modifiedCard = [[NSDictionary alloc] initWithDictionary:dic];
		isAlertForDate = animated;
        orderType = OrderTypeNone;
        self.editable = YES;
		
		self.bankName = [[dic safeObjectForKey:@"CreditCardType"] safeObjectForKey:@"Name"];
		[selectTableBank selectByString:self.bankName];
        self.needCardType = YES;
        
        [self checkNeedCVVWithBank:self.bankName];     //CVV不一定全部显示
        [self checkNeedCertificateWithBank:self.bankName];
        
        self.cardNum = [StringEncryption DecryptString:[dic safeObjectForKey:@"CreditCardNumber"]];
        self.idType = [Utils getCertificateName:[[dic safeObjectForKey:@"CertificateType"] intValue]];
		[selectTableCertificate selectByString:self.idType];
        
        self.cardholder = [dic safeObjectForKey:@"HolderName"];
        self.idNum = [StringEncryption DecryptString: [dic safeObjectForKey:@"CertificateNumber"]];
		NSString *year = [dic safeObjectForKey:@"ExpireYear"];
		NSString *month = [dic safeObjectForKey:@"ExpireMonth"];
		
		
		if ([month intValue] < 10) {
			month = [NSString stringWithFormat:@"0%@",month];
		}
		
        self.validityDate = [NSString stringWithFormat:@"%@年%@月",year,month];
		//有效期时间弹出框
		cardDate=[[CardDate alloc] initWithDate:self.validityDate];
        cardDate.delegate = self;
		cardDate.view.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 220);
		[self.view addSubview:cardDate.view];
	}
	
	return self;
}


- (id)initWithNewCardFromOrderType:(OrderType)type {
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *title = appDelegate.isNonmemberFlow ? @"填写信用卡信息" : @"新增常用信用卡";
    orderType = type;
    if (self = [super initWithTopImagePath:nil andTitle:title style:_NavOnlyBackBtnStyle_]) {
        
        [self isAddorEdit:YES];
        isFromMyElong = NO;
        self.needCardType = YES;
        [self checkNeedCVVWithBank:self.bankName];     //CVV不一定显示
        [self checkNeedCertificateWithBank:self.bankName];
    }
    
    return self;
}


-(void)isAddorEdit:(BOOL)boool{
    self.editable  = boool;
#if CARD_EDIT_DELETE
	if (self.editable) {
		self.bankName = BANK_CHOOSE_TIP;
        self.cardNum = @"";
        self.idType = @"身份证";
        self.cardholder = @"";
        self.idNum = @"";
		
		//有效期时间弹出框
		cardDate=[[CardDate alloc] initWithDate:self.validityDate];
        cardDate.delegate = self;
		cardDate.view.frame=CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 220);
		[self.view addSubview:cardDate.view];
	}else {
		self.bankName = [[[[MyElongCenter allCardsInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"CreditCardType"] safeObjectForKey:@"Name"];
		[selectTableBank selectByString:self.bankName];
        [self checkNeedCertificateWithBank:self.bankName];
        
        
		self.cardNum = [StringEncryption DecryptString:[[[MyElongCenter allCardsInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"CreditCardNumber"]];
		self.idType = [Utils getCertificateName:[[[[MyElongCenter allCardsInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"CertificateType"] intValue]];
		[selectTableCertificate selectByString:self.idType];
		self.cardholder = [[[MyElongCenter allCardsInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"HolderName"];
		self.idNum = [StringEncryption DecryptString: [[[MyElongCenter allCardsInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"CertificateNumber"]];
		NSString *year = [[[MyElongCenter allCardsInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"ExpireYear"];
		NSString *month = [[[MyElongCenter allCardsInfo] safeObjectAtIndex:[MyElongCenter getcustomerIndex]] safeObjectForKey:@"ExpireMonth"];
		
		
		if ([month intValue] < 10) {
			month = [NSString stringWithFormat:@"0%@",month];
		}
		self.validityDate = [NSString stringWithFormat:@"%@年%@月",year,month];
		//有效期时间弹出框
		cardDate=[[CardDate alloc] initWithDate:self.validityDate];
		cardDate.view.frame=CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 220);
        cardDate.delegate = self;
		[self.view addSubview:cardDate.view];
	}
#endif
}


#pragma mark -
#pragma mark IBAction


#pragma mark -
#pragma mark Private

#if	CARD_EDIT_DELETE
-(BOOL)checkCreditCardIsExist:(NSString *)string{
	if (modifiedCard) {
		return NO;
	}
	
    if (isFromMyElong) {
        if(self.editable){
            for (NSDictionary *card in [MyElongCenter allCardsInfo]) {
                if ([string isEqualToString:[StringEncryption DecryptString:[card safeObjectForKey:@"CreditCardNumber"]]]) {
                    return YES;
                }
            }
            
        }else {
            int i = 0;
            for (NSDictionary *card in [MyElongCenter allCardsInfo]) {
                if (i == [MyElongCenter getcustomerIndex]) {
                    i++;
                    continue;
                }else if ([string isEqualToString:[StringEncryption DecryptString:[card safeObjectForKey:@"CreditCardNumber"]]]) {
                    return YES;
                }
                i++;
            }
        }
    }
    else {
        for (NSDictionary *card in [SelectCard allCards]) {
            if ([string isEqualToString:[StringEncryption DecryptString:[card safeObjectForKey:@"CreditCardNumber"]]]) {
                return YES;
            }
        }
    }
	
	return NO;
}

#else

-(BOOL)checkCreditCardIsExist:(NSString *)string{
	for (NSDictionary *card in [MyElong allCardsInfo]) {
		if ([string isEqualToString:[StringEncryption DecryptString:[card safeObjectForKey:@"CreditCardNumber"]]]) {
			return YES;
		}
	}
	return NO;
}
#endif

-(NSString *)getCreditCardType:(NSString *)string{
	
	NSArray *allcardTypes=[SelectCard cardTypes];
	
	NSMutableDictionary *allCardDictonary=[[NSMutableDictionary alloc] init];
	for (NSDictionary *dict in allcardTypes) {
		[allCardDictonary safeSetObject:[dict safeObjectForKey:@"Id"] forKey:[dict safeObjectForKey:@"Name"]];
	}
	
	NSString *cardType = [NSString stringWithFormat:@"%@",[allCardDictonary safeObjectForKey:string]];
	[allCardDictonary release];
	
	return cardType;
}


-(NSDate *)lastOfMonth:(NSDate *)today
{
	NSCalendar *calendar=[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	
	NSDateComponents *components=[calendar components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:today];
    
	NSInteger month=[components month];
    [components setMonth:month+1];
	
	return [[calendar dateFromComponents:components] dateByAddingTimeInterval:-1/*24*60*60*/];
}

-(NSString *)getExpireTime:(NSString *)string{
	
	NSDate *currentDate = [TimeUtils NSStringToNSDate:string formatter:@"yyyy年MM月"];
	
	NSDate *lastDate=[self lastOfMonth:currentDate];
	
	NSString *elongDateFormat=[NSString stringWithFormat:@"/Date(%.f)/",[lastDate timeIntervalSince1970]*1000];
	
	return elongDateFormat;
}

- (NSString *)validateUserInputData
{
	if ([self.bankName isEqualToString:BANK_CHOOSE_TIP]) {
		return @"请选择银行";
	}
    if ([self.cardNum length] == 0) {
		return @"请填写信用卡卡号";
	}
    //	if ([dateLabel.textColor isEqual:[UIColor redColor]]) {
    //		return @"请更改信用卡有效期";
    //	}
	if ([self.validityDate isEqualToString:DATE_CHOOSE_TIP]) {
		return @"请选择信用卡有效期";
	}
    if ([self.cardholder length] == 0) {
		return @"请填写持卡人名字";
	}
    if (self.needCardType) {
        if ([self.idNum length] == 0) {
            return @"请填写证件号码";
        }
        
		if (![StringFormat isOnlyEnWordAndNum:self.idNum]
            || [StringFormat isContainedIllegalChar:self.idNum]){
            return @"证件号码中包含特殊字符或非法字符";
        }
	}
    if (self.needCVV) {
		if ([self.cvv length] == 0) {
			return @"请填写信用卡三位验证码";
		}
		
		if (([self.cvv length] == 1 || [self.cvv length] == 2 || [self.cvv length] > 3) || ([self.cvv length] == 3 && ![StringFormat isOnlyContainedNumber:self.cvv])) {
			return @"请正确填写信用卡三位验证码";
		}
	}
    if (![StringFormat isOnlyEnWordAndNum:self.cardNum]
        || [StringFormat isContainedIllegalChar:self.cardNum]) {
		return @"信用卡号码中包含特殊字符或非法字符";
	}
    
	if ([StringFormat isContainedNumber:self.cardholder] ||
        [StringFormat isContainedIllegalChar:self.cardholder]){
		return @"请输入正确的持卡人姓名";
	}
    if ([self checkCreditCardIsExist:self.cardNum]){
		return @"信用卡列表中已包含该信用卡";
		
	}
    if ([self.cardNum length] < 16){
		return @"信用卡卡号不完整";
	}
	
	return nil;
}


-(NSNumber *)getExpireTime:(NSString *)string format:(NSString *)format{
	
	
	NSDate *currentDate = [TimeUtils NSStringToNSDate:string formatter:@"yyyy年MM月"];
	
	NSString *datestring = [TimeUtils displayDateWithNSDate:currentDate formatter:format];
	
	return [NSNumber numberWithInt:[datestring intValue]];
}


- (void)requestForModify {
	[jMoidfyCard clearBuildData];
	[jMoidfyCard setCreditCardTypeName:self.bankName];
	[jMoidfyCard setCreditCardTypeID:[self getCreditCardType:self.bankName]];
	[jMoidfyCard setCreditCardNumber:[StringEncryption EncryptString:self.cardNum]];
	
	NSDate *expireDate = [TimeUtils displayNSStringToGMT8CNNSDate:self.validityDate];
	
	NSString *yearstring = [TimeUtils displayDateWithNSDate:expireDate formatter:@"yyyy"];
	NSString *monthstring = [TimeUtils displayDateWithNSDate:expireDate formatter:@"MM"];
	[jMoidfyCard setExpireMonth:[monthstring intValue]];
	[jMoidfyCard setExpireYear:[yearstring intValue]];
    
    NSNumber *certificateType = [NSNumber numberWithInt:0];
    NSString *certificateNumber = @"";
    if (self.needCardType) {
        certificateType=[Utils getCertificateType:self.idType];
        certificateNumber=[StringEncryption EncryptString:self.idNum];
    }
    [jMoidfyCard setCertificateType:certificateType];
    [jMoidfyCard setCertificateNumber:certificateNumber];
	
	[jMoidfyCard setHolderName:self.cardholder];
	if (self.needCVV) {
		[jMoidfyCard setVerifyCode:self.cvv];
	}
	
	[Utils request:MYELONG_SEARCH req:[jMoidfyCard requesString:NO] delegate:self];
}


- (void)checkModify {
	[self requestForModify];
}


- (void)checkNewCardForBooking {
	JPostHeader *postheader = [[JPostHeader alloc] init];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	NSString *cardNum = [self.cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *secretNum = [StringEncryption EncryptString:cardNum];
	[dict safeSetObject:secretNum forKey:@"CreditCardNo"];
	if (self.needCVV) {
		[dict safeSetObject:self.cvv forKey:@"VerifyCode"];
	}
    
	if ([delegate checkCardNumberExist:secretNum]) {
        // 已存在相同信用卡的情况
        [PublicMethods showAlertTitle:@"已存在相同的信用卡" Message:@"请检查信用卡卡号"];
        [dict release];
        [postheader release];
        return;
    }
    
	[Utils request:MYELONG_SEARCH req:[postheader requesString:NO action:@"VerifyCreditCard" params:dict] delegate:self];
	[dict release];
	[postheader release];
}


- (void)clickConfirmButton {
	[self textDown:nil];
    
    if (selectTableCertificate.view.frame.origin.y<SCREEN_HEIGHT) {
		[selectTableCertificate dismissInView];
	}
    if (cardDate.view.frame.origin.y<SCREEN_HEIGHT - 50) {
		[cardDate dpViewLeftBtnPressed];
	}
    
	[self.view endEditing:YES];
	
    NSString *msg = [self validateUserInputData];
    if (msg) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:_string(@"s_ok") otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return ;
    }
	
    if (OrderTypeNone != orderType) {
        // 没有信用卡纪录时直接请求验证信用卡
        JPostHeader *postheader = [[JPostHeader alloc] init];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSString *cardNum = [self.cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *creditCardNumber = [StringEncryption EncryptString:cardNum];
        [dict safeSetObject:creditCardNumber forKey:@"CreditCardNo"];
        if (self.needCVV) {
            [dict safeSetObject:self.cvv forKey:@"VerifyCode"];
        }
        
        [Utils request:MYELONG_SEARCH req:[postheader requesString:NO action:@"VerifyCreditCard" params:dict] delegate:self];
        [dict release];
        [postheader release];
        
        return;
    }
    
    
	if (modifiedCard) {
		// 非我的艺龙流程修改信用卡
		[self checkModify];
		return;
	}
    
	if (isFromMyElong) {
        if(self.editable){
            JAddCard *jAddCard=[MyElongPostManager addCard];
            [jAddCard clearBuildData];
            
            [jAddCard setCreditCardTypeName:self.bankName];
            [jAddCard setCreditCardTypeID:[self getCreditCardType:self.bankName]];
			NSString *cardNum = [self.cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
            [jAddCard setCreditCardNumber:[StringEncryption EncryptString:cardNum]];
            
            NSDate *expireDate = [TimeUtils displayNSStringToGMT8CNNSDate:self.validityDate];
            
            NSString *yearstring = [TimeUtils displayDateWithNSDate:expireDate formatter:@"yyyy"];
            NSString *monthstring = [TimeUtils displayDateWithNSDate:expireDate formatter:@"MM"];
            
            [jAddCard setExpireMonth:[monthstring intValue]];
            [jAddCard setExpireYear:[yearstring intValue]];
            
            NSNumber *certificateType = [NSNumber numberWithInt:0];
            NSString *certificateNumber = @"";
            if (self.needCardType) {
                certificateType=[Utils getCertificateType:self.idType];
                certificateNumber=[StringEncryption EncryptString:self.idNum];
            }
            [jAddCard setCertificateType:certificateType];
            [jAddCard setCertificateNumber:certificateNumber];
            [jAddCard setHolderName:self.cardholder];
			if (self.needCVV) {
				[jAddCard setVerifyCode:self.cvv];
			}
            
            [Utils request:MYELONG_SEARCH req:[jAddCard requesString:NO] delegate:self];
        }else {
            [self requestForModify];
        }
    }
	else {
		[self checkNewCardForBooking];
	}
}


- (NSDictionary *)getCardInfo {
    NSString *creditCardName = self.bankName;
	NSString *creditCardId=[self getCreditCardType:creditCardName];
    NSString *verifyCode = self.cvv;
    
	/*信用卡构造区分新老流程（统一收银台和非统一收银台）*/
    NSMutableDictionary *creditCardType = [NSMutableDictionary dictionaryWithCapacity:2];
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (orderType == OrderTypeGroupon &&
        !appDelegate.isNonmemberFlow)
    {
        // 走新流程的信用卡构造
        for (NSDictionary *creditCard in cards)
        {
            if ([[creditCard objectForKey:productNameCN_API] isEqualToString:creditCardName])
            {
                [creditCardType safeSetObject:[creditCard safeObjectForKey:categoryId_API] forKey:@"Id"];
                [creditCardType safeSetObject:creditCardName forKey:@"Name"];
                [creditCardType safeSetObject:[creditCard safeObjectForKey:needCVV2_API] forKey:@"Cvv"];
                [creditCardType safeSetObject:[creditCard safeObjectForKey:needCertificateNo_API] forKey:@"IdentityCard"];
            }
        }
        
        if (!verifyCode)
        {
            verifyCode = @"";
        }
    }
    else
    {
        // 走老流程的信用卡构造
        [creditCardType safeSetObject:creditCardId forKey:@"Id"];
        [creditCardType safeSetObject:creditCardName forKey:@"Name"];
        
        if (!self.needCVV) {
            verifyCode = @"";
            [creditCardType safeSetObject:[NSNumber numberWithBool:0] forKey:@"Cvv"];
        }
        else {
            [creditCardType safeSetObject:[NSNumber numberWithBool:1] forKey:@"Cvv"];
        }
    }
    
    NSString *cardNum = [self.cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *creditCardNumber = [StringEncryption EncryptString:cardNum];
    
    NSNumber *certificateType = [NSNumber numberWithInt:0];
    NSString *certificateNumber = @"";
    if (self.needCardType) {
        certificateType=[Utils getCertificateType:self.idType];
        certificateNumber=[StringEncryption EncryptString:self.idNum];
    }
	
	NSNumber *expireYear=[self getExpireTime:self.validityDate format:@"yyyy"];
	NSNumber *expireMonth=[self getExpireTime:self.validityDate format:@"MM"];
	
	/*身份证明*/
	NSString *holderName=self.cardholder;
	
    
    NSDictionary *card=[[NSDictionary alloc] initWithObjectsAndKeys:
                        //信用卡
                        creditCardType,CREDITCARD_TYPE,
                        creditCardNumber,@"CreditCardNumber",
                        verifyCode,@"VerifyCode",
                        expireYear,@"ExpireYear",
                        expireMonth,@"ExpireMonth",
                        //身份证明
                        holderName,HOLDER_NAME,
                        certificateType,@"CertificateType",
                        certificateNumber,@"CertificateNumber",
                        [NSNumber numberWithBool:NO], IS_VOER_DUE,
                        nil];
    
    return [card autorelease];
}


- (void)saveNewCardForBooking {
	// 预订流程存储信用卡
    for (int i = self.navigationController.viewControllers.count - 1; i >= 0; i--) {
        UIViewController *oneObject = (UIViewController *)[self.navigationController.viewControllers objectAtIndex:i];
        if ([oneObject isKindOfClass:[SelectCard class]]) {
			SelectCard *controller = (SelectCard *)oneObject;
			[[SelectCard allCards] addObject:[self getCardInfo]];
			
			[controller updateData];
			if (!ReceiveMemoryWarning) {
				NSIndexPath *path = [NSIndexPath indexPathForRow:([[SelectCard allCards] count] -1) inSection:0];
				[controller tableView:controller.tabView didSelectRowAtIndexPath:path];
			}
			
			//[controller.tabView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
			
			break;
		}
        
        if ([oneObject isKindOfClass:[PaymentTypeVC class]]) {
			PaymentTypeVC *controller = (PaymentTypeVC *)oneObject;
			[[SelectCard allCards] addObject:[self getCardInfo]];
			
            controller.selectedCard = YES;
			[controller refreshTable];
			if (!ReceiveMemoryWarning) {
				NSIndexPath *path = [NSIndexPath indexPathForRow:([[SelectCard allCards] count] -1) inSection:0];
				[controller tableView:controller.creditCardTable didSelectRowAtIndexPath:path];
			}
			
			break;
		}
    }
    
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)setConfirmButtonHidden:(BOOL)hidden
{
    searchBtn.hidden = hidden;
}

#pragma mark ------
#pragma mark iHttp

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData {
	NSString *string = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	NSDictionary *root = [string JSONValue];
	
	if ([Utils checkJsonIsError:root]) {
		return ;
	}
	
	if (isFromMyElong) {
		// 我的艺龙流程添加或修改信用卡
		if(self.editable){
			JAddCard *jAddCard=[MyElongPostManager addCard];
			NSMutableDictionary * card = [[jAddCard getCard] safeObjectForKey:@"CreditCard"];
            if([MyElongCenter allCardsInfo]!=nil){
                [[MyElongCenter allCardsInfo] insertObject:card atIndex:0];
            }
            //			[[MyElongCenter allCardsInfo] addObject:card];
			
			ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
			for (UIViewController *controller in appDelegate.navigationController.viewControllers) {
				if ([controller isKindOfClass:[Card class]]) {
					Card *card = (Card *)controller;
					[card refreshNavRightBtnStatus];
					[card.cardsTableView reloadData];
					[appDelegate.navigationController popToViewController:controller animated:YES];
					
					return ;
				}
			}
		}else {
            //			JModifyCard *jModifyCard=[MyElongPostManager modifyCard];
			NSMutableDictionary * card = [[jMoidfyCard getCard] safeObjectForKey:@"CreditCard"];
			[[MyElongCenter allCardsInfo] replaceObjectAtIndex:[MyElongCenter getcustomerIndex] withObject:[NSDictionary dictionaryWithDictionary:card]];
			
			ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[[UIApplication sharedApplication] delegate];
			for (UIViewController *controller in appDelegate.navigationController.viewControllers) {
				if ([controller isKindOfClass:[Card class]]) {
					Card *card = (Card *)controller;
					[card refreshNavRightBtnStatus];
					[card.cardsTableView reloadData];
					[appDelegate.navigationController popToViewController:controller animated:YES];
					
					return ;
				}
			}
		}
	}
	else {
        // 预订流程
        if (OrderTypeNone != orderType &&
            OrderTypeCashAmount != orderType) {
            // 第一次新增信用卡的情况
            BOOL isValid = [[root safeObjectForKey:@"IsValid"] boolValue];
            BOOL isInBlackList = [[root safeObjectForKey:@"IsInBlackList"] boolValue];
            BOOL HasVerifyCode = [[root safeObjectForKey:@"HasVerifyCode"] boolValue];
            
            if (!isValid || isInBlackList) {
                [Utils alert:@"您的信用卡不能使用"];
                return;
            }
            
            if (HasVerifyCode && !self.needCVV) {
                [Utils alert:@"该信用卡需要三位验证码，请输入"];
                self.needCVV = YES;
                [cardList reloadData];
                return;
            }
            
            // 取得信用卡信息
            NSMutableDictionary *card = [NSMutableDictionary dictionaryWithDictionary:[self getCardInfo]];
            
            switch (orderType) {
                case OrderTypeHotel: {
                    // 酒店目前不存在直接进入新增信用卡的情况
                    [delegate addNewCardFinished:card];
                }
                    break;
                case OrderTypeFlight: {
                    flightOrderConfirmVC = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:card];
                    [flightOrderConfirmVC nextState:UniformPaymentTypeCreditCard];
                }
                    break;
                case OrderTypeGroupon: {
                    grouponConfirmVC = [[GrouponConfirmViewController alloc] initWithCardInfo:card];
                    [grouponConfirmVC nextState];
                }
                    break;
                    
                case OrderTypeRentCar:{
                    rentCarConfirmVC = [[RentComfirmController alloc] init];
                    [rentCarConfirmVC  setCardMessage:card];
                    [rentCarConfirmVC  requestUrl];
                }
                    break;
                default:
                    break;
            }
        }
        else {
            // 已有信用卡纪录时增加或修改信用卡
            if (modifiedCard) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                            [[jMoidfyCard getCard] safeObjectForKey:CREDITCARD]];	// 获取修改过的信用卡信息
                [dic safeSetObject:[NSNumber numberWithBool:NO] forKey:IS_VOER_DUE];
                [delegate getModifiedCard:dic];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                BOOL isValid=[[root safeObjectForKey:@"IsValid"] boolValue];
                BOOL isInBlackList=[[root safeObjectForKey:@"IsInBlackList"] boolValue];
                BOOL HasVerifyCode = [[root safeObjectForKey:@"HasVerifyCode"] boolValue];
                
                if (!isValid||isInBlackList) {
                    [Utils alert:@"该信用卡不能使用，请检查信用卡信息或更换其它信用卡"];
                    return ;
                }
                
                if (HasVerifyCode && !self.needCVV)
                {
                    [Utils alert:@"该信用卡需要三位验证码，请输入"];
                    self.needCVV = YES;
                    [cardList reloadData];
                    return;
                }
                
                [self saveNewCardForBooking];
            }
        }
	}
}


#pragma mark -
#pragma mark Filter Delegate

- (void)getFilterString:(NSString *)filterStr inFilterView:(FilterView *)filterView {
	if (filterView == selectTableBank) {
        self.bankName = filterStr;
		
        [self checkNeedCVVWithBank:filterStr];     //CVV不一定全部显示
        [self checkNeedCertificateWithBank:filterStr];
        
	}
	else {
        EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
		if ([filterStr isEqualToString:@"身份证"]) {
			[cell.detailField changeKeyboardStateToSysterm:NO];
			cell.detailField.numberOfCharacter = 18;
		}
		else {
			[cell.detailField changeKeyboardStateToSysterm:YES];
			cell.detailField.numberOfCharacter = 60;
		}
		self.idType = filterStr;
	}
    
    [cardList reloadData];
}


#pragma mark -
#pragma mark UITextField Delegate


- (void)textDown:(id)sender {
	
	[sender resignFirstResponder];
}


- (void) textFieldDidBeginEditing:(UITextField *)textField{
    if (cardDate.view.frame.origin.y<SCREEN_HEIGHT - 50) {
		[cardDate dpViewLeftBtnPressed];
	}
	else if (selectTableCertificate.view.frame.origin.y<SCREEN_HEIGHT) {
		[selectTableCertificate dismissInView];
	}
	
    if (self.cardList.scrollEnabled)
    {
        if (textField.tag == CARD_FIELD_TAG) {
            [cardList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else if(textField.tag == CVV_FIELD_TAG){
            [cardList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else if(textField.tag == CARDHOLDER_FIELD_TAG){
            [cardList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else if(textField.tag == IDNUM_FIELD_TAG){
            [cardList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    else
    {
        NSInteger index = 0;
        
        if (textField.tag == CARD_FIELD_TAG) {
            index = 1;
        }else if(textField.tag == CVV_FIELD_TAG){
            index = 3;
        }else if(textField.tag == CARDHOLDER_FIELD_TAG){
            index = 4;
        }else if(textField.tag == IDNUM_FIELD_TAG){
            index = 6;
        }
        
        [delegate textFieldBeginEditingAtIndex:index];
    }
}

- (BOOL) textFieldShouldClear:(UITextField *)textField{
    if (textField.tag == CARD_FIELD_TAG) {
        self.cardNum = @"";
    }else if(textField.tag == CVV_FIELD_TAG){
        self.cvv = @"";
    }else if(textField.tag == CARDHOLDER_FIELD_TAG){
        self.cardholder = @"";
    }else if(textField.tag == IDNUM_FIELD_TAG){
        self.idNum = @"";
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [delegate textFieldEndEditing];
	/*
     if (textField.tag == CARD_FIELD_TAG) {
     EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
     // 卡号数位校验
     if (cell.detailField.text.length > 0) {
     if (cell.detailField.text.length < 16) {
     [cell.detailField alertMessage:@"卡号不完整"];
     }
     }
     
     }
     else if (textField.tag == CVV_FIELD_TAG) {
     EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
     // 验证码数位校验
     if (cell.detailField.text.length > 0) {
     if (cell.detailField.text.length != 3) {
     [cell.detailField alertMessage:@"验证码有误"
     InRect:CGRectMake(cell.detailField.bounds.origin.x, cell.detailField.bounds.origin.y + 23, cell.detailField.bounds.size.width + 40, 30)
     arrowStartPoint:CGPointMake(cell.detailField.bounds.size.width / 2, cell.detailField.center.y)];
     }
     }
     
     }
     */
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
    }
    
    if (textField.tag == CARD_FIELD_TAG) {
        EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell.detailField changeKeyboardStateToSysterm:NO];
        cell.detailField.abcEnabled = NO;
        [cell.detailField showNumKeyboard];
    }else if(textField.tag == CVV_FIELD_TAG){
        EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        [cell.detailField changeKeyboardStateToSysterm:NO];
        cell.detailField.numberOfCharacter = 3;
        cell.detailField.abcEnabled = NO;
        [cell.detailField showNumKeyboard];
    }else if(textField.tag == IDNUM_FIELD_TAG){
        EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        [cell.detailField changeKeyboardStateToSysterm:NO];
        [cell.detailField showNumKeyboard];
        cell.detailField.numberOfCharacter = 18;			// 默认身份证号的长度
        cell.detailField.abcEnabled = YES;
    }else if(textField.tag == CARDHOLDER_FIELD_TAG){
        EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [cell.detailField changeKeyboardStateToSysterm:YES];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self textDown:textField];
	return YES;
}

- (void)checkCardNoText:(NSString *)cardNO {
    EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	if (cardNO.length >= 16) {
		if ([StringFormat isOnlyEnWordAndNum:cardNO] &&
			![StringFormat isContainedIllegalChar:cardNO]) {
			[cell.detailField removeAlert];
		}
	}
	else if (cardNO.length > 0 && cardNO.length < 19) {
		if (![StringFormat isOnlyEnWordAndNum:cardNO] ||
			[StringFormat isContainedIllegalChar:cardNO]) {
			[cell.detailField alertMessage:@"包含特殊或非法字符"];
		}
		else {
			[cell.detailField removeAlert];
		}
	}
	else {
		[cell.detailField removeAlert];
	}
}


- (void)checkCodeText:(NSString *)codeText {
    EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	if (codeText.length > 0 && codeText.length < 4) {
		if (![StringFormat isOnlyContainedNumber:codeText]) {
			[cell.detailField alertMessage:@"验证码有误"
                                    InRect:CGRectMake(cell.detailField.bounds.origin.x, cell.detailField.bounds.origin.y + 21, cell.detailField.bounds.size.width + 40, 30)
                           arrowStartPoint:CGPointMake(cell.detailField.bounds.size.width / 2, cell.detailField.center.y)];
		}
		else {
			[cell.detailField removeAlert];
		}
	}
	else {
		[cell.detailField removeAlert];
	}
}


- (void)checkNameText:(NSString *)nameText {
    EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
	if (nameText.length > 1) {
		if ([StringFormat isNameFormat:nameText] &&
			![StringFormat isContainedIllegalChar:nameText]) {
			[cell.detailField removeAlert];
		}
		else {
			if (![StringFormat isNameFormat:nameText] ||
				[StringFormat isContainedIllegalChar:nameText]) {
				[cell.detailField alertMessage: @"持卡人姓名有误"];
			}
		}
	}
	else {
		[cell.detailField removeAlert];
	}
}


- (void)checkNumberText:(NSString *)numberText {
    EditCardCell *cell = (EditCardCell *)[cardList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
	if (numberText.length > 0) {
		if ([StringFormat isOnlyEnWordAndNum:numberText] &&
			![StringFormat isContainedIllegalChar:numberText]) {
			[cell.detailField removeAlert];
		}
		else {
			[cell.detailField alertMessage:@"包含特殊或非法字符"];
		}
	}
	else {
		[cell.detailField removeAlert];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *fieldString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	if (textField.tag == CARDHOLDER_FIELD_TAG) {
		// 持卡人校验
		//[self checkNameText:fieldString];
        if([string isEqualToString:@""]){   //删除文字
            return YES;
        }
        if(textField.text.length>=30){
            //持卡人长度不能超过30
            return NO;
        }
        self.cardholder = fieldString;
	}
    else if (textField.tag == IDNUM_FIELD_TAG) {
		// 证件号码校验
		//[self checkNumberText:fieldString];
		if ([self.idType isEqualToString:@"身份证"]) {
			if (range.location >= 18 && ![string isEqualToString:@"\n"]) {
				textField.text = [textField.text substringToIndex:18];
                self.idNum = textField.text;
				return NO;
			}
		}
        self.idNum = fieldString;
	}
    else if (textField.tag == CVV_FIELD_TAG) {
        // 验证码校验
        //[self checkCodeText:fieldString];
        if (range.location >= 3) {
            self.cvv = [textField.text substringToIndex:3];
            return NO;
        }
        self.cvv = fieldString;
    }
    else if (textField.tag == CARD_FIELD_TAG) {
		if (range.length != 0) {
			if (fieldString && fieldString.length > 1) {
				NSString *endChar = [fieldString substringFromIndex:fieldString.length - 1];
				if ([endChar isEqualToString:@" "]) {
					textField.text = [fieldString substringToIndex:fieldString.length - 1];
                    self.cardNum = textField.text;
					return NO;
				}
			}
		}
		
		// 卡号校验
		if (range.length == 0 && string && string.length > 0) {
			if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
				// 过滤空字符串
				return NO;
			}
		}
		
		//[self checkCardNoText:fieldString];
        
		if (range.location >= 19 && ![string isEqualToString:@"\n"]) {
			textField.text = [textField.text substringToIndex:19];
            self.cardNum = textField.text;
			return NO;
		}
		else {
			if (range.length == 0) {
				if (range.location < 18 && range.location > 0) {
					// 卡号逢4位自动加一个空格
					textField.text = [[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]
                                      stringByInsertingWithFormat:@" " perDigit:4];
                    self.cardNum = textField.text;
				}
			}
		}
        
        fieldString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.cardNum = fieldString;
	}
	
	return YES;
}


- (void) textFieldDidChange:(NSNotification *)notification{
    
    UITextField *textField = (UITextField *)notification.object;
    if(textField.delegate != self)
        return;
    
    if (textField.tag == CARDHOLDER_FIELD_TAG) {
		// 持卡人
        self.cardholder = textField.text;
	}
    else if (textField.tag == IDNUM_FIELD_TAG) {
		// 证件号码
        self.idNum = textField.text;
	}
    else if (textField.tag == CVV_FIELD_TAG) {
        // 验证码校验
        self.cvv = textField.text;
    }
    else if (textField.tag == CARD_FIELD_TAG) {
        // 卡号
		self.cardNum = textField.text;
	}
    
}

#pragma mark -
#pragma mark CardDateDelegate
- (void) cardDate:(CardDate *)cardDate didSelectedDate:(NSString *)date{
    self.validityDate = date;
    [cardList reloadData];
}


#pragma mark -

- (id)init:(NSString *)name btnname:(NSString *)btnname navLeftBtnStyle:(NavLeftBtnStyle)navLeftBtnStyle {
	self.editable = [name isEqualToString:@"编辑常用信用卡"] ? NO : YES;
	
	if (self = [super init:name btnname:btnname navLeftBtnStyle:navLeftBtnStyle]) {
		
	}
	
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    self.view.clipsToBounds = YES;
    
	ReceiveMemoryWarning = NO;
    dataModel = [UniformCounterDataModel shared];
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    // 初始化信用卡列表
    bankNames = [[NSMutableArray alloc] initWithCapacity:2];
    bankIds = [[NSMutableArray alloc] initWithCapacity:0];
    if (orderType == OrderTypeGroupon &&
        !appDelegate.isNonmemberFlow)
    {
        // 走新流程的银行列表
        cards = dataModel.banksOfCreditCard;
        
        for (NSDictionary *cd in cards)
        {
            [bankNames addObject:[cd safeObjectForKey:productNameCN_API]];
            [bankIds addObject:[cd safeObjectForKey:categoryId_API]];
        }
    }
    else
    {
        // 其它走老流程的银行列表
        cards = [SelectCard cardTypes];
        
        for (NSDictionary *cd in cards)
        {
            //国际酒店排除上海银行 by dawn
            InterHotelSearcher *hotelSearch = [InterHotelSearcher shared];
            if (hotelSearch.isInterHotelProgress)
            {
                if ([[cd safeObjectForKey:@"Name"] isEqualToString:@"上海银行"])
                {
                    continue;
                }
            }
            
            [bankNames addObject:[cd safeObjectForKey:@"Name"]];
            [bankIds addObject:[cd safeObjectForKey:@"Id"]];
        }
    }
    
    //tableview
    cardList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT) style:UITableViewStylePlain];
    cardList.delegate = self;
    cardList.dataSource = self;
    cardList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cardList];
    [cardList release];
    cardList.backgroundColor = [UIColor clearColor];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    
    NSString *title = @"确 定";
    if (orderType == OrderTypeGroupon ||
        orderType == OrderTypeFlight) {
        title = @"提交订单";
    }
    
    searchBtn = [UIButton uniformButtonWithTitle:title
                                       ImagePath:Nil
                                          Target:self
                                          Action:@selector(clickConfirmButton)
                                           Frame:CGRectMake((SCREEN_WIDTH - BOTTOM_BUTTON_WIDTH)/2, 20, BOTTOM_BUTTON_WIDTH, BOTTOM_BUTTON_HEIGHT)];
    searchBtn.exclusiveTouch = YES;
    [footerView addSubview:searchBtn];
    cardList.tableFooterView = footerView;
    [footerView release];
    
    // 初始值
    self.bankName = [bankNames safeObjectAtIndex:0];
    self.validityDate = DATE_CHOOSE_TIP;
    self.needCardType = YES;
    self.needCVV = YES;
    jMoidfyCard= [[JModifyCard alloc] init];
    
    if (IOSVersion_7 || (IOSVersion_4 && !IOSVersion_5)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.needCVV) {
            return 4;
        }else{
            return 3;
        }
    }else if(section == 1){
        if (self.needCardType) {
            return 3;
        }else{
            return 1;
        }
    }
	return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)] autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EditCardCell";
    EditCardCell *cell = (EditCardCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[EditCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
    }
    cell.topSplitView.hidden = YES;
    cell.bottomSplitView.hidden = NO;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLbl.text = @"发 卡 行";
            cell.detailLbl.text = self.bankName;
            cell.detailField.hidden = YES;
            cell.detailLbl.hidden = NO;
            cell.arrowView.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.topSplitView.hidden = NO;
            if ([cell.detailLbl.text isEqualToString:BANK_CHOOSE_TIP]) {
                cell.detailLbl.textColor = RGBACOLOR(205, 205, 210, 1);
            }else{
                cell.detailLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            }
        }else if(indexPath.row == 1){
            if (!self.editable) {
                cell.detailLbl.hidden = NO;
                cell.detailField.hidden = YES;
                cell.titleLbl.text = @"卡    号";
                cell.arrowView.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.detailLbl.text = [NSString stringWithFormat:@"%@%@",[@"**********************************************" substringToIndex:self.cardNum.length - 1],
                                       [self.cardNum substringFromIndex:self.cardNum.length - 1]];
            }else{
                cell.titleLbl.text = @"卡    号";
                cell.detailLbl.hidden = YES;
                cell.detailField.hidden = NO;
                cell.detailField.text = self.cardNum;
                cell.detailField.placeholder = @"请填写卡号";
                cell.detailField.delegate = self;
                cell.detailField.textField.tag = CARD_FIELD_TAG;
                cell.arrowView.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.detailField.text = self.cardNum;
            }
        }else if(indexPath.row == 2){
            cell.titleLbl.text = @"有 效 期";
            cell.detailField.hidden = YES;
            cell.detailLbl.hidden = NO;
            cell.detailLbl.text = self.validityDate;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.detailLbl.text = self.validityDate;
            cell.arrowView.hidden = NO;
            if ([cell.detailLbl.text isEqualToString:DATE_CHOOSE_TIP]) {
                cell.detailLbl.textColor = RGBACOLOR(205, 205, 210, 1);
            }else{
                cell.detailLbl.textColor = RGBACOLOR(52, 52, 52, 1);
            }
        }else if(indexPath.row == 3){
            cell.titleLbl.text = @"验 证 码";
            cell.detailLbl.hidden = YES;
            cell.detailField.hidden = NO;
            cell.detailField.placeholder = @"三位(卡背面三位数字)";
            cell.detailField.textField.tag = CVV_FIELD_TAG;
            cell.detailField.delegate = self;
            cell.arrowView.hidden = YES;
            cell.detailField.text = self.cvv;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.topSplitView.hidden = NO;
            cell.titleLbl.text = @"持 卡 人";
            cell.detailField.hidden = NO;
            cell.detailLbl.hidden = YES;
            cell.detailField.placeholder = @"持卡人姓名";
            cell.detailField.returnKeyType = UIReturnKeyDone;
            cell.detailField.textField.tag = CARDHOLDER_FIELD_TAG;
            cell.detailField.delegate = self;
            cell.arrowView.hidden = YES;
            cell.detailField.text = self.cardholder;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if(indexPath.row == 1){
            cell.titleLbl.text = @"证件类型";
            cell.detailField.hidden = YES;
            cell.detailLbl.hidden = NO;
            cell.detailLbl.text = self.idType;
            cell.arrowView.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }else if(indexPath.row == 2){
            cell.titleLbl.text = @"证件号码";
            cell.detailLbl.hidden = YES;
            cell.detailField.hidden = NO;
            cell.detailField.text = self.idNum;
            cell.detailField.placeholder = @"请填写证件号码";
            cell.detailField.textField.tag = IDNUM_FIELD_TAG;
            cell.detailField.delegate = self;
            cell.arrowView.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (!selectTableBank) {
                // 加入银行图标
                NSMutableArray *bankImages = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
                for (NSString *bankId in bankIds) {
                    UIImage *bankImage = [UIImage noCacheImageNamed:[NSString stringWithFormat:@"%@.png", bankId]];
                    if (bankImage) {
                        [bankImages addObject:bankImage];
                    }
                    else {
                        [bankImages removeAllObjects];
                        break;
                    }
                }
                
                if ([bankImages count] > 0) {
                    selectTableBank = [[FilterView alloc] initWithTitle:@"选择发卡行" Datas:bankNames extraImages:bankImages];
                }
                else {
                    selectTableBank = [[FilterView alloc] initWithTitle:@"选择发卡行" Datas:bankNames];
                }
                [selectTableBank selectRow:0];
                selectTableBank.delegate = self;
                [self.view addSubview:selectTableBank.view];
                
                if (!STRINGHASVALUE(self.bankName)) {
                    // 没有数据时不选
                    [selectTableBank selectRow:-1];
                }
                else {
                    [selectTableBank selectRow:[bankNames indexOfObject:self.bankName]];
                }
            }
            [selectTableBank showInView];
            if (selectTableCertificate.view.frame.origin.y<SCREEN_HEIGHT) {
                [selectTableCertificate dismissInView];
            }else if (cardDate.view.frame.origin.y<SCREEN_HEIGHT - 50) {
                [cardDate dpViewLeftBtnPressed];
            }
            [currentTextField resignFirstResponder];
        }else if(indexPath.row == 2){
            [cardDate initStatus];
            [cardDate showInView];
            
            if (selectTableCertificate.view.frame.origin.y < SCREEN_HEIGHT) {
                [selectTableCertificate dismissInView];
            }
            
            [currentTextField resignFirstResponder];
            [self textDown:nil];
        }
    }else if(indexPath.section == 1){
        if (indexPath.row == 1) {
            if (!selectTableCertificate) {
                //证件弹出框
                selectTableCertificate = [[FilterView alloc] initWithTitle:@"选择证件类型"
                                                                     Datas:[NSArray arrayWithObjects:@"身份证", @"护照", @"其它", nil]];
                selectTableCertificate.delegate = self;
                [self.view addSubview:selectTableCertificate.view];
            }
            
            [selectTableCertificate showInView];
            
            if (cardDate.view.frame.origin.y<SCREEN_HEIGHT - 50) {
                [cardDate dpViewLeftBtnPressed];
            }
            [currentTextField resignFirstResponder];
            [self textDown:nil];
        }
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [currentTextField resignFirstResponder];
}

@end
