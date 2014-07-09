//
//  ReviewCell.m
//  ElongClient
//
//  Created by bin xing on 11-3-16.
//  Copyright 2011 DP. All rights reserved.
//

#import "ReviewCell.h"


@implementation ReviewCell

@synthesize flagImageView;
@synthesize nameLabel;
@synthesize timeLable;
@synthesize contentLable;
@synthesize cellheight;
@synthesize bubbleView;

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
	self.flagImageView	= nil;
	self.bubbleView		= nil;
	self.nameLabel		= nil;
	self.timeLable		= nil;
	self.contentLable	= nil;
	
    [super dealloc];
}


@end
