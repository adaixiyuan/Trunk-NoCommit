//
//  ExchangeRate.h
//  ElongClient
//
//  Created by Jian.Zhao on 13-12-24.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "RateCell.h"
#import "RateList.h"

@class HttpUtil;

@interface ExchangeRate : DPNav<UITableViewDataSource,UITableViewDelegate,CellInputDelegate,RateListDelegate>{

    UITableView *_tableView;                  //
    NSMutableArray *currentDisplay;      //本界面当前显示
    NSMutableArray *dataSource;           //18种币种
    UILabel *timeStamp;                         //时间戳
    
    HttpUtil *_httpUtil;
}

@end
