//
//  TrainOrderSuccessVC.h
//  ElongClient
//  火车票订单成功页
//
//  Created by Zhao Haibo on 13-11-26.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositioningManager.h"
#import "HomeAdNavi.h"

typedef enum viewStatus : NSUInteger
{
    eStatusBookSuccess = 1,
    eStatusPaySuccess,
} OrderSuccessVCStatus;

@class FXLabel;
@interface TrainOrderSuccessVC : DPNav <UITableViewDataSource, UITableViewDelegate,PositioningManagerDelegate,UIAlertViewDelegate>
{
@private
//    UIButton *payButton;
    UITableView *table;         // 展示提示信息
    
    BOOL jumpToSafari;          // 判断是否跳转到safari完成支付流程
    BOOL paySuccess;            // 标志是否支付成功
    
    OrderSuccessVCStatus viewStatus; // 页面状态
    
    UIAlertView *backAlert;     // 提示用户可以到myelong里继续支付
    UIAlertView *askingAlert;   // 询问用户是否支付完成
    HttpUtil *payAddressRequest;          //支付连接请求
}


@property (nonatomic, strong) HttpUtil *getPayStateUtil;
@property (nonatomic, assign) BOOL isPayStateLoading;
@property (nonatomic,assign) BOOL isStudent;
// 跳转链接
@property (nonatomic, strong) HomeAdNavi *homeAdNavi;
@property (nonatomic, assign) BOOL isPushHotel;


- (id)initWithOrderInfo:(NSDictionary *)order isStudent:(BOOL)stu;  // 使用订单信息初始化

@end
