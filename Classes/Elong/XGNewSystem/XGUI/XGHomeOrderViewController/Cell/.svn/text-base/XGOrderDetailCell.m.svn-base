//
//  XGOrderDetailCell.m
//  ElongClient
//
//  Created by 李程 on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGOrderDetailCell.h"

@implementation XGOrderDetailCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    
    
    self.topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
    self.topLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_topLineImgView];
    
    self.bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
    self.bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:self.bottomLineImgView];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)telePhoneAction:(id)sender{
    
    self.callTeleBlock();

}

@end
