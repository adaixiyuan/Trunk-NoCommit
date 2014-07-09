//
//  HotelOrderCell.m
//  ElongClient
//
//  Created by Wang Shuguang on 13-4-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelOrderCell.h"

@implementation HotelOrderCell
@synthesize textField;
@synthesize cellType = _cellType;

- (void) dealloc{
    self.textField = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [UIView setAnimationsEnabled:NO];

        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);

        // 分割虚线
        dashView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20 - 62, 1, 1, 43)];
        //dashView.image = [UIImage noCacheImageNamed:@"fillorder_cell_dashline.png"];
        [self.contentView addSubview:dashView];
        dashView.clipsToBounds = YES;
        dashView.contentMode = UIViewContentModeCenter;
        dashView.hidden = YES;
        [dashView release];
        
        // 右侧指示箭头
        arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16, (44 - 8)/2, 8, 9)];
        arrowView.image = [UIImage noCacheImageNamed:@"ico_rightarrow.png"];
        arrowView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:arrowView];
        [arrowView release];
        
        // title
        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 150, 44)];
        titleLbl.font = [UIFont systemFontOfSize:16.0f];
        titleLbl.adjustsFontSizeToFitWidth = YES;
        titleLbl.minimumFontSize = 12.0f;
        titleLbl.textColor = [UIColor colorWithRed:93.0/255.0f green:93.0/255.0f blue:93.0/255.0f alpha:1];
        titleLbl.backgroundColor = [UIColor clearColor];
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
        
        // 文本框
        UITextField *_textField = [[UITextField alloc] initWithFrame:CGRectMake(100 + 12, 0, 170, 44)];
        _textField.textAlignment = UITextAlignmentRight;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.textColor = RGBACOLOR(52, 52, 52, 1);
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_textField];
        [_textField release];
        _textField.hidden = YES;
        _textField.placeholder = @"姓名";
        
        self.textField = _textField;
        
        
        // 分割线
        topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_SCALE)];
        topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:topSplitView];
        [topSplitView release];
        
        bottomSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44 - SCREEN_SCALE,SCREEN_WIDTH, SCREEN_SCALE)];
        bottomSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:bottomSplitView];
        [bottomSplitView release];
        
        [UIView setAnimationsEnabled:YES];
    }
    return self;
}

- (void)setCellType:(CellType)cellType{
    if (cellType == -1) {
        topSplitView.hidden = NO;
        bottomSplitView.hidden = NO;
    }else if(cellType == 0){
        topSplitView.hidden = YES;
        bottomSplitView.hidden = NO;
    }else if(cellType == 1){
        topSplitView.hidden = YES;
        bottomSplitView.hidden = NO;
    }
    _cellType = cellType;
}

//✽✽✽✽✹✩✩●●●★★

// 设置Arrow的可见性
- (void) setArrowHidden:(BOOL)hidden{
    arrowView.hidden = hidden;
}

// 设置常用联系人是否可见
- (void) setCustomerHidden:(BOOL)hidden{
    if (hidden) {
        self.textField.frame = CGRectMake(100 + 12, 0, 190, 44);
        bottomSplitView.frame = CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE);
        dashView.hidden = YES;
    }else{
        self.textField.frame = CGRectMake(100 + 12, 0, 150, 44);
        bottomSplitView.frame = CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH - 45, SCREEN_SCALE);
        dashView.hidden = NO;
    }
}


- (void)disWholeSplitLine {
    bottomSplitView.frame = CGRectMake(0, 44 - SCREEN_SCALE, SCREEN_WIDTH , SCREEN_SCALE);
}


// 设置左侧标题
- (void) setTitle:(NSString *)title{
    titleLbl.text = title;
    
}

// 设置右标题
- (void) setDetail:(NSString *)detail{
    if (detail == nil || [detail isEqualToString:@""]) {
        titleLbl.frame = CGRectMake(12, 0, 300 - 12 - 12, 44);
    }
    detailLbl.text = detail;
}



@end
