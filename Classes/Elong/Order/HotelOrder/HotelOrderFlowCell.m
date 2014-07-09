//
//  HotelOrderFlowCell.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderFlowCell.h"

@implementation HotelOrderFlowCell

-(void)dealloc{
    [_contentLabel release];
    [_roundIconImgView release];
    [_verticalLineImgView release];
    [_timeLabel release];
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    //-------在XIB中不能添加这条线。否则设置frame.width为0.5时会不显示---特注
    _verticalLineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 0, SCREEN_SCALE, 50)];
    _verticalLineImgView.image = [UIImage imageNamed:@"dashed.png"];
    [self.contentView addSubview:_verticalLineImgView];
    [self.contentView sendSubviewToBack:_verticalLineImgView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)blueStye{
    _timeLabel.textColor = RGBACOLOR(35, 119,232, 1);
    _contentLabel.textColor = RGBACOLOR(35, 119,232, 1);
    _roundIconImgView.image = [UIImage noCacheImageNamed:@"orderFlowBlue_ico.png"];
}

-(void)grayStyle{
    _timeLabel.textColor = [UIColor grayColor];
    _contentLabel.textColor = [UIColor grayColor];
    _roundIconImgView.image = [UIImage noCacheImageNamed:@"orderFlowGray_ico.png"];
}

@end
