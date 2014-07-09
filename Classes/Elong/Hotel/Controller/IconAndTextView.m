//
//  IconAndTextView.m
//  ElongClient
//
//  Created by haibo on 12-1-11.
//  Copyright 2012 elong. All rights reserved.
//

#import "IconAndTextView.h"


@implementation IconAndTextView

@synthesize iconView;
@synthesize textLabel;


- (void)dealloc {
	self.iconView	= nil;
	self.textLabel	= nil;
	
    [super dealloc];
}


- (void)addIconViewByImagePath:(NSString *)imgPath {
	UIImage *icon = [UIImage noCacheImageNamed:imgPath];
	
	iconView = [[UIImageView alloc] initWithImage:icon];
	iconView.frame = CGRectMake(0, (self.frame.size.height - icon.size.height)/2, icon.size.width, icon.size.height);
	[self addSubview:iconView];
}


- (void)addTextViewByText:(NSString *)text {
	textLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.frame.size.width + 2,
														  0,
														  self.frame.size.width - iconView.frame.size.width - 2,
														  self.frame.size.height)];
	textLabel.backgroundColor	= [UIColor clearColor];
	textLabel.text				= text;
	textLabel.textColor			= [UIColor darkGrayColor];
	textLabel.font				= FONT_11;
	textLabel.numberOfLines		= 0;
	[self addSubview:textLabel];
}


- (id)initWithFrame:(CGRect)frame iconPath:(NSString *)path textContent:(NSString *)text {
    self = [super initWithFrame:frame];
	
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		
		[self addIconViewByImagePath:path];
		[self addTextViewByText:text];
    }
	
    return self;
}


- (void)reSetFrame:(CGRect)rect {
	self.frame = rect;
	
	textLabel.frame = CGRectMake(iconView.frame.size.width + 2,
								 0,
								 self.frame.size.width - iconView.frame.size.width - 2,
								 self.frame.size.height);
}

@end
