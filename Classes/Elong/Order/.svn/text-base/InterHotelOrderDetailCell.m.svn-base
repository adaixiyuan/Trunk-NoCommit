//
//  InterHotelOrderDetailCell.m
//  ElongClient
//
//  Created by Dawn on 13-7-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "InterHotelOrderDetailCell.h"

@implementation InterHotelOrderDetailCell
@synthesize nameLbl;
@synthesize valueLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 订单状态
        nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 76, 32)];
        nameLbl.text = @"";
        nameLbl.font = [UIFont systemFontOfSize:14.0f];
        nameLbl.textColor = [UIColor darkGrayColor];
        nameLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:nameLbl];
        [nameLbl release];
        
        valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(98, 0, SCREEN_WIDTH - 115, 32)];
        valueLbl.font = FONT_15;
        valueLbl.text = @"";
        valueLbl.numberOfLines = 0;
        valueLbl.lineBreakMode = UILineBreakModeWordWrap;
        valueLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:valueLbl];
        [valueLbl release];
        
        lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32- SCREEN_SCALE, SCREEN_WIDTH , SCREEN_SCALE)];
        [lineView setImage:[UIImage stretchableImageWithPath:@"dashed.png"]];
        [self.contentView addSubview:lineView];
        [lineView release];
    }
    return self;
}

- (void) setLineHidden:(BOOL) hidden{
    lineView.hidden = hidden;
}

- (void) setName:(NSString *)name{
    nameLbl.text = name;
}

- (void) setValue:(NSString *)value{
    CGSize newSize = [value sizeWithFont:FONT_15 constrainedToSize:CGSizeMake(SCREEN_WIDTH-115, 1000)];
    int height = newSize.height>32?newSize.height+12:32;
    NSLog(@"InterDetailCell Height :%d---%@",height,value);
    valueLbl.frame = CGRectMake(98, 0, SCREEN_WIDTH - 115, height);
    valueLbl.text = value;

    lineView.frame = CGRectMake(0, height- SCREEN_SCALE, SCREEN_WIDTH , SCREEN_SCALE);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
