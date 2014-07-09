//
//  PlaneInfo.m
//  ElongClient
//
//  Created by dengfang on 11-1-24.
//  Copyright 2011 shoujimobile. All rights reserved.
//

#import "PlaneInfo.h"
#import "FlightDataDefine.h"
#import "Utils.h"

#define FLIGHT_PLANE_LEBEL_WIDTH 280
@implementation PlaneInfo

#pragma mark -
#pragma mark Private
- (int)getLineHeight:(NSString *)string componentWidth:(float)componentWidth {
	int height = 0;
	componentWidth -= 10;
	UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(componentWidth, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
	height += (size.height +5);
	if (height < 20) {
		height = 20;
	}
	return height;
}

- (void)setComponentHeight {
	planeTitleLabel.frame = CGRectMake(planeTitleLabel.frame.origin.x,
									   planeTitleLabel.frame.origin.y,
									   FLIGHT_PLANE_LEBEL_WIDTH,
									   [self getLineHeight:planeTitleLabel.text componentWidth:FLIGHT_PLANE_LEBEL_WIDTH]);
	planeDetailLabel.frame = CGRectMake(planeDetailLabel.frame.origin.x,
										planeDetailLabel.frame.origin.y ,
										FLIGHT_PLANE_LEBEL_WIDTH,
										[self getLineHeight:planeDetailLabel.text componentWidth:FLIGHT_PLANE_LEBEL_WIDTH]);
	bgImageView.frame = CGRectMake(bgImageView.frame.origin.x,
								   bgImageView.frame.origin.y,
								   bgImageView.frame.size.width,
								   planeDetailLabel.frame.origin.y +planeDetailLabel.frame.size.height +10);

    rootScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAINCONTENTHEIGHT);
	if (bgImageView.frame.origin.y + bgImageView.frame.size.height <= self.view.frame.size.height) {
		rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bgImageView.frame.size.height);
	} else {
		rootScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, bgImageView.frame.origin.y +bgImageView.frame.size.height +10);
	}
}

- (void)_setImage:(UIImage *)img {
	[[FlightData getFDictionary] safeSetObject:img forKey:KEY_PLANE_PIC];
	
	if (planeImageView) {
		[planeImageView endLoading];
		planeImageView.image = img;
	}
}

- (void)getNetImage {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIImage *getImg = nil;
	if ([[FlightData getFDictionary] safeObjectForKey:KEY_PLANE_PIC_URL] != [NSNull null]) {
		NSString *imgName = [[FlightData getFDictionary] safeObjectForKey:KEY_PLANE_PIC_URL];
		if (imgName != nil && [imgName hasPrefix:@"http://"]) {
			NSURL *url = [NSURL URLWithString:imgName]; 
			NSData *data = [NSData dataWithContentsOfURL:url];
			if (data == nil) {
				getImg=[UIImage imageNamed:@"bg_noflightpic.png"];
			} else {
				getImg = [UIImage imageWithData:data]; //[[UIImage alloc] initWithData:data]; 
				if (getImg == nil) {
					getImg = [UIImage imageNamed:@"bg_noflightpic.png"];
				}
			}
		} else {
			getImg=[UIImage imageNamed:@"bg_noflightpic.png"];
		}
	} else {
		getImg=[UIImage imageNamed:@"bg_noflightpic.png"];
	}
	[self performSelectorOnMainThread:@selector(_setImage:) withObject:getImg waitUntilDone:YES];
	[pool release];  
}


- (void)dpViewButtonPressed{
    if (IOSVersion_7) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 添加顶栏
	UIView *navibar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
	navibar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_header.png"]];
	[self.view addSubview:navibar];
	[navibar release];
	
	// shadow
	UIImageView *shaowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_shadow.png"]];
	[shaowView setFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, 320, 11)];
	[self.view addSubview:shaowView];
	[shaowView release];
	
	//title label
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 6, SCREEN_WIDTH -120, NAVIGATION_BAR_HEIGHT -5*2)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setFont:FONT_B18];
	[titleLabel setTextAlignment:UITextAlignmentCenter];
	[titleLabel setTextColor:[UIColor blackColor]];
	[titleLabel setText:@"机型介绍"];
	[navibar addSubview:titleLabel];
	[titleLabel release];
	
	//left button
	UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, TABITEM_DEFALUT_HEIGHT)];
	[leftBtn.titleLabel setFont:FONT_B16];
	[leftBtn setTitle:@"关闭" forState:UIControlStateNormal];
	[leftBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateNormal];
	[leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[Utils setButton:leftBtn normalImage:@"white_btn_normal.png" pressedImage:@"white_btn_press.png"];
	[leftBtn addTarget:self action:@selector(dpViewButtonPressed) forControlEvents:UIControlEventTouchUpInside];
	[navibar addSubview:leftBtn];
	[leftBtn release];
	
	NSString *planeTitle = [[FlightData getFDictionary] safeObjectForKey:KEY_PLANE_PIC_NAME];
	if ([planeTitle isEqual:[NSNull null]]) {
		planeTitle = @"暂无机型信息";
	}
	NSString *detailTitle = [[FlightData getFDictionary] safeObjectForKey:KEY_PLANE_PIC_INFO];
	if ([detailTitle isEqual:[NSNull null]]) {
		detailTitle = @"暂无机型信息";
	}
	
	planeTitleLabel.text	= planeTitle;
	planeDetailLabel.text	= detailTitle;
	
	rootScrollView.delegate = self;
	
	[self setComponentHeight];
	
	UIImage *planeImg = [[FlightData getFDictionary] safeObjectForKey:KEY_PLANE_PIC];
	if ([planeImg isKindOfClass:[UIImage class]]) {
		planeImageView.image = planeImg;
	}
	else {
		[planeImageView startLoadingByStyle:UIActivityIndicatorViewStyleGray];
		[self performSelectorInBackground:@selector(getNetImage) withObject:nil];
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	[dpViewTopBar release];
	[rootScrollView release];
	[bgImageView release];
	[planeImageView release];
	planeImageView = nil;
	[planeTitleLabel release];
	[planeDetailLabel release];
	[activityView release];
	activityView = nil;
    [super dealloc];
}
@end
