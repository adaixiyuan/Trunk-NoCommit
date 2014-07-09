//
//  FlightAddNewCustomerCell.m
//  ElongClient
//
//  Created by chenggong on 13-12-11.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightAddNewCustomerCell.h"

@implementation FlightAddNewCustomerCell

- (void)dealloc
{
    self.cellDescription = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.0f, 11.0f, 22.0f, 22.0f)];
        signImageView.image = [UIImage noCacheImageNamed:@"add_new_customer.png"];
        [self addSubview:signImageView];
        [signImageView release];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(44.0f, 11.0f, 200.0f, 22.0f)];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.font = [UIFont systemFontOfSize:16.0f];
        tempLabel.textColor = [UIColor blackColor];
        [self addSubview:tempLabel];
        self.cellDescription = tempLabel;
        [tempLabel release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
