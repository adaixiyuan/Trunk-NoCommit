//
//  TrainHomeVC.m
//  ElongClient
//
//  Created by bruce on 13-10-30.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainHomeVC.h"
#import "TrainSearchListVC.h"
#import "TrainList.h"
#import "TrainListSearchParam.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kTrainHomeTrainCityCellHeight               80
#define kTrainHomeTrainDateCellHeight               90
#define kTrainHomeCellSeparateLineHeight            1
#define kTrainHomeTrainIconWidth                    20
#define kTrainHomeTrainIconHeight                   24
#define kTrainHomeTrainCityViewWidth                104
#define kTrainHomeCityExchangeIconWidth             30
#define kTrainHomeCityExchangeIconHeight            30
#define kTrainHomeCellSelectBgViewHeight            78
#define kTrainHomeDateIconWidth                     21
#define kTrainHomeDateIconHeight                    24
#define kTrainHomeArrowIconWidth                    8
#define kTrainHomeArrowIconHeight                   12
#define kTrainHomeSearchButtonHeight                46
#define kTrainHomeFilterBgIconWidth                 19
#define kTrainHomeFilterBgIconHeight                19
#define kTrainHomeExchangeIconWidth                 32
#define kTrainHomeExchangeIconHeight                34

// 边框局
#define kTrainHomeTableViewHMargin                  15
#define kTrainHomeTableViewVMargin                  15
#define kTrainHomeTableViewMiddleVMargin            25
#define kTrainHomeTableCityMiddleHMargin            10
#define kTrainHomeTableCellHMargin                  5
#define kTrainHomeTableCellDateHMargin              3
#define kTrainHomeTableCellDateVMargin              5
#define kTrainHomeTableCellCityHMargin              2
#define kTrainHomeTableCellCityVMargin              10
#define kTrainHomeFooterMiddleVMargin               70
#define kTrainHomeFooterHMargin                     8

// 控件Tag
enum TrainHomeVCTag {
    kTrainHomeDateInitLabelTag = 100,
    kTrainHomeCityTopLineTag,
    kTrainHomeTrainIconTag,
    kTrainHomeDepartCityButtonTag,
    kTrainHomeExangeButtonTag,
    kTrainHomeArriveCityButtonTag,
    kTrainHomeDepartCityHintLabelTag,
    kTrainHomeDepartCityLabelTag,
    kTrainHomeDepartArrowTag,
    kTrainHomeArriveCityHintLabelTag,
    kTrainHomeArriveCityLabelTag,
    kTrainHomeArriveArrowTag,
    kTrainHomeDateIconTag,
    kTrainHomeDateArrowTag,
    kTrainHomeDateContentViewTag,
    kTrainHomeDepartDateHintLabelTag,
    kTrainHomeDateSelectViewTag,
    kTrainHomeDepartDayLabelTag,
    kTrainHomeDateMonthWeekViewTag,
    kTrainHomeDepartMonthLabelTag,
    kTrainHomeDepartWeedLabelTag,
    kTrainHomeSearchButtonTag,
    kTrainHomeHighTrainButtonTag,
    kTrainHomeHighTrainLabelTag,
    kTrainHomeHasTicketButtonTag,
    kTrainHomeHasTicketLabelTag,
    kTrainHomeHighTrainCheckIconTag,
    kTrainHomeHasTicketCheckIconTag,
    kTrainHomeCellDateBottomLineTag,
};


@implementation TrainHomeVC

- (void)dealloc
{
    [_tableViewParam setDataSource:nil];
    [_tableViewParam setDelegate:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)init
{
    if (self = [super initWithTopImagePath:nil andTitle:@"列车查询" style:_NavNormalBtnStyle_])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notiApplicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // 初始使用当前日期
    NSDate *departDateTmp = [NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]];
    
    [self ElcalendarViewSelectDay:nil checkinDate:departDateTmp checkoutDate:nil];
    
    // 出发城市
    NSString *departCityTmp = [self getHistoryCity:USERDEFAULT_TRAIN_DEPARTCITYNAME];
    if (departCityTmp != nil)
    {
        _departCity = departCityTmp;
    }
    else
    {
        // 默认城市
        _departCity = @"北京";
    }
    // 到达城市
    NSString *arriveCityTmp = [self getHistoryCity:USERDEFAULT_TRAIN_ARRIVALCITYNAME];
    if (arriveCityTmp != nil)
    {
        _arriveCity = arriveCityTmp;
    }
    else
    {
        _arriveCity = @"上海";
    }
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
    //注册消息关注
    [self registerNotification];
    
}

// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
- (void)back {
	//[PublicMethods closeSesameInView:self.navigationController.view];
    [super back];
}

// 出发城市按钮触发
- (void)departCityPressed:(id)sender
{
    if (_isViewPushHappen)
        return;
    
    // 保存页面push的Flag
    _isViewPushHappen = YES;
    
    SelectCity *selectCity = [[SelectCity alloc] init:@"出发站" style:_NavOnlyBackBtnStyle_ citylable:nil cityType:SelectCityTypeTrainDepart isSave:NO];
    [selectCity setCityDelegate:self];
    //
    [self setCitySelectType:eTDepartCity];
    
    
	[self.navigationController pushViewController:selectCity animated:YES];
    
    
    UMENG_EVENT(UEvent_Train_Search_DepartureStationChoice)
}

// 到达城市按钮触发
- (void)arriveCityPressed:(id)sender
{
    if (_isViewPushHappen)
        return;
    
    // 保存页面push的Flag
    _isViewPushHappen = YES;
    
    SelectCity *selectCity = [[SelectCity alloc] init:@"到达站" style:_NavOnlyBackBtnStyle_ citylable:nil cityType:SelectCityTypeTrainArrive isSave:NO];
    [selectCity setCityDelegate:self];
    //
    [self setCitySelectType:eTArriveCity];
    
	[self.navigationController pushViewController:selectCity animated:YES];
    
    UMENG_EVENT(UEvent_Train_Search_ArrivalStationChoice)
}

// 城市交换事件
- (void)exchangeCityPressed:(id)sender
{
    // 交换城市
    NSString *cityTmp = _departCity;
    
    _departCity = _arriveCity;
    _arriveCity = cityTmp;
    UILabel *labelDepartCity = (UILabel *)[self.view viewWithTag:kTrainHomeDepartCityLabelTag];
    UILabel *labelArriveCity = (UILabel *)[self.view viewWithTag:kTrainHomeArriveCityLabelTag];
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
    // =========================
    // 保存搜索过的历史城市
    // =========================
    [self saveHistoryCity:_departCity andKeyname:USERDEFAULT_TRAIN_DEPARTCITYNAME];
    [self saveHistoryCity:_arriveCity andKeyname:USERDEFAULT_TRAIN_ARRIVALCITYNAME];
    
    
    // ===========================================
    // 列车列表搜索
    // ===========================================
    // 请求参数
    TrainListSearchParam *trainListSearchParam = [[TrainListSearchParam alloc] init];
    
    // 出发城市
    [trainListSearchParam setStartStation:_departCity];
    
    // 到达城市
    [trainListSearchParam setEndStation:_arriveCity];
    
    // 出发日期
    [trainListSearchParam setStartDate:_departDate];
    
    // 列车类型
    [trainListSearchParam setTrainType:@"0"];
    
    // ota厂商
    [trainListSearchParam setWrapperId:@"ika0000000"];
    
    // 组织Json数据
	NSMutableDictionary *dictionaryJson = [[NSMutableDictionary alloc] init];
	[trainListSearchParam serialSearchParam:dictionaryJson];
    
    // 请求参数
    NSString *paramJson = [dictionaryJson JSONString];
    
    // 请求url
    NSString *url = [PublicMethods composeNetSearchUrl:@"mytrain"
                                            forService:@"startEndInfos"
                                              andParam:paramJson];
    
    if (url != nil)
    {
        [HttpUtil requestURL:url postContent:nil delegate:self];
    }
    
    // 搜索，记录出发和到达城市
    if (UMENG) {
        NSDictionary *trainSearchInfo = [NSDictionary dictionaryWithObjectsAndKeys:_departCity,@"DepartCity",_arriveCity,@"ArriveCity", nil];
        [MobClick event:Event_TrainSearch attributes:trainSearchInfo];
    }
    
    UMENG_EVENT(UEvent_Train_Search_Search)
}

// 选择触发日期
- (void)chooseDepartDate
{
    if (_isViewPushHappen)
        return;
    
    // 保存页面push的Flag
    _isViewPushHappen = YES;
    
    // 日期转换
    NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
    [oFormat setDateFormat:@"yyyy-MM-dd"];
    
    // 日历界面
    ELCalendarViewController *calendar=[[ELCalendarViewController alloc] initWithCheckIn:[oFormat dateFromString:_departDate] checkOut:nil type:TrainCalendar];
    calendar.delegate=self;
    
    [self.navigationController pushViewController:calendar animated:YES];
    
    UMENG_EVENT(UEvent_Train_Search_DepartureDateChoice)
    
}

// 高铁/动车选择
- (void)highTrainBtnSelect:(id)sender
{
    _isSelectHighTrain = !_isSelectHighTrain;
    
    [_tableViewParam reloadData];
    
    if (_isSelectHighTrain) {
        UMENG_EVENT(UEvent_Train_Search_OnlyDG)
    }
}

// 有票列车选择
- (void)hasTicketBtnSelect:(id)sender
{
    _isSelectTicket = !_isSelectTicket;
    
    [_tableViewParam reloadData];
    
    if (_isSelectTicket) {
        UMENG_EVENT(UEvent_Train_Search_OnlyTicket)
    }
}


- (void)combinationDepartDateWithDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
	[format setDateFormat:@"E,MMMM,d"];
    
    // 显示日期
	NSArray *dateCompents = [Utils switchMonth:[[format stringFromDate:date] componentsSeparatedByString:@","]];
	
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
    double interval = [date timeIntervalSinceNow]/86400.0;
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

// =======================================================================
#pragma mark - 城市选择回调
// =======================================================================
- (void)selectCityBack:(NSString *)cityName
{
    // 保存页面push的Flag
    _isViewPushHappen = NO;
    
    if (STRINGHASVALUE(cityName))
    {
        if (_citySelectType == eTDepartCity)
        {
            _departCity = [cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        else if (_citySelectType == eTArriveCity)
        {
            _arriveCity = [cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
            
        }
        
        [_tableViewParam reloadData];
    }
}

// =======================================================================
#pragma mark - 日历代理回调
// =======================================================================
- (void) ElcalendarViewSelectDay:(ELCalendarViewController *)elViewController checkinDate:(NSDate *)cinDate checkoutDate:(NSDate *)coutDate
{
    // 保存页面push的Flag
    _isViewPushHappen = NO;
    
    if (cinDate != nil)
    {
        NSDateFormatter *oFormat = [[NSDateFormatter alloc] init];
        [oFormat setDateFormat:@"yyyy-MM-dd"];
        
        // 保存日期搜索使用
        NSString *dateString = [oFormat stringFromDate:cinDate];
        _departDate = [[dateString componentsSeparatedByString:@","] objectAtIndex:0];
        self.deDate = cinDate;
        
        [self combinationDepartDateWithDate:cinDate];
    }
}


- (void)notiApplicationDidBecomeActive:(NSNotification *)noti
{
    /*
     * 用户切回前台时，如果是起飞日期小于当前日期的情况，需要更新日期；
     */
    
    NSString *nowDescription = [PublicMethods descriptionFromDate:[NSDate date]];   // 当前日期的描述，只会是“今天”
    NSString *lastDescription = [PublicMethods descriptionFromDate:_deDate];  // 上次关闭时的日期描述，有可能是比今天早或者比今天晚
    NSLog(@"%@===%@", [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]], [_deDate descriptionWithLocale:[NSLocale currentLocale]]);
    
    if ([nowDescription isEqualToString:lastDescription] )
    {
        // 如果当前的日期和上次关闭时都是今天的情况，不做处理
        return;
    }
    
    // 其它情况都要刷新日期
    if ([_deDate earlierDate:[NSDate date]] == _deDate)
    {
        [self combinationDepartDateWithDate:[NSDate dateWithTimeInterval:86400 sinceDate:[NSDate date]]];
    }
}

// =======================================================================
#pragma mark - 网络请求回调
// =======================================================================
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    NSDictionary *root = [PublicMethods unCompressData:responseData];
//    NSLog(@"%@", root);
    
    if ([Utils checkJsonIsError:root]) {
        return;
    }
    
    if (root != nil)
    {
        TrainList *trainList = [[TrainList alloc] init];
        [trainList parseSearchResult:root];
        
        NSNumber *isError = [trainList isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            TrainSearchListVC *controller = [[TrainSearchListVC alloc] init];
            
            [controller setTrainListCur:trainList];
            [controller setDepartCity:_departCity];
            [controller setArriveCity:_arriveCity];
            [controller setDepartDate:_departDate];
            [controller setFilterInfo:[self getTrainFilter]];
            [controller setHasTicketFilte:_isSelectTicket];
            
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        else
        {
            NSString *errorMessage = [trainList errorMessage];
            if (STRINGHASVALUE(errorMessage))
            {
                [Utils alert:errorMessage];
            }
        }
    }
    else
    {
        [Utils alert:@"服务器错误"];
    }
    
    
}


// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
- (void)saveHistoryCity:(NSString *)cityName andKeyname:(NSString *)keyname
{
    BOOL hasDuplicate = NO;
    NSInteger duplicateIndex = 0;
    
    // 存储
    
    NSMutableArray *arrayHistoryCity = [NSMutableArray arrayWithArray:[[ElongUserDefaults sharedInstance] objectForKey:keyname]] ;
    BOOL canSaveCity = YES;      // 标记是否可存储当前城市
    if (arrayHistoryCity == nil)
    {
        arrayHistoryCity = [[NSMutableArray alloc] init];
        canSaveCity = YES;
    }
    else
    {
        for (NSInteger i=0; i<[arrayHistoryCity count]; i++)
        {
            NSArray *arrayCityValue = [arrayHistoryCity objectAtIndex:i];
            if (arrayCityValue != nil && [arrayCityValue count]>0)
            {
                NSString *historyCityName = [arrayCityValue objectAtIndex:0];
                if (historyCityName == nil || [historyCityName length] <=0 || ([historyCityName isEqualToString:cityName] == YES))
                {
                    hasDuplicate = YES;
                    duplicateIndex = i;
                }
            }
        }
    }
    
    if (canSaveCity)
    {
        // 去重复
        if (hasDuplicate)
        {
            [arrayHistoryCity removeObjectAtIndex:duplicateIndex];
        }
        
        // 多余3个去掉最后一个
        if ([arrayHistoryCity count] >= 3)
        {
            [arrayHistoryCity removeLastObject];
        }
        
        //
        NSArray *arrayCityInsert = [NSArray arrayWithObjects:cityName, @"",@"", nil];
        
        
        [arrayHistoryCity insertObject:arrayCityInsert atIndex:0];
        
        [[ElongUserDefaults sharedInstance] setObject:arrayHistoryCity forKey:keyname];

    }
}

// 获取历史城市
- (NSString *)getHistoryCity:(NSString *)keyname
{
    // 历史城市
    NSMutableArray *arrayHistoryCity = [[ElongUserDefaults sharedInstance] objectForKey:keyname];
    // 取出列车历史城市
    if (arrayHistoryCity != nil && [arrayHistoryCity count] > 0)
    {
        NSArray *arrayCityValue = [arrayHistoryCity objectAtIndex:0];
        if (arrayCityValue != nil && [arrayCityValue count]>0)
        {
            NSString *historyCityName = [arrayCityValue objectAtIndex:0];
            if (historyCityName != nil)
            {
                return historyCityName;
            }
        }
    }
    
    return nil;
}

// 设置列车筛选内容
- (NSDictionary *)getTrainFilter
{
    NSMutableDictionary *filterInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    NSMutableArray *typeResultArray = [NSMutableArray arrayWithCapacity:0];
    if (_isSelectHighTrain)
    {
        [typeResultArray addObject:[NSString stringWithFormat:@"%d", 1]];
        [typeResultArray addObject:[NSString stringWithFormat:@"%d", 2]];
    }
    else
    {
        [typeResultArray addObject:[NSString stringWithFormat:@"%d", 0]];
    }
    [filterInfo setValue:typeResultArray forKey:[NSString stringWithFormat:@"%d", FilterType]];
    
    
    // 发车时间
    NSArray *arrayDepartTime = nil;
    
    [filterInfo setValue:arrayDepartTime forKey:[NSString stringWithFormat:@"%d", FilterDepartureTime]];
    
    // 到达时间
    NSArray *arrayArriveTime = nil;
    
    [filterInfo setValue:arrayArriveTime forKey:[NSString stringWithFormat:@"%d", FilterArrivalTime]];
    
    
    return filterInfo;
}

//注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTrainTypeStatus:) name:kTrainTypeChangeNotification object:nil];
}


//更新列车查询类型状态
- (void)updateTrainTypeStatus:(NSNotification *)sender
{
    NSDictionary *trainTypeDictionary = (NSDictionary *)[sender object];
    if (trainTypeDictionary!=nil && [trainTypeDictionary isKindOfClass:[NSDictionary class]])
    {
        NSNumber *trainType = [trainTypeDictionary safeObjectForKey:kTrainType];
        if (trainType != nil && [trainType boolValue]== YES)
        {
            _isSelectHighTrain = YES;
        }
        else
        {
            _isSelectHighTrain = NO;
        }
        [_tableViewParam reloadData];
    }
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
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceYStart += kTrainHomeTableViewMiddleVMargin;
    
    // =======================================================================
    // 搜索条件TableView
    // =======================================================================
    // 创建TableView
	UITableView *tableViewParamTmp = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	[tableViewParamTmp setFrame:CGRectMake(spaceXStart, spaceYStart, spaceXEnd-spaceXStart,
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

// 创建列车出发到达城市子界面
- (void)setupCellTrainCitySubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
	NSInteger spaceXStart = 0;
    
    // =======================================================================
    // 分隔线
    // =======================================================================
    CGSize topLineSize = CGSizeMake(parentFrame.size.width, kTrainHomeCellSeparateLineHeight);
    UIImageView *imageViewTopLine = (UIImageView *)[viewParent viewWithTag:kTrainHomeCityTopLineTag];
    if (imageViewTopLine == nil)
    {
        imageViewTopLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewTopLine setImage:[UIImage imageNamed:@"dashed.png"]];
        [imageViewTopLine setTag:kTrainHomeCityTopLineTag];
        [imageViewTopLine setAlpha:0.7];
        
        // 添加到父窗口
        [viewParent addSubview:imageViewTopLine];
    }
    [imageViewTopLine setFrame:CGRectMake(0, 0, topLineSize.width,topLineSize.height)];
    
    // 间隔
    spaceXStart += kTrainHomeTableViewHMargin;
    
    spaceXStart += kTrainHomeTableCellHMargin;
    
    // =======================================================================
    // 列车Icon
    // =======================================================================
    CGSize trainIconSize = CGSizeMake(kTrainHomeTrainIconWidth, kTrainHomeTrainIconHeight);
    
    UIImageView *trainIcon = (UIImageView *)[viewParent viewWithTag:kTrainHomeTrainIconTag];
    if (trainIcon == nil)
    {
        trainIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [trainIcon setImage:[UIImage noCacheImageNamed:@"ico_traincityleft.png"]];
        [trainIcon setTag:kTrainHomeTrainIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:trainIcon];
    }
    [trainIcon setFrame:CGRectMake(spaceXStart, parentFrame.size.height*0.4, trainIconSize.width, trainIconSize.height)];
    
    // 子窗口大小
    spaceXStart += trainIconSize.width;
    
    // 间隔
    spaceXStart +=kTrainHomeTableCellHMargin;
    
    // =======================================================================
    // 出发城市
    // =======================================================================
    
    // 事件按钮
    CGSize departCitySize = CGSizeMake(kTrainHomeTrainCityViewWidth, parentFrame.size.height- kTrainHomeCellSeparateLineHeight*6);
    
    UIButton *buttonDepartCity = (UIButton *)[viewParent viewWithTag:kTrainHomeDepartCityButtonTag];
    if (buttonDepartCity == nil)
    {
        buttonDepartCity = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buttonDepartCity setBackgroundImage:[[UIImage imageNamed:@"flight_press.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateHighlighted];
        [buttonDepartCity addTarget:self action:@selector(departCityPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonDepartCity setTag:kTrainHomeDepartCityButtonTag];
        // 保存
        [viewParent addSubview:buttonDepartCity];
    }
    [buttonDepartCity setFrame:CGRectMake(spaceXStart, kTrainHomeCellSeparateLineHeight*3, departCitySize.width, departCitySize.height)];
    
    // 创建子界面
    [self setupDepartCity:buttonDepartCity];
    
    // 城市Label
    if (_departCity != nil && [_departCity length] > 0)
    {
        CGSize citySize = [_departCity sizeWithFont:[UIFont boldSystemFontOfSize:24.0f]];
        
        UILabel *labelDepartCity = (UILabel *)[viewParent viewWithTag:kTrainHomeDepartCityLabelTag];
        if (labelDepartCity == nil)
        {
            labelDepartCity = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelDepartCity setBackgroundColor:[UIColor clearColor]];
            [labelDepartCity setFont:[UIFont boldSystemFontOfSize:24.0f]];
            [labelDepartCity setTextColor:[UIColor blackColor]];
            [labelDepartCity setTextAlignment:UITextAlignmentCenter];
            [labelDepartCity setAdjustsFontSizeToFitWidth:YES];
            [labelDepartCity setMinimumFontSize:10.0f];
            [labelDepartCity setTag:kTrainHomeDepartCityLabelTag];
            // 保存
            [viewParent addSubview:labelDepartCity];
        }
        [labelDepartCity setFrame:CGRectMake(spaceXStart, parentFrame.size.height*0.45, kTrainHomeTrainCityViewWidth-kTrainHomeArrowIconWidth-kTrainHomeTableCellCityHMargin, citySize.height)];
        [labelDepartCity setText:_departCity];
        
    }
    
    // 子窗口大小
    spaceXStart += departCitySize.width;
    
    // 间隔
    spaceXStart += kTrainHomeTableCityMiddleHMargin;
    
    
    // =======================================================================
    // 交换Icon
    // =======================================================================
    CGSize exchangeIconSize = CGSizeMake(kTrainHomeExchangeIconWidth, kTrainHomeExchangeIconHeight);
    
    UIButton *buttonExchange = (UIButton *)[viewParent viewWithTag:kTrainHomeExangeButtonTag];
    if (buttonExchange == nil)
    {
        buttonExchange = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buttonExchange setBackgroundImage:[UIImage imageNamed:@"btn_exchangeicon.png"] forState:UIControlStateNormal];
        [buttonExchange addTarget:self action:@selector(exchangeCityPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonExchange setTag:kTrainHomeExangeButtonTag];
        // 保存
        [viewParent addSubview:buttonExchange];
    }
    [buttonExchange setFrame:CGRectMake(spaceXStart, parentFrame.size.height*0.38, exchangeIconSize.width, exchangeIconSize.height)];
    
    // 子窗口大小
    spaceXStart += exchangeIconSize.width;
    
    
    // 间隔
    spaceXStart +=kTrainHomeTableCityMiddleHMargin;
    
    // =======================================================================
    // 到达城市
    // =======================================================================
    CGSize arriveCitySize = CGSizeMake(kTrainHomeTrainCityViewWidth, parentFrame.size.height-kTrainHomeCellSeparateLineHeight*6);
    
    UIButton *buttonArriveCity = (UIButton *)[viewParent viewWithTag:kTrainHomeArriveCityButtonTag];
    if (buttonArriveCity == nil)
    {
        buttonArriveCity = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buttonArriveCity setBackgroundImage:[[UIImage imageNamed:@"flight_press.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateHighlighted];
        
        [buttonArriveCity addTarget:self action:@selector(arriveCityPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonArriveCity setTag:kTrainHomeArriveCityButtonTag];
        // 保存
        [viewParent addSubview:buttonArriveCity];
    }
    [buttonArriveCity setFrame:CGRectMake(spaceXStart, kTrainHomeCellSeparateLineHeight*3, arriveCitySize.width, arriveCitySize.height)];
    
    // 创建子界面
    [self setupArriveCity:buttonArriveCity];
    
    // 城市Label
    if (_arriveCity != nil && [_arriveCity length] > 0)
    {
        CGSize citySize = [_arriveCity sizeWithFont:[UIFont boldSystemFontOfSize:24.0f]];
        
        UILabel *labelArriveCity = (UILabel *)[viewParent viewWithTag:kTrainHomeArriveCityLabelTag];
        if (labelArriveCity == nil)
        {
            labelArriveCity = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelArriveCity setBackgroundColor:[UIColor clearColor]];
            [labelArriveCity setFont:[UIFont boldSystemFontOfSize:24.0f]];
            [labelArriveCity setTextColor:[UIColor blackColor]];
            [labelArriveCity setTextAlignment:UITextAlignmentCenter];
            [labelArriveCity setAdjustsFontSizeToFitWidth:YES];
            [labelArriveCity setMinimumFontSize:10.0f];
            [labelArriveCity setTag:kTrainHomeArriveCityLabelTag];
            
            // 保存
            [viewParent addSubview:labelArriveCity];
        }
        [labelArriveCity setFrame:CGRectMake(spaceXStart, parentFrame.size.height*0.45, kTrainHomeTrainCityViewWidth-kTrainHomeArrowIconWidth-kTrainHomeTableCellCityHMargin, citySize.height)];
        [labelArriveCity setText:_arriveCity];
        
    }
    
    
    [viewParent bringSubviewToFront:buttonExchange];
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
    spaceXEnd -= kTrainHomeTableCellCityHMargin;
    spaceYStart += kTrainHomeTableViewVMargin;
    
    
    // =======================================================================
    // 箭头Icon
    // =======================================================================
    CGSize arrowSize = CGSizeMake(kTrainHomeArrowIconWidth, kTrainHomeArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kTrainHomeDepartArrowTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [arrowIcon setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        [arrowIcon setTag:kTrainHomeDepartArrowTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(spaceXEnd-arrowSize.width, parentFrame.size.height*0.5, arrowSize.width, arrowSize.height)];
    
    // 子窗口高宽
    spaceXEnd -= arrowSize.width;
    
    // 间隔
    spaceXEnd -= kTrainHomeTableCellCityHMargin;
    
    // 城市Hint Label
    NSString *departCityHint = @"出发站";
    CGSize hintSize = [departCityHint sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kTrainHomeDepartCityHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont systemFontOfSize:12.0f]];
        [labelHint setTextColor:[UIColor grayColor]];
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setAdjustsFontSizeToFitWidth:YES];
        [labelHint setMinimumFontSize:10.0f];
        [labelHint setTag:kTrainHomeDepartCityHintLabelTag];
        // 保存
        [viewParent addSubview:labelHint];
    }
    [labelHint setFrame:CGRectMake(0, spaceYStart, spaceXEnd, hintSize.height)];
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
    spaceXEnd -= kTrainHomeTableCellCityHMargin;
    spaceYStart += kTrainHomeTableViewVMargin;
    
    
    // =======================================================================
    // 箭头Icon
    // =======================================================================
    CGSize arrowSize = CGSizeMake(kTrainHomeArrowIconWidth, kTrainHomeArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kTrainHomeArriveArrowTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [arrowIcon setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        [arrowIcon setTag:kTrainHomeArriveArrowTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(spaceXEnd-arrowSize.width, parentFrame.size.height*0.5, arrowSize.width, arrowSize.height)];
    
    // 子窗口高宽
    spaceXEnd -= arrowSize.width;
    
    // 城市Hint Label
    NSString *arriveCityHint = @"到达站";
    CGSize hintSize = [arriveCityHint sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kTrainHomeArriveCityHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont systemFontOfSize:12.0f]];
        [labelHint setTextColor:[UIColor grayColor]];
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setAdjustsFontSizeToFitWidth:YES];
        [labelHint setMinimumFontSize:10.0f];
        [labelHint setTag:kTrainHomeArriveCityHintLabelTag];
        
        // 保存
        [viewParent addSubview:labelHint];
    }
    [labelHint setFrame:CGRectMake(0, spaceYStart, spaceXEnd, hintSize.height)];
    [labelHint setText:arriveCityHint];

    
}


// 创建列车出发日期子界面
- (void)setupCellTrainDateSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
	NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = parentFrame.size.width;
    
    CGSize bottomLineSize = CGSizeMake(pViewSize->width, kTrainHomeCellSeparateLineHeight);
    UIImageView *imageViewBottomLine = (UIImageView *)[viewParent viewWithTag:kTrainHomeCellDateBottomLineTag];
    if (imageViewBottomLine == nil)
    {
        imageViewBottomLine = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageViewBottomLine setImage:[UIImage imageNamed:@"dashed.png"]];
        [imageViewBottomLine setTag:kTrainHomeCellDateBottomLineTag];
        [imageViewBottomLine setAlpha:0.7];
        
        // 添加到父窗口
        [viewParent addSubview:imageViewBottomLine];
    }
    [imageViewBottomLine setFrame:CGRectMake(0, pViewSize->height-bottomLineSize.height, bottomLineSize.width,bottomLineSize.height)];
    
    // 间隔
    spaceXStart += kTrainHomeTableViewHMargin+kTrainHomeTableCellHMargin;
    spaceXEnd -= kTrainHomeTableViewHMargin+kTrainHomeTableCellCityHMargin;
    
    
    // =======================================================================
    // 箭头Icon
    // =======================================================================
    CGSize arrowSize = CGSizeMake(kTrainHomeArrowIconWidth, kTrainHomeArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kTrainHomeDateArrowTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [arrowIcon setImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
        [arrowIcon setTag:kTrainHomeDateArrowTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(spaceXEnd-arrowSize.width, parentFrame.size.height*0.5, arrowSize.width, arrowSize.height)];
    
    // =======================================================================
    // 日期Icon
    // =======================================================================
    CGSize dateIconSize = CGSizeMake(kTrainHomeDateIconWidth, kTrainHomeDateIconHeight);
    
    UIImageView *dateIcon = (UIImageView *)[viewParent viewWithTag:kTrainHomeDateIconTag];
    if (dateIcon == nil)
    {
        dateIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [dateIcon setImage:[UIImage imageNamed:@"ico_traindate.png"]];
        [dateIcon setTag:kTrainHomeDateIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:dateIcon];
    }
    [dateIcon setFrame:CGRectMake(spaceXStart, (parentFrame.size.height - dateIconSize.height)/2, dateIconSize.width, dateIconSize.height)];
    
    // 子窗口大小
    spaceXStart += dateIconSize.width;
    
    
    // 间隔
    spaceXStart +=kTrainHomeTableCellHMargin;
        
    // 间隔
    spaceXEnd -= kTrainHomeTableCellHMargin;
    
    // =======================================================================
    // 日期选择内容
    // =======================================================================
    CGSize viewContentSize = CGSizeMake(0, 0);
    
    UIView *viewContent = [viewParent viewWithTag:kTrainHomeDateContentViewTag];
    if (viewContent == nil)
    {
        viewContent = [[UIView alloc] initWithFrame:CGRectZero];
        [viewContent setTag:kTrainHomeDateContentViewTag];
        // 保存
        [viewParent addSubview:viewContent];
    }
    [viewContent setFrame:CGRectMake(spaceXStart, 0, viewContentSize.width, viewContentSize.height)];
    
    // 创建子界面
    [self setupCellTrainDateContentSubs:viewContent inSize:&viewContentSize];
    
    
    // 调整界面位置
    [viewContent setViewX:spaceXStart + (spaceXEnd-spaceXStart-viewContentSize.width)/2];
    [viewContent setViewY:(parentFrame.size.height-viewContentSize.height)/2];
}

// 创建列车出发日期子界面
- (void)setupCellTrainDateContentSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    NSInteger subsWidth = 0;
    
    // 隐藏的原始日期Label
    UILabel *labelDateInit = (UILabel *)[viewParent viewWithTag:kTrainHomeDateInitLabelTag];
    if (labelDateInit == nil)
    {
        labelDateInit = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDateInit setBackgroundColor:[UIColor clearColor]];
        [labelDateInit setFont:[UIFont systemFontOfSize:12.0f]];
        [labelDateInit setTextColor:[UIColor lightGrayColor]];
        [labelDateInit setHidden:YES];
        [labelDateInit setTag:kTrainHomeDateInitLabelTag];
//        [labelDateInit addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
        
        // 保存
        [viewParent addSubview:labelDateInit];
    }
    [labelDateInit setFrame:CGRectMake(0, spaceYStart, pViewSize->width, pViewSize->height)];
    [labelDateInit setText:_departDate];
    
    // =======================================================================
    // 日期选择提示
    // =======================================================================
    NSString *dateHint = @"出发日期";
    CGSize hintSize = [dateHint sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kTrainHomeDepartDateHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont systemFontOfSize:12.0f]];
        [labelHint setTextColor:[UIColor grayColor]];
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setAdjustsFontSizeToFitWidth:YES];
        [labelHint setMinimumFontSize:10.0f];
        [labelHint setTag:kTrainHomeDepartDateHintLabelTag];
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
    
    UIView *viewDateSelect = [viewParent viewWithTag:kTrainHomeDateSelectViewTag];
    if (viewDateSelect == nil)
    {
        viewDateSelect = [[UIView alloc] initWithFrame:CGRectZero];
        [viewDateSelect setTag:kTrainHomeDateSelectViewTag];
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
    
    UILabel *labelDepartDay = (UILabel *)[viewParent viewWithTag:kTrainHomeDepartDayLabelTag];
    if (labelDepartDay == nil)
    {
        labelDepartDay = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDepartDay setBackgroundColor:[UIColor clearColor]];
        [labelDepartDay setFont:[UIFont fontWithName:@"Helvetica" size:41]];
        [labelDepartDay setTextColor:[UIColor blackColor]];
        [labelDepartDay setTextAlignment:UITextAlignmentCenter];
        [labelDepartDay setTag:kTrainHomeDepartDayLabelTag];
        // 保存
        [viewParent addSubview:labelDepartDay];
    }
    [labelDepartDay setFrame:CGRectMake(0, 0, daySize.width, daySize.height)];
    [labelDepartDay setText:_departDay];
    
    // 子窗口大小
    spaceXStart += daySize.width;
    subsHeight = daySize.height;
    
    // 间隔
    spaceXStart += kTrainHomeTableCellHMargin;
    
    // =======================================================================
    // 出发日期月和周
    // =======================================================================
    CGSize viewMonthWeekSize = CGSizeMake(0, 0);
    
    UIView *viewMonthWeek = [viewParent viewWithTag:kTrainHomeDateMonthWeekViewTag];
    if (viewMonthWeek == nil)
    {
        viewMonthWeek = [[UIView alloc] initWithFrame:CGRectZero];
        [viewMonthWeek setTag:kTrainHomeDateMonthWeekViewTag];
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
    
    UILabel *labelDepartMonth = (UILabel *)[viewParent viewWithTag:kTrainHomeDepartMonthLabelTag];
    if (labelDepartMonth == nil)
    {
        labelDepartMonth = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDepartMonth setBackgroundColor:[UIColor clearColor]];
        [labelDepartMonth setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        [labelDepartMonth setTextColor:[UIColor blackColor]];
        [labelDepartMonth setTextAlignment:UITextAlignmentCenter];
        [labelDepartMonth setTag:kTrainHomeDepartMonthLabelTag];
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
    
    UILabel *labelDepartWeek = (UILabel *)[viewParent viewWithTag:kTrainHomeDepartWeedLabelTag];
    if (labelDepartWeek == nil)
    {
        labelDepartWeek = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDepartWeek setBackgroundColor:[UIColor clearColor]];
        [labelDepartWeek setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        [labelDepartWeek setTextColor:[UIColor blackColor]];
        [labelDepartWeek setTextAlignment:UITextAlignmentLeft];
        [labelDepartWeek setTag:kTrainHomeDepartWeedLabelTag];
        
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


// 创建详细信息cell分隔线子界面
- (void)setupCellSeparateLineSubs:(UIView *)viewParent withWidth:(CGFloat)width andAlpha:(CGFloat)alpha
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
	
//    [viewParent setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1.0]];
	// 背景ImageView
	UIImageView *imageViewBG = [[UIImageView alloc] initWithFrame:CGRectZero];
	[imageViewBG setFrame:CGRectMake(parentFrame.size.width-width, parentFrame.size.height - kTrainHomeCellSeparateLineHeight, width, kTrainHomeCellSeparateLineHeight)];
	[imageViewBG setImage:[UIImage imageNamed:@"dashed.png"]];
    [imageViewBG setAlpha:alpha];
	
	// 添加到父窗口
	[viewParent addSubview:imageViewBG];
}

// 创建Footer子界面
- (void)setupTableViewFooterSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // 间隔
    spaceYStart += kTrainHomeTableViewVMargin;
    
    // =======================================================================
	// 筛选条件项
	// =======================================================================
    CGSize viewFilterSize = CGSizeMake(parentFrame.size.width-kTrainHomeTableViewHMargin*2, 0);
    
    // 创建视图
    if (viewParent != nil)
    {
        UIView *viewFilter = [[UIView alloc] initWithFrame:CGRectMake(kTrainHomeTableViewHMargin, spaceYStart, viewFilterSize.width, viewFilterSize.height)];
        // 创建子界面
        [self setupFooterFilterSubs:viewFilter inSize:&viewFilterSize];
        
        // 保存
        [viewParent addSubview:viewFilter];
    }
    
    // 调整子窗口大小
    spaceYStart += viewFilterSize.height;
    
    // 间隔
    spaceYStart += kTrainHomeFooterMiddleVMargin;
    
    
    // =======================================================================
	// 查询按钮
	// =======================================================================
    CGSize searchButtonSize = CGSizeMake(parentFrame.size.width-kTrainHomeTableViewHMargin*2, kTrainHomeSearchButtonHeight);
    
    if (viewParent != nil)
    {
        UIButton *searchButton = (UIButton *)[viewParent viewWithTag:kTrainHomeSearchButtonTag];
        if (searchButton == nil)
        {
            searchButton = [UIButton uniformButtonWithTitle:@"查  询"
                                                  ImagePath:nil
                                                     Target:self
                                                     Action:@selector(searchButtonPressed:)
                                                      Frame:CGRectMake(kTrainHomeTableViewHMargin, spaceYStart, searchButtonSize.width, searchButtonSize.height)];
            [searchButton setTag:kTrainHomeSearchButtonTag];
            // 保存
            [viewParent addSubview:searchButton];
        }
    }
    
    // 调整子窗口大小
    spaceYStart += searchButtonSize.height;
    
    // 间隔
    spaceYStart += kTrainHomeTableViewMiddleVMargin;

    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
    
}

// 创建筛选项目子界面
- (void)setupFooterFilterSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger subsHeight = 0;
    
    // 间隔
    
    spaceXStart += kTrainHomeFooterHMargin;
    
    // =======================================================================
	// 动车/高铁选项
	// =======================================================================
    CGSize imageHighTrainSize = CGSizeMake(kTrainHomeFilterBgIconWidth, kTrainHomeFilterBgIconHeight);
    
    // 创建Icon
    if (viewParent != nil)
    {
        UIImageView *highTrainIcon = (UIImageView *)[viewParent viewWithTag:kTrainHomeHighTrainCheckIconTag];
        if (highTrainIcon == nil)
        {
            highTrainIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
            [highTrainIcon setTag:kTrainHomeHighTrainCheckIconTag];
            
            // 添加到父窗口
            [viewParent addSubview:highTrainIcon];
            
        }
        [highTrainIcon setFrame:CGRectMake(spaceXStart, 0, imageHighTrainSize.width, imageHighTrainSize.height)];
        if (_isSelectHighTrain)
        {
            [highTrainIcon setImage:[UIImage noCacheImageNamed:@"btn_choice_checked.png"]];
        }
        else
        {
            [highTrainIcon setImage:[UIImage noCacheImageNamed:@"btn_choice.png"]];
        }
        
    }
    
    // 子窗口大小
    spaceXStart += imageHighTrainSize.width;
    subsHeight += imageHighTrainSize.height;
    
    // 间隔
    spaceXStart += kTrainHomeFooterHMargin;
    
    // 创建Label
    NSString *highTrainHint = @"只看动车/高铁";
    CGSize highTrainHintSize = [highTrainHint sizeWithFont:[UIFont systemFontOfSize:13.0f]];
    
    if (viewParent != nil)
    {
        UILabel *labelHighTrain = (UILabel *)[viewParent viewWithTag:kTrainHomeHighTrainLabelTag];
        if (labelHighTrain == nil)
        {
            labelHighTrain = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelHighTrain setBackgroundColor:[UIColor clearColor]];
            [labelHighTrain setText:highTrainHint];
            [labelHighTrain setFont:[UIFont systemFontOfSize:13.0f]];
            [labelHighTrain setTextColor:[UIColor blackColor]];
            [labelHighTrain setTextAlignment:UITextAlignmentCenter];
            [labelHighTrain setTag:kTrainHomeHighTrainLabelTag];
            
            // 保存
            [viewParent addSubview:labelHighTrain];
        }
        [labelHighTrain setFrame:CGRectMake(spaceXStart, (subsHeight-highTrainHintSize.height)/2, highTrainHintSize.width, highTrainHintSize.height)];
        
    }
    
    // 子窗口大小
    spaceXStart += highTrainHintSize.width;
    
    // 事件按钮
    UIButton *highTrainButton = (UIButton *)[viewParent viewWithTag:kTrainHomeHighTrainButtonTag];
    if (highTrainButton == nil)
    {
        highTrainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [highTrainButton setAdjustsImageWhenHighlighted:NO];
        [highTrainButton addTarget:self action:@selector(highTrainBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [highTrainButton setTag:kTrainHomeHighTrainButtonTag];
        
        // 保存
        [viewParent addSubview:highTrainButton];
    }
    [highTrainButton setFrame:CGRectMake(kTrainHomeFooterHMargin, 0, spaceXStart-kTrainHomeFooterHMargin, imageHighTrainSize.height*2)];
    
    
    // 间隔
    spaceXStart += kTrainHomeFooterHMargin*4;
    
    
    // =======================================================================
	// 有票列车选项
	// =======================================================================
    CGSize imageHasTicketSize = CGSizeMake(kTrainHomeFilterBgIconWidth, kTrainHomeFilterBgIconHeight);
    // 创建Icon
    if (viewParent != nil)
    {
        UIImageView *hasTicketIcon = (UIImageView *)[viewParent viewWithTag:kTrainHomeHasTicketCheckIconTag];
        if (hasTicketIcon == nil)
        {
            hasTicketIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
            [hasTicketIcon setTag:kTrainHomeHasTicketCheckIconTag];
            
            // 添加到父窗口
            [viewParent addSubview:hasTicketIcon];
            
        }
        [hasTicketIcon setFrame:CGRectMake(spaceXStart, 0, imageHasTicketSize.width, imageHasTicketSize.height)];
        if (_isSelectTicket)
        {
            [hasTicketIcon setImage:[UIImage noCacheImageNamed:@"btn_choice_checked.png"]];
        }
        else
        {
            [hasTicketIcon setImage:[UIImage noCacheImageNamed:@"btn_choice.png"]];
        }
    }
    
    // 子窗口大小
    spaceXStart += imageHasTicketSize.width;
    
    // 间隔
    spaceXStart += kTrainHomeFooterHMargin;
    
    // 创建Label
    NSString *hasTicketHint = @"只看有票列车";
    CGSize hasTicketHintSize = [hasTicketHint sizeWithFont:[UIFont systemFontOfSize:13.0f]];
    
    if (viewParent != nil)
    {
        UILabel *labelHasTicket = (UILabel *)[viewParent viewWithTag:kTrainHomeHasTicketLabelTag];
        if (labelHasTicket == nil)
        {
            labelHasTicket = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelHasTicket setBackgroundColor:[UIColor clearColor]];
            [labelHasTicket setText:hasTicketHint];
            [labelHasTicket setFont:[UIFont systemFontOfSize:13.0f]];
            [labelHasTicket setTextColor:[UIColor blackColor]];
            [labelHasTicket setTextAlignment:UITextAlignmentCenter];
            [labelHasTicket setTag:kTrainHomeHasTicketLabelTag];
            // 保存
            [viewParent addSubview:labelHasTicket];
        }
        [labelHasTicket setFrame:CGRectMake(spaceXStart, (subsHeight-hasTicketHintSize.height)/2, hasTicketHintSize.width, hasTicketHintSize.height)];
    }
    
    // 事件按钮
    UIButton *hasTicketButton = (UIButton *)[viewParent viewWithTag:kTrainHomeHasTicketButtonTag];
    if (hasTicketButton == nil)
    {
        hasTicketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [hasTicketButton setAdjustsImageWhenHighlighted:NO];
        [hasTicketButton addTarget:self action:@selector(hasTicketBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [hasTicketButton setTag:kTrainHomeHasTicketButtonTag];
        // 保存
        [viewParent addSubview:hasTicketButton];
    }
    [hasTicketButton setFrame:CGRectMake(spaceXStart-kTrainHomeFooterHMargin-imageHasTicketSize.width, 0, hasTicketHintSize.width+kTrainHomeFooterHMargin+imageHasTicketSize.width, imageHighTrainSize.height*2)];
    
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->height = subsHeight;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:subsHeight];
	}
    
}

// =======================================================================
#pragma mark - TabelViewDataSource的代理函数
// =======================================================================
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
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kTrainHomeTrainCityCellHeight);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupCellTrainCitySubs:[cell contentView] inSize:&contentViewSize];
        
        // 背景分隔线
        UIView *viewCellSeparateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupCellSeparateLineSubs:viewCellSeparateLine withWidth:contentViewSize.width*0.79 andAlpha:0.7];
        [cell setBackgroundView:viewCellSeparateLine];
        
        // 设置选中背景
        UIView* b_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentFrame.size.width, kTrainHomeCellSelectBgViewHeight)];
        b_view.backgroundColor = [UIColor clearColor];
        UIButton* b_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        b_btn.backgroundColor = [UIColor clearColor];
        b_btn.frame = CGRectMake(0, (contentViewSize.height-kTrainHomeCellSelectBgViewHeight)/2, parentFrame.size.width, kTrainHomeCellSelectBgViewHeight);
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
        CGSize contentViewSize = CGSizeMake(parentFrame.size.width, kTrainHomeTrainDateCellHeight);
        [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
        [self setupCellTrainDateSubs:[cell contentView] inSize:&contentViewSize];
        
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
        return kTrainHomeTrainCityCellHeight;
    }
    // 出发日期
    else if (row == 1)
    {
        return kTrainHomeTrainDateCellHeight;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
