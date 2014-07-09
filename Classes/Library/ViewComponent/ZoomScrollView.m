//
//  ZoomScrollView.m
//  ElongClient
//  可缩放得scrollview
//
//  Created by haibo on 11-12-1.
//  Copyright 2011 elong. All rights reserved.
//

#import "ZoomScrollView.h"


@implementation ZoomScrollView

@synthesize image;

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"zoomScale"];
	
	self.image = nil;
	[imageView release];
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.delegate						= self;
		self.minimumZoomScale				= 1.0;
		self.maximumZoomScale				= 1.4;
		self.showsVerticalScrollIndicator	= NO;
		self.showsHorizontalScrollIndicator = NO;
		touchFinished = YES;
		
		imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:imageView];
		
		[self addObserver:self forKeyPath:@"zoomScale" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
	
    return self;
}


- (void)setImage:(UIImage *)img {
	imageView.image = img;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[[NSNotificationCenter defaultCenter] postNotificationName:ZOOMSCALE_NOTIFICATION 
														object:[change safeObjectForKey:NSKeyValueChangeNewKey]];
}


#pragma mark -
#pragma mark === UIScrollView Delegate ===

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {	
	return imageView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	CGFloat zs = scrollView.zoomScale;
	zs = MAX(zs, 1.0);
	zs = MIN(zs, 1.4);	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];		
	scrollView.zoomScale = zs;	
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark === UITouch Delegate ===


- (void)singleTap {
    [[NSNotificationCenter defaultCenter] postNotificationName:CLICK_NOTIFICATION object:nil];
}


- (void)doubleTap {
	CGFloat zs = self.zoomScale;
	zs = (zs == 1.0) ? 1.4 : 1.0;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];			
	self.zoomScale = zs;
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark UITouch Method

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	switch (touch.tapCount) {
		case 1:
			[self performSelector:@selector(singleTap) withObject:nil afterDelay:0.25];
			break;
		case 2:{
			[ZoomScrollView cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
			[self doubleTap];
		}
            break;
		default:
			break;
	}
}


@end
