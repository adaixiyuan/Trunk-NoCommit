//
//  TrainOrderCell.m
//  ElongClient
//
//  Created by bruce on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainOrderCell.h"

@implementation TrainOrderCell

- (void) dealloc{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [UIView setAnimationsEnabled:NO];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        // 分割虚线
        dashView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 62, 1, 1, 43)];
        //dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
        [self.contentView addSubview:dashView];
        dashView.clipsToBounds = YES;
        dashView.contentMode = UIViewContentModeCenter;
        dashView.hidden = YES;
        [dashView release];
        
        // 右侧指示箭头
//        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 26, (44 - 5)/2, 9, 5)];
//        arrowView.image = [UIImage imageNamed:@"ico_downdirectionarrow.png"];
//        arrowView.contentMode = UIViewContentModeCenter;
//        [self.contentView addSubview:arrowView];
//        [arrowView release];
        
        UILabel *modifySeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, (44 - 16)/2, 70, 16)];
        modifySeatLabel.backgroundColor = [UIColor clearColor];
        modifySeatLabel.textColor = RGBACOLOR(29, 94, 226, 1);
        modifySeatLabel.font = [UIFont systemFontOfSize:14.0f];
        modifySeatLabel.text = @"修改坐席";
        [self.contentView addSubview:modifySeatLabel];
        [modifySeatLabel release];
        
        // title
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 110, 44)];
        titleLbl.font = [UIFont fontWithName:@"STHeitiJ-Light" size:17.0f];
        titleLbl.adjustsFontSizeToFitWidth = YES;
        titleLbl.minimumFontSize = 12.0f;
        titleLbl.textColor = RGBCOLOR(93, 93, 93, 1);
        titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLbl];
        [titleLbl release];
        
        // Unit price
        unitPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(122.0f, 0, 150, 44)];
        unitPriceLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:13.0f];
        unitPriceLabel.adjustsFontSizeToFitWidth = YES;
        unitPriceLabel.minimumFontSize = 12.0f;
        unitPriceLabel.textColor = RGBACOLOR(140, 140, 140, 1);
        unitPriceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:unitPriceLabel];
        [unitPriceLabel release];
        
        
        // detail
        detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(156.0f, 0, SCREEN_WIDTH - 156.0f- 70.0f - 25.0f, 44)];
        detailLbl.font = [UIFont fontWithName:@"STHeitiJ-Light" size:13.0f];
        detailLbl.backgroundColor = [UIColor clearColor];
        detailLbl.textColor = RGBACOLOR(140, 140, 140, 1);
        detailLbl.adjustsFontSizeToFitWidth = YES;
        detailLbl.minimumFontSize = 12.0f;
        detailLbl.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:detailLbl];
        [detailLbl release];
        
        
        // 分割线
        topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:topSplitView];
        [topSplitView release];
        
        bottomSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE,SCREEN_WIDTH, SCREEN_SCALE)];
        bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:bottomSplitView];
        [bottomSplitView release];
        
        [UIView setAnimationsEnabled:YES];
    }
    return self;
}

// 设置Arrow的可见性
- (void) setArrowHidden:(BOOL)hidden{
    arrowView.hidden = hidden;
}



// 设置左侧标题
- (void) setTitle:(NSString *)title{
    CGSize titleSize = [title sizeWithFont:titleLbl.font];
    if (titleSize.width > titleLbl.frame.size.width) {
        titleLbl.font = [UIFont systemFontOfSize:14.0f];
    }
    titleLbl.text = title;
    
}

// 设置右标题
- (void) setDetail:(NSString *)detail{
    if (detail == nil || [detail isEqualToString:@""]) {
        titleLbl.frame = CGRectMake(12, 0, 300 - 12 - 12, 44);
    }
    detailLbl.text = detail;
}

// 设置单价
- (void)setUnitPrice:(NSString *)unitPrice
{
    unitPriceLabel.text = unitPrice;
}

@end
