//
//  CustomSegItem.m
//  ElongClient
//  自定义segmented的组件
//
//  Created by haibo on 11-10-28.
//  Copyright 2011 elong. All rights reserved.
//

#import "CustomSegItem.h"


@implementation CustomSegItem

@synthesize delegate;
@synthesize titleLabel;
@synthesize titleNormalColor;
@synthesize titleHighlightedColor;
@synthesize titleNormalFont;
@synthesize titleHighlightedFont;


- (void)dealloc {
	self.titleLabel				= nil;
	self.titleNormalColor		= nil;
	self.titleHighlightedColor	= nil;
	self.titleNormalFont		= nil;
	self.titleHighlightedFont	= nil;
    
	[iconImageView release];
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		label.backgroundColor	= [UIColor clearColor];
		label.textAlignment		= UITextAlignmentCenter;
		label.textColor			= [UIColor whiteColor];
		self.titleLabel			= label;
		[self addSubview:label];
		[label release];
		
		self.titleHighlightedColor = [UIColor blackColor];
        self.titleNormalColor = [UIColor whiteColor];
    }
    
    return self;
}


- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
	if (self = [super initWithImage:image highlightedImage:highlightedImage]) {
		self.userInteractionEnabled = YES;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		label.backgroundColor	= [UIColor clearColor];
		label.textAlignment		= UITextAlignmentCenter;
		label.textColor			= [UIColor whiteColor];
		self.titleLabel			= label;
		[self addSubview:label];
		[label release];
		
		titleHighlightedColor = titleNormalColor = [UIColor blackColor];
	}
	
	return self;
}


- (void)changeState:(BOOL)isPressed {
	if (isPressed) {
		self.highlighted			= YES;
		self.userInteractionEnabled	= NO;
		titleLabel.textColor		= titleHighlightedColor;
		titleLabel.font				= titleHighlightedFont;
		iconImageView.highlighted	= YES;
	}
	else {
		self.highlighted			= NO;
		self.userInteractionEnabled	= YES;
		titleLabel.textColor		= titleNormalColor;
		titleLabel.font				= titleNormalFont;
		iconImageView.highlighted	= NO;
	}
}


- (void)setTitleNormalColor:(UIColor *)color
{
    if (titleNormalColor && color != titleNormalColor)
    {
        SFRelease(titleNormalColor);
    }
    
    titleNormalColor = [color retain];
	titleLabel.textColor = color;
}


- (void)setTitleNormalFont:(UIFont *)font
{
    if (titleNormalFont && font != titleNormalFont)
    {
        SFRelease(titleNormalFont);
    }
        
    titleNormalFont = [font retain];
    titleLabel.font = font;
}


- (void)setNormalIcon:(UIImage *)iconNormal hightedIcon:(UIImage *)iconHighted {
	if (iconNormal && [iconNormal isKindOfClass:[UIImage class]]) {
		// 有图标时调整图文字得位置
		if (!iconImageView) {
			iconImageView = [[UIImageView alloc] initWithImage:iconNormal highlightedImage:iconHighted];
			
			CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:self.frame.size];
			iconImageView.frame = CGRectMake((self.frame.size.width - iconNormal.size.width - 10 - titleSize.width) / 2,
											 (self.frame.size.height - iconNormal.size.height) / 2,
											 iconNormal.size.width,
											 iconNormal.size.height);
			[self addSubview:iconImageView];
			
			titleLabel.frame = CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + 10,
										  (self.frame.size.height - titleSize.height) / 2,
										  titleSize.width,
										  titleSize.height);
		}
	}
	else {
		// 没有图标时调整文字位置
		titleLabel.frame = self.bounds;
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if (touch) {
		[delegate setHighlightedIndex:self.tag];
	}
}

@end
