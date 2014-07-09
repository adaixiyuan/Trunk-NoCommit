//
//  TrainFillOrderVC.h
//  ElongClient
//  火车票订单填写页
//
//  Created by 赵 海波 on 13-11-6.
//  Copyright (c) 2013年 elong. All rights reserved.
//
//  －修改底部banner条样式  by：赵海波（2014.03.12）

#import <UIKit/UIKit.h>
#import "CommonSelectView.h"
#import "PassengerListVC.h"
#import "TrainIdentifyiCodeView.h"
#import "TrainCommitOrderAppendData.h"
#import "TrainIdenfyCodeModel.h"

@class TrainTickets, TrainSeats;
@interface TrainFillOrderVC : DPNav <UITableViewDataSource, UITableViewDelegate, CustomABDelegate, UITextFieldDelegate, CommonSelectViewDelegate, PassengerDelegate, AddOrEditPassengerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
@private
    UITableView *passagerList;          // 乘客列表
    UIView *viewResponder;
    
    BOOL reqListOver;                   // 预加载乘客是否结束
    NSInteger passagerCount;            // 乘客数
    NSInteger currentPassagerIndex;     // 当前选中的乘客
    NSMutableArray *passengersArray;    // 纪录乘客信息
    
    TrainTickets *ticket;               // 火车票数据
    TrainSeats *seat;                   // 当前选择的座席
    HttpUtil *getCustomerListUtil;      // 预加载乘客列表信息
//    CommonSelectView *ticketNumSelectView;       // 票数选择器
    UIView *viewFoot;               //tablefootview
    
    TrainIdentifyiCodeView *identifyCodeView;  //验证码模块
    HttpUtil *identifyCodeRequest;          //验证码请求
}

@property (nonatomic, assign) BOOL isSkipLogin;     // 标记返回时是否跳过login页面

+ (NSString *)getCertTypeNameByTypeEnum:(NSString *)enumName;

@end
