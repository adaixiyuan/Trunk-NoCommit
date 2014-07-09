//
//  ScenicBookingCell.m
//  ElongClient
//
//  Created by Jian.Zhao on 14-5-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicBookingCell.h"
#import "ScenicDetail.h"
@implementation ScenicBookingCell

- (void)awakeFromNib
{
    // Initialization code
    //self.backgroundColor = RGBACOLOR(253, 247, 241, 1);
    //划价
    [self.marketPrice addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 10, _marketPrice.frame.size.width,SCREEN_SCALE)]];
}

-(void)loadData{
    self.ticketName.text = self.price.ticketName;
    self.marketPrice.text = self.price.price;
    self.elongPrice.text = self.price.elongPrice;
    self.payTypeName.text = self.price.pModeName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_price release];
    [_ticketName release];
    [_marketPrice release];
    [_elongPrice release];
    [_payTypeName release];
    [super dealloc];
}
@end
