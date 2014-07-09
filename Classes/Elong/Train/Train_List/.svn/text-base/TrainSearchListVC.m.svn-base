//
//  TrainSearchListVC.m
//  ElongClient
//
//  Created by bruce on 13-11-4.
//  Copyright (c) 2013年 elong. All rights reserved.
//

#import "TrainSearchListVC.h"
#import "TrainListSearchParam.h"
#import "TrainTickets.h"
#import "TrainDepartStation.h"
#import "TrainArriveStation.h"
#import "TrainSeats.h"
#import "TrainSearchDetailVC.h"
#import "TrainFillOrderVC.h"
#import "AccountManager.h"
#import "LoginManager.h"
#import "TrainReq.h"

// ==================================================================
#pragma mark - 布局参数
// ==================================================================
// 控件尺寸
#define kTrainListScreenToolBarHeight               20
#define kTrainListNavBarHeight                      44
#define kTrainListNavRefreshButtonWidth             35
#define kTrainListNavRefreshButtonHeight            35
#define kTrainListTopViewHeight                     44
#define kTrainListBottomViewHeight                  44
#define kTrainListTopButtonBgHeight                 29
#define kTrainListPreDayButtonWidth                 106
#define kTrainListCurdayButtonWidth                 108
#define kTrainListBottomFilterButtonWidth           130
#define kTrainListBottomFilterButtonHeight          30
#define kTrainListCellSeparateLineHeight            1
#define kTrainListCellArrowIconWidth                5
#define kTrainListCellArrowIconHeight               9
#define kTrainListCellDepartIconWidth               12
#define kTrainListCellDepartIconHeight              12
#define kTrainListTopViewShadowHeight               1
#define kTrainListFilterButtonBadgeWidth            4
#define kTrainListFilterButtonBadgeHeight           4
#define kTrainListSortPriceIconWidth                21
#define kTrainListSortPriceIconHeight               17
#define kTrainListSortTimeIconWidth                 25
#define kTrainListSortTimeIconHeight                17
#define kTrainListFilterIconWidth                   14
#define kTrainListFilterIconHeight                  17

// 边框局
#define kTrainListNavBarButtonHMargin               4
#define kTrainListTableViewHMargin                  8
#define kTrainListTableViewVMargin                  10
#define kTrainListTopViewButtonHMargin              10
#define kTrainListTopViewButtonMiddleHMargin        2
#define kTrainListBottomMiddleYMargin               3
#define kTrainListFilterButtonHMargin               15
#define kTrainListCellHMargin                       14
#define kTrainListCellVMargin                       6
#define kTrainListCellEdgeVMargin                   12
#define kTrainListCellMiddleHMargin                 5
#define kTrainListCellMiddleVMargin                 6
#define kTrainListCellR1ViewMiddleVMargin           2
#define kTrainListCellR1ViewMiddleHMargin           2
#define kTrainListCellR2ViewMiddleHMargin           1
#define kTrainListCellR2ViewMiddleVMargin           1
#define kTrainListCellIconYMargin                   3

// 控件Tag
enum TrainListVCTag {
    kTrainListTopPredayButtonTag = 100,
    kTrainListTopViewShadowTag,
    kTrainListTopCurdayButtonTag,
    kTrainListTopNextdayButtonTag,
    kTrainListTopLeftArrowIconTag,
    kTrainListTopRightArrowIconTag,
    kTrainListDateInitLabelTag,
    kTrainListTopPredayHintLabelTag,
    kTrainListTopCurdayDateLabelTag,
    kTrainListTopCurdayWeekLabelTag,
    kTrainListTopNextdayHintLabelTag,
    kTrainListSortPriceButtonTag,
    kTrainListSortTimeButtonTag,
    kTrainListSortPriceIconTag,
    kTrainListSortPriceLabelTag,
    kTrainListSortTimeIconTag,
    kTrainListSortTimeLabelTag,
    kTrainListFilterIconTag,
    kTrainListFilterLabelTag,
    kTrainListBottomFilterButtonTag,
    kTrainListBottomFilterButtonBadgeTag,
    kTrainListBottomSortButtonTag,
    kTrainListCellTrainInfoR1ViewTag,
    kTrainListCellTrainInfoR2ViewTag,
    kTrainListCellTrainNumberLabelTag,
    kTrainListCellRightArrowTag,
    kTrainListCellPriceHintLabelTag,
    kTrainListCellPriceLabelTag,
    kTrainListCellCurrencySignLabelTag,
    kTrainListCellDepartIconTag,
    kTrainListCellArriveIconTag,
    kTrainListCellDepartStationLabelTag,
    kTrainListCellArriveStationLabelTag,
    kTrainListCellDepartTimeLabelTag,
    kTrainListCellArriveTimeLabelTag,
    kTrainListCellYpMessageLabelTag,
    kTrainListCellDurationLabelTag,
    kTrainListCellTicketInfoLabelTag,
    kTrainListCellTrainInfoDepartViewTag,
    kTrainListCellTrainInfoArriveViewTag,
    kTrainListCellCellNoResultHintLabelTag,
    kTrainListCellTrainInfoBottomLineTag,
};

typedef enum sortType : NSUInteger
{
    eTSortPrce = 1,
    eTSortTime,
} TrainListSortType;


@implementation TrainSearchListVC


- (id)initWithTitle:(NSString *)title
{
    if(self = [self init])
	{
		return self;
	}
    
    return nil;
}

- (void)dealloc
{
    [_tableViewList setDataSource:nil];
    [_tableViewList setDelegate:nil];
    
    //清空
    [TrainIdenfyCodeModel clearIdentifyCodeData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //
    _arrayTickets = [_trainListCur arrayTickets];
    
    // 初始化排序为升序
    _isTimeAscending = YES;
    _isPriceReset = YES;
    
    // 网络加载状态
    _isNetLoading = NO;
    
    // 获取日期格式
    [self dateRefresh];
    
    // 创建Root View的子视图
	[self setupViewRootSubs:[self view]];
    
    // 筛选数据
    [self filteDataStart];
    
    //获取验证码开关是否打开
    _trainIdenfyCodeTool=[[TrainIdenfyCodeModel alloc] init];
    [_trainIdenfyCodeTool sendIdentifyCodeRequest];
}

- (void)viewDidAppear:(BOOL)animated
{
    UITableViewCell *cell = [_tableViewList cellForRowAtIndexPath:_selectedIndexPath];
    if (cell.isSelected) {
        [cell setSelected:NO animated:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    // net
    if (_isNetLoading)
    {
        [_getListUtil cancel];
        [_getListUtil setDelegate:nil];
    }
}

// =======================================================================
#pragma mark - 事件处理函数
// =======================================================================
// 上一天
- (void)preDayPressed:(id)sender
{
    NSDate *curDate = [_oFormat dateFromString:_departDate];
    NSDate *predate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:curDate];
    _departDateTmp = [_oFormat stringFromDate:predate];
    
    _isPullRefresh = NO;
    // 发起请求
    [self trainSearchStart];
    
    UMENG_EVENT(UEvent_Train_List_BeforeDay)
}

// 当前日期,进入日历
- (void)curDayPressed:(id)sender
{
    // 日历界面
    ELCalendarViewController *calendar=[[ELCalendarViewController alloc] initWithCheckIn:[_oFormat dateFromString:_departDate] checkOut:nil type:TrainCalendar];
    calendar.delegate=self;
    
    [self.navigationController pushViewController:calendar animated:YES];
    
    UMENG_EVENT(UEvent_Train_List_Date)
}

// 下一天
- (void)nextDayPressed:(id)sender
{
    NSDate *curDate = [_oFormat dateFromString:_departDate];
    NSDate *nextdate = [NSDate dateWithTimeInterval:24*60*60 sinceDate:curDate];
    _departDateTmp = [_oFormat stringFromDate:nextdate];
    
    _isPullRefresh = NO;
    // 发起请求
    [self trainSearchStart];
    
    UMENG_EVENT(UEvent_Train_List_AfterDay)
}

// 筛选按钮
- (void)filterButtonPressed:(id)sender
{
    if (!_filterNav)
    {
        TrainSearchFilterController *trainFilterTmp = [[TrainSearchFilterController alloc] initWithFilterConditions:_filterInfo];
        trainFilterTmp.filterDelegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:trainFilterTmp];
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


// 价格排序
- (void)sortPricePressed:(id)sender
{
    _isPriceAscending = !_isPriceAscending;
    _isTimeReset = YES;
    _isPriceReset = NO;
    
    // 进行排序
    [self sortDataStart:eTSortPrce];
    
    // 刷新界面
    if (_viewBottom != nil)
    {
        [self setupViewBottomSubs:_viewBottom];
    }
}

// 时间排序
- (void)sortTimePressed:(id)sender
{
    _isTimeAscending = !_isTimeAscending;
    _isPriceReset = YES;
    _isTimeReset = NO;
    
    // 进行排序
    [self sortDataStart:eTSortTime];
    
    // 刷新界面
    if (_viewBottom != nil)
    {
        [self setupViewBottomSubs:_viewBottom];
    }
}

// 顶部按钮刷新
- (void)topRefresh:(id)sender
{
    _isPullRefresh = NO;
    
    [self trainSearchStart];
    
    UMENG_EVENT(UEvent_Train_List_Refresh)
}

// 下拉刷新
- (void)pullRefresh:(id)sender
{
    _isPullRefresh = YES;
    
    [self trainSearchStart];
    
    UMENG_EVENT(UEvent_Train_List_Refresh)
}



// 开始搜索列表
- (void)trainSearchStart
{
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
    [trainListSearchParam setStartDate:_departDateTmp];
    
    // 列车类型
    [trainListSearchParam setTrainType:@"0"];
    
    // ota厂商
    [trainListSearchParam setWrapperId:[_trainListCur wrapperId]];
    
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
        // 开始加载
        if (_isPullRefresh)
        {
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSDate *refreshTime = [defaults objectForKey:@"trainList_refreshTime"];
            [_refreshControl beginRefreshing:refreshTime];
            
        }
        
        //
        _isNetLoading = YES;
        
        if (_getListUtil == nil)
        {
            _getListUtil = [[HttpUtil alloc] init];
        }
        [_getListUtil requestWithURLString:url
                                      Content:nil
                                 StartLoading:YES
                                   EndLoading:YES
                                     Delegate:self];
    }
}


// =======================================================================
#pragma mark - 网络请求回调
// =======================================================================
- (void)httpConnectionDidFinished:(HttpUtil *)util responseData:(NSData *)responseData
{
    if (_isPullRefresh)
    {
        [_refreshControl endRefreshingWithTime:[NSDate date]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"trainList_refreshTime"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    // 更改网络加载状态
    _isNetLoading = NO;
    
    NSDictionary *root = [PublicMethods unCompressData:responseData];
//    NSLog(@"%@", root);
    
    if ([Utils checkJsonIsError:root]) {
        return;
    }
    
    if (root != nil)
    {
        // 解析结果数据
        TrainList *trainListTmp = [[TrainList alloc] init];
        [trainListTmp parseSearchResult:root];
        
        // 请求结果判断
        NSNumber *isError = [trainListTmp isError];
        if (isError !=nil && [isError boolValue] == NO)
        {
            // 进行发车时间和到达时间的筛选
            if ([trainListTmp arrayTickets] != nil && ([[trainListTmp arrayTickets] count] > 0))
            {
                [self setTrainListCur:trainListTmp];
                
                // 保存成功请求的日期
                _departDate = _departDateTmp;
                
                // 更新日期
                [self dateRefresh];
                
                // 数据筛选
                [self filteDataStart];
                
                [_tableViewList reloadData];
                
            }
        }
        else
        {
            // 显示错误信息
            NSString *errorMessage = [trainListTmp errorMessage];
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

- (void)httpConnectionDidFailed:(HttpUtil *)util withError:(NSError *)error
{
    if (_isPullRefresh)
    {
        [_refreshControl endRefreshing];
    }
    
    // 将日期回退至备份的日期
    _departDateTmp = _departDate;
}

- (void)httpConnectionDidCanceled:(HttpUtil *)util
{
    if (_isPullRefresh)
    {
        [_refreshControl endRefreshing];
    }
    
    // 将日期回退至备份的日期
    _departDateTmp = _departDate;
}

// =======================================================================
#pragma mark - 日历代理回调
// =======================================================================
- (void) ElcalendarViewSelectDay:(ELCalendarViewController *)elViewController checkinDate:(NSDate *)cinDate checkoutDate:(NSDate *)coutDate
{
    if (cinDate != nil)
    {
        // 从日历选择的日期
        _departDateTmp = [_oFormat stringFromDate:cinDate];
        
        // 发起请求
        [self trainSearchStart];
    }
}


// =======================================================================
#pragma mark - 筛选回调
// =======================================================================
- (void) searchFilterController:(SearchFilterController *)filter didFinishedWithInfo:(NSDictionary *)info
{
    if (info != nil)
    {
        // 获取列车类型
        NSArray *arrayTrainType = [info safeObjectForKey:[NSString stringWithFormat:@"%d", FilterType]];
        if (arrayTrainType != nil && ([arrayTrainType count]>0))
        {
            BOOL isSelectHighTrain = NO;
            
            for (NSInteger i=0; i<[arrayTrainType count]; i++)
            {
                NSString *stringTrainType = [arrayTrainType objectAtIndex:i];
                if (STRINGHASVALUE(stringTrainType))
                {
                    if ([stringTrainType integerValue] == 1 || [stringTrainType integerValue] == 2)
                    {
                        isSelectHighTrain = YES;
                    }
                }
            }
            
            // 构造列车查询类型的通知信息
            NSMutableDictionary *trainTypeDictionary = [[NSMutableDictionary alloc] init];
            // 列车查询类型
            NSNumber *trainType = [NSNumber numberWithBool:isSelectHighTrain];
            [trainTypeDictionary safeSetObject:trainType forKey:kTrainType];
            [[NSNotificationCenter defaultCenter]  postNotificationName:kTrainTypeChangeNotification object:trainTypeDictionary];
        }
        
        // 保存筛选类型
        _filterInfo = info;
        
        [self filteDataStart];
    }
}

//
- (void)searchFilterControllerDidCancel:(SearchFilterController *)filter
{
    
}

// =======================================================================
#pragma mark - 列车详情选择回调
// =======================================================================
- (void)detailViewDidShow
{
    _isDetailViewShow = YES;
}

- (void)detailViewDidDismiss
{
    _isDetailViewShow = NO;
}

- (void)seatSelectBack:(TrainSeats *)trainSeat andTrainTickets:(TrainTickets *)trainTickets
{
    
    BOOL islogin = [[AccountManager instanse] isLogin];
    
    TrainReq *req = [TrainReq shared];
    req.currentRoute = trainTickets;
    req.currentSeat = trainSeat;
    
    if (islogin)
    {
        // 如果用户已登陆，则进入订单填写页
        TrainFillOrderVC *controller = [[TrainFillOrderVC alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        // 否则进入登陆页面
        LoginManager *login = [[LoginManager alloc] init:_string(@"s_loginandregister") style:_NavOnlyBackBtnStyle_ state:TrainOrder];
        [self.navigationController pushViewController:login animated:YES];
    }
}


// =======================================================================
#pragma mark - 辅助函数
// =======================================================================
// 日期显示
- (void)dateRefresh
{
    // 日期格式处理
    if (STRINGHASVALUE(_departDate))
    {
         _departDateTmp = _departDate;
        
        if (_oFormat == nil)
        {
            _oFormat = [[NSDateFormatter alloc] init];
            [_oFormat setDateFormat:@"yyyy-MM-dd"];
        }
        
        NSArray *dateCompents = [_departDate componentsSeparatedByString:@"-"];
        // 获取分段格式的日期
        NSString *month	= [dateCompents safeObjectAtIndex:1];
        NSString *day = [dateCompents safeObjectAtIndex:2];
        
        _showDate = [NSString stringWithFormat:@"%@月%@日",month,day];

        // 刷新界面
        if (_viewTop != nil)
        {
            [self setupViewTopSubs:_viewTop];
        }
        
    }
}

// 开始筛选
- (void)filteDataStart
{
    // 进行有票筛选
    if (_hasTicketFilte)
    {
        [self filterWithTicket];
    }
    
    NSArray *filteredData = [self filterTrainData:[_trainListCur arrayTickets]];
    if (filteredData != nil)
    {
        // 进行条件筛选
        [self setArrayTickets:filteredData];
    }
    
    // 排序结束进行排序
    if (!_isPriceReset)
    {
        [self sortDataStart:eTSortPrce];
    }
    if (!_isTimeReset)
    {
        [self sortDataStart:eTSortTime];
    }
    
    // 设置筛选按钮的标示icon
    UIImageView *badgeIcon = (UIImageView *)[[self view] viewWithTag:kTrainListBottomFilterButtonBadgeTag];
    if (badgeIcon != nil)
    {
        if ([_arrayTickets count] < [[_trainListCur arrayTickets] count])
        {
            [badgeIcon setHidden:NO];
            
            UMENG_EVENT(UEvent_Train_List_FilterAction)
        }
        else
        {
            [badgeIcon setHidden:YES];
            UMENG_EVENT(UEvent_Train_List_FilterReset)
        }
    }
    
}

// 进行排序
- (void)sortDataStart:(TrainListSortType )sortType
{
    if (sortType == eTSortPrce)
    {
        // 价格排序
        NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"lowPrice" ascending:YES comparator:^(id obj1, id obj2) {
            
            if (_isPriceAscending)
            {
                if ([obj1 floatValue] > [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([obj1 floatValue] < [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }
            else
            {
                if ([obj1 floatValue] > [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                if ([obj1 floatValue] < [obj2 floatValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
            }
            UMENG_EVENT(UEvent_Train_List_SortPrice)
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSArray * descriptors = [NSArray arrayWithObject:sortDes];
        [self setArrayTickets:[NSArray arrayWithArray:[_arrayTickets sortedArrayUsingDescriptors:descriptors]]];
    }
    else if (sortType == eTSortTime)
    {
        // 时间排序
        NSSortDescriptor * sortDes	= [[NSSortDescriptor alloc] initWithKey:@"departInfo.time" ascending:_isTimeAscending];
        NSArray * descriptors = [NSArray arrayWithObject:sortDes];
        [self setArrayTickets:[NSArray arrayWithArray:[_arrayTickets sortedArrayUsingDescriptors:descriptors]]];
        UMENG_EVENT(UEvent_Train_List_SortTime)
        
    }
    
    [_tableViewList reloadData];
    
}

// 进行有票筛选
- (void)filterWithTicket
{
    // 列车数据
    NSArray *arrayTicketsTmp = [_trainListCur arrayTickets];
    if (arrayTicketsTmp != nil && [arrayTicketsTmp count]>0)
    {
        NSMutableArray *arrayFilteResult = [[NSMutableArray alloc] init];
        
        for (NSInteger i=0; i<[arrayTicketsTmp count]; i++)
        {
            TrainTickets *trainTickets = [arrayTicketsTmp objectAtIndex:i];
            if (trainTickets != nil)
            {
                NSNumber *ypCode = [trainTickets ypCode];
                
                if (ypCode != nil && [ypCode integerValue] != 0)
                {
                    [arrayFilteResult addObject:trainTickets];
                }
            }
        }
        
        // 保存
        [_trainListCur setArrayTickets:arrayFilteResult];
    }
}

// 进行数据筛选
- (NSArray *)filterTrainData:(NSArray *)trainTicketsTmp
{
    NSMutableArray *arrayTickets = [NSMutableArray arrayWithArray:trainTicketsTmp];
    NSMutableArray *arrayFilteResult = [[NSMutableArray alloc] init];
    
    // 根据列车类型进行筛选
    NSArray *arrayFilterTmp = nil;
    NSArray *arrayTrainTypeFilter = [NSMutableArray arrayWithArray:[_filterInfo safeObjectForKey:[NSString stringWithFormat:@"%d", FilterType]]];
    if (arrayTrainTypeFilter != nil && [arrayTrainTypeFilter count] > 0)
    {
        for (NSInteger i=0; i<[arrayTrainTypeFilter count]; i++)
        {
            NSString *filterValue = [arrayTrainTypeFilter objectAtIndex:i];
            if (STRINGHASVALUE(filterValue))
            {
                arrayFilterTmp = [self doFilterWithType:arrayTickets withFilterIndex:[filterValue integerValue]];
                
                for (NSInteger j=0; j<[arrayFilterTmp count]; j++)
                {
                    [arrayFilteResult addObject:[arrayFilterTmp safeObjectAtIndex:j]];
                }

            }
        }
    }
    
    
    // 根据发车时间进行筛选
    NSMutableArray *arrayFilteDepart = [[NSMutableArray alloc] init];
    NSArray *arrayDepartTimeFilter = [_filterInfo safeObjectForKey:[NSString stringWithFormat:@"%d", FilterDepartureTime]];
    if (arrayDepartTimeFilter != nil && [arrayDepartTimeFilter count] > 0)
    {
        for (NSInteger i=0; i<[arrayDepartTimeFilter count]; i++)
        {
            NSString *filterValue = [arrayDepartTimeFilter objectAtIndex:i];
            if (STRINGHASVALUE(filterValue))
            {
                arrayFilterTmp = [NSArray arrayWithArray:[self doFilterWithTime:arrayFilteResult withFilterType:FilterDepartureTime andFilterIndex:[filterValue integerValue]]];
                
                if (arrayFilterTmp != nil)
                {
                    for (NSInteger j=0; j<[arrayFilterTmp count]; j++)
                    {
                        [arrayFilteDepart addObject:[arrayFilterTmp safeObjectAtIndex:j]];
                    }
                }
            }
        }
        
        // 保存
        arrayFilteResult = [NSMutableArray arrayWithArray:arrayFilteDepart];
    }
    

    // 根据到达时间进行筛选
    NSMutableArray *arrayFilteArrive = [[NSMutableArray alloc] init];
    NSArray *arrayArriveTimeFilter = [_filterInfo safeObjectForKey:[NSString stringWithFormat:@"%d", FilterArrivalTime]];
    if (arrayArriveTimeFilter != nil && [arrayArriveTimeFilter count] > 0)
    {
        for (NSInteger i=0; i<[arrayArriveTimeFilter count]; i++)
        {
            NSString *filterValue = [arrayArriveTimeFilter objectAtIndex:i];
            if (STRINGHASVALUE(filterValue))
            {
                arrayFilterTmp = [self doFilterWithTime:arrayFilteResult withFilterType:FilterArrivalTime andFilterIndex:[filterValue integerValue]];
                
                if (arrayFilterTmp != nil)
                {
                    for (NSInteger j=0; j<[arrayFilterTmp count]; j++)
                    {
                        [arrayFilteArrive addObject:[arrayFilterTmp safeObjectAtIndex:j]];
                    }
                }
            }
        }
        
        // 保存
        arrayFilteResult = [NSMutableArray arrayWithArray:arrayFilteArrive];
    }
    
    
    
    return arrayFilteResult;
}

// 根据列车类型筛选
- (NSArray *)doFilterWithType:(NSMutableArray *)arrayTickets withFilterIndex:(NSInteger)filterIndex
{
    if (UMENG) {
        // 火车票排序，点击确定
        [MobClick event:Event_TrainSort_Confirm label:[NSString stringWithFormat:@"%d",filterIndex]];
    }
    
    NSArray *arrayTicketsTmp = [arrayTickets copy];
    
    // 根据时间值筛选
    NSArray *arrayTicketsFilter = [[NSMutableArray alloc] init];
    NSPredicate *predicate;
    
    if (filterIndex == 0)
    {
        arrayTicketsFilter = [NSArray arrayWithArray:arrayTickets];
        return arrayTicketsFilter;
    }
    else if (filterIndex == 1)
    {
        predicate = [NSPredicate predicateWithFormat:@"number BEGINSWITH 'D'"];
        arrayTicketsFilter = [arrayTicketsTmp filteredArrayUsingPredicate:predicate];
    }
    else if (filterIndex == 2)
    {
        predicate = [NSPredicate predicateWithFormat:@"number BEGINSWITH 'G' or number BEGINSWITH 'C'"];
        arrayTicketsFilter = [arrayTicketsTmp filteredArrayUsingPredicate:predicate];
    }
    else if (filterIndex == 3)
    {
        predicate = [NSPredicate predicateWithFormat:@"NOT (number BEGINSWITH 'D') AND NOT (number  BEGINSWITH 'G') AND NOT (number BEGINSWITH 'C')"];
        arrayTicketsFilter = [arrayTicketsTmp filteredArrayUsingPredicate:predicate];
    }
    
    return arrayTicketsFilter;
}

// 根据起始时间和终止时间筛选数据
- (NSMutableArray *)doFilterWithTime:(NSArray *)arrayTickets withFilterType:(FilterTypes)filterType andFilterIndex:(NSInteger)filterIndex
{
    if (_filterFormat == nil)
    {
        _filterFormat = [[NSDateFormatter alloc] init];
        [_filterFormat setDateFormat:@"HH:mm"];
        _filterFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0]; 
    }
    
    NSDate *startTime;
    NSDate *endTime;
    
    // 根据筛选index获取时间值
    switch (filterIndex) {
        case 0:
        {
            startTime = [_filterFormat dateFromString:@"00:00"];
            endTime = [_filterFormat dateFromString:@"06:00"];
            break;
        }
        case 1:
        {
            startTime = [_filterFormat dateFromString:@"06:00"];
            endTime = [_filterFormat dateFromString:@"12:00"];
            break;
        }
        case 2:
        {
            startTime = [_filterFormat dateFromString:@"12:00"];
            endTime = [_filterFormat dateFromString:@"18:00"];
            break;
        }
        case 3:
        {
            startTime = [_filterFormat dateFromString:@"18:00"];
            endTime = [_filterFormat dateFromString:@"23:59"];
            break;
        }
        default:
            break;
    }
    
    //
    NSDate *curDate;
    // 根据时间值筛选
    NSMutableArray *arrayTicketsFilter = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<[arrayTickets count]; i++)
    {
        TrainTickets *trainTickets = [arrayTickets objectAtIndex:i];
        if (trainTickets != nil)
        {
            NSString *time = @"";
            
            // 出发时间
            if ((filterType == FilterDepartureTime) && [trainTickets departInfo]!= nil)
            {
                time = [[trainTickets departInfo] time];
            }
            // 到达时间
            else if ((filterType == FilterArrivalTime) && [trainTickets arriveInfo]!= nil)
            {
                time = [[trainTickets arriveInfo] time];
            }
            
            if (STRINGHASVALUE(time))
            {
                curDate = [_filterFormat dateFromString:time];
                
                if (([curDate compare:startTime] == NSOrderedDescending && [curDate compare:endTime] == NSOrderedAscending) ||
                    [curDate compare:startTime] == NSOrderedSame || [curDate compare:endTime] == NSOrderedSame)
                {
                    [arrayTicketsFilter addObject:trainTickets];
                }
            }
        }
    }
    
    return arrayTicketsFilter;
}

// 获取格式化的列车历时
- (NSString *)getFormatDuration:(NSNumber *)duration
{
    NSInteger durationValue = [duration integerValue];
    
    NSInteger hour = durationValue/60;
    NSInteger minute = durationValue%60;
    
    NSString *durationText = [NSString stringWithFormat:@"历时%d时%d分",hour,minute];
    if (hour < 1)
    {
        durationText = [NSString stringWithFormat:@"历时%d分",minute];
    }
    
    return durationText;
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
    spaceYEnd -= kTrainListNavBarHeight+kTrainListScreenToolBarHeight;
    [self addTopImageAndTitle:nil andTitle:@"火车列表"];
    [self setShowBackBtn:YES];
    // 刷新按钮
    UIButton *buttonRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRefresh setFrame:CGRectMake(0, 3, NAVBAR_ITEM_WIDTH, NAVBAR_ITEM_HEIGHT)];
    [buttonRefresh setBackgroundImage:[UIImage imageNamed:@"btn_refreshNormal.png"] forState:UIControlStateNormal];
    [buttonRefresh addTarget:self action:@selector(topRefresh:) forControlEvents:UIControlEventTouchUpInside];
    // 保存
    UIBarButtonItem *rightbtnitem = [[UIBarButtonItem alloc] initWithCustomView:buttonRefresh];
    self.navigationItem.rightBarButtonItem = rightbtnitem;
    
    // =======================================================================
    // 顶部视图
    // =======================================================================
    UIView *viewTopTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, kTrainListTopViewHeight)];
    [viewTopTmp setBackgroundColor:[UIColor clearColor]];
    [self setupViewTopSubs:viewTopTmp];
    [viewParent addSubview:viewTopTmp];
    _viewTop = viewTopTmp;
    
    // 子窗口大小
    spaceYStart += kTrainListTopViewHeight;
    
    
    // =======================================================================
    // 底部视图
    // =======================================================================
    UIView *viewBottomTmp = [[UIView alloc] initWithFrame:CGRectMake(0, spaceYEnd - kTrainListBottomViewHeight, parentFrame.size.width, kTrainListBottomViewHeight)];
    [viewBottomTmp setBackgroundColor:[UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]];
    [self setupViewBottomSubs:viewBottomTmp];
    [viewParent addSubview:viewBottomTmp];
    _viewBottom = viewBottomTmp;
    
    // 子窗口大小
    spaceYEnd -= kTrainListBottomViewHeight;
    
    
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
    
    // =======================================================================
	// TableView RefreshControl
	// =======================================================================
	_refreshControl = [[RefreshControl alloc] initInScrollView:_tableViewList];
    [_refreshControl setRefreshTime:[NSDate date]];
	[_refreshControl addTarget:self action:@selector(pullRefresh:) forControlEvents:UIControlEventValueChanged];
}

// 创建TopView的子界面
- (void)setupViewTopSubs:(UIView *)viewParent
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
    
    // =====================================================
    // 分隔线
    // =====================================================
    UIImageView *topShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
    [topShadow setFrame:CGRectMake(0, parentFrame.size.height-kTrainListTopViewShadowHeight, parentFrame.size.width, kTrainListTopViewShadowHeight)];
    [topShadow setBackgroundColor:[UIColor clearColor]];
    [topShadow setAlpha:0.7];
    [topShadow setTag:kTrainListTopViewShadowTag];
    
    [viewParent addSubview:topShadow];
    
    // =====================================================
    // 日期选择按钮
    // =====================================================
    CGSize viewButtonAreaSize = CGSizeMake(0, kTrainListTopViewHeight-kTrainListTopViewShadowHeight);
    UIView *viewButtonArea = [[UIView alloc] initWithFrame:CGRectMake(0, (parentFrame.size.height-kTrainListTopViewShadowHeight-viewButtonAreaSize.height)/2, viewButtonAreaSize.width, viewButtonAreaSize.height)];
    // 创建子界面
    [self setupTopViewButtonAreaSubs:viewButtonArea inSize:&viewButtonAreaSize];
    
    // 调整界面位置
    [viewButtonArea setViewX:(parentFrame.size.width-viewButtonAreaSize.width)/2];
    
    // 保存
    [viewParent addSubview:viewButtonArea];
}

// 创建日期按钮区域子界面
- (void)setupTopViewButtonAreaSubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    
    
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    
    
    // =====================================================
    // 上一天
    // =====================================================
    // 事件按钮
    CGSize preDaySize = CGSizeMake(kTrainListPreDayButtonWidth, parentFrame.size.height);
    
    UIButton *buttonPreday = (UIButton *)[viewParent viewWithTag:kTrainListTopPredayButtonTag];
    if (buttonPreday == nil)
    {
        buttonPreday = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buttonPreday setBackgroundImage:[UIImage imageNamed:@"btn_tabitemleft_nomal.png"] forState:UIControlStateNormal];
        [buttonPreday setBackgroundImage:[UIImage imageNamed:@"btn_tabitemleft_press.png"] forState:UIControlStateHighlighted];
        [buttonPreday setBackgroundImage:[UIImage imageNamed:@"btn_tabitemleft_press.png"] forState:UIControlStateDisabled];
        [buttonPreday addTarget:self action:@selector(preDayPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonPreday setTag:kTrainListTopPredayButtonTag];
        // 保存
        [viewParent addSubview:buttonPreday];
    }
    [buttonPreday setFrame:CGRectMake(spaceXStart, 0, preDaySize.width, preDaySize.height)];
    
    // 设置显示状态
    NSString *today = [_oFormat stringFromDate:[NSDate dateWithTimeInterval:0 sinceDate:[NSDate date]]];
    if ([_departDate isEqualToString:today])
    {
        [buttonPreday setEnabled:NO];
    }
    else
    {
        [buttonPreday setEnabled:YES];
    }
    
    // 创建子界面
    [self setupPredayButtonSubs:buttonPreday];
    // 子窗口大小
    spaceXStart += preDaySize.width;
    
    
    // =====================================================
    // 当前日期
    // =====================================================
    CGSize curDaySize = CGSizeMake(kTrainListCurdayButtonWidth, parentFrame.size.height);
    
    UIButton *buttonCurday = (UIButton *)[viewParent viewWithTag:kTrainListTopCurdayButtonTag];
    if (buttonCurday == nil)
    {
        buttonCurday = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buttonCurday setBackgroundImage:[UIImage imageNamed:@"btn_tabitemmiddle_nomal.png"] forState:UIControlStateNormal];
        [buttonCurday setBackgroundImage:[UIImage imageNamed:@"btn_tabitemmiddle_press.png"] forState:UIControlStateHighlighted];
        [buttonCurday addTarget:self action:@selector(curDayPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonCurday setTag:kTrainListTopCurdayButtonTag];
        // 保存
        [viewParent addSubview:buttonCurday];
    }
    [buttonCurday setFrame:CGRectMake(spaceXStart, 0, curDaySize.width, curDaySize.height)];
    
    // 创建子界面
    [self setupCurdayButtonSubs:buttonCurday];
    // 子窗口大小
    spaceXStart += curDaySize.width;
    
    
    // =====================================================
    // 下一天
    // =====================================================
    CGSize nextDaySize = CGSizeMake(kTrainListPreDayButtonWidth, parentFrame.size.height);
    
    UIButton *buttonNextday = (UIButton *)[viewParent viewWithTag:kTrainListTopNextdayButtonTag];
    if (buttonNextday == nil)
    {
        buttonNextday = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [buttonNextday setBackgroundImage:[UIImage imageNamed:@"btn_tabitemleft_nomal.png"] forState:UIControlStateNormal];
        [buttonNextday setBackgroundImage:[UIImage imageNamed:@"btn_tabitemleft_press.png"] forState:UIControlStateHighlighted];
        [buttonNextday addTarget:self action:@selector(nextDayPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonNextday setTag:kTrainListTopPredayButtonTag];
        // 保存
        [viewParent addSubview:buttonNextday];
    }
    [buttonNextday setFrame:CGRectMake(spaceXStart, 0, nextDaySize.width, nextDaySize.height)];
    
    // 创建子界面
    [self setupNextdayButtonSubs:buttonNextday];
    // 子窗口大小
    spaceXStart += nextDaySize.width;
    
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
    pViewSize->width = spaceXStart;
	if(viewParent != nil)
	{
        [viewParent setViewWidth:spaceXStart];
	}
}

// 创建上一天按钮的子界面
- (void)setupPredayButtonSubs:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // =====================================================
    // 箭头
    // =====================================================
    CGSize arrowSize = CGSizeMake(kTrainListCellArrowIconWidth, kTrainListCellArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kTrainListTopLeftArrowIconTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (viewParent.enabled)
        {
            [arrowIcon setImage:[UIImage imageNamed:@"ico_leftarrownomal.png"]];
        }
        else
        {
            [arrowIcon setImage:[UIImage imageNamed:@"ico_leftarrowdiable.png"]];
        }
        
        [arrowIcon setTag:kTrainListTopLeftArrowIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(kTrainListTopViewButtonHMargin, (parentFrame.size.height-arrowSize.height)/2, arrowSize.width, arrowSize.height)];
    
    
    
    // =====================================================
    // 上一天Label
    // =====================================================
    NSString *preDayHint = @"前一天";
    CGSize hintSize = [preDayHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:12.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kTrainListTopPredayHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:12.0f]];
        if (viewParent.enabled)
        {
            [labelHint setTextColor:[UIColor colorWithRed:35/255.0 green:119/255.0 blue:232/255.0 alpha:1.0]];
        }
        else
        {
            [labelHint setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
        }
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setTag:kTrainListTopPredayHintLabelTag];
        // 保存
        [viewParent addSubview:labelHint];
    }
    
    [labelHint setFrame:CGRectMake((parentFrame.size.width-hintSize.width)/2, (parentFrame.size.height-hintSize.height)/2, hintSize.width, hintSize.height)];
    [labelHint setText:preDayHint];
}


// 创建当前日期按钮的子界面
- (void)setupCurdayButtonSubs:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    
    // 隐藏的原始日期Label
    UILabel *labelDateInit = (UILabel *)[viewParent viewWithTag:kTrainListDateInitLabelTag];
    if (labelDateInit == nil)
    {
        labelDateInit = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDateInit setBackgroundColor:[UIColor clearColor]];
        [labelDateInit setFont:[UIFont systemFontOfSize:12.0f]];
        [labelDateInit setTextColor:[UIColor whiteColor]];
        [labelDateInit setHidden:YES];
        [labelDateInit setTag:kTrainListDateInitLabelTag];
        //        [labelDateInit addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
        
        // 保存
        [viewParent addSubview:labelDateInit];
    }
    [labelDateInit setFrame:CGRectMake(0, spaceYStart, parentFrame.size.width, parentFrame.size.height)];
    [labelDateInit setText:_departDate];
    
    
    // =====================================================
    // 日期
    // =====================================================
    CGSize dateSize = [_departDate sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
    
    UILabel *labelDate = (UILabel *)[viewParent viewWithTag:kTrainListTopCurdayDateLabelTag];
    if (labelDate == nil)
    {
        labelDate = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelDate setBackgroundColor:[UIColor clearColor]];
        [labelDate setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [labelDate setTextColor:RGBACOLOR(35, 119, 232, 1)];
        [labelDate setTextAlignment:UITextAlignmentCenter];
        [labelDate setTag:kTrainListTopCurdayDateLabelTag];
        // 保存
        [viewParent addSubview:labelDate];
    }
    
    [labelDate setFrame:CGRectMake((parentFrame.size.width-dateSize.width)/2, (parentFrame.size.height-dateSize.height)/2, dateSize.width, dateSize.height)];
    [labelDate setText:_departDate];
    
    
}


// 创建下一天按钮的子界面
- (void)setupNextdayButtonSubs:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // =====================================================
    // 箭头
    // =====================================================
    CGSize arrowSize = CGSizeMake(kTrainListCellArrowIconWidth, kTrainListCellArrowIconHeight);
    
    UIImageView *arrowIcon = (UIImageView *)[viewParent viewWithTag:kTrainListTopRightArrowIconTag];
    if (arrowIcon == nil)
    {
        arrowIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (viewParent.enabled)
        {
            [arrowIcon setImage:[UIImage imageNamed:@"ico_rightarrownomal.png"]];
        }
        else
        {
            [arrowIcon setImage:[UIImage imageNamed:@"ico_rightarrowdiable.png"]];
        }
        
        [arrowIcon setTag:kTrainListTopRightArrowIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:arrowIcon];
        
    }
    [arrowIcon setFrame:CGRectMake(parentFrame.size.width-kTrainListTopViewButtonHMargin-kTrainListTopViewButtonMiddleHMargin*2, (parentFrame.size.height-arrowSize.height)/2, arrowSize.width, arrowSize.height)];
    
    // =====================================================
    // 下一天Label
    // =====================================================
    NSString *nextDayHint = @"后一天";
    CGSize hintSize = [nextDayHint sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:12.0f]];
    
    UILabel *labelHint = (UILabel *)[viewParent viewWithTag:kTrainListTopNextdayHintLabelTag];
    if (labelHint == nil)
    {
        labelHint = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelHint setBackgroundColor:[UIColor clearColor]];
        [labelHint setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:12.0f]];
        [labelHint setTextColor:RGBACOLOR(35, 119, 232, 1)];
        [labelHint setTextAlignment:UITextAlignmentCenter];
        [labelHint setTag:kTrainListTopNextdayHintLabelTag];
        // 保存
        [viewParent addSubview:labelHint];
    }
    
    [labelHint setFrame:CGRectMake((parentFrame.size.width-hintSize.width)/2, (parentFrame.size.height-hintSize.height)/2, hintSize.width, hintSize.height)];
    [labelHint setText:nextDayHint];
    
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
    CGSize sortBtnSize = CGSizeMake(parentFrame.size.width/3, parentFrame.size.height);
    
    UIButton *buttonSortTime = (UIButton *)[viewParent viewWithTag:kTrainListSortTimeButtonTag];
    if (buttonSortTime == nil)
    {
        buttonSortTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonSortTime addTarget:self action:@selector(sortTimePressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonSortTime setTag:kTrainListSortTimeButtonTag];
        // 保存
        [viewParent addSubview:buttonSortTime];
    }
    [buttonSortTime setFrame:CGRectMake(spaceXStart, 0, sortBtnSize.width, sortBtnSize.height)];
    
    // 子窗口大小
    spaceXStart += sortBtnSize.width;
    
    // 创建子界面
    [self setupSortTimeButton:buttonSortTime];
    
    // =====================================================
    // 价格排序按钮
    // =====================================================
    // 事件按钮
    CGSize priceBtnSize = CGSizeMake(parentFrame.size.width/3, parentFrame.size.height);
    
    UIButton *buttonSortPrice = (UIButton *)[viewParent viewWithTag:kTrainListSortPriceButtonTag];
    if (buttonSortPrice == nil)
    {
        buttonSortPrice = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonSortPrice addTarget:self action:@selector(sortPricePressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonSortPrice setTag:kTrainListSortPriceButtonTag];
        // 保存
        [viewParent addSubview:buttonSortPrice];
    }
    [buttonSortPrice setFrame:CGRectMake(spaceXStart, 0, priceBtnSize.width, priceBtnSize.height)];
    
    // 子窗口大小
    spaceXStart += priceBtnSize.width;
    
    // 创建子界面
    [self setupSortPriceButton:buttonSortPrice];
    
    
    // =====================================================
    // 筛选按钮
    // =====================================================
    CGSize filterBtnSize = CGSizeMake(parentFrame.size.width/3, parentFrame.size.height);
    
    UIButton *buttonFilter  = (UIButton *)[viewParent viewWithTag:kTrainListBottomFilterButtonTag];
    if (buttonFilter == nil)
    {
        buttonFilter = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonFilter addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonFilter setTag:kTrainListBottomFilterButtonTag];
        // 保存
        [viewParent addSubview:buttonFilter];
    }
    [buttonFilter setFrame:CGRectMake(spaceXStart, 0, filterBtnSize.width, filterBtnSize.height)];
    
    // 创建子界面
    [self setupFilterButton:buttonFilter];
    
    
    
    
}

// 创建价格排序按钮
- (void)setupSortPriceButton:(UIButton *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
    
    // 子窗口高宽
    NSInteger spaceYStart = 0;
    
    // 排序提示文案
    NSString *sortText = @"价格";
    CGSize sortTextSize = [sortText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
    
    // =====================================================
    // 排序图标
    // =====================================================
    CGSize iconSize = CGSizeMake(kTrainListSortPriceIconWidth, kTrainListSortPriceIconHeight);
    
    // 计算间隔
    NSInteger spaceYmargin = (parentFrame.size.height-sortTextSize.height-iconSize.height)/2;
    spaceYStart += spaceYmargin;
    
    UIImageView *sortIcon = (UIImageView *)[viewParent viewWithTag:kTrainListSortPriceIconTag];
    if (sortIcon == nil)
    {
        sortIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (_isPriceReset)
        {
            [sortIcon setImage:[UIImage imageNamed:@"ico_priceorder_normal.png"]];
        }
        else
        {
            [sortIcon setImage:_isPriceAscending ? [UIImage imageNamed:@"ico_priceorder_descending.png"] : [UIImage imageNamed:@"ico_priceorder_ascending.png"]];
        }
        
        [sortIcon setTag:kTrainListSortPriceIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:sortIcon];
        
    }
    [sortIcon setFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    // 子窗口大小
    spaceYStart += iconSize.height;
    // 间隔
    spaceYStart += kTrainListBottomMiddleYMargin;
    
    // =====================================================
    // 排序提示文字
    // =====================================================
    UILabel *labelText = (UILabel *)[viewParent viewWithTag:kTrainListSortPriceLabelTag];
    if (labelText == nil)
    {
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        [labelText setTextColor:[UIColor whiteColor]];
//        if (_isPriceReset)
//        {
//            [labelText setTextColor:[UIColor whiteColor]];
//        }
//        else
//        {
//            [labelText setTextColor:RGBACOLOR(254, 75, 32, 1)];
//        }
        
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setTag:kTrainListSortPriceLabelTag];
        // 保存
        [viewParent addSubview:labelText];
    }
    [labelText setFrame:CGRectMake(parentFrame.size.width * 0.36, spaceYStart, sortTextSize.width, sortTextSize.height)];
    [labelText setText:sortText];
    
    
    
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
    CGSize iconSize = CGSizeMake(kTrainListSortTimeIconWidth, kTrainListSortTimeIconHeight);
    
    // 计算间隔
    NSInteger spaceYmargin = (parentFrame.size.height-sortTextSize.height-iconSize.height)/2;
    spaceYStart += spaceYmargin;
    
    UIImageView *sortIcon = (UIImageView *)[viewParent viewWithTag:kTrainListSortTimeIconTag];
    if (sortIcon == nil)
    {
        sortIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        if (_isTimeReset)
        {
            [sortIcon setImage:[UIImage imageNamed:@"ico_timeorder_normal.png"]];
        }
        else
        {
            [sortIcon setImage:_isTimeAscending ? [UIImage imageNamed:@"ico_timeorder_descending.png"] : [UIImage imageNamed:@"ico_timeorder_ascending.png"]];
        }
        
        [sortIcon setTag:kTrainListSortTimeIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:sortIcon];
        
    }
    [sortIcon setFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    // 子窗口大小
    spaceYStart += iconSize.height;
    // 间隔
    spaceYStart += kTrainListBottomMiddleYMargin;
    
    // =====================================================
    // 排序提示文字
    // =====================================================
    UILabel *labelText = (UILabel *)[viewParent viewWithTag:kTrainListSortTimeLabelTag];
    if (labelText == nil)
    {
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        [labelText setTextColor:[UIColor whiteColor]];
//        if (_isTimeReset)
//        {
//            [labelText setTextColor:[UIColor whiteColor]];
//        }
//        else
//        {
//            [labelText setTextColor:RGBACOLOR(254, 75, 32, 1)];
//        }
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setTag:kTrainListSortTimeLabelTag];
        // 保存
        [viewParent addSubview:labelText];
    }
    [labelText setFrame:CGRectMake(parentFrame.size.width * 0.36, spaceYStart, sortTextSize.width, sortTextSize.height)];
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
    CGSize iconSize = CGSizeMake(kTrainListFilterIconWidth, kTrainListFilterIconHeight);
    
    // 计算间隔
    NSInteger spaceYmargin = (parentFrame.size.height-filterTextSize.height-iconSize.height)/2;
    spaceYStart += spaceYmargin;
    
    UIImageView *filterIcon = (UIImageView *)[viewParent viewWithTag:kTrainListFilterIconTag];
    if (filterIcon == nil)
    {
        filterIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [filterIcon setImage:[UIImage imageNamed:@"ico_filterbuttonicon.png"]];
        [filterIcon setTag:kTrainListFilterIconTag];
        
        // 添加到父窗口
        [viewParent addSubview:filterIcon];
        
    }
    [filterIcon setFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2, spaceYStart, iconSize.width, iconSize.height)];
    
    // =====================================================
    // 筛选标志Icon
    // =====================================================
    CGSize filterBadgeSize = CGSizeMake(kTrainListFilterButtonBadgeWidth, kTrainListFilterButtonBadgeHeight);
    UIImageView *badgeIcon = (UIImageView *)[viewParent viewWithTag:kTrainListBottomFilterButtonBadgeTag];
    if (badgeIcon == nil)
    {
        badgeIcon = [[UIImageView alloc] initWithFrame:CGRectMake((parentFrame.size.width-iconSize.width)/2+iconSize.width*1.3, spaceYStart, filterBadgeSize.width, filterBadgeSize.height)];
        [badgeIcon setImage:[UIImage imageNamed:@"filterButtonBadge.png"]];
        [badgeIcon setTag:kTrainListBottomFilterButtonBadgeTag];
        if ([_arrayTickets count] < [[_trainListCur arrayTickets] count])
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
    spaceYStart += kTrainListBottomMiddleYMargin;

    
    // =====================================================
    // 筛选提示文字
    // =====================================================
    UILabel *labelText = (UILabel *)[viewParent viewWithTag:kTrainListFilterLabelTag];
    if (labelText == nil)
    {
        labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        [labelText setBackgroundColor:[UIColor clearColor]];
        [labelText setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:12]];
        [labelText setTextColor:[UIColor whiteColor]];
        [labelText setTextAlignment:UITextAlignmentCenter];
        [labelText setTag:kTrainListFilterLabelTag];
        // 保存
        [viewParent addSubview:labelText];
    }
    [labelText setFrame:CGRectMake((parentFrame.size.width-filterTextSize.width)/2, spaceYStart, filterTextSize.width, filterTextSize.height)];
    [labelText setText:filterText];
}

// 创建详细信息cell分隔线子界面
- (void)setupCellSeparateLineSubs:(UIView *)viewParent
{
    // 父窗口尺寸
	CGRect parentFrame = [viewParent frame];
	
    [viewParent setBackgroundColor:[UIColor clearColor]];
	// 背景ImageView
	UIImageView *imageViewBG = [[UIImageView alloc] initWithFrame:CGRectZero];
	[imageViewBG setFrame:CGRectMake(0, parentFrame.size.height - kTrainListCellSeparateLineHeight, parentFrame.size.width, kTrainListCellSeparateLineHeight)];
    [imageViewBG setAlpha:0.7];
	[imageViewBG setImage:[UIImage imageNamed:@"dashed.png"]];
	
	// 添加到父窗口
	[viewParent addSubview:imageViewBG];
}

// 初始化列车信息View的子界面
- (void)initCellTrainInfoSubs:(UIView*)viewParent
{
    /* R1 View */
	UIView *viewR1 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewR1 setTag:kTrainListCellTrainInfoR1ViewTag];
	
	// 子界面
	[self initCellTrainInfoR1Subs:viewR1];
	
	// 保存
	[viewParent addSubview:viewR1];
    
    
    /* R2 View */
	UIView *viewR2 = [[UIView alloc] initWithFrame:CGRectZero];
	[viewR2 setTag:kTrainListCellTrainInfoR2ViewTag];
	
	// 子界面
	[self initCellTrainInfoR2Subs:viewR2];
	
	// 保存
	[viewParent addSubview:viewR2];
    
    // arrow Icon
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_rightarrow.png"]];
    [arrowImageView setBackgroundColor:[UIColor clearColor]];
    [arrowImageView setTag:kTrainListCellRightArrowTag];
    
    [viewParent addSubview:arrowImageView];
    
    
    // bottomLine
    UIImageView *imageViewBottomLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed.png"]];
    [imageViewBottomLine setBackgroundColor:[UIColor clearColor]];
    [imageViewBottomLine setTag:kTrainListCellTrainInfoBottomLineTag];
    
    [viewParent addSubview:imageViewBottomLine];
    
}

// 设置列车信息View的子界面
- (void)setupCellTrainInfoSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize forTrain:(TrainTickets *)trainTickets
{
    // 子窗口高度
	NSInteger spaceXStart=0;
	NSInteger spaceXEnd = pViewSize->width;
	NSInteger spaceYStart = 0;
    
	/* 间隔 */
	spaceXStart += kTrainListCellHMargin;
    spaceYStart += kTrainListCellEdgeVMargin;
    spaceXEnd -= kTrainListTableViewHMargin;
    
    // =====================================================
    // 箭头
    // =====================================================
    // arrow Icon
    CGSize iconSize = CGSizeMake(kTrainListCellArrowIconWidth, kTrainListCellArrowIconHeight);
    if (viewParent != nil)
    {
        UIImageView *arrowImageView =(UIImageView *) [viewParent viewWithTag:kTrainListCellRightArrowTag];
        [arrowImageView setFrame:CGRectMake(spaceXEnd-iconSize.width, 0, iconSize.width, iconSize.height)];
    }
    
    // 子窗口大小
    spaceXEnd -= iconSize.width;
    
    // 间隔
    spaceXEnd -= kTrainListTableViewHMargin;
    
    
    // =======================================================================
	// R1 View
	// =======================================================================
    CGSize viewR1Size = CGSizeMake(spaceXEnd-spaceXStart-kTrainListCellR1ViewMiddleHMargin, 0);
	if(viewParent != nil)
	{
		UIView *viewR1 = [viewParent viewWithTag:kTrainListCellTrainInfoR1ViewTag];
		[viewR1 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR1Size.width, viewR1Size.height)];
		
		// 创建子界面
		[self setupCellTrainInfoR1Subs:viewR1 inSize:&viewR1Size forTrain:trainTickets];
	}
	else
	{
		[self setupCellTrainInfoR1Subs:nil inSize:&viewR1Size forTrain:trainTickets];
	}
    
    // 子窗口大小
	spaceYStart += viewR1Size.height;
    
    // 间隔
    spaceYStart += kTrainListCellMiddleVMargin;
    
    // =======================================================================
	// R2 View
	// =======================================================================
    CGSize viewR2Size = CGSizeMake(spaceXEnd-spaceXStart, 0);
	if(viewParent != nil)
	{
		UIView *viewR2 = [viewParent viewWithTag:kTrainListCellTrainInfoR2ViewTag];
		[viewR2 setFrame:CGRectMake(spaceXStart, spaceYStart, viewR2Size.width, viewR2Size.height)];
		
		// 创建子界面
		[self setupCellTrainInfoR2Subs:viewR2 inSize:&viewR2Size forTrain:trainTickets];
	}
	else
	{
		[self setupCellTrainInfoR2Subs:nil inSize:&viewR2Size forTrain:trainTickets];
	}
    
    // 子窗口大小
	spaceYStart += viewR2Size.height;
    
    
    // 间隔
    spaceYStart += kTrainListCellEdgeVMargin;
    
    // =====================================================
    // 分隔线
    // =====================================================
    // bottomLine
    CGSize bottomLineSize = CGSizeMake(pViewSize->width, kTrainListCellSeparateLineHeight);
    if (viewParent != nil)
    {
        UIImageView *imageViewBottomLine =(UIImageView *) [viewParent viewWithTag:kTrainListCellTrainInfoBottomLineTag];
        [imageViewBottomLine setFrame:CGRectMake(0, spaceYStart, bottomLineSize.width,bottomLineSize.height)];
        [imageViewBottomLine setAlpha:0.7];
    }
    
    // 子窗口大小
	spaceYStart += bottomLineSize.height;
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
    
    // 调整子界面位置
    if (viewParent != nil)
    {
        UIImageView *arrowImageView =(UIImageView *) [viewParent viewWithTag:kTrainListCellRightArrowTag];
        [arrowImageView setViewY:(spaceYStart-[arrowImageView frame].size.height)/2];
    }
}

// 初始化列车信息R1View的子界面
- (void)initCellTrainInfoR1Subs:(UIView*)viewParent
{
    // 出发时间
    UILabel *labelDepartTime = [[UILabel alloc] init];
    [labelDepartTime setBackgroundColor:[UIColor clearColor]];
	[labelDepartTime setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [labelDepartTime setTextColor:[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0]];
    [labelDepartTime setTag:kTrainListCellDepartTimeLabelTag];
    [labelDepartTime setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelDepartTime];
    
    // 列车车次号
	UILabel *labelTrainNumber = [[UILabel alloc] init];
    [labelTrainNumber setBackgroundColor:[UIColor clearColor]];
	[labelTrainNumber setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [labelTrainNumber setTextColor:[UIColor colorWithHex:0x343434 alpha:1.0]];
    [labelTrainNumber setTag:kTrainListCellTrainNumberLabelTag];
    [labelTrainNumber setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelTrainNumber];
    
    // 起
    UILabel *labelPriceHint = [[UILabel alloc] init];
    [labelPriceHint setBackgroundColor:[UIColor clearColor]];
	[labelPriceHint setFont:[UIFont systemFontOfSize:12.0f]];
    [labelPriceHint setTextColor:[UIColor colorWithHex:0x767676 alpha:1.0]];
    [labelPriceHint setTag:kTrainListCellPriceHintLabelTag];
    [labelPriceHint setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelPriceHint];
    
    // 价格
    UILabel *labelPrice = [[UILabel alloc] init];
    [labelPrice setBackgroundColor:[UIColor clearColor]];
	[labelPrice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [labelPrice setTextColor:[UIColor colorWithHex:0xff8000 alpha:1.0]];
    [labelPrice setTag:kTrainListCellPriceLabelTag];
    [labelPrice setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelPrice];
    
    // 价格符号
    UILabel *labelCurrencySign = [[UILabel alloc] init];
    [labelCurrencySign setBackgroundColor:[UIColor clearColor]];
	[labelCurrencySign setFont:[UIFont systemFontOfSize:12.0f]];
    [labelCurrencySign setTextColor:[UIColor colorWithHex:0x767676 alpha:1.0]];
    [labelCurrencySign setTag:kTrainListCellCurrencySignLabelTag];
    [labelCurrencySign setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelCurrencySign];
    
}

// 创建列车信息R1View的子界面
- (void)setupCellTrainInfoR1Subs:(UIView*)viewParent inSize:(CGSize *)pViewSize forTrain:(TrainTickets *)trainTickets
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger subsHeight = 0;
    
    
    // =====================================================
    // 出发时间
    // =====================================================
    TrainDepartStation *departStation = [trainTickets departInfo];
    if (departStation != nil)
    {
        // =====================================================
        // 出发时间
        // =====================================================
        NSString *departTime = [departStation time];
        if (STRINGHASVALUE(departTime))
        {
            CGSize timeSize = [departTime sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
            
            // 创建Label
            if(viewParent != nil)
            {
                UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainListCellDepartTimeLabelTag];
                [labelTime setFrame:CGRectMake(spaceXStart, 0,
                                               timeSize.width, timeSize.height)];
                [labelTime setText:departTime];
                [labelTime setHidden:NO];
            }
            
            // 子窗口大小
            //spaceXStart += timeSize.width;
            if (timeSize.height > subsHeight)
            {
                subsHeight = timeSize.height;
            }
        }
        else
        {
            if(viewParent != nil)
            {
                UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainListCellDepartTimeLabelTag];
                [labelTime setHidden:YES];
            }
        }
    }
    
    
    //
    spaceXStart = (pViewSize->width/11)*3;
    
    // =====================================================
    // 车次号
    // =====================================================
    NSString *trainNumber = [trainTickets number];
    
    if (STRINGHASVALUE(trainNumber))
    {
        CGSize trainNumberSize = [trainNumber sizeWithFont:[UIFont boldSystemFontOfSize:18.0f]];
        
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelTrainNumber = (UILabel *)[viewParent viewWithTag:kTrainListCellTrainNumberLabelTag];
			[labelTrainNumber setFrame:CGRectMake(spaceXStart, 0,
                                                 trainNumberSize.width, trainNumberSize.height)];
			[labelTrainNumber setText:trainNumber];
			[labelTrainNumber setHidden:NO];
        }
        
        // 调整子窗口的高宽
        //spaceXStart += trainNumberSize.width;
		subsHeight = trainNumberSize.height;
    }
    else
    {
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelTrainNumber = (UILabel *)[viewParent viewWithTag:kTrainListCellTrainNumberLabelTag];
			[labelTrainNumber setHidden:YES];
        }
    }
    
    // =====================================================
    // 价格hint
    // =====================================================
    NSString *priceHint = @"起";
    CGSize priceHintSize = [priceHint sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelPriceHint = (UILabel *)[viewParent viewWithTag:kTrainListCellPriceHintLabelTag];
        [labelPriceHint setFrame:CGRectMake(spaceXEnd-priceHintSize.width, 0,
                                              priceHintSize.width, priceHintSize.height)];
        [labelPriceHint setText:priceHint];
    }
    
    // 子窗口大小
    spaceXEnd -= priceHintSize.width;
    
    // 间隔
    spaceXEnd -= kTrainListCellMiddleHMargin;
    
    // =====================================================
    // 价格
    // =====================================================
    NSString *ticketPrice = [trainTickets lowPrice];
    
    if (STRINGHASVALUE(ticketPrice))
    {
//        NSString *priceText = [NSString stringWithFormat:@"%.f",[ticketPrice floatValue]];
        
        CGSize priceSize = [ticketPrice sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelPrice = (UILabel *)[viewParent viewWithTag:kTrainListCellPriceLabelTag];
			[labelPrice setFrame:CGRectMake(spaceXEnd-priceSize.width, 0,
                                                  priceSize.width, priceSize.height)];
			[labelPrice setText:ticketPrice];
			[labelPrice setHidden:NO];
            
            //根据余票状态更改颜色
            NSNumber *ypCode = [trainTickets ypCode];
            if (ypCode != nil && [ypCode integerValue] == 0) // 无票
            {
                [labelPrice setTextColor:[UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:1.0]];
            }
            else
            {
                [labelPrice setTextColor:[UIColor colorWithRed:254/255.0 green:75/255.0 blue:32/255.0 alpha:1.0]];
            }
        }
        
        // 调整子窗口的高宽
        spaceXEnd -= priceSize.width;
        if (priceSize.height > subsHeight)
        {
            subsHeight = priceSize.height;
        }
        
        // 间隔
        spaceXEnd -= kTrainListCellMiddleHMargin;
        
    }
    else
    {
        // 创建Label
		if(viewParent != nil)
		{
            UILabel *labelPrice = (UILabel *)[viewParent viewWithTag:kTrainListCellPriceLabelTag];
			[labelPrice setHidden:YES];
        }
    }
    
    // =====================================================
    // 价格符号
    // =====================================================
    NSString *currencySign = @"¥";
    CGSize signSize = [currencySign sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    
    // 创建Label
    if(viewParent != nil)
    {
        UILabel *labelCurrencySign = (UILabel *)[viewParent viewWithTag:kTrainListCellCurrencySignLabelTag];
        [labelCurrencySign setFrame:CGRectMake(spaceXEnd-signSize.width, 0,
                                            signSize.width, signSize.height)];
        [labelCurrencySign setText:currencySign];
    }
    
    // 子窗口大小
    //spaceXEnd -= priceHintSize.width;
    
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
        // 出发时间
        UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainListCellDepartTimeLabelTag];
        [labelTime setViewY:(subsHeight - [labelTime frame].size.height)];
        
        // 车次号
        UILabel *labelTrainNumber = (UILabel *)[viewParent viewWithTag:kTrainListCellTrainNumberLabelTag];
        [labelTrainNumber setViewY:(subsHeight - [labelTrainNumber frame].size.height)];
        
        // 价格hint
        UILabel *labelPriceHint = (UILabel *)[viewParent viewWithTag:kTrainListCellPriceHintLabelTag];
        [labelPriceHint setViewY:(subsHeight - [labelPriceHint frame].size.height-kTrainListCellR1ViewMiddleVMargin)];
        
        // 价格
        UILabel *labelPrice = (UILabel *)[viewParent viewWithTag:kTrainListCellPriceLabelTag];
        [labelPrice setViewY:(subsHeight - [labelPrice frame].size.height )];
        
        // 价格符号
        UILabel *labelCurrencySign = (UILabel *)[viewParent viewWithTag:kTrainListCellCurrencySignLabelTag];
        [labelCurrencySign setViewY:(subsHeight - [labelCurrencySign frame].size.height-kTrainListCellR1ViewMiddleVMargin)];
        
    }
    
}


// 初始化列车信息R2View的子界面
- (void)initCellTrainInfoR2Subs:(UIView*)viewParent
{
    /* Depart View */
	UIView *viewDepart = [[UIView alloc] initWithFrame:CGRectZero];
	[viewDepart setTag:kTrainListCellTrainInfoDepartViewTag];
	
	// 子界面
	[self initCellTrainInfoDepartSubs:viewDepart];
	
	// 保存
	[viewParent addSubview:viewDepart];
    
    
    /* Arrive View */
	UIView *viewArrive = [[UIView alloc] initWithFrame:CGRectZero];
	[viewArrive setTag:kTrainListCellTrainInfoArriveViewTag];
	
	// 子界面
	[self initCellTrainInfoArriveSubs:viewArrive];
	
	// 保存
	[viewParent addSubview:viewArrive];
    
    
}

// 创建列车信息R2View的子界面
- (void)setupCellTrainInfoR2Subs:(UIView*)viewParent inSize:(CGSize *)pViewSize forTrain:(TrainTickets *)trainTickets
{
    // 子窗口高度
	NSInteger spaceXStart=0;
	NSInteger spaceXEnd = pViewSize->width;
	NSInteger spaceYStart = 0;
	
    
    // =======================================================================
	// depart View
	// =======================================================================
    CGSize viewDepartSize = CGSizeMake(spaceXEnd-spaceXStart, 0);
	if(viewParent != nil)
	{
		UIView *viewDepart = [viewParent viewWithTag:kTrainListCellTrainInfoDepartViewTag];
		[viewDepart setFrame:CGRectMake(spaceXStart, spaceYStart, viewDepartSize.width, viewDepartSize.height)];
		
		// 创建子界面
		[self setupCellTrainInfoDepartSubs:viewDepart inSize:&viewDepartSize forTrain:trainTickets];
	}
	else
	{
		[self setupCellTrainInfoDepartSubs:nil inSize:&viewDepartSize forTrain:trainTickets];
	}
    
    // 子窗口大小
	spaceYStart += viewDepartSize.height;
    
    // 间隔
    spaceYStart += kTrainListCellVMargin;
    
    // =======================================================================
	// arrive View
	// =======================================================================
    CGSize viewArriveSize = CGSizeMake(spaceXEnd-spaceXStart-kTrainListCellR2ViewMiddleHMargin, 0);
	if(viewParent != nil)
	{
		UIView *viewArrive = [viewParent viewWithTag:kTrainListCellTrainInfoArriveViewTag];
		[viewArrive setFrame:CGRectMake(spaceXStart, spaceYStart, viewArriveSize.width, viewArriveSize.height)];
		
		// 创建子界面
		[self setupCellTrainInfoArriveSubs:viewArrive inSize:&viewArriveSize forTrain:trainTickets];
	}
	else
	{
		[self setupCellTrainInfoArriveSubs:nil inSize:&viewArriveSize forTrain:trainTickets];
	}
    
    // 子窗口大小
	spaceYStart += viewArriveSize.height;
    
    // =======================================================================
	// 设置父窗口的尺寸
	// =======================================================================
	pViewSize->height = spaceYStart;
	if(viewParent != nil)
	{
		[viewParent setViewHeight:spaceYStart];
	}
    
    
}

// 初始化列车出发站信息子界面
- (void)initCellTrainInfoDepartSubs:(UIView*)viewParent
{
    // 始发站Icon
    UIImageView *departImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_originatingicon.png"]];
    [departImageView setBackgroundColor:[UIColor clearColor]];
    [departImageView setTag:kTrainListCellDepartIconTag];
    [viewParent addSubview:departImageView];
    
    // 到达时间
    UILabel *labelArriveTime = [[UILabel alloc] init];
    [labelArriveTime setBackgroundColor:[UIColor clearColor]];
	[labelArriveTime setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [labelArriveTime setTextColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]];
    [labelArriveTime setTag:kTrainListCellArriveTimeLabelTag];
    [labelArriveTime setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelArriveTime];
    
    
    // 出发站名
    UILabel *labelDepartStation = [[UILabel alloc] init];
    [labelDepartStation setBackgroundColor:[UIColor clearColor]];
	[labelDepartStation setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    [labelDepartStation setTextColor:[UIColor colorWithHex:0x767676 alpha:1.0]];
    [labelDepartStation setTag:kTrainListCellDepartStationLabelTag];
    [labelDepartStation setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelDepartStation];
    
    // 历时
    UILabel *labelDuration = [[UILabel alloc] init];
    [labelDuration setBackgroundColor:[UIColor clearColor]];
	[labelDuration setFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13.0f]];
    [labelDuration setTextColor:[UIColor colorWithHex:0x767676 alpha:1.0]];
    [labelDuration setTag:kTrainListCellDurationLabelTag];
    [labelDuration setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelDuration];
}

// 创建列车出发站信息子界面
- (void)setupCellTrainInfoDepartSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize forTrain:(TrainTickets *)trainTickets
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    NSInteger subsHeight = 0;
    
    // 间隔
    spaceYStart += kTrainListCellR2ViewMiddleVMargin;
    
    // =====================================================
    // 到达时间
    // =====================================================
    TrainArriveStation *arriveStation = [trainTickets arriveInfo];
    if (arriveStation != nil)
    {
        NSString *arriveTime = [arriveStation time];
        if (STRINGHASVALUE(arriveTime))
        {
            CGSize timeSize = [arriveTime sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]];
            
            // 创建Label
            if(viewParent != nil)
            {
                UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainListCellArriveTimeLabelTag];
                [labelTime setFrame:CGRectMake(spaceXStart, spaceYStart,
                                               timeSize.width, timeSize.height)];
                [labelTime setText:arriveTime];
                [labelTime setHidden:NO];
            }
            
            // 子窗口大小
            //spaceXStart += timeSize.width;
            if (timeSize.height > subsHeight)
            {
                subsHeight = timeSize.height;
            }
        }
        else
        {
            if(viewParent != nil)
            {
                UILabel *labelTime = (UILabel *)[viewParent viewWithTag:kTrainListCellArriveTimeLabelTag];
                [labelTime setHidden:YES];
            }
        }
    }
    
    // 出发站信息
    TrainDepartStation *departStation = [trainTickets departInfo];
    if (departStation != nil)
    {
        // =====================================================
        // 始发站Icon
        // =====================================================
        spaceXStart = (pViewSize->width/11)*3;
        
        NSString *isFirst = [departStation isFirst];
        if (STRINGHASVALUE(isFirst) && [isFirst isEqualToString:@"1"])
        {
            CGSize iconSize = CGSizeMake(kTrainListCellDepartIconWidth, kTrainListCellDepartIconHeight);
            
            if (viewParent != nil)
            {
                UIImageView *departImageView  = (UIImageView *)[viewParent viewWithTag:kTrainListCellDepartIconTag];
                [departImageView setFrame:CGRectMake(spaceXStart, kTrainListCellIconYMargin, iconSize.width, iconSize.height)];
                [departImageView setHidden:NO];
            }
            
            // 子窗口大小
            subsHeight = iconSize.height;
        }
        else
        {
            if(viewParent != nil)
            {
                UIImageView *departImageView  = (UIImageView *)[viewParent viewWithTag:kTrainListCellDepartIconTag];
                [departImageView setHidden:YES];
            }
        }
        
        // 子窗口大小
        spaceXStart += kTrainListCellDepartIconWidth;
        // 间隔
        spaceXStart += kTrainListCellMiddleHMargin;
        
        // =====================================================
        // 出发站名
        // =====================================================
        NSString *departName = [departStation name];
        
        if (STRINGHASVALUE(departName))
        {
            CGSize nameSize = [departName sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
            
            // 创建Label
            if(viewParent != nil)
            {
                UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainListCellDepartStationLabelTag];
                [labelName setFrame:CGRectMake(spaceXStart, spaceYStart,
                                               nameSize.width, nameSize.height)];
                [labelName setText:departName];
                [labelName setHidden:NO];
            }
            
            // 子窗口大小
            //spaceXStart += nameSize.width;
            if (nameSize.height > subsHeight)
            {
                subsHeight = nameSize.height;
            }
        }
        else
        {
            if(viewParent != nil)
            {
                UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainListCellDepartStationLabelTag];
                [labelName setHidden:YES];
            }
        }
        
        
        
        // =====================================================
        // 历时
        // =====================================================
        NSNumber *duration = [trainTickets duration];
        if (duration != nil)
        {
            NSString *durationText = [self getFormatDuration:duration];
            
            CGSize durationSize = [durationText sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Light" size:13.0f]];
            
            // 创建Label
            if(viewParent != nil)
            {
                UILabel *labelDuration = (UILabel *)[viewParent viewWithTag:kTrainListCellDurationLabelTag];
                [labelDuration setFrame:CGRectMake(spaceXEnd-durationSize.width, spaceYStart,
                                                   durationSize.width, durationSize.height)];
                [labelDuration setText:durationText];
                [labelDuration setHidden:NO];
            }
            
            // 子窗口大小
            if (durationSize.height > subsHeight)
            {
                subsHeight = durationSize.height;
            }
        }
        else
        {
            if (viewParent != nil)
            {
                UILabel *labelDuration = (UILabel *)[viewParent viewWithTag:kTrainListCellDurationLabelTag];
                [labelDuration setHidden:YES];
            }
        }
    }
    
    // 父窗口的宽度
    pViewSize->height  = subsHeight;
    if (viewParent != nil)
    {
        [viewParent setViewHeight:subsHeight];
    }
}


// 初始化列车到达站信息子界面
- (void)initCellTrainInfoArriveSubs:(UIView*)viewParent
{
    // 终点站Icon
    UIImageView *arriveImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_terminalicon.png"]];
    [arriveImageView setBackgroundColor:[UIColor clearColor]];
    [arriveImageView setTag:kTrainListCellArriveIconTag];
    
    [viewParent addSubview:arriveImageView];
    
    // 到达站名
    UILabel *labelArriveStation = [[UILabel alloc] init];
    [labelArriveStation setBackgroundColor:[UIColor clearColor]];
	[labelArriveStation setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [labelArriveStation setTextColor:[UIColor colorWithHex:0x767676 alpha:1.0]];
    [labelArriveStation setTag:kTrainListCellArriveStationLabelTag];
    [labelArriveStation setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelArriveStation];
    
    // 余票状态
    UILabel *labelYpMessage = [[UILabel alloc] init];
    [labelYpMessage setBackgroundColor:[UIColor clearColor]];
	[labelYpMessage setFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
    [labelYpMessage setTag:kTrainListCellYpMessageLabelTag];
    [labelYpMessage setTextAlignment:NSTextAlignmentCenter];
	[viewParent addSubview:labelYpMessage];
}

// 创建列车到达站信息子界面
- (void)setupCellTrainInfoArriveSubs:(UIView*)viewParent inSize:(CGSize *)pViewSize forTrain:(TrainTickets *)trainTickets
{
    // 子窗口高宽
    NSInteger spaceXStart = 0;
    NSInteger spaceXEnd = pViewSize->width;
    NSInteger spaceYStart = 0;
    NSInteger subsHeight = 0;
    
    // 间隔
    spaceYStart += kTrainListCellR2ViewMiddleVMargin;
    
    // 终点站信息
    TrainArriveStation *arriveStation = [trainTickets arriveInfo];
    if (arriveStation != nil)
    {
        // =====================================================
        // 终点站Icon
        // =====================================================
        spaceXStart = (pViewSize->width/11)*3;
        NSString *isLast = [arriveStation isLast];
        if (STRINGHASVALUE(isLast) && [isLast isEqualToString:@"1"])
        {
            CGSize iconSize = CGSizeMake(kTrainListCellDepartIconWidth, kTrainListCellDepartIconHeight);
            
            if (viewParent != nil)
            {
                UIImageView *arriveImageView  = (UIImageView *)[viewParent viewWithTag:kTrainListCellArriveIconTag];
                [arriveImageView setFrame:CGRectMake(spaceXStart, kTrainListCellIconYMargin, iconSize.width, iconSize.height)];
                [arriveImageView setHidden:NO];
            }
            
            // 子窗口大小
            subsHeight = iconSize.height;
            
        }
        else
        {
            if(viewParent != nil)
            {
                UIImageView *arriveImageView  = (UIImageView *)[viewParent viewWithTag:kTrainListCellArriveIconTag];
                [arriveImageView setHidden:YES];
            }
        }
        
        // 子窗口大小
        spaceXStart += kTrainListCellDepartIconWidth;
        // 间隔
        spaceXStart += kTrainListCellMiddleHMargin;
        
        // =====================================================
        // 到达站名
        // =====================================================
        NSString *arriveName = [arriveStation name];
        
        if (STRINGHASVALUE(arriveName))
        {
            CGSize nameSize = [arriveName sizeWithFont:[UIFont boldSystemFontOfSize:13.0f]];
            
            // 创建Label
            if(viewParent != nil)
            {
                UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainListCellArriveStationLabelTag];
                [labelName setFrame:CGRectMake(spaceXStart, spaceYStart,
                                               nameSize.width, nameSize.height)];
                [labelName setText:arriveName];
                [labelName setHidden:NO];
            }
            
            // 子窗口大小
            //spaceXStart += nameSize.width;
            if (nameSize.height > subsHeight)
            {
                subsHeight = nameSize.height;
            }
        }
        else
        {
            if(viewParent != nil)
            {
                UILabel *labelName = (UILabel *)[viewParent viewWithTag:kTrainListCellArriveStationLabelTag];
                [labelName setHidden:YES];
            }
        }
        
        
        
        
        // =====================================================
        // 票量信息
        // =====================================================
        NSString *ypMessage = [trainTickets ypMessage];
        if (STRINGHASVALUE(ypMessage))
        {
            CGSize ypSize = [ypMessage sizeWithFont:[UIFont fontWithName:@"STHeitiJ-Medium" size:13.0f]];
            
            // 创建Label
            if(viewParent != nil)
            {
                UILabel *labelYp = (UILabel *)[viewParent viewWithTag:kTrainListCellYpMessageLabelTag];
                [labelYp setFrame:CGRectMake(spaceXEnd-ypSize.width, spaceYStart,
                                                   ypSize.width, ypSize.height)];
                [labelYp setText:ypMessage];
                [labelYp setHidden:NO];
                // 余票状态
                NSNumber *ypCode = [trainTickets ypCode];
                if (ypCode != nil && [ypCode integerValue] == 1) // 余票紧张
                {
                    [labelYp setTextColor:RGBACOLOR(210, 70, 36, 1)];
                }
                else if (ypCode != nil && [ypCode integerValue] == 2) // 余票充足
                {
                    [labelYp setTextColor:RGBACOLOR(20, 157, 52, 1)];
                }
                else 
                {
                    [labelYp setTextColor:RGBACOLOR(108, 108, 108, 1)];
                }
                
            }
            
            // 子窗口大小
            if (ypSize.height > subsHeight)
            {
                subsHeight = ypSize.height;
            }
        }
        else
        {
            if (viewParent != nil)
            {
                UILabel *labelYp = (UILabel *)[viewParent viewWithTag:kTrainListCellYpMessageLabelTag];
                [labelYp setHidden:YES];
            }
        }
    }
    
    // 父窗口的宽度
    pViewSize->height  = subsHeight;
    if (viewParent != nil)
    {
        [viewParent setViewHeight:subsHeight];
    }
}

// 创建空View的子界面
- (void)setupCellEmptySubs:(UIView *)viewParent inSize:(CGSize *)pViewSize
{
    // =====================================================
    // 无结果提示
    // =====================================================
    NSString *noResultHint = @"未找到列车数据";
    CGSize noResultSize = [noResultHint sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]];
    
    if (viewParent != nil)
    {
        UILabel *labelNoResultHint = (UILabel *)[viewParent viewWithTag:kTrainListCellCellNoResultHintLabelTag];
        if (labelNoResultHint == nil)
        {
            labelNoResultHint = [[UILabel alloc] initWithFrame:CGRectZero];
            [labelNoResultHint setBackgroundColor:[UIColor clearColor]];
            [labelNoResultHint setText:noResultHint];
            [labelNoResultHint setFont:[UIFont boldSystemFontOfSize:16.0f]];
            [labelNoResultHint setTextColor:[UIColor colorWithHex:0x343434 alpha:1.0]];
            [labelNoResultHint setTextAlignment:UITextAlignmentCenter];
            [labelNoResultHint setTag:kTrainListCellCellNoResultHintLabelTag];
            
            // 保存
            [viewParent addSubview:labelNoResultHint];
        }
        [labelNoResultHint setFrame:CGRectMake((pViewSize->width-noResultSize.width)/2, (pViewSize->height-noResultSize.height)/2, noResultSize.width, noResultSize.height)];
        
    }
    
    
}


// =======================================================================
#pragma mark - TabelViewDataSource的代理函数
// =======================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrayTickets != nil && [_arrayTickets count] > 0)
    {
        return [_arrayTickets count];
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
    
    // 列车数据搜索
    if (_arrayTickets != nil && [_arrayTickets count] > 0)
    {
        if (row < [_arrayTickets count])
        {
            // 列车列表数据
            TrainTickets *trainTickets = [_arrayTickets objectAtIndex:row];
            
            if (trainTickets != nil)
            {
                NSString *reusedIdentifier = @"TrainSearchListTCID";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIdentifier];
                if(cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:reusedIdentifier];
                    
                    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
                    cell.selectedBackgroundView.backgroundColor = RGBACOLOR(237, 237, 237, 1);

                    
                    // 初始化contentView
                    [self initCellTrainInfoSubs:[cell contentView]];
                }
                
                
                // 创建contentView
                CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
                [[cell contentView] setFrame:CGRectMake(0, 0, contentViewSize.width, contentViewSize.height)];
                [self setupCellTrainInfoSubs:[cell contentView] inSize:&contentViewSize forTrain:trainTickets];
                
                return cell;
            }
        }
    }
    // 结果为空
    else
    {
        NSString *reusedIdentifier = @"TrainListEmptyTCID";
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
    if (_arrayTickets != nil && [_arrayTickets count] > 0)
    {
        if (row < [_arrayTickets count])
        {
            // 列车列表数据
            TrainTickets *trainTickets = [_arrayTickets objectAtIndex:row];
            
            if (trainTickets != nil)
            {
                CGSize contentViewSize = CGSizeMake(parentFrame.size.width, 0);
                [self setupCellTrainInfoSubs:nil inSize:&contentViewSize forTrain:trainTickets];
                
                return contentViewSize.height;
            }
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
    //
    if (_isDetailViewShow)
    {
        return;
    }
    
    NSUInteger row = [indexPath row];
    
    // 列车数据搜索
    if (row < [_arrayTickets count])
    {
        // 列车列表数据
        TrainTickets *trainTickets = [_arrayTickets objectAtIndex:row];
        
        if (trainTickets != nil)
        {
            // 添加出发日期
            [trainTickets setDepartDate:_departDate];
            
            // 进入列车详情
            TrainSearchDetailVC * trainDetailVC = [[TrainSearchDetailVC alloc] initWithTitle:nil];
            [self setTrainDetailVC:trainDetailVC];
            [_trainDetailVC setDelegate:self];
            [_trainDetailVC setWrapperId:[_trainListCur wrapperId]];
            [_trainDetailVC setBookStatus:[trainTickets ticketStatus]];
            [_trainDetailVC setListStatus:[_trainListCur bookStatus]];
            
            // 出发显示日期
            [trainTickets setDepartShowDate:_showDate];
            
            // 计算到达日期
            NSNumber *duration = [trainTickets duration];
            if (duration != nil)
            {
                [trainTickets setDurationShow:[self getFormatDuration:duration]];
                
                // 到达日期
                if (_mFormat == nil)
                {
                    _mFormat = [[NSDateFormatter alloc] init];
                    [_mFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                }
                NSString *departTime = [[trainTickets departInfo] time];
                if (STRINGHASVALUE(departTime))
                {
                    NSDate *arriveDateValue = [[NSDate alloc] initWithTimeInterval:[duration integerValue]*60 sinceDate:[_mFormat dateFromString:[NSString stringWithFormat:@"%@ %@",_departDate,departTime]]];
                    NSString *arriveDate = [_oFormat stringFromDate:arriveDateValue];
                    NSArray *dateCompents = [arriveDate componentsSeparatedByString:@"-"];
                    // 获取分段格式的日期
                    NSString *month	= [dateCompents safeObjectAtIndex:1];
                    NSString *day = [dateCompents safeObjectAtIndex:2];
                    
                    [trainTickets setArriveShowDate:[NSString stringWithFormat:@"%@月%@日",month,day]];
                }
            }
            [_trainDetailVC setTrainTickets:trainTickets];
            
            // 显示
            [_trainDetailVC show];
            
            if (UMENG) {
                // 查看车次详情，记录选择车次
                [MobClick event:Event_TrainDetail label:trainTickets.number];
            }
            
            UMENG_EVENT(UEvent_Train_List_DetailEnter)
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
