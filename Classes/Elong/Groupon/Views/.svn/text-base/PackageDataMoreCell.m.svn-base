//
//  PackageDataMoreCell.m
//  ElongClient
//
//  Created by garin on 14-6-3.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "PackageDataMoreCell.h"

@implementation PackageDataMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        float cellHeight = 41;
        
        // 背景色
        UIView *bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cellHeight)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        UILabel *moreLabel = [UILabel new];
        moreLabel.frame = CGRectMake(104, 10, 100, 20);
        moreLabel.backgroundColor = [UIColor clearColor];
        moreLabel.text = @"点击查看更多";
        moreLabel.textAlignment = NSTextAlignmentCenter;
        moreLabel.font = [UIFont systemFontOfSize:17];
        moreLabel.textColor = RGBACOLOR(252, 152, 44, 1);
        [moreLabel sizeToFit];
        [bgImageView addSubview:moreLabel];
        [moreLabel release];
        
        UIImageView *moreIcon = [UIImageView new];
        moreIcon.frame = CGRectMake(204, cellHeight/2 - 9 , 18, 18);
        moreIcon.image = [UIImage noCacheImageNamed:@"tuan_lookMoreProduct.png"];
        [bgImageView addSubview:moreIcon];
        [moreIcon release];
        
        UIImageView *downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, cellHeight- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
    }
    return self;
}

@end
