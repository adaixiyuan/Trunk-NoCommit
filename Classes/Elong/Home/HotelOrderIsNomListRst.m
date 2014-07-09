//
//  HotelOrderIsNomListRst.m
//  ElongClient
//
//  Created by nieyun on 14-6-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderIsNomListRst.h"
#import "NHotelOrderReq.h"
#import "ElongURL.h"
@implementation HotelOrderIsNomListRst
- (void)startRequestIsNoNomListWithDelegate:(id<HotelOrderIsNomListDelegate>)delegate
{
    [self  readList];
    mdelegate  = delegate;
}

- (void)readList
{
    NSData *orderData = [[NSUserDefaults standardUserDefaults] objectForKey:NONMEMBER_HOTEL_ORDERS];
    self.localOrderArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:orderData]];
    
    if ([_localOrderArray count] > 0)
    {
        // 有预订过酒店
        NSMutableArray *idArray = [NSMutableArray arrayWithCapacity:2];
        for (NSDictionary *dic in _localOrderArray)
        {
            [idArray addObject:[dic   safeObjectForKey:ORDERNO_REQ]];
        }
        
        NHotelOrderReq *orderReq = [NHotelOrderReq shared];
        [orderReq setOrderState:NOrderStateHotel];
        [Utils request:PUSH_SEARCH req:[orderReq requestOrderStateWithOrders:idArray] delegate:self];
    }

}
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@", root);
	
	if ([Utils checkJsonIsError:root])
    {
		return ;
	}
	
    for (NSDictionary *stateDic in [root safeObjectForKey:ORDERSTATUSINFOS]) {
        for (NSMutableDictionary *savedOrder in _localOrderArray) {
            NSString *orderID_net = [NSString stringWithFormat:@"%@", [stateDic safeObjectForKey:ORDERID_GROUPON]];
            NSString *orderID_local = [NSString stringWithFormat:@"%@", [savedOrder safeObjectForKey:ORDERNO_REQ]];
            
            if ([orderID_net isEqualToString:orderID_local]) {
                NSNumber *ordderState = [stateDic safeObjectForKey:HOTEL_STATE_CODE];
                if (ordderState) {
                    // 获取酒店订单状态
                    [savedOrder safeSetObject:ordderState forKey:STATE_CODE];
                }
                
                //新的订单状态
                NSString *clientStatusDesc = [stateDic safeObjectForKey:@"HotelOrderClientStatusDesc"];
                if(STRINGHASVALUE(clientStatusDesc)){
                    [savedOrder safeSetObject:clientStatusDesc forKey:CLIENTSTATUSDESC];
                }
                
                NSString *hotelName = [stateDic safeObjectForKey:HOTEL_STATE_NAME];
                if (hotelName && STRINGHASVALUE(hotelName)) {
                    // 获取酒店名
                    [savedOrder safeSetObject:hotelName forKey:STATENAME];
                }
                
                
                NSString *cityName = [stateDic safeObjectForKey:CITYNAME_GROUPON];
                if (cityName && STRINGHASVALUE(cityName)) {
                    // 获取酒店所在城市
                    [savedOrder safeSetObject:cityName forKey:CITYNAME_GROUPON];
                }
                
                NSString *creatTime = [stateDic safeObjectForKey:HOTEL_ORDER_CREATE_TIME];
                if (creatTime && STRINGHASVALUE(creatTime)) {
                    // 获取订单创建时间
                    [savedOrder safeSetObject:creatTime forKey:CREATETIME];
                }
            }
        }
    }
    if ([mdelegate  respondsToSelector:@selector(exceluteGetIsNoNomResult:)]) {
        [mdelegate  exceluteGetIsNoNomResult:_localOrderArray];

    }
   }
@end
