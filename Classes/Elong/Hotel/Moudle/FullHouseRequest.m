//
//  FullHouseRequest.m
//  ElongClient
//
//  Created by nieyun on 14-6-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FullHouseRequest.h"
#import "AccountManager.h"

@implementation FullHouseRequest
- (void)dealloc
{
    [[NSNotificationCenter  defaultCenter]removeObserver:self name:@"refreshOrderList" object:nil];
    [order  release];
   
    if (agreeArrageUtil ) {
        [agreeArrageUtil  cancel];
        SFRelease(agreeArrageUtil);
    }
    if (feedbackUtil) {
        [feedbackUtil  cancel];
        SFRelease(feedbackUtil);
    }
     [super dealloc];
}
- (id)initWithOrder:(NSDictionary *)dic
{
    
    if (self = [super init])
    {
        
        order = [[NSDictionary  alloc]initWithDictionary:dic];
        _orderDetailRequest = [[HotelOrderDetailRequest alloc] initWithDelegate:self];

    
    }
    return self;
}
- (void)requestAgreeHouse
{
    if (agreeArrageUtil) {
        [agreeArrageUtil  cancel];
        SFRelease(agreeArrageUtil);
    }
    NSDictionary   *dic = [NSDictionary  dictionaryWithObjectsAndKeys:[order objectForKey:@"OrderNo"],@"OrderNo",[[AccountManager instanse] cardNo],@"CardNo",[[AccountManager  instanse] password],@"Pwd",nil];
    NSString  *jsonStr = [dic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"myelong" forService:@"fullHouseAgreeArrange"];

    agreeArrageUtil = [[HttpUtil alloc]init];
    [agreeArrageUtil  requestWithURLString:url Content:jsonStr Delegate:self];
    
}

- (void)requestFeedBack:(NSString *)message
{
    
    NSDictionary  *dic = [NSDictionary  dictionaryWithObjectsAndKeys:[order objectForKey:@"OrderNo"],@"OrderNo",message,@"Feedback",[[AccountManager  instanse] cardNo],@"CardNo",[[AccountManager  instanse]password],@"Pwd",nil];
    if (feedbackUtil) {
        [feedbackUtil  cancel];
        SFRelease(feedbackUtil);
       
    }
    feedbackUtil = [[HttpUtil  alloc]init];
    NSString  *jsonStr = [dic  JSONString];
    NSString  *url = [PublicMethods  composeNetSearchUrl:@"myelong" forService:@"fullHouseFeedback"];
    [feedbackUtil  requestWithURLString:url Content:jsonStr Delegate:self];
    
}
- (void)requestCancelOrder
{    
    [_orderDetailRequest startRequestWithCancelOrder:order];
}

- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary  *root = [PublicMethods  unCompressData:responseData];
    if ([Utils  checkJsonIsError:root]) {
        return;
    }
    if (util == agreeArrageUtil) {
        if ([self.fullDelegate  respondsToSelector:@selector(getFullAgreeState:)])
        {
            [self.fullDelegate  getFullAgreeState:root];
        }
    }
    else if (util  == feedbackUtil)
    {
        if ([self.fullDelegate respondsToSelector:@selector(finishFeedBack:)]) {
            [self.fullDelegate  finishFeedBack:root];
        }
    }
}


-(void)executeCancelOrderResult:(NSDictionary *)result
{
   
    if ([self.fullDelegate  respondsToSelector:@selector(finishCancel:)]) {
        [self.fullDelegate  finishCancel:result];
    }
}
@end
