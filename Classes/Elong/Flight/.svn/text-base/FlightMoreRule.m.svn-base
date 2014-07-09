//
//  FlightMoreRule.m
//  ElongClient
//
//  Created by elong lide on 12-1-11.
//  Copyright 2012 elong. All rights reserved.
//

#import "FlightMoreRule.h"
#import "FlightDetail.h"

@implementation FlightMoreRule

@synthesize isShow;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
- (int)getLineHeight:(NSString *)string componentWidth:(float)componentWidth {
	int height = 0;
	//componentWidth -= 10;
	UIFont *font = FONT_13;
	CGSize size = [string sizeWithFont:font constrainedToSize:CGSizeMake(componentWidth, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
	height += (size.height +5);
	if (height < 20) {
		height = 20;
	}
	return height;
}

- (void)showSelectTable:(UIViewController *)controller {
    [mainView scrollRectToVisible:CGRectMake(0, 0, mainView.bounds.size.width, 10) animated:NO];
	mcontroller = controller;
	isShow = YES;
	
	if (self.view.frame.size.height <= 410 * COEFFICIENT_Y) {
		[Utils animationView:self.view
					   fromX:0
					   fromY:480 * COEFFICIENT_Y
						 toX:0
						 toY:MAINCONTENTHEIGHT - self.view.frame.size.height
					   delay:0.0f
					duration:0.3f];
	}
	else {
        if (IOSVersion_7) {
            self.transitioningDelegate = [ModalAnimationContainer shared];
            self.modalPresentationStyle = UIModalPresentationCustom;
        }
        if (IOSVersion_7) {
            [mcontroller presentViewController:self animated:YES completion:nil];
        }else{
            [mcontroller presentModalViewController:self animated:YES];
		}
	}
}
- (void)dpViewLeftBtnPressed{
	isShow = NO;
	if (self.view.frame.size.height <= 410 * COEFFICIENT_Y) {
		[Utils animationView:self.view
					   fromX:0
					   fromY:MAINCONTENTHEIGHT - self.view.frame.size.height
						 toX:0
						 toY:480 * COEFFICIENT_Y
					   delay:0.0f
					duration:0.3f];
	}
	else {
        if (IOSVersion_7) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self dismissModalViewControllerAnimated:YES];
        }
	}

	FlightDetail* flight = (FlightDetail*)mcontroller;
	flight.planeInfoButton.enabled = YES;
	
}
- (void)dpViewRightBtnPressed{
	
	
	[Utils animationView:self.view
				   fromX:0
				   fromY:480 -20 -44 -self.view.frame.size.height
					 toX:0
					 toY:480
				   delay:0.0f
				duration:0.3f];
	FlightDetail* flight = (FlightDetail*)mcontroller;
	flight.planeInfoButton.enabled = YES;
	
}


-(id)init{
	if (self = [super init]) {
		[self setReturnInfo:@"" changeInfo:@""];
		isShow = NO;
	}
	return self;
}


- (void)setReturnInfo:(NSString *)returnStr changeInfo:(NSString *)changeStr {
	returnstr = returnStr;
	changestr = changeStr;
		
	returnLabel.text = returnstr;
	changeLabel.text = changestr;
    //重新计算控件高度
	returnLabel.frame = CGRectMake(returnLabel.frame.origin.x, returnLabel.frame.origin.y,
								   290, [self getLineHeight:returnLabel.text componentWidth:290]);
	changetitleLabel.frame = CGRectMake(changetitleLabel.frame.origin.x, returnLabel.frame.origin.y +returnLabel.frame.size.height+20 ,
										changetitleLabel.frame.size.width, changetitleLabel.frame.size.height);
	lineimage.frame = CGRectMake(lineimage.frame.origin.x, returnLabel.frame.origin.y + returnLabel.frame.size.height + 10, 
								 lineimage.frame.size.width, lineimage.frame.size.height);
	changeLabel.frame = CGRectMake(changeLabel.frame.origin.x, changetitleLabel.frame.origin.y +changetitleLabel.frame.size.height,
								   290, [self getLineHeight:changeLabel.text componentWidth:290]);
	
	int contentHeight = changeLabel.frame.origin.y + changeLabel.frame.size.height + 15;
	mainView.contentSize = CGSizeMake(320, contentHeight);
	
	if (contentHeight > 416) {
		contentHeight = 416;
	}
	
	[self.view setFrame:CGRectMake(0, 480, 320, contentHeight)];
	mainView.frame = self.view.bounds;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 添加顶栏
	UIView *navibar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
	navibar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_header.png"]];
	[self.view addSubview:navibar];
	[navibar release];
	
	// topshadow
	UIImageView *topShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -15, 320, 15)];
	topShadow.image = [UIImage noCacheImageNamed:@"selecTable_shadow.png"];
	[self.view addSubview:topShadow];
	[topShadow release];
	
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
	[titleLabel setText:@"退改签规则"];
	[navibar addSubview:titleLabel];
	[titleLabel release];
	
	//left button
	UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, TABITEM_DEFALUT_HEIGHT)];
	[leftBtn.titleLabel setFont:FONT_B16];
	[leftBtn setTitle:@"关闭" forState:UIControlStateNormal];
	[leftBtn setTitleColor:COLOR_NAV_TITLE forState:UIControlStateNormal];
	[leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[Utils setButton:leftBtn normalImage:@"white_btn_normal.png" pressedImage:@"white_btn_press.png"];
	[leftBtn addTarget:self action:@selector(dpViewLeftBtnPressed) forControlEvents:UIControlEventTouchUpInside];
	[navibar addSubview:leftBtn];
	[leftBtn release];
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
	[dpViewTopBar release];
    [super dealloc];
}


@end
