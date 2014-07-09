//
//  CustomPageController.m
//  ElongClient
//
//  Created by haibo on 12-1-13.
//  Copyright 2012 elong. All rights reserved.
//

#import "CustomPageController.h"

#define PAGECTRTAG		876

static int diameter	= 6;			// 小点直径
static int distance = 10;			// 小点间距

@interface CustomPageController ()

@property (nonatomic, retain) UIImage *normalImage;
@property (nonatomic, retain) UIImage *highlightedImage;
@property (nonatomic, retain) UIView *displayView;

@end


@implementation CustomPageController

@synthesize currentPage;
@synthesize displayView;
@synthesize numberOfPages;
@synthesize hidesForSinglePage;
@synthesize normalImage;
@synthesize highlightedImage;

- (void)dealloc {
	self.normalImage		= nil;
	self.highlightedImage	= nil;
	self.displayView		= nil;
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame selectedImage:(UIImage *)selectedImg normalImage:(UIImage *)normalImg {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor	= [UIColor clearColor];
		
		self.normalImage		= normalImg;
		self.highlightedImage	= selectedImg;
		self.hidesForSinglePage = YES;
		
		lastPage = -1;
		
		UIView *disView  = [[UIView alloc] initWithFrame:CGRectZero];
		self.displayView = disView;
		[self addSubview:displayView];
		[disView release];
    }
	
    return self;
}


- (void)displayPageView {
	if (hidesForSinglePage) {
		if (numberOfPages == 1) {
			displayView.hidden = YES;
		}
	}
	else {
		displayView.hidden = NO;
	}
}


- (void)setNumberOfPages:(NSInteger)number {
	numberOfPages = number;
	displayView.frame  = CGRectMake(0, 0, number * (diameter + distance) - distance, diameter);
	displayView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2); 
	
	for (UIImageView *img in displayView.subviews) {
		[img removeFromSuperview];
	}
	
	for (int i = 0; i < number; i ++) {
		UIImageView *img = [[UIImageView alloc] initWithImage:normalImage highlightedImage:highlightedImage];
		img.frame	= CGRectMake(i * (diameter + distance), 0, diameter, diameter);
		img.tag		= PAGECTRTAG + i;
		[displayView addSubview:img];
		[img release];
	}
	
	[self displayPageView];
}


- (void)setCurrentPage:(NSInteger)number {
	currentPage = number;
	
	UIImageView *img = (UIImageView *)[displayView viewWithTag:PAGECTRTAG + number];
	if ([img isKindOfClass:[UIImageView class]]) {
		img.highlighted = YES;
	}
	
	UIImageView *lastImg = (UIImageView *)[displayView viewWithTag:PAGECTRTAG + lastPage];
	if ([lastImg isKindOfClass:[UIImageView class]]) {
		lastImg.highlighted = NO;
	}
	
	lastPage = currentPage;
}


- (void)setHidesForSinglePage:(BOOL)hide {
	hidesForSinglePage = hide;
	
	[self displayPageView];
}

@end
