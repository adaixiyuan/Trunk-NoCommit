//
//  AlertTipView.m
//  ElongClient
//
//  Created by 赵 海波 on 12-6-15.
//  Copyright 2012 elong. All rights reserved.
//

#import "AlertTipView.h"


@implementation AlertTipView

@synthesize tipString;
@synthesize stringColor;


- (void)dealloc {
	self.tipString = nil;
	self.stringColor = nil;
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame startPoint:(CGPoint)point {    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.stringColor = [UIColor redColor];
		startPoint = point;
    }
	
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect rrect = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 10);
	CGFloat radius = 2.0;
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	// Start at 1
	CGContextMoveToPoint(context, startPoint.x - 10, miny);
	CGContextAddLineToPoint(context, startPoint.x, miny - 10.0);
	CGContextAddLineToPoint(context, startPoint.x + 10, miny);
	
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	
	// Close the path
	CGContextClosePath(context);
	// Fill & stroke the path
	//CGContextDrawPath(context, kCGPathFillStroke);
	//CGContextStrokePath(context);
	CGContextClip(context);
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] =
	{
		238 / 255.0, 238 / 255.0, 238 / 255.0, 1.00,
		208 / 255.0,  208 / 255.0, 208 / 255.0, 1.00,
	};
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);	
	CGContextDrawLinearGradient(context, gradient,CGPointMake(0.0,0.0) ,CGPointMake(0.0, self.frame.size.height), kCGGradientDrawsBeforeStartLocation);
	
	CGContextFillPath(context);
	CGGradientRelease(gradient);
	
	UIGraphicsPushContext(context);
	[stringColor setFill];
	[tipString drawInRect:CGRectMake(5, 11, self.frame.size.width - 10, self.frame.size.height - 11) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	UIGraphicsPopContext();
}


@end
