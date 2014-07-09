//
//  FAQcell.m
//  ElongClient
//
//  Created by jinmiao on 11-2-23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FAQInformCell.h"


@implementation FAQInformCell
@synthesize contentlabel;
@synthesize titlelabel;
@synthesize isSelected;
@synthesize row;
@synthesize subBgview;
@synthesize headimageView;
@synthesize answerBgImageView;
//- (id)initWithFrame:(CGRect)frame {
//    if ((self = [super initWithFrame:frame])) {
//        // Initialization code
//    }
//    return self;
//}

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
	[contentlabel release];
	[titlelabel release];
	[subBgview release];
	[headimageView release];
	[answerBgImageView release];
	
    [super dealloc];
}


@end
