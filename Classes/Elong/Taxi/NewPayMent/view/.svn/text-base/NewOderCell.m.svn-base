//
//  NewOderCell.m
//  ElongClient
//
//  Created by nieyun on 14-4-4.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "NewOderCell.h"

@implementation NewOderCell
- (void)dealloc
{
    
    [_price  release];
    [_orderAmount release];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.orderAmount.text  = [NSString  stringWithFormat:@"¥%@",self.price  ];
}

@end
