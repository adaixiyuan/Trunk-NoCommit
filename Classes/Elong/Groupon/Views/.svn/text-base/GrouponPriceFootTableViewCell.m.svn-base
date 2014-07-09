//
//  GrouponPriceFootTableViewCell.m
//  ElongClient
//  价格表的表尾巴
//  Created by garin on 14-5-27.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponPriceFootTableViewCell.h"

@implementation GrouponPriceFootTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        float cellHeight = 55;
        
        // 背景色
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        upSplitView.frame = CGRectMake(9, 0, SCREEN_WIDTH -19, SCREEN_SCALE);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:upSplitView];
        [upSplitView release];
        
        valueLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 3, SCREEN_WIDTH/2-10, cellHeight/2-3)];
        valueLabel.backgroundColor=[UIColor clearColor];
        valueLabel.font=[UIFont systemFontOfSize:14];
        valueLabel.textColor=RGBACOLOR(34, 34, 34, 1);
        valueLabel.text=@"价值：1400";
        valueLabel.textAlignment=NSTextAlignmentRight;
        [bgImageView addSubview:valueLabel];
        [valueLabel release];
        
        tuanPriceLabel=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, cellHeight/2-1, SCREEN_WIDTH/2-10, cellHeight/2-1)];
        tuanPriceLabel.backgroundColor=[UIColor clearColor];
        tuanPriceLabel.font=[UIFont systemFontOfSize:14];
        tuanPriceLabel.textColor=RGBACOLOR(254, 75, 32, 1);
        tuanPriceLabel.text=@"艺龙团购价：1000";
        tuanPriceLabel.textAlignment=NSTextAlignmentRight;
        [bgImageView addSubview:tuanPriceLabel];
        [tuanPriceLabel release];
        
        UIImageView *downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, cellHeight- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
    }
    return self;
}

-(void) setValueDesp:(NSString *) value_
{
    valueLabel.text = value_;
}

-(void) settuanPriceLabelDesp:(NSString *) tuanPriceLabelDesp_
{
    tuanPriceLabel.text = tuanPriceLabelDesp_;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
