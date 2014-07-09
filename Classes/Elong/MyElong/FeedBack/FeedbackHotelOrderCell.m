//
//  FeedbackHotelOrderCell.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-19.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "FeedbackHotelOrderCell.h"

@implementation FeedbackHotelOrderCell

- (void)dealloc
{
    [_hotelNameLabel release];
    [_priceLabel release];
    [_roomNameLabel release];
    [_arriveDateLabel release];
    [_departDateLabel release];
    [_feedbackStatusLabel release];
    [_arrowImgView release];
    
    [_topLineImgView release];
    [_bottomLineImgView release];
    [super dealloc];
}

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    UIImage *pressImg = [UIImage stretchableImageWithPath:@"common_btn_press.png"];
    self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:pressImg] autorelease];
    
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
