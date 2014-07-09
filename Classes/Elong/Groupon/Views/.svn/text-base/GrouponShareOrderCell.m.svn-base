//
//  GrouponDetailOrderCell.m
//  ElongClient
//
//  Created by garin on 13-7-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponShareOrderCell.h"

@implementation GrouponShareOrderCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        [self.contentView addSubview:bgImageView];
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor=[UIColor whiteColor];
        [bgImageView release];
        
        UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
        upSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:upSplitView];
        [upSplitView release];
        
        downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
        downSplitView.frame = CGRectMake(0, 45-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        downSplitView.contentMode=UIViewContentModeScaleToFill;
        [bgImageView addSubview:downSplitView];
        [downSplitView release];
        
        shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame =  CGRectMake(0, 0, SCREEN_WIDTH, 45);
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [shareBtn setImage:[UIImage noCacheImageNamed:@"groupon_detail_share.png"] forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [shareBtn setTitle:@"  分享给朋友，听听他们的意见" forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:shareBtn];
    }
    
    return self;
}

- (void) shareBtnClick:(id)sender{
    if ([delegate respondsToSelector:@selector(orderCellShare:)]) {
        [delegate orderCellShare:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
