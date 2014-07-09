//
//  TaxiTypeCell.h
//  ElongClient
//
//  Created by nieyun on 14-3-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaxiTypeModel.h"
#import "UIImageView+WebCache.h"


@interface TaxiTypeCell : UITableViewCell<SDWebImageManagerDelegate>
@property (retain,nonatomic) TaxiTypeModel  *model;//车型model
@property (retain, nonatomic) IBOutlet UIImageView *picImageV;//图片
@property (retain, nonatomic) IBOutlet UILabel *carTypeName;//车型名称label

@property (retain, nonatomic) IBOutlet UILabel *carBrandName;//车牌名称
@property (retain, nonatomic) IBOutlet UILabel *timeAndDistance;//时间和距离
@property (retain, nonatomic) IBOutlet UILabel *carPrice;//车的价格
@end
