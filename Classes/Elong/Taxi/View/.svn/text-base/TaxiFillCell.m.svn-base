//
//  TaxiFillCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiFillCell.h"

@implementation TaxiFillCell

- (void) dealloc
{
    [_titleLbl release];
    [_textField  release];
    [_dashView release];
    [_topLine release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor  whiteColor];
        
        
        self.textLabel.font = [UIFont  systemFontOfSize:16];
       
        [UIView setAnimationsEnabled:NO];
        
        // ===========================================
        // 分隔线
        // ===========================================
       
        
        // 分割虚线
        _dashView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 2, SCREEN_SCALE, 44 - 4)];
        _dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
        [self.contentView addSubview:_dashView];
        
        // title
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12,0, 150, 44)];
        _titleLbl.font = [UIFont systemFontOfSize:16.0f];
        _titleLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.text = @"联系人手机";
        [self.contentView addSubview:_titleLbl];
        
        // 文本框
        _textField = [[CustomTextField alloc] initWithFrame:CGRectMake(70 + 12, 0, 180, 44)];
        _textField.backgroundColor = [UIColor  clearColor];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.fieldKeyboardType = CustomTextFieldKeyboardTypeDefault;
        
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.textAlignment = UITextAlignmentRight;
        _textField.textColor = RGBACOLOR(52, 52, 52, 1);
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_textField];
        _textField.placeholder = @"用于客服、确认";
        
        // 按钮
        _addressBoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressBoomBtn setImage:[UIImage noCacheImageNamed:@"groupon_order_add.png"] forState:UIControlStateNormal];
        [_addressBoomBtn  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_addressBoomBtn];
        
        _addressBoomBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
        
        _topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        _topLine.image = [UIImage noCacheImageNamed:@"dashed.png"];
        _topLine.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_topLine];
        
        // 分割线
        UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        splitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        splitView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:splitView];
        [splitView release];
        
        [UIView setAnimationsEnabled:YES];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void) buttonAction:(UIButton *)buttton
{
    if ([self.delegate  respondsToSelector:@selector(addressChooseAction:)])
    {
        [self.delegate  addressChooseAction:buttton];
    }
}
// 设置左侧标题
- (void) setTitle:(NSString *)title
{
    _titleLbl.text = title;
}



@end
