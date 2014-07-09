//
//  FStatusListVC.m
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FStatusListVC.h"
#import "FStatusListInfos.h"
#import "FStatusDetailVC.h"


// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kFStatusListScreenToolBarHeight               20
#define kFStatusListNavBarHeight                      44
#define kFStatusListBottomViewHeight                  44
#define kFStatusListFilterButtonBadgeWidth            4
#define kFStatusListFilterButtonBadgeHeight           4
#define kFStatusListSortPriceIconWidth                21
#define kFStatusListSortPriceIconHeight               17
#define kFStatusListSortTimeIconWidth                 25
#define kFStatusListSortTimeIconHeight                17
#define kFStatusListFilterIconWidth                   14
#define kFStatusListFilterIconHeight                  17
#define kFStatusListCellSeparateLineHeight            1
#define kFStatusListCellHeight                        68
#define kFStatusListCellArrowIconWidth                5
#define kFStatusListCellArrowIconHeight               9
#define kFStatusListCellFlightInfoWidth               98
#define kFStatusListCorpIconWidth                     16
#define kFStatusListCorpIconHeight                    16

// 边框局
#define kFStatusListTableViewHMargin                  8
#define kFStatusListTableViewVMargin                  10
#define kFStatusListBottomMiddleYMargin               3
#define kFStatusListFilterButtonHMargin               15
#define kFStatusListCellHMargin                       12
#define kFStatusListCellVMargin                       13
#define kFStatusListCellMiddleHMargin                 3

// 控件Tag
enum FStatusListVCTag {
    kFStatusListSortTimeButtonTag = 100,
    kFStatusListSortPriceButtonTag,
    kFStatusListSortPriceIconTag,
    kFStatusListSortPriceLabelTag,
    kFStatusListSortTimeIconTag,
    kFStatusListSortTimeLabelTag,
    kFStatusListFilterIconTag,
    kFStatusListFilterLabelTag,
    kFStatusListBottomFilterButtonTag,
    kFStatusListBottomFilterButtonBadgeTag,
    kFStatusListBottomSortButtonTag,
    kFStatusListCellRightArrowTag,
    kFStatusListCellCellNoResultHintLabelTag,
    kFStatusListStatusLabelTag,
    kFStatusListCellInfo1ViewTag,
    kFStatusListCellInfo2ViewTag,
    kFStatusListAirCorpIconTag,
    kFStatusListFlightNumberLabelTag,
    kFStatusListFlightDepAirportLabelTag,
    kFStatusListFlightDepTimeLabelTag,
    kFStatusListFlightCorpNameLabelTag,
    kFStatusListFlightArrAirportLabelTag,
    kFStatusListFlightArrTimeLabelTag,
    kFStatusListCellBottomLineTag,
};


@implementation FStatusListVC


- (void)dealloc
{
    [_tableViewList setDelegate:nil];
    [_tableViewList setDataSource:nil];
    [_tableViewList removeFromSuperview];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //
    _arrayFlightInfos = [_fStatusListCur arrayListInfos];
    
    // 初始化排序为升序
    _isTimeAscending = YES;
    // 排序
    [self sortDataStart];
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    UITableViewCell *cell = [_tableViewList cellForRowAtIndexPath:_selectedIndexPath];
    if (cell.isSelected) {
        [cell setSelected:NO animated:YES];
    }
}


// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
// 时间排序
- (void)sortTimePressed:(id)sender
{
    _isTimeAscending = !_isTimeAscending;
    
    // 进行排序
    [self sortDataStart];
    
    // 刷新界面
    if (_viewBottom != nil)
    {
        [self setupViewBottomSubs:_viewBottom];
    }
}

// 筛选按钮
- (void)filterButtonPressed:(id)sender
{
    NSMutableArray *airlinesArray = [NSMutableArray arrayWithArray:[self getAirlinesArray:_arrayFlightInfos]];
    NSMutableArray *departArray = [NSMutableArray arrayWithArray:[self getDepartArray:_arrayFlightInfos]];
    NSMutableArray *arrivalArray = [NSMutableArray arrayWithArray:[self getArrivalArray:_arrayFlightInfos]];
    
    
    if (_filterNav == nil) {
        FlightSearchFilterController *flightFilterTmp = [[FlightSearchFilterController alloc] initWithAirlineArray:airlinesArray departureAirportArray:departArray arrivalAirportArray:arrivalArray];
        flightFilterTmp.filterDelegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:flightFilterTmp];
        self.filterNav = nav;
    }
    
    if (IOSVersion_7) {
        _filterNav.transitioningDelegate = [ModalAnimationContainer shared];
        _filterNav.modalPresentationStyle = UIModalPresentationCustom;
    }
    if (IOSVersion_7) {
        [self presentViewController:_filterNav animated:YES completion:nil];
    }else{
        [self presentModalViewController:_filterNav animated:YES];
    }
}


// =======================================================================
#pragma mark - 筛选回调
// =======================================================================
- (void) searchFilterController:(SearchFilterController *)filter didFinishedWithInfo:(NSDictionary *)info
{
    // 保存筛选类型
    _filterInfo = info;
    
    // 进行条件筛选
    [self setArrayFlightInfos:[self filterListData:[_fStatusListCur arrayListInfos]]];
    
    // 排序结束进行排序
    [self sortDataStart];
    
    // 设置筛选按钮的标示icon
    UIImageView *badgeIcon = (UIImageView *)[[self view] viewWithTag:kFStatusListBottomFilterButtonBadgeTag];
    if (badgeIcon != nil)
    {
        if ([_arrayFlightInfos count] < [[_fStatusListCur arrayListInfos] count])
        {
            [badgeIcon setHidden:NO];
        }
        else
        {
            [badgeIcon setHidden:YES];
        }
    }
}

- (void)searchFilterControllerDidCancel:(SearchFilterController *)filter
{
    
}

// ===========================================
#pragma mark - FStatusDetailDelgt
// ===========================================
- (void)fStatusDetailBack:(BOOL)isSuccess withMessage:(NSString *)resultMsg
{
    if (isSuccess)
    {
        FStatusDetailVC *controller = [[FStatusDetailVC alloc] init];
        
        [controller setFStatusDetail:_fStatusDetail];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        [Utils alert:resultMsg];
    }
}


// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
// 进行数据筛选
- (NSArray *)filterListData:(NSArray *)arrayFlightInfoTmp
{
    NSMutableArray *arrayInfos = [NSMutableArray arrayWithArray:arrayFlightInfoTmp];
    NSMutableArray *arrayFilteResult = [[NSMutableArray alloc] init];
    
    // 根据航空公司进行筛选
//    NSArray *arrayFilterTmp = nil;
    NSArray *arrayAirCorpFilter = [NSMutableArray arrayWithArray:[_filterInfo safeObjectForKey:[NSString stringWithFormat:@"%d", FilterAirline]]];
    if (arrayAirCorpFilter != nil && [arrayAirCorpFilter count] > 0)
    {
        for (NSInteger index = 0; index < [arrayInfos count]; index++)
        {
            FStatusListInfos *fStatusInfo = [arrayInfos safeObjectAtIndex:index];
            if ([arrayAirCorpFilter containsObject:[fStatusInfo flightCompany]])
            {
                [arrayFilteResult addObject:fStatusInfo];
            }
        }
    }
    
    
    // 根据起飞机场进行筛选
    NSMutableArray *arrayFilteDepart = [[NSMutableArray alloc] init];
    NSArray *arrayDepartAirportFilter = [_filterInfo safeObjectForKey:[NSString stringWithFormat:@"%d", FilterDepartureAirport]];
    if (arrayDepartAirportFilter != nil && [arrayDepartAirportFilter count] > 0)
    {
        for (NSInteger index = 0; index < [arrayFilteResult count]; index++)
        {
            FStatusListInfos *fStatusInfo = [arrayFilteResult safeObjectAtIndex:index];
            if ([arrayDepartAirportFilter containsObject:[fStatusInfo flightDepAirport]])
            {
                [arrayFilteDepart addObject:fStatusInfo];
            }
        }
        
        // 保存
        arrayFilteResult = [NSMutableArray arrayWithArray:arrayFilteDepart];
    }
    
    
    // 根据降落机场进行筛选
    NSMutableArray *arrayFilteArrive = [[NSMutableArray alloc] init];
    NSArray *arrayArriveAirportFilter = [_filterInfo safeObjectForKey:[NSString stringWithFormat:@"%d", FilterArrivalAirport]];
    if (arrayArriveAirportFilter != nil && [arrayArriveAirportFilter count] > 0)
    {
        for (NSInteger index = 0; index < [arrayFilteResult count]; index++)
        {
            FStatusListInfos *fStatusInfo = [arrayFilteResult safeObjectAtIndex:index];
            if ([arrayArriveAirportFilter containsObject:[fStatusInfo flightArrAirport]])
            {
                [arrayFilteArrive addObject:fStatusInfo];
            }
        }
        
        // 保存
        arrayFilteResult = [NSMutableArray arrayWithArray:arrayFilteArrive];
    }
    
    
    
    return arrayFilteResult;
}

// 进行排序
- (void)sortDataStart
{
    // 时间排序
    NSSortDescriptor * sortDes	= [[NSSortDescriptor alloc] initWithKey:@"flightDeptimePlan" ascending:_isTimeAscending];
    NSArray * descriptors = [NSArray arrayWithObject:sortDes];
    [self setArrayFlightInfos:[NSArray arrayWithArray:[_arrayFlightInfos sortedArrayUsingDescriptors:descriptors]]];
    
    [_tableViewList reloadData];
    
}



- (NSMutableArray *)getAirlinesArray:(NSArray *)dataArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (FStatusListInfos *listInfo in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ((listInfo != nil) && ([listInfo flightCompany]) && [[listInfo flightCompany] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			[array addObject:[listInfo flightCompany]];
		}
	}
	
	return array;
}

- (NSMutableArray *)getDepartArray:(NSArray *)dataArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (FStatusListInfos *listInfo in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ((listInfo != nil) && ([listInfo flightDepAirport]) && [[listInfo flightDepAirport] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			//isHave = NO;
			[array addObject:[listInfo flightDepAirport]];
		}
	}
   
    return array;
}

- (NSMutableArray *)getArrivalArray:(NSArray *)dataArray {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (FStatusListInfos *listInfo in dataArray) {
		BOOL isHave = NO;
		for (NSString *str in array) {
			if ((listInfo != nil) && ([listInfo flightArrAirport]) && [[listInfo flightArrAirport] isEqualToString:str]) {
				isHave = YES;
				break;
			}
		}
		if (!isHave) {
			[array addObject:[listInfo flightArrAirport]];
		}
	}
	
	return array;
}


// =======================================================================
#pragma mark - 布局函数
// =======================================================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
	
	// 子窗口高宽
    NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = SCREEN_HEIGHT;
    
    // =======================================================================
    // 导航栏
    // =======================================================================
    // 导航栏高度
    spaceYEnd -= kFStatusListNavBarHeight+kFStatusListScreenToolBarHeight;
    [self addTopImageAndTitle:nil andTitle:@"航班列表"];
    [self setShowBackBtn:YES];

    
    
    // =======================================================================
    // 底部视图
    // =======================================================================
    UIView *viewBottomTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYEnd - kFStatusListBottomViewHeight, parentFrame.size.width, kFStatusListBottomViewHeight)];
    [viewBottomTmp setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [self setupViewBottomSubs:viewBottomTmp];
    [viewParent addSubview:viewBottomTmp];
    _viewBottom = viewBottomTmp;
    
    // 子窗口大小
    spaceYEnd -= kFStatusListBottomViewHeight;
    
    
    // =======================================================================
    // 搜索条件TableView
    // =======================================================================
    // 创建TableView
	UITableView *tableViewParamTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewParamTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
										   spaceYEnd-spaceYStart)];
	[tableViewParamTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViewParamTmp setScrollEnabled:YES];
	[tableViewParamTmp setDataSource:self];
	[tableViewParamTmp setDelegate:self];
	
	// 设置TableView的背景色
	if ([tableViewParamTmp respondsToSelector:@selector(setBackgroundView:)] == YES)
	{
		// 3.2以后的版本
		UIView *viewBackground = [[UIView alloc] initWithFrame:CGRectZero];
		[tableViewParamTmp setBackgroundView:viewBackground];
	}
	
	[tableViewParamTmp setBackgroundColor:[UIColor clearColor]];
	
    // 保存
	[self setTableViewList:tableViewParamTmp];
	[viewParent addSubview:tableViewParamTmp];
    
}

// 创建BottomView的子界面
- (void)setupViewBottomSubs:(UIView *)viewParent
{
    // 移除子view
    for(UIView *subview in [viewParent subviews])
    {
        if (subview != nil)
        {
            [subview removeFromSuperview];
        }
    }
    
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    
    
    
    // =====================================================
    // 时间排序按钮
    // =====================================================
    CGSize sortBtnSize = CGSizeMake(parentFrame.size.width/2, parentFrame.size.height);
    
    UIButton *buttonSortTime = (UIButton *)[viewParent viewWithTag:kFStatusListSortTimeButtonTag];
    if (buttonSortTime == nil)
    {
        buttonSortTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonSortTime addTarget:self action:@selector(sortTimePressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonSortTime setTag:kFStatusListSortTimeButtonTag];
        // 保存
        [viewParent addSubview:buttonSortTime];
    }
    [buttonSortTime setFrame:CGRectMake(spaceXStart, 0, sortBtnSize.width, sortBtnSize.height)];
    
    // 子窗口大小
    spaceXStart += sortBtnSize.width;
    
    // 创建子界面
    [self setupSortTimeButton:buttonSortTime];
    
    
    // =====================================================
    // 筛选按钮
    // =====================================================
    CGSize filterBtnSize = CGSizeMake(parentFrame.size.width/2, parentFrame.size.height);
    
    UIButton *buttonFilter  = (UIButton *)[viewParent viewWithTag:kFStatusListBottomFilterButtonTag];
    if (buttonFilter == nil)
    {
        buttonFilter = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonFilter addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonFilter setTag:kFStatusListBottomFilterButtonTag];
        // 保存
        [viewParent addSubview:buttonFilter];
    }
    [buttonFilter setFrame:CGRectMake(spaceXStart, 0, filterBtnSize.width, filterBtnSize.height)];
    
    // 创建子界面
    [self setupFilterButton:buttonFilter];
}

// 创建时间排序按钮
- (void)setupSortTimeButton:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // 排序提示文案
    NSString *sortText = @"时间";
    CGSize sortTextSize = [sortText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // =====================================================
    // 排序图标
    // =====================================================
    CGSize iconSize = CGSizeMake(kFStatusListSortTimeIconWidth, kFStatusListSortTimeIconHeight);
    
    // 计算间隔
    NSInteger spaceYmargin = (parentFrame.size.height-sortTextSize.height-iconSize.height)/2;
    spaceYStart += spaceYmargin;
    
    UIImageView *sortIcon = (UIImageView *)[viewParent viewWithTag:kFStatusListSortTimeIconTag];
    if (sortIcon == nil)
    {
        sortIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [sortIcon setImage:_isTimeAscending ? [UIImage imageNamed:@"ico_timeorder_descending.png"] : [UIImage imageNamed:@"ico_timeorder_ascending.png"]];
        
        [sortIcon setTag:kFStatusListSortTimeIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:sortIcon];
        
    }
    [sortIcon setFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    // 子窗口大小
    spaceYStart += iconSize.height;
    // 间隔
    spaceYStart += kFStatusListBottomMiddleYMargin;
    
    // =====================================================
    // 排序提示文字
    // =====================================================
    UILabel *labelText = (UILabel *)[viewParent viewWithTag:kFStatusListSortTimeLabelTag];
    if (labelText == nil)
    {
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
//        [labelText setTextColor:RGBACOLOR(254, 75, 32, 1)];
        [labelText setTextColor:[UIColor whiteColor]];
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setTag:kFStatusListSortTimeLabelTag];
        // 保存
        [viewParent addSubview:labelText];
    }
    [labelText setFrame:CGRectMake(parentFrame.size.width * 0.4, spaceYStart, sortTextSize.width, sortTextSize.height)];
    [labelText setText:sortText];
}

// 创建筛选按钮
- (void)setupFilterButton:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // 筛选提示文案
    NSString *filterText = @"筛选";
    CGSize filterTextSize = [filterText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // =====================================================
    // 筛选图标
    // =====================================================
    CGSize iconSize = CGSizeMake(kFStatusListFilterIconWidth, kFStatusListFilterIconHeight);
    
    // 计算间隔
    NSInteger spaceYmargin = (parentFrame.size.height-filterTextSize.height-iconSize.height)/2;
    spaceYStart += spaceYmargin;
    
    UIImageView *filterIcon = (UIImageView *)[viewParent viewWithTag:kFStatusListFilterIconTag];
    if (filterIcon == nil)
    {
        filterIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [filterIcon setImage:[UIImage imageNamed:@"ico_filterbuttonicon.png"]];
        [filterIcon setTag:kFStatusListFilterIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:filterIcon];
        
    }
    [filterIcon setFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    
    // =====================================================
    // 筛选标志Icon
    // =====================================================
    CGSize filterBadgeSize = CGSizeMake(kFStatusListFilterButtonBadgeWidth, kFStatusListFilterButtonBadgeHeight);
    UIImageView *badgeIcon = (UIImageView *)[viewParent viewWithTag:kFStatusListBottomFilterButtonBadgeTag];
    if (badgeIcon == nil)
    {
        badgeIcon = [[UIImageView alloc] initWithFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2+iconSize.width*1.3, spaceYStart, filterBadgeSize.width, filterBadgeSize.height)];
        [badgeIcon setImage:[UIImage imageNamed:@"filterButtonBadge.png"]];
        [badgeIcon setTag:kFStatusListBottomFilterButtonBadgeTag];
        if ([_arrayFlightInfos count] < [[_fStatusListCur arrayListInfos] count])
        {
            [badgeIcon setHidden:NO];
        }
        else
        {
            [badgeIcon setHidden:YES];
        }
        [viewParent addSubview:badgeIcon];
    }
    
    // 子窗口大小
    spaceYStart += iconSize.height;
    // 间隔
    spaceYStart += kFStatusListBottomMiddleYMargin;
    
    
    // =====================================================
    // 筛选提示文字
    // =====================================================
    UILabel *labelText = (UILabel *)[viewParent viewWithTag:kFStatusListFilterLabelTag];
    if (labelText == nil)
    {
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        [labelText setTextColor:[UIColor whiteColor]];
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setTag:kFStatusListFilterLabelTag];
        // 保存
        [viewParent addSubview:labelText];
    }
    [labelText setFrame:CGRectMake((parentFrame.size.width-filterTextSize.width)/2, spaceYStart, filterTextSize.width, filterTextSize.height)];
    [labelText setText:filterText];
}

// 设置航班信息View的子界面
- (void)setupCellFStatusInfoSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize forInfo:(FStatusListInfos *)fStatusInfo
{
    // 子窗口高度
	NSInteger spaceXStart=0;
	NSInteger spaceXEnd = pViewSize->width;
	NSInteger spaceYStart = 0;
    NSInteger spaceYEnd = pViewSize->height;
    
    
    CGSize bottomLineSize = CGSizeMake(pViewSize->width, kFStatusListCellSeparateLineHeight);
    UIImageView *imageViewBottomLine = (UIImageView *)[viewParent viewWithTag:kFStatusListCellBottomLineTag];
    if (imageViewBottomLine == nil)
    {
        imageViewBottomLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewBottomLine setImage:[UIImage imageNamed:@"dashed.png"]];
        [imageViewBottomLine setTag:kFStatusListCellBottomLineTag];
        [imageViewBottomLine setAlpha:0.7];
        
        // 添加到父窗口
        [viewParent addSubview:imageViewBottomLine];
    }
    [imageViewBottomLine setFrame:CGRectMake(0, pViewSize->height-bottomLineSize.height, bottomLineSize.width,bottomLineSize.height)];
    
	
	/* 间隔 */
	spaceXStart += kFStatusListCellHMargin;
    spaceXEnd -= kFStatusListCellHMargin;
    spaceYStart += kFStatusListCellVMargin;
    spaceYEnd -= kFStatusListCellVMargin;
    
    // =====================================================
    // 箭头
    // =====================================================
    // arrow Icon
    CGSize iconSize = CGSizeMake(kFStatusListCellArrowIconWidth, kFStatusListCellArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kFStatusListCellRightArrowTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        [arrowIcon setBackgroundColor:[UIColor clearColor]];
        [arrowIcon setTag:kFStatusListCellRightArrowTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(spaceXEnd-iconSize.width, (pViewSize->height-iconSize.height)/2, iconSize.width, iconSize.height)];
    
    // 子窗口高宽
    spaceXEnd -= iconSize.width;
    // 间隔
    spaceXEnd -= kFStatusListCellHMargin;
    
    
    // =====================================================
    // 航班状态
    // =====================================================
    NSString *flightStatus = [fStatusInfo flightState];
    if (STRINGHASVALUE(flightStatus))
    {
        UIColor *textColor = [UIColor whiteColor];
        NSNumber *statusCode = [fStatusInfo flightStateCode];
        if (statusCode != nil)
        {
            textColor = [Utils getFlightStatusColor:[statusCode integerValue]];
        }
        
        CGSize statusSize = [flightStatus sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:14]];
        
        // 创建Label
        UILabel *labelStatus = (UILabel *)[viewParent viewWithTag:kFStatusListStatusLabelTag];
        if (labelStatus == nil)
        {
            labelStatus = [[UILabel alloc] init];
            [labelStatus setBackgroundColor:[UIColor clearColor]];
            [labelStatus setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:14]];
            [labelStatus setTag:kFStatusListStatusLabelTag];
            [labelStatus setTextAlignment:NSTextAlignmentLeft];
            
            [viewParent addSubview:labelStatus];
        }
        [labelStatus setFrame:CGRectMake(spaceXEnd-statusSize.width, (pViewSize->height-statusSize.height)/2,statusSize.width, statusSize.height)];
        [labelStatus setTextColor:textColor];
        [labelStatus setText:flightStatus];
        
        // 子窗口大小
        spaceXEnd -= statusSize.width;
        // 间隔
        spaceXEnd -= kFStatusListCellHMargin;
    }
    
    // =====================================================
    // R1 View
    // =====================================================
    CGSize viewR1Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
    
    UIView *viewR1 = [viewParent viewWithTag:kFStatusListCellInfo1ViewTag];
    if (viewR1 == nil)
    {
        viewR1 = [[UIView alloc] initWithFrame:CGRectZero];
        [viewR1 setTag:kFStatusListCellInfo1ViewTag];
        // 保存
        [viewParent addSubview:viewR1];
    }
    [viewR1 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR1Size.width, viewR1Size.height)];
    
    // 创建子界面
    [self setupCellFStatusInfoR1Subs:viewR1 inSize:&viewR1Size forInfo:fStatusInfo];
    
    
    
    // =====================================================
    // R2 View
    // =====================================================
    CGSize viewR2Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
    
    UIView *viewR2 = [viewParent viewWithTag:kFStatusListCellInfo2ViewTag];
    if (viewR2 == nil)
    {
        viewR2 = [[UIView alloc] initWithFrame:CGRectZero];
        [viewR2 setTag:kFStatusListCellInfo2ViewTag];
        // 保存
        [viewParent addSubview:viewR2];
    }
    [viewR2 setFrame:CGRectMake(spaceXStart, spaceYEnd, viewR2Size.width, viewR2Size.height)];
    
    // 创建子界面
    [self setupCellFStatusInfoR2Subs:viewR2 inSize:&viewR2Size forInfo:fStatusInfo];
    [viewR2 setViewY:spaceYEnd-viewR2Size.height];
    
}

// 创建列车信息R1View的子界面
- (void)setupCellFStatusInfoR1Subs:(UIView*)viewParent inSize:(CGSize *)pViewSize forInfo:(FStatusListInfos *)fStatusInfo
{
    // 子窗口高度
	NSInteger spaceXStart=0;
    NSInteger subsHeight = 0;
    
    
    // =======================================
    // 航班图标
    // =======================================
    NSString *airCorpName = [fStatusInfo flightCompany];
    if (STRINGHASVALUE(airCorpName))
    {
        UIImageView *flightIcon = (UIImageView *)[viewParent viewWithTag:kFStatusListAirCorpIconTag];
        if (flightIcon == nil)
        {
            flightIcon = [[UIImageView alloc] init];
            [flightIcon setBackgroundColor:[UIColor clearColor]];
            [flightIcon setTag:kFStatusListAirCorpIconTag];
            // 保存
            [viewParent addSubview:flightIcon];
            
        }
        [flightIcon setImage:[UIImage imageNamed:[Utils getAirCorpPicName:airCorpName]]];
        [flightIcon setFrame:CGRectMake(spaceXStart, 0, kFStatusListCorpIconWidth, kFStatusListCorpIconHeight)];
    }
    // 航班号
    NSString *flightNo = [fStatusInfo flightNo];
    if (STRINGHASVALUE(flightNo))
    {
        UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:17];
        CGSize numberSize = [flightNo sizeWithFont:textFont];
        
        UILabel *labelNum = (UILabel *)[viewParent viewWithTag:kFStatusListFlightNumberLabelTag];
        if (labelNum == nil)
        {
            labelNum = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelNum setBackgroundColor:[UIColor clearColor]];
            [labelNum setFont:textFont];
            [labelNum setTextColor:RGBACOLOR(52, 52, 52, 1)];
            [labelNum setTextAlignment:UITextAlignmentLeft];
            [labelNum setAdjustsFontSizeToFitWidth:YES];
            [labelNum setMinimumFontSize:10.0f];
            [labelNum setTag:kFStatusListFlightNumberLabelTag];
            // 保存
            [viewParent addSubview:labelNum];
        }
        
        [labelNum setFrame:CGRectMake(spaceXStart+kFStatusListCorpIconWidth, 0, numberSize.width, numberSize.height)];
        [labelNum setText:flightNo];
        
        // 子窗口大小
        spaceXStart += kFStatusListCellFlightInfoWidth;
        if (numberSize.height > subsHeight)
        {
            subsHeight = numberSize.height;
        }
    }
    
    
	// =======================================
    // 起飞机场
    // =======================================
    NSString *flightDepAirport = [fStatusInfo flightDepAirport];
    if (STRINGHASVALUE(flightDepAirport))
    {
        UIFont *textFont = [UIFont fontWithName:@"STHeitiJ-Light" size:14.0f];
        CGSize airportSize = [flightDepAirport sizeWithFont:textFont];
        
        UILabel *labelAirport = (UILabel *)[viewParent viewWithTag:kFStatusListFlightDepAirportLabelTag];
        if (labelAirport == nil)
        {
            labelAirport = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelAirport setBackgroundColor:[UIColor clearColor]];
            [labelAirport setFont:textFont];
            [labelAirport setTextColor:RGBACOLOR(138, 138, 138, 1)];
            [labelAirport setTextAlignment:UITextAlignmentLeft];
            [labelAirport setAdjustsFontSizeToFitWidth:YES];
            [labelAirport setMinimumFontSize:10.0f];
            [labelAirport setTag:kFStatusListFlightDepAirportLabelTag];
            // 保存
            [viewParent addSubview:labelAirport];
        }
        
        [labelAirport setFrame:CGRectMake(spaceXStart+kFStatusListCellMiddleHMargin, kFStatusListCellFlightInfoWidth-kFStatusListCellMiddleHMargin, airportSize.width, airportSize.height)];
        [labelAirport setText:flightDepAirport];
        
        // 子窗口大小
        spaceXStart += kFStatusListCellFlightInfoWidth;
        if (airportSize.height > subsHeight)
        {
            subsHeight = airportSize.height;
        }
    }
    
    
    // =======================================
    // 起飞时间
    // =======================================
    NSString *flightTime = [fStatusInfo flightDeptimePlan];
    if (STRINGHASVALUE([fStatusInfo flightDeptime]) && ![[fStatusInfo flightDeptime] isEqualToString:@"false"])
    {
        flightTime = [fStatusInfo flightDeptime];
    }
    if (STRINGHASVALUE(flightTime))
    {
        UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
        CGSize timeSize = [flightTime sizeWithFont:textFont];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kFStatusListFlightDepTimeLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:textFont];
            [labelTime setTextColor:RGBACOLOR(52, 52, 52, 1)];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setAdjustsFontSizeToFitWidth:YES];
            [labelTime setMinimumFontSize:10.0f];
            [labelTime setTag:kFStatusListFlightDepTimeLabelTag];
            // 保存
            [viewParent addSubview:labelTime];
        }
        
        [labelTime setFrame:CGRectMake(spaceXStart, 0, timeSize.width, timeSize.height)];
        [labelTime setText:flightTime];
        
    }
    
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:subsHeight];
	}
    
    // 调整控件位置
    if (viewParent != nil)
    {
        // 航空公司图标
        UIImageView *flightIcon = (UIImageView *)[viewParent viewWithTag:kFStatusListAirCorpIconTag];
        [flightIcon setViewY:(subsHeight - [flightIcon frame].size.height)/2];
        
        // 起飞机场
        UILabel *labelAirport = (UILabel *)[viewParent viewWithTag:kFStatusListFlightDepAirportLabelTag];
        [labelAirport setViewY:(subsHeight - [labelAirport frame].size.height)/2];
        
        // 起飞时间
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kFStatusListFlightDepTimeLabelTag];
        [labelTime setViewY:(subsHeight - [labelTime frame].size.height)/2];
    }
}

// 创建列车信息R2View的子界面
- (void)setupCellFStatusInfoR2Subs:(UIView*)viewParent inSize:(CGSize *)pViewSize forInfo:(FStatusListInfos *)fStatusInfo
{
    // 子窗口高度
	NSInteger spaceXStart=0;
    NSInteger subsHeight = 0;
    
    
    // =======================================
    // 航空公司
    // =======================================
    NSString *airCorpName = [fStatusInfo flightCompany];
    if (STRINGHASVALUE(airCorpName))
    {
        // 创建label
        NSString *airCorpShortName = [Utils getAirCorpShortName:airCorpName];
        if (!STRINGHASVALUE(airCorpShortName))
        {
            airCorpShortName = airCorpName;
        }
        
        UIFont *textFont = [UIFont fontWithName:@"STHeitiJ-Light" size:13.0f];
        CGSize nameSize = [airCorpShortName sizeWithFont:textFont];
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kFStatusListFlightCorpNameLabelTag];
        if (labelName == nil)
        {
            labelName = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelName setBackgroundColor:[UIColor clearColor]];
            [labelName setFont:textFont];
            [labelName setTextColor:RGBACOLOR(138, 138, 138, 1)];
            [labelName setTextAlignment:UITextAlignmentLeft];
            [labelName setAdjustsFontSizeToFitWidth:YES];
            [labelName setMinimumFontSize:10.0f];
            [labelName setTag:kFStatusListFlightCorpNameLabelTag];
            // 保存
            [viewParent addSubview:labelName];
        }
        
        [labelName setFrame:CGRectMake(spaceXStart+kFStatusListCorpIconWidth, 0, kFStatusListCellFlightInfoWidth-kFStatusListCorpIconWidth, nameSize.height)];
        [labelName setText:airCorpShortName];
        
        // 子窗口大小
        spaceXStart += kFStatusListCellFlightInfoWidth;
        if (nameSize.height > subsHeight)
        {
            subsHeight = nameSize.height;
        }
    }
    
    
	// =======================================
    // 到达机场
    // =======================================
    NSString *flightArrAirport = [fStatusInfo flightArrAirport];
    if (STRINGHASVALUE(flightArrAirport))
    {
        UIFont *textFont = [UIFont fontWithName:@"STHeitiJ-Light" size:14.0f];
        CGSize airportSize = [flightArrAirport sizeWithFont:textFont];
        
        UILabel *labelAirport = (UILabel *)[viewParent viewWithTag:kFStatusListFlightArrAirportLabelTag];
        if (labelAirport == nil)
        {
            labelAirport = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelAirport setBackgroundColor:[UIColor clearColor]];
            [labelAirport setFont:textFont];
            [labelAirport setTextColor:RGBACOLOR(118, 118, 118, 1)];
            [labelAirport setTextAlignment:UITextAlignmentLeft];
            [labelAirport setAdjustsFontSizeToFitWidth:YES];
            [labelAirport setMinimumFontSize:10.0f];
            [labelAirport setTag:kFStatusListFlightArrAirportLabelTag];
            // 保存
            [viewParent addSubview:labelAirport];
        }
        
        [labelAirport setFrame:CGRectMake(spaceXStart+kFStatusListCellMiddleHMargin, 0, kFStatusListCellFlightInfoWidth-kFStatusListCellMiddleHMargin, airportSize.height)];
        [labelAirport setText:flightArrAirport];
        
        // 子窗口大小
        spaceXStart += kFStatusListCellFlightInfoWidth;
        if (airportSize.height > subsHeight)
        {
            subsHeight = airportSize.height;
        }
    }
    
    
    // =======================================
    // 到达时间
    // =======================================
    NSString *flightTime = [fStatusInfo flightArrtimePlan];
    if (STRINGHASVALUE([fStatusInfo flightArrtime]) && ![[fStatusInfo flightArrtime] isEqualToString:@"false"])
    {
        flightTime = [fStatusInfo flightArrtime];
    }
    if (STRINGHASVALUE(flightTime))
    {
        UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:14.0f];
        CGSize timeSize = [flightTime sizeWithFont:textFont];
        
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kFStatusListFlightArrTimeLabelTag];
        if (labelTime == nil)
        {
            labelTime = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelTime setBackgroundColor:[UIColor clearColor]];
            [labelTime setFont:textFont];
            [labelTime setTextColor:RGBACOLOR(52, 52, 52, 1)];
            [labelTime setTextAlignment:UITextAlignmentCenter];
            [labelTime setAdjustsFontSizeToFitWidth:YES];
            [labelTime setMinimumFontSize:10.0f];
            [labelTime setTag:kFStatusListFlightArrTimeLabelTag];
            // 保存
            [viewParent addSubview:labelTime];
        }
        
        [labelTime setFrame:CGRectMake(spaceXStart, 0, timeSize.width, timeSize.height)];
        [labelTime setText:flightTime];
        
    }
    
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:subsHeight];
	}
    
    // 调整控件位置
    if (viewParent != nil)
    {
        // 航空公司
        UILabel *labelName = (UILabel *)[viewParent viewWithTag:kFStatusListFlightCorpNameLabelTag];
        [labelName setViewY:(subsHeight - [labelName frame].size.height)/2];
        
    }
}


// 创建空View的子界面
- (void)setupCellEmptySubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // =====================================================
    // 无结果提示
    // =====================================================
    NSString *noResultHint = @"未找到航班数据";
    CGSize noResultSize = [noResultHint sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]];
    
    if (viewParent != nil)
    {
        UILabel *labelNoResultHint = (UILabel *)[viewParent viewWithTag:kFStatusListCellCellNoResultHintLabelTag];
        if (labelNoResultHint == nil)
        {
            labelNoResultHint = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelNoResultHint setBackgroundColor:[UIColor clearColor]];
            [labelNoResultHint setText:noResultHint];
            [labelNoResultHint setFont:[UIFont boldSystemFontOfSize:16.0f]];
            [labelNoResultHint setTextColor:[UIColor colorWithHex:0x343434 alpha:1.0]];
            [labelNoResultHint setTextAlignment:UITextAlignmentCenter];
            [labelNoResultHint setTag:kFStatusListCellCellNoResultHintLabelTag];
            
            // 保存
            [viewParent addSubview:labelNoResultHint];
        }
        [labelNoResultHint setFrame:CGRectMake((pViewSize->width-noResultSize.width)/2, (pViewSize->height-noResultSize.height)/2, noResultSize.width, noResultSize.height)];
        
    }
    
    
}

// 创建详细信息cell分隔线子界面
- (void)setupCellSeparateLineSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
	
    [viewParent setBackgroundColor:[UIColor clearColor]];
	// 背景ImageView
	UIImageView *imageViewBG = [[UIImageView alloc] initWithFrame:CGRectZero];
	[imageViewBG setFrame:CGRectMake(0, parentFrame.size.height - kFStatusListCellSeparateLineHeight, parentFrame.size.width, kFStatusListCellSeparateLineHeight)];
    [imageViewBG setAlpha:0.7];
	[imageViewBG setImage:[UIImage imageNamed:@"dashed.png"]];
	
	// 添加到父窗口
	[viewParent addSubview:imageViewBG];
}


// =======================================================================
#pragma mark - TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayFlightInfos != nil && [_arrayFlightInfos count] > 0)
    {
        return [_arrayFlightInfos count];
    }
    else
    {
        return 1;
    }
    
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    
    NSUInteger row = [indexPath row];
    
    // 航班数据
    if (_arrayFlightInfos != nil && [_arrayFlightInfos count] > 0)
    {
        if (row < [_arrayFlightInfos count])
        {
            // 航班列表数据
            FStatusListInfos *fStatusInfo = [_arrayFlightInfos safeObjectAtIndex:row];
            
            if (fStatusInfo != nil)
            {
                NSString *reusedIdentifier = @"FStatusListTCID";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:reusedIdentifier];
                    
                    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
                    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
                }
                
                
                // 创建contentView
                CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kFStatusListCellHeight);
                [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
                [self setupCellFStatusInfoSubs:[cell contentView] inSize:&contentViewSize forInfo:fStatusInfo];
                
                // 背景分隔线
//                UIView *viewCellSeparateLine = [[UIView alloc] initWithFrame:
//                                                CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
//                [self setupCellSeparateLineSubs:viewCellSeparateLine];
//                [cell setBackgroundView:viewCellSeparateLine];
                
                
                return cell;
            }
        }
    }
    // 结果为空
    else
    {
        NSString *reusedIdentifier = @"FStatusListEmptyTCID";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
		if(cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:reusedIdentifier];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			
			// 创建contentView
			CGSize contentViewSize = CGSizeMake(parentFrame.size.width, parentFrame.size.height);
			[[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
			[self setupCellEmptySubs:[cell contentView] inSize:&contentViewSize];
		}
		
		return cell;
    }
    
    
    return nil;
}

// =======================================================================
#pragma mark - TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    
    NSUInteger row = [indexPath row];
    
    // 列车数据搜索
    if (_arrayFlightInfos != nil && [_arrayFlightInfos count] > 0)
    {
        if (row < [_arrayFlightInfos count])
        {
            return kFStatusListCellHeight;
        }
    }
    // 结果为空
    else
    {
        return parentFrame.size.height;
    }
    
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    // 列车数据搜索
    if (row < [_arrayFlightInfos count])
    {
        // 航班列表数据
        FStatusListInfos *fStatusInfo = [_arrayFlightInfos safeObjectAtIndex:row];
        
        if (fStatusInfo != nil)
        {
            // 航班号
            NSString *flightNumber = [fStatusInfo flightNo];
            // 航班日期
            NSString *flightDate = [fStatusInfo flightDate];
            if (STRINGHASVALUE(flightNumber) && STRINGHASVALUE(flightDate))
            {
                if (_fStatusDetail == nil)
                {
                    _fStatusDetail = [[FStatusDetail alloc] init];
                }
                [_fStatusDetail setFStatusDelegate:self];
                // 航班详情请求
                [_fStatusDetail getFlightStatusDetailStart:flightNumber withDate:flightDate andDisableAutoLoad:NO];
            }
        }
    }
    
    _selectedIndexPath = indexPath;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
