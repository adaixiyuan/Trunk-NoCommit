//
//  UniformCashAccountModel.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UniformCashAccountModel.h"
#import "HotelDetailController.h"
#import "CashAccountReq.h"
#import "CashAccountConfig.h"
#import "GrouponSharedInfo.h"
#import "CashAccountReq.h"
#import "FlightPostManager.h"
#import "InterHotelPostManager.h"
#import "JInterHotelOrder.h"
#import "InterHotelConfirmCtrl.h"
#import "UniformCounterDataModel.h"
#import "GrouponSuccessController.h"

@interface UniformCashAccountModel()

@property (nonatomic) CGFloat orderTotal;       // 订单总价
@property (nonatomic) int netType;              // 请求类型
@property (nonatomic) UniformFromType payType;  // 支付类型

@end


static UniformCashAccountModel *model = nil;

@implementation UniformCashAccountModel

@synthesize orderTotal;
@synthesize netType;
@synthesize payType;


+ (id)shared {
    @synchronized(model)
    {
        if (!model)
        {
            model = [[UniformCashAccountModel alloc] init];
        }
    }
    
    return model;
}


- (void)beginForType:(UniformFromType)type TotalPrice:(CGFloat)totalPrice Password:(NSString *)pwd
{
    self.orderTotal = totalPrice;
    self.payType = type;
    
    appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (STRINGHASVALUE(pwd))
    {
        // 如果有CA密码，先进行密码校验
        [self checkCAPassword:pwd];
    }
    else
    {
        // 没有密码直接提交订单
        [self dealOrderByType:type];
    }
}


- (id)init
{
    if (self = [super init])
    {
        dataModel = [UniformCounterDataModel shared];
    }
    
    return self;
}

#pragma mark - Model Methods
// 发起校验CA密码的请求
- (void)checkCAPassword:(NSString *)pwd
{
    netType = kNetTypeCheckPassword;
    
    [Utils request:GIFTCARD_SEARCH req:[CashAccountReq verifyCashAccountPwdWithPwd:pwd] delegate:self];
}


// 分别处理各个流程的CA支付
- (void)dealOrderByType:(UniformFromType)type
{
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


- (void)dealNativeHotel
{
    netType = kNetTypeNativeHotel;
    
    NSArray *rooms = [[HotelDetailController hoteldetail] safeObjectForKey:ROOMS];
    if (ARRAYHASVALUE(rooms))
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
        
        if (UMENG)
        {
            //礼品卡支付
            [MobClick event:Event_CAOrderSubmit];
        }
    }
    else
    {
        [PublicMethods showAlertTitle:@"订单信息有误" Message:nil];
    }
}


- (void)dealInterHotel
{
    JInterHotelOrder *interOder = [InterHotelPostManager interHotelOrder];
    //设置CashAmount,余额足够直接支付
    [interOder setCashAmount:orderTotal];
    InterHotelConfirmCtrl *interConfirmCtrl = [[InterHotelConfirmCtrl alloc] init];
    [appDelegate.navigationController pushViewController:interConfirmCtrl animated:YES];
}


- (void)dealFlight
{
    // 余额足够，直接支付
    [[FlightPostManager flightOrder] setCashAmount:orderTotal];
    
    flightConfirmVC = [[FlightOrderConfirm alloc] init:@"订单确认" style:_NavNormalBtnStyle_ card:nil];
    [flightConfirmVC nextState:UniformPaymentTypeCreditCard];
    
}


- (void)dealGroupon
{
    netType = kNetTypeGroupon;
    
//    GrouponSharedInfo *gSharedInfo = [GrouponSharedInfo shared];
//    
//    // 信用卡支付
//    gSharedInfo.payType = 0;
//
//    gSharedInfo.cashAmount = [NSNumber numberWithDouble:orderTotal];
//    
//    grouponConfirmVC = [[GrouponConfirmViewController alloc] initWithCardInfo:nil];
//    [grouponConfirmVC nextState];
    
    // 余额足够，直接支付
    dataModel.waitingPayMoney = dataModel.caAmount;
    
    NSMutableDictionary *mutDict = [dataModel getUniformPayData:UniformFromTypeGroupon];
    if(DICTIONARYHASVALUE(mutDict))
    {
        // 如果使用CA支付，加入CA支付信息
        NSString *url = [HttpUtil javaAPIPostReqInDomain:API_DOMAIN_myelong_Pay atFunction:API_FUNCTION_pay];
        [HttpUtil requestURL:url postContent:[mutDict JSONString] delegate:self];
    }
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
        case kNetTypeCheckPassword:
        {
            if ([[root safeObjectForKey:IS_SUCCESS] safeBoolValue] == YES)
            {
                // 校验密码成功
                [self dealOrderByType:payType];
            }
            else
            {
                // 发送验密成功失败
                [PublicMethods showAlertTitle:@"密码错误" Message:@"请检查"];
            }
        }
            break;
        case kNetTypeNativeHotel:
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
            [appDelegate.navigationController pushViewController:hotelordersuccess animated:YES];
        }
            break;
        case kNetTypeGroupon:
        {
            // 进入成功页面
            GrouponSuccessController *controller = [[GrouponSuccessController alloc] initWithOrderID:[dataModel.orderID intValue] payType:GrouponOrderPayTypeCreditCard];
            [appDelegate.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
