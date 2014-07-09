//
//  OnOffView.m
//  ElongClient
//  自定义图像的开关
//
//  Created by haibo on 11-11-23.
//  Copyright 2011 elong. All rights reserved.
//

#import "OnOffView.h"


@interface OnOffView ()

@property (nonatomic, retain) UIImage *onImg;
@property (nonatomic, retain) UIImage *offImg;
@property (nonatomic, retain) UIImageView *insteadView;

@end


static int minLimitLength = 60;			// 边界最小长度

@implementation OnOffView

@synthesize on;
@synthesize onImg;
@synthesize offImg;
@synthesize insteadView;


- (void)dealloc {
	self.onImg		 = nil;
	self.offImg		 = nil;
	self.insteadView = nil;
	
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame OnImage:(UIImage *)onImage OffImage:(UIImage *)offImage {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
		self.on						= NO;
		self.image					= offImage;
		self.onImg					= onImage;
		self.offImg					= offImage;
		
		if (frame.size.width < minLimitLength && frame.size.height < minLimitLength) {
			// 如果点击区域太小，自动扩大, 并生成替代显示区
			UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
			imgView.image = self.image;
			imgView.userInteractionEnabled = YES;
			[self addSubview:imgView];
			self.insteadView = imgView;
			[imgView release];
			
			self.frame = CGRectInset(self.frame, (frame.size.width - minLimitLength)/2, (frame.size.height - minLimitLength)/2);
			
			self.image = nil;
			insteadView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
		}
    }
	
    return self;
}


- (void)setOn:(BOOL)animated {
	if (insteadView) {
		insteadView.image = animated ? onImg : offImg;
	}else {
		self.image = animated ? onImg : offImg;
	}
	
	on = animated;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if (touch) {
		self.on = !self.on;
	}
}


@end
