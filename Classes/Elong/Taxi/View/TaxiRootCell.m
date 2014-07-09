//
//  TaxiRootCell.m
//  ElongClient
//
//  Created by jian.zhao on 14-5-16.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiRootCell.h"

@implementation TaxiRootCell

- (void)awakeFromNib
{
    // Initialization code
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)]];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(_firstBtn.origin.x, _firstBtn.origin.y+_firstBtn.frame.size.height, SCREEN_WIDTH-_firstBtn.origin.x, SCREEN_SCALE)]];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(_secondBtn.origin.x, _secondBtn.origin.y+_secondBtn.frame.size.height, SCREEN_WIDTH-_secondBtn.origin.x, SCREEN_SCALE)]];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, self.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];
    self.thirdTip.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_typeImage release];
    [_firstBtn release];
    [_secondBtn release];
    [_thirdBtn release];
    [_thirdArrow release];
    [_thirdTip release];
    [super dealloc];
}
@end
