//
//  CFAndButtonCell.m
//  ElongClient
//  
//  Created by jian.zhao on 14-5-13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "CFAndButtonCell.h"

@implementation CFAndButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier showRight:(BOOL)show customTF:(BOOL)yes
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _showRightTip = show;
        //
        self.backgroundColor = [UIColor whiteColor];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 34)];
        _title.backgroundColor = [UIColor clearColor];
        [_title setTextColor:RGBACOLOR(54, 54, 54, 1)];
        [self addSubview:_title];
        
        if (yes) {
            _cf_Field = [[CustomTextField alloc] initWithFrame:CGRectZero];
            _cf_Field.borderStyle = UITextBorderStyleNone;
            _cf_Field.backgroundColor = [UIColor clearColor];
            _cf_Field.textAlignment = NSTextAlignmentRight;
            _cf_Field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _cf_Field.font = FONT_12;
            _cf_Field.tag = 101;
            [self addSubview:_cf_Field];
        }else{
        
            _textField = [[UITextField    alloc] initWithFrame:CGRectZero];
            _textField.borderStyle = UITextBorderStyleNone;
            _textField.backgroundColor = [UIColor clearColor];
            _textField.textAlignment = NSTextAlignmentRight;
            _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _textField.font = FONT_12;
            _textField.tag = 101;
            [self addSubview:_textField];
        }

        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectZero];
        line.tag = 100;
        line.image = [[UIImage imageNamed:@"fillorder_cell_dashline.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        [self addSubview:line];
        [line release];
        
        _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipBtn setFrame:CGRectZero];
        [self addSubview:_tipBtn];
        
        [self adjustTheCellLayoutByShowRight:self.showRightTip];
    }
    return self;
}

-(void)adjustTheCellLayoutByShowRight:(BOOL)show{

    CGRect tf_Frame;
    CGRect verLine_frame;
    CGRect btn_frame;
    if (show) {
        tf_Frame = CGRectMake(75, 5, 190, 34);
        verLine_frame = CGRectMake(275,5,SCREEN_SCALE,34);
        btn_frame = CGRectMake(280, 0, 40, 44);
    }else{
        tf_Frame = CGRectMake(80, 5, 230, 34);
        verLine_frame = CGRectZero;
        btn_frame = CGRectZero;
    }
    
    UITextField *textF = (UITextField *)[self viewWithTag:101];
    if (textF) {
        [textF setFrame:tf_Frame];
    }
    UIImageView *view = (UIImageView *)[self viewWithTag:100];
    if (view) {
        [view setFrame:verLine_frame];
    }
    [_tipBtn setFrame:btn_frame];
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc{
    
    self.title = nil;
    self.cf_Field = nil;
    self.textField = nil;
    [super dealloc];
}

@end
