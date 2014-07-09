//
//  UniformCreditCardMode.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-25.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UniformCreditCardModel.h"
#import "HotelDetailController.h"
#import "CashAccountReq.h"
#import "GrouponSharedInfo.h"
#import "CashAccountConfig.h"
#import "FlightPostManager.h"
#import "InterHotelPostManager.h"
#import "JInterHotelOrder.h"
#import "InterHotelConfirmCtrl.h"

#define kNetTypeGrouponBankList           111
#define kNetTypeFlightBankList            122
#define kNetTypeCheckHotelPassword        222
#define kNetTypeCheckGrouponPassword      333
#define kNetTypeCheckFlightPassword       444
#define kNetTypeCheckInterHotelPassword 555

@interface UniformCreditCardModel ()

@property (nonatomic) CGFloat orderTotal;       // 订单总价
@property (nonatomic) BOOL useCA;               // 是否使用现金账户
@property (nonatomic) int netType;              // 请求类型
@property (nonatomic, strong) NSString *password;       // CA支付密码

@end


static UniformCreditCardModel *model = nil;

@implementation UniformCreditCardModel

@synthesize orderTotal;
@synthesize useCA;
@synthesize netType;


+ (id)shared {
    @synchronized(model)
    {
        if (!model)
        {
            model = [[UniformCreditCardModel alloc] init];
        }
    }
    
    return model;
}


- (void)beginForType:(UniformFromType)type TotalPrice:(CGFloat)totalPrice usedCA:(BOOL)cashAccountAvailable CAPassword:(NSString *)pwd
{
    self.orderTotal = totalPrice;
    self.useCA = cashAccountAvailable;
    if (cashAccountAvailable)
    {
        self.password = pwd;
    }
    
    appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    switch (type)
    {
        case UniformFromTypeHotel:
            // 国内酒店预付
            [self dealNativeHotel];
            break;
        case UniformFromTypeInterHotel:
            // 国际酒店预付
            [self dealInterHotel];
            break;
        case UniformFromTypeFlight:
            // 机票
            [self dealFlight];
            break;
        case UniformFromTypeGroupon:
            // 团购
            [self dealGroupon];
            break;
            
        default:
            break;
    }
}


- (id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}


#pragma mark - Model Methods

// 发起酒店校验CA密码的请求
- (void)checkCAPassword:(NSString *)pwd fromType:(UniformFromType)type
{
    switch (type)
    {
        case UniformFromTypeHotel:
            // 国内酒店预付
            netType = kNetTypeCheckHotelPassword;
            break;
        case UniformFromTypeInterHotel:
            // 国际酒店预付
            netType = kNetTypeCheckInterHotelPassword;
            break;
        case UniformFromTypeFlight:
            // 机票
            netType = kNetTypeCheckFlightPassword;
            
            break;
        case UniformFromTypeGroupon:
            // 团购
            netType = kNetTypeCheckGrouponPassword;
            break;
            
        default:
            break;
    }
    
    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq verifyCashAccountPwdWithPwd:pwd] delegate:self];
}


- (void)dealNativeHotel
{
    NSArray *rooms = [[HotelDetailController hoteldetail] safeObjectForKey:@"Rooms"];
    if (ARRAYHASVALUE(rooms))
    {
        netType = kNetTypeNativeHotel;
        
        if ([[CashAccountReq shared] cashAccountRemain] >= orderTotal && useCA)
        {
            // 余额足够，直接支付
            NSDictionary *room = [rooms safeObjectAtIndex:[RoomType currentRoomIndex]];
            [[HotelPostManager hotelorder] setCurrency:[room safeObjectForKey:CURRENCY]];
            [[HotelPostManager hotelorder] setToPrePay];
            [[HotelPostManager hotelorder] setCashAmount:orderTotal];
            
            // 由于使用CA会与coupon冲突，此处必须清空coupon
            [[Coupon activedcoupons] removeAllObjects];
            [[HotelPostManager hotelorder] setClearCoupons];
            
            [Utils request:HOTELSEARCH req:[[HotelPostManager hotelorder] requesString:YES] delegate:self];
        }
        else
        {
            // 余额不足
            if (useCA)
            {
                [self checkCAPassword:_password fromType:UniformFromTypeHotel];
            }
            else
            {
                // 纯纯的只用信用卡支付全部金额
                [[HotelPostManager hotelorder] setCashAmount:0];
                [[MyElongPostManager card] clearBuildData];
                [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
            }
        }
        
        if (useCA)
        {
            if (UMENG)
            {
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


- (void)dealInterHotel
{
    netType = kNetTypeInterHotel;
    
    if ([[CashAccountReq shared] cashAccountRemain] >= orderTotal && useCA)
    {
        // 余额足够，直接支付
        JInterHotelOrder *interOder = [InterHotelPostManager interHotelOrder];
        //设置CashAmount,余额足够直接支付
        [interOder setCashAmount:orderTotal];
        InterHotelConfirmCtrl *interConfirmCtrl = [[InterHotelConfirmCtrl alloc] init];
        [appDelegate.navigationController pushViewController:interConfirmCtrl animated:YES];
    }
    else
    {
        // 余额不足
        if (useCA)
        {
            [self checkCAPassword:_password fromType:UniformFromTypeInterHotel];
        }
        else
        {
            // 需要走预付流程,先获取信用卡列表
            JInterHotelOrder *interOder = [InterHotelPostManager interHotelOrder];
            //清零CashAmount
            [interOder setCashAmount:0];
            [[MyElongPostManager card] clearBuildData];
            [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
        }
    }
}


- (void)dealFlight
{
    netType = kNetTypeFlight;
    
    // 混合支付，有CA余额减去CA余额，没有则用0
    if (useCA)
    {
        if (STRINGHASVALUE(_password))
        {
            [self checkCAPassword:_password fromType:UniformFromTypeFlight];
        }
        else
        {
            [self orderFlightByCAAndCreditCard];
        }
        
        UMENG_EVENT(UEvent_Flight_Paytype_UseCA)
    }
    else
    {
        [[FlightPostManager flightOrder] setCashAmount:0];
        
        [[MyElongPostManager card] clearBuildData];
        [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
    }
}


- (void)dealGroupon
{
    netType = kNetTypeGroupon;
    
    GrouponSharedInfo *gSharedInfo = [GrouponSharedInfo shared];
    
    // 信用卡支付
    gSharedInfo.payType = 0;
    
    // 混合支付，有CA余额减去CA余额，没有则用0
    if (useCA)
    {
        if (STRINGHASVALUE(_password))
        {
            [self checkCAPassword:_password fromType:UniformFromTypeGroupon];
        }
        else
        {
            [self orderGrouponByCAAndCreditCard];
        }
        
        UMENG_EVENT(UEvent_Groupon_Paytype_UseCA)
    }
    else
    {
        gSharedInfo.cashAmount = [NSNumber numberWithInt:0];
        
        [[MyElongPostManager card] clearBuildData];
        [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
    }
}


// CA与信用卡混合方式提交机票订单
- (void)orderFlightByCAAndCreditCard
{
    netType = kNetTypeFlight;
    
    // 校验密码成功
    // 使用现金账户时，混合支付
    [[FlightPostManager flightOrder] setCashAmount:[[CashAccountReq shared] cashAccountRemain]];
    
    [[MyElongPostManager card] clearBuildData];
    [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
}


// CA与信用卡混合方式提交团购订单
- (void)orderGrouponByCAAndCreditCard
{
    netType = kNetTypeGroupon;
    
    // 校验密码成功
    GrouponSharedInfo *gSharedInfo = [GrouponSharedInfo shared];
    gSharedInfo.cashAmount = [NSNumber numberWithDouble:[[CashAccountReq shared] cashAccountRemain]];
    
    [[MyElongPostManager card] clearBuildData];
    [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
}

#pragma mark - Http Delegate

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSMutableData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if ([Utils checkJsonIsError:root])
    {
        return;
    }
    
    switch (netType)
    {
        case kNetTypeNativeHotel:
        {
            // 国内酒店
            [[SelectCard allCards] removeAllObjects];
            if (ARRAYHASVALUE([root objectForKey:@"CreditCards"]))
            {
                [[SelectCard allCards] addObjectsFromArray:[root objectForKey:@"CreditCards"]];
            }
            
            SelectCard *controller = [[SelectCard alloc] init:@"信用卡预付" style:_NavNormalBtnStyle_ nextState:HOTEL_STATE];
            controller.useCoupon = useCA ? NO : YES;    // Coupon与CA目前不能共存
            [appDelegate.navigationController pushViewController:controller animated:YES];
            
            if (UMENG) {
                // 酒店订单担保页面
                [MobClick event:Event_HotelOrder_CreditCard];
                NSLog(@"UMeng_Event_HotelOrder_CreditCard");
            }
        }
            break;
        case kNetTypeInterHotel:
        {
            // 国内酒店
            [[SelectCard allCards] removeAllObjects];
            if (ARRAYHASVALUE([root objectForKey:@"CreditCards"]))
            {
                [[SelectCard allCards] addObjectsFromArray:[root objectForKey:@"CreditCards"]];
            }
            
            SelectCard *controller = [[SelectCard alloc] init:@"信用卡预付" style:_NavNormalBtnStyle_ nextState:INTERHOTEL_STATE];
            [appDelegate.navigationController pushViewController:controller animated:YES];
            
            if (UMENG) {
                // 酒店订单担保页面
                [MobClick event:Event_InterHotelOrder_CreditCard];
                NSLog(@"UMeng_Event_InterHotelOrder_CreditCard");
            }
        }
            break;
        case kNetTypeGroupon:
        {
            // 团购
            [[SelectCard allCards] removeAllObjects];
            NSArray *cards = [root safeObjectForKey:@"CreditCards"];
            if ([cards isKindOfClass:[NSArray class]] && [cards count] > 0){
                // 已有信用卡纪录时进入信用卡选择页面
                [[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
                
                SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:GROUPON_STATE];
                [appDelegate.navigationController pushViewController:controller animated:YES];
                
                if (UMENG) {
                    //团购酒店信用卡支付页面
                    [MobClick event:Event_GrouponHotelOrder_CreditCard];
                }
            }
            else {
                // 没有信用卡时进入信用卡填写界面
                [[SelectCard cardTypes] removeAllObjects];
                [[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
                
                AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeGroupon];
                [appDelegate.navigationController pushViewController:controller animated:YES];
                
                if (UMENG) {
                    //团购酒店信用卡支付页面
                    [MobClick event:Event_GrouponHotelOrder_CreditCard];
                }
            }
        }
            break;
        case kNetTypeFlight:
        {
            // 机票
            [[SelectCard allCards] removeAllObjects];
			NSArray *cards = [root safeObjectForKey:@"CreditCards"];
            if ([cards isKindOfClass:[NSArray class]] && [cards count] > 0) {
                // 有信用卡时进入信用卡选择
				[[SelectCard allCards] addObjectsFromArray:[root safeObjectForKey:@"CreditCards"]];
                
                SelectCard *controller = [[SelectCard alloc] init:@"信用卡支付" style:_NavNormalBtnStyle_ nextState:FLIGHT_STATE];
                [appDelegate.navigationController pushViewController:controller animated:YES];
			}
            else {
                netType = kNetTypeFlightBankList;
                // 没有信用卡时请求银行列表界面
                JPostHeader *postheader = [[JPostHeader alloc] init];
                [Utils request:MYELONG_SEARCH req:[postheader requesString:YES action:@"GetCreditCardType"] delegate:self];
            }
        }
            break;
        case kNetTypeFlightBankList:
        {
            [[SelectCard cardTypes] removeAllObjects];
			[[SelectCard cardTypes] addObjectsFromArray:[root safeObjectForKey:@"CreditCardTypeList"]];		// 存储银行信息
            
			AddAndEditCard *controller = [[AddAndEditCard alloc] initWithNewCardFromOrderType:OrderTypeFlight];
			[appDelegate.navigationController pushViewController:controller animated:YES];
        }
            break;
        case kNetTypeCheckHotelPassword:
        {
            if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
            {
                netType = kNetTypeNativeHotel;
                // 校验密码成功
                // 由于使用CA会与coupon冲突，此处必须清空coupon
                [[Coupon activedcoupons] removeAllObjects];
                [[HotelPostManager hotelorder] setClearCoupons];
                
                // 使用现金账户时，混合支付
                [[HotelPostManager hotelorder] setCashAmount:[[CashAccountReq shared] cashAccountRemain]];
                
                [[MyElongPostManager card] clearBuildData];
                [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
            }
            else
            {
                // 发送验密成功失败
                [PublicMethods showAlertTitle:@"密码错误" Message:@"请检查"];
                return;
            }
        }
            break;
        case kNetTypeCheckInterHotelPassword:
        {
            if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
            {
                netType = kNetTypeInterHotel;
                // 校验密码成功
                // 需要走预付流程,先获取信用卡列表
                JInterHotelOrder *interOder = [InterHotelPostManager interHotelOrder];
                //设置CashAmount
                [interOder setCashAmount:[[CashAccountReq shared] cashAccountRemain]];
                [[MyElongPostManager card] clearBuildData];
                [Utils request:MYELONG_SEARCH req:[[MyElongPostManager card] requesString:YES] delegate:self];
            }
            else
            {
                // 发送验密成功失败
                [PublicMethods showAlertTitle:@"密码错误" Message:@"请检查"];
                return;
            }
        }
            break;
        case kNetTypeCheckGrouponPassword:
        {
            if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
            {
                [self orderGrouponByCAAndCreditCard];
            }
            else
            {
                // 发送验密成功失败
                [PublicMethods showAlertTitle:@"密码错误" Message:@"请检查"];
                return;
            }
        }
            break;
        case kNetTypeCheckFlightPassword:
        {
            if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
            {
                [self orderFlightByCAAndCreditCard];
            }
            else
            {
                // 发送验密成功失败
                [PublicMethods showAlertTitle:@"密码错误" Message:@"请检查"];
                return;
            }
        }
            break;
            
        default:
            break;
    }
}

@end
