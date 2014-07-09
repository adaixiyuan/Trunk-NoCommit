    //
//  CouponRule.m
//  ElongClient
//
//  Created by bin xing on 11-3-12.
//  Copyright 2011 DP. All rights reserved.
//

#import "CouponRule.h"
#import "Utils.h"

@implementation CouponRule

- (id)initFromOrderFlow:(BOOL)isInOrder {
	if (self = [super initWithTopImagePath:@"" andTitle:@"消费券使用说明" style:_NavNormalBtnStyle_]) {
		showBackHomeTip = isInOrder;
	}
	
	return self;
}

-(int)labelHeightWithNSString:(UIFont *)font string:(NSString *)string width:(int)width{
	
	CGSize expectedLabelSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, 10000) lineBreakMode:UILineBreakModeWordWrap];
	
	
	return expectedLabelSize.height;
	
}


- (void)backhome {
	if (showBackHomeTip) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:ORDER_FILL_ALERT
													   delegate:self 
											  cancelButtonTitle:@"取消"
											  otherButtonTitles:@"确认", nil];
		[alert show];
		[alert release];
	}
	else {
		[super backhome];
	}
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (0 != buttonIndex) {
		[super backhome];
	}
}

- (void)loadView {
	[super loadView];
	
	UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(3, 0, 300, 20)];
	label.font=FONT_13;
	NSString *text=NSLocalizedStringFromTable(@"couponrule", @"RuleText",nil);
	
	int height=[self labelHeightWithNSString:label.font string:text width:300];
	
	label.text=text;
	
	label.lineBreakMode=UILineBreakModeWordWrap;
	//label.textAlignment=UITextAlignmentCenter;
	label.textColor=[UIColor blackColor];
	
	label.numberOfLines=1000;
	
	label.backgroundColor=[UIColor clearColor];
	
	CGRect oldframe=label.frame;
	
	oldframe.size.height=height;
	
	label.frame=oldframe;
	
	UIScrollView *scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(7, 0, 313,SCREEN_HEIGHT -20-44)];
	scrollview.backgroundColor=[UIColor whiteColor];
	
	[scrollview addSubview:label];
	scrollview.contentSize=CGSizeMake(306, label.frame.size.height+20);
	[label release];
	[self.view addSubview:scrollview];
	
	[scrollview release];
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
    [super dealloc];
}


@end
