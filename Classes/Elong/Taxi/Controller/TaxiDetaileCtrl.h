//
//  TaxiDetaileCtrlViewController.h
//  ElongClient
//
//  Created by nieyun on 14-2-8.
//  Copyright (c) 2014年 elong. All rights reserved.
//
#define SectionHeight  40
#define TipHeight   30
#define TIP  @"如需取消用车，请及时联系司机，以免引起司机投诉哦～"
#import "DPNav.h"
#import "TaxiDetaileModel.h"
#import "TaxiListModel.h"
#define TAXI_ORDERSTATE  2

@interface TaxiDetaileCtrl : DPNav<UITableViewDataSource,UITableViewDelegate>
{
    UITableView   *detaileTable;
    NSArray  *journeyAr;
}
@property  (nonatomic,retain) TaxiDetaileModel  *detaileModel;
@property   (nonatomic,retain)  TaxiListModel  *listModel;
@end
