//
//  HotelOrderLinkmanCell.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-11.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelOrderLinkmanCell.h"

@implementation HotelOrderLinkmanCell

- (void) dealloc
{
    [_titleLbl release];
    [_dashView release];
    [_topLine release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [UIView setAnimationsEnabled:NO];
        
        // ===========================================
        // 分隔线
        // ===========================================
        _topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        _topLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
        _topLine.backgroundColor = [UIColor clearColor];
        _topLine.hidden = YES;
        [self.contentView addSubview:_topLine];
        
        // 分割虚线
        _dashView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 2, SCREEN_SCALE, 44 - 4)];
        _dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
        [self.contentView addSubview:_dashView];
        
        // title
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,0, 150, 44)];
        _titleLbl.font = [UIFont systemFontOfSize:16.0f];
        _titleLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        _titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLbl];
        
        // 文本框
        _textField = [[CustomTextField alloc] initWithFrame:CGRectMake(70 + 12, 0, 180, 44)];
        _textField.borderStyle = UITextBorderStyleNone;
        
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.textAlignment = UITextAlignmentRight;
        _textField.textColor = RGBACOLOR(52, 52, 52, 1);
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_textField];
        [_textField release];
        _textField.placeholder = @"用于客服、确认";

        // 按钮
        _addressBoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressBoomBtn setImage:[UIImage noCacheImageNamed:@"groupon_order_add.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_addressBoomBtn];
        _addressBoomBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
        
        
        // 分割线
        UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        splitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        splitView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:splitView];
        [splitView release];
        
        [UIView setAnimationsEnabled:YES];
  
    }
    return self;
}


// 设置左侧标题
- (void) setTitle:(NSString *)title
{
    _titleLbl.text = title;
}

@end