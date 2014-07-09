//
//  DPViewTopBar.m
//  ElongClient
//
//  Created by dengfang on 11-1-27.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "DPViewTopBar.h"
#import "Utils.h"

@implementation DPViewTopBar
@synthesize delegate;
@synthesize titleLabel;
@synthesize leftBtn;
@synthesize rightBtn;

- (void)dpViewButtonPressed:(id)sender {
	if (sender == leftBtn) {
		[self.delegate dpViewLeftBtnPressed];
	} else {
		[self.delegate dpViewRightBtnPressed];
	}
}


- (id)init:(NSString *)titleText {
	if ((self = [super init])) {
		//view
		self.view = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)] autorelease];
		self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);

		
		//title label
		titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, SCREEN_WIDTH -120, NAVIGATION_BAR_HEIGHT -5*2)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setFont:FONT_B16];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
		[titleLabel setTextColor:[UIColor blackColor]];
		[titleLabel setText:titleText];
		
		//left button
		leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, TABITEM_DEFALUT_HEIGHT)];
		NSString *leftStr = [[NSString alloc] initWithString:@"取消"];
		[leftBtn.titleLabel setFont:FONT_B16];
		[leftBtn setTitle:leftStr forState:UIControlStateNormal];
		[leftBtn setTitle:leftStr forState:UIControlStateHighlighted];
		[leftBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
		[leftBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
		[leftBtn addTarget:self action:@selector(dpViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[leftStr release];
		
		//right button
		rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -5 -50, 5, 50, TABITEM_DEFALUT_HEIGHT)];
		NSString *rightStr = [[NSString alloc] initWithString:@"确定"];
		[rightBtn.titleLabel setFont:FONT_B16];
		[rightBtn setTitle:rightStr forState:UIControlStateNormal];
		[rightBtn setTitle:rightStr forState:UIControlStateHighlighted];
		[rightBtn setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
		[rightBtn setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
		[rightBtn addTarget:self action:@selector(dpViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[rightStr release];
        
        // splitview
        UIImageView *splitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - 1, SCREEN_WIDTH, 1)];
        splitView.image = [UIImage noCacheImageNamed:@"dashed_half.png"];
		
		[self.view addSubview:titleLabel];
		[self.view addSubview:leftBtn];
		[self.view addSubview:rightBtn];
        [self.view addSubview:splitView];
        [splitView release];
	}
	return self;
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[titleLabel release];
	[leftBtn release];
	[rightBtn release];
    [super dealloc];
}


@end
