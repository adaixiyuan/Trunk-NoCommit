//
//  RateBarView.m
//  ElongClient
//
//  Created by 赵 海波 on 12-12-26.
//  Copyright (c) 2012年 elong. All rights reserved.
//

#import "RateBarView.h"

@implementation RateBarView

- (void)dealloc {
    self.backColor = nil;
    self.rateColor = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame Rate:(CGFloat)rate
{
    self = [super initWithFrame:frame];
    if (self) {
        rateValue = rate;
        self.backgroundColor = [UIColor clearColor];
        //RoundCornerView
        self.backColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        self.rateColor = [UIColor colorWithRed:254/255.0 green:75/255.0 blue:32/255.0 alpha:1];
    }
    
    return self;
}

- (void) setBackColor:(UIColor *)backColor{
    [_backColor release];
    _backColor = backColor;
    [_backColor retain];
    [self setNeedsDisplay];
}

- (void) setRateColor:(UIColor *)rateColor{
    [_rateColor release];
    _rateColor = rateColor;
    [_rateColor retain];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    // draw background
	CGFloat height = self.bounds.size.height;
	CGContextTranslateCTM(context, 0.0, height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextSetLineWidth(context, 1.0);
	CGContextSaveGState(context);
	
	UIColor *pathColor = self.backColor;
    [[UIColor clearColor] setStroke];
	[pathColor setFill];
	
	CGRect rrect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	CGFloat radius = 2.0f;
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	// Start at 1
	CGContextMoveToPoint(context, minx, midy);
	// Add an arc through 2 to 3
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	// Add an arc through 4 to 5
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	// Add an arc through 6 to 7
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	// Add an arc through 8 to 9
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	// Close the path
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
	
    // draw rate
	if (rateValue > 0 && rateValue <= 1) {
		CGContextRestoreGState(context);
		[self.rateColor setFill];
		CGContextSetLineWidth(context, 1.0f);
        
		CGRect orrect = CGRectMake(0, 0, self.frame.size.width * rateValue, self.frame.size.height);
		CGFloat ominx = CGRectGetMinX(orrect), omidx = CGRectGetMidX(orrect), omaxx = CGRectGetMaxX(orrect);
		CGFloat ominy = CGRectGetMinY(orrect), omidy = CGRectGetMidY(orrect), omaxy = CGRectGetMaxY(orrect);
		
		// Start at 1
		CGContextMoveToPoint(context, ominx, omidy);
		// Add an arc through 2 to 3
		CGContextAddArcToPoint(context, ominx, ominy, omidx, ominy, radius);
		// Add an arc through 4 to 5
		CGContextAddArcToPoint(context, omaxx, ominy, omaxx, omidy, radius);
		// Add an arc through 6 to 7
		CGContextAddArcToPoint(context, omaxx, omaxy, omidx, omaxy, radius);
		// Add an arc through 8 to 9
		CGContextAddArcToPoint(context, ominx, omaxy, ominx, omidy, radius);
		// Close the path
		CGContextClosePath(context);
		CGContextDrawPath(context, kCGPathFill);
	}
}


@end
