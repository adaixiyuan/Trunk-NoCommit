//
//  selectCityCell.m
//  ElongClient
//
//  Created by elong lide on 11-12-30.
//  Copyright 2011 elong. All rights reserved.
//

#import "selectCityCell.h"


@implementation selectCityCell
@synthesize city_label;
@synthesize gpsView;
@synthesize splitView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
        
        self.gpsView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 40)] autorelease];
        gpsView.image = [UIImage noCacheImageNamed:@"elong_gps_h.png"];
        gpsView.hidden = YES;
        gpsView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:gpsView];
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)] autorelease];
        self.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        
		self.city_label = [[[UILabel alloc] initWithFrame:CGRectMake(17, 0, 260, 44)] autorelease];
		city_label.backgroundColor = [UIColor clearColor];
		city_label.textColor	= RGBACOLOR(52, 52, 52, 1);
		city_label.font			= FONT_15;
        city_label.adjustsFontSizeToFitWidth = YES;
        city_label.minimumFontSize = 12;
		[self.contentView addSubview:city_label];
        
        splitView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 40 - SCREEN_SCALE, SCREEN_WIDTH - 17, SCREEN_SCALE)];
        splitView.image= [UIImage noCacheImageNamed:@"dashed.png"];
        [self.contentView addSubview:splitView];
        [splitView release];
    }
    return self;
}


- (void)setIsInterHotelType:(BOOL)isInterHotelType {
    _isInterHotelType = isInterHotelType;
    
    city_label.adjustsFontSizeToFitWidth = NO;
    city_label.font = FONT_B14;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	self.city_label = nil;
    SFRelease(gpsView);
	
    [super dealloc];
}


@end
