//
//  CustomersTableCell.m
//  ElongClient
//
//  Created by WangHaibin on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomersTableCell.h"


@implementation CustomersTableCell
@synthesize nameLabel;
@synthesize infoLabel;

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
    [super dealloc];
}


@end
