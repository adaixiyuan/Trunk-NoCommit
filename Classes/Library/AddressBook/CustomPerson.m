    //
//  CustomPerson.m
//  ElongClient
//
//  Created by 赵 海波 on 12-8-9.
//  Copyright 2012 elong. All rights reserved.
//

#import "CustomPerson.h"

@implementation CustomPerson

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
	[navTitle release];
	
    [super dealloc];
}

- (id)initWithTitle:(NSString *)titleStr {
	if (self = [super init]) {
		navTitle = [titleStr copy];
		[self performSelector:@selector(makeTitleView)];
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self performSelector:@selector(makeBackView)];
	[self performSelector:@selector(addTopShadow)];
}


- (void)makeBackView {
	ButtonView *backbtn = [[ButtonView alloc] initWithFrame:CGRectMake(0, 0, 45, 35)];
	backbtn.image = [UIImage imageNamed:@"btn_navback_normal.png"];
	backbtn.highlightedImage = [UIImage imageNamed:nil];
	backbtn.delegate = self;
	backbtn.tag = kBackBtnTag;
	backbtn.canCancelSelected = NO;
	UIBarButtonItem * backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
	self.navigationItem.leftBarButtonItem = backbarbuttonitem;
	[backbarbuttonitem release];
	[backbtn release];
}

- (void)makeTitleView {
	UIView *topView = [[UIView alloc] init];
	
	int offX = 0;
	
	CGSize size = [navTitle sizeWithFont:FONT_B18];
	if (size.width >= 150) {
		size.width = 145;
	}
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 3, 13, size.width, 18)];
	label.tag = 101;
	label.backgroundColor	= [UIColor clearColor];
	label.font				= FONT_B18;
	label.textColor			= [UIColor blackColor];
	label.text				= navTitle;
	label.textAlignment		= UITextAlignmentCenter;
	
	topView.frame = CGRectMake(0, 0, size.width + offX + 5, 44);
	[topView addSubview:label];
	self.navigationItem.titleView = topView;
	
	[label		release];
	[topView	release];
}

#pragma mark -
#pragma mark ButtonView Delegate

- (void)ButtonViewIsPressed:(ButtonView *)button {
	button.highlighted = YES;
	[self performSelector:@selector(restoreStateOfButton:) withObject:button afterDelay:0.2];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)restoreStateOfButton:(ButtonView *)button {
	button.highlighted = NO;
}

@end
