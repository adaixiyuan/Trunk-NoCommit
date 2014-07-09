//
//  NewPayMentCell.h
//  ElongClient
//
//  Created by nieyun on 14-4-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPayMentCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *payTypeIcon;         // 支付方式图标
@property (nonatomic, strong) IBOutlet UIImageView *checkBox;            // 勾选框
@property (nonatomic, strong) IBOutlet UILabel *payTypeNameLabel;        // 支付方式名称
@property (nonatomic, strong) IBOutlet UILabel *payTypeDetailLabel;      // 支付方式说明

@end
