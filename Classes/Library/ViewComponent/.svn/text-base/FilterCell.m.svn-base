//
//  FilterCell.m
//  ElongClient
//
//  Created by garin on 13-12-18.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//设置图标的其他，子类可以实现
-(void) setImgOther:(UIImageView *)img
{
    if (CommonCellStyleChoose == curStyle) {
        img.frame = CGRectMake(55, img.frame.origin.y , img.frame.size.width, img.frame.size.height);
    }
    else if (CommonCellStyleCheckBox == curStyle)
    {
        img.frame = CGRectMake(55, img.frame.origin.y , img.frame.size.width, img.frame.size.height);
    }
}

//设置label的其他，子类可以实现
-(void) setlabelOther:(UILabel *)label
{
    label.frame = CGRectMake((CommonCellStyleChoose == curStyle || CommonCellStyleCheckBox == curStyle)? 95 : 20,label.frame.origin.y , label.frame.size.width, label.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
