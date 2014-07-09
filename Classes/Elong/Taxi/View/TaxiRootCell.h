//
//  TaxiRootCell.h
//  ElongClient
//
//  Created by jian.zhao on 14-5-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxiRootCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *typeImage;
@property (retain, nonatomic) IBOutlet UIButton *firstBtn;
@property (retain, nonatomic) IBOutlet UIButton *secondBtn;
@property (retain, nonatomic) IBOutlet UIButton *thirdBtn;
@property (retain, nonatomic) IBOutlet UIImageView *thirdArrow;
@property (retain, nonatomic) IBOutlet UILabel *thirdTip;

@end
