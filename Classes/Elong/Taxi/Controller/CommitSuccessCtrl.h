//
//  CommitSuccessCtrl.h
//  ElongClient
//
//  Created by nieyun on 14-2-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "DPNav.h"
#import "TaxiDetaileModel.h"
#import "TaxiOrderManager.h"
#define CommitTip  @"若预约成功,司机的联系方式最晚于出发前24小时以短信方式发送至您的手机。"

@interface CommitSuccessCtrl : ElongBaseViewController <HttpUtilDelegate>

@property (retain, nonatomic) IBOutlet UILabel *callName;
@property (retain, nonatomic) IBOutlet UILabel *orderNum;
//@property (retain,nonatomic) TaxiDetaileModel  *detaileModel;
@property(nonatomic,copy) NSString *orderID;
@property (nonatomic,assign) TaxiReserveType reserveType;

@property (retain, nonatomic) IBOutlet UILabel *tipLabel;
@end
