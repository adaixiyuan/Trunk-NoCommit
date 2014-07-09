//
//  CommonSelectView.m
//  ElongClient
//
//  Created by 赵 海波 on 13-11-13.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "CommonSelectView.h"

@interface CommonSelectView ()
@property (nonatomic, retain) UIView *markView;

@end


@implementation CommonSelectView


- (void)dealloc
{
    _delegate = nil;
    if (viewPickerView)
    {
        [viewPickerView release];
    }
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame title:(NSString *)title_
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化数据
        _selectedRow = 0;
        _maxRows = 10;
        _isShowing = NO;
        
        // 标题栏
        [self makeUpTopBarWithTitle:title_];
        
        // 选择器
        [self makeUpSelectView];
    }
    
    return self;
}


#pragma mark - UI

- (void)makeUpTopBarWithTitle:(NSString *)title
{
    // 生成顶部标题栏
    UIView *topView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)] autorelease];
    topView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    [self addSubview:topView];
    
    UIImageView *shaowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
    [shaowView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, 320, 1)];
    [topView addSubview:shaowView];
    [shaowView release];
    
    UIImageView *topShadow = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_SCALE)] autorelease];
    topShadow.image = [UIImage noCacheImageNamed:@"dashed.png"];
    
    // title label
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60, 6, SCREEN_WIDTH -120, NAVIGATION_BAR_HEIGHT -5*2)] autorelease];
    titleLabel.text = title;
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:FONT_B16];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setTextColor:[UIColor blackColor]];
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [leftBtn.titleLabel setFont:FONT_B16];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(dismissInView) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    [leftBtn release];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [rightBtn.titleLabel setFont:FONT_B16];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    [rightBtn release];
    
    
    [topView addSubview:topShadow];
    [topView addSubview:titleLabel];
    [topView addSubview:leftBtn];
    [topView addSubview:rightBtn];
}


- (void)makeUpSelectView
{
    viewPickerView = [[UIPickerView alloc] init];
    [viewPickerView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT+1, 320, 180)];
    viewPickerView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    viewPickerView.showsSelectionIndicator=YES;
    viewPickerView.delegate = self;
    viewPickerView.dataSource = self;
    [self addSubview:viewPickerView];
    
}


#pragma mark - Methods

- (void)singleTapGesture:(UITapGestureRecognizer *)gesture{
    [self dismissInView];
}

- (void)setSelectedRow:(NSInteger)selectedRow
{
    if (selectedRow >= _maxRows)
    {
        selectedRow = _maxRows;
    }
        
    _selectedRow = selectedRow;
    [viewPickerView selectRow:_selectedRow inComponent:0 animated:NO];
}


- (void)dismissInView
{
    _isShowing = NO;

    [self setFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height)];
        self.markView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
    }];
    

}


- (void)showInView
{
    _isShowing = YES;
    
    ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.markView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)] autorelease];
    self.markView.backgroundColor = RGBACOLOR(0, 0, 0, 1.0f);
    [appDelegate.window addSubview:self.markView];
    self.markView.alpha = 0.0f;
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self.markView addGestureRecognizer:singleTapGesture];
    [singleTapGesture release];
    
    if (self.superview) {
        [self retain];
        [self removeFromSuperview];
        [appDelegate.window addSubview:self];
        [self release];
    }else{
        [appDelegate.window addSubview:self];
    }
    
    // 刷新
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDuration:SHOW_WINDOWS_DEFAULT_DURATION];
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT - 180-NAVIGATION_BAR_HEIGHT, self.frame.size.width, self.frame.size.height)];
    self.markView.alpha = 0.8f;
    [UIView commitAnimations];
    
}


- (void)clickRightBtn
{
	if ([_delegate respondsToSelector:@selector(selectView:didSelectedNumber:)])
    {
        [_delegate selectView:self didSelectedNumber:[viewPickerView selectedRowInComponent:0] + _originNumer];
    }
    
	[self dismissInView];
}


#pragma mark - UIPickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return _maxRows - _originNumer + 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d%@", row + _originNumer, _measureWord];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel *pickerRowLabel = (UILabel *)view;
	if (pickerRowLabel == nil) {
		// Rule 1: width and height match what the picker view expects.
		//         Change as needed.
		CGRect frame = CGRectMake(0.0, 0.0, 160, 44);
		pickerRowLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		// Rule 2: background color is clear. The view is positioned over
		//         the UIPickerView chrome.
		pickerRowLabel.backgroundColor = [UIColor clearColor];
		pickerRowLabel.textColor = RGBACOLOR(52, 52, 52, 1);
		pickerRowLabel.textAlignment = UITextAlignmentCenter;
		[pickerRowLabel setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18]];
		// Rule 3: view must capture all touches otherwise the cell will highlight,
		//         because the picker view uses a UITableView in its implementation.
		pickerRowLabel.userInteractionEnabled = NO;
	}
    
    pickerRowLabel.text = [NSString stringWithFormat:@"%d%@", row + _originNumer, _measureWord];
    
	return pickerRowLabel;
}

@end
