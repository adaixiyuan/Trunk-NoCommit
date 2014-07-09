//
//  XGRoomSelectController.m
//  ElongClient
//
//  Created by 李程 on 14-6-6.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "XGRoomSelectController.h"

@interface XGRoomSelectController ()
@property (nonatomic, strong) UIView *markView;
@end

@implementation XGRoomSelectController



- (id)initWithFrame:(CGRect)frame mytitle:(NSString *)title_
{
    self = [super initWithFrame:frame];
    if (self) {
        
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    topView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    
    // title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:FONT_B18];
    [titleLabel setTextAlignment:UITextAlignmentCenter];
    [titleLabel setTextColor:RGBACOLOR(52, 52, 52, 1)];
    [titleLabel setText:title_];
    [topView addSubview:titleLabel];

    
    UIImageView *topSplitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - SCREEN_SCALE, SCREEN_WIDTH, SCREEN_SCALE)];
    topSplitView.image = [UIImage noCacheImageNamed:@"dashed.png"];
    [topView addSubview:topSplitView];

    
    // left button
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [leftBtn.titleLabel setFont:FONT_B16];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [leftBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];

    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 0, 50, NAVIGATION_BAR_HEIGHT)];
    [rightBtn.titleLabel setFont:FONT_B16];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];

    
    self.viewPickerView =[[UIPickerView alloc] init];
    self.viewPickerView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    
    [self.viewPickerView setFrame:CGRectMake(0, 44, 320, frame.size.height - NAVIGATION_BAR_HEIGHT)];
    
    self.viewPickerView.showsSelectionIndicator=YES;
    self.viewPickerView.delegate=self;
    self.viewPickerView.dataSource=self;
    
    [self addSubview:topView];

    [self addSubview:self.viewPickerView];


    }
    return self;
}


- (void)showInView {
	ElongClientAppDelegate *appDelegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.markView.backgroundColor = RGBACOLOR(0, 0, 0, 1.0f);
    [appDelegate.window addSubview:self.markView];
    self.markView.alpha = 0.0f;
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    singleTapGesture.numberOfTapsRequired = 1;
    singleTapGesture.numberOfTouchesRequired = 1;
    [self.markView addGestureRecognizer:singleTapGesture];
    
    if (self.superview) {
        [self removeFromSuperview];
        [appDelegate.window addSubview:self];
    }else{
        [appDelegate.window addSubview:self];
    }
    
    // 刷新
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDuration:SHOW_WINDOWS_DEFAULT_DURATION];
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    self.markView.alpha = 0.8f;
    [UIView commitAnimations];
    
    [self reloadData];
}

- (void) reloadData{
    [self.viewPickerView reloadAllComponents];
}



- (void) cancelBtnClick{
    [self dismissInView];
}


- (void)confirmBtnClick {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(roomSelectedResult:myindex:)]) {
        
        [self.delegate roomSelectedResult:self myindex:[self.viewPickerView selectedRowInComponent:0]];
    }

    
    [self dismissInView];
}


- (void)dismissInView {
    [self setFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height)];
        self.markView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
    }];
}
- (void)singleTapGesture:(UITapGestureRecognizer *)gesture{
    [self dismissInView];
}


#pragma mark -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return 3;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//
//    return [NSString stringWithFormat:@"%d间",row];
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	
	NSLog(@"====%d",row);
//    @selector(roomSelectedResult:myindex:)
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 36;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	
	UILabel *pickerRowLabel=(UILabel *)view;
	if (pickerRowLabel == nil) {
		CGRect frame = CGRectMake(0.0, 0.0, 160, 44);
		pickerRowLabel = [[UILabel alloc] initWithFrame:frame];
		pickerRowLabel.backgroundColor = [UIColor clearColor];
		pickerRowLabel.textColor =  RGBACOLOR(52, 52, 52, 1);
		pickerRowLabel.textAlignment=UITextAlignmentCenter;
        pickerRowLabel.font = [UIFont boldSystemFontOfSize:20.0f];
		pickerRowLabel.userInteractionEnabled = NO;
	}

    pickerRowLabel.text = [NSString stringWithFormat:@"%d间",row+1];

	return pickerRowLabel;
}




@end
