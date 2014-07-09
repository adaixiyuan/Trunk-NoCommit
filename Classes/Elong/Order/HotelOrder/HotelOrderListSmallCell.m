//
//  HotelOrderListCell.m
//  ElongClient
//
//  Created by Ivan.xu on 14-3-7.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "HotelOrderListSmallCell.h"

@implementation HotelOrderListSmallCell

- (void)dealloc
{
    [_hotelNameLabel release];
    [_roomNameLabel release];
    [_checkInDateLabel release];
    [_departureDateLabel release];
    [_orderStatusLabel release];
    [_priceInfoLabel release];
    [_bookingDateLabel release];
    
    [_topLineImgView release];
    [_bottomLineImgView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
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

-(void)layoutSubviews{
    [super layoutSubviews];
    //设置删除按钮全部显示
    for (UIView *subview in self.subviews) {
        for (UIView *subview2 in subview.subviews) {
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
                [subview bringSubviewToFront:subview2];
            }
        }
    }
}

@end
