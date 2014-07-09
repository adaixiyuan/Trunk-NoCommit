    //
//  CardDate.m
//  ElongClient
//
//  Created by bin xing on 11-2-23.
//  Copyright 2011 DP. All rights reserved.
//
#define kYearComponent 0
#define kMonthComponent 1
#import "CardDate.h"


@interface CardDate ()

@property (nonatomic, copy) NSString *yearStr;
@property (nonatomic, copy) NSString *monthStr;
@property (nonatomic,retain) UIView *markView;

- (void)selectYear:(NSString *)year Month:(NSString *)month;
- (void)setYearAndMonthWithText:(NSString *)string;

@end


@implementation CardDate
@synthesize delegate;
@synthesize yearStr;
@synthesize monthStr;

-(id)initWithDate:(NSString *)date{
	if (self=[super init]) {
		[self setYearAndMonthWithText:date];
		
		// 生成合适的年月选项
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *yearComponents = [calendar components:(NSYearCalendarUnit) fromDate:[NSDate date]];
		NSDateComponents *monthComponents = [calendar components:(NSMonthCalendarUnit) fromDate:[NSDate date]];
		int year=[yearComponents year];
		int month=[monthComponents month];
		containYears=[[NSMutableArray alloc] init];
		for (int i=year; i<year+25;i++) {
			NSString *yearstring=[[NSString alloc] initWithFormat:@"%i年",i];
			[containYears addObject:yearstring];
			[yearstring release];
		}
		
		allMouths = [[NSMutableArray alloc] initWithObjects:
					 @"01月", @"02月", @"03月", @"04月", 
					 @"05月", @"06月", @"07月", @"08月", 
					 @"09月", @"10月", @"11月", @"12月", nil];
		
		currentMouths=[[NSMutableArray alloc] init];
		for (int i=month+1; i<13; i++) {
			NSString *monthstring;
			if (i<10) {
				monthstring=[NSString stringWithFormat:@"0%i月",i];
			}else {
				monthstring=[NSString stringWithFormat:@"%i月",i];
			}
			[currentMouths addObject:monthstring];
		}
		
		if ([currentMouths count] == 0) {
			// 如果是1年的最后一月，移除该年
			[containYears removeObjectAtIndex:0];
			[currentMouths addObjectsFromArray:allMouths];
		}
	}
	
	return self;
}

-(void)loadView{
	[super loadView];
	dpViewTopBar = [[DPViewTopBar alloc] init:[[[NSString alloc] initWithString:@"信用卡有效期"] autorelease]];
	dpViewTopBar.delegate = self;
	viewPickerView=[[UIPickerView alloc] init];
	
	[viewPickerView setFrame:CGRectMake(0, dpViewTopBar.view.frame.size.height, 320, 180)];
	viewPickerView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
	viewPickerView.showsSelectionIndicator=YES;
	viewPickerView.delegate=self;
	viewPickerView.dataSource=self;

	[self.view addSubview:dpViewTopBar.view];
	[self.view addSubview:viewPickerView];
	[viewPickerView release];
}

-(void) initStatus{
	//[viewPickerView selectRow:0 inComponent:1 animated:YES];
	// 如果有年月，就显示已有的年月，否则显示当前月的下个月
	if (STRINGHASVALUE(yearStr)) {
		if ([[containYears safeObjectAtIndex:0] isEqualToString:yearStr]) {
			// 没有已有年月或已有年月，且在到期月在今年
			realmonths = currentMouths;
		}
		else {
			realmonths = allMouths;
		}
		[viewPickerView reloadComponent:1];
		[self selectYear:yearStr Month:monthStr];
	}
}

-(void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}


- (void)selectYear:(NSString *)year Month:(NSString *)month {
	if ([containYears containsObject:year]) {
		[viewPickerView selectRow:[containYears indexOfObject:year] inComponent:0 animated:NO];
	}
	if ([realmonths containsObject:month]) {
		[viewPickerView selectRow:[realmonths indexOfObject:month] inComponent:1 animated:NO];
	}
}


- (void)setYearAndMonthWithText:(NSString *)string {
	if ([string isEqualToString:@"请选择有效期时间"]) {
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *yearComponents = [calendar components:(NSYearCalendarUnit) fromDate:[NSDate date]];
		NSDateComponents *monthComponents = [calendar components:(NSMonthCalendarUnit) fromDate:[NSDate date]];
		int year=[yearComponents year];
		int month=[monthComponents month];
		self.yearStr =[NSString stringWithFormat:@"%i年",year];
		if (month+1<10) {
			self.monthStr=[NSString stringWithFormat:@"0%i月",month+1];
		}else {
			self.monthStr=[NSString stringWithFormat:@"%i月",month+1];
		}
		return;
	}
	self.yearStr  = [string substringToIndex:5];
	self.monthStr = [string substringFromIndex:5];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView  
numberOfRowsInComponent:(NSInteger)component
{
	

	//((UIView*)[[pickerView subviews] safeObjectAtIndex:4]).backgroundColor=[UIColor whiteColor];
	//((UIView*)[[pickerView subviews] safeObjectAtIndex:10]).backgroundColor=[UIColor redColor];

	
	//((UIView*)[[pickerView subviews] lastObject]).backgroundColor=[UIColor clearColor];
	//((UIView*)[[pickerView subviews] lastObject]).backgroundColor=[UIColor clearColor];
//
//	UIImageView *pickerBg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_pickerview.png"]];
//	pickerBg.frame=CGRectMake(0, 0, 320, 175);
//	[((UIView*)[[pickerView subviews] lastObject]) addSubview:pickerBg];
	
    if (component == kMonthComponent)
        return [realmonths count];
    
    return [containYears count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component
{
    if (component == kMonthComponent)
        return [realmonths safeObjectAtIndex:row];
    
    return [containYears safeObjectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	
	if (component == kYearComponent)
	{
		if (row == 0) {
			realmonths=currentMouths;
			[viewPickerView selectRow:0 inComponent:1 animated:YES];
			
		}else{
			realmonths=allMouths;
		}
		[viewPickerView reloadComponent:1];
		
	}
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row 
		  forComponent:(NSInteger)component reusingView:(UIView *)view
{
	
	UILabel *pickerRowLabel=(UILabel *)view;
	if (pickerRowLabel == nil) { 
		// Rule 1: width and height match what the picker view expects. 
		//         Change as needed. 
		CGRect frame = CGRectMake(0.0, 0.0, 160, 44); 
		pickerRowLabel = [[[UILabel alloc] initWithFrame:frame] autorelease]; 
		// Rule 2: background color is clear. The view is positioned over 
		//         the UIPickerView chrome. 
		pickerRowLabel.backgroundColor = [UIColor clearColor]; 
		pickerRowLabel.textColor=[UIColor colorWithRed:0 green:64/255.0 blue:128/255.0 alpha:1.0];
		pickerRowLabel.textAlignment=UITextAlignmentCenter;
		[pickerRowLabel setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18]];
		// Rule 3: view must capture all touches otherwise the cell will highlight, 
		//         because the picker view uses a UITableView in its implementation. 
		pickerRowLabel.userInteractionEnabled = NO; 
	} 
	if (component==0) {
		pickerRowLabel.text = [containYears safeObjectAtIndex:row];  
	}else {
		pickerRowLabel.text = [realmonths safeObjectAtIndex:row];  
	}

	 
	return pickerRowLabel;
	
	/*
	DPUIPickerViewCell *pickerCell;
	if (component==kYearComponent) {
		pickerCell= [[[DPUIPickerViewCell alloc] MakePickerViewCell:[containYears safeObjectAtIndex:row] textFont:[UIFont systemFontOfSize:20]] autorelease];
	}else{
		pickerCell= [[[DPUIPickerViewCell alloc] MakePickerViewCell:[realmonths safeObjectAtIndex:row] textFont:[UIFont systemFontOfSize:20]] autorelease];

	}
	return pickerCell;
	 */
}
#pragma mark DPViewTopBarDelegate
- (void)dpViewLeftBtnPressed {
	[self dismissInView];
	
	[self selectYear:yearStr Month:monthStr];
}

- (void)dpViewRightBtnPressed {
	int year = [viewPickerView selectedRowInComponent:0];
	int month = [viewPickerView selectedRowInComponent:1];
	
	NSCalendar *currentCalendar = [NSCalendar currentCalendar];
	NSDateComponents *dateComponents = [currentCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:[NSDate date]];
	int currentYear	= [dateComponents year];
	int currentMonth = [dateComponents month];
	
	// 当选择年月小于当前年月时，给予提示
	BOOL dateIsRight = YES;
	if ([[[containYears safeObjectAtIndex:year] stringByReplacingOccurrencesOfString:@"年" withString:@""] intValue] < currentYear) {
		dateIsRight = NO;
	}
	
	if ([[[containYears safeObjectAtIndex:year] stringByReplacingOccurrencesOfString:@"年" withString:@""] intValue] == currentYear &&
		[[[realmonths safeObjectAtIndex:month] stringByReplacingOccurrencesOfString:@"月" withString:@""] intValue] < currentMonth) {
		dateIsRight = NO;
	}
	
	if (dateIsRight) {
		NSString *datestring=[NSString stringWithFormat:@"%@%@",[containYears safeObjectAtIndex:year],[realmonths safeObjectAtIndex:month]];
		[self setYearAndMonthWithText:datestring];
		
		[self dpViewLeftBtnPressed];
        if ([delegate respondsToSelector:@selector(cardDate:didSelectedDate:)]) {
            [self.delegate cardDate:self didSelectedDate:datestring];
        }
	}
	else {
		[PublicMethods showAlertTitle:@"信用卡有效期小于当前日期" Message:@"请重新选择"];
	}
}

- (void)showInView {
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
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
        [appDelegate.window addSubview:self.view];
    }else{
        [appDelegate.window addSubview:self.view];
    }
    
    CGRect rect		 = self.view.frame;
    rect.size.height = NAVIGATION_BAR_HEIGHT + viewPickerView.frame.size.height;
    self.view.frame  = rect;
    
    [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];		//UIViewAnimationCurveEaseOut:  slow at end
    [UIView setAnimationDuration:SHOW_WINDOWS_DEFAULT_DURATION];
    [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    self.markView.alpha = 0.8f;
    [UIView commitAnimations];
}

- (void)dismissInView {
    [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView animateWithDuration:SHOW_WINDOWS_DEFAULT_DURATION delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.view setFrame:CGRectMake(0, SCREEN_HEIGHT, self.view.frame.size.width, self.view.frame.size.height)];
        self.markView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.markView removeFromSuperview];
        self.markView = nil;
        [self.view removeFromSuperview];
    }];
}

- (void)singleTapGesture:(UITapGestureRecognizer *)gesture{
    [self dismissInView];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[currentMouths release];
	[containYears release];
	[allMouths release];
	
	self.yearStr	= nil;
	self.monthStr	= nil;
    self.markView   = nil;
	self.delegate   = nil;
    [super dealloc];
}


@end
