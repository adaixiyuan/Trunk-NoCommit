//
//  HotelOrderInvoiceCell.m
//  ElongClient
//
//  Created by Dawn on 13-12-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "HotelOrderInvoiceCell.h"

@implementation HotelOrderInvoiceCell
@synthesize flagImageView;

- (void) dealloc{
    self.detailLabel = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
        flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 50, 44)];
        flagImageView.contentMode = UIViewContentModeCenter;
        flagImageView.image = [UIImage noCacheImageNamed:@"btn_checkbox.png"];
        [self.contentView addSubview:flagImageView];
        [flagImageView release];
        
        
        self.detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(56, 0, SCREEN_WIDTH - 67, 44)] autorelease];
        self.detailLabel.numberOfLines = 2;
        self.detailLabel.backgroundColor = [UIColor clearColor];
        self.detailLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        self.detailLabel.font = [UIFont systemFontOfSize:11.0f];
        self.detailLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        [self.contentView addSubview:self.detailLabel];
        
        UIImageView *dashLineView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 44 - SCREEN_SCALE, SCREEN_WIDTH - 24, SCREEN_SCALE)];
        dashLineView.image = [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:dashLineView];
        [dashLineView release];
    }
    return self;
}

- (void) setChecked:(BOOL)checked{
    _checked = checked;
    if (checked) {
        flagImageView.image = [UIImage noCacheImageNamed:@"btn_checkbox_checked.png"];
    }else{
        flagImageView.image = [UIImage noCacheImageNamed:@"btn_checkbox.png"];
    }
    
}


@end
