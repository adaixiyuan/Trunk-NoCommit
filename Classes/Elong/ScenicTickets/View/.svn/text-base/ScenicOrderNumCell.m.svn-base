//
//  ScenicOrderNumCell.m
//  ElongClient
//
//  Created by jian.zhao on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicOrderNumCell.h"

@implementation ScenicOrderNumCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)reduceBuyNum:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(reduceNum:)]) {
        [_delegate reduceNum:sender];
    }
}
- (IBAction)plusBuyNum:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(plusNum:)]) {
        [_delegate plusNum:sender];
    }
}

- (void)dealloc {
    [_spanNum release];
    [_buyNum release];
    [_left release];
    [_right release];
    [super dealloc];
}
@end
