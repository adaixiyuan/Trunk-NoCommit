//
//  PassengerCell.m
//  ElongClient
//
//  Created by Zhao Haibo on 13-11-17.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "PassengerCell.h"

@implementation PassengerCell

- (void)dealloc
{
    self.cellEditButton = nil;
    [super dealloc];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier cellHeight:(NSInteger)height
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // 选择框
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(16, (height-19) / 2, 19, 19)];
        _selectImgView.image = [UIImage noCacheImageNamed:@"btn_checkbox.png"];
        [self.contentView addSubview:_selectImgView];
        [_selectImgView release];
        
        // 姓名
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 4, SCREEN_WIDTH - 65 - 48, height / 2)];
        nameLabel.font = FONT_14;
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumFontSize = 12;
        nameLabel.textColor = [UIColor colorWithRed:93.0f/255.0f green:93.0f/255.0f blue:93.0f/255.0f alpha:1];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        [nameLabel release];
        
        // 证件
        certLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, height / 2, nameLabel.frame.size.width, height / 2 -4)];
        certLabel.font = FONT_14;
        certLabel.adjustsFontSizeToFitWidth = YES;
        certLabel.minimumFontSize = 12;
        certLabel.textColor = [UIColor colorWithRed:93.0f/255.0f green:93.0f/255.0f blue:93.0f/255.0f alpha:1];
        certLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:certLabel];
        [certLabel release];
        
        // 编辑按钮
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        editButton.frame = CGRectMake(SCREEN_WIDTH - 44.0f, 0.0f, 44.0, height);
//        editButton.imageView.frame = CGRectMake(23.0f, 20.0f, 5.0f, 9.0f);
//        editButton.imageView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        [editButton setImageEdgeInsets:UIEdgeInsetsMake(23.0f, 20.0f, 23.0f, 20.0f)];
        [editButton setImage:[UIImage noCacheImageNamed:@"ico_rightarrow.png"] forState:UIControlStateNormal];
//        [editButton setExclusiveTouch:YES];
        [self.contentView setUserInteractionEnabled:YES];
        [self.contentView addSubview:editButton];
        [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        self.cellEditButton = editButton;
        
        // 分割线
        _topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        _topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [_topSplitView setAlpha:0.8];
        [_topSplitView setHidden:YES];
        [self.contentView addSubview:_topSplitView];
        [_topSplitView release];
        
        UIImageView *bottomSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-1,SCREEN_WIDTH, 1)];
        bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:bottomSplitView];
        [bottomSplitView release];
    }
    return self;
}


- (void)setPassengerName:(NSString *)name
{
    nameLabel.text = [NSString stringWithFormat:@"姓名：%@", name];
}


- (void)setPassengerCert:(NSString *)certInfo
{
    certLabel.text = [NSString stringWithFormat:@"证件：%@", certInfo];
}


- (void)setChecked:(BOOL)checked
{
    if (checked)
    {
        _selectImgView.image = [UIImage noCacheImageNamed:@"btn_choice_checked.png"];
    }else{
        _selectImgView.image = [UIImage noCacheImageNamed:@"btn_choice.png"];
    }
}

- (void)editAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(editPassenger:)]) {
        [_delegate editPassenger:self];
    }
}

@end
