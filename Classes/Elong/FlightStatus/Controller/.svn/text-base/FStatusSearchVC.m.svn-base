//
//  FStatusSearchVC.m
//  ElongClient
//
//  Created by bruce on 13-12-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "FStatusSearchVC.h"
#import "FStatusList.h"
#import "FStatusListVC.h"
#import "FStatusDetailVC.h"

// ========================================
#pragma mark - 布局参数
// ========================================
// 控件尺寸
#define kFStatusSearchConditionCellHeight               90
#define kFStatusSearchDateCellHeight                    92
#define kFStatusSearchTopViewHeight                     51
#define kFStatusSearchParamSegmentWidth                 300
#define kFStatusSearchParamSegmentHeight                29
#define kFStatusSearchFlightIconWidth                   23
#define kFStatusSearchFlightIconHeight                  24
#define kFStatusSearchCellSeparateLineHeight            1
#define kFStatusSearchExchangeIconWidth                 32
#define kFStatusSearchExchangeIconHeight                34
#define kFStatusSearchArrowIconWidth                    8
#define kFStatusSearchArrowIconHeight                   12
#define kFStatusSearchDateIconWidth                     21
#define kFStatusSearchDateIconHeight                    24
#define kFStatusSearchSearchButtonHeight                46


// 边框局
#define kFStatusSearchTableViewHMargin                  20
#define kFStatusSearchTableViewVMargin                  15
#define kFStatusSearchTopViewHMargin                    10
#define kFStatusSearchCellHMargin                       15
#define kFStatusSearchCityMiddleHMargin                 8
#define kFStatusSearchTableCellCityHMargin              2
#define kFStatusSearchTableCellCityVMargin              10
#define kFStatusSearchTableCellHMargin                  5
#define kFStatusSearchTableViewMiddleVMargin            25

// 控件Tag
enum FStatusSearchVCTag {
    kFStatusSearchFlightNumLabelTag = 100,
    kFStatusSearchFlightIconTag,
    kFStatusSearchNumberTopLineTag,
    kFStatusSearchNumberBottomLineTag,
    kFStatusSearchDepartCityButtonTag,
    kFStatusSearchDepartCityLabelTag,
    kFStatusSearchExangeButtonTag,
    kFStatusSearchArriveCityButtonTag,
    kFStatusSearchArriveCityLabelTag,
    kFStatusSearchDepartArrowTag,
    kFStatusSearchArriveArrowTag,
    kFStatusSearchDepartCityHintLabelTag,
    kFStatusSearchArriveCityHintLabelTag,
    kFStatusSearchDateArrowTag,
    kFStatusSearchDateIconTag,
    kFStatusSearchDateContentViewTag,
    kFStatusSearchDepartDateHintLabelTag,
    kFStatusSearchDateSelectViewTag,
    kFStatusSearchDepartDayLabelTag,
    kFStatusSearchDateMonthWeekViewTag,
    kFStatusSearchDepartMonthLabelTag,
    kFStatusSearchDepartWeedLabelTag,
    kFStatusSearchDateTopLineTag,
    kFStatusSearchDateBottomLineTag,
    kFStatusSearchSearchButtonTag,
};

#define	kFStatusNumberMaxLength							8						// 航班号最大输入字符数

@interface FStatusSearchVC ()

@end

@implementation FStatusSearchVC

- (void)dealloc
{
    [_tableViewParam setDelegate:nil];
    [_tableViewParam setDataSource:nil];
    [_tableViewParam removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 初始使用当前日期
    [self ElcalendarViewSelectDay:nil checkinDate:nil checkoutDate:nil];
    
    // 出发城市
    NSString *departCityTmp = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFAULT_FLIGHTSTATUS_DEPARTCITYNAME];
    if (departCityTmp != nil)
    {
        _departCity = departCityTmp;
    }
    else
    {
        // 默认城市
        _departCity = @"北京首都";
    }
    // 到达城市
    NSString *arriveCityTmp = [[ElongUserDefaults sharedInstance] objectForKey:USERDEFUALT_FLIGHTSTATUS_ARRIVALCITYNAME];
    if (arriveCityTmp != nil)
    {
        _arriveCity = arriveCityTmp;
    }
    else
    {
        _arriveCity = @"上海虹桥";
    }
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
    
}



// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
// 出发城市按钮触发
- (void)departCityPressed:(id)sender
{
    SelectCity *selectCity = [[SelectCity alloc] init:@"出发机场" style:_NavOnlyBackBtnStyle_ citylable:nil cityType:SelectCityTypeFStatusDepart isSave:NO];
    [selectCity setCityDelegate:self];
    //
    [self setCitySelectType:eFSDepartCity];
    
	[self.navigationController pushViewController:selectCity animated:YES];
}

// 到达城市按钮触发
- (void)arriveCityPressed:(id)sender
{
    SelectCity *selectCity = [[SelectCity alloc] init:@"到达机场" style:_NavOnlyBackBtnStyle_ citylable:nil cityType:SelectCityTypeFStatusArrive isSave:NO];
    [selectCity setCityDelegate:self];
    //
    [self setCitySelectType:eFSArriveCity];
    
	[self.navigationController pushViewController:selectCity animated:YES];
}

// 城市交换事件
- (void)exchangeCityPressed:(id)sender
{
    // 交换城市
    NSString *cityTmp = _departCity;
    
    _departCity = _arriveCity;
    _arriveCity = cityTmp;
    UILabel *labelDepartCity = (UILabel *)[self.view viewWithTag:kFStatusSearchDepartCityLabelTag];
    UILabel *labelArriveCity = (UILabel *)[self.view viewWithTag:kFStatusSearchArriveCityLabelTag];
    if (labelDepartCity != nil && labelArriveCity != nil)
    {
        CGRect tempRect = labelDepartCity.frame;
        [UIView animateWithDuration:0.5f
                         animations:^(void){
                             labelDepartCity.frame = labelArriveCity.frame;
                             labelArriveCity.frame = tempRect;
                         }
                         completion:^(BOOL finished) {
                             CGRect rect = labelDepartCity.frame;
                             labelDepartCity.frame = labelArriveCity.frame;
                             labelArriveCity.frame = rect;
                             
                             NSString *cityTmp = labelDepartCity.text;
                             labelDepartCity.text = labelArriveCity.text;
                             labelArriveCity.text = cityTmp;
                         }];
    }
    
}

// 查询按钮触发
- (void)searchButtonPressed:(id)sender
{
    // 出发到达机场搜索
    if (_paramType == eFStatusTypeCity)
    {
        
        // =========================
        // 保存搜索过的历史城市
        // =========================
 
        [[ElongUserDefaults sharedInstance] setObject:_departCity forKey:USERDEFAULT_FLIGHTSTATUS_DEPARTCITYNAME];
        [[ElongUserDefaults sharedInstance] setObject:_arriveCity forKey:USERDEFUALT_FLIGHTSTATUS_ARRIVALCITYNAME];

        // 搜索
        [self citySearch];
        
    }
    // 航班搜索
    else if (_paramType == eFStatusTypeNumber)
    {
        [self numberSearch];
    }
}


// 航班号输入
- (void)codeInputChange:(id)sender
{
	UITextField *textFieldCode = (UITextField *)sender;
	
	// 写入本地保存
//    [[NSUserDefaults standardUserDefaults] setObject:[textFieldCode text] forKey:@"fStatusSearch_Number"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _flightNumber = [textFieldCode text];
	
	[self refreshButtonSearchStatus];
}

// 航班号输入结束
- (void)codeInputEnd:(id)sender
{
	UITextField *textFieldCode = (UITextField *)sender;
	
	// 隐藏键盘
	[textFieldCode resignFirstResponder];
}


// 选择触发日期
- (void)chooseDepartDate
{
    [_viewResponder resignFirstResponder];
    
    // 日期转换
    NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
    [oFormat setDateFormat:@"yyyy-MM-dd"];
    
    // 日历界面
    ELCalendarViewController *calendar=[[ELCalendarViewController alloc] initWithCheckIn:[oFormat dateFromString:_departDate] checkOut:nil type:FlightCalendarGo];
    calendar.delegate=self;
    
    [self.navigationController pushViewController:calendar animated:YES];
    
}



// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
// 出发到达搜索
- (void)citySearch
{
    // 组织Json
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
    
    
    // 起飞地点
    if (_departCity != nil)
    {
        [dictionaryJson safeSetObject:_departCity forKey:@"startPlace"];
    }
    
    // 降落地点
    if (_arriveCity != nil)
    {
        [dictionaryJson safeSetObject:_arriveCity forKey:@"endPlace"];
    }
    
    
    // 查询日期
    if (_departDate != nil)
    {
        [dictionaryJson safeSetObject:_departDate forKey:@"Date"];
    }
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods composeNetSearchUrl:@"mtools"
                                            forService:@"flightTrendList"
                                              andParam:paramJson];
    
    if (url != nil)
    {
        [HttpUtil requestURL:url postContent:nil delegate:self];
        
    }
}

// 航班号搜索
- (void)numberSearch
{
//    NSString *flightNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"fStatusSearch_Number"];
    
    if (STRINGHASVALUE(_flightNumber) && STRINGHASVALUE(_departDate))
    {
        if (_fStatusDetail == nil)
        {
            _fStatusDetail = [[FStatusDetail alloc] init];
        }
        if ([_fStatusDetail fStatusDelegate] == nil)
        {
            [_fStatusDetail setFStatusDelegate:self];
        }
        // 航班详情请求
        [_fStatusDetail getFlightStatusDetailStart:_flightNumber withDate:_departDate andDisableAutoLoad:NO];
    }
    else
    {
        [Utils alert:@"请输入航班号"];
    }
}


// 刷新搜索button的状态
- (void)refreshButtonSearchStatus
{
	if(_paramType == eFStatusTypeNumber)
	{
        UIButton *searchButton = (UIButton *)[self.view viewWithTag:kFStatusSearchSearchButtonTag];
        
//		NSString *fStatusFlightNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"fStatusSearch_Number"];
		if(STRINGHASVALUE(_flightNumber))
		{
			[searchButton setEnabled:YES];
		}
		else
		{
			[searchButton setEnabled:NO];
		}
	}
}

// =======================================================================
#pragma mark - 城市选择回调
// =======================================================================
- (void)selectCityBack:(NSString *)cityName
{
    if (STRINGHASVALUE(cityName))
    {
        if (_citySelectType == eFSDepartCity)
        {
            _departCity = cityName;
        }
        else if (_citySelectType == eFSArriveCity)
        {
            _arriveCity = cityName;
        }
        
        [_tableViewParam reloadData];
    }
}

// =======================================================================
#pragma mark - 日历代理回调
// =======================================================================
- (void) ElcalendarViewSelectDay:(ELCalendarViewController *)elViewController checkinDate:(NSDate *)cinDate checkoutDate:(NSDate *)coutDate
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"E,MMMM,d"];
	NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
	[oFormat setDateFormat:@"yyyy-MM-dd"];
    
    // 默认日期
//    NSDate *departDateTmp = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];
    NSDate *departDateTmp = [NSDate date];
    
    if (cinDate != nil)
    {
        departDateTmp = cinDate;
    }
    
    // 保存日期搜索使用
    NSString *dateString = [oFormat stringFromDate:departDateTmp];
    _departDate = [[dateString componentsSeparatedByString:@","] objectAtIndex:0];
    
    // 显示日期
	NSArray *dateCompents = [Utils switchMonth:[[format stringFromDate:departDateTmp] componentsSeparatedByString:@","]];
	
	_departWeek	= [dateCompents safeObjectAtIndex:0];
	_departMonth		= [dateCompents safeObjectAtIndex:1];
	
	NSString *dayStr = [dateCompents safeObjectAtIndex:2];
	if ([dayStr intValue] < 10)
    {
        NSString *dayStrTmp = [NSString stringWithFormat:@"0%@",dayStr];
        dayStr = dayStrTmp;
	}
	_departDay = dayStr;
    
    // 日期差
    double interval = [departDateTmp timeIntervalSinceNow]/86400.0;
    if (interval <= 0)
    {
        _departWeek = @"今天";
    }
    else if (interval > 0 && interval <=1)
    {
        _departWeek = @"明天";
    }
    
    [_tableViewParam reloadData];
}

#pragma mark - customSegmented delegate
- (void)segmentedView:(id)segView ClickIndex:(NSInteger)index
{
    _paramType = index;
    
    if (_paramType == eFStatusTypeCity)
    {
        [_viewResponder resignFirstResponder];
    }
    
    [_tableViewParam reloadData];
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
#pragma mark - 网络请求回调
// =======================================================================
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
    NSLog(@"%@", root);
    
    if ([Utils checkJsonIsError:root]) {
        return;
    }
    
    FStatusList *fStatusList = [[FStatusList alloc] init];
    [fStatusList parseSearchResult:root];
    
    NSNumber *isError = [fStatusList isError];
    if (isError !=nil && [isError boolValue] == NO)
    {
        FStatusListVC *controller = [[FStatusListVC alloc] init];
        
        [controller setFStatusListCur:fStatusList];
//        [controller setDepartCity:_departCity];
//        [controller setArriveCity:_arriveCity];
//        [controller setDepartDate:_departDate];
//        [controller setFilterInfo:[self getTrainFilter]];
//        [controller setHasTicketFilte:_isSelectTicket];
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else
    {
        NSString *errorMessage = [fStatusList errorMessage];
        if (STRINGHASVALUE(errorMessage))
        {
            [Utils alert:errorMessage];
        }
    }
}


// ===========================================
#pragma mark - 布局函数
// ===========================================
// 创建Root View的子界面
- (void)setupViewRootSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    [self addTopImageAndTitle:nil andTitle:@"航班查询"];
    [self setShowBackBtn:YES];
    // =======================================
    // 顶部视图
    // =======================================
    UIView *viewTopTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, kFStatusSearchTopViewHeight)];
    [viewTopTmp setBackgroundColor:[UIColor clearColor]];
    [self setupViewTopSubs:viewTopTmp];
    [viewParent addSubview:viewTopTmp];
    
    // 子窗口大小
    spaceYStart += kFStatusSearchTopViewHeight;
    
    // =======================================================================
    // 搜索条件TableView
    // =======================================================================
    // 创建TableView
	UITableView *tableViewParamTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewParamTmp setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width,
										   parentFrame.size.height)];
	[tableViewParamTmp setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableViewParamTmp setScrollEnabled:NO];
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
	[self setTableViewParam:tableViewParamTmp];
	[viewParent addSubview:tableViewParamTmp];
    
}

// 创建TopView的子界面
- (void)setupViewTopSubs:(UIView *)viewParent
{
    // 父窗口的尺寸
	CGRect parentFrame = [viewParent frame];
    
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"航班号查询", @"起降地查询", nil];
    CustomSegmented *segParamType = [[CustomSegmented alloc] initSegmentedWithFrame:CGRectMake(kFStatusSearchTopViewHMargin, (parentFrame.size.height-kFStatusSearchParamSegmentHeight)/2, kFStatusSearchParamSegmentWidth, kFStatusSearchParamSegmentHeight) titles:titleArray normalIcons:nil highlightIcons:nil];
    
    segParamType.delegate = self;
    segParamType.selectedIndex = eFStatusTypeNumber;
    [viewParent addSubview:segParamType];
}


// 创建搜索条件子界面
- (void)setupCellSearchConditionSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
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
    
    // =======================================================================
    // 分隔线
    // =======================================================================
    CGSize topLineSize = CGSizeMake(parentFrame.size.width, kFStatusSearchCellSeparateLineHeight);
    UIImageView *imageViewTopLine = (UIImageView *)[viewParent viewWithTag:kFStatusSearchNumberTopLineTag];
    if (imageViewTopLine == nil)
    {
        imageViewTopLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewTopLine setImage:[UIImage imageNamed:@"dashed.png"]];
        [imageViewTopLine setTag:kFStatusSearchNumberTopLineTag];
        [imageViewTopLine setAlpha:0.7];
        
        // 添加到父窗口
        [viewParent addSubview:imageViewTopLine];
    }
    [imageViewTopLine setFrame:CGRectMake(0, 0, topLineSize.width,topLineSize.height)];
    
    
    // 根据查询类型创建
    if (_paramType == eFStatusTypeNumber)   // 航班号
    {
        UITextField *textFieldCode = (UITextField *)[viewParent viewWithTag:kFStatusSearchFlightNumLabelTag];
        if (textFieldCode == nil)
        {
            textFieldCode = [[UITextField alloc] initWithFrame:CGRectZero];
            [textFieldCode setBorderStyle:UITextBorderStyleNone];
            [textFieldCode setTextColor:RGBACOLOR(52, 52, 52, 1)];
            [textFieldCode setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:18.0f]];
            [textFieldCode setTextAlignment: UITextAlignmentCenter];
            [textFieldCode setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
            [textFieldCode setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter|UIControlContentHorizontalAlignmentCenter];
            [textFieldCode setPlaceholder:@"请输入航班号（如MU1883）"];
            [textFieldCode setClearsOnBeginEditing:NO];
            [textFieldCode setReturnKeyType:UIReturnKeyDone];
            [textFieldCode addTarget:self action:@selector(codeInputChange:) forControlEvents:UIControlEventEditingChanged];
            [textFieldCode addTarget:self action:@selector(codeInputEnd:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [textFieldCode setDelegate:self];
            [textFieldCode setTag:kFStatusSearchFlightNumLabelTag];
            
            // 保存
            [viewParent addSubview:textFieldCode];
        }
        [textFieldCode setFrame:CGRectMake(parentFrame.size.width*0.15, 0, parentFrame.size.width*0.8, parentFrame.size.height)];
//        NSString *fStatusFlightNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"fStatusSearch_Number"];
        if (STRINGHASVALUE(_flightNumber))
        {
            [textFieldCode setText:_flightNumber];
        }
    }
    // 起降地
    else if (_paramType == eFStatusTypeCity)
    {
        // =======================================================================
        // 出发城市
        // =======================================================================
        // 事件按钮
        CGSize departCitySize = CGSizeMake(parentFrame.size.width*0.5, parentFrame.size.height - kFStatusSearchCellSeparateLineHeight);
        
        UIButton *buttonDepartCity = (UIButton *)[viewParent viewWithTag:kFStatusSearchDepartCityButtonTag];
        if (buttonDepartCity == nil)
        {
            buttonDepartCity = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [buttonDepartCity setBackgroundImage:[[UIImage imageNamed:@"flight_press.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateHighlighted];
            [buttonDepartCity addTarget:self action:@selector(departCityPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonDepartCity setTag:kFStatusSearchDepartCityButtonTag];
            // 保存
            [viewParent addSubview:buttonDepartCity];
        }
        [buttonDepartCity setFrame:CGRectMake(spaceXStart, kFStatusSearchCellSeparateLineHeight, departCitySize.width, departCitySize.height)];
        
        // 创建子界面
        [self setupDepartCity:buttonDepartCity];
        
        // 城市Label
        if (_departCity != nil && [_departCity length] > 0)
        {
            CGSize citySize = [_departCity sizeWithFont:[UIFont boldSystemFontOfSize:24.0f]];
            
            UILabel *labelDepartCity = (UILabel *)[viewParent viewWithTag:kFStatusSearchDepartCityLabelTag];
            if (labelDepartCity == nil)
            {
                labelDepartCity = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelDepartCity setBackgroundColor:[UIColor clearColor]];
                [labelDepartCity setFont:[UIFont boldSystemFontOfSize:24.0f]];
                [labelDepartCity setTextColor:[UIColor blackColor]];
                [labelDepartCity setTextAlignment:UITextAlignmentCenter];
                [labelDepartCity setAdjustsFontSizeToFitWidth:YES];
                [labelDepartCity setMinimumFontSize:10.0f];
                [labelDepartCity setTag:kFStatusSearchDepartCityLabelTag];
                // 保存
                [viewParent addSubview:labelDepartCity];
            }
            [labelDepartCity setFrame:CGRectMake(parentFrame.size.width*0.16, parentFrame.size.height*0.45, parentFrame.size.width*0.29, citySize.height)];
            [labelDepartCity setText:_departCity];
            
        }
        
        // 子窗口大小
        spaceXStart += departCitySize.width;
        
        // 间隔
        spaceXStart += kFStatusSearchTableCellHMargin;
        
        
        // =======================================================================
        // 交换Icon
        // =======================================================================
        CGSize exchangeIconSize = CGSizeMake(kFStatusSearchExchangeIconWidth, kFStatusSearchExchangeIconHeight);
        
        UIButton *buttonExchange = (UIButton *)[viewParent viewWithTag:kFStatusSearchExangeButtonTag];
        if (buttonExchange == nil)
        {
            buttonExchange = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [buttonExchange setBackgroundImage:[UIImage imageNamed:@"btn_exchangeicon.png"] forState:UIControlStateNormal];
            [buttonExchange addTarget:self action:@selector(exchangeCityPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonExchange setTag:kFStatusSearchExangeButtonTag];
            // 保存
            [viewParent addSubview:buttonExchange];
        }
        [buttonExchange setFrame:CGRectMake(spaceXStart, parentFrame.size.height*0.38, exchangeIconSize.width, exchangeIconSize.height)];
        
        // 子窗口大小
        spaceXStart += exchangeIconSize.width;
        
        
        // 间隔
        spaceXStart +=kFStatusSearchTableCellHMargin;
        
        // =======================================================================
        // 到达城市
        // =======================================================================
        CGSize arriveCitySize = CGSizeMake(pViewSize->width-spaceXStart, parentFrame.size.height-kFStatusSearchCellSeparateLineHeight);
        
        UIButton *buttonArriveCity = (UIButton *)[viewParent viewWithTag:kFStatusSearchArriveCityButtonTag];
        if (buttonArriveCity == nil)
        {
            buttonArriveCity = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [buttonArriveCity setBackgroundImage:[[UIImage imageNamed:@"flight_press.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateHighlighted];
            
            [buttonArriveCity addTarget:self action:@selector(arriveCityPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonArriveCity setTag:kFStatusSearchArriveCityButtonTag];
            // 保存
            [viewParent addSubview:buttonArriveCity];
        }
        [buttonArriveCity setFrame:CGRectMake(spaceXStart, kFStatusSearchCellSeparateLineHeight, arriveCitySize.width, arriveCitySize.height)];
        
        // 创建子界面
        [self setupArriveCity:buttonArriveCity];
        
        // 城市Label
        if (_arriveCity != nil && [_arriveCity length] > 0)
        {
            CGSize citySize = [_arriveCity sizeWithFont:[UIFont boldSystemFontOfSize:24.0f]];
            
            UILabel *labelArriveCity = (UILabel *)[viewParent viewWithTag:kFStatusSearchArriveCityLabelTag];
            if (labelArriveCity == nil)
            {
                labelArriveCity = [[UILabel alloc] initWithFrame:CGRectZero];
                [labelArriveCity setBackgroundColor:[UIColor clearColor]];
                [labelArriveCity setFont:[UIFont boldSystemFontOfSize:24.0f]];
                [labelArriveCity setTextColor:[UIColor blackColor]];
                [labelArriveCity setTextAlignment:UITextAlignmentCenter];
                [labelArriveCity setAdjustsFontSizeToFitWidth:YES];
                [labelArriveCity setMinimumFontSize:10.0f];
                [labelArriveCity setTag:kFStatusSearchArriveCityLabelTag];
                
                // 保存
                [viewParent addSubview:labelArriveCity];
            }
            [labelArriveCity setFrame:CGRectMake(spaceXStart+kFStatusSearchTableCellCityHMargin, parentFrame.size.height*0.45, arriveCitySize.width-kFStatusSearchCellHMargin-kFStatusSearchArrowIconWidth-kFStatusSearchTableCellCityHMargin, citySize.height)];
            [labelArriveCity setText:_arriveCity];
            
        }
        
        
        [viewParent bringSubviewToFront:buttonExchange];
    }
    
    // ================================
    // 飞机Icon
    // ================================
    CGSize flightIconSize = CGSizeMake(kFStatusSearchFlightIconWidth, kFStatusSearchFlightIconHeight);
    
    UIImageView *flightIcon = (UIImageView *)[viewParent viewWithTag:kFStatusSearchFlightIconTag];
    if (flightIcon == nil)
    {
        flightIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [flightIcon setImage:[UIImage noCacheImageNamed:@"ico_flightleft.png"]];
        [flightIcon setTag:kFStatusSearchFlightIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:flightIcon];
    }
    [flightIcon setFrame:CGRectMake(kFStatusSearchTableViewHMargin, parentFrame.size.height*0.4, flightIconSize.width, flightIconSize.height)];
    
}

// 创建出发城市内容
- (void)setupDepartCity:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXEnd -= kFStatusSearchTableCellCityHMargin;
    spaceYStart += kFStatusSearchTableViewVMargin;
    
    
    // =======================================================================
    // 箭头Icon
    // =======================================================================
    CGSize arrowSize = CGSizeMake(kFStatusSearchArrowIconWidth, kFStatusSearchArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kFStatusSearchDepartArrowTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [arrowIcon setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        [arrowIcon setTag:kFStatusSearchDepartArrowTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(spaceXEnd-arrowSize.width, parentFrame.size.height*0.5, arrowSize.width, arrowSize.height)];
    
    // 子窗口高宽
    spaceXEnd -= arrowSize.width;
    
    // 间隔
    spaceXEnd -= kFStatusSearchTableCellCityHMargin;
    
    // 城市Hint Label
    NSString *departCityHint = @"出发机场";
    CGSize hintSize = [departCityHint sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kFStatusSearchDepartCityHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont systemFontOfSize:12.0f]];
        [labelHint setTextColor:[UIColor grayColor]];
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setAdjustsFontSizeToFitWidth:YES];
        [labelHint setMinimumFontSize:10.0f];
        [labelHint setTag:kFStatusSearchDepartCityHintLabelTag];
        // 保存
        [viewParent addSubview:labelHint];
    }
    [labelHint setFrame:CGRectMake(kFStatusSearchTableCellHMargin*3, spaceYStart, spaceXEnd, hintSize.height)];
    [labelHint setText:departCityHint];
    
}

// 创建到达城市内容
- (void)setupArriveCity:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceXEnd -= kFStatusSearchCellHMargin;
    spaceYStart += kFStatusSearchTableViewVMargin;
    
    
    // =======================================================================
    // 箭头Icon
    // =======================================================================
    CGSize arrowSize = CGSizeMake(kFStatusSearchArrowIconWidth, kFStatusSearchArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kFStatusSearchArriveArrowTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [arrowIcon setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        [arrowIcon setTag:kFStatusSearchArriveArrowTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(spaceXEnd-arrowSize.width, parentFrame.size.height*0.5, arrowSize.width, arrowSize.height)];
    
    // 子窗口高宽
    spaceXEnd -= arrowSize.width;
    
    // 城市Hint Label
    NSString *arriveCityHint = @"到达机场";
    CGSize hintSize = [arriveCityHint sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kFStatusSearchArriveCityHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont systemFontOfSize:12.0f]];
        [labelHint setTextColor:[UIColor grayColor]];
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setAdjustsFontSizeToFitWidth:YES];
        [labelHint setMinimumFontSize:10.0f];
        [labelHint setTag:kFStatusSearchArriveCityHintLabelTag];
        
        // 保存
        [viewParent addSubview:labelHint];
    }
    [labelHint setFrame:CGRectMake(0, spaceYStart, spaceXEnd, hintSize.height)];
    [labelHint setText:arriveCityHint];
    
    
}



// 创建出发日期子界面
- (void)setupCellSearchDateSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
	NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    
    
    // =======================================================================
    // 分隔线
    // =======================================================================
    CGSize topLineSize = CGSizeMake(pViewSize->width*0.8, kFStatusSearchCellSeparateLineHeight);
    UIImageView *imageViewTopLine = (UIImageView *)[viewParent viewWithTag:kFStatusSearchDateTopLineTag];
    if (imageViewTopLine == nil)
    {
        imageViewTopLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewTopLine setImage:[UIImage imageNamed:@"dashed.png"]];
        [imageViewTopLine setTag:kFStatusSearchDateTopLineTag];
        [imageViewTopLine setAlpha:0.7];
        
        // 添加到父窗口
        [viewParent addSubview:imageViewTopLine];
    }
    [imageViewTopLine setFrame:CGRectMake(pViewSize->width*0.2, 0, topLineSize.width,topLineSize.height)];
    
    //
    CGSize bottomLineSize = CGSizeMake(pViewSize->width, kFStatusSearchCellSeparateLineHeight);
    UIImageView *imageViewBottomLine = (UIImageView *)[viewParent viewWithTag:kFStatusSearchDateBottomLineTag];
    if (imageViewBottomLine == nil)
    {
        imageViewBottomLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewBottomLine setImage:[UIImage imageNamed:@"dashed.png"]];
        [imageViewBottomLine setTag:kFStatusSearchDateBottomLineTag];
        [imageViewBottomLine setAlpha:0.7];
        
        // 添加到父窗口
        [viewParent addSubview:imageViewBottomLine];
    }
    [imageViewBottomLine setFrame:CGRectMake(0, pViewSize->height-bottomLineSize.height, bottomLineSize.width,bottomLineSize.height)];
    
    
    // 间隔
    spaceXStart += kFStatusSearchTableViewHMargin+kFStatusSearchTableCellCityHMargin;
    spaceXEnd -= kFStatusSearchTableViewHMargin+kFStatusSearchTableCellCityHMargin;
    
    
    // =======================================================================
    // 箭头Icon
    // =======================================================================
    CGSize arrowSize = CGSizeMake(kFStatusSearchArrowIconWidth, kFStatusSearchArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kFStatusSearchDateArrowTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [arrowIcon setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        [arrowIcon setTag:kFStatusSearchDateArrowTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(spaceXEnd-arrowSize.width, parentFrame.size.height*0.5, arrowSize.width, arrowSize.height)];
    
    // =======================================================================
    // 日期Icon
    // =======================================================================
    CGSize dateIconSize = CGSizeMake(kFStatusSearchDateIconWidth, kFStatusSearchDateIconHeight);
    
    UIImageView *dateIcon = (UIImageView *)[viewParent viewWithTag:kFStatusSearchDateIconTag];
    if (dateIcon == nil)
    {
        dateIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [dateIcon setImage:[UIImage imageNamed:@"ico_traindate.png"]];
        [dateIcon setTag:kFStatusSearchDateIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:dateIcon];
    }
    [dateIcon setFrame:CGRectMake(spaceXStart, (parentFrame.size.height - dateIconSize.height)/2, dateIconSize.width, dateIconSize.height)];
    
    // 子窗口大小
    spaceXStart += dateIconSize.width;
    
    
    // 间隔
    spaceXStart +=kFStatusSearchTableCellHMargin;
    
    // 间隔
    spaceXEnd -= kFStatusSearchTableCellHMargin;
    
    // =======================================================================
    // 日期选择内容
    // =======================================================================
    CGSize viewContentSize = CGSizeMake(0, 0);
    
    UIView *viewContent = [viewParent viewWithTag:kFStatusSearchDateContentViewTag];
    if (viewContent == nil)
    {
        viewContent = [[UIView alloc] initWithFrame:CGRectZero];
        [viewContent setTag:kFStatusSearchDateContentViewTag];
        // 保存
        [viewParent addSubview:viewContent];
    }
    [viewContent setFrame:CGRectMake(spaceXStart, 0, viewContentSize.width, viewContentSize.height)];
    
    // 创建子界面
    [self setupCellTrainDateContentSubs:viewContent inSize:&viewContentSize];
    
    
    // 调整界面位置
    [viewContent setViewX:spaceXStart + (spaceXEnd-spaceXStart-viewContentSize.width)/2];
    [viewContent setViewY:(pViewSize->height-viewContentSize.height)/2];
    
    
}


// 创建列车出发日期子界面
- (void)setupCellTrainDateContentSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    NSInteger subsWidth = 0;
    
    // =======================================================================
    // 日期选择提示
    // =======================================================================
    NSString *dateHint = @"出发日期";
    CGSize hintSize = [dateHint sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kFStatusSearchDepartDateHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont systemFontOfSize:12.0f]];
        [labelHint setTextColor:[UIColor grayColor]];
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setAdjustsFontSizeToFitWidth:YES];
        [labelHint setMinimumFontSize:10.0f];
        [labelHint setTag:kFStatusSearchDepartDateHintLabelTag];
        // 保存
        [viewParent addSubview:labelHint];
    }
    [labelHint setFrame:CGRectMake(0, spaceYStart, hintSize.width, hintSize.height)];
    [labelHint setText:dateHint];;
    
    // 子窗口大小
    spaceYStart += hintSize.height;
    subsWidth = hintSize.width;
    
    
    // =======================================================================
    // 日期选择内容
    // =======================================================================
    CGSize viewDateSelectSize = CGSizeMake(0, 0);
    
    UIView *viewDateSelect = [viewParent viewWithTag:kFStatusSearchDateSelectViewTag];
    if (viewDateSelect == nil)
    {
        viewDateSelect = [[UIView alloc] initWithFrame:CGRectZero];
        [viewDateSelect setTag:kFStatusSearchDateSelectViewTag];
        // 保存
        [viewParent addSubview:viewDateSelect];
    }
    [viewDateSelect setFrame:CGRectMake(0, spaceYStart, viewDateSelectSize.width, viewDateSelectSize.height)];
    
    // 创建子界面
    [self setupCellDateSelectSubs:viewDateSelect inSize:&viewDateSelectSize];
    
    
    // 子窗口大小
    spaceYStart += viewDateSelectSize.height;
    if (viewDateSelectSize.width > subsWidth)
    {
        subsWidth = viewDateSelectSize.width;
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->width = subsWidth;
    pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
        [viewParent setViewWidth:subsWidth];
		[viewParent setViewHeight:spaceYStart];
	}
}

// 创建日期选择信息
- (void)setupCellDateSelectSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
	NSInteger spaceXStart = 0;
    NSInteger subsHeight = 0;
    
    // =======================================================================
    // 出发日期日
    // =======================================================================
    CGSize daySize = [_departDay sizeWithFont:[UIFont fontWithName:@"Helvetica" size:41]];
    
    UILabel *labelDepartDay = (UILabel *)[viewParent viewWithTag:kFStatusSearchDepartDayLabelTag];
    if (labelDepartDay == nil)
    {
        labelDepartDay = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDepartDay setBackgroundColor:[UIColor clearColor]];
        [labelDepartDay setFont:[UIFont fontWithName:@"Helvetica" size:41]];
        [labelDepartDay setTextColor:[UIColor blackColor]];
        [labelDepartDay setTextAlignment:UITextAlignmentCenter];
        [labelDepartDay setTag:kFStatusSearchDepartDayLabelTag];
        // 保存
        [viewParent addSubview:labelDepartDay];
    }
    [labelDepartDay setFrame:CGRectMake(0, 0, daySize.width, daySize.height)];
    [labelDepartDay setText:_departDay];
    
    // 子窗口大小
    spaceXStart += daySize.width;
    subsHeight = daySize.height;
    
    // 间隔
    spaceXStart += kFStatusSearchTableCellHMargin;
    
    // =======================================================================
    // 出发日期月和周
    // =======================================================================
    CGSize viewMonthWeekSize = CGSizeMake(0, 0);
    
    UIView *viewMonthWeek = [viewParent viewWithTag:kFStatusSearchDateMonthWeekViewTag];
    if (viewMonthWeek == nil)
    {
        viewMonthWeek = [[UIView alloc] initWithFrame:CGRectZero];
        [viewMonthWeek setTag:kFStatusSearchDateMonthWeekViewTag];
        // 保存
        [viewParent addSubview:viewMonthWeek];
    }
    [viewMonthWeek setFrame:CGRectMake(spaceXStart, 0, viewMonthWeekSize.width, viewMonthWeekSize.height)];
    
    // 创建子界面
    [self setupCellDateMonthWeekSubs:viewMonthWeek inSize:&viewMonthWeekSize];
    
    
    // 子窗口大小
    spaceXStart += viewMonthWeekSize.width;
    if (viewMonthWeekSize.height > subsHeight)
    {
        subsHeight = viewMonthWeekSize.width;
    }
    
    // 调整位置
    [viewMonthWeek setViewY:(subsHeight-viewMonthWeekSize.height)/2];
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->width = spaceXStart;
    pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
        [viewParent setViewWidth:spaceXStart];
		[viewParent setViewHeight:subsHeight];
	}
}

// 创建出发日期月和周
- (void)setupCellDateMonthWeekSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
	NSInteger spaceYStart = 0;
    NSInteger subsWidth = 0;
    
    // =======================================================================
    // 出发日期月
    // =======================================================================
    CGSize monthSize = [_departMonth sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13]];
    
    UILabel *labelDepartMonth = (UILabel *)[viewParent viewWithTag:kFStatusSearchDepartMonthLabelTag];
    if (labelDepartMonth == nil)
    {
        labelDepartMonth = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDepartMonth setBackgroundColor:[UIColor clearColor]];
        [labelDepartMonth setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [labelDepartMonth setTextColor:[UIColor blackColor]];
        [labelDepartMonth setTextAlignment:UITextAlignmentCenter];
        [labelDepartMonth setTag:kFStatusSearchDepartMonthLabelTag];
        // 保存
        [viewParent addSubview:labelDepartMonth];
    }
    [labelDepartMonth setFrame:CGRectMake(0, 0, monthSize.width, monthSize.height)];
    [labelDepartMonth setText:_departMonth];
    
    // 子窗口大小
    spaceYStart += monthSize.height;
    subsWidth = monthSize.width;
    
    
    // =======================================================================
    // 出发日期周
    // =======================================================================
    CGSize weekSize = [_departWeek sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12]];
    
    UILabel *labelDepartWeek = (UILabel *)[viewParent viewWithTag:kFStatusSearchDepartWeedLabelTag];
    if (labelDepartWeek == nil)
    {
        labelDepartWeek = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDepartWeek setBackgroundColor:[UIColor clearColor]];
        [labelDepartWeek setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [labelDepartWeek setTextColor:[UIColor blackColor]];
        [labelDepartWeek setTextAlignment:UITextAlignmentLeft];
        [labelDepartWeek setTag:kFStatusSearchDepartWeedLabelTag];
        
        // 保存
        [viewParent addSubview:labelDepartWeek];
    }
    [labelDepartWeek setFrame:CGRectMake(0, spaceYStart, weekSize.width, weekSize.height)];
    [labelDepartWeek setText:_departWeek];
    
    
    // 子窗口大小
    spaceYStart += weekSize.height;
    if (weekSize.width > spaceYStart)
    {
        subsWidth = weekSize.width;
    }
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->width = subsWidth;
    pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
        [viewParent setViewWidth:subsWidth];
		[viewParent setViewHeight:spaceYStart];
	}
    
}


// 创建Footer子界面
- (void)setupTableViewFooterSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceYStart += kFStatusSearchTableViewVMargin;
    
    
    // 间隔
    spaceYStart += kFStatusSearchTableViewMiddleVMargin;
    
    
    // =======================================================================
	// 查询按钮
	// =======================================================================
    CGSize searchButtonSize = CGSizeMake(parentFrame.size.width-kFStatusSearchTableViewHMargin*2, kFStatusSearchSearchButtonHeight);
    
    if (viewParent != nil)
    {
        UIButton *searchButton = (UIButton *)[viewParent viewWithTag:kFStatusSearchSearchButtonTag];
        if (searchButton == nil)
        {
            searchButton = [UIButton uniformButtonWithTitle:@"查  询"
                                                  ImagePath:nil
                                                     Target:self
                                                     Action:@selector(searchButtonPressed:)
                                                      Frame:CGRectMake(kFStatusSearchTableViewHMargin, spaceYStart, searchButtonSize.width, searchButtonSize.height)];
            [searchButton setTag:kFStatusSearchSearchButtonTag];
//            NSString *fStatusFlightNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"fStatusSearch_Number"];
            
//            if (_paramType == eFStatusTypeNumber)
//            {
//                if(STRINGHASVALUE(_flightNumber))
//                {
//                    [searchButton setEnabled:YES];
//                }
//                else
//                {
//                    [searchButton setEnabled:NO];
//                }
//            }
//            else if (_paramType == eFStatusTypeCity)
//            {
//                if (STRINGHASVALUE(_departCity) && STRINGHASVALUE(_arriveCity))
//                {
//                    [searchButton setEnabled:YES];
//                }
//                else
//                {
//                    [searchButton setEnabled:NO];
//                }
//            }
            
            // 保存
            [viewParent addSubview:searchButton];
        }
    }
    
    // 调整子窗口大小
    spaceYStart += searchButtonSize.height;
    
    // 间隔
    spaceYStart += kFStatusSearchTableViewMiddleVMargin;
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
}

// ====================================
#pragma mark - TabelViewDataSource的代理函数
// ====================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 父窗口尺寸
	CGRect parentFrame = [tableView frame];
    
    NSUInteger row = [indexPath row];
    
    // 出发到达城市
    if (row == 0)
    {
        NSString *reusedIdentifier = @"TrainHomeCityTCID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:reusedIdentifier];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        // 创建contentView
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kFStatusSearchConditionCellHeight);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupCellSearchConditionSubs:[cell contentView] inSize:&contentViewSize];
        
        // 设置选中背景
        UIView* b_view = [[UIView alloc] initWithFrame:CGRectMake(0, 1, parentFrame.size.width, kFStatusSearchConditionCellHeight-2)];
        b_view.backgroundColor = [UIColor clearColor];
        UIButton* b_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        b_btn.backgroundColor = [UIColor clearColor];
        b_btn.frame = CGRectMake(0, 1, parentFrame.size.width, kFStatusSearchConditionCellHeight-2);
        [b_view addSubview:b_btn];
        [cell setSelectedBackgroundView:b_view];
        
        return cell;
    }
    // 出发日期
    else if (row == 1)
    {
        NSString *reusedIdentifier = @"TrainHomeDateTCID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:reusedIdentifier];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);
        }
        
        // 创建contentView
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kFStatusSearchDateCellHeight);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupCellSearchDateSubs:[cell contentView] inSize:&contentViewSize];
        
        
        return cell;
    }
    
    return nil;
}

// =======================================================================
#pragma mark - TableViewDelegate的代理函数
// =======================================================================
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    // 出发到达城市
    if (row == 0)
    {
        return kFStatusSearchConditionCellHeight;
    }
    // 出发日期
    else if (row == 1)
    {
        return kFStatusSearchDateCellHeight;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    if (row == 0)
    {
    }
    // 触发日期
    else if (row == 1)
    {
        [self chooseDepartDate];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGSize viewFooterSize = CGSizeMake(tableView.frame.size.width, 0);
    [self setupTableViewFooterSubs:nil inSize:&viewFooterSize];
    
    return viewFooterSize.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGSize viewFooterSize = CGSizeMake(tableView.frame.size.width, 0);
    UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewFooterSize.width, viewFooterSize.height)];
    [self setupTableViewFooterSubs:viewFooter inSize:&viewFooterSize];
    
    return viewFooter;
}

// =======================================================================
#pragma mark - TextFieldDelegate代理函数
// =======================================================================
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField setPlaceholder:@""];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _viewResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setPlaceholder:@"请输入航班号（如MU1883）"];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return [textField shouldChangeInRange:range withString:string andLength:kFStatusNumberMaxLength];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
