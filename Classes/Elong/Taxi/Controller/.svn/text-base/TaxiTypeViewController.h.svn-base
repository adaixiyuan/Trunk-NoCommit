//
//  TaxiTypeViewController.h
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//
typedef enum {
    default_request = 0,  //默认请求
    explainStep1_request =1,  //资费说明 请求1
    explainStep2_request =2   //资费说明 请求2
    
}RentRequestType;

#import "ElongBaseViewController.h"
#import "RentCarExplainManager.h"
@interface TaxiTypeViewController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,HttpUtilDelegate>
{
    UITableView  *_table;
    NSMutableArray  *modelAr;
    
}
@property  (nonatomic,retain) NSArray  *totalAr;
@property(nonatomic,assign)RentRequestType curRequestType;  //默认是0
@property(nonatomic,retain)RentCarExplainManager *renCarManager;  //处理数据
@end
