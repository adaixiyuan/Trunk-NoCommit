//
//  FlightEditInsurerViewCell.m
//  ElongClient
//
//  Created by chenggong on 13-12-14.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FlightEditInsurerViewCell.h"

@implementation FlightEditInsurerViewCell

- (void)dealloc
{
    self.nameLabel = nil;
    self.selectImgView = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *insurerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 0.0f, 213.0f, CGRectGetHeight(self.frame))];
        [self addSubview:insurerLabel];
        self.nameLabel = insurerLabel;
        [insurerLabel release];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(286.0f - 28.0f - 15.0f, (CGRectGetHeight(self.frame) - 24.0f) / 2, 28.0f, 24.0f)];
        [self addSubview:imageView];
        self.selectImgView = imageView;
        [imageView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
