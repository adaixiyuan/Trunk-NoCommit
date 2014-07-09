//
//  TonightHotelListModeTableCell.m
//  ElongClient
//
//  Created by Wang Shuguang on 12-10-23.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "TonightHotelListModeTableCell.h"

@implementation TonightHotelListModeTableCell
@dynamic tonightHotelCount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 分割线
        UIImageView *splitLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        splitLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitLine];
        [splitLine release];
        
        // 选中背景
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        //logo
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 13, 50, 54)];
        logoView.image = [UIImage noCacheImageNamed:@"tonight_logo.png"];
        [self.contentView addSubview:logoView];
        [logoView release];
        
        //文字提示
        UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(94, 10, 160, 30)];
        tipLable.backgroundColor = [UIColor clearColor];
        tipLable.text = @"今日特价";
        tipLable.font = [UIFont boldSystemFontOfSize:16.0f];
        tipLable.textColor = RGBACOLOR(52, 52, 52, 1);
        [self.contentView addSubview:tipLable];
        [tipLable release];
        
        UILabel *priceTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(94, 42, 200, 30)];
        priceTipLabel.backgroundColor = [UIColor clearColor];
        priceTipLabel.text = @"比艺龙网站优惠30%以上";
        priceTipLabel.textColor = RGBACOLOR(108, 108, 108, 1);
        priceTipLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:priceTipLabel];
        [priceTipLabel release];
        
        //加载逻辑处理容器
        loadingContentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,80)];
        [self.contentView addSubview:loadingContentView];
        [loadingContentView release];
        
        
        //酒店数量
        UIImageView *hotelCountBg = [[UIImageView alloc] initWithFrame:CGRectMake(236, 26, 68, 27)];
        //hotelCountBg.image = [UIImage noCacheImageNamed:@"tonight_count.png"];
        [loadingContentView addSubview:hotelCountBg];
        [hotelCountBg release];
        
        hotelCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 53, 24)];
        hotelCount.textAlignment = UITextAlignmentRight;
        hotelCount.font = [UIFont boldSystemFontOfSize:23.0f];
        hotelCount.textColor = RGBACOLOR(254, 75, 32, 1);
        hotelCount.backgroundColor = [UIColor clearColor];
        [hotelCountBg addSubview:hotelCount];
        [hotelCount release];
        
        UILabel *homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 6, 40, 17)];
        homeLabel.textAlignment = UITextAlignmentCenter;
        homeLabel.font = [UIFont systemFontOfSize:12.0f];
        homeLabel.textColor = RGBACOLOR(102, 102, 102, 1);
        homeLabel.backgroundColor = [UIColor clearColor];
        homeLabel.text = @"家";
        [hotelCountBg addSubview:homeLabel];
        [homeLabel release];
        
        UIImageView *rightArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(69, 10, 5, 9)];
        rightArrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [hotelCountBg addSubview:rightArrowView];
        [rightArrowView release];
        
        //加载符
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.frame = CGRectMake(320 - 40, 30, 20, 20);
        [self.contentView addSubview:loadingView];
        [loadingView release];

        
        self.clipsToBounds = NO;
    }
    return self;
}

- (void) startLoading{
    [loadingView startAnimating];
    [loadingContentView setHidden:YES];
    self.userInteractionEnabled = NO;
}

- (void) stopLoading{
    [loadingView stopAnimating];
    [loadingContentView setHidden:NO];
    self.userInteractionEnabled = YES;
}

- (NSInteger) tonightHotelCount{
    return  [hotelCount.text  intValue];
}

-(void) setTonightHotelCount:(NSInteger)tonightHotelCount{
    if (tonightHotelCount == 0) {
        [loadingContentView setHidden:YES];
        [loadingView stopAnimating];
        self.userInteractionEnabled = NO;
    }
    hotelCount.text = [NSString stringWithFormat:@"%d",tonightHotelCount];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
