//
//  InterHotelListCell.m
//  ElongClient
//
//  Created by 赵 海波 on 13-6-20.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelListCell.h"
#import "StarsView.h"
#import "SettingManager.h"
#import "DaoDaoRankingView.h"

@implementation InterHotelListCell
@synthesize haveImage;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        // 酒店名
        _hotelNameLable = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH - 16, 42)];
        _hotelNameLable.font = [UIFont boldSystemFontOfSize:16];
        _hotelNameLable.textColor = RGBACOLOR(52, 52, 52, 1);
        _hotelNameLable.numberOfLines = 0;
        [self.contentView addSubview:_hotelNameLable];
        [_hotelNameLable release];
        
        int offX = 7;
        // 需要显示酒店图片的情况
        if ([[SettingManager instanse] defaultDisplayHotelPic]) {
            _hotelImageView = [[RoundCornerView alloc] initWithFrame:CGRectMake(6, 41 - 3, 75 + 6, 75 + 6)];
            _hotelImageView.imageRadius = 2.0f;
            [self.contentView addSubview:_hotelImageView];
            [_hotelImageView release];
            
            offX = 89;
        }
        
        // 酒店星级
        starView = [[StarsView alloc] initWithFrame:CGRectMake(offX, 44, 110, 16)];
        [starView setStarNumber:0];
        [self.contentView addSubview:starView];
        [starView release];
        
        // 酒店评分
        rankingView = [[DaoDaoRankingView alloc] initWithFrame:CGRectMake(offX, 69, 106, 18)];
        [self.contentView addSubview:rankingView];
        [rankingView release];
        
        // 酒店位置说明
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(offX, 98, 150, 18)];
        _locationLabel.textColor = RGBACOLOR(108, 108, 108, 1);
        _locationLabel.font = FONT_12;
        _locationLabel.adjustsFontSizeToFitWidth = YES;
        _locationLabel.minimumFontSize = 12;
        [self.contentView addSubview:_locationLabel];
        [_locationLabel release];
        
        // 原始价
        _originPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(224, 46, 61, 20)];
        _originPriceLabel.font = FONT_12;
        _originPriceLabel.textColor = RGBACOLOR(119, 119, 119, 1);
        _originPriceLabel.textAlignment = UITextAlignmentCenter;
        [self.contentView addSubview:_originPriceLabel];
        [_originPriceLabel release];
        
        // 原始价划线
        line = [[UIImageView alloc] initWithFrame:CGRectMake(10, _originPriceLabel.frame.size.height / 2, _originPriceLabel.frame.size.width-20, 1)];
        line.image = [UIImage stretchableImageWithPath:@"price_line_bg.png"];
        
        [_originPriceLabel addSubview:line];
        [line release];
        
        // 符号"¥"
        currency = [[UILabel alloc] initWithFrame:CGRectMake(226, 72, 13, 13)];
        currency.text = @"¥";
        currency.textColor = RGBACOLOR(108, 108, 108, 1);
        currency.font = FONT_10;
        currency.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:currency];
        [currency release];
        
        // 实际价
        _realPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 66, 76, 21)];
        _realPriceLabel.font = [UIFont boldSystemFontOfSize:23.0f];
        _realPriceLabel.textColor = RGBACOLOR(254, 75, 32, 1);
        _realPriceLabel.backgroundColor = [UIColor clearColor];
        _realPriceLabel.adjustsFontSizeToFitWidth = YES;
        _realPriceLabel.minimumFontSize = 12;
        _realPriceLabel.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:_realPriceLabel];
        [_realPriceLabel release];
        
        // “起”字
        UILabel *qiLabel = [[UILabel alloc] initWithFrame:CGRectMake(287, 72, 13, 13)];
        qiLabel.text = @"起";
        qiLabel.font = FONT_10;
        qiLabel.textColor = RGBACOLOR(108, 108, 108, 1);
        [self.contentView addSubview:qiLabel];
        [qiLabel release];
        
        // 右箭头
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(305, 74, 5, 9)];
        arrowIcon.image = [UIImage imageNamed:@"ico_rightarrow.png"];
        [self.contentView addSubview:arrowIcon];
        [arrowIcon release];
        
        // "促"字icon
        cuIcon = [[UIImageView alloc] initWithFrame:CGRectMake(36, 123, 14, 14)];
        cuIcon.image = [UIImage imageNamed:@"promotion_ico.png"];
        [self.contentView addSubview:cuIcon];
        [cuIcon release];
        
        // 促销信息
        _bottomInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 123, SCREEN_WIDTH - 90, 14)];
        _bottomInfoLabel.textColor = [UIColor colorWithRed:19/255.0 green:137/255.0 blue:49/255.0 alpha:1];
        _bottomInfoLabel.font = FONT_14;
        [self.contentView addSubview:_bottomInfoLabel];
        [_bottomInfoLabel release];
        
        // 底部虚线
        dash = [UIImageView graySeparatorWithFrame:CGRectMake(0, 146 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        [self.contentView addSubview:dash];
        
        // 返现
        cashDiscountIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 94 + 26, 98, 14, 13)];
        cashDiscountIcon.image = [UIImage noCacheImageNamed:@"fanxian_icon.png"];
        [self.contentView addSubview:cashDiscountIcon];
        [cashDiscountIcon release];
        
        cashDiscountLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 94 + 26 + 18, 98, 70, 13)];
        cashDiscountLbl.backgroundColor = [UIColor clearColor];
        cashDiscountLbl.textColor = RGBACOLOR(254, 75, 32, 1);
        cashDiscountLbl.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:cashDiscountLbl];
        [cashDiscountLbl release];
        
        //预付卡
        _giftCardImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 94 + 26, 98, 14, 13)];
        _giftCardImgView.image = [UIImage noCacheImageNamed:@"giftcard_icon.png"];
        [self.contentView addSubview:_giftCardImgView];
        [_giftCardImgView release];
        
        _giftAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 94 + 26 + 18, 98, 70, 13)];
        _giftAmountLabel.backgroundColor = [UIColor clearColor];
        _giftAmountLabel.textColor = RGBACOLOR(252, 152, 44, 1);
        _giftAmountLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:_giftAmountLabel];
        [_giftAmountLabel release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    line.backgroundColor = COLOR_CELL_LABEL;
}


- (void)setHotelStar:(NSString *)StarNum {
    [starView setStarNumber:StarNum];
}


- (void)setDaodaoRating:(CGFloat)rating {
    [rankingView setDaoDaoScore:rating];
}


- (void)showPromotionInfo:(NSString *)info {
    cuIcon.hidden = NO;
    _bottomInfoLabel.text = info;
    _bottomInfoLabel.hidden = NO;
    
    dash.frame = CGRectMake(0, 146 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
}

- (void) setPrice:(NSInteger)price{
    self.realPriceLabel.text = [NSString stringWithFormat:@"%d",price];
    if (price < 100) {
        currency.frame = CGRectMake(226 + 20, 72, 13, 13);
    }else if(price < 1000){
        currency.frame = CGRectMake(226 + 10, 72, 13, 13);
    }else if(price < 10000){
        currency.frame = CGRectMake(226, 72, 13, 13);
    }else{
        currency.frame = CGRectMake(226 - 10, 72, 13, 13);
    }
}

- (void)hiddenPromotionInfo {
    cuIcon.hidden = YES;
    _bottomInfoLabel.hidden = YES;
    
    
    dash.frame = CGRectMake(0, 126 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
}


- (void)setPromoPrice:(CGFloat)price {
    if (price > 0) {
        _originPriceLabel.text = [NSString stringWithFormat:@"¥ %.0f", price];
        line.hidden = NO;
    }
    else {
        _originPriceLabel.text = @"";
        line.hidden = YES;
    }
}

- (void) setDiscountPrice:(CGFloat)price{
    if (price > 0) {
        cashDiscountLbl.text = [NSString stringWithFormat:@"¥ %.0f", price];
        cashDiscountIcon.hidden = NO;
    }
    else {
        cashDiscountLbl.text = @"";
        cashDiscountIcon.hidden = YES;
    }
}

 //设置预付卡
-(void)setGiftCardPrice:(float)price{
    if (price > 0) {
        _giftAmountLabel.text = [NSString stringWithFormat:@"¥ %.0f", price];
        _giftCardImgView.hidden = NO;
    }
    else {
        _giftAmountLabel.text = @"";
        _giftCardImgView.hidden = YES;
    }
}


@end
