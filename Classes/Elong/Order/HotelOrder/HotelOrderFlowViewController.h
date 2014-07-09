//
//  HotelOrderFlowViewController.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "HotelOrderFlowRequest.h"
#import "FullHouseRequest.h"
#import "FeedBackView.h"
#import "HotelOrderListRequest.h"
typedef enum
{
    NoOrderFlowStatus = 0,
    AgreeFlowArrangeStatus,
    FeedBackStatus
    
}FlowStatus;

@interface HotelOrderFlowViewController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,HotelOrderFlowRequestDelgate,FullHouseDelegate,UIAlertViewDelegate,FeedBackDelegate,HotelOrderListRequestDelegate>{
    IBOutlet UITableView *_orderFlowTable;
    IBOutlet UILabel *_noDataPromptLabel;       //没有日志时的提醒
   
    
    NSMutableArray *_orderFlowArray;        //订单流程数据
    NSDictionary *_currentOrder;        //当前订单信息
    HotelOrderFlowRequest  *_orderFlowRequest;      //订单处理页面的请求管理
    FlowStatus  flowState;
    NSString  *flowDes;
    FullHouseRequest  *fullRequest;
   
    NSMutableArray  *_buttonAr;
    UIImageView *bottomView ;
    int refreshCount;
}

-(id)initWithOrder:(NSDictionary *)anOrder;

@end
