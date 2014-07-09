//
//  SelectRoomerEditCell.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-12.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "SelectRoomerEditCell.h"

@implementation SelectRoomerEditCell
@synthesize saveBtn;
@synthesize nameTextField;

- (void) dealloc{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        [bgView release];
        
        // 添加按钮
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(0, 0, 44, 44);
        [addBtn setImage:[UIImage noCacheImageNamed:@"add_new_customer.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:addBtn];
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        
        // 输入框
        nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH - 50, 44)];
        nameTextField.borderStyle = UITextBorderStyleNone;
        nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        nameTextField.placeholder = @"新增常用入住人";
        nameTextField.returnKeyType = UIReturnKeyDone;
        nameTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        nameTextField.delegate = self;
        nameTextField.textColor = RGBACOLOR(93, 93, 93, 1);
        [self.contentView addSubview:nameTextField];
        [nameTextField release];
        
        self.contentView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        
        // 保存
        saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(SCREEN_WIDTH, 4, 60, 36);
        [saveBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_normal.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateNormal];
        [saveBtn setBackgroundImage:[[UIImage imageNamed:@"btn_default1_press.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:23] forState:UIControlStateHighlighted];
        saveBtn.titleLabel.font	= FONT_B18;
        [self addSubview:saveBtn];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        
        UIImageView *dashLineView0  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        dashLineView0.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:dashLineView0];
        [dashLineView0 release];
        
        UIImageView *dashLineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
        dashLineView1.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:dashLineView1];
        [dashLineView1 release];
    }
    return self;
}


- (void) keyboardBack{
    if ([nameTextField isFirstResponder]) {
        [nameTextField resignFirstResponder];
        [self endEdit];
    }
    
}

- (void) beginEdit{
    [UIView animateWithDuration:0.3 animations:^{
        addBtn.frame = CGRectMake(-50, 0, 46, 46);
        nameTextField.frame = CGRectMake(20, 0, SCREEN_WIDTH - 100, 46);
        saveBtn.frame = CGRectMake(SCREEN_WIDTH - 76, saveBtn.frame.origin.y, saveBtn.frame.size.width, saveBtn.frame.size.height);
        bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20 - 80, 46);
    }];
}

- (void) endEdit{
   
    [UIView animateWithDuration:0.3 animations:^{
        addBtn.frame = CGRectMake(0, 0, 46, 46);
        nameTextField.frame = CGRectMake(44, 0, SCREEN_WIDTH - 50, 46);
        saveBtn.frame = CGRectMake(SCREEN_WIDTH, saveBtn.frame.origin.y, saveBtn.frame.size.width, saveBtn.frame.size.height);
        bgImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 46);
    } completion:^(BOOL finished) {
         nameTextField.text = @"";
    }];
}

- (void) addBtnClick:(id)sender{
    [self beginEdit];
    [nameTextField becomeFirstResponder];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    [self beginEdit];
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
        [self endEdit];
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
        [self endEdit];
    }
    [saveBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
