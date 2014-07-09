//
//  GrouponDetailMutipleAddreeCell.m
//  ElongClient
//
//  Created by garin on 14-5-30.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "GrouponDetailMutipleAddreeCell.h"

@implementation GrouponDetailMutipleAddreeCell

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    UIImageView *upSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
    upSplitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE);
    upSplitView.contentMode=UIViewContentModeScaleToFill;
    [self.contentView addSubview:upSplitView];
    [upSplitView release];
    
    UIImageView *downSplitView = [[UIImageView alloc] initWithImage:[UIImage noCacheImageNamed:@"dashed.png"]];
    downSplitView.frame = CGRectMake(0, 45- SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
    downSplitView.contentMode=UIViewContentModeScaleToFill;
    [self.contentView addSubview:downSplitView];
    [downSplitView release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//预约
- (IBAction)appointMentClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(appointmentCellAppoint)])
    {
        [_delegate appointmentCellAppoint];
    }
}
@end
