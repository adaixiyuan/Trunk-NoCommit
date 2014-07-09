//
//  ScenicOrderListCell.m
//  ElongClient
//
//  Created by bruce on 14-5-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicOrderListCell.h"

@implementation ScenicOrderListCell

- (void)awakeFromNib
{
    // Initialization code
    
    
    _topLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)];
    _topLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_topLineImgView];
    
    _bottomLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SCREEN_SCALE, 320, SCREEN_SCALE)];
    _bottomLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self addSubview:_bottomLineImgView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
