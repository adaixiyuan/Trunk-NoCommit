//
//  GrouponOrderPhoneCell.m
//  ElongClient
//
//  Created by Dawn on 13-7-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GrouponOrderPhoneCell.h"

@implementation GrouponOrderPhoneCell
@synthesize phoneField;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImage *stretchImg = [UIImage noCacheImageNamed:@"groupon_cell_normal.png"];
        UIImage *newImg = [stretchImg stretchableImageWithLeftCapWidth:14
                                                          topCapHeight:14];
        
        // 背景色
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(13, 0, 294, 40)];
        [self.contentView addSubview:bgImageView];
        bgImageView.image = newImg;
        [bgImageView release];
        bgImageView.userInteractionEnabled = YES;
        
        
        // 手机号
        UILabel *phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 40)];
        phoneLbl.textColor = [UIColor blackColor];
        phoneLbl.backgroundColor = [UIColor clearColor];
        phoneLbl.font = [UIFont boldSystemFontOfSize:14.0f];
        [bgImageView addSubview:phoneLbl];
        [phoneLbl release];
        phoneLbl.text = @"手 机 号";
        
        
        phoneField = [[CustomTextField alloc] initWithFrame:CGRectMake(15, 0, 294-15 - 45, 40)];
        phoneField.placeholder = @"请输入正确手机号码";
        phoneField.placeholder	= @"请输入手机号";
        phoneField.borderStyle = UITextBorderStyleNone;
        phoneField.textAlignment = UITextAlignmentRight;
        phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        phoneField.font = [UIFont systemFontOfSize:14.0f];
        phoneField.numberOfCharacter = 11;
        [bgImageView addSubview:phoneField];
        [phoneField release];
        
        // 分割线
        UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImageView.frame.size.width - 40, 0, 0.55, 40)];
        splitView.image = [UIImage noCacheImageNamed:@"groupon_detail_cell_split.png"];
        [bgImageView addSubview:splitView];
        [splitView release];
        
        // 电话按钮
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(bgImageView.frame.size.width - 40, 0, 40, 40);
        [addBtn setImage:[UIImage noCacheImageNamed:@"groupon_order_add.png"] forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:9.0f];
        [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgImageView addSubview:addBtn];
    }
    return self;
}

- (void) addBtnClick:(id)sender{
    if([delegate respondsToSelector:@selector(orderPhoneCellAddPhone:)]){
        [delegate orderPhoneCellAddPhone:self];
    }
}
@end
