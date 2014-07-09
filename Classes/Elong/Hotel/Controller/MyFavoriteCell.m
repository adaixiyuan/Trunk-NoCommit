//
//  MyFavoriteCell.m
//  ElongClient
//
//  Created by bin xing on 11-2-19.
//  Copyright 2011 DP. All rights reserved.
//

#import "MyFavoriteCell.h"


@implementation MyFavoriteCell
@synthesize hotelNameLabel;
@synthesize hotelRatingLabel;
@synthesize starLevelImageView;
@synthesize hotelAddressLabel;
@synthesize cellHeight;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	hotelNameLabel=nil;
	hotelRatingLabel=nil;
	starLevelImageView=nil;
	hotelAddressLabel=nil;
	[hotelNameLabel release];
	[hotelRatingLabel release];
	[starLevelImageView release];
	[hotelAddressLabel release];
    [super dealloc];
}


@end
