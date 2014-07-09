//
//  ScenicIntroCell.m
//  ElongClient
//
//  Created by jian.zhao on 14-5-15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ScenicIntroCell.h"

@implementation ScenicIntroCell

- (void)awakeFromNib
{
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)]];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(_scenicIntro.frame.origin.x,44, SCREEN_WIDTH-_scenicIntro.frame.origin.x, SCREEN_SCALE)]];
    [self addSubview:[UIImageView graySeparatorWithFrame:CGRectMake(0, self.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)]];

    _mainImage.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAndGoImages:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_mainImage addGestureRecognizer:tap];
    [tap release];
}

- (void)tapAndGoImages:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(tapTheImageBtn)]) {
        [_delegate tapTheImageBtn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_imageNums release];
    [_scenicIntro release];
    [_mainImage release];
    [super dealloc];
}
@end
