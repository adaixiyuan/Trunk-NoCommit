//
//  ScenicAreaDetailViewController.h
//  ElongClient
//  景区详情页面
//  Created by Jian.Zhao on 14-5-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "ScenicBookingTable.h"
#import "ScenicIntroCell.h"

typedef enum {
    ScenicTicketType_Temporarily_offLine = 99, //暂时下线
    ScenicTicketType_NoBooking = 100,//不可预订景区
    ScenicTicketType_CanBooking = 101 //可预订景区
}ScenicTicketType;//景区详情类型

typedef enum {
    ScenicRecommandType_Around = 10,//附近景点
    ScenicRecommandType_Same,//同类景点
}ScenicRecommandType;//不可预订景区下面的推荐栏


@class ScenicDetail,ScenicBookingTable;
@interface ScenicAreaDetailViewController : ElongBaseViewController<UITableViewDataSource,UITableViewDelegate,ScenicBookingDelegate,ImageTapDelegate>{

    UITableView *_tableView;
    NSMutableArray *_heightArray;
    ScenicBookingTable *_bookingTable;
    
}
@property (nonatomic,assign) ScenicTicketType type;
@property (nonatomic,retain) ScenicDetail *scenicDetail;
@property (nonatomic,copy) NSString *mainImageURL;
@property (nonatomic,copy) NSString *scenerySummary;
@property (nonatomic,copy) NSString *orderTip;

@end
