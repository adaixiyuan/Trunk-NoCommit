//
//  InterHotelDetailCtrl.h
//  ElongClient
//
//  Created by Ivan.xu on 13-6-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterRoomCell.h"
#import "InterRoomerSelectorViewController.h"
#import "InterRoomDetailView.h"
#import "ELCalendarViewController.h"

@interface InterHotelDetailCtrl : DPNav<UITableViewDataSource,UITableViewDelegate,HttpUtilDelegate,InterRoomerSelectorViewControllerDelegate,InterRoomDelegate,InterRoomDetailDelegate,ElCalendarViewSelectDelegate>
{
    HttpUtil *_couponUtil;
}
-(id)initWithDataDic:(NSDictionary *)hotelDic;//需要列表传递过来的数据

+(NSMutableDictionary *)detail; //酒店详情数据
+(NSMutableArray *)rooms;       //酒店房间数据

@end
