//
//  ScenicBookingCell.h
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScenicPrice;
@interface ScenicBookingCell : UITableViewCell
@property (nonatomic,retain) ScenicPrice *price;
@property (retain, nonatomic) IBOutlet UILabel *ticketName;
@property (retain, nonatomic) IBOutlet UILabel *marketPrice;
@property (retain, nonatomic) IBOutlet UILabel *elongPrice;
@property (retain, nonatomic) IBOutlet UILabel *payTypeName;
-(void)loadData;
@end
