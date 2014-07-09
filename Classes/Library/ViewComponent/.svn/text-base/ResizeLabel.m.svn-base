//
//  ResizeLabel.m
//  ElongClient
//
//  Created by haibo on 11-12-13.
//  Copyright 2011 elong. All rights reserved.
//

#import "ResizeLabel.h"


@implementation ResizeLabel


- (void)dealloc {
    [super dealloc];
}


- (id)init {
	if (self = [super init]) {
		self.numberOfLines = 0;
		self.lineBreakMode = UILineBreakModeTailTruncation;
	}
	
	return self;
}


- (void)resizeByFrame:(CGRect)rect {
	originPoint = rect.origin;

	if (STRINGHASVALUE(self.text)) {
		originSize	= [self.text sizeWithFont:self.font constrainedToSize:rect.size];
	}
	else {
		originSize = rect.size;
	}
	
	self.frame = CGRectMake(originPoint.x, originPoint.y, originSize.width, originSize.height);
	constSize = self.frame.size;
}


- (void)resizeByText:(NSString *)textString {
	self.text = textString;

	self.frame = CGRectMake(originPoint.x, originPoint.y, constSize.width, constSize.height);
	originSize = [textString sizeWithFont:self.font constrainedToSize:self.frame.size];
	
	self.frame = CGRectMake(originPoint.x, originPoint.y, self.frame.size.width, originSize.height);
}


- (void)resizeByFont:(UIFont *)textFont {
	self.font = textFont;
	
	originSize = [self.text sizeWithFont:self.font constrainedToSize:self.frame.size];
	
	self.frame = CGRectMake(originPoint.x, originPoint.y, originSize.width, originSize.height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


@end
