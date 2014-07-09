//
//  OnlyTextFieldCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-14.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "OnlyTextFieldCell.h"

@implementation OnlyTextFieldCell

- (void)dealloc
{
    [_textField  release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 文本框
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 190, 0, 180, 44)];
        
        _textField.textAlignment = UITextAlignmentRight;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.textColor = RGBACOLOR(52, 52, 52, 1);
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_textField];
        
        UIImageView  *bottomLineView  =[[UIImageView  alloc]initWithFrame:CGRectMake(0, self.frame.size.height-SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        bottomLineView.image = [UIImage  noCacheImageNamed:@"dashed.png"];
        [self.contentView  addSubview:bottomLineView];
        [bottomLineView  release];
        
        self.contentView.backgroundColor = [UIColor  whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
