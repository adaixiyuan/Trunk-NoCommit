//
//  FlightCheckboxCell.m
//  ElongClient
//
//  Created by chenggong on 13-12-19.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightCheckboxCell.h"

@implementation FlightCheckboxCell

- (void)dealloc {
    self.checkBoxButton = nil;
    self.cellTextLabel = nil;
    self.airlineImageView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)buttonClicked:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tableViewCell:selected:)]) {
        [_delegate tableViewCell:self selected:_checkBoxButton.selected];
    }
}

- (id)initWithIdentifier:(NSString *)identifierString height:(CGFloat)cellHeight selected:(BOOL)selected
{
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierString]) {
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkBoxButton = selectButton;
        selectButton.frame = CGRectMake(40.0f, 15.0f, 19.0f, 19.0f);
        [_checkBoxButton setImage:[UIImage imageNamed:@"btn_choice_checked.png"] forState:UIControlStateSelected];
        [_checkBoxButton setImage:[UIImage imageNamed:@"btn_choice.png"] forState:UIControlStateNormal];
        _checkBoxButton.selected = selected;
        [_checkBoxButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_checkBoxButton];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_checkBoxButton.frame) + CGRectGetMinX(_checkBoxButton.frame) + 20.0f, 14.0f, 20.0f, 20.0f)];
        tempImageView.hidden = YES;
        self.airlineImageView = tempImageView;
        [self addSubview:tempImageView];
        [tempImageView release];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(_checkBoxButton.frame.size.width + CGRectGetMinX(_checkBoxButton.frame) + 20.0f, 15.0f, self.frame.size.width - _checkBoxButton.frame.size.width, _checkBoxButton.frame.size.height)];
        tempLabel.font = [UIFont boldSystemFontOfSize:16];
        tempLabel.adjustsFontSizeToFitWidth = YES;
        tempLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.cellTextLabel = tempLabel;
        [tempLabel release];
        [self addSubview:_cellTextLabel];
	}
	
	return self;
}

- (void)setCheckBoxButtonSelected:(BOOL)selected {
    _checkBoxButton.selected = selected;
}

- (void)setAirlineImageViewImage:(UIImage *)image
{
    _airlineImageView.hidden = NO;
    _airlineImageView.image = image;
    
    CGRect rect = _cellTextLabel.frame;
    rect.origin.x = CGRectGetMinX(_airlineImageView.frame) + CGRectGetWidth(_airlineImageView.frame) + 5.0f;
    _cellTextLabel.frame = rect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
