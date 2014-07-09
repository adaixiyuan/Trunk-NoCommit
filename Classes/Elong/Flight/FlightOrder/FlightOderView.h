//
//  FlightOderView.h
//  ElongClient
//
//  Created by nieyun on 14-3-17.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlightOrderInfoModel.h"
#import "AirlineInfoModel.h"

@interface FlightOderView : UIView
@property  (nonatomic,retain)AirlineInfoModel *model;
@property (retain, nonatomic) IBOutlet UIImageView *flightNumPic;
@property (retain, nonatomic) IBOutlet UILabel *flightNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightArriveLabel;
@property (retain, nonatomic) IBOutlet UILabel *flightStartLabel;
@property (retain, nonatomic) IBOutlet UILabel *startTime;
@property (retain, nonatomic) IBOutlet UILabel *arriveTime;
@property (retain, nonatomic) IBOutlet UILabel *priceLabel;
@end
