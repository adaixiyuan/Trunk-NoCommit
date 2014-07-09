//
//  InterHotelOrderHistoryController.h
//  ElongClient
//
//  Created by 赵岩 on 13-6-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import "InterOrderDetailRequest.h"
#import "InterHotelOrderHistoryDetail.h"
#import "BaseBottomBar.h"


@interface InterHotelOrderHistoryController : DPNav <UITableViewDataSource, UITableViewDelegate, InterHotelOrderHistoryDetailDelegate,BaseBottomBarDelegate>{
@private
    HttpUtil *detailHttpUtil;
    UILabel *_noneDataLabel;
}

@property (nonatomic, assign) NSUInteger type;
@property (nonatomic, retain) NSArray *orderList;
@property (nonatomic, retain) NSArray *confirmedOrderList;
@property (nonatomic, retain) NSArray *canceledOrderList;

@end
