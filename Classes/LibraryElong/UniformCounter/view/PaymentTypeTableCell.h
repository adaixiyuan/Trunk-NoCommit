//
//  PaymentTypeTableCell.h
//  ElongClient
//
//  Created by 赵 海波 on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTypeTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *payTypeIcon;         // 支付方式图标
@property (nonatomic, strong) IBOutlet UIImageView *checkBox;            // 勾选框
@property (nonatomic, strong) IBOutlet UILabel *payTypeNameLabel;        // 支付方式名称
@property (nonatomic, strong) IBOutlet UILabel *payTypeDetailLabel;      // 支付方式说明

@end
