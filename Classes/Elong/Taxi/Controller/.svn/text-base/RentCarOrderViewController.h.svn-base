//
//  RenCarOrderViewController.h
//  ElongClient
//
//  Created by licheng on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

typedef enum {
    RENTCARLIST_REFRESH,      //刷新
    RENTCARLIST_MORE,     //更多
    RENTCARLIST_FILTER,       //筛选
    RENTCARDETAIL_REVIEW,      //查看详情
}RequestType4RENTCAR;

#import "ElongBaseViewController.h"
#import "NewPayMethodCtrl.h"

@interface RentCarOrderViewController : ElongBaseViewController<HttpUtilDelegate>
{
    int _currentDeletedRow;
    RequestType4RENTCAR _requestType;
    NewPayMethodCtrl   *newPayControl;
    int currentSelectedRow;
    int net_Request;
}
-(id)initWithRentCarOrders:(NSArray *)hotelRentCarOrdersArray;

@property(nonatomic,retain)UITableView *mainTableView;
@property(nonatomic,retain)NSMutableArray *dataSourceArray;
@property(nonatomic,retain)UILabel *noListLabel;
@property(nonatomic,retain)NSDictionary *continueDict;
@end
