//
//  TaxiPersonCell.m
//  ElongClient
//
//  Created by nieyun on 14-3-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "TaxiPersonCell.h"
#import "UIViewExt.h"

@implementation TaxiPersonCell

- (void)dealloc
{
    [_textField  release];
    SFRelease(dashView);
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.font = [UIFont  systemFontOfSize:16];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [UIView setAnimationsEnabled:NO];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        // 分割虚线
        
        // title
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 150, 44)];
        titleLbl.font = [UIFont systemFontOfSize:16.0f];
        titleLbl.adjustsFontSizeToFitWidth = YES;
        titleLbl.minimumFontSize = 12.0f;
        titleLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.text = @"联系人";
        [self.contentView addSubview:titleLbl];
        [titleLbl release];
        
        // detail
        detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH - 20 - 12, 44)];
        detailLbl.font = [UIFont systemFontOfSize:16.0f];
        detailLbl.backgroundColor = [UIColor clearColor];
        detailLbl.adjustsFontSizeToFitWidth = YES;
        detailLbl.minimumFontSize = 12.0f;
        detailLbl.textColor = RGBACOLOR(52, 52, 52, 1);
        detailLbl.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:detailLbl];
        [detailLbl release];
        
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(70 + 12, 0, 180, 44)];
    
        _textField.textAlignment = UITextAlignmentRight;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.textColor = RGBACOLOR(52, 52, 52, 1);
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_textField];
        _textField.placeholder = @"姓名";

        
        // 文本框
        
        // 分割线
              //顶部线
        topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:topSplitView];
        [topSplitView release];
        
        
        [UIView setAnimationsEnabled:YES];
    }
    return self;

  
}

- (void)setIsMember:(BOOL)isMember
{
    if (_isMember != isMember)
    {
        _isMember =  isMember;
    }
    if (self.isMember && !dashView)
    {
      
        dashView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 2, SCREEN_SCALE, 44 - 4)];
        dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
        [self.contentView addSubview:dashView];
        
        UIButton *customerSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        customerSelBtn.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
        [customerSelBtn setImage:[UIImage noCacheImageNamed:@"customer_icon.png"] forState:UIControlStateNormal];
        [customerSelBtn addTarget:self action:@selector(customerSelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView  *dashView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 0.55, 43)];
        dashView1.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
        [customerSelBtn addSubview:dashView1];
        [dashView1 release];
        [self.contentView addSubview:customerSelBtn];
    }
    
    if (self.isMember)
    {
        _textField.left = 82;
    }else
    {
        _textField.left = SCREEN_WIDTH - 190;
    }
    


}
- (void)customerSelBtnClick:(UIButton *)bt
{
    if ([self.delegate respondsToSelector:@selector(personChooseAction)])
    {
        [self.delegate  personChooseAction];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
