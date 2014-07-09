//
//  PassengerListVC.h
//  ElongClient
//  火车票/机票乘客列表页面（会员）
//
//  Created by Zhao Haibo on 13-11-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//
//  －修改底部banner条样式  by：赵海波（2014.03.12）

#import <UIKit/UIKit.h>
#import "AddOrEditPassengerVC.h"
#import "AttributedLabel.h"
#import "PassengerCell.h"

#define k_checked_key   @"Checked"          // 标记是否被选中
#define k_new_key       @"New"              // 标记是否是新增乘客
#define IDCARD          @"IDCard"           // 证件类型－身份证
#define GANGAO          @"GangAoPassport"   // 证件类型－港澳通行证
#define TAIWAN          @"TaiWaiPassport"   // 证件类型－台湾通行证(暂时不支持)
#define PASSPORT        @"Passport"         // 证件类型－护照

@protocol PassengerDelegate;

@interface PassengerListVC : DPNav <UITableViewDataSource, UITableViewDelegate, AddOrEditPassengerDelegate, PassengerCellDelegate>
{
    SmallLoadingView *smallLoading;
    HttpUtil *getCustomerListUtil;      // 获取乘客信息
    
    UITableView *passengerList;  // 乘客列表
    UIView *m_tipView;
    
    NSInteger ticketCount;       // 票数统计
    BOOL needReloadList;         // 是否在本页需要重新加载乘客列表
    PassengerType passageType;
    AttributedLabel *passengerNumberLabel;      // 显示选择了多少乘客
}

@property (nonatomic, assign) id<PassengerDelegate> delegate;

+ (NSMutableArray *)allPassengers;      // 获取会员所有乘客的列表

- (id)initWithTicketCount:(NSInteger)count reqPassengerListOver:(BOOL)reqOver passengerType:(PassengerType)type;         // 使用票数、是否需要请求乘客列表、类型来初始化
- (void)scrollToDisplayByCertType:(NSString *)certType CertNumber:(NSString *)certNumber;    // 初始显示点击的证件

@end


@protocol PassengerDelegate<NSObject>

@required
- (void)selectedPassengersArray:(NSArray *)array;   // 返回选中乘客的情况

@optional
- (void)passengerListReqIsOver;             // 本页的乘客列表是否结束

@end
