//
//  XGShoppingCell.h
//  ElongClient
//
//  Created by guorendong on 14-4-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGFramework.h"
#import "XGHotelInfo.h"

@interface XGShoppingCell : XGBaseTableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *hotelImage;
@property (retain, nonatomic) IBOutlet UILabel *hotelNameLable;
@property (strong, nonatomic) IBOutlet UILabel *distanceLable;//如具体29公里
@property (retain, nonatomic) IBOutlet UILabel *onlineLable;
@property (retain, nonatomic) IBOutlet UIView *wifiAndParkBack;
@property (retain, nonatomic) IBOutlet UILabel *otherInfoLable;//其他说明
@property (strong, nonatomic) IBOutlet UILabel *otherInfo;//如，优惠活动等其他信息
@property (retain, nonatomic) IBOutlet UIView *otherView;
@property (retain, nonatomic) IBOutlet UIImageView *wifiImage;//wifi
@property (retain, nonatomic) IBOutlet UIImageView *stopImage;//停车场
@property (retain, nonatomic) IBOutlet UILabel *roomStyleName;//豪华高级床
@property (retain, nonatomic) IBOutlet UIImageView *arrowImage;//是否Arrar
@property (retain, nonatomic) IBOutlet UILabel *tagAndCommentLable;// 96%好评
@property (retain, nonatomic) IBOutlet UILabel *finalPriceLable;//最终价格

-(void)setViewInfoForObject:(XGHotelInfo *)hotelInfo;
@end
