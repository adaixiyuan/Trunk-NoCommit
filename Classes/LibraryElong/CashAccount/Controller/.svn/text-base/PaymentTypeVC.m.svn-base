//
//  PaymentTypeVC.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PaymentTypeVC.h"
#import "HotelDetailController.h"
#import "CashAccountPaymentVC.h"
#import "DefineHotelResp.h"
#import "CashAccountReq.h"
#import "GrouponSharedInfo.h"
#import "CashPayPasswordView.h"
#import "GOrderRequest.h"
#import "JInterHotelOrder.h"
#import "InterHotelPostManager.h"
#import "InterHotelConfirmCtrl.h"

#define NET_TYPE_CREDITCARD     111
#define NET_TYPE_BANKLIST       112
#define NET_TYPE_COMMITORDER    113

#define CARD_CELL_HEIGHT_SMALL 40
#define CARD_CELL_HEIGHT_MIDDLE 90
#define CARD_CELL_HEIGHT_BIG 135


@interface PaymentTypeVC ()
@end

@implementation PaymentTypeVC
@synthesize selectedCard;


- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [cardsUtil cancel];
    SFRelease(cardsUtil);
    
    [bankUntil cancel];
    SFRelease(bankUntil);
    [loadingView release];
    [confirmController release];
    [grouponConfirmVC release];
    
    [super dealloc];
}

/*
 * 本页UI随逻辑变动较多，不做内存警告处理
 */

- (id)initWithType:(PaymentType)type
{
    payType = type;
    
    if (self = [super initWithTopImagePath:nil andTitle:@"选择支付方式" style:_NavNoTelStyle_]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(NotiCashPasswordFailed)
                                                     name:NOTI_CASHACCOUNT_PASSERROR
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(NotiCashPasswordCancel)
                                                     name:NOTI_CASHACCOUNT_PASSCANCEL
                                                   object:nil];
        
        defaultCardCount = [[SelectCard allCards] count];
        preSelectRow = 0;
        currentRow = 0;
        sectionNum = 2;
        selectedCard = YES;
        
        // 页面初始请求客史信息
        preloadOver = NO;
        _showHotelInvoiceTip = NO;
        
		[self preRequestBankList];
        [self requestForCards];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    offY = 0;
    
    // ============================================================
    // tableview
    UIView *headView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [headView addSubview:[self makeMoneyPartUI]];
    [headView addSubview:[self makePayTypeChoosingPart]];
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, offY);
    
    _creditCardTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT - 44)];
    _creditCardTable.dataSource = self;
    _creditCardTable.delegate = self;
    _creditCardTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _creditCardTable.separatorColor = [UIColor clearColor];
    [self.view addSubview:_creditCardTable];
    [_creditCardTable release];
    
    _creditCardTable.tableHeaderView = headView;
    
    [self makeBottomBar];
}





// 请求客史信用卡
- (void)requestForCards
{
    if (!loadingView) {
        loadingView = [[SmallLoadingView alloc] initWithFrame:CGRectMake(135, MAINCONTENTHEIGHT - 160, 50, 50)];
    }
    
    [self.view addSubview:loadingView];
    [loadingView startLoading];
    
    if (cardsUtil)
    {
        [cardsUtil cancel];
        SFRelease(cardsUtil);
    }
    cardsUtil = [[HttpUtil alloc] init];
    [cardsUtil connectWithURLString:MYELONG_SEARCH
                            Content:[[MyElongPostManager card] requesString:YES]
                       StartLoading:NO
                         EndLoading:NO
                           Delegate:self];
}


// 预加载银行列表
- (void)preRequestBankList {
    bankUntil = [[HttpUtil alloc] init];
    JPostHeader *postheader = [[[JPostHeader alloc] init] autorelease];
    [bankUntil connectWithURLString:MYELONG_SEARCH
                            Content:[postheader requesString:YES action:@"GetCreditCardType"]
                       StartLoading:NO
                         EndLoading:NO
                           Delegate:self];
}


// 订单总额部分
- (UIView *)makeMoneyPartUI
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 80, 45)];
    titleLabel.text = @"订单总额：";
    titleLabel.font = FONT_B16;
    [bgView addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(98, 10, 210, 45)];
    moneyLabel.textColor = [UIColor orangeColor];
    moneyLabel.font = [UIFont systemFontOfSize:32];
    [bgView addSubview:moneyLabel];
    [moneyLabel release];
    
    offY = moneyLabel.frame.origin.y + moneyLabel.frame.size.height;
    
    if (payType == PaymentTypeNativeHotel)
    {
        // 预付页面构造
        NSDictionary *dic = [[[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"] safeObjectAtIndex:[RoomType currentRoomIndex]];
 
        
        payMoney = [[HotelPostManager hotelorder] getTotalPrice];
        
        couponPrice = 0;
        NSArray *coupons = [[HotelPostManager hotelorder] getCoupons];
        if (ARRAYHASVALUE(coupons))
        {
            // 取出coupon的值
            couponPrice = [[[coupons safeObjectAtIndex:0] safeObjectForKey:@"CouponValue"] intValue];
        }
        
        moneyLabel.text = [NSString stringWithFormat:@"¥%.f", payMoney - couponPrice];
        
        if (couponPrice > 0)
        {
            // 如果使用消费券立减后，显示价格构成
            UILabel *priceStructure = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.origin.x - 8,
                                                                                moneyLabel.frame.origin.y + 18,
                                                                                190,
                                                                                moneyLabel.frame.size.height)];
            moneyLabel.center = CGPointMake(moneyLabel.center.x, moneyLabel.center.y - 5);
            
            NSString *priceStr;
            priceStr = [NSString stringWithFormat:@"  ¥%.f - ¥%d（消费券立减）",
                        payMoney, couponPrice];
            
            priceStructure.font				= [UIFont systemFontOfSize:15];
            priceStructure.textColor		= [UIColor blackColor];
            priceStructure.backgroundColor	= [UIColor clearColor];
            priceStructure.adjustsFontSizeToFitWidth = YES;
            priceStructure.minimumFontSize	= 10;
            priceStructure.text				= priceStr;
            [bgView addSubview:priceStructure];
            [priceStructure release];
            
            offY += 10;
        }
        
        // 显示预付规则说明
        NSArray *rules = [dic safeObjectForKey:@"PrepayRules"];
        if (ARRAYHASVALUE(rules))
        {
            NSString *ruleString = [[rules safeObjectAtIndex:0] safeObjectForKey:@"Description"];
            CGSize textSize = [ruleString sizeWithFont:FONT_12 constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:UILineBreakModeWordWrap];
            
            UILabel *pretipLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, offY, 282, textSize.height)];
            pretipLabel.textColor       = [UIColor darkGrayColor];
            pretipLabel.text            = ruleString;
            pretipLabel.font			= FONT_12;
            pretipLabel.numberOfLines   = 0;
            pretipLabel.backgroundColor = [UIColor clearColor];
            [bgView addSubview:pretipLabel];
            [pretipLabel release];
            
            // 调整UI布局
            offY += pretipLabel.frame.size.height + 15;
            CGRect rect = bgView.frame;
            rect.size.height = offY;
            bgView.frame = rect;
        }
        
        // 担保
    }
    else if (payType == PaymentTypeInterHotel)
    {
        // 国际酒店页面构造
        // 预付流程，价格与全额担保一样
        JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
        NSDictionary *interProduct = [interOrder getObjectForKey:Req_InterHotelProducts];
        payMoney = [[interProduct safeObjectForKey:Req_OrderTotalPrice] safeFloatValue];
        moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", payMoney];
        
        //int offY = priceLabel.frame.origin.y + priceLabel.frame.size.height + 6;
    }
    else if (payType == PaymentTypeGroupon)
    {
        // 团购页面构造
        GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
        payMoney = [gInfo.isInvoice boolValue] ? [gInfo.showTotalPrice intValue] + (int)round([gInfo.expressFee floatValue]) : [gInfo.showTotalPrice intValue];
        moneyLabel.text = [NSString stringWithFormat:@"¥%.f", payMoney];
        
        //重新微调价格构成文字位置，分两行显示
        UILabel *priceStructure = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.origin.x - 8,
                                                                            moneyLabel.frame.origin.y + 18,
                                                                            190,
                                                                            moneyLabel.frame.size.height)];
        
        moneyLabel.center = CGPointMake(moneyLabel.center.x, moneyLabel.center.y - 5);
        
        NSString *priceStr;
        if ([gInfo.isInvoice boolValue])
        {
            priceStr = [NSString stringWithFormat:@"（¥%dx%d + ¥%.0f 快递费）",
                        (int)round([gInfo.salePrice floatValue]),
                        [gInfo.purchaseNum intValue],
                        [gInfo.expressFee floatValue]];
        }
        else
        {
            priceStr = [NSString stringWithFormat:@"（¥%d x %d）",
                        (int)round([gInfo.salePrice floatValue]),
                        [gInfo.purchaseNum intValue]];
        }
        
        priceStructure.font				= [UIFont systemFontOfSize:15];
        priceStructure.textColor		= [UIColor blackColor];
        priceStructure.backgroundColor	= [UIColor clearColor];
        priceStructure.adjustsFontSizeToFitWidth = YES;
        priceStructure.minimumFontSize	= 10;
        priceStructure.text				= priceStr;
        [bgView addSubview:priceStructure];
        [priceStructure release];
        
        offY += 10;
    }
    
    UIImageView *dash = [UIImageView graySeparatorWithFrame:CGRectMake(10, offY - 5, 300, 1)];
    [bgView addSubview:dash];
    
    return [bgView autorelease];
}


// 支付模式选择
- (UIView *)makePayTypeChoosingPart
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, offY, SCREEN_WIDTH, 140)];
    
    // ================
    // 现金账户选择
    offY = 5;
    cashLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offY, 10, 14)];
    cashLeftLabel.text = @"您的可用现金账户余额：";
    cashLeftLabel.font = FONT_14;
    [cashLeftLabel sizeToFit];
    [bgView addSubview:cashLeftLabel];
    [cashLeftLabel release];
    
    cashNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(cashLeftLabel.frame.origin.x + cashLeftLabel.frame.size.width, offY - 1, 10, 14)];
    cashNumLabel.text = [NSString stringWithFormat:@"¥%.f", [[CashAccountReq shared] cashAccountRemain]];
    cashNumLabel.font = FONT_16;
    cashNumLabel.textColor = [UIColor orangeColor];
    [cashNumLabel sizeToFit];
    [bgView addSubview:cashNumLabel];
    [cashNumLabel release];
    
    cashRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(cashNumLabel.frame.origin.x + cashNumLabel.frame.size.width, offY, 10, 14)];
    cashRightLabel.font = FONT_14;
    [bgView addSubview:cashRightLabel];
    [cashRightLabel release];
    
    offY += 26;
    UIImageView *cashBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, offY, SCREEN_WIDTH - 20, 48)];
    cashBg.image = [UIImage imageNamed:@"fillorder_cell.png"];
    cashBg.userInteractionEnabled = YES;
    [bgView addSubview:cashBg];
    [cashBg release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 180, cashBg.frame.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"艺龙现金账户支付";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = FONT_B16;
    [cashBg addSubview:titleLabel];
    [titleLabel release];
    
    int offX = IOSVersion_5 ? 215 : 195;
    cashSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(offX, 11, 0, 0)];
    cashSwitch.userInteractionEnabled = NO;
    [cashBg addSubview:cashSwitch];
    [cashSwitch release];
    
    // 加个按钮在switch上面，控制页面开关逻辑
    switchBtn = [[ButtonView alloc] initWithFrame:CGRectMake(200, 0, cashBg.frame.size.width - 200, cashBg.frame.size.height)];
    switchBtn.delegate = self;
    switchBtn.userInteractionEnabled = NO;
    [cashBg addSubview:switchBtn];
    [switchBtn release];
    
    invoiceTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, cashBg.frame.origin.y + cashBg.frame.size.height + 4, 300, 30)];
    invoiceTipLabel.backgroundColor = [UIColor clearColor];
    invoiceTipLabel.numberOfLines = 0;
    invoiceTipLabel.font = FONT_B12;
    invoiceTipLabel.alpha = 0;
    [bgView addSubview:invoiceTipLabel];
    [invoiceTipLabel release];
    
    invoiceNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 15, 120, 16)];
    invoiceNumLabel.backgroundColor = [UIColor clearColor];
    invoiceNumLabel.font = FONT_B12;
    invoiceNumLabel.textColor = [UIColor orangeColor];
    [invoiceTipLabel addSubview:invoiceNumLabel];
    [invoiceNumLabel release];
    // ================
    // 信用卡选择
    offY += 93;
    
    creditLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, offY, 170, 14)];
    creditLeftLabel.font = FONT_14;
    creditLeftLabel.text = @"信用卡支付：";
    [bgView addSubview:creditLeftLabel];
    [creditLeftLabel release];
    
    creditNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(creditLeftLabel.frame.origin.x + creditLeftLabel.frame.size.width, creditLeftLabel.frame.origin.y, SCREEN_WIDTH - creditLeftLabel.frame.origin.x - creditLeftLabel.frame.size.width, 14)];
    creditNumLabel.font = FONT_16;
    creditNumLabel.textColor = [UIColor orangeColor];
    [bgView addSubview:creditNumLabel];
    [creditNumLabel release];
    
    offY = bgView.frame.origin.y + bgView.frame.size.height;
    
    return [bgView autorelease];
}


// 提交订单按钮
- (void)makeBottomBar
{
    // 添加底栏
	UIImageView *listFooterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MAINCONTENTHEIGHT - 44, SCREEN_WIDTH, 44)];
	listFooterView.userInteractionEnabled = YES;
	listFooterView.image = [UIImage stretchableImageWithPath:@"groupon_detail_switch_normal_btn.png"];
	
	// 阴影
	UIImageView *shadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -8 , SCREEN_WIDTH, 8)];
	shadow.image = [UIImage imageNamed:@"bottom_bar_shadow.png"];
	[listFooterView addSubview:shadow];
	[shadow release];
    
    UIButton *nextButton = [UIButton uniformButtonWithTitle:@"提交订单"
                                                  ImagePath:@"confirm_sign.png"
                                                     Target:self
                                                     Action:@selector(clickNextButton)
                                                      Frame:CGRectMake(50, 4, 220, 36)];
	
	[listFooterView addSubview:nextButton];
	
	[self.view addSubview:listFooterView];
	[listFooterView release];
}


// ca验密失败时，关闭ca开关
- (void)NotiCashPasswordFailed
{
    [self ButtonViewIsPressed:switchBtn];
}


- (void)NotiCashPasswordCancel
{
    [self popPasswordPage];
}


- (void)popPasswordPage
{
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    CashPayPasswordView *passView = [[CashPayPasswordView alloc] initWithCashMoney:[NSString stringWithFormat:@"%.f", [[CashAccountReq shared] cashAccountRemain]]];
    [appDelegate.window addSubview:passView];
    [passView release];
}


- (BOOL)checkInputData
{
	NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
	SelectCardCell *cell = (SelectCardCell *)[_creditCardTable cellForRowAtIndexPath:path];
	
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


- (BOOL)checkInputCardCode
{
	NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
	SelectCardCell *cell = (SelectCardCell *)[_creditCardTable cellForRowAtIndexPath:path];
    
	if(cell.codeTF.text.length > 0 &&
	   ![[NSPredicate predicateWithFormat:@"SELF MATCHES '\\\\d{3}'"] evaluateWithObject:cell.codeTF.text]) {
		return YES;
	}
    
	return NO;
}


// 校验数据正确性
- (NSString *)checkData
{
    if (!cashSwitch.on && [[SelectCard allCards] count] == 0)
    {
        return @"请选择支付方式";
    }
    
    if (selectedCard == NO)
    {
        // 不选信用卡时的验证
        if (!cashSwitch.on)
        {
            return @"请选择支付方式";
        }
        
        if ([[CashAccountReq shared] cashAccountRemain] < payMoney)
        {
            return @"您的现金账户余额不足，请选择或新增信用卡完成支付";
        }
    }
    else
    {
        if ([[CashAccountReq shared] cashAccountRemain] < payMoney &&
            [[SelectCard allCards] count] == 0)
        {
            return @"您的现金账户余额不足，请选择或新增信用卡完成支付";
        }
        
        // 选择信用卡后的验证
        if (![self checkInputData])
        {
            return @"信用卡后四位输入错误";
        }
        
        if ([self checkInputCardCode])
        {
            return @"请正确填写信用卡三位验证码";
        }
    }
    
    return nil;
}


// 点击新增信用卡
- (void)clickCreditBtn
{
    [self requestBankList:YES];
//    netType = NET_TYPE_CREDITCARD;
//    
//    JPostHeader *postheader = [[JPostHeader alloc] init];
//    [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
//    [postheader release];
    
// 流程细分，暂时屏蔽 
//    switch (payType) {
//        case PaymentTypeNativeHotel:
//        {
//            if (cashSwitch.on)
//            {
//                if (payMoney > [[CashAccountReq shared] cashAccountRemain])
//                {
//                    
//                }
//            }
//            else
//            {
//                netType = NET_TYPE_CREDITCARD;
//                
//                JPostHeader *postheader = [[JPostHeader alloc] init];
//                [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
//                [postheader release];
//            }
//        }
//            break;
//        case PaymentTypeGroupon:
//        {
//            GrouponSharedInfo *gInfo = [GrouponSharedInfo shared];
//            if (cashSwitch.on)
//            {
//                // 如果使用了现金账户支付，在总价里减去对应的钱
//                gInfo.showTotalPrice = [NSNumber numberWithFloat:payMoney - [[CashAccountReq shared] cashAccountRemain]];
//                gInfo.cashPayment = [[CashAccountReq shared] cashAccountRemain];
//            }
//            else
//            {
//                // 恢复原价
//                gInfo.showTotalPrice = [NSNumber numberWithFloat:payMoney];
//                gInfo.cashPayment = 0;
//            }
//            netType = NET_TYPE_CREDITCARD;
//            
//            [[MyElongPostManager card] clearBuildData];
//            [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
//        }
//            break;
//            
//        default:
//            break;
//    }
}


// 点击提交订单
- (void)clickNextButton
{
    NSString *errorMsg = [self checkData];
    if (STRINGHASVALUE(errorMsg)) {
        [PublicMethods showAlertTitle:errorMsg Message:nil];
        return;
    }
    
    if (payType == PaymentTypeNativeHotel)
    {
        [self orderNativeHotel];
    }
    else if (payType == PaymentTypeInterHotel)
    {
        [self orderInterHotel];
    }
    else if (payType == PaymentTypeGroupon)
    {
        [self orderGroupon];
    }
}


// 预订国内酒店
- (void)orderNativeHotel
{
    NSArray *rooms = [[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"];
    if (ARRAYHASVALUE(rooms))
    {
        netType = NET_TYPE_COMMITORDER;
        
        if ([[CashAccountReq shared] cashAccountRemain] >= payMoney && cashSwitch.on)
        {
            // 余额足够，直接支付
            NSDictionary *room = [rooms safeObjectAtIndex:[RoomType currentRoomIndex]];
            [[HotelPostManager hotelorder] setCurrency:[room safeObjectForKey:CURRENCY]];
            [[HotelPostManager hotelorder] setToPrePay];
            [[HotelPostManager hotelorder] setCashAmount:payMoney];
            
            // 由于使用CA会与coupon冲突，此处必须清空coupon
            [[Coupon activedcoupons] removeAllObjects];
            [[HotelPostManager hotelorder] setClearCoupons];
            
            [Utils request:HOTELSEARCH req:[[HotelPostManager hotelorder] requesString:YES] delegate:self];
        }
        else
        {
            // 余额不足
            if (cashSwitch.on) {
                // 使用现金账户时，混合支付
                [[HotelPostManager hotelorder] setCashAmount:[[CashAccountReq shared] cashAccountRemain]];
                
                // 由于使用CA会与coupon冲突，此处必须清空coupon
                [[Coupon activedcoupons] removeAllObjects];
                [[HotelPostManager hotelorder] setClearCoupons];
            }
            else
            {
                // 纯纯的只用信用卡支付全部金额
                [[HotelPostManager hotelorder] setCashAmount:0];
            }
            
            NSMutableDictionary *cardDate = [NSMutableDictionary dictionaryWithDictionary:[[SelectCard allCards] safeObjectAtIndex:currentRow]];
            NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
            SelectCardCell *cell = (SelectCardCell *)[_creditCardTable cellForRowAtIndexPath:path];
            [cardDate safeSetObject:cell.codeTF.text forKey:@"VerifyCode"];
            
            CGFloat vouchMoney = [[HotelPostManager hotelorder] getTotalPrice] - [[[HotelPostManager hotelorder] getCashAmount] doubleValue];
            [[HotelPostManager hotelorder] setVouch:1 vouchMoney:vouchMoney vouchData:cardDate];
            
            if (!confirmController) {
                confirmController = [[ConfirmHotelOrder alloc] init];
            }
            
            [confirmController nextState];
        }
        
        if (cashSwitch.on) {
            if (UMENG) {
                //礼品卡支付
                [MobClick event:Event_CAOrderSubmit];
            }
        }
    }
    else
    {
        [PublicMethods showAlertTitle:@"订单信息有误" Message:nil];
    }
}


// 预订国际酒店
- (void)orderInterHotel
{
    netType = NET_TYPE_COMMITORDER;
    
    if ([[CashAccountReq shared] cashAccountRemain] >= payMoney && cashSwitch.on)
    {
        // 余额足够，直接支付
        //写入国际提交订单数据第三步，记录信用卡-----------------------
        //---------------------------------------------------------------------------------
        InterHotelConfirmCtrl *interConfirmCtrl = [[InterHotelConfirmCtrl alloc] init];
        [self.navigationController pushViewController:interConfirmCtrl animated:YES];
        [interConfirmCtrl release];
    }
    else
    {
        // 余额不足
        if (cashSwitch.on) {
            // 使用现金账户时，混合支付
            //JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
        }
        else
        {
            // 纯纯的只用信用卡支付全部金额
            //JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
        }
        
        NSMutableDictionary *cardDate = [NSMutableDictionary dictionaryWithDictionary:[[SelectCard allCards] safeObjectAtIndex:currentRow]];
        NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
        SelectCardCell *cell = (SelectCardCell *)[_creditCardTable cellForRowAtIndexPath:path];
        [cardDate safeSetObject:cell.codeTF.text forKey:@"VerifyCode"];
        
        //写入国际提交订单数据第三步，记录信用卡-----------------------
        JInterHotelOrder *interOrder = [InterHotelPostManager interHotelOrder];
        [interOrder setCreditCardData:cardDate];
        //---------------------------------------------------------------------------------
        InterHotelConfirmCtrl *interConfirmCtrl = [[InterHotelConfirmCtrl alloc] init];
        [self.navigationController pushViewController:interConfirmCtrl animated:YES];
        [interConfirmCtrl release];
    }
}


// 预订团购
- (void)orderGroupon
{
    netType = NET_TYPE_COMMITORDER;
    
    GrouponSharedInfo *gSharedInfo = [GrouponSharedInfo shared];
    // 信用卡支付
    gSharedInfo.payType = 0;
    
    if ([[CashAccountReq shared] cashAccountRemain] >= payMoney && cashSwitch.on)
    {
        // 余额足够，直接支付
        gSharedInfo.cashAmount = [NSNumber numberWithDouble:payMoney];
        
        grouponConfirmVC = [[GrouponConfirmViewController alloc] initWithCardInfo:nil];
        [grouponConfirmVC nextState];
    }
    else
    {
        // 余额不足
        if (cashSwitch.on) {
            // 使用现金账户时，混合支付
            gSharedInfo.cashAmount = [NSNumber numberWithDouble:[[CashAccountReq shared] cashAccountRemain]];
        }
        else
        {
            // 纯纯的只用信用卡支付全部金额
            gSharedInfo.cashAmount = [NSNumber numberWithInt:0];
        }
        
        NSMutableDictionary *cardDate = [NSMutableDictionary dictionaryWithDictionary:[[SelectCard allCards] safeObjectAtIndex:currentRow]];
        NSIndexPath *path = [NSIndexPath indexPathForRow:currentRow inSection:0];
        SelectCardCell *cell = (SelectCardCell *)[_creditCardTable cellForRowAtIndexPath:path];
        [cardDate safeSetObject:cell.codeTF.text forKey:@"VerifyCode"];
        
        grouponConfirmVC = [[GrouponConfirmViewController alloc] initWithCardInfo:cardDate];
        [grouponConfirmVC nextState];
    }
}


- (BOOL)canUseCashToPayAll
{
    if ([[CashAccountReq shared] cashAccountRemain] >= payMoney - couponPrice)
    {
        // 余额足够支付当前订单,直接进行下单
        [Utils alert:@"成功支付"];
        
        return YES;
    }
    else
    {
        // 余额不足,需要使用信用卡补充下单
        [cashSwitch setOn:YES animated:NO];
        
        return NO;
    }
}


// 展示信用卡和相关提示
- (void)showCreditCard
{
    if(sectionNum == 0)
    {
        selectedCard = YES;
        
        [UIView animateWithDuration:.2 animations:^{
            creditLeftLabel.alpha = 1;
            creditNumLabel.alpha = 1;
            
            sectionNum = 2;
            [_creditCardTable reloadData];
        }];
    }
}


// 隐藏信用卡和相关提示
- (void)closeCreditCard
{
    if (sectionNum == 2)
    {
        selectedCard = NO;
        
        [UIView animateWithDuration:.2 animations:^{
            creditLeftLabel.alpha = 0;
            creditNumLabel.alpha = 0;
            
            sectionNum = 0;
            [_creditCardTable reloadData];
        }];
    }
}


- (void)goAddCardController
{
    // 进入新增信用卡页面
    AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeCashAmount];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)goModifyCardController {
    // 进入修改信用卡页面
    NSMutableDictionary *card = [[SelectCard allCards] safeObjectAtIndex:currentOverDueRow];
    AddAndEditCard *controller = [[AddAndEditCard alloc] initWithCard:card tipOverDue:YES];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


- (void)requestBankList:(BOOL)isAddCard {
	[self.view endEditing:YES];
	[self textFieldDidEnd:nil];
	
    if (!preloadOver) {
        // 没有获取到入住人时停止本页请求
        [bankUntil cancel];
    }
    
    // 取缓存数据,取决于是否预加载到银行列表
    NSDictionary *root = [PublicMethods unCompressData:[[CacheManage manager] getBankListData]];
    if (DICTIONARYHASVALUE(root)) {
        [[SelectCard cardTypes] removeAllObjects];
        [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];
        
        // 直接进入信用卡新增(编辑)页面
        if (isAddCard)
        {
            [self goAddCardController];
        }
        else
        {
            [self goModifyCardController];
        }
        
        return;
    }
    
	netType = isAddCard ? NETCARDTYPE_STATE : NETCARDTYPE_EDIT;
	JPostHeader *postheader = [[JPostHeader alloc] init];
	[Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
	[postheader release];
}


- (void)refreshTable
{
    [_creditCardTable reloadData];
}


#pragma mark - Animation

// 现金账户文字更改动画
- (void)animationCashLabelTextChange
{
    CGFloat animationAlpha = 0.5;
    if (cashSwitch.on)
    {
        [UIView animateWithDuration:0.1 animations:^{
            cashLeftLabel.alpha = animationAlpha;
            cashNumLabel.alpha = animationAlpha;
            cashRightLabel.alpha = animationAlpha;
        } completion:^(BOOL finished) {
            // 打开开关，更改ca的提示文字
            cashLeftLabel.text = @"本单将使用";
            [cashLeftLabel sizeToFit];
            
            cashNumLabel.text = [NSString stringWithFormat:@"¥%.f", MIN(payMoney, [[CashAccountReq shared] cashAccountRemain])];
            [cashNumLabel sizeToFit];
            CGRect rect = cashNumLabel.frame;
            rect.origin.x = cashLeftLabel.frame.origin.x + cashLeftLabel.frame.size.width + 3;
            cashNumLabel.frame = rect;
            
            cashRightLabel.text = @"账户余额用于支付";
            [cashRightLabel sizeToFit];
            rect = cashRightLabel.frame;
            rect.origin.x = cashNumLabel.frame.origin.x + cashNumLabel.frame.size.width + 3;
            cashRightLabel.frame = rect;
            
            [UIView animateWithDuration:0.1 animations:^{
                cashLeftLabel.alpha = 1;
                cashNumLabel.alpha = 1;
                cashRightLabel.alpha = 1;
            }];
            
            invoiceTipLabel.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            cashLeftLabel.alpha = animationAlpha;
            cashNumLabel.alpha = animationAlpha;
            cashRightLabel.alpha = animationAlpha;
        } completion:^(BOOL finished) {
            // 关闭开关，更改ca的提示文字
            cashLeftLabel.text = @"您的可用现金账户余额：";
            [cashLeftLabel sizeToFit];
            
            cashNumLabel.text = [NSString stringWithFormat:@"¥%.f", [[CashAccountReq shared] cashAccountRemain]];
            [cashNumLabel sizeToFit];
            CGRect rect = cashNumLabel.frame;
            rect.origin.x = cashLeftLabel.frame.origin.x + cashLeftLabel.frame.size.width;
            cashNumLabel.frame = rect;
            
            cashRightLabel.text = nil;
            [cashRightLabel sizeToFit];
            
            [UIView animateWithDuration:0.1 animations:^{
                cashLeftLabel.alpha = 1;
                cashNumLabel.alpha = 1;
                cashRightLabel.alpha = 1;
            }];
            
            invoiceTipLabel.alpha = 0;
        }];
    }
}


// 信用卡文字更改动画
- (void)animationCreditLabelTextChange
{
    if (sectionNum == 2) {
        CGFloat animationAlpha = 0.5;
        if (cashSwitch.on)
        {
            [UIView animateWithDuration:0.1 animations:^{
                creditLeftLabel.alpha = animationAlpha;
                creditNumLabel.alpha = animationAlpha;
            } completion:^(BOOL finished) {
                // 打开开关，更改信用卡的提示文字
                creditLeftLabel.text = @"使用信用卡支付剩余金额：";
                CGFloat vouchMoney = payMoney - couponPrice -[[CashAccountReq shared] cashAccountRemain];
                if (vouchMoney > 0)
                {
                    creditNumLabel.text = [NSString stringWithFormat:@"¥%.f", vouchMoney];
                    
                    if (payType == PaymentTypeNativeHotel)
                    {
                        [self changeHeaderViewByUsingCashAccount:YES];
                    }
                }
                else
                {
                    if (payType == PaymentTypeNativeHotel)
                    {
                        [self changeHeaderViewByUsingCashAccount:NO];
                    }
                }
                
                [UIView animateWithDuration:0.1 animations:^{
                    creditLeftLabel.alpha = 1;
                    creditNumLabel.alpha = 1;
                }];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.1 animations:^{
                creditLeftLabel.alpha = animationAlpha;
                creditNumLabel.alpha = animationAlpha;
            } completion:^(BOOL finished) {
                // 关闭开关，更改信用卡的提示文字
                creditLeftLabel.text = @"常用信用卡支付：";
                creditNumLabel.text = nil;
                
                [UIView animateWithDuration:0.1 animations:^{
                    creditLeftLabel.alpha = 1;
                    creditNumLabel.alpha = 1;
                }];
            }];
        }
    }
}


- (void)changeHeaderViewByUsingCashAccount:(BOOL)usingCA
{
    if (usingCA)
    {
        // 酒店发票提示
        invoiceTipLabel.text = @"注意：使用现金帐户部分无法开具发票，您开的发票总额为";
        invoiceNumLabel.text = creditNumLabel.text;
    }
    else
    {
        invoiceTipLabel.text = @"注意：使用现金帐户支付无法开具发票";
        invoiceNumLabel.text = @"";
    }
}

#pragma mark -
#pragma mark AddAndEditCardDelegate

- (void)getModifiedCard:(NSDictionary *)dic {
	[[SelectCard allCards] replaceObjectAtIndex:currentOverDueRow withObject:dic];
	currentRow = currentOverDueRow;
	[_creditCardTable reloadData];
}

#pragma mark - ButtonView Delegate

- (void)ButtonViewIsPressed:(ButtonView *)button
{
    [super ButtonViewIsPressed:button];
    [self.view endEditing:YES];
    [self textFieldDidEnd:nil];
    
    if (button == switchBtn) {
        if (cashSwitch.on)
        {
            [cashSwitch setOn:NO animated:YES];
            
            // 为了获取更好的效果，需要延时
            [self performSelector:@selector(showCreditCard) withObject:nil afterDelay:0.2];
        }
        else
        {
            [cashSwitch setOn:YES animated:YES];
            
            if ([[CashAccountReq shared] needPassword])
            {
                // 如有支付密码，进入密码输入页
                [self popPasswordPage];
            }
            
            if ([[CashAccountReq shared] cashAccountRemain] >= payMoney)
            {
                [self closeCreditCard];
            }
        }
        
        [self animationCashLabelTextChange];
        [self animationCreditLabelTextChange];
    }
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidActive:(id)sender {
	if (_creditCardTable.contentInset.bottom == 0) {
		_creditCardTable.contentInset = UIEdgeInsetsMake(0, 0, 261, 0);
		[_creditCardTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]
                               atScrollPosition:UITableViewScrollPositionMiddle
                                       animated:YES];
	}
}


- (void)textFieldDidEnd:(id)sender {
	if ((_creditCardTable.contentInset.bottom != 0 && [sender isFirstResponder]) ||
		!sender) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3f];
		
		_creditCardTable.contentInset = UIEdgeInsetsZero;
		
		[UIView commitAnimations];
	}
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if ([textField isKindOfClass:[CustomTextField class]]) {
        [textField performSelector:@selector(resetTargetKeyboard)];
        CustomTextField *customField = (CustomTextField *)textField;
        customField.abcEnabled = NO;
        [customField showNumKeyboard];
    }
    
    return YES;
}


- (void)keyboardWillHide:(NSNotification *)noti {
	[self textFieldDidEnd:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self textFieldDidEnd:nil];
	return [textField resignFirstResponder];
}


#pragma mark -
#pragma mark NetDelegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        if (util == cardsUtil) {
            [loadingView removeFromSuperview];
            cashSwitch.userInteractionEnabled = YES;
            switchBtn.userInteractionEnabled = YES;
        }
        
        return ;
    }
    
    if (util == cardsUtil)
    {
        [[SelectCard allCards] removeAllObjects];
        if ([root safeObjectForKey:@"CreditCards"]!=[NSNull null]) {
            [[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
        }
        
        [loadingView removeFromSuperview];
        cashSwitch.userInteractionEnabled = YES;
        switchBtn.userInteractionEnabled = YES;
        defaultCardCount = [[SelectCard allCards] count];
        [_creditCardTable reloadData];
    }
    else if (util == bankUntil)
    {
        // 新增信用卡
        [[SelectCard cardTypes] removeAllObjects];
        [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
        [[CacheManage manager] setBankListData:responseData];
        
        preloadOver = YES;
    }
    else
    {
        // 以下是同步请求
        switch (netType)
        {
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
            case NET_TYPE_BANKLIST:
            {
                // 没有信用卡时进入信用卡填写界面（团购）
                [[SelectCard cardTypes] removeAllObjects];
                [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
                
                AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeGroupon];
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            }
            case NET_TYPE_COMMITORDER:
            {
                // 提交订单
                NSString *orderNO = nil;
                if ([root safeObjectForKey:ORDERNO_REQ] && [root safeObjectForKey:ORDERNO_REQ] != [NSNull null]) {
                    orderNO = [root safeObjectForKey:ORDERNO_REQ];
                    if ([orderNO intValue] == 0) {
                        [Utils alert:[NSString stringWithFormat:@"%@", [root safeObjectForKey:@"ErrorMessage"]]];
                        
                        return;
                    }
                }
                else
                {
                    orderNO = (NSString *)[NSNumber numberWithLong:0];
                }
                
                [[HotelPostManager hotelorder] setOrderNo:orderNO];
                HotelOrderSuccess *hotelordersuccess = [[HotelOrderSuccess alloc] init];
                [self.navigationController pushViewController:hotelordersuccess animated:YES];
                [hotelordersuccess release];
            }
                
            default:
                break;
        }
    }
}


- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error {
    if (util == bankUntil) {
        preloadOver = NO;
    }
    if (util == cardsUtil) {
        [loadingView removeFromSuperview];
        cashSwitch.userInteractionEnabled = YES;
        switchBtn.userInteractionEnabled = YES;
    }
}


- (void)httpConnectionDidCanceled:(HttpUtil *)util {
    if (util == bankUntil) {
        preloadOver = NO;
    }
    if (util == cardsUtil) {
        [loadingView removeFromSuperview];
        cashSwitch.userInteractionEnabled = YES;
        switchBtn.userInteractionEnabled = YES;
    }
}

#pragma mark -
#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionNum;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
    {
        if (0 == [[SelectCard allCards] count])
        {
            return 0;
        }
        else
        {
            return [[SelectCard allCards] count] + 1;
        }
    }
	else
    {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        if (indexPath.row != [[SelectCard allCards] count]) {
            NSMutableDictionary *card = [[SelectCard allCards] safeObjectAtIndex:currentRow];
            
            if(currentRow == indexPath.row &&
               ![[card safeObjectForKey:IS_VOER_DUE] boolValue]) {
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
    else
    {
        return CARD_CELL_HEIGHT_MIDDLE;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        if (indexPath.row != [[SelectCard allCards] count]) {
            static NSString *SelectCardKey = @"SelectCardKey";
            SelectCardCell *cell = (SelectCardCell *)[tableView dequeueReusableCellWithIdentifier:SelectCardKey];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectCardCell" owner:self options:nil];
                cell = [nib safeObjectAtIndex:0];
                cell.isSelected = NO;
                cell.selectCard = self;
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
                    
                    CustomTextField *cardTF = [[[CustomTextField alloc] initWithFrame:CGRectMake(215, 10, 88, 18)] autorelease];
                    cell.cardTF = cardTF;
                    
                    CustomTextField *codeTF = [[[CustomTextField alloc] initWithFrame:CGRectMake(227, 52, 74, 18)] autorelease];
                    cell.codeTF = codeTF;
                    
                    cell.cardTF.font = [UIFont boldSystemFontOfSize:16];
                    cell.cardTF.borderStyle = UITextBorderStyleNone;
                    cell.cardTF.numberOfCharacter = 4;
                    cell.cardTF.placeholder = @"输入后四位";
                    
                    cell.codeTF.font = [UIFont boldSystemFontOfSize:16];
                    cell.codeTF.borderStyle = UITextBorderStyleNone;
                    cell.codeTF.numberOfCharacter = 3;
                    cell.codeTF.placeholder = @"输入三位";

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
            NSMutableString *realcardnum=[[NSMutableString alloc] init];
            [realcardnum appendString:[StringEncryption DecryptString:cardnum]];
            [realcardnum deleteCharactersInRange:NSMakeRange(realcardnum.length-4, 4)];
            cell.cardNumLabel.text = [[realcardnum stringByReplaceWithAsteriskFromIndex:4] stringWithCreditFromat];
            [realcardnum release];
            
            cell.cardTF.delegate = self;
            cell.codeTF.delegate = self;
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
    else
    {
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(10, 10, 300, 1)]];
            
            creditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            creditBtn.frame = CGRectMake(10, 25, SCREEN_WIDTH - 20, 48);
            [creditBtn addTarget:self action:@selector(clickCreditBtn) forControlEvents:UIControlEventTouchUpInside];
            [creditBtn setBackgroundImage:[UIImage imageNamed:@"fillorder_cell.png"] forState:UIControlStateNormal];
            [creditBtn setBackgroundImage:[UIImage imageNamed:@"fillorder_cell_h.png"] forState:UIControlStateHighlighted];
            [cell.contentView addSubview:creditBtn];
            
            UILabel *titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(12, (creditBtn.frame.size.height - 16)/2, 180, 16)];
            titleLabel_.backgroundColor = [UIColor clearColor];
            titleLabel_.text = @"使用其它信用卡";
            titleLabel_.textColor = [UIColor grayColor];
            titleLabel_.font = FONT_B16;
            [creditBtn addSubview:titleLabel_];
            [titleLabel_ release];
            
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(creditBtn.bounds.size.width - 20, (creditBtn.frame.size.height - 12)/2, 8, 12)];
            arrow.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
            [creditBtn addSubview:arrow];
            [arrow release];
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        selectedCard = YES;
        
        if ([[SelectCard allCards] count] > 0) {
            NSMutableDictionary *card = [[SelectCard allCards] safeObjectAtIndex:indexPath.row];
            if ([[card safeObjectForKey:IS_VOER_DUE] boolValue]) {
                // 信用卡过期进入信用卡修改页面
                currentOverDueRow = indexPath.row;
                [self requestBankList:NO];
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
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    // 取消上一行的选中状态
                    if (preSelectRow >= 0)
                    {
                        SelectCardCell *lastCell = (SelectCardCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:preSelectRow inSection:0]];
                        lastCell.isSelected = NO;
                        
                        if (!lastCell.isOverDue) {
                            lastCell.selectImgView.image = [UIImage imageNamed:@"btn_checkbox.png"];
                        }
                        lastCell.backView.hidden=YES;
                    }
                    
                    preSelectRow = currentRow;
                }
            }
        }
    }
}


@end
