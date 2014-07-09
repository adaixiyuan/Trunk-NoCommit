//
//  PhotoProgressView.m
//  Elong_iPad
//
//  Created by Wang Shuguang on 12-5-15.
//  Copyright 2012 elong. All rights reserved.
//

#import "PhotoProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@implementation PhotoProgressView

@synthesize progress;
- (id)init
{
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    if (self)
    {
		progress = 0.0f;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
		progress = 0.0f;
        self.backgroundColor = [UIColor clearColor];
		progressTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		progressTips.font = [UIFont boldSystemFontOfSize:(frame.size.width/4)];
		progressTips.text = @"";
		progressTips.textAlignment = UITextAlignmentCenter;
		progressTips.textColor = [UIColor colorWithRed:188.0f/255.0f green:190.0f/255.0f blue:191.0f/255.0f alpha:1.0];
		progressTips.backgroundColor = [UIColor clearColor];
		[self addSubview:progressTips];
		[progressTips release];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGPoint centerPoint = CGPointMake(rect.size.height / 2, rect.size.width / 2);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2;
    
    CGFloat pathWidth = radius * 0.3f;
    
    CGFloat radians = DEGREES_2_RADIANS((self.progress*359.9)-90);
    CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
    CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
    CGPoint endPoint = CGPointMake(xOffset, yOffset);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.3);
	CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), DEGREES_2_RADIANS(-90), NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
	CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0);
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth/2, 0, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth/2, endPoint.y - pathWidth/2, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    CGContextSetBlendMode(context, kCGBlendModeClear);;
    CGFloat innerRadius = radius * 0.7;
	CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);    
	CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
	CGContextFillPath(context);
}

#pragma mark - Property Methods


- (void)setProgress:(float)prog{
	//progressTips.text = [NSString stringWithFormat:@"%.f",prog*100];
    progress = prog;
    [self setNeedsDisplay];
}

@end