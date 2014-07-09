//
//  HotelOrderDetailRequest.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderDetailRequest.h"
#import "OrderHistoryPostManager.h"
#import "ElongURL.h"
#import "AccountManager.h"
#import "TokenReq.h"
#import "HotelPromotionInfoRequest.h"

@implementation HotelOrderDetailRequest

- (void)dealloc
{
    
    [_checkFeedbackUtil cancel];
    [_cancelOrderUtil cancel];
    [_editOrderUtil cancel];
    [_feedbackUtil cancel];
    [_alipayWebUtil cancel];
    [_alipayClientUtil cancel];
    [_weixinPayUtil cancel];
    [_bookingAgainUtil cancel];
    [_passbookUtil cancel];
    [_orderFlowUtil cancel];
    
    [_checkFeedbackUtil release];
    [_cancelOrderUtil release];
    [_editOrderUtil release];
    [_feedbackUtil release];
    
    [_alipayWebUtil release];
    [_alipayClientUtil release];
    [_weixinPayUtil release];
    
    [_bookingAgainUtil release];
    [_passbookUtil release];
    
    [_orderFlowUtil release];
    [super dealloc];
}

-(id)initWithDelegate:(id<HotelOrderDetailRequestDelegate>)aDelegate{
    self = [super init];
    if(self){
        _checkFeedbackUtil = [[HttpUtil alloc] init];
        _cancelOrderUtil = [[HttpUtil alloc] init];
        _editOrderUtil = [[HttpUtil alloc] init];
        _feedbackUtil = [[HttpUtil alloc] init];
        _alipayClientUtil = [[HttpUtil alloc] init];
        _alipayWebUtil = [[HttpUtil alloc] init];
        _weixinPayUtil = [[HttpUtil alloc] init];
        _bookingAgainUtil = [[HttpUtil alloc] init];
        _passbookUtil = [[HttpUtil alloc] init];
        _orderFlowUtil = [[HttpUtil alloc] init];
        _delegate = aDelegate;
    }
    return self;
}

//检查是否可以反馈
-(void)startRequestWithCheckCanBeFeedback:(NSDictionary *)anOrder{
    // 开着monkey时不发生事件
    if ([[ServiceConfig share] monkeySwitch])
        return;
    
    long long cardNo = 0;
    if ([[AccountManager instanse] isLogin]){
        cardNo = [[[AccountManager instanse] cardNo] longLongValue];
    }
    
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLongLong:cardNo],@"CardNo",[NSArray arrayWithObjects:orderNO, nil],@"orderNos", nil];
    NSString *reqContent = [reqDictInfo JSONString];
    
    // 发起请求
    [_checkFeedbackUtil requestWithURLString:[PublicMethods composeNetSearchUrl:@"myelong" forService:@"getFeedbackStatusList"] Content:reqContent StartLoading:NO EndLoading:NO Delegate:self];
}

  //取消订单
-(void)startRequestWithCancelOrder:(NSDictionary *)anOrder{
    if (UMENG) {
        //酒店订单详情页面点击取消
        [MobClick event:Event_OrderDetail_Cancel];
    }
    UMENG_EVENT(UEvent_UserCenter_InnerOrder_Cancel)
    
    //取消订单
    JCancelHotelOrder *cancelHotelOrder = [OrderHistoryPostManager cancelhotelorder];
    [cancelHotelOrder clearBuildData];
    [cancelHotelOrder setOrderNo:[anOrder safeObjectForKey:@"OrderNo"]];
    
    [_cancelOrderUtil connectWithURLString:MYELONG_SEARCH Content:[cancelHotelOrder requesString:YES] Delegate:self];
}

//修改订单请求
-(void)startRequestWithEditOrder{
    [_editOrderUtil connectWithURLString:OTHER_SEARCH Content:[TokenReq getAppConfigWithAppKey:@"iphone_editorderurl"] Delegate:self];
}

//入住反馈
-(void)startRequestWithFeedback{
    [_feedbackUtil connectWithURLString:OTHER_SEARCH Content:[TokenReq getAppConfigWithAppKey:@"iphone_checkinfeedbackurl"] Delegate:self];
}

//微信支付
-(void)startAgainPayRequestByWeixin:(NSDictionary *)anOrder{
    // 微信客户端
    if(![WXApi isWXAppInstalled]){
        [PublicMethods showAlertTitle:nil Message:@"未发现微信客户端，请您更换别的支付方式或下载微信"];
        return;
    }
    if (![WXApi isWXAppSupportApi]) {
        [PublicMethods showAlertTitle:nil Message:@"您微信客户端版本过低，请您更换别的支付方式或更新微信"];
        return;
    }
    NSString *orderNo = [anOrder safeObjectForKey:@"OrderNo"];
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
    [mutDict safeSetObject:orderNo forKey:@"OrderId"];
    [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"MemberId"];
    [mutDict safeSetObject:[NSNumber numberWithInt:4] forKey:@"PaymentMethodType"];
    
    NSString *reqParam = [NSString stringWithFormat:@"action=ChangePaymentMethod&version=1.2&compress=true&req=%@", [mutDict JSONRepresentationWithURLEncoding]];
    [mutDict release];

    [_weixinPayUtil connectWithURLString:HOTELSEARCH Content:reqParam Delegate:self];
}

//支付宝客户端支付
-(void)startAgainPayRequestByAlipayClient:(NSDictionary *)anOrder{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]){
        NSString *orderNo = [anOrder safeObjectForKey:@"OrderNo"];
        
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
        [mutDict safeSetObject:orderNo forKey:@"OrderId"];
        [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"MemberId"];
        [mutDict safeSetObject:[NSNumber numberWithInt:1] forKey:@"PaymentMethodType"];

        NSString *reqParam = [NSString stringWithFormat:@"action=ChangePaymentMethod&version=1.2&compress=true&req=%@", [mutDict JSONRepresentationWithURLEncoding]];
        [mutDict release];
        
        [_alipayClientUtil connectWithURLString:HOTELSEARCH Content:reqParam Delegate:self];
    }else{
        [PublicMethods showAlertTitle:nil Message:@"未发现支付宝客户端，请您更换别的支付方式或下载支付宝"];
        return;
    }

}

//支付宝网页支付
-(void)startAgainPayRequestByAlipayWeb:(NSDictionary *)anOrder{
    NSString *orderNo = [anOrder safeObjectForKey:@"OrderNo"];
    
    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
    [mutDict safeSetObject:[PostHeader header] forKey:Resq_Header];
    [mutDict safeSetObject:orderNo forKey:@"OrderId"];
    [mutDict safeSetObject:[[AccountManager instanse] cardNo] forKey:@"MemberId"];
    [mutDict safeSetObject:[NSNumber numberWithInt:0] forKey:@"PaymentMethodType"];

    NSString *reqParam = [NSString stringWithFormat:@"action=ChangePaymentMethod&version=1.2&compress=true&req=%@", [mutDict JSONRepresentationWithURLEncoding]];
    [mutDict release];
    
    [_alipayWebUtil connectWithURLString:HOTELSEARCH Content:reqParam Delegate:self];
}

//再次预订
-(void)startRequestWithBookingAgain:(NSDictionary *)anOrder{
    // 查询的酒店详情
    NSString *hotelId = [anOrder safeObjectForKey:@"HotelId"];
    // 获取入离店日期
    NSString *checkinDate = [TimeUtils displayDateWithNSTimeInterval:[[NSDate date] timeIntervalSince1970] formatter:@"yyyy-MM-dd"];
    NSString *checkoutDate = [TimeUtils displayDateWithNSTimeInterval:([[NSDate date] timeIntervalSince1970]+24*60*60) formatter:@"yyyy-MM-dd"];

    JHotelDetail *hoteldetail = [HotelPostManager hoteldetailer];
	[hoteldetail clearBuildData];
	[hoteldetail setHotelId:hotelId];
	[hoteldetail setCheckDate:checkinDate checkoutdate:checkoutDate];

    [_bookingAgainUtil sendSynchronousRequest:HOTELSEARCH PostContent:[hoteldetail requesString:YES] CachePolicy:CachePolicyHotelDetail Delegate:self];
    
    HotelPromotionInfoRequest *promotionInfoRequest = [HotelPromotionInfoRequest sharedInstance];
    promotionInfoRequest.checkinDate = checkinDate;
    promotionInfoRequest.checkoutDate = checkoutDate;
}

//增加订单到Passbook
-(void)startRequestWIthAddOrderToPassbook:(NSDictionary *)anOrder
{
    // 组织Json
	NSMutableDictionary *dicJson = [[NSMutableDictionary alloc] init];
    
    //===========
    //PKPASS DIC
    //===========
    NSMutableDictionary *dicPKPass = [[NSMutableDictionary alloc] init];
    
    NSString *orderNoText = @"";
    NSNumber *orderNoObj = [anOrder safeObjectForKey:@"OrderNo"];
    if (orderNoObj != nil)
    {
        orderNoText = [NSString stringWithFormat:@"%d",[orderNoObj intValue]];
        [dicPKPass safeSetObject:orderNoText forKey:@"serialNumber"];
    }
    NSString *arriveDate =  [TimeUtils displayDateWithJsonDate:[anOrder safeObjectForKey:@"ArriveDate"] formatter:@"yyyy-MM-dd"];
    if (!STRINGHASVALUE(arriveDate))
    {
        arriveDate = @"2015-05-07T10:30-05:00";
    }
    [dicPKPass safeSetObject:arriveDate forKey:@"relevantDate"];
    
    // 经纬度位置
    NSMutableArray *arrayLonLatJson = [[NSMutableArray alloc] init];
    for (int i=0; i<1; i++)
    {
        NSMutableDictionary *dicLonLatJson = [[NSMutableDictionary alloc] init];
        
        [dicLonLatJson setObject:@"39.898895" forKey:@"latitude"];
        [dicLonLatJson setObject:@"116.425587" forKey:@"longitude"];
        
        // 添加
        [arrayLonLatJson addObject:dicLonLatJson];
        [dicLonLatJson release];
    }
    [dicPKPass setObject:arrayLonLatJson forKey:@"locations"];
    [arrayLonLatJson release];
    
    // logo 名
    NSString *hotelName = [anOrder safeObjectForKey:@"HotelName"];
    if (STRINGHASVALUE(hotelName))
    {
        [dicPKPass setObject:hotelName forKey:@"logoText"];
    }
    
    //===========
    //====PKGeneric 结构
    //===========
    NSMutableDictionary *dicPKGeneric = [[NSMutableDictionary alloc] init];
    
    // header信息
    NSMutableArray *arrayHeader = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc] init];
    if (STRINGHASVALUE(orderNoText))
    {
        [dicHeader setObject:@"orderNo" forKey:@"key"];
        [dicHeader setObject:orderNoText forKey:@"value"];
        [dicHeader setObject:@"订单号" forKey:@"label"];
    }
    [arrayHeader addObject:dicHeader];
    [dicHeader release];
    
    // Save
    [dicPKGeneric setObject:arrayHeader forKey:@"headerFields"];
    [arrayHeader release];
    
    //=====primaryField
    NSMutableArray *arrayPrimary = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicPrimary = [[NSMutableDictionary alloc] init];
    
    NSString *orderPriceText = @"";
    NSNumber *orderPriceObj = [anOrder safeObjectForKey:@"SumPrice"];
    if (orderPriceObj != nil)
    {
        orderPriceText = [NSString stringWithFormat:@"%f",[orderPriceObj floatValue]];
        
        [dicPrimary setObject:@"price" forKey:@"key"];
        [dicPrimary setObject:orderPriceText forKey:@"value"];
        [dicPrimary setObject:@"CNY" forKey:@"currencyCode"];
    }
    
    [arrayPrimary addObject:dicPrimary];
    [dicPrimary release];
    
    // Save
    [dicPKGeneric setObject:arrayPrimary forKey:@"primaryFields"];
    [arrayPrimary release];
    
    //=====secondaryField
    NSMutableArray *arraySecondary = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicSecondaryField01 = [[NSMutableDictionary alloc] init];
    
    NSMutableString *guestName = [NSMutableString stringWithFormat:@""];
    id value = [anOrder safeObjectForKey:@"GuestName"];        //入住人
    if([value isKindOfClass:[NSString class]]){
        guestName = STRINGHASVALUE(value)?value:@"--";
    }else if([value isKindOfClass:[NSArray class]]){
        int count = 0;
        for (NSString *s in value)
        {
            [guestName appendFormat:@"%@ ",s];
            count++;
            if (count>=4) {
                [guestName appendFormat:@"%@",@"\n"];
                count=0;
            }
        }
    }
    if (STRINGHASVALUE(guestName))
    {
        [dicSecondaryField01 setObject:@"customer" forKey:@"key"];
        [dicSecondaryField01 setObject:guestName forKey:@"value"];
        [dicSecondaryField01 setObject:@"入住人" forKey:@"label"];
    }
    [arraySecondary addObject:dicSecondaryField01];
    [dicSecondaryField01 release];
    
    NSMutableDictionary *dicSecondaryField02 = [[NSMutableDictionary alloc] init];
    
    NSString *roomTypeName = [anOrder safeObjectForKey:@"RoomTypeName"];
    if (STRINGHASVALUE(roomTypeName))
    {
        [dicSecondaryField02 setObject:@"romeType" forKey:@"key"];
        [dicSecondaryField02 setObject:roomTypeName forKey:@"value"];
        [dicSecondaryField02 setObject:@"房型" forKey:@"label"];
    }
    [arraySecondary addObject:dicSecondaryField02];
    [dicSecondaryField02 release];
    
    // Save
    [dicPKGeneric setObject:arraySecondary forKey:@"secondaryFields"];
    [arraySecondary release];
    
    
    //=====auxiliaryField
    NSMutableArray *arrayAuxiliary = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicAuxiliaryField01 = [[NSMutableDictionary alloc] init];
    if (STRINGHASVALUE(arriveDate))
    {
        [dicAuxiliaryField01 setObject:@"checkIn" forKey:@"key"];
        [dicAuxiliaryField01 setObject:arriveDate forKey:@"value"];
        [dicAuxiliaryField01 setObject:@"入住日期" forKey:@"label"];
    }
    [arrayAuxiliary addObject:dicAuxiliaryField01];
    [dicAuxiliaryField01 release];
    
    NSMutableDictionary *dicAuxiliaryField02 = [[NSMutableDictionary alloc] init];
    NSString *departDate = [TimeUtils displayDateWithJsonDate:[anOrder safeObjectForKey:@"LeaveDate"] formatter:@"yyyy-MM-dd"];
    if (STRINGHASVALUE(departDate))
    {
        [dicAuxiliaryField02 setObject:@"checkOut" forKey:@"key"];
        [dicAuxiliaryField02 setObject:departDate forKey:@"value"];
        [dicAuxiliaryField02 setObject:@"离店日期" forKey:@"label"];
    }
    [arrayAuxiliary addObject:dicAuxiliaryField02];
    [dicAuxiliaryField02 release];
    
    NSMutableDictionary *dicAuxiliaryField03 = [[NSMutableDictionary alloc] init];
    
    // 计算时间间隔
    if (STRINGHASVALUE(arriveDate) && STRINGHASVALUE(departDate))
    {
        NSDate *arriveDateObj = [NSDate dateFromString:arriveDate withFormat:@"yyyy-MM-dd"];
        NSDate *departDateObj = [NSDate dateFromString:departDate withFormat:@"yyyy-MM-dd"];
        NSInteger dayCount = [departDateObj timeIntervalSinceDate:arriveDateObj]/(24*60*60);
        
        [dicAuxiliaryField03 setObject:@"days" forKey:@"key"];
        [dicAuxiliaryField03 setObject:[NSString stringWithFormat:@"%d",dayCount] forKey:@"value"];
        [dicAuxiliaryField03 setObject:@"入住天数" forKey:@"label"];
    }
    [arrayAuxiliary addObject:dicAuxiliaryField03];
    [dicAuxiliaryField03 release];
    
    // Save
    [dicPKGeneric setObject:arrayAuxiliary forKey:@"auxiliaryFields"];
    [arrayAuxiliary release];
    
    
    //=====backField
    NSMutableArray *arrayBack = [[NSMutableArray alloc] init];
    
    // 添加内容
    NSMutableDictionary *dicBackField01 = [[NSMutableDictionary alloc] init];
    if (STRINGHASVALUE(roomTypeName))
    {
        [dicBackField01 setObject:@"romeInfo" forKey:@"key"];
        [dicBackField01 setObject:roomTypeName forKey:@"value"];
        [dicBackField01 setObject:@"房间信息" forKey:@"label"];
    }
    [arrayBack addObject:dicBackField01];
    [dicBackField01 release];
    
    NSMutableDictionary *dicBackField02 = [[NSMutableDictionary alloc] init];
    
    NSString *hotelAddress = STRINGHASVALUE([anOrder safeObjectForKey:@"HotelAddress"])?[anOrder safeObjectForKey:@"HotelAddress"]:@"--";
    if (STRINGHASVALUE(hotelAddress))
    {
        [dicBackField02 setObject:@"hotelInfo" forKey:@"key"];
        [dicBackField02 setObject:hotelAddress forKey:@"value"];
        [dicBackField02 setObject:@"酒店地址" forKey:@"label"];
    }
    [arrayBack addObject:dicBackField02];
    [dicBackField02 release];
    
    NSMutableDictionary *dicBackField03 = [[NSMutableDictionary alloc] init];
    
    NSString *telephone = @"400-666-1166";
    if (STRINGHASVALUE(telephone))
    {
        [dicBackField03 setObject:@"telInfo" forKey:@"key"];
        [dicBackField03 setObject:telephone forKey:@"value"];
        [dicBackField03 setObject:@"艺龙客服电话" forKey:@"label"];
    }
    [arrayBack addObject:dicBackField03];
    [dicBackField03 release];
    
    // Save
    [dicPKGeneric setObject:arrayBack forKey:@"backFields"];
    [arrayBack release];
    
    // 保存generic
    [dicPKPass safeSetObject:dicPKGeneric forKey:@"generic"];
    [dicPKGeneric release];
    
    // 保存PKPass
    [dicJson safeSetObject:dicPKPass forKey:@"PKPass"];
    [dicPKPass release];
    
    // 请求参数
    NSString *paramJson = [dicJson JSONString];
    [dicJson release];
    
    NSString *passContent = [NSString stringWithFormat:@"req=%@",paramJson];
    
    [_passbookUtil connectWithURLString:PASSBOOKURL Content:passContent Delegate:self];
}

//获取订单流程状态
-(void)startRequestWithGetOrderFlowState:(NSDictionary *)anOrder{
    NSString *orderNO  = [NSString stringWithFormat:@"%.f",[[anOrder safeObjectForKey:@"OrderNo"] doubleValue]];
    NSDictionary *reqDictInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:orderNO, nil],@"OrderNos", nil];
    NSString *reqContent = [reqDictInfo JSONString];
    
    // 发起请求
    NSString *url = [PublicMethods composeNetSearchUrl:@"myelong" forService:@"getOrderVisualFlow" andParam:reqContent];
    [_orderFlowUtil requestWithURLString:url Content:nil StartLoading:NO EndLoading:NO Delegate:self];
}



#pragma mark - httpUtil Delegate
-(void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    if(util==_checkFeedbackUtil){
        //判断网络数据的正确性
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return ;
        }
        //入住反馈
        if([_delegate respondsToSelector:@selector(executeCheckFeedbackResult:)]){
            [_delegate executeCheckFeedbackResult:root];
        }
    }else if(util==_orderFlowUtil){
        //判断网络数据的正确性
        if ([Utils checkJsonIsErrorNoAlert:root]) {
            return ;
        }
        //查看订单流程状态
        if([_delegate respondsToSelector:@selector(executeGetOrderFlowState:)]){
            [_delegate executeGetOrderFlowState:root];
        }
    }
    else if(util == _passbookUtil){
        if (!responseData) {
            [PublicMethods showAlertTitle:@"Pass文件生成失败" Message:nil];
            return;
        }
        //增加Passbook 请求
        if([_delegate respondsToSelector:@selector(executeAddPassbookResultData:)]){
            [_delegate executeAddPassbookResultData:responseData];
        }
    }else{
        if([Utils checkJsonIsError:root]){
            return;
        }
        
        if(util==_cancelOrderUtil){
            //取消订单
            if([_delegate respondsToSelector:@selector(executeCancelOrderResult:)]){
                [_delegate executeCancelOrderResult:root];
            }
        }else if(util == _feedbackUtil){
            //入住反馈
            if([_delegate respondsToSelector:@selector(executeFeedbackResult:)]){
                [_delegate executeFeedbackResult:root];
            }
        }else if(util == _editOrderUtil){
            //修改订单
            if([_delegate respondsToSelector:@selector(executeEditOrderResult:)]){
                [_delegate executeEditOrderResult:root];
            }
        }else if(util == _weixinPayUtil){
            //微信支付
            if([_delegate respondsToSelector:@selector(executeAgainPayByWeixinResult:)]){
                [_delegate executeAgainPayByWeixinResult:root];
            }
        }else if(util == _alipayClientUtil){
            //修改订单
            if([_delegate respondsToSelector:@selector(executeAgainPayByAlipayClientResult:)]){
                [_delegate executeAgainPayByAlipayClientResult:root];
            }
        }else if(util == _alipayWebUtil){
            //修改订单
            if([_delegate respondsToSelector:@selector(executeAgainPayByAlipayWebResult:)]){
                [_delegate executeAgainPayByAlipayWebResult:root];
            }
        }else if(util==_bookingAgainUtil){
            //再次预订
            if([_delegate respondsToSelector:@selector(executeBookingAgainResult:)]){
                [_delegate executeBookingAgainResult:root];
            }
        }
    }

    
}


@end
