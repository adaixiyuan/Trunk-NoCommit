//
//  Feedback_HotelOrderListViewController.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "HotelOrderDetailRequest.h"

@interface Feedback_HotelOrderListViewController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,HotelOrderDetailRequestDelegate>{
    NSArray *_feedBackList; //反馈酒店列表
    NSMutableArray *_statusList;    //酒店是否可反馈状态列表
    HotelOrderDetailRequest *_detailRequest;        //请求信息
    int _currentSelectedRow;        //记录当前要反馈的行数
    
    IBOutlet UITableView *_mainTable;
    IBOutlet UILabel *_noDataPromptLabel;
}

-(id)initWithFeedBackList:(NSArray *)aFeedbackList statusList:(NSArray *)aStatusList;

@end
