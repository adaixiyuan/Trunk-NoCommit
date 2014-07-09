//
//  PhoneListCell.h
//  ElongClient
//
//  Created by nieyun on 14-6-11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineCell.h"
@interface PhoneListCell :LineCell
@property (retain, nonatomic) IBOutlet UIImageView *cellImageView;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *detaileLabel;
@end
