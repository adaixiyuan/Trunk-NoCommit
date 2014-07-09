//
//  GrouponItemViewController.h
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-22.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "DPNav.h"
#import <MapKit/MapKit.h>

typedef enum {
    GrouponMapItem,
    GrouponPhoneItem,
    GrouponCommentItem,
    HotelDetailInfoItem,
}GrouponItemStyle;

@class GrouponDetailViewController;
@interface GrouponItemViewController : DPNav<UITableViewDelegate,UITableViewDataSource,HttpUtilDelegate>{
@private
    UITableView *hotelList;
    HttpUtil *hoteldetailRequest;
}
@property (nonatomic, retain) NSDictionary *detailDic;				// 源数据
@property (nonatomic, assign) GrouponDetailViewController *parentVC;

- (id)initWithDictionary:(NSDictionary *)dictionary style:(GrouponItemStyle)grouponStyle;

@end