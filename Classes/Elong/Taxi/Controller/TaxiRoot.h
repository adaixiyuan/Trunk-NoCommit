//
//  TaxiRoot.h
//  ElongClient
// 用车首页
//  Created by Jian.Zhao on 14-2-10.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    Taxi_onCall = 100,//随叫随到
    Taxi_Pick,      //接机
    Taxi_Send,    //送机
}TaxiType;

typedef enum {
    RentCarType_Pick = 104,//租车接机
    RentCarType_Send,//租车送机
}RentCarType;

@interface TaxiRoot : DPNav<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>{

    HttpUtil *http_util;
    UITableView *_tableView;
}

@end
