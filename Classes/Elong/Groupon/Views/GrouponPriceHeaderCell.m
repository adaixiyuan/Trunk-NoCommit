//
//  GrouponPriceHeaderCell.m
//  ElongClient
//  价格表的表头
//  Created by garin on 14-4-23.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponPriceHeaderCell.h"

@implementation GrouponPriceHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        float cellHeight = 27;
        
        // 背景色
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=RGBACOLOR(248, 248, 248, 1);
        [bgImageView release];
        
//        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
//        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
//        upSplitView.contentMode=UIViewContentModeScaleToFill;
//        [bgImageView addSubview:upSplitView];
//        [upSplitView release];
        
        firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(9, 0, 142 - 9, cellHeight)];
        firstLabel.backgroundColor=[UIColor clearColor];
        firstLabel.font=[UIFont boldSystemFontOfSize:12];
        firstLabel.textColor=RGBACOLOR(34, 34, 34, 1);
        firstLabel.text=@"内容";
        firstLabel.textAlignment=NSTextAlignmentLeft;
        [bgImageView addSubview:firstLabel];
        [firstLabel release];
        
//        secondLabel=[[UILabel alloc] initWithFrame:CGRectMake(140, 0, 65, cellHeight)];
//        secondLabel.backgroundColor=[UIColor clearColor];
//        secondLabel.font=[UIFont systemFontOfSize:13];
//        secondLabel.textColor=RGBACOLOR(34, 34, 34, 1);
//        secondLabel.text=@"单价";
//        secondLabel.textAlignment=NSTextAlignmentCenter;
//        [bgImageView addSubview:secondLabel];
//        [secondLabel release];
        
        thirdLable=[[UILabel alloc] initWithFrame:CGRectMake(142, 0, 69, cellHeight)];
        thirdLable.backgroundColor=[UIColor clearColor];
        thirdLable.font=[UIFont boldSystemFontOfSize:12];
        thirdLable.textColor=RGBACOLOR(34, 34, 34, 1);
        thirdLable.text=@"数量";
        thirdLable.textAlignment=NSTextAlignmentCenter;
        [bgImageView addSubview:thirdLable];
        [thirdLable release];
        
        fourthLable=[[UILabel alloc] initWithFrame:CGRectMake(211 , 0, 109 - 10 , cellHeight)];
        fourthLable.backgroundColor=[UIColor clearColor];
        fourthLable.font=[UIFont boldSystemFontOfSize:12];
        fourthLable.textColor=RGBACOLOR(34, 34, 34, 1);
        fourthLable.text=@"小计";
        fourthLable.textAlignment=NSTextAlignmentRight;
        [bgImageView addSubview:fourthLable];
        [fourthLable release];
    }
    return self;
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
