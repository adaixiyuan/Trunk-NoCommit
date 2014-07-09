//
//  AddressTableCell.m
//  ElongClient
//
//  Created by WangHaibin on 2/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddressTableCell.h"


@implementation AddressTableCell
@synthesize nameLable;
@synthesize infoLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		//self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	self.nameLable = nil;
	self.infoLable = nil;
	
    [super dealloc];
}


@end
