//
//  GroupStyleCell.m
//  ElongClient
//
//  Created by 赵 海波 on 13-7-23.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "GroupStyleCell.h"

@implementation GroupStyleCell

- (void)dealloc
{
    [_titleLabel removeObserver:self forKeyPath:@"text"];
    [super dealloc];
}

- (id)initWithStyle:(GroupCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(int)height
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [UIView setAnimationsEnabled:NO];
        cellHeight = height;
        _needHighLighted = YES;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView = nil;
        
        // 背景色
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        [self.contentView addSubview:bgImageView];
        [bgImageView release];

        [self makeUIForStyle:style];
        
        [UIView setAnimationsEnabled:YES];
    }
    return self;
}


// 为不同的类型的cell生成对应控件
- (void)makeUIForStyle:(GroupCellStyle)style
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, self.contentView.frame.size.width - 20, cellHeight)];
    _titleLabel.font = FONT_16;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor colorWithRed:0.17 green:0.17 blue:0.17 alpha:1];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel release];
    
    [_titleLabel addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, (cellHeight - 9)/2, 5, 9)];
    rightArrow.image = [UIImage imageNamed:@"ico_rightarrow.png"];
    [self.contentView addSubview:rightArrow];
    [rightArrow release];
    
    cellStyle = style;
    switch (style)
    {
        case GroupCellStyleDefault:
        {
            rightArrow.hidden = NO;
        }
            break;
        case GroupCellStyleSubTitle:
        {   
            _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            _subTitleLabel.font = FONT_13;
            _subTitleLabel.backgroundColor = [UIColor clearColor];
            _subTitleLabel.textColor = [UIColor grayColor];
            _subTitleLabel.adjustsFontSizeToFitWidth = YES;
            _subTitleLabel.textAlignment = UITextAlignmentRight;
            [self.contentView addSubview:_subTitleLabel];
            [_subTitleLabel release];
            
            rightArrow.hidden = NO;
        }
            break;
        case GroupCellStyleTextField:
        {   
            _inputField = [[CustomTextField alloc] initWithFrame:CGRectZero];
            _inputField.font = FONT_16;
            _inputField.delegate = self;
            _inputField.borderStyle = UITextBorderStyleNone;
            _inputField.textAlignment = NSTextAlignmentRight;
            _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self.contentView addSubview:_inputField];
            [_inputField release];
            
            rightArrow.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (void)setCellType:(GroupCellPosition)cellType {
//    if (cellType == GroupCellPositionTop) {
//        bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_header.png"];
//        splitView.hidden = NO;
//    }else if(cellType == GroupCellPositionMiddle){
//        bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_middle.png"];
//        splitView.hidden = NO;
//    }else if(cellType == GroupCellPositionBottom){
//        bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_footer.png"];
//        splitView.hidden = YES;
//    }else if (cellType == GroupCellPositionWhole) {
//        bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell.png"];
//        splitView.hidden = YES;
//    }
    
    _cellType = cellType;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        bgImageView.image = COMMON_BUTTON_PRESSED_IMG;
//        if (self.cellType == GroupCellPositionTop) {
//            bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_header_h.png"];
//        }else if(self.cellType == GroupCellPositionMiddle){
//            bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_middle_h.png"];
//        }else if(self.cellType == GroupCellPositionBottom){
//            bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_footer_h.png"];
//        }else if (self.cellType == GroupCellPositionWhole) {
//            bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_h.png"];
//        }
    }else{
        bgImageView.image = nil;
//        if (self.cellType == GroupCellPositionTop) {
//            bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_header.png"];
//        }else if(self.cellType == GroupCellPositionMiddle){
//            bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_middle.png"];
//        }else if(self.cellType == GroupCellPositionBottom){
//            bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_footer.png"];
//        }else if (self.cellType == GroupCellPositionWhole) {
//            bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell.png"];
//        }
    }
}


- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (_needHighLighted)
    {
        if (highlighted) {
            bgImageView.image = COMMON_BUTTON_PRESSED_IMG;
//            if (self.cellType == -1) {
//                bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_header_h.png"];
//            }else if(self.cellType == 0){
//                bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_middle_h.png"];
//            }else if(self.cellType == 1){
//                bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_footer_h.png"];
//            }
        }else{
            bgImageView.image = nil;
//            if (self.cellType == -1) {
//                bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_header.png"];
//            }else if(self.cellType == 0){
//                bgImageView.image = [UIImage stretchableImageWithPath:@"fillorder_cell_middle.png"];
//            }else if(self.cellType == 1){
//                bgImageView.image = [UIImage noCacheImageNamed:@"fillorder_cell_footer.png"];
//            }
        }
    }
}


#pragma mark - KVC

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _titleLabel)
    {
        [_titleLabel sizeToFit];
        CGRect rect = _titleLabel.frame;
        rect.size.height = cellHeight;
        _titleLabel.frame = rect;
        
        int offX = _titleLabel.frame.origin.x + _titleLabel.frame.size.width;
        // 根据主标题长度调整各控件位置
        switch (cellStyle) {
            case GroupCellStyleSubTitle:
            _subTitleLabel.frame = CGRectMake(offX, 0, 280 - offX, cellHeight);
                break;
            case GroupCellStyleTextField:
            _inputField.frame = CGRectMake(offX, 0, 295 - offX, cellHeight);
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isKindOfClass:[CustomTextField class]])
    {
        [textField performSelector:@selector(resetTargetKeyboard)];
        
        if ([_delegate respondsToSelector:@selector(cellTextFieldShouldBeginEditing:)]) {
            [_delegate cellTextFieldShouldBeginEditing:textField];
        }
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	return [textField resignFirstResponder];
}

@end
