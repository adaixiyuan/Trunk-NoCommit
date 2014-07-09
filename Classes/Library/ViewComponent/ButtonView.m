//
//  ButtonView.m
//  ElongClient
//
//  Created by haibo on 11-12-22.
//  Copyright 2011 elong. All rights reserved.
//

#import "ButtonView.h"


@implementation ButtonView

@synthesize isSelected;
@synthesize canCancelSelected;
@synthesize sectionNum;
@synthesize delegate;


- (void)dealloc {
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.userInteractionEnabled = YES;
		
		isSelected			= NO;
        canCancelSelected	= YES;
		sectionNum			= -1;
    }
	
    return self;
}


- (void)setIsSelected:(BOOL)animated {
	if (animated) {
		isSelected = animated;
		[delegate ButtonViewIsPressed:self];
	}
	else if (!animated && canCancelSelected) {
		isSelected = animated;
		[delegate ButtonViewIsPressed:self];
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	self.isSelected = !self.isSelected;
    [self setIsSelected:!self.isSelected];
}


//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	if (delegate && [delegate isEqual:[NSNull null]]) {
//		if ([delegate respondsToSelector:@selector(ButtonViewDone:)]) {
//			[delegate ButtonViewDone:self];
//		}
//	}
//}


@end