//
//  RefreshControl.m
//  ElongClient
//
//  Created by bruce on 13-12-28.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "RefreshControl.h"

#define kTotalViewHeightMin                     45
#define kTriggerPointPos                        60
#define kTextBottomMargin						20
#define kArrowImageWidth                        18
#define kArrowImageHeight                       40
#define kArrowBottomMargin                      5

// 控件字体
#define	kLoadHintLabelFont						[UIFont systemFontOfSize:11.0f]

@interface RefreshControl ()

@property (nonatomic, strong) UIActivityIndicatorView	*activityView;
@property (nonatomic, strong) UILabel		*labelStat;		// 加载状态Label
@property (nonatomic, strong) UIImageView   *arrowImage;    // 加载状态箭头
@property (nonatomic, strong) UILabel       *lastUpdated;   // 上次加载Label

@property (nonatomic, assign) BOOL			refreshing;		// 正在刷新
@property (nonatomic, assign) BOOL			canRefresh;		// 是否还能够触发刷新

@property (nonatomic, assign) UIScrollView	*scrollView;	// RefreshControl所在的ScrollView

@end

@implementation RefreshControl

- (id)initInScrollView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:CGRectMake(0, -kTotalViewHeightMin, scrollView.frame.size.width, kTotalViewHeightMin)];
    if (self)
    {
		// 默认提示文案
		_startText = @"下拉可以刷新";
		_hintText = @"松开即可刷新";
		_loadingText = @"努力加载中...";
		
		// 设置RefreshControl所在的ScrollView
		_scrollView = scrollView;
        
		// 设置RefreshControl的位置
        //		[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kRefreshControlBGImageFile]]];
        [self setBackgroundColor:RGBACOLOR(245, 245, 245, 1)];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [scrollView addSubview:self];
        //
        
        // 指示箭头
        UIImageView *arrowImageTmp = [[UIImageView alloc] initWithFrame:CGRectMake(kTextBottomMargin, self.frame.size.height-kArrowImageHeight- kArrowBottomMargin, kArrowImageWidth, kArrowImageHeight)];
        [arrowImageTmp setImage:[UIImage imageNamed:@"ico_refreshblueArrow.png"]];
        [self addSubview:arrowImageTmp];
        _arrowImage = arrowImageTmp;
        
        //
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(kTextBottomMargin,
                                self.frame.size.height*0.35,
                                25,
                                25);
		[self addSubview:view];
		_activityView = view;
        
        // 状态文字 Label
        _labelStat = [[UILabel alloc] init];
        CGSize statSize = [_startText sizeWithFont:kLoadHintLabelFont];
        [_labelStat setFrame:CGRectMake(0,
										self.frame.size.height - kTextBottomMargin*2,
										scrollView.frame.size.width,
										statSize.height)];
        [_labelStat setBackgroundColor:[UIColor clearColor]];
		[_labelStat setTextColor:RGBACOLOR(93, 93, 93, 1)];
		[_labelStat setTextAlignment:NSTextAlignmentCenter];
        [_labelStat setFont:kLoadHintLabelFont];
        [_labelStat setText:_startText];
        [_labelStat setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
        [self addSubview:_labelStat];
        
        // 加载时间状态
        _lastUpdated = [[UILabel alloc] init];
        [_lastUpdated setFrame:CGRectMake(0,
										self.frame.size.height - kTextBottomMargin,
										scrollView.frame.size.width,
										statSize.height)];
        [_lastUpdated setBackgroundColor:[UIColor clearColor]];
		[_lastUpdated setTextColor:RGBACOLOR(93, 93, 93, 1)];
		[_lastUpdated setTextAlignment:NSTextAlignmentCenter];
        [_lastUpdated setFont:kLoadHintLabelFont];
        [_lastUpdated setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [self addSubview:_lastUpdated];
        
        
        _refreshing = NO;
        _canRefresh = YES;
    }
    
    return self;
}

- (void)dealloc
{
    _scrollView = nil;
}

- (void)setRefreshTime:(NSDate *)time
{
    if (time != nil)
    {
        [_lastUpdated setText:[self getFormatRefreshTime:time]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y;
    CGFloat oldOffset = [[change objectForKey:@"old"] CGPointValue].y;
    
	if (offset >= -kTotalViewHeightMin)
	{
		[self setFrame:CGRectMake(0, -kTotalViewHeightMin, self.scrollView.frame.size.width, kTotalViewHeightMin)];
	}
	else
	{
		[self setFrame:CGRectMake(0, offset, self.scrollView.frame.size.width, -offset)];
	}
	
	CGSize statSize = [_startText sizeWithFont:kLoadHintLabelFont];
    
    
    
	[_labelStat setFrame:CGRectMake(0,
									self.frame.size.height - kTextBottomMargin*2,
									_scrollView.frame.size.width,
									statSize.height)];
    [_lastUpdated setFrame:CGRectMake(0,
									self.frame.size.height - kTextBottomMargin,
									_scrollView.frame.size.width,
									statSize.height)];
    // 箭头
    [_arrowImage setFrame:CGRectMake(kTextBottomMargin, self.frame.size.height-kArrowImageHeight-kArrowBottomMargin, kArrowImageWidth, kArrowImageHeight)];
    
	
    if (_refreshing)
    {
        if (offset >= -kTriggerPointPos && !self.scrollView.dragging)
        {
            [self.scrollView setContentInset:UIEdgeInsetsMake(kTriggerPointPos, 0, 0, 0)];
        }
        
        return;
    }
    else
    {
        if (!_canRefresh)
        {
            if (offset < 0)
            {
                _canRefresh = YES;
            }
            else
            {
                return;
            }
        }
    }
    
    BOOL triggered = NO;
    
    if ((oldOffset < -kTriggerPointPos && !self.scrollView.tracking))
    {
        triggered = YES;
    }
    
    if (!triggered)
    {
        if ((offset < 0) && (offset > -kTriggerPointPos))
        {
            // 下拉可以刷新
            [_labelStat setText:_startText];
            
            [_activityView stopAnimating];
            // 箭头
            [CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			[_arrowImage layer].transform = CATransform3DIdentity;
			[CATransaction commit];
            
        }
        else if ((offset < -kTriggerPointPos))
        {
            // 松开即可刷新
            [_labelStat setText:_hintText];
            // 箭头
            
            [UIView animateWithDuration:0.18
                                  delay:0.0
                                options:nil
                             animations:^(void){
                                 _arrowImage.alpha = 1.0;
                                 _arrowImage.transform = CGAffineTransformMakeRotation(1 * M_PI);
                             }
                             completion:^(BOOL finished) {
                                 _arrowImage.alpha = 1.0;
                             }];
            
        }
    }
    else
    {
        // 松开即可刷新
        [_labelStat setText:_loadingText];
        
        // 箭头
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _arrowImage.hidden = YES;
        [CATransaction commit];
        
        [_activityView startAnimating];
        
        _refreshing = YES;
        _canRefresh = NO;
		
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)beginRefreshing:(NSDate *)time
{
    if (!_refreshing)
    {
        // 松开即可刷新
        [_labelStat setText:_loadingText];
        
        // 更新时间
        if (time == nil)
        {
            time = [NSDate date];
        }
        [_lastUpdated setText:[self getFormatRefreshTime:time]];
        
        
        // 箭头
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        _arrowImage.hidden = YES;
        [CATransaction commit];
        
        [_activityView startAnimating];
        
        
		[self.scrollView setContentOffset:CGPointMake(0, -kTriggerPointPos) animated:YES];
        
        
        _refreshing = YES;
        _canRefresh = NO;
    }
}

- (void)endRefreshing
{
    _refreshing = NO;
	
    // 松开即可刷新
    [_labelStat setText:_startText];
    
    [UIView animateWithDuration:0.4
                     animations:^ {
                         [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                     }
                     completion:^ (BOOL finished) {
						 if (finished)
						 {
                             [_activityView stopAnimating];
                             
							 [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
						 }
					 }];
}

- (void)endRefreshingWithText:(NSString *)errorText
{
	_refreshing = NO;
	
    // 松开即可刷新
    [_labelStat setText:errorText];
    
    [UIView animateWithDuration:0.4
						  delay:1
						options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                     }
                     completion:^ (BOOL finished) {
						 if (finished)
						 {
                             [_activityView stopAnimating];
                             
							 [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
						 }
					 }];
}

//
- (void)endRefreshingWithTime:(NSDate *)time
{
    _refreshing = NO;
	
    // 松开即可刷新
    [_labelStat setText:_startText];
    
    // 更新时间
    if (time == nil)
    {
        time = [NSDate date];
    }
    [_lastUpdated setText:[self getFormatRefreshTime:time]];
    
    
    
    [UIView animateWithDuration:0.4
                     animations:^ {
                         [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                     }
                     completion:^ (BOOL finished) {
						 if (finished)
						 {
                             [_activityView stopAnimating];
                             
							 [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
						 }
					 }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil)
    {
        [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    }
    else
    {
        [newSuperview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    
    [super willMoveToSuperview:newSuperview];
}

- (NSString *)getFormatRefreshTime:(NSDate *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setAMSymbol:@"AM"];
//    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    NSString *tips = [NSString stringWithFormat:@"最后更新于: %@", [formatter stringFromDate:time]];
    
    return tips;
}


@end

