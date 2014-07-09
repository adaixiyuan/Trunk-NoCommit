//
//  GrouponPriceCell.m
//  ElongClient
//  团购详情页面的价格cell
//  Created by garin on 14-4-23.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponPriceCell.h"

@implementation GrouponPriceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        float cellHeight = 29;
        
        // 背景色
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
//        UIView *upSplitView = [[UIView alloc] init];
//        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
//        upSplitView.backgroundColor=[UIColor colorWithPatternImage:[UIImage noCacheImageNamed:@"tuan_dotline.png"]];
//        [bgImageView addSubview:upSplitView];
//        [upSplitView release];
        
//        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
//        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
//        upSplitView.contentMode=UIViewContentModeScaleToFill;
//        [bgImageView addSubview:upSplitView];
//        [upSplitView release];
        
        firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(9, 0, 142 - 9, cellHeight)];
        firstLabel.backgroundColor=[UIColor clearColor];
        firstLabel.font=[UIFont systemFontOfSize:12];
        firstLabel.textColor=RGBACOLOR(34, 34, 34, 1);
        firstLabel.textAlignment=NSTextAlignmentLeft;
        [bgImageView addSubview:firstLabel];
        [firstLabel release];

//        secondLabel=[[UILabel alloc] initWithFrame:CGRectMake(140, 0, 65, cellHeight)];
//        secondLabel.backgroundColor=[UIColor clearColor];
//        secondLabel.font=[UIFont systemFontOfSize:12];
//        secondLabel.textColor=RGBACOLOR(34, 34, 34, 1);
//        secondLabel.textAlignment=NSTextAlignmentCenter;
//        [bgImageView addSubview:secondLabel];
//        [secondLabel release];
        
        thirdLable=[[UILabel alloc] initWithFrame:CGRectMake(142, 0, 69, cellHeight)];
        thirdLable.backgroundColor=[UIColor clearColor];
        thirdLable.font=[UIFont systemFontOfSize:12];
        thirdLable.textColor=RGBACOLOR(34, 34, 34, 1);
        thirdLable.textAlignment=NSTextAlignmentCenter;
        [bgImageView addSubview:thirdLable];
        [thirdLable release];
        
        fourthLable=[[UILabel alloc] initWithFrame:CGRectMake(211 , 0, 109 - 10, cellHeight)];
        fourthLable.backgroundColor=[UIColor clearColor];
        fourthLable.font=[UIFont systemFontOfSize:12];
        fourthLable.textColor=RGBACOLOR(34, 34, 34, 1);
        fourthLable.textAlignment=NSTextAlignmentRight;
        [bgImageView addSubview:fourthLable];
        [fourthLable release];
    }
    return self;
}

-(void) setLabelTxt:(NSString *) txt1 txt2:(NSString *) txt2 txt3:(NSString *) txt3 txt4:(NSString *) txt4
{
    firstLabel.text=txt1;
    secondLabel.text=txt2;
    thirdLable.text=txt3;
    fourthLable.text=txt4;
}

-(void) setLabelTxtColor:(UIColor *) color1 txt2:(UIColor *) color2 txt3:(UIColor *) color3 txt4:(UIColor *) color4
{
    if (color1) {
        firstLabel.textColor=color1;
    }
    if (color2) {
        secondLabel.textColor=color2;
    }
    if (color3) {
        thirdLable.textColor=color3;
    }
    if (color4) {
        fourthLable.textColor=color4;
    }
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
