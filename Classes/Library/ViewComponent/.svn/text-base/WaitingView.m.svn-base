//
//  WaitingView.m
//  OpenSesameDemo
//
//  Created by haibo on 11-12-8.
//  Copyright 2011 elong. All rights reserved.
//

#import "WaitingView.h"


@implementation WaitingView


- (void)dealloc {
	CGImageRelease(alphaImage);
	[timer invalidate];
	timer = nil;
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"loading_red.png" ofType:nil];
		UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
		alphaImage = CGImageRetain(img.CGImage);
    }
	
    return self;
}


- (void)startLoading {
	drawHeight = 0;
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(fillElong) userInfo:nil repeats:YES];
	
    
    self.hidden = NO;
    
}


- (void)stopLoading {
	self.hidden = YES;
	[timer invalidate];
	timer = nil;
	
	drawHeight = 0;
}


- (void)fillElong {
	[self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGFloat height = self.bounds.size.height;
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, self.bounds.size.width, 0);
	CGContextScaleCTM(context, -1.0, 1.0);

	CGContextDrawImage(context, self.bounds, [[UIImage imageNamed:@"loading_gray.png"] CGImage]);
	CGContextClipToRect(context, CGRectMake(0, 0, self.bounds.size.width, drawHeight));
	CGContextDrawImage(context, self.bounds, alphaImage);
	
	// 灰底logo
	//UIImageView *logobg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//	[logobg setImage:[UIImage imageNamed:@"loading_gray.png"]];
//	[self addSubview:logobg];
//	[logobg release];
	
	
	//CGContextSaveGState(context);
	//[[UIColor grayColor] setFill];
	
	//CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, height - drawHeight));
	
	if (drawHeight < height + 10) {
		drawHeight ++;
	}
	else {
		drawHeight = 0;
	}
}

@end