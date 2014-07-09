//
//  InterHotelOrderHistoryCell.m
//  ElongClient
//
//  Created by 赵岩 on 13-6-27.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelOrderHistoryCell.h"

@implementation InterHotelOrderHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		UIView* b_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
		b_view.backgroundColor = [UIColor clearColor];
		UIButton* b_btn = [UIButton buttonWithType:UIButtonTypeCustom];
		b_btn.backgroundColor = [UIColor clearColor];
		b_btn.frame = CGRectMake(0, 0, 320, 90);
		[b_btn setBackgroundImage:[UIImage stretchableImageWithPath:@"common_btn_press.png"] forState:UIControlStateHighlighted];
		[b_view addSubview:b_btn];
		self.selectedBackgroundView = b_view;
		[b_view release];
	}
	
	return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (UIView *subview in self.subviews) {
        for (UIView *subview2 in subview.subviews) {
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
                [subview bringSubviewToFront:subview2];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
