//
//  ElongBaseViewController.m
//  ElongClient
//
//  Created by 赵 海波 on 13-12-10.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "ElongBaseViewController.h"
#import "MainPageController.h"
#import "NavTelCallSingleton.h"

@interface ElongBaseViewController ()

@end

@implementation ElongBaseViewController

#pragma mark - Init Methods

- (id)initWithTitle:(NSString *)titleStr style:(NavBarBtnStyle)style
{
    if (self = [super init])
    {
        m_style = style;
		self.title = titleStr;
		switch (style) {
            case NavBarBtnStyleOlnyHotel:
            {
                
                [self headerView:@"btn_navback_normal.png" backSelectIcon:nil
						 telicon:nil telSelectIcon:nil
						homeicon:nil homeSelectIcon:nil];
                teliconstring = nil;
                telSelectIconstring = nil;
            }
                break;
			case NavBarBtnStyleNormalBtn:
			{
				[self headerView:@"btn_navback_normal.png" backSelectIcon:nil
						 telicon:@"btn_navtel_normal.png" telSelectIcon:nil
						homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
                teliconstring = @"btn_navtel_normal.png";
                telSelectIconstring = nil;
                
			}
				break;
			case NavBarBtnStyleNoBackBtn:
			{
				[self headerView:nil backSelectIcon:nil
						 telicon:@"btn_navtel_normal.png" telSelectIcon:nil
						homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
                teliconstring = @"btn_navtel_normal.png";
                telSelectIconstring = nil;
			}
				break;
			case NavBarBtnStyleOnlyBackBtn:
			{
				[self headerView:@"btn_navback_normal.png" backSelectIcon:nil
						 telicon:nil telSelectIcon:nil
						homeicon:nil homeSelectIcon:nil];
                teliconstring = nil;
                telSelectIconstring = nil;
			}
				break;
			case NavBarBtnStyleOnlyHomeBtn:
			{
				[self headerView:nil backSelectIcon:nil
						 telicon:nil telSelectIcon:nil
						homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
                teliconstring = nil;
                telSelectIconstring = nil;
			}
				break;
			case NavBarBtnStyleCalendarBtn:
			{
				//[self calendarHeaderView:@"btn_navback_normal.png" backSelectIcon:nil
                //							   todayicon:@"btn_default3_normal.png" todaySelectIcon:@"btn_default3_press.png"];
			}
				break;
			case NavBarBtnStyleBackShareHomeTel:
			{
				[self headerView:@"btn_navback_normal.png" backSelectIcon:nil
						 telicon:@"share" telSelectIcon:@"share"
						homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
                teliconstring = @"share";
                telSelectIconstring = @"share";
			}
				break;
                
			case NavBarBtnStyleNoTel:
			{
				[self headerView:@"btn_navback_normal.png" backSelectIcon:nil
						 telicon:nil telSelectIcon:nil
						homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
                teliconstring = nil;
                telSelectIconstring = nil;
			}
                break;
            case NavBarBtnStyleBackShare:
            {
				[self headerView:@"btn_navback_normal.png" backSelectIcon:nil
						 telicon:nil telSelectIcon:nil
						homeicon:@"btn_navshare_normal.png" homeSelectIcon:nil];
                teliconstring = nil;
                telSelectIconstring = nil;
            }
                break;
            default:
                break;
        }
        
        [self addTopImageAndTitle:nil andTitle:titleStr];
    }
    
    return self;
}


#pragma mark - end

- (void)headerView:(NSString *)backicon backSelectIcon:(NSString *)backSelectIcon
		   telicon:(NSString *)telicon telSelectIcon:(NSString *)telSelectIcon
		  homeicon:(NSString *)homeicon homeSelectIcon:(NSString *)homeSelectIcon
{
	if (backicon!=nil)
    {
        ButtonView *backbtn = [[ButtonView alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
        backbtn.image = [UIImage imageNamed:backicon];
        
        backbtn.highlightedImage = [UIImage imageNamed:backSelectIcon];
        backbtn.delegate = self;
        backbtn.tag = kBackBtnTag;
        backbtn.canCancelSelected = NO;
        UIBarButtonItem *backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        
        self.navigationItem.leftBarButtonItem = backbarbuttonitem;
        [backbtn release];
        [backbarbuttonitem release];
	} else {
		UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
        backbtn.exclusiveTouch = YES;
		UIBarButtonItem * backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
		self.navigationItem.leftBarButtonItem = backbarbuttonitem;
        [backbarbuttonitem  release];
        [backbtn  release];
	}
	
    if (telicon && homeicon)
    {
        // 多按钮情况
        NSString *leftIcon = nil;
        SEL leftBtnaction;
        
        if ([telicon isEqualToString:@"share"])
        {
            leftIcon = @"btn_navshare_normal.png";
            leftBtnaction = @selector(shareInfo);
        }
        else
        {
            leftIcon = telicon;
            leftBtnaction = @selector(calltel400);
        }
        
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarTwoButtonItemWithTarget:self leftButtonIcon:leftIcon leftButtonAction:leftBtnaction rightIcon:homeicon rightButtonAction:@selector(backhome)];
    }
    //只有返回主页的按钮
    else if (homeicon)
    {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem navBarTwoButtonItemWithTarget:self leftButtonIcon:nil leftButtonAction:nil rightIcon:homeicon rightButtonAction:@selector(backhome)];
    }
}

- (void)clickNavRightBtn{
    
    
}

- (void)cancelButtonPressed{
	[self.navigationController  popViewControllerAnimated:YES];
}

- (void)alertHeaderView:(NSString *)backicon backSelectIcon:(NSString *)backSelectIcon
                btnicon:(NSString *)btnicon btnSelectIcon:(NSString *)btnSelectIcon btnstring:(NSString *)btnstring
{
	if (backicon!=nil) {
		UIButton *backbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
        backbtn.imageEdgeInsets = EDGE_NAV_LEFTITEM;
        backbtn.exclusiveTouch = YES;
		[backbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
		[backbtn setBackgroundImage:[UIImage imageNamed:backicon] forState:UIControlStateNormal];
		if (backSelectIcon != nil) {
			[backbtn setBackgroundImage:[UIImage imageNamed:backSelectIcon] forState:UIControlStateHighlighted];
		}
		UIBarButtonItem * backbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
		self.navigationItem.leftBarButtonItem = backbarbuttonitem;
        [backbtn release];
        [backbarbuttonitem release];
	} else {
		UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 50, 30)];
        cancelButton.exclusiveTouch = YES;
		[cancelButton.titleLabel setFont:FONT_B16];
		[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
		[cancelButton setTitleColor:COLOR_NAV_BTN_TITLE forState:UIControlStateNormal];
        [cancelButton setTitleColor:COLOR_NAV_BIN_TITLE_H forState:UIControlStateHighlighted];
		[cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
		self.navigationItem.leftBarButtonItem = cancelButtonItem;
        [cancelButton release];
        [cancelButtonItem release];
	}
	
    
	if (btnicon!=nil) {
		UIButton *rightbtn;
		if ([btnstring length]<=2) {
			rightbtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
		}else if ([btnstring length]==3) {
			rightbtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 34)];
		}else {
			
			rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 34)];
		}
        
        rightbtn.exclusiveTouch = YES;
		[rightbtn setTitle:btnstring forState:UIControlStateNormal];
		[rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[[rightbtn titleLabel] setFont:FONT_B16];
        
        [rightbtn addTarget:self action:@selector(clickNavRightBtn) forControlEvents:UIControlEventTouchUpInside];
        [rightbtn setBackgroundImage:[UIImage imageNamed:btnicon] forState:UIControlStateNormal];
        if (btnSelectIcon != nil) {
            [rightbtn setBackgroundImage:[UIImage imageNamed:btnSelectIcon] forState:UIControlStateHighlighted];
        }
        UIBarButtonItem * rightbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
        self.navigationItem.rightBarButtonItem = rightbarbuttonitem;
        [rightbtn release];
        [rightbarbuttonitem release];
    }
	else {
		UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 34)];
        rightbtn.exclusiveTouch = YES;
		UIBarButtonItem *rightbarbuttonitem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
		self.navigationItem.rightBarButtonItem = rightbarbuttonitem;
        [rightbtn release];
        [rightbarbuttonitem release];
	}
    
}

-(void) dealloc
{
    HttpUtil *httpUtil = [HttpUtil shared];
    if (httpUtil.delegate==(id)self) {
        httpUtil.delegate=nil;
    }
    
    [super dealloc];
}

- (void)back {
    if (self.navigationController.viewControllers.count == 2) {
        if ([[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[MainPageController class]]) {
            [self backhome];
            return;
        }
    }
	//pop
	//[PublicMethods showAvailableMemory];
	[self.navigationController popViewControllerAnimated:YES];
}


- (void)calltel400{
    //[[UIApplication sharedApplication] _performMemoryWarning];		// 强制执行内存警告,真机有效
    
	ElongClientAppDelegate *delegate = (ElongClientAppDelegate *)[UIApplication sharedApplication].delegate;
	NSString *sheetTitle;
    
    NSArray *serviceVCArray = [NSArray arrayWithObjects:@"HotelOrderListViewController",@"HotelOrderDetailViewController",@"GrouponOrderHistoryController",@"GrouponHistoryDetailController",@"InterHotelOrderHistoryController",@"InterHotelOrderHistoryDetail",@"FlightOrderHistory",@"FlightOrderHistoryDetail",@"TrainHomeVC",@"RentCarDetailViewController",@"RentCarDetailedBillViewController", nil];
    
    sheetTitle = @"电话预订";
    for (NSString *service in serviceVCArray) {
        if ([service isEqualToString:NSStringFromClass([delegate.navigationController.visibleViewController class])]) {
            sheetTitle = @"客服电话";
            break;
        }
    }
    
    NSString *telephone = @"400-666-1166";
    // 列车客服电话
    if ([NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"TrainHomeVC"])
    {
        telephone = @"400-689-9617";
        
    }else if ([NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"RentCarDetailViewController"]||[NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"RentCarDetailedBillViewController"])
    {
        telephone = @"艺龙客服:400-689-9617";
    }
    
    //by lc copy DPNav
    
    UIActionSheet *menu;
    
    if ([NSStringFromClass([delegate.navigationController.visibleViewController class]) isEqualToString:@"XGSpecialProductDetailViewController"]) {
        NSString *currentHotelPhone = [[HotelDetailController hoteldetail] safeObjectForKey:@"Phone"];
        
        telephone = @"艺龙客服:400-666-1166";
        
        // 有多个电话，处理第一个电话
        NSArray *phoneArray = [currentHotelPhone componentsSeparatedByString:@"、"];
        NSString *firstPhone = @"";
        if (phoneArray && [phoneArray count] > 0) {
            firstPhone = [phoneArray safeObjectAtIndex:0];
        }
        
        // 有分机拨号，去掉分机拨号
        NSArray *disposeExtensionArray;
        if ([firstPhone length] > 0) {
            disposeExtensionArray = [firstPhone componentsSeparatedByString:@"-"];
            if (disposeExtensionArray && [disposeExtensionArray count] > 1) {
                currentHotelPhone = [NSString stringWithFormat:@"酒店电话:%@-%@", [disposeExtensionArray safeObjectAtIndex:0], [disposeExtensionArray safeObjectAtIndex:1]];
            }
        }
        else {
            disposeExtensionArray = [currentHotelPhone componentsSeparatedByString:@"-"];
            if (disposeExtensionArray && [disposeExtensionArray count] > 1) {
                currentHotelPhone = [NSString stringWithFormat:@"酒店电话:%@-%@", [disposeExtensionArray safeObjectAtIndex:0], [disposeExtensionArray safeObjectAtIndex:1]];
            }
            else {
                currentHotelPhone = [NSString stringWithFormat:@"酒店电话:%@", currentHotelPhone];
            }
        }
        
        
        menu =[[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:currentHotelPhone, telephone,nil];

    }else{
        menu =[[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:telephone,nil];
    }
    
    NSArray *interHotelVCArray = [NSArray arrayWithObjects:@"InterHotelOrderHistoryController",@"InterHotelOrderHistoryDetail",@"InterHotelDetailCtrl",@"InterHotelDetailIntroVC",@"InterHotelCommentVC", nil];
    for (NSString *interHotelVC in interHotelVCArray) {
        if ([interHotelVC isEqualToString:NSStringFromClass([delegate.navigationController.visibleViewController class])]) {
            
            menu = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"国内客服 400-666-1166       ",@"国际客服 +86-10-64329999",nil];
            break;
        }
    }
    
	
	menu.delegate = [NavTelCallSingleton sharedInstance];
	menu.actionSheetStyle=UIBarStyleBlackTranslucent;
	[menu showInView:delegate.window];
    menu.tag = DPNAVSHEET;
}


- (void)backhome{
    if (m_style == _NavBackShareStyle_) {
        [self performSelector:@selector(shareInfo)];
        return;
    }
    [PublicMethods closeSesameInView:nil];
    
	[Utils clearFlightData];
	[Utils clearHotelData];
}

-(void) addTopImageAndTitle:(NSString *)imgPath andTitle:(NSString *)titleStr
{
    UIView *topView = [[UIView alloc] init];
    
    int offX = 0;
    if (STRINGHASVALUE(imgPath)) {
        UIImage *topImg = [UIImage noCacheImageNamed:imgPath];
        float imgWidth  = topImg.size.width;
        float imgHeight = topImg.size.height;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (44 - imgHeight)/2, imgWidth, imgHeight)];
        imgView.image = topImg;
        [topView addSubview:imgView];
        [imgView release];
        
        offX = imgWidth;
    }
    
    CGSize size = [titleStr sizeWithFont:FONT_B18];
    if (size.width >= 200) {
        size.width = 195;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(offX + 3, 12, size.width, 20)];
    label.tag = 101;
    label.backgroundColor	= [UIColor clearColor];
    label.font				= FONT_B18;
    label.textColor			= COLOR_NAV_TITLE;
    label.text				= titleStr;
    label.textAlignment		= UITextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumFontSize = 14.0f;
    
    topView.frame = CGRectMake(0, 0, size.width + offX + 5, 44);
    [topView addSubview:label];
    [label release];
    self.navigationItem.titleView = topView;
    [topView release];
}

- (void)setNavTitle:(NSString *)title{
	
    CGSize size = [title sizeWithFont:FONT_B18];
    if (size.width >= 200) {
        size.width = 195;
    }
    
    if (self.navigationItem.titleView.frame.size.width < size.width) {
        self.navigationItem.titleView.frame = CGRectMake(self.navigationItem.titleView.frame.origin.x, self.navigationItem.titleView.frame.origin.y, size.width, self.navigationItem.titleView.frame.size.height);
    }
    
    UILabel *label = (UILabel *)[self.navigationItem.titleView viewWithTag:101];
    if (label.frame.size.width < size.width) {
        label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, size.width, label.frame.size.height);
    }
	label.text = title;
}

- (NSString *) getNavTitle{
    UILabel *label = (UILabel *)[self.navigationItem.titleView viewWithTag:101];
	return label.text;
}

- (void)setShowBackBtn:(BOOL)flag{
	if(flag){
		[self headerView:@"btn_navback_normal.png" backSelectIcon:nil
				 telicon:nil telSelectIcon:nil
				homeicon:nil homeSelectIcon:nil];
	}else {
		[self headerView:nil backSelectIcon:nil
				 telicon:teliconstring telSelectIcon:telSelectIconstring
				homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
	}
    
}

-(void) setShowBackBtnWithNoHomeBtn:(BOOL)flag{
    if(flag){
		[self headerView:@"btn_navback_normal.png" backSelectIcon:nil
				 telicon:nil telSelectIcon:nil
				homeicon:nil homeSelectIcon:nil];
	}else {
		[self headerView:nil backSelectIcon:nil
				 telicon:teliconstring telSelectIcon:telSelectIconstring
				homeicon:@"" homeSelectIcon:nil];
	}
}

-(void) setshowHome
{
    [self headerView:nil backSelectIcon:nil
             telicon:nil telSelectIcon:nil
            homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
}

- (void)setshowTelAndHome
{
    [self headerView:nil backSelectIcon:nil
             telicon:@"btn_navtel_normal.png" telSelectIcon:nil
            homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
}

- (void)setshowShareAndHome
{
    [self headerView:nil backSelectIcon:nil
             telicon:@"share" telSelectIcon:@"share"
            homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
}

- (void)setshowNormaltpyewithouthtel
{
    [self headerView:@"btn_navback_normal.png" backSelectIcon:nil
             telicon:nil telSelectIcon:nil
            homeicon:@"btn_navhome_normal.png" homeSelectIcon:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
        if (![[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault]) {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_header_gray.png"] forBarMetrics:UIBarMetricsDefault];
        }
    }
#endif
	
	self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    if (IOSVersion_7 && ![self isKindOfClass:[MainPageController class]])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark -
#pragma mark ButtonViewDelegate

- (void)ButtonViewIsPressed:(ButtonView *)button
{
	if (kBackBtnTag == button.tag)
    {
		button.highlighted = YES;
		[self performSelector:@selector(restoreStateOfButton:) withObject:button afterDelay:0.2];
		[self back];
        
        return;
	}
}

- (void)restoreStateOfButton:(ButtonView *)button
{
	button.highlighted = NO;
}




@end
