//
//  CashAccountDetailCell.h
//  ElongClient
//
//  Created by 赵岩 on 13-8-7.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CashAccountDetailCell : UITableViewCell

@property (nonatomic, assign) IBOutlet UILabel *balanceLabel;
@property (nonatomic, assign) IBOutlet UILabel *sourceLabel;
@property (nonatomic, assign) IBOutlet UILabel *arriveDateLabel;
@property (nonatomic, assign) IBOutlet UILabel *expiryDateLabel;

@end
