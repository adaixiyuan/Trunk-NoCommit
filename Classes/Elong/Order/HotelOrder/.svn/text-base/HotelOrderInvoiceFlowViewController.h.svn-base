//
//  HotelOrderInvoiceFlowViewController.h
//  ElongClient
//
//  Created by Ivan.xu on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "HotelOrderInvoiceFlowRequest.h"

@interface HotelOrderInvoiceFlowViewController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,HotelOrderInvoiceFlowRequestDelegate>{
    IBOutlet UITableView *_orderFlowTable;
    IBOutlet UILabel *_noDataPromptLabel;       //没有日志时的提醒
    
    NSMutableArray *_invoiceFlowArray;        //订单流程数据
    NSDictionary *_currentOrder;        //当前订单信息
    
    HotelOrderInvoiceFlowRequest  *_orderInvoiceFlowRequest;      //订单处理页面的请求管理
}

-(id)initWithOrder:(NSDictionary *)anOrder;

@end
