//
//  XGOrderDetailViewController.h
//  ElongClient
//
//  Created by 李程 on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGBaseViewController.h"
#import "XGOrderModel.h"
@class XGHomeOrderDetailSource;

typedef void(^BackBlock)(void);

@interface XGOrderDetailViewController : XGBaseViewController

@property(nonatomic,strong)XGOrderModel *orderModel;
@property(nonatomic,strong)XGHomeOrderDetailSource *dataSource;

@property(nonatomic,strong)BackBlock backBlock;  //如果取消订单了，就冲刷list 列表
//点击酒店电话
-(void)clickOrderDetailCell_TelPhoneBtn;
@end
