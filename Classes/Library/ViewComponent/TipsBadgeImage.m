//
//  TipsBadgeImage.m
//  ElongClient
//
//  Created by 赵 海波 on 12-7-19.
//  Copyright 2012 elong. All rights reserved.
//

#import "TipsBadgeImage.h"


@implementation TipsBadgeImage


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end


// =================================================================================
@implementation RoundBadgeImage


- (id)initWithImage:(UIImage *)image {
	if (self = [super initWithImage:image]) {
		self.image			= image;
		self.contentMode	= UIViewContentModeScaleToFill; 
		
		numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
		numberLabel.backgroundColor = [UIColor clearColor];
		numberLabel.textColor		= [UIColor whiteColor];
		numberLabel.textAlignment	= UITextAlignmentCenter;
		numberLabel.font			= [UIFont boldSystemFontOfSize:13];
		[self addSubview:numberLabel];
		[numberLabel release];
	}
	
	return self;
}


- (void)setNumber:(NSInteger)num {
	if (num >= 10) {
		NSInteger zoomNum = 5;				// 拉伸系数
		
		if (num >= 100) {
			zoomNum = 12;
		}
		
		CGRect rect = self.frame;
		rect.origin.x -= zoomNum;
		rect.size.width += zoomNum;
		self.frame = rect;
		
		self.image = [self.image stretchableImageWithLeftCapWidth:self.image.size.width / 2
													 topCapHeight:self.image.size.height / 2];
	}
	
	numberLabel.frame = self.bounds;
	numberLabel.text = [NSString stringWithFormat:@"%d", num];
}


- (void)dealloc {
    [super dealloc];
}


@end
