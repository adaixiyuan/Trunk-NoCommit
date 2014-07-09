//
//  ScenicFillOrderVC.h
//  ElongClient
//  门票订单填写页面
//  Created by jian.zhao on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "ELCalendarViewController.h"
#import "ScenicOrderNumCell.h"
#import "ScenicOrderHeaderCell.h"
@class ScenicPrice;
@interface ScenicFillOrderVC : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,CustomABDelegate,ElCalendarViewSelectDelegate,TicketsNumDelegate,AdjustHeaderHeightDelegate>
{
    
    UITableView *_tableView;
    int tickets_num;//购买的票数
    
    BOOL requestOver;  //联系人是否预加载
    int kNetRequest;//网络请求
    HttpUtil *customersRequest;//请求客史
    
    CGFloat headerCell_Height;
    BOOL head_intro_Show;
    UILabel *salePriceLbl;//金额标签
    NSIndexPath *currentPath;//调整键盘专用
}

@property (nonatomic,retain) ScenicPrice *priceDetail;
@property (nonatomic,copy) NSString *travelDate;
@property (nonatomic,copy) NSString *t_holder_Name;//取票人姓名
@property (nonatomic,copy) NSString *t_holder_Phone;//取票人电话
@property (nonatomic,copy) NSString *t_holder_id;//取票人身份证

@end
