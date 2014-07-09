//
//  FullHouseRequest.h
//  ElongClient
//
//  Created by nieyun on 14-6-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HotelOrderDetailRequest.h"
@protocol FullHouseDelegate <NSObject>
@optional
-(void) getFullAgreeState:(NSDictionary *)result;
- (void)finishFeedBack:(NSDictionary *)result;
- (void) finishCancel:(NSDictionary  *)result;
@end
@interface FullHouseRequest : NSObject<HttpUtilDelegate,HotelOrderDetailRequestDelegate>
{
    HttpUtil  *agreeArrageUtil;
    HttpUtil  *feedbackUtil;
    NSDictionary  *order;
     HotelOrderDetailRequest *_orderDetailRequest;
}
- (id ) initWithOrder:(NSDictionary  *)dic;
- (void)requestAgreeHouse;
- (void)requestFeedBack:(NSString *)message;
- (void)requestCancelOrder;
@property (nonatomic,assign)  id<FullHouseDelegate> fullDelegate;
@end

