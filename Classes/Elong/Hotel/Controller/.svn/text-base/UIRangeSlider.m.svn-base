//
//  UIRangeSlider.m
//  ElongClient
//
//  Created by 赵岩 on 13-5-16.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "UIRangeSlider.h"

#define kDefaultThumbSize   (20.0f)

@interface UIRangeSlider ()

@property (nonatomic, retain) UIImageView *backgroundImageView;
@property (nonatomic, retain) UIImageView *inRangeTrackImageView;
@property (nonatomic, retain) UIImageView *trankImageView;
@property (nonatomic, retain) UIImageView *minimumThumbImageView;
@property (nonatomic, retain) UIImageView *maximumThumbImageView;

@property (nonatomic, assign) UIImageView *trackingThumbView;

@end

@implementation UIRangeSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        
        _minimumValue = 0.0f;
		_maximumValue = 1.0f;
		_minimumRange = 0.0f;
        
		_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_backgroundImageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:_backgroundImageView];
		
        _inRangeTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, 0, (_maximumValue - _minimumValue) * self.frame.size.width, self.frame.size.height)];
		_inRangeTrackImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_inRangeTrackImageView];
        
		_trankImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_trankImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_trankImageView];
        
        _minimumThumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDefaultThumbSize, kDefaultThumbSize)];
        _minimumThumbImageView.backgroundColor = [UIColor clearColor];
        _minimumThumbImageView.contentMode = UIViewContentModeCenter;
        _minimumThumbImageView.center = CGPointMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
        
        _maximumThumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDefaultThumbSize, kDefaultThumbSize)];
        _maximumThumbImageView.backgroundColor = [UIColor clearColor];
        _maximumThumbImageView.contentMode = UIViewContentModeCenter;
        _minimumThumbImageView.center = CGPointMake(_maximumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
        
        [self addSubview:_minimumThumbImageView];
        [self addSubview:_maximumThumbImageView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = NO;
        
        _minimumValue = 0.0;
		_maximumValue = 1.0;
		_minimumRange = 0.0;
        
		_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_backgroundImageView.contentMode = UIViewContentModeScaleToFill;
		[self addSubview:_backgroundImageView];
		
        _inRangeTrackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, 0, (_maximumValue - _minimumValue) * self.frame.size.width, self.frame.size.height)];
		_inRangeTrackImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_inRangeTrackImageView];
        
		_trankImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_trankImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_trankImageView];
        
        _minimumThumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDefaultThumbSize, kDefaultThumbSize)];
        _minimumThumbImageView.backgroundColor = [UIColor clearColor];
        _minimumThumbImageView.contentMode = UIViewContentModeCenter;
        _minimumThumbImageView.center = CGPointMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
        
        _maximumThumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDefaultThumbSize, kDefaultThumbSize)];
        _maximumThumbImageView.backgroundColor = [UIColor clearColor];
        _maximumThumbImageView.contentMode = UIViewContentModeCenter;
        _maximumThumbImageView.center = CGPointMake(_maximumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
        
        [self addSubview:_minimumThumbImageView];
        [self addSubview:_maximumThumbImageView];
    }
    return self;
}

- (void)setHorizontalInset:(double)horizontalInset
{
    _horizontalInset = horizontalInset;
    _minimumThumbImageView.center = CGPointMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
    _maximumThumbImageView.center = CGPointMake(_maximumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
    [self updateTrackView];
}

- (void)setMinimumRange:(double)minimumRange
{
    _minimumRange = minimumRange;
    _minimumValue = 0.0f;
    _maximumValue = 1.0f;
    _minimumThumbImageView.center = CGPointMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
     _maximumThumbImageView.center = CGPointMake(_maximumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
    [self updateTrackView];
}

- (void)setMinimumValue:(double)minimumValue
{
    _minimumValue = minimumValue;
    _minimumThumbImageView.center = CGPointMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
    _maximumThumbImageView.center = CGPointMake(_maximumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
    [self updateTrackView];
}

- (void)setMaximumValue:(double)maximumValue
{
    _maximumValue = maximumValue;
    _minimumThumbImageView.center = CGPointMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
    _maximumThumbImageView.center = CGPointMake(_maximumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, self.frame.size.height / 2);
    [self updateTrackView];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    [backgroundImage retain];
    [_backgroundImage release];
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = backgroundImage;
}

- (void)setTrackImage:(UIImage *)trackImage
{
    [trackImage retain];
    [_trackImage release];
    _trackImage = trackImage;
    self.trankImageView.image = trackImage;
}

- (void)setInRangeTrackImage:(UIImage *)inRangeTrackImage
{
    [inRangeTrackImage retain];
    [_inRangeTrackImage release];
    _inRangeTrackImage = inRangeTrackImage;
    self.inRangeTrackImageView.image = inRangeTrackImage;
}

- (void)setMinimumThumbImage:(UIImage *)minimumThumbImage
{
    [minimumThumbImage retain];
    [_minimumThumbImage release];
    _minimumThumbImage = minimumThumbImage;
    self.minimumThumbImageView.image = minimumThumbImage;
}

- (void)setMaximumThumbImage:(UIImage *)maximumThumbImage
{
    [maximumThumbImage retain];
    [_maximumThumbImage release];
    _maximumThumbImage = maximumThumbImage;
    self.maximumThumbImageView.image = maximumThumbImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
    
	if (CGRectContainsPoint(CGRectInset(_minimumThumbImageView.frame, -15, -15), [touch locationInView:self])) { //if touch is beginning on min slider
		self.trackingThumbView = _minimumThumbImageView;
	} else if (CGRectContainsPoint(CGRectInset(_maximumThumbImageView.frame, -15, -15), [touch locationInView:self])) { //if touch is beginning on max slider
		self.trackingThumbView = _maximumThumbImageView;
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	
	UITouch *touch = [touches anyObject];
	
	float deltaX = [touch locationInView:self].x - [touch previousLocationInView:self].x;
	
	if (self.trackingThumbView == _minimumThumbImageView) {
        float minSrcPosX = _minimumThumbImageView.center.x;
        float minSrcPosY = _minimumThumbImageView.center.y;
		float minDesPosX = MAX(_horizontalInset, MIN(minSrcPosX + deltaX, self.frame.size.width - _horizontalInset - _minimumRange * (self.frame.size.width - 2 * _horizontalInset)));
		
		_minimumThumbImageView.center = CGPointMake(minDesPosX, minSrcPosY);
		
        float maxSrcPosX = _maximumThumbImageView.center.x;
        float maxSrcPosY = _maximumThumbImageView.center.y;
        float maxDesPosX = MIN(self.frame.size.width - _horizontalInset, MAX(minDesPosX + _minimumRange * (self.frame.size.width - 2 * _horizontalInset), maxSrcPosX));
        
		_maximumThumbImageView.center = CGPointMake(maxDesPosX, maxSrcPosY);
		
	}
    else if (self.trackingThumbView == _maximumThumbImageView) {
		float maxSrcPosX = _maximumThumbImageView.center.x;
        float maxSrcPosY = _maximumThumbImageView.center.y;
        float maxDesPosX = MIN(self.frame.size.width - _horizontalInset, MAX(maxSrcPosX + deltaX, _horizontalInset + _minimumRange * (self.frame.size.width - 2 * _horizontalInset)));
        
		_maximumThumbImageView.center = CGPointMake(maxDesPosX, maxSrcPosY);
        
        float minSrcPosX = _minimumThumbImageView.center.x;
        float minSrcPosY = _minimumThumbImageView.center.y;
		float minDesPosX = MAX(_horizontalInset, MIN(maxDesPosX - _minimumRange * (self.frame.size.width - 2 * _horizontalInset), minSrcPosX));
		
		_minimumThumbImageView.center = CGPointMake(minDesPosX, minSrcPosY);
	}
	
	[self ajustRange];
	[self updateTrackView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	[self sendActionsForControlEvents:UIControlEventTouchUpInside];
	self.trackingThumbView = nil; //we are no longer tracking either slider
}

- (void)ajustRange
{
    float minSrcPosX = _minimumThumbImageView.center.x - _horizontalInset;
    float maxSrcPosX = _maximumThumbImageView.center.x - _horizontalInset;
    float width = self.frame.size.width - 2 * _horizontalInset;
    _minimumValue = minSrcPosX / width;
    _maximumValue = maxSrcPosX / width;
}

- (void)updateTrackView
{
    self.inRangeTrackImageView.frame = CGRectMake(_minimumValue * (self.frame.size.width - 2 * _horizontalInset) + _horizontalInset, 0, (_maximumValue - _minimumValue) * (self.frame.size.width - 2 * _horizontalInset), self.frame.size.height);
}

- (void)dealloc
{
    [_minimumThumbImage release];
    [_maximumThumbImage release];
    [_backgroundImage release];
    [_inRangeTrackImage release];
    [_trackImage release];
    
    [_backgroundImageView release];
    [_inRangeTrackImageView release];
    [_trankImageView release];
    [_minimumThumbImageView release];
    [_maximumThumbImageView release];
    
    [super dealloc];
}

@end
