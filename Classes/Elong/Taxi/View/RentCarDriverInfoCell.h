//
//  RentCarDriverInfoCell.h
//  ElongClient
//
//  Created by licheng on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//
//租车订单详情的 司机单信息
#import "LineCell.h"
#import "RentOrderDetailModel.h"
@interface RentCarDriverInfoCell : LineCell
@property(nonatomic,retain)RentOrderDetailModel *orderDetailModel;

@property (retain, nonatomic) IBOutlet UIImageView *driverImage;
@property (retain, nonatomic) IBOutlet UILabel *driverName;
@property (retain, nonatomic) IBOutlet UILabel *driverCarNum;
@property (retain, nonatomic) IBOutlet UILabel *driverCarType;
@property (retain, nonatomic) IBOutlet UILabel *driverTeleNum;

- (IBAction)callDriver:(id)sender;
@end
